<#PSScriptInfo

.VERSION 1.0.1

.GUID a8d543c8-d93f-43ba-8f92-819a35ce44ac

.AUTHOR Daniel Scott-Raynsford

.COMPANYNAME

.COPYRIGHT (C) Daniel Scott-Raynsford. All rights reserved.

.TAGS DSC Docker Containers

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES

#>

<#
    .SYNOPSIS
    Installs Docker on a Windows Server 2016 server using DSC.
    .DESCRIPTION
    Installs Docker on a Windows Server 2016 server using DSC.

    This function will:
    1. Install the DSC Resource modules xPSDesiredStateConfiguration and xPendingReboot.
    2. Compile an LCM Meta Config to ensure the LCM is set correctly (allowing reboot etc).
    3. Apply the LCM Meta Config.
    4. Compile the DSC Configuration file (contained in a string) to a MOF.
    5. Apply the DSC Configuration MOF.

    Importantn note: This will not work on Nano Server. It is for Server Core and Server
    Core with GUI only.
    .PARAMETER ComputerName
    The name of the computer to install Docker on.
    If not set this will default to 'LocalHost'.
    If this is set to a computer other than the one running this script then the
    xPSDesiredStateConfiguration and xPendingReboot resource modules will need to be
    installed manually on the node.
    .PARAMETER DockerUri
    This is the URI to download the Docker engine zip file for Windows Server.
    If not provided it will default to:
    https://download.docker.com/components/engine/windows-server/cs-1.12/docker.zip
    .EXAMPLE
     Install-DockerOnWS2016UsingDSC.ps1
    This will install Docker onto the current node using DSC.
#>
[CmdletBinding()]
Param
(
    [String] $ComputerName = 'LocalHost',

    [String] $DockerUri = 'https://download.docker.com/components/engine/windows-server/cs-1.12/docker.zip'
)

$requiredModules = @(
    'xPSDesiredStateConfiguration'
    'xPendingReboot'
)
$exisingModules = Get-Module -ListAvailable

# Install the DSC resource modules required by the DSC Config
foreach ($module in $requiredModules) {
    if ($module -notin $exisingModules.Name) {
        Write-Verbose -Verbose -Message  "Installing DSC Resource module $module"
        Install-Module -Name $module -Force
    }
}

# The DSC Config is stored as a string, because otherwise an error
# will be thrown when the script is first run if any of the required
# DSC Resource modules are missing.
$dscConfig = @'
Configuration ContainerHostDsc
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    Import-DscResource -ModuleName xPendingReboot

    # Set up general parameters used to determine paths where Docker will
    # be installed to and downloaded from.
    $ProgramFiles = $ENV:ProgramFiles
    $DockerPath = Join-Path -Path $ProgramFiles -ChildPath 'Docker'
    $DockerZipFileName = 'docker.zip'
    $DockerZipPath = Join-Path -Path $ProgramFiles -ChildPath $DockerZipFilename
    $DockerUri = $ConfigurationData.NonNodeData.DockerUri

    Node $AllNodes.NodeName {

        # Install containers feature
        WindowsFeature ContainerInstall
        {
            Ensure = "Present"
            Name   = "Containers"
        }

        # Download Docker Engine
        xRemoteFile DockerEngineDownload
        {
            DestinationPath = $ProgramFiles
            Uri             = $DockerUri
            MatchSource     = $False
        }

        # Extract Docker Engine zip file
        xArchive DockerEngineExtract
        {
            Destination = $ProgramFiles
            Path        = $DockerZipPath
            Ensure      = 'Present'
            Validate    = $false
            Force       = $true
            DependsOn   = '[xRemoteFile]DockerEngineDownload'
        }

        # Add Docker to the Path
        xEnvironment DockerPath
        {
            Ensure    = 'Present'
            Name      = 'Path'
            Value     = $DockerPath
            Path      = $True
            DependsOn = '[xArchive]DockerEngineExtract'
        }

          # Reboot the system to complete Containers feature setup
        # Perform this after setting the Environment variable
        # so that PowerShell and other consoles can access it.
        xPendingReboot Reboot
        {
            Name = "Reboot After Containers"
        }

        # Install the Docker Daemon as a service
        Script DockerService
        {
            SetScript = {
                $DockerDPath = (Join-Path -Path $Using:DockerPath -ChildPath 'dockerd.exe')
                & $DockerDPath @('--register-service')
            }
            GetScript = {
                return @{
                    'Service' = (Get-Service -Name Docker).Name
                }
            }
            TestScript = {
                if (Get-Service -Name Docker -ErrorAction SilentlyContinue) {
                    return $True
                }
                return $False
            }
            DependsOn = '[xArchive]DockerEngineExtract'
        }

        # Start up the Docker Service and ensure it is set
        # to start up automatically.
        xServiceSet DockerService
        {
            Ensure      = 'Present'
            Name        = 'Docker'
            StartupType = 'Automatic'
            State       = 'Running'
            DependsOn   = '[Script]DockerService'
        }
    }
}
'@

# Create temporary workspace
$workspace = Join-Path -Path $ENV:TEMP -ChildPath ([System.IO.Path]::GetRandomFileName())
if (-not (Test-Path -Path $workspace)) {
    Write-Verbose -Verbose -Message  "Creating Temporary Workspace Folder $workspace"
    $null = New-Item -Path $workspace -ItemType Directory -Force
}

$dscConfigPath = Join-Path -Path $workspace -ChildPath 'ContainerHostDsc.ps1'
Set-Content -Path $dscConfigPath -Value $dscConfig -Force
. $dscConfigPath

# Configuration Data
$configData = @{
    AllNodes = @(
        @{
            NodeName = $ComputerName
        }
    )
    NonNodeData =
        @{
            DockerUri = $DockerUri
        }
}

# Configure the LCM
Configuration ConfigureLCM
{
   Node $AllNodes.NodeName {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
            RefreshMode        = 'Push'
            ConfigurationMode  = 'ApplyAndAutoCorrect'
            ActionAfterReboot  = 'ContinueConfiguration'
        }
    }
}

# Compile the LCM Config
Write-Verbose -Verbose -Message  "Compiling DSC LCM Meta Configuration"
ConfigureLCM `
    -OutputPath $workspace `
    -ConfigurationData $configData

# Apply the LCM Config
Write-Verbose -Verbose -Message  "Applying DSC LCM Meta Configuration"
Set-DscLocalConfigurationManager `
    -Path "$workspace" `
    -ComputerName $ComputerName `
    -Verbose

# Compile the Node Config
Write-Verbose -Verbose -Message  "Compiling DSC Configuration"
ContainerHostDsc `
    -OutputPath $workspace `
    -ConfigurationData $ConfigData

# Apply the DSC Configuration
Write-Verbose -Verbose -Message  "Applying DSC Configuration"
Start-DscConfiguration `
    -Path "$workspace" `
    -ComputerName $ComputerName `
    -Wait `
    -Force `
    -Verbose

# Clean up
Write-Verbose -Verbose -Message  "Removing Temporary Workspace Folder $workspace"
Remove-Item -Path $workspace -Recurse -Force

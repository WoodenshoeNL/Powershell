

$MachineName = "localhost"

#install DSC Modules
$requiredModules = @(
    'xPSDesiredStateConfiguration'
    'xPendingReboot'
)
$exisingModules = Get-Module -ListAvailable

foreach ($module in $requiredModules) {
    if ($module -notin $exisingModules.Name) {
        Write-Verbose -Verbose -Message  "Installing DSC Resource module $module"
        Install-Module -Name $module -Force
    }
}

Configuration ContainerBuild
{
  param ($MachineName)

  Import-DscResource -ModuleName PSDesiredStateConfiguration
  Import-DscResource -ModuleName xPSDesiredStateConfiguration
  Import-DscResource -ModuleName xPendingReboot

  Node $MachineName
  {
    


    $ProgramFiles = $ENV:ProgramFiles
    $DockerPath = Join-Path -Path $ProgramFiles -ChildPath 'Docker'
    $DockerZipPath = 'c:\install\docker.zip'
    
    #Install the Container Role
    WindowsFeature ContainerInstall
    {
        Ensure = "Present"
        Name   = "Containers"
    }

    # Download Docker Engine
    #xRemoteFile DockerEngineDownload
    #{
    #    DestinationPath = $ProgramFiles
    #    Uri             = $DockerUri
    #    MatchSource     = $False
    #}

    # Extract Docker Engine zip file
    Archive DockerEngineExtract
    {
        Destination = $ProgramFiles
        Path        = $DockerZipPath
        Ensure      = 'Present'
        Validate    = $false
        Force       = $true
    }

    # Add Docker to the Path
    Environment DockerPath
    {
        Ensure    = 'Present'
        Name      = 'Path'
        Value     = $DockerPath
        Path      = $True
        DependsOn = '[Archive]DockerEngineExtract'
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
            $DockerDPath = (Join-Path -Path $DockerPath -ChildPath 'dockerd.exe')
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
        DependsOn = '[Archive]DockerEngineExtract'
    }

    # Start up the Docker Service and ensure it is set
    # to start up automatically.
    ServiceSet DockerService
    {
        Ensure      = 'Present'
        Name        = 'Docker'
        StartupType = 'Automatic'
        State       = 'Running'
        DependsOn   = '[Script]DockerService'
    }


  }
} 
    
ContainerBuild -OutputPath d:\ -MachineName $MachineName
    
Start-DscConfiguration -Path d:\ -verbose

Start-Sleep 3
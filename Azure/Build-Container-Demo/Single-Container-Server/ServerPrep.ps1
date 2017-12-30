
#Install Providers
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force


#install DSC Modules
$requiredModules = @(
    'xPSDesiredStateConfiguration'
)
$exisingModules = Get-Module -ListAvailable

foreach ($module in $requiredModules) {
    if ($module -notin $exisingModules.Name) {
        Write-Verbose -Verbose -Message  "Installing DSC Resource module $module"
        Install-Module -Name $module -Force
    }
}


Configuration PrepConfig {
    
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    
    Node "localhost" {
        
        File InstallDir {
            DestinationPath = "c:\install"
            Type = "Directory" 
            Ensure = "Present"   
        }
    
        File ScriptDir {
            DestinationPath = "c:\install\script"
            Type = "Directory" 
            Ensure = "Present"  
            DependsOn = "[File]InstallDir"
        }

        File DockerDir {
            DestinationPath = "C:\Program Files\Docker"
            Type = "Directory" 
            Ensure = "Present"  
        }

        Environment addPath
        {
            Ensure    = 'Present'
            Name      = 'Path'
            Value     = '%programfiles%\Docker;%programfiles%\Git\bin\git'
            Path      = $True
            DependsOn = "[File]DockerDir"
        }

        WindowsFeature ContainerInstall
        {
            Ensure = "Present"
            Name   = "Containers"
        }
    }
}
    
PrepConfig -OutputPath d:\
    
Start-DscConfiguration -Path d:\

Start-Sleep 30

#cleanup MOF file
Remove-Item d:\localhost.mof -force

#Download Files
(New-Object System.Net.WebClient).DownloadFile('https://github.com/git-for-windows/git/releases/download/v2.15.1.windows.2/Git-2.15.1.2-64-bit.exe', 'c:\install\Git-2.15.1.2-64-bit.exe')
(New-Object System.Net.WebClient).DownloadFile('https://download.docker.com/win/static/stable/x86_64/docker-17.09.0-ce.zip', 'c:\install\docker.zip')


#Extract Files
Expand-Archive c:\install\docker.zip -DestinationPath 'C:\Program Files' -Force

#Install Software
#Git Installatie
c:\install\Git-2.15.1.2-64-bit.exe /SILENT /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"

#Docker service geregistreerd
& "C:\Program Files\Docker\dockerd.exe" --register-service

Start-Sleep 30

#Git Clone Powershell script GitHub
& "C:\Program Files\Git\bin\git" clone https://github.com/WoodenshoeNL/Powershell c:\install\script

#Log time
Set-Content -Path "d:\DSC-test.log" -Value $(get-date)

#Restart voor het afronden Container en Docker install
Restart-Computer -Force
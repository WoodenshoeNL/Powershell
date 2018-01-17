
#Install Providers
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force


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

        Environment addPath
        {
            Ensure    = 'Present'
            Name      = 'Path'
            Value     = '%programfiles%\Git\bin\git'
            Path      = $True
            DependsOn = "[File]DockerDir"
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


#Git Installatie
c:\install\Git-2.15.1.2-64-bit.exe /SILENT /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"

#Git Clone Powershell script GitHub
& "C:\Program Files\Git\bin\git" clone https://github.com/WoodenshoeNL/Powershell c:\install\script


#Log time
Set-Content -Path "d:\DSC-test.log" -Value $(get-date)


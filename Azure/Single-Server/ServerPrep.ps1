
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
    }
}
    
PrepConfig -OutputPath d:\
    
Start-DscConfiguration -Path d:\

Start-Sleep 30

#cleanup MOF file
Remove-Item d:\localhost.mof -force

#Download Files
(New-Object System.Net.WebClient).DownloadFile('https://github.com/git-for-windows/git/releases/download/v2.15.1.windows.2/Git-2.15.1.2-64-bit.exe', 'c:\install\Git-2.15.1.2-64-bit.exe')
#(New-Object System.Net.WebClient).DownloadFile('https://download.docker.com/win/static/stable/x86_64/docker-17.09.0-ce.zip', 'c:\install\docker.zip')


#Extract Files
#Expand-Archive c:\install\docker.zip -DestinationPath 'C:\Program Files'

#Install Software
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
. { Invoke-WebRequest -useb http://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression 
get-boxstarter -Force


#Log time
Set-Content -Path "d:\DSC-test.log" -Value $(get-date)


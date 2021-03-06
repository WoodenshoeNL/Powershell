
#Boxstarter Prep

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
. { Invoke-WebRequest -useb http://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression 
get-boxstarter -Force

choco feature enable --name=allowGlobalConfirmation

Import-Module Boxstarter.Chocolatey

#start Boxstarter

Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar

Set-TaskbarOptions -Lock -Dock Bottom

#cinst Microsoft-Hyper-V-All -source windowsFeatures

cinst notepadplusplus
cinst 7zip
cinst GoogleChrome
cinst Firefox
cinst visualstudiocode
cinst google-backup-and-sync
cinst evernote
cinst vlc
cinst f.lux --ignorechecksum
cinst gitkraken
cinst passwordsafe
cinst spotify
cinst sumatrapdf
cinst autohotkey
cinst greenshot
cinst pester
cinst powershell-core
cinst git
cinst microsoft-teams
cinst steam


Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module AzureRM -Force -AllowClobber
Install-Module AzureAD -Force -AllowClobber
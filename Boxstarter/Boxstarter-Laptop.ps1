
#Boxstarter Prep

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
. { Invoke-WebRequest -useb http://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression 
get-boxstarter -Force

choco feature enable --name=allowGlobalConfirmation

Import-Module Boxstarter.Chocolatey

#start Boxstarter

Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar

Set-TaskbarOptions -Lock -Dock Bottom

cinst Microsoft-Hyper-V-All -source windowsFeatures

#cinst chocolatey
cinst notepadplusplus
cinst 7zip
cinst GoogleChrome
cinst Firefox
#cinst dotnet3.5
cinst visualstudiocode
cinst googledrive
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
cinst windowsazurepowershell
cinst steam


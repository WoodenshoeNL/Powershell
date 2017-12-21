#Create Directorie
New-Item -Path c:\install -ItemType directory
New-Item -Path c:\install\script -ItemType directory

#Install Providers
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

<#
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
#>

#Download Files
#(New-Object System.Net.WebClient).DownloadFile('https://github.com/git-for-windows/git/releases/download/v2.15.1.windows.2/Git-2.15.1.2-64-bit.exe', 'c:\install\Git-2.15.1.2-64-bit.exe')
#(New-Object System.Net.WebClient).DownloadFile('https://download.docker.com/components/engine/windows-server/cs-1.12/docker.zip', 'c:\install\docker..zip')


#Extract Files


#Install Software



#Log time
Set-Content -Path "c:\install\DSC-test.log" -Value $(get-date)


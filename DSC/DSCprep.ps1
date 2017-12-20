
#Install NuGet PackageProvider pre-req xDSC

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force



$log = Join-Path -Path $ENV:TEMP -ChildPath "DSC-test.log"
Set-Content -Path $log -Value $(get-date)
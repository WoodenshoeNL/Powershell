
New-Item -Path c:\install -ItemType directory

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force


Set-Content -Path "c:\install\DSC-test.log" -Value $(get-date)


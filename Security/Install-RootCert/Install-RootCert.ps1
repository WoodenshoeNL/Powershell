
$certPath = "C:\script\Install-RootCert\certnew.p7b"
Import-Certificate -FilePath $certpath 

get-childitem Cert:\LocalMachine\Root\ | Where-Object {$_.subject -match "winvision"}

Start-Sleep 5
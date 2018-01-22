
$hostname = $([System.Net.Dns]::GetHostByName(($env:computerName))).hostname

#copy agent files
$remotepath = "\\tsclient\C\Operations Manager\Agent_2016"
$path = "C:\Install"

Copy-Item $remotepath $path -Recurse -Force

#import Root Certs

$certPath = "C:\Install\Agent_2016\certnew.p7b"
Import-Certificate -FilePath $certpath -CertStoreLocation Cert:\LocalMachine\Root

#Install Computer Cert
if(Test-Path "C:\Install\Agent_2016\Cert\$hostname.pfx" )
{
    $mypwd = Get-Credential -UserName 'Enter password below' -Message 'Enter password below'
    Import-PfxCertificate -FilePath "C:\Install\Agent_2016\Cert\$hostname.pfx" -CertStoreLocation Cert:\LocalMachine\My -Password $mypwd.Password 
}

#Start CertImport
& "C:\Install\Agent_2016\SupportTools\AMD64\MOMCertImport.exe /subjectname $hostname"
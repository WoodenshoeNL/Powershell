
$hostname = $([System.Net.Dns]::GetHostByName(($env:computerName))).hostname

if(Test-Path "C:\Install\Agent_2016\Cert\$hostname.pfx" )
{
    $mypwd = Get-Credential -UserName 'Enter password below' -Message 'Enter password below'
    Import-PfxCertificate -FilePath "C:\Install\Agent_2016\Cert\$hostname.pfx" -CertStoreLocation Cert:\LocalMachine\My -Password $mypwd.Password 
}


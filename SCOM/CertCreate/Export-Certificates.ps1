
$mypwd = Get-Credential -UserName 'Enter password below' -Message 'Enter password below'

foreach($cert in $(Get-ChildItem -Path cert:\CurrentUser\my))
{
    $cert | Export-PfxCertificate -FilePath "\\tsclient\C\Operations Manager\Agent_2016\Cert\$($cert.FriendlyName).pfx" -Password $mypwd.Password
}


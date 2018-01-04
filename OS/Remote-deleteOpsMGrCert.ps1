


foreach($server in $(get-content .\servers.txt) )
{
    Invoke-Command -ComputerName $server -ScriptBlock {
        Remove-ItemProperty -Name 'ChannelCertificateSerialNumber' -Path 'HKLM:\\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Machine Settings';
        Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Issuer -match 'OpsMgrCA' } | Remove-Item
    }
}
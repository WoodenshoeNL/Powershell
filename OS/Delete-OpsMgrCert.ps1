#delete Reg Key

Remove-ItemProperty -Name 'ChannelCertificateSerialNumber' -Path 'HKLM:\\SOFTWARE\Microsoft\Microsoft Operations Manager\3.0\Machine Settings'

#Delete Cert

Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Issuer -match 'OpsMgrCA' } | Remove-Item
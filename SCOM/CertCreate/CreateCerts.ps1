

foreach($server in $(get-content .\servers.txt) )
{
    $server
    .\Request-Certificate.ps1 -CN $server -TemplateName "Web Server Exportable PK" -CAName "mgmt-pki02.management.int"  -Export
    Move-Item -path ".\$server.pfx" -Destination "\\tsclient\C\Operations Manager\Agent_2016\Cert\"
}

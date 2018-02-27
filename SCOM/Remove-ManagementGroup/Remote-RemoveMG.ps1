$servers = @("server1",
"server2",
"server3",
"Server4")

#$servers = get-content .\server.txt

foreach($server in $servers)
{
    Invoke-Command -ComputerName $Server -FilePath ".\Remove-MG.ps1"
}

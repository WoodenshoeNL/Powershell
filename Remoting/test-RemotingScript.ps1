
$list = @("server1",
"server2",
"server3",
"Server4")

foreach($server in $list)
{
    Invoke-Command -ComputerName $Server -FilePath ".\Test-Script.ps1"
}




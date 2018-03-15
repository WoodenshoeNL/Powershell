$servers = get-content .\server.txt

foreach($server in $servers)
{
    Invoke-Command -ComputerName $Server -FilePath ".\Add-MG.ps1"
}

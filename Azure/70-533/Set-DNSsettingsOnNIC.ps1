$nic = Get-AzureRmNetworkInterface `
            -ResourceGroupName "ExamRefRG" `
            -Name "examrefwebvm172"
$nic.DnsSettings.DnsServers.Clear()
$nic.DnsSettings.DnsServers.Add("8.8.8.8")
$nic.DnsSettings.DnsServers.Add("4.2.2.1")
$nic | Set-AzureRmNetworkInterface 
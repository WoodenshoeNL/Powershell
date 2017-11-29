
$ResourceGroupName = "Azure-Test"
$InterfaceName = "ServerInterface01"



$nic = Get-AzureRmNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName
$nic.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
$nic.IpConfigurations[0].PrivateIpAddress = "10.77.1.101"
Set-AzureRmNetworkInterface -NetworkInterface $nic

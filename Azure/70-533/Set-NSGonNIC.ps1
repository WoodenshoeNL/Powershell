#Associate the Rule with the NIC from ExamRefWEBVM1
$nic = Get-AzureRmNetworkInterface -ResourceGroupName ExamRefRGPS -Name examrefwebvm1892
$nic.NetworkSecurityGroup = $nsg
Set-AzureRmNetworkInterface -NetworkInterface $nic
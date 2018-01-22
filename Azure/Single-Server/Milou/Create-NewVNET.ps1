
$ResourceGroupName = "Milou"
$Location = "WestEurope"


$SubnetName = "SubnetMilou"
$VNetName = "VNetMilou"
$VNetAddressPrefix = "10.177.0.0/16"
$VNetSubnetAddressPrefix = "10.177.1.0/24"




$SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $VNetSubnetAddressPrefix
$VNet = New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Location $Location -AddressPrefix $VNetAddressPrefix -Subnet $SubnetConfig
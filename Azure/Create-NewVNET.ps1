
$ResourceGroupName = "Azure-Test"
$Location = "WestEurope"


$SubnetName = "Subnet1"
$VNetName = "VNet01"
$VNetAddressPrefix = "10.77.0.0/16"
$VNetSubnetAddressPrefix = "10.77.1.0/24"




$SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $VNetSubnetAddressPrefix
$VNet = New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Location $Location -AddressPrefix $VNetAddressPrefix -Subnet $SubnetConfig
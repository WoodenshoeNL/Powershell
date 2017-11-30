
$ResourceGroupName = "Azure-Test"
$Location = "WestEurope"

$VNetName = "VNet01"
$SubnetName = "Subnet1"

$NSGname = "Test-NSG"



$rule1 = New-AzureRmNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" `
-Access Allow -Protocol Tcp -Direction Inbound -Priority 100 `
-SourceAddressPrefix Internet -SourcePortRange * `
-DestinationAddressPrefix * -DestinationPortRange 3389

$rule2 = New-AzureRmNetworkSecurityRuleConfig -Name web-rule -Description "Allow HTTP" `
-Access Allow -Protocol Tcp -Direction Inbound -Priority 101 `
-SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * `
-DestinationPortRange 80


$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Location $Location `
-Name $NSGname -SecurityRules $rule1,$rule2


#$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $VNetName
#Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $SubnetName -NetworkSecurityGroup $nsg


#Set-AzureRmVirtualNetwork -VirtualNetwork $vnet
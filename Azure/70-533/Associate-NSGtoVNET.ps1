#Associate the Rule with the Subnet Apps in the Virtual Network ExamRefVNET-PS
$vnet = Get-AzureRmVirtualNetwork –ResourceGroupName ExamRefRGPS –Name ExamRefVNET-PS

Set-AzureRmVirtualNetworkSubnetConfig –VirtualNetwork $vnet `
                                      -Name Apps `
                                      -AddressPrefix 10.0.0.0/24 `
                                      -NetworkSecurityGroup $nsg
Set-AzureRmVirtualNetwork –VirtualNetwork $vnet
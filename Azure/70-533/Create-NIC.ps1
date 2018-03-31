

$nicName    = "ExamRefVM-NIC"
$nic = New-AzureRmNetworkInterface -Name $nicName `
                                 -ResourceGroupName $rgName `
                                 -Location $location `
                                 -SubnetId $vnet.Subnets[0].Id `
                                 -PublicIpAddressId $pip.Id `
                                 -NetworkSecurityGroupId $nsg.ID
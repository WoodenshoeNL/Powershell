

# Add a rule to the network security group to allow RDP in
$nsgRules = @()
$nsgRules += New-AzureRmNetworkSecurityRuleConfig -Name "RDP" `
                                     -Description "RemoteDesktop" `
                                     -Protocol Tcp `
                                     -SourcePortRange "*" `
                                     -DestinationPortRange "3389" `
                                     -SourceAddressPrefix "*" `
                                     -DestinationAddressPrefix "*" `
                                     -Access Allow `
                                     -Priority 110 `
                                     -Direction Inbound 


                                     
$nsgName    = "ExamRefNSG"
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName `
                                -Name $nsgName `
                                -SecurityRules $nsgRules `
                                -Location $location
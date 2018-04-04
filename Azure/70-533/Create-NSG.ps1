#Build a new Inbound Rule to Allow TCP Traffic on Port 80 to the Subnet
$rule1 = New-AzureRmNetworkSecurityRuleConfig –Name PORT_HTTP_80 `
                                              -Description "Allow HTTP" `
                                              -Access Allow `
                                              -Protocol Tcp `
                                              -Direction Inbound `
                                              -Priority 100 `
                                              -SourceAddressPrefix * `
                                              -SourcePortRange * `
                                              -DestinationAddressPrefix 10.0.0.0/24 `
                                              -DestinationPortRange 80
$nsg = New-AzureRmNetworkSecurityGroup –ResourceGroupName ExamRefRGPS `
                                       -Location centralus `
                                       -Name "AppsNSG" `
                                       -SecurityRules $rule1
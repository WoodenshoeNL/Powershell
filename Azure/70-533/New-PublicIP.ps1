$pip = New-AzureRmPublicIpAddress -Name $ipName `
                                -ResourceGroupName $rgName `
                                -Location $location `
                                -AllocationMethod Dynamic `
                                -DomainNameLabel $dnsName 
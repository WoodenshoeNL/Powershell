$vmSize     = "Standard_DS1_V2"
$vm = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize `
                          -AvailabilitySetId $avSet.Id


$cred = Get-Credential  #local admin account
Set-AzureRmVMOperatingSystem -Windows `
                             -ComputerName $vmName `
                             -Credential $cred `
                             -ProvisionVMAgent `
                             -VM $vm 
                             

$pubName    = "MicrosoftWindowsServer"
$offerName  = "WindowsServer"
$skuName    = "2016-Datacenter"
Set-AzureRmVMSourceImage -PublisherName $pubName `
                         -Offer $offerName `
                         -Skus $skuName `
                         -Version "latest" `
                         -VM $vm
$osDiskName = "ExamRefVM-osdisk"
$osDiskUri    = $blobEndpoint + "vhds/" + $osDiskName  + ".vhd"
Set-AzureRmVMOSDisk -Name $osDiskName `
                    -VhdUri $osDiskUri `
                    -CreateOption fromImage `
                    -VM $vm

New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $vm
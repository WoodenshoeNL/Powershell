
#variable
$ResourceGroupName = "Azure-Test"
$Location = "WestEurope"


$VMName = "VM-P-Test002"
$VMSize = "Standard_DS1_v2"    #Get-AzureRmVMSize -Location "WestEurope"

$ComputerName = $VMName
$OSDiskName = $VMName
$InterfaceName = $VMName

$VNetName = "VNet01"
$StorageAccountName = "woodenshoeteststorage01"


#network
$VNet = get-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName
$NSG = Get-AzureRmNetworkSecurityGroup -Name "Test-NSG" -ResourceGroupName "Azure-Test"
$Interface = New-AzureRmNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location `-SubnetId $VNet.Subnets[0].Id -DnsServer "8.8.8.8", "8.8.4.4" -PrivateIpAddress "10.77.1.101" -NetworkSecurityGroupId $NSG.Id


#Disk

$StorageAccount = get-azurermstorageaccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName

$diskSize = '40'
$OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $OSDiskName + ".vhd"
$accountType = 'PremiumLRS'
$diskConfig = New-AzureRmDiskConfig -AccountType $accountType -DiskSizeGB $diskSize -SourceUri $OSDiskUri -CreateOption Import -OsType Windows -Location $Location

#Create Managed disk
New-AzureRmDisk -DiskName $OSDiskName -Disk $diskConfig -ResourceGroupName $ResourceGroupName 


$OSdisk =  Get-AzureRmDisk -ResourceGroupName $resourceGroupName -DiskName $OSDiskName



#create VM Object
$Credential = Get-Credential
$VirtualMachine = New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent #-EnableAutoUpdate
$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version "latest"
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $Interface.Id
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -ManagedDiskId $OSdisk.Id -CreateOption Attach -Windows


#create VM
New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VirtualMachine

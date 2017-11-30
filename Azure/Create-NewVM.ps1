## Global
$ResourceGroupName = "Azure-Test"
$Location = "WestEurope"


## Network
$InterfaceName = "ServerInterface01"

## Compute
$VMName = "VM-P-Test001"
$ComputerName = "VM-P-Test001"
$VMSize = "Standard_A2"
$OSDiskName = $VMName


# Storage
$StorageAccount = get-azurermstorageaccount #New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageName -Type $StorageType -Location $Location

#Network
$VNet = get-AzureRmVirtualNetwork

$Interface = New-AzureRmNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -SubnetId $VNet.Subnets[0].Id -DnsServer "8.8.8.8", "8.8.4.4" -PrivateIpAddress "10.77.1.101"

# Compute

## Setup local VM object
$Credential = Get-Credential
$VirtualMachine = New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent #-EnableAutoUpdate
$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version "latest"
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $Interface.Id
$OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/" + $OSDiskName + ".vhd"
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $OSDiskName -VhdUri $OSDiskUri -CreateOption FromImage

## Create the VM in Azure
New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VirtualMachine







<#

PS C:\Users\michel.klomp> Get-AzureRmVMImageSku
cmdlet Get-AzureRmVMImageSku at command pipeline position 1
Supply values for the following parameters:
Location: WestEurope
PublisherName: MicrosoftWindowsServer
Offer: WindowsServer

Skus                                  Offer         PublisherName          Location   Id                                                    
----                                  -----         -------------          --------   --                                                    
2008-R2-SP1                           WindowsServer MicrosoftWindowsServer westeurope /Subscriptions/b2f81635-ee4b-4cac-8610-3569594a6484...
2008-R2-SP1-smalldisk                 WindowsServer MicrosoftWindowsServer westeurope /Subscriptions/b2f81635-ee4b-4cac-8610-3569594a6484...
2012-Datacenter                       WindowsServer MicrosoftWindowsServer westeurope /Subscriptions/b2f81635-ee4b-4cac-8610-3569594a6484...
2012-Datacenter-smalldisk             WindowsServer MicrosoftWindowsServer westeurope /Subscriptions/b2f81635-ee4b-4cac-8610-3569594a6484...
2012-R2-Datacenter                    WindowsServer MicrosoftWindowsServer westeurope /Subscriptions/b2f81635-ee4b-4cac-8610-3569594a6484...
2012-R2-Datacenter-smalldisk          WindowsServer MicrosoftWindowsServer westeurope /Subscriptions/b2f81635-ee4b-4cac-8610-3569594a6484...
2016-Datacenter                       WindowsServer MicrosoftWindowsServer westeurope /Subscriptions/b2f81635-ee4b-4cac-8610-3569594a6484...
2016-Datacenter-Server-Core           WindowsServer MicrosoftWindowsServer westeurope /Subscriptions/b2f81635-ee4b-4cac-8610-3569594a6484...
2016-Datacenter-Server-Core-smalldisk WindowsServer MicrosoftWindowsServer westeurope /Subscriptions/b2f81635-ee4b-4cac-8610-3569594a6484...
2016-Datacenter-smalldisk             WindowsServer MicrosoftWindowsServer westeurope /Subscriptions/b2f81635-ee4b-4cac-8610-3569594a6484...
2016-Datacenter-with-Containers       WindowsServer MicrosoftWindowsServer westeurope /Subscriptions/b2f81635-ee4b-4cac-8610-3569594a6484...
2016-Datacenter-with-RDSH             WindowsServer MicrosoftWindowsServer westeurope /Subscriptions/b2f81635-ee4b-4cac-8610-3569594a6484...
2016-Nano-Server                      WindowsServer MicrosoftWindowsServer westeurope /Subscriptions/b2f81635-ee4b-4cac-8610-3569594a6484...

#>


$subscriptionId = "b2f81635-ee4b-4cac-8610-3569594a6484"
$resourceGroupName = "TestManagedDisk"
$resourceGroupName2 = "TestManagedDisk2"
$NetworkresourceGroupName = "Azure-Test"
$Location = "westeurope"
$deploymentName = "Test-ManagedDiskDeployment"
$templateFilePath = "template.json"
$parametersFilePath = "parameters.json"

$VMname = "VM-DiskTest001"
$virtualNetworkName = "VNet01"

$storageType = "PremiumLRS"
$virtualMachineSize = "Standard_D2s_v3"

$ErrorActionPreference = "Stop"

#Login-AzureRmAccount;


New-AzureRmResourceGroup -Name $resourceGroupName -Location $Location
New-AzureRmResourceGroup -Name $resourceGroupName2 -Location $Location


New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath -Verbose;

Write-Host "VM Deployment compleet" -ForegroundColor "DarkYellow"

#Stop VM
Stop-AzureRmVM -ResourceGroupName $resourceGroupName -Name $VMname -Force

#Create managed disks snapshots

$VM = Get-AzureRmVM -ResourceGroupName $resourceGroupName -Name $VMname

$disk = Get-AzureRmDisk -ResourceGroupName $resourceGroupName | Where-Object{$_.ManagedBy -eq $VM.Id}

$snapshotName = 'ManagedDiskSnapshot'
$snapshotConfig =  New-AzureRmSnapshotConfig -SourceUri $disk.Id -CreateOption Copy -Location $location -AccountType $storageType
$snapshot = New-AzureRmSnapshot -Snapshot $snapshotConfig -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName

#Create new managed disks from snapshots in the new Resource Group

$osDiskName = $disk.name #+ "_n"


#$snapshot = Get-AzureRmSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $snapshotName 

$diskConfig = New-AzureRmDiskConfig -AccountType $storageType -Location $snapshot.Location -SourceResourceId $snapshot.Id -CreateOption Copy

$disk = New-AzureRmDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName2 -DiskName $osDiskName


$virtualMachineName = $VMname.ToString()

#Deploy new vm using using managed disks in the new Resource Group

$VirtualMachine = New-AzureRmVMConfig -VMName $virtualMachineName -VMSize $($virtualMachineSize).ToString()
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -ManagedDiskId $disk.Id -CreateOption Attach -Windows

$vnet = Get-AzureRmVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $NetworkresourceGroupName


$nic = New-AzureRmNetworkInterface -Name ($VirtualMachineName.ToLower()+'_nic') -ResourceGroupName $resourceGroupName2 -Location $snapshot.Location -SubnetId $vnet.Subnets[0].Id #-PublicIpAddressId $publicIp.Id

$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $nic.Id

New-AzureRmVM -VM $VirtualMachine -ResourceGroupName $resourceGroupName2 -Location $snapshot.Location

$VM = Get-AzureRmVM -ResourceGroupName $resourceGroupName -Name $virtualMachineName
Set-AzureRmVMBootDiagnostics -vm $VM -Enable -ResourceGroupName "TestServer" -StorageAccountName "azuretestdiagdisk001"






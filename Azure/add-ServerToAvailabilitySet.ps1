
Write-Host "[^] Script Start - $(Get-Date)" -ForegroundColor "Darkgreen"
#####Set Variable
$VMname = "VM-T-2"

$virtualMachineSize = "Standard_DS2_v2"
$resourceGroupName = "RG-T"
$BootDiagResourceGroupName = "RG-T"
$BootDiagAccount = "diagstorageaccount"
$Location = "westeurope"
$storageType = "PremiumLRS"
$AvailabilitySetName = "HA-T"

$snapshotName = "ManagedDiskSnapshot_$VMname"

#Login-AzureRmAccount;

#####Get Disk
$disk = Get-AzureRmDisk -ResourceGroupName $resourceGroupName | Where-Object{$_.ManagedBy -match $VMname}
$osDiskName = $disk.name

#####Stop VM
Write-Host "[->] Stop VM - $vmname" -ForegroundColor "DarkGreen"
Stop-AzureRmVM -ResourceGroupName $resourceGroupName -Name $VMname -Force

#####Create managed disks snapshots
Write-Host "[->] Create Snapshot" -ForegroundColor "DarkGreen"
$snapshotConfig =  New-AzureRmSnapshotConfig -SourceUri $disk.Id -CreateOption Copy -Location $location -AccountType $storageType
$snapshot = New-AzureRmSnapshot -Snapshot $snapshotConfig -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName

#####Delete VM
Write-Host "[->] Remove VM" -ForegroundColor "DarkGreen"
Remove-AzureRmVM -ResourceGroupName $resourceGroupName -Name $VMname -Force

#####Create Managed Disk
Write-Host "[->] Create Managed Disk in Resource Group: $resourceGroupName" -ForegroundColor "DarkGreen"
$diskConfig = New-AzureRmDiskConfig -AccountType $storageType -Location $snapshot.Location -SourceResourceId $snapshot.Id -CreateOption Copy
$disk = New-AzureRmDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName -DiskName "$osDiskName-n"

#####Deploy new vm in Availability set
$virtualMachineName = $VMname.ToString()
Write-Host "[->] Create VM($virtualMachineName) in Resource Group: $resourceGroupName en Availability Set: $AvailabilitySetName " -ForegroundColor "DarkGreen"
$AvailabilitySet = Get-AzureRmAvailabilitySet -ResourceGroupName $resourceGroupName -Name $AvailabilitySetName
$nic = Get-AzureRmNetworkInterface -ResourceGroupName $resourceGroupName | Where-Object{$_.Name -match $VMname}

$VirtualMachine = New-AzureRmVMConfig -VMName $virtualMachineName -VMSize $($virtualMachineSize).ToString() -AvailabilitySetID $AvailabilitySet.Id
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -ManagedDiskId $disk.Id -CreateOption Attach -Windows
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $nic.Id
Set-AzureRmVMBootDiagnostics -vm $VirtualMachine -Enable -ResourceGroupName $BootDiagResourceGroupName -StorageAccountName $BootDiagAccount
New-AzureRmVM -VM $VirtualMachine -ResourceGroupName $resourceGroupName -Location $Location

Write-Host "[$] Script Finished - $(Get-Date)" -ForegroundColor "Darkgreen"
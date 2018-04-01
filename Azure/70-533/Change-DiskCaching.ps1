$rgName = "StorageRG"
$vmName = "StandardVM"
$vm = Get-AzureRmVM -ResourceGroupName $rgName -Name $vmName
Set-AzureRmVMDataDisk -VM $vm -Lun 0 -Caching ReadOnly 
Update-AzureRmVM -ResourceGroupName $rgName -VM $vm
# Deallocate the VM 
$rgName = "Contoso"
$vmName = "ImageVM"
Stop-AzureRmVM -ResourceGroupName $rgName -Name $vmName 
# Set the status of the virtual machine to Generalized
Set-AzureRmVm -ResourceGroupName $rgName -Name $vmName -Generalized 
# Create a managed VM from a VM 
$imageName = "WinVMImage"
$vm = Get-AzureRmVM -ResourceGroupName $rgName -Name $vmName
$image = New-AzureRmImageConfig -Location $location -SourceVirtualMachineId $vm.ID 
New-AzureRmImage -Image $image -ImageName $imageName -ResourceGroupName $rgName
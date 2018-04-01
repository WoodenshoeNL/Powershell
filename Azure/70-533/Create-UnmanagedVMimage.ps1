# Deallocate the VM 
$rgName = "Contoso"
$vmName = "ImageVM"
Stop-AzureRmVM -ResourceGroupName $rgName -Name $vmName 
# Set the status of the virtual machine to Generalized
Set-AzureRmVm -ResourceGroupName $rgName -Name $vmName -Generalized 

$containerName = "vmimage"
$vhdPrefix     = "img"
$localPath     = "C:\Local\ImageConfig"
Save-AzureRmVMImage -ResourceGroupName $rgName -Name $vmName `
    -DestinationContainerName $containerName -VHDNamePrefix $vhdPrefix `
    -Path $localPath  
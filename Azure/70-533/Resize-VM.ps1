# View available sizes 
$location = "WestUS"
Get-AzureRmVMSize -Location $location 


#resize VM
$rgName = "EXAMREGWEBRG"
$vmName = "Web1"
$size = "Standard_DS2_V2"
$vm = Get-AzureRmVM -ResourceGroupName $rgName -VMName $vmName
$vm.HardwareProfile.VmSize = $size
Update-AzureRmVM -VM $vm -ResourceGroupName $rgName
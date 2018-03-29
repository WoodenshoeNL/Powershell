
$vm = "test-server"
$ResourceGroup = "RG-Test"

$virtualMachine = Get-AzureRMVM -Name $vm -ResourceGroupName $ResourceGroup

$virtualMachine.StorageProfile.DataDisks[0].DiskSizeGB

$virtualMachine.StorageProfile.DataDisks[0].DiskSizeGB = 300
Update-AzureRmVM -VM $virtualMachine -ResourceGroupName $ResourceGroup
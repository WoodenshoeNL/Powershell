
$vms = get-azurermvm
$nics = get-azurermnetworkinterface | where VirtualMachine -NE $null #skip Nics with no VM

foreach($nic in $nics)
{
    $vm = $vms | where-object -Property Id -EQ $nic.VirtualMachine.id
    $DNSservers =  $nic.DnsSettings | select-object -ExpandProperty DnsServers
    Write-Output "$($vm.Name) : $DNSservers"
}
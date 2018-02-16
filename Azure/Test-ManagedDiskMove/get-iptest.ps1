
$VMname = "VM-DiskTest001"

$nics = get-azurermnetworkinterface 
foreach($nic in $nics)
{
    if($nic.virtualmachine.Id -match $VMname){
        $IPaddress =  $nic.IpConfigurations | select-object -ExpandProperty PrivateIpAddress
        $DNSservers = $nic.DnsSettings | select-object -ExpandProperty DnsServers
        $DNSservers
    }
} 
$IPaddress
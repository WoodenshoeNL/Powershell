# Properties for the traffic manager profile
$resourceGroupName = "WebApp"
$tmName = "Woodenshoe-public"
$tmDnsName = "Woodenshoe-public-tm"
$ttl = 300
$monitorProtocol = "TCP"
$monitorPort = 80

# Create the traffic manager profile
New-AzureRmTrafficManagerProfile -ResourceGroupName $resourceGroupName -Name $tmName `
    -RelativeDnsName $tmDnsName -Ttl $ttl -TrafficRoutingMethod Performance `
    -MonitorProtocol $monitorProtocol -MonitorPort $monitorPort 
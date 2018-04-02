# Create a virtual machine scale set with IIS installed from a custom script extension 
$rgName       = "ExamRefRGPS"
$location     = "WestUS"
$vmSize       = "Standard_DS2_V2"
$capacity     = 2

New-AzureRmResourceGroup -Name $rgName -Location $location 

# Create a config object
$vmssConfig = New-AzureRmVmssConfig `
    -Location $location `
    -SkuCapacity $capacity `
    -SkuName $vmSize `
    -UpgradePolicyMode Automatic 

# Define the script for your Custom Script Extension to run
$publicSettings = @{
    "fileUris" = (,"https://raw.githubusercontent.com/opsgility/lab-support-public/master/script-extensions/install-iis.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File install-iis.ps1"
}

# Use Custom Script Extension to install IIS and configure basic website
Add-AzureRmVmssExtension -VirtualMachineScaleSet $vmssConfig `
    -Name "customScript" `
    -Publisher "Microsoft.Compute" `
    -Type "CustomScriptExtension" `
    -TypeHandlerVersion 1.8 `
    -Setting $publicSettings
$publicIPName = "vmssIP"

# Create a public IP address
$publicIP = New-AzureRmPublicIpAddress `
  -ResourceGroupName $rgName  `
  -Location $location `
  -AllocationMethod Static `
  -Name $publicIPName

# Create a frontend and backend IP pool
$frontEndPoolName = "lbFrontEndPool"
$backendPoolName = "lbBackEndPool"
$frontendIP = New-AzureRmLoadBalancerFrontendIpConfig `
  -Name $frontEndPoolName `
  -PublicIpAddress $publicIP
$backendPool = New-AzureRmLoadBalancerBackendAddressPoolConfig -Name $backendPoolName

# Create the load balancer
$lbName = "vmsslb"
$lb = New-AzureRmLoadBalancer `
  -ResourceGroupName $rgName  `
  -Name $lbName `
  -Location $location `
  -FrontendIpConfiguration $frontendIP `
  -BackendAddressPool $backendPool

# Create a load balancer health probe on port 80
$probeName = "lbprobe"
Add-AzureRmLoadBalancerProbeConfig -Name $probeName `
  -LoadBalancer $lb `
  -Protocol tcp `
  -Port 80 `
  -IntervalInSeconds 15 `
  -ProbeCount 2 `
  -RequestPath "/"
# Create a load balancer rule to distribute traffic on port 80
Add-AzureRmLoadBalancerRuleConfig `
  -Name "lbrule" `
  -LoadBalancer $lb `
  -FrontendIpConfiguration $lb.FrontendIpConfigurations[0] `
  -BackendAddressPool $lb.BackendAddressPools[0] `
  -Protocol Tcp `
  -FrontendPort 80 `
  -BackendPort 80

# Update the load balancer configuration
Set-AzureRmLoadBalancer -LoadBalancer $lb

# Reference a virtual machine image from the gallery
Set-AzureRmVmssStorageProfile $vmssConfig `
  -ImageReferencePublisher MicrosoftWindowsServer `
  -ImageReferenceOffer WindowsServer `
  -ImageReferenceSku 2016-Datacenter `
  -ImageReferenceVersion latest

# Set up information for authenticating with the virtual machine
$userName = "azureuser"
$password = "P@ssword!"
$vmPrefix = "ssVM"
Set-AzureRmVmssOsProfile $vmssConfig `
  -AdminUsername $userName `
  -AdminPassword $password `
  -ComputerNamePrefix $vmPrefix 

# Create the virtual network resources
$subnetName = "web"
$subnet = New-AzureRmVirtualNetworkSubnetConfig `
  -Name $subnetName `
  -AddressPrefix 10.0.0.0/24
$ssName = "vmssVNET"
$subnetPrefix = "10.0.0.0/16"
$vnet = New-AzureRmVirtualNetwork `
  -ResourceGroupName $rgName `
  -Name $ssName `
  -Location $location  `
  -AddressPrefix $subnetPrefix `
  -Subnet $subnet
$ipConfig = New-AzureRmVmssIpConfig `
  -Name "vmssIPConfig" `
  -LoadBalancerBackendAddressPoolsId $lb.BackendAddressPools[0].Id `
  -SubnetId $vnet.Subnets[0].Id

# Attach the virtual network to the config object
$netConfigName = "network-config" 
Add-AzureRmVmssNetworkInterfaceConfiguration `
  -VirtualMachineScaleSet $vmssConfig `
  -Name $netConfigName `
  -Primary $true `
  -IPConfiguration $ipConfig
$scaleSetName = "erscaleset"
# Create the scale set with the config object (this step might take a few minutes)
New-AzureRmVmss `
  -ResourceGroupName $rgName `
  -Name $scaleSetName `
  -VirtualMachineScaleSet $vmssConfig 
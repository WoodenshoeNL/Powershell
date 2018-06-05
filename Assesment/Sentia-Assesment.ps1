#Parameters & Variablelen
Param(
    $ResourceGroupName = "Sentia"
 )

$resourceGroupLocation = "westeurope"
$storageAccountPrefix = "sentia"

$VNetName = "SentiaVNet01"
$VNetAddressPrefix = "172.16.0.0/12"

$SubnetName1 = "SentiaSubnet1"
$SubnetAddressPrefix1 = "172.16.1.0/24"

$SubnetName2 = "SentiaSubnet2"
$SubnetAddressPrefix2 = "172.16.2.0/24"

$SubnetName3 = "SentiaSubnet3"
$SubnetAddressPrefix3 = "172.16.3.0/24"


#uniqeu string Function - zoals ARM uniqueString() 
function Get-UniqueString ([string]$id, $length=13)
{
    $hashArray = (new-object System.Security.Cryptography.SHA512Managed).ComputeHash($id.ToCharArray())
    -join ($hashArray[1..$length] | ForEach-Object { [char]($_ % 26 + [byte][char]'a') })
}


#aanmaken Resource Group
$resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    New-AzureRmResourceGroup -Name $ResourceGroupName -Location $resourceGroupLocation
}


#Storage Account aanmaken
$suffixLength = 24 - $storageAccountPrefix.Length
$storageAccountName =  $storageAccountPrefix + $(Get-UniqueString -id $(Get-AzureRmResourceGroup $ResourceGroupName).ResourceID -length $suffixLength)

$storageAccount = Get-AzureRmStorageAccount -Name $storageAccountName -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue
if(!$storageAccount)
{
    New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName `
        -Name $storageAccountName `
        -Location $resourceGroupLocation `
        -SkuName Standard_LRS `
        -Kind Storage `
        -EnableEncryptionService Blob
}


#Create VNET
$VNET = Get-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue
if(!$VNET)
{
    $SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName1 -AddressPrefix $SubnetAddressPrefix1
    $VNET = New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Location $resourceGroupLocation -AddressPrefix $VNetAddressPrefix -Subnet $SubnetConfig

    Add-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName2 -VirtualNetwork $VNET -AddressPrefix $SubnetAddressPrefix2
    Add-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName3 -VirtualNetwork $VNET -AddressPrefix $SubnetAddressPrefix3
    $VNET | Set-AzureRmVirtualNetwork

}


#Apply Tag to Resource Group
Set-AzureRmResourceGroup -Name $ResourceGroupName -Tag @{Environment='Test';Company='Sentia'}


#Create Policy Definition
$policy = New-AzureRmPolicyDefinition -Name "OnlyAllow3Types" `
                                    -DisplayName "Allowed Type Definitions" `
                                    -description "Policy Description" `
                                    -Policy ".\policy.json" `
                                    -Mode All



#Assign Policy to Resource Group
$resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName
New-AzureRMPolicyAssignment -Name "Allowed resource types - RG" `
                                        -Scope $resourceGroup.ResourceId  `
                                        -PolicyDefinition $policy


#Assign Policy to Subscription
$subscription = Get-AzureRmSubscription
$subResourceId = "/subscriptions/{0}" -f $subscription.SubscriptionId
New-AzureRMPolicyAssignment -Name "Allowed resource types - Subscription" `
                                        -Scope $subResourceId `
                                        -PolicyDefinition $policy





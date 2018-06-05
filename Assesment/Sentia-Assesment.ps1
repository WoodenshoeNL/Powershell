#Parameters & Variablelen
Param(
    $ResourceGroupName = "Sentia",
    $resourceGroupLocation = "westeurope",
    $storageAccountPrefix = "sentia",
    $numberOfSubnets = 3
)


$VNetName = "SentiaVNet01"
$VNetAddressPrefix = "172.16.0.0/12"

$SubnetNamePrefix = "SentiaSubnet"
$SubnetAddressPrefixPrefix = "172.16."


#uniqeu string Function - zoals ARM uniqueString() 
function Get-UniqueString ([string]$id, $length = 13) {
    $hashArray = (new-object System.Security.Cryptography.SHA512Managed).ComputeHash($id.ToCharArray())
    -join ($hashArray[1..$length] | ForEach-Object { [char]($_ % 26 + [byte][char]'a') })
}


#aanmaken Resource Group
$resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $ResourceGroupName -Location $resourceGroupLocation
}


#Storage Account aanmaken
$suffixLength = 24 - $storageAccountPrefix.Length
$storageAccountName = $($storageAccountPrefix + $(Get-UniqueString -id $(Get-AzureRmResourceGroup $ResourceGroupName).ResourceID -length $suffixLength)).ToLower()

$storageAccount = Get-AzureRmStorageAccount -Name $storageAccountName -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue
if (!$storageAccount) {
    New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName `
        -Name $storageAccountName `
        -Location $resourceGroupLocation `
        -SkuName Standard_LRS `
        -Kind Storage `
        -EnableEncryptionService Blob
}


#Create VNET
$VNET = Get-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue
if (!$VNET) {
    $SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $($SubnetNamePrefix + "1") -AddressPrefix $($SubnetAddressPrefixPrefix + "1.0/24")
    $VNET = New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Location $resourceGroupLocation -AddressPrefix $VNetAddressPrefix -Subnet $SubnetConfig

    if ($numberOfSubnets -gt 1){
        foreach($subnetNumber in 2..$numberOfSubnets){
            Add-AzureRmVirtualNetworkSubnetConfig -Name  $($SubnetNamePrefix + $subnetNumber) `
                    -VirtualNetwork $VNET -AddressPrefix $($SubnetAddressPrefixPrefix + $subnetNumber + ".0/24")
        }
        $VNET | Set-AzureRmVirtualNetwork
    }
}


#Apply Tag to Resource Group
Set-AzureRmResourceGroup -Name $ResourceGroupName -Tag @{Environment = 'Test'; Company = 'Sentia'}


#Test of Policy File aanwezig is.
if (Test-Path ".\policy.json" ) {
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
}
else {
    Write-Host "[*] policy.json file is niet aanwezig in de script directory" -ForegroundColor "DarkRed"
}




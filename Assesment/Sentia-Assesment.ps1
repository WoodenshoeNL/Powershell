#Parameters & Variablelen
Param(
    [string]$ResourceGroupName = "Sentia",
    [string]$resourceGroupLocation = "westeurope",
    [string]$storageAccountPrefix = "sentia",
    [int]$numberOfSubnets = 3,
    [switch]$VerboseOutput
)


$VNetName = "SentiaVNet01"
$VNetAddressPrefix = "172.16.0.0/12"

$SubnetNamePrefix = "SentiaSubnet"
$SubnetAddressPrefixPrefix = "172.16."

Write-Host "[*] Start Script" -ForegroundColor "White"
#uniqeu string Function - zoals ARM uniqueString() 
function Get-UniqueString ([string]$id, $length = 13) {
    $hashArray = (new-object System.Security.Cryptography.SHA512Managed).ComputeHash($id.ToCharArray())
    -join ($hashArray[1..$length] | ForEach-Object { [char]($_ % 26 + [byte][char]'a') })
}


#aanmaken Resource Group
$resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    Write-Host "[*] Create Resource Group" -ForegroundColor "White"
    $output = New-AzureRmResourceGroup -Name $ResourceGroupName -Location $resourceGroupLocation
    if($VerboseOutput){
        $output
    }
}


#Storage Account aanmaken
$suffixLength = 24 - $storageAccountPrefix.Length
$storageAccountName = $($storageAccountPrefix + $(Get-UniqueString -id $(Get-AzureRmResourceGroup $ResourceGroupName).ResourceID -length $suffixLength)).ToLower()

$storageAccount = Get-AzureRmStorageAccount -Name $storageAccountName -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue
if (!$storageAccount) {
    Write-Host "[*] Create Storage Account" -ForegroundColor "White"
    $output = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName `
            -Name $storageAccountName `
            -Location $resourceGroupLocation `
            -SkuName Standard_LRS `
            -Kind Storage `
            -EnableEncryptionService Blob
    if($VerboseOutput){
        $output
    }
}


#Create VNET
$VNET = Get-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue
if (!$VNET) {
    Write-Host "[*] Create VNet + Subnet 1" -ForegroundColor "White"
    $SubnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $($SubnetNamePrefix + "1") -AddressPrefix $($SubnetAddressPrefixPrefix + "1.0/24")
    $VNET = New-AzureRmVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Location $resourceGroupLocation -AddressPrefix $VNetAddressPrefix -Subnet $SubnetConfig

    if ($numberOfSubnets -gt 1){
        foreach($subnetNumber in 2..$numberOfSubnets){
            Write-Host "[*] Create Subnet $subnetNumber" -ForegroundColor "White"
            $output = Add-AzureRmVirtualNetworkSubnetConfig -Name  $($SubnetNamePrefix + $subnetNumber) `
                        -VirtualNetwork $VNET -AddressPrefix $($SubnetAddressPrefixPrefix + $subnetNumber + ".0/24")
            if($VerboseOutput){
                $output
            }
        }
        $output = $VNET | Set-AzureRmVirtualNetwork
        if($VerboseOutput){
            $output
        }
    }
}


#Apply Tag to Resource Group
Write-Host "[*] Set Tag" -ForegroundColor "White"
$output = Set-AzureRmResourceGroup -Name $ResourceGroupName -Tag @{Environment = 'Test'; Company = 'Sentia'}
if($VerboseOutput){
    $output
}


#Test of Policy File aanwezig is.
if (Test-Path ".\policy.json" ) {
    #Create Policy Definition
    Write-Host "[*] Create Policy Definition" -ForegroundColor "White"
    $policy = New-AzureRmPolicyDefinition -Name "OnlyAllow3Types" `
        -DisplayName "Allowed Type Definitions" `
        -description "Policy Description" `
        -Policy ".\policy.json" `
        -Mode All



    #Assign Policy to Resource Group
    Write-Host "[*] Assign Policy to Resource Group" -ForegroundColor "White"
    $resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName
    $output = New-AzureRMPolicyAssignment -Name "Allowed resource types - RG" `
                -Scope $resourceGroup.ResourceId  `
                -PolicyDefinition $policy
    if($VerboseOutput){
        $output
    }

    #Assign Policy to Subscription
    Write-Host "[*] Assign Policy to Subscription" -ForegroundColor "White"
    $subscription = Get-AzureRmSubscription
    $subResourceId = "/subscriptions/{0}" -f $subscription.SubscriptionId
    $output = New-AzureRMPolicyAssignment -Name "Allowed resource types - Subscription" `
                -Scope $subResourceId `
                -PolicyDefinition $policy
    if($VerboseOutput){
        $output
    }
}
else {
    Write-Host "[*] policy.json file is niet aanwezig in de script directory" -ForegroundColor "DarkRed"
}

Write-Host "[*] Script Finished" -ForegroundColor "White"


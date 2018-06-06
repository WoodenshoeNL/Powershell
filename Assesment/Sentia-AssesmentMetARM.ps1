#Parameters & Variablelen
Param(
    [string]$ResourceGroupName = "Sentia",
    [string]$resourceGroupLocation = "westeurope",
    [string]$storageAccountPrefix = "sentia",
    [int]$numberOfSubnets = 3,
    [switch]$VerboseOutput
)

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


Write-Host "[*] Start ARM Deployment Storage Account & VNet" -ForegroundColor "White"
New-AzureRmResourceGroupDeployment -TemplateParameterFile ".\Parameter.json" -TemplateFile ".\Template.json" -ResourceGroupName $ResourceGroupName -Verbose


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


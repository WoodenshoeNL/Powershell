#Parameters & Variablelen
Param(
    $ResourceGroupName = "Sentia"
 
)

$resourceGroupLocation = "westeurope"


#aanmaken Resource Group

$resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    New-AzureRmResourceGroup -Name $ResourceGroupName -Location $resourceGroupLocation
}



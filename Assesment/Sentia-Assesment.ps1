#Parameters & Variablelen
Param(
    $ResourceGroupName = "Sentia"
 
)

$resourceGroupLocation = "westeurope"

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





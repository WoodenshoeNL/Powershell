

$subscriptionId = "b2f81635-ee4b-4cac-8610-3569594a6484"
$resourceGroupName = "TestManagedDisk"
$resourceGroupName2 = "TestManagedDisk2"
$Location = "westeurope"
$deploymentName = "Test-ManagedDiskDeployment"
$templateFilePath = "template.json"
$parametersFilePath = "parameters.json"

$ErrorActionPreference = "Stop"

#Login-AzureRmAccount;


New-AzureRmResourceGroup -Name $resourceGroupName -Location $Location
New-AzureRmResourceGroup -Name $resourceGroupName2 -Location $Location


New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath -Verbose;


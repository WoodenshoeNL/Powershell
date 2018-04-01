# Create a Resource Group
$rgName   = "Contoso"
$location = "WestUs"
New-AzureRmResourceGroup -Name $rgName -Location $location

# Deploy a Template from GitHub 
$deploymentName = "simpleVMDeployment"

$templateUri = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-vm-simple-windows/azuredeploy.json"
New-AzureRmResourceGroupDeployment -Name $deploymentName `
                                   -ResourceGroupName $rgName `
                                   -TemplateUri $templateUri
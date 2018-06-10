$resourceGroupName="lab1"
$templateFilePath="C:\GIT\Powershell\Azure\Citadel\Lab5\azuredeploy.json"
$parametersFilePath="C:\GIT\Powershell\Azure\Citadel\Lab5\azuredeploy.parameters.json"

New-AzureRmResourceGroupDeployment -TemplateParameterFile $parametersFilePath -TemplateFile $templateFilePath -ResourceGroupName $resourceGroupName -Verbose
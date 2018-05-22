$resourceGroupName="lab1"
$templateFilePath="C:\GIT\Powershell\Azure\Citadel\linux\azuredeploy.json"
$parametersFilePath="C:\GIT\Powershell\Azure\Citadel\Linux\azuredeploy.parameters.json"

New-AzureRmResourceGroupDeployment -TemplateParameterFile $parametersFilePath -TemplateFile $templateFilePath -ResourceGroupName $resourceGroupName -Verbose
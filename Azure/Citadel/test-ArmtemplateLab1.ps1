$rg="lab1"
$template="C:\GIT\Powershell\Azure\Citadel\azuredeploy.json"

$storageAccount="citadelsa"
test-AzureRmResourceGroupDeployment -storageAccountPrefix $storageAccount -TemplateFile $template -ResourceGroupName $rg
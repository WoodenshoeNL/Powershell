$rg="lab1"
$template="C:\GIT\Powershell\Azure\Citadel\azuredeploy.json"
$job="job2"
$storageAccount="citadelsa"
New-AzureRmResourceGroupDeployment -Name $job -storageAccountPrefix $storageAccount -TemplateFile $template -ResourceGroupName $rg
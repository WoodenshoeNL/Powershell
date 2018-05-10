$rg="lab1"
$template="C:\GIT\Powershell\Azure\Citadel\azuredeploy.json"
$parms="C:\GIT\Powershell\Azure\Citadel\azuredeploy.parameter.json"
$job="job2"
$storageAccount="citadelsa"
New-AzureRmResourceGroupDeployment -Name $job -storageAccountPrefix $storageAccount -TemplateParameterFile $parms -TemplateFile $template -ResourceGroupName $rg
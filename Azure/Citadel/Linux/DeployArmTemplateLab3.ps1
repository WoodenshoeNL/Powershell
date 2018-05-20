$rg="lab1"
$template="C:\GIT\Powershell\Azure\Citadel\linux\azuredeploy.json"
$parms="C:\GIT\Powershell\Azure\Citadel\linux\azuredeploy.parameter.json"
$job="job3"
$storageAccount="citadelsa"
New-AzureRmResourceGroupDeployment -Name $job -storageAccountPrefix $storageAccount -TemplateParameterFile $parms -TemplateFile $template -ResourceGroupName $rg
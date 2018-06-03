$rg="lab1"
$template="C:\GIT\Powershell\Azure\Citadel\Lab6\noresources.json"
$job="job2"

New-AzureRmResourceGroupDeployment -Name $job -TemplateFile $template -ResourceGroupName $rg
$resourceGroupName = "WebApp"
$appServicePlanName = "WebAppPlan"
$location = "WestEurope"
$webAppName = "woodenshoe-test-web-app"

New-AzureRmWebApp -ResourceGroupName $resourceGroupName -Location $location `
 -AppServicePlan $appServicePlanName -Name $webAppName
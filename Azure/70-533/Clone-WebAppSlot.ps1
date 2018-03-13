$resourceGroupName = "WebApp"
$appServicePlanName = "WebAppPlan"
$location = "WestEurope"
$webAppName = "woodenshoe-test-web-app"
$stagingSlotName = "Dev"
$productionSlotName = "Production" 


# Get a reference to the production deployment slot
$productionSite = Get-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName `
    -Name $webAppName -Slot $productionSlotName

# Create a deployment slot that clones the production deployment slot settings
New-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName `
    -Name $webAppName -Slot $stagingSlotName `
    -AppServicePlan $appServicePlanName -SourceWebApp $productionSite 
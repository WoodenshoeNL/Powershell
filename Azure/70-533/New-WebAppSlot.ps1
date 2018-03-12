$resourceGroupName = "WebApp"

$location = "WestEurope"
$webAppName = "woodenshoe-test-web-app"
$stagingSlotName = "Dev"

New-AzureRmWebAppSlot -ResourceGroupName $resourceGroupName `
    -Name $webAppName -Slot $stagingSlotName 
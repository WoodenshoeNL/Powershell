$resourceGroupName = "WebApp"
$location = "WestEurope"
$webAppName = "woodenshoe-test-web-app"

# Get a reference to an existing web app
$webApp = Get-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName

# Configure diagnostic logging
Set-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName `
    -RequestTracingEnabled $true -HttpLoggingEnabled $true 
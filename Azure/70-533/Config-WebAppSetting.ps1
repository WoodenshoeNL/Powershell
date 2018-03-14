$resourceGroupName = "WebApp"
$location = "WestEurope"
$webAppName = "woodenshoe-test-web-app"

# Get current app settings
$webApp = Get-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName
$settings = $webApp.SiteConfig.AppSettings

# Add new settings to the current set of settings
$newSettings = New-Object Hashtable
$newSettings["setting1"] = "value-1"
$newSettings["setting2"] = "value-2"
foreach ($setting in $settings) {
    $newSettings.Add($setting.Name, $setting.Value)
}

# Apply the new app settings to the web app
Set-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $webAppName -AppSettings $newSettings 
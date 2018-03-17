$webAppName = "woodenshoe-test-web-app"

#Streaming Web Server Logs
Get-AzureWebsiteLog -Name $webAppName -Tail -Path http

#Streaming App log Error messages
Get-AzureWebsiteLog -Name $webAppName -Tail -Message Error

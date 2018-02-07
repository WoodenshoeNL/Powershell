$webhookurl = 'https://s2events.azure-automation.net/webhooks?token=[secrettoken]'

$params = @{
    ContentType = 'application/json'
    Method = 'Post'
    URI = $webhookurl
}

Invoke-RestMethod @params -Verbose
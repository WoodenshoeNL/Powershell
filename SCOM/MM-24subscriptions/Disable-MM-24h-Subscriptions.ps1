
#Get-SCOMNotificationSubscription | ?{$_.DisplayName -match "24h"}  | Select-object DisplayName

$subscriptions = get-content -Path .\subscriptions.txt

foreach($subscription in $subscriptions)
{
    $subscription
    Get-SCOMNotificationSubscription $subscription | Disable-SCOMNotificationSubscription
}
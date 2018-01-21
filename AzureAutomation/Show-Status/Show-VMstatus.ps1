$ResourceGroupName = "Script"
$AutomationAccount = "Script-AA"

$VerbosePreference = "Continue"

#Write-Verbose "[*] Logging in to Azure"

#$connectionName = "AzureRunAsConnection"
#$servicePrincipalConnection = Get-AutomationConnection -Name $connectionName
#Add-AzureRmAccount -ServicePrincipal -TenantId $servicePrincipalConnection.TenantId -ApplicationId $servicePrincipalConnection.ApplicationId -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint


$cred = get-automationpscredentials 



Get-AzureRmVM
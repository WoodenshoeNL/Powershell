
$ResourceGroupName = "Azure-Test"
$Location = "WestEurope"
$AutomationAccount = "Test-AA"


#get-command -Module AzureRM New-AzureRmAutomation* 

New-AzureRmAutomationVariable -Name "Max-Age" -Description "Max age for logfiles" -Encrypted $false -Value 2 -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount

$Credential = Get-Credential -Message 'Enter Credentials'

New-AzureRmAutomationCredential -Name "Test-Login-Creds" -Description "Test Credentials" -Value $Credential -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount



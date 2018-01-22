
$ResourceGroupName = "Milou"
$Location = "WestEurope"
$AutomationAccount = "Milou-AA"


#get-command -Module AzureRM New-AzureRmAutomation* 

#New-AzureRmAutomationVariable -Name "Max-Age" -Description "Max age for logfiles" -Encrypted $false -Value 2 -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount

$Credential = Get-Credential -Message 'Enter Credentials'

New-AzureRmAutomationCredential -Name "Script-Milou" -Description "Run As account Milou-AA" -Value $Credential -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccount



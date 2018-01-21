

$ResourceGroupName = "Script"
$Location = "WestEurope"


New-AzureRmAutomationAccount -Name "Script-AA" -ResourceGroupName $ResourceGroupName -Location $Location

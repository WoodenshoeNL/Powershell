

$ResourceGroupName = "Milou"
$Location = "WestEurope"


New-AzureRmAutomationAccount -Name "Milou-AA" -ResourceGroupName $ResourceGroupName -Location $Location

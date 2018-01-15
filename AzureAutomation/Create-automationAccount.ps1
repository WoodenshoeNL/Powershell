

$ResourceGroupName = "Azure-Test"
$Location = "WestEurope"


New-AzureRmAutomationAccount -Name "Test-AA" -ResourceGroupName $ResourceGroupName -Location $Location

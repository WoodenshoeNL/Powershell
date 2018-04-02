# Create an availability set 
 
$rgName    = "ExamRefRG"
$avSetName = "WebAVSet"
$location  = "West US"
New-AzureRmAvailabilitySet -ResourceGroupName $rgName `
                           -Name $avSetName `
                           -Location $location `
                           -PlatformUpdateDomainCount 10 `
                           -PlatformFaultDomainCount 3 `
                           -Sku "Aligned"
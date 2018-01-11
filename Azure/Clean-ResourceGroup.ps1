
$resourceGroupName = "TestServer"


get-azurermvm -ResourceGroupName $resourceGroupName | stop-azurermvm -Force
get-azurermvm -ResourceGroupName $resourceGroupName | remove-azurermvm -Force

Get-AzureRmDisk -ResourceGroupName $resourceGroupName | Remove-AzureRmDisk -Force

Get-AzureRmNetworkInterface -ResourceGroupName $resourceGroupName | Remove-AzureRmNetworkInterface -Force

Get-AzureRmPublicIpAddress -ResourceGroupName $resourceGroupName | Remove-AzureRmPublicIpAddress -Force



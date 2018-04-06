# Resource lock properties 
$lockName = "devGroupNoDeleteLock"
$resourceGroupName = "Dev"

# Create a CanNotDelete resource lock for the resource group (ie: all resources in the resource group)
New-AzureRmResourceLock -LockName $lockName -LockLevel CanNotDelete '
    -ResourceGroupName $resourceGroupName  
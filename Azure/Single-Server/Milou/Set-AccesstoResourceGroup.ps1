
$resourceGroupName = "Milou"

New-AzureRmRoleAssignment -SignInName "<User>" -RoleDefinitionName "Contributor" -ResourceGroupName $resourceGroupName



$roleName = "Contributor"
$assigneeName = "cawatson@microsoft.com"
$resourceGroupName = "contoso-app"

New-AzureRmRoleAssignment -RoleDefinitionName $roleName -SignInName $assigneeName -ResourceGroupName $resourceGroupName 
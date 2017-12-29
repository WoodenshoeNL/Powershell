

"Servernaam;PreMaintenanceWindowStartTime;PreMaintenanceWindowEndTime;MaintenanceWindowStartTime"

foreach ($server in $(Get-AzureRmVM))
{
    #$server.name
    $vmstatus = get-azurermvm -name $server.name -status -resourcegroupname $server.ResourceGroupName
    #$($vmstatus.MaintenanceRedeployStatus).PreMaintenanceWindowStartTime
    #$($vmstatus.MaintenanceRedeployStatus).MaintenanceWindowStartTime
    "$($server.name);$($($vmstatus.MaintenanceRedeployStatus).PreMaintenanceWindowStartTime);$($($vmstatus.MaintenanceRedeployStatus).PreMaintenanceWindowEndTime);$($($vmstatus.MaintenanceRedeployStatus).MaintenanceWindowStartTime)"
}
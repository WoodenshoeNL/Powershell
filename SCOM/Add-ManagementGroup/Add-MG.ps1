$MGMTGroup = "MGXX"
$GWServer = "opm.domain.local"

$Object= New-Object -ComObject AgentConfigManager.MgmtSvcCfg
$Object.AddManagementGroup("$MGMTGroup", "$GWServer",5723)
Restart-Service HEALTHSERVICE
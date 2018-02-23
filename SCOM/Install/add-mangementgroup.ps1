$MGMTGroup = "MG"
$GWServer = "opm3.domein.int"

$Object= New-Object -ComObject AgentConfigManager.MgmtSvcCfg
$Object.AddManagementGroup("$MGMTGroup", "$GWServer",5723)
Restart-Service HEALTHSERVICE
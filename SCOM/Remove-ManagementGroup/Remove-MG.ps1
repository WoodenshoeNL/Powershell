$MGMTGroup = "OpsMgr01"

$Object= New-Object -ComObject AgentConfigManager.MgmtSvcCfg
$Object.RemoveManagementGroup($MGMTGroup)
Restart-Service HEALTHSERVICE
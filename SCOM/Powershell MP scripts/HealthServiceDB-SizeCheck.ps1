
# Any Arguments specified will be sent to the script as a single string.
# If you need to send multiple values, delimit them with a space, semicolon or other separator and then use split.
#param([string]$Arguments)

$ScomAPI = New-Object -comObject "MOM.ScriptAPI"
$PropertyBag = $ScomAPI.CreatePropertyBag()

# Example of use below, in this case return the length of the string passed in and we'll set health state based on that.
# Since the health state comparison is string based in this template we'll need to create a state value and return it.
# Ensure you return a unique value per health state (e.g. a service status), or a unique combination of values.

if(Test-Path "$env:programfiles\Microsoft Monitoring Agent\Agent\Health Service State\Health Service Store\HealthServiceStore.edb"){
    if((((Get-Item "$env:programfiles\Microsoft Monitoring Agent\Agent\Health Service State\Health Service Store\HealthServiceStore.edb").length) / 1mb) -gt 500){
        $PropertyBag.AddValue("State","OverThreshold")
        $PropertyBag.AddValue("MessageText","De HealthServiceStore.edb is te groot")
        $PropertyBag.AddValue("Length",$(Get-Item "$env:programfiles\Microsoft Monitoring Agent\Agent\Health Service State\Health Service Store\HealthServiceStore.edb").length / 1mb)
    }
    else{
        $PropertyBag.AddValue("State","UnderThreshold")
        $PropertyBag.AddValue("MessageText","De HealthServiceStore.edb size is goed")
        $PropertyBag.AddValue("Length",$(Get-Item "$env:programfiles\Microsoft Monitoring Agent\Agent\Health Service State\Health Service Store\HealthServiceStore.edb").length / 1mb)
    }
}
else{
    $PropertyBag.AddValue("MessageText","De HealthServiceStore.edb Staat op een andere lokatie")
}

         
# Send output to SCOM
$PropertyBag


# ALert -> Message: $Data/Context/Property[@Name='MessageText']$
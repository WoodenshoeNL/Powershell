



function Write-EventLog {  
    param ([string]$msg = $(read-host "Please enter a Event Description"), [string]$source = $(read-host "Please enter Event Source"), [string]$type = $(read-host "Please enter Event Type [Information, Warning, Error]"), [int]$eventid = $(read-host "Please enter EventID")) 
    # Create the source, if it does not already exist. 
        if(![System.Diagnostics.EventLog]::SourceExists($source)) 
        { 
            [System.Diagnostics.EventLog]::CreateEventSource($source,'Application') 
        } 
        else  
        { 
            write-host "Source exists" 
        } 
         
    # Check if Event Type is correct 
    switch ($type)  
    {  
        "Information" {}  
        "Warning" {}  
        "Error" {}  
        default {"Event type is invalid";exit} 
    } 

       
    $log = New-Object System.Diagnostics.EventLog  
    $log.set_log("Application")  
    $log.set_source($source) 
    $log.WriteEntry($msg,$type,$eventid) 
} 

Write-EventLog "dit is een test log" "testsource" "information" "666"

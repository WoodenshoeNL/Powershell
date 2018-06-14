
$resources = @() 

$rawMatches = $(get-content .\Resources.html -ReadCount 1000 | ForEach-Object { $_ -match 'aria-label="Microsoft.' }) -split ","

foreach($Match in $rawMatches){
    foreach($M2 in $($Match -split '"')){
        if ((($M2 -match 'Microsoft.Network/') -and ($M2 -notmatch '>')) -or (($M2 -match 'Microsoft.Compute/') -and ($M2 -notmatch '>')) -or(($M2 -match 'Microsoft.storage/') -and ($M2 -notmatch '>'))) {
            $resources += $M2
        }
    }
}

$resources | ConvertTo-Json | Set-Content -Path ".\Resource-Types.json"


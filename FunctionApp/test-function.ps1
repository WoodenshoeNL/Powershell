
$Server = "8.8.8.8"

$pingResponse = Test-netConnection $Server -port 53

$response = @{
    time    = [System.DateTime]::UtcNow.ToString('u')
    Message = $pingResponse
} | ConvertTo-Json

Out-File -InputObject $response -FilePath $res -Encoding Ascii

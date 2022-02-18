function Get-TokenData {
    param(
        [Parameter(Mandatory=$true)]
        [string] 
        $TokenAddress
    )
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")

    try {
        $api = "$SolscanApi/token/meta?token=$TokenAddress"
        $response = Invoke-RestMethod $api -Method 'GET' -Headers $headers
        return $response
    } catch {
        PSLog($_)
    }
}
function Get-SPLTokenPrice {
    param(
        [Parameter(Mandatory=$true)]
        [string] 
        $TokenAddress
    )
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")

    try {
        $api = "$SolscanPublicApi/market/token/$TokenAddress"
        $response = Invoke-RestMethod $api -Method 'GET' -Headers $headers
        return $response
    } catch {
        $error
    }
}
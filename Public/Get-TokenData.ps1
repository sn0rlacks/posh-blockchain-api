function Get-TokenData {
    param(
        [Parameter(Mandatory=$true)]
        [string] 
        $TokenAddress,

        [Parameter(Mandatory=$true)]
        [ValidateSet("live-scrape", "public")]
        [String] 
        $Url
    )
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")

    try {
        if ($Url -eq "live-scrape") {
            $api = "$SolscanApi/token/meta?token=$TokenAddress"    
        }

        if ($Url -eq "public") {
            $api = "$SolscanPublicApi/token/meta?tokenAddress=$TokenAddress"
        }
        
        $response = Invoke-RestMethod $api -Method 'GET' -Headers $headers
        return $response
    } catch {
        PSLog($_)
    }
}
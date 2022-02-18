<#
.SYNOPSIS
    Pulls escrow data for a given collection on Magic Eden marketplace.ME Rate Limit is 120 Calls/m,minute
.PARAMETER CollectionName
    ToLower, Under-delimited name of the NFT Collection. i.e high_roller_hippo_clique
#>
function Get-NFTCollectionStats {
    param(
        [Parameter(Mandatory=$true)]
        [string] 
        $CollectionName
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")

    try {
        $api = "$MEUrl/rpc/getCollectionEscrowStats/$CollectionName"
        $response = Invoke-RestMethod $api -Method 'GET' -Headers $headers -ResponseHeadersVariable 'ResponseHeaders'
        $response | Add-Member -MemberType NoteProperty -Name 'Headers' -Value $ResponseHeaders
        $response.results.floorPrice = $response.results.floorPrice/$Lamports
        $response.results.avgPrice24hr = [Math]::Round(($response.results.avgPrice24hr/$Lamports),2)
        $response.results.volumeAll = [Math]::Round(($response.results.volumeAll/$Lamports),2)
        $response.results.volume24hr = [Math]::Round(($response.results.volume24hr/$Lamports),2)
        $response.results.listedTotalValue = [Math]::Round(($response.results.listedTotalValue/$Lamports),2)
        Write-Host "Rate limit remaining for Magic Eden API: "$response.Headers['X-RateLimit-Remaining']
        return $response.results | Select-Object symbol, floorPrice, avgPrice24hr, listedCount, volume24hr, volumeAll, listedTotalValue, availableAttribues | Format-List
    } catch {
        Write-Host "Status Code:" $_.Exception.Response.StatusCode.value__
        Write-Host "Status Description:" $_.Exception.Response.StatusDescription
        Write-Host "Status Message:" $_.ErrorDetails.Message
        Write-Host "Other:" $_ 
    }
}
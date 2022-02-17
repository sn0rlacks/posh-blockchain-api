<#
.SYNOPSIS
    Pulls escrow data for a given collection on Magic Eden marketplace.
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
        $response = Invoke-RestMethod $api -Method 'GET' -Headers $headers 
        return $response
    } catch {
        Write-Host "Status Code:" $_.Exception.Response.StatusCode.value__
        Write-Host "Status Description:" $_.Exception.Response.StatusDescription
        Write-Host "Status Message:" $_.ErrorDetails.Message
        Write-Host "Other:" $_ 
    }
}
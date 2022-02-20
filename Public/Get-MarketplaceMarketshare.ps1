<#
.SYNOPSIS
    Get the Marketplace listing of a Solana NFT.
#>
function Get-MarketplaceMarketshare {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    try {
        $api = "$ApiUrl/solana/nft/marketplaces/analytics/market_share"
        $response = Invoke-RestMethod -Uri $api -Headers $headers
        return $response
    }
    catch {
        $_
    }
}
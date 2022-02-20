<#
.SYNOPSIS
    Get all NFT transactions across all major marketplaces in the last 30 minutes.
#>
function Get-RecentNFTTransactions {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    try {
        $api = "$ApiUrl/solana/nft/marketplaces/analytics/recent_transactions"
        $response = Invoke-RestMethod -Uri $api -Headers $headers 
        foreach ($tx in $response) {
            $sol = $tx.price/$Lamports
            $tx | Add-Member -MemberType NoteProperty -Name 'price_sol' -Value $sol
        }
        return $response
    }
    catch {
        $_
    }
}
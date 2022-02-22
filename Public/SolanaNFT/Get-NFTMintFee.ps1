<#
.SYNOPSIS
    Get the estimated fee for minting an NFT on the Solana blockchain using the Metaplex protocol.
#>
function Get-NFTMintFee {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    try {
        $api = "$ApiUrl/solana/nft/mint/fee"
        $response = Invoke-RestMethod $api -Method 'GET' -Headers $headers
        $response.nft_mint_fee_estimate_lamports = [Decimal]$response.nft_mint_fee_estimate_lamports/$Lamports
        return $response
    }
    catch {
        $_
    }
}
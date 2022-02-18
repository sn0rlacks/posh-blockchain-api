<#
.SYNOPSIS
    Used to retrieve information on a NFT Listing
.PARAMETER MintAddress
    Exact Mint Address of the NFT you wish to retrieve.    
.PARAMETER Network
    Network to use. Choices are mainnet-beta and devnet.
#>
function Get-NFTListing {
    param(
        [Parameter(Mandatory=$true)]
        [string] 
        $MintAddress,

        [Parameter(Mandatory=$true)]
        [ValidateSet("devnet", "mainnet-beta")]
        [String] 
        $Network
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    try {
        $api = "$ApiUrl/solana/nft/marketplaces/listing/$Network/$MintAddress"
        $response = Invoke-RestMethod $api -Method 'GET' -Headers $headers
        foreach ($listing in $response) {
            $listing.price = [Decimal]$listing.price/$Lamports
        }
        return $response
    } catch {
        PSLog($_)
    }
}
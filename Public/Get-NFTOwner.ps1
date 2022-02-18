<#
.SYNOPSIS
    Used to retrieve the owner of a given NFT
.PARAMETER MintAddress
    Exact Mint Address of the NFT you wish to retrieve owner data for.    
.PARAMETER Network
    Network to use. Choices are mainnet-beta and devnet.
#>
function Get-NFTOwner {
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
        $api = "$ApiUrl/solana/nft/$Network/$MintAddress/owner"
        $response = Invoke-RestMethod $api -Method 'GET' -Headers $headers
        return $response
    } catch {
        PSLog($_)
    }
}
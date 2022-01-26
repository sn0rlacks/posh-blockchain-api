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
        return $response
    } catch {
        Write-Host "Status Code:" $_.Exception.Response.StatusCode.value__
        Write-Host "Status Description:" $_.Exception.Response.StatusDescription
        Write-Host "Status Message:" $_.ErrorDetails.Message
        Write-Host "Other:" $_
    }
}
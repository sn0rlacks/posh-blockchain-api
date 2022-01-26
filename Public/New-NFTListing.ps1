<#
.SYNOPSIS
    Used to list an NFT from either Solsea or Magic Eden
.PARAMETER Network
    Network to use. Choices are mainnet-beta and devnet.
.PARAMETER Marketplace
    Marketplace where nft should be listed. Solsea or Magic Eden
.PARAMETER MintAddress
    Exact Mint Address of the NFT you wish to Delist    
.PARAMETER Price
    The price which to list the NFT
#>
function New-NFTListing {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("devnet", "mainnet-beta")]
        [String]
        $Network,

        [Parameter(Mandatory=$true)]
        [ValidateSet("magic-eden", "solsea")]
        [String]
        $Marketplace,

        [Parameter(Mandatory=$true)]
        [String]
        $MintAddress,

        [Parameter(Mandatory=$true)]
        [Decimal]
        $Price
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    $privatekey = Read-Host "Enter the Base58 Private Key where the NFT is held. THIS IS YOU SIGNING THE TX" -MaskInput

    $body = [PSCustomObject]@{
        wallet = @{
            b58_private_key = $privatekey
        }
        nft_price = [System.Int64]($Lamports*$Price)
    } | ConvertTo-Json

    try {
        $api = "$ApiUrl/solana/nft/marketplaces/$Marketplace/list/$Network/$MintAddress"
        $response = Invoke-RestMethod $api -Method 'POST' -Headers $headers -Body $body
        return $response | Format-List
    } catch {
        Write-Host "Status Code:" $_.Exception.Response.StatusCode.value__
        Write-Host "Status Description:" $_.Exception.Response.StatusDescription
        Write-Host "Status Message:" $_.ErrorDetails.Message
        Write-Host "Other:" $_
    }
}
<#
.SYNOPSIS
    Used to create a single NFT on solana blockchain
.PARAMETER Network
    Network to use. Choices are mainnet-beta and devnet.
.PARAMETER Symbol
    The symbol of the token. Limited to 10 characters. Stored on the blockchain.
.PARAMETER Name
    The name of the token. Limited to 32 characters. Stored on the blockchain.
.PARAMETER Mutable
    Indicates whether or not the NFT created is mutable. If mutable, the NFT can be updated later. Once set to immutable, the NFT is unable to be changed.
#>
function New-SolanaNFT {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("devnet", "mainnet-beta")]
        [String]
        $Network,

        [Parameter(Mandatory=$false)]
        [String]
        $Symbol,

        [Parameter(Mandatory=$false)]
        [String]
        $Name,

        [Parameter(Mandatory=$true)]
        [Boolean]
        $Mutable
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    $privatekey = Read-Host "Enter the Base58 Private Key for signing. THIS IS YOU SIGNING THE TX" -MaskInput

    $body = [PSCustomObject]@{
        wallet = @{
            b58_private_key = $privatekey
        }
        nft_name = $Name
        nft_symbol = $Symbol
        is_mutable = $Mutable
    } | ConvertTo-Json

    try {
        $api = "$ApiUrl/solana/nft"
        $response = Invoke-RestMethod $api -Method 'POST' -Headers $headers -Body $body
        return $response | Format-List
    } catch {
        Write-Host "Status Code:" $_.Exception.Response.StatusCode.value__
        Write-Host "Status Description:" $_.Exception.Response.StatusDescription
        Write-Host "Status Message:" $_.ErrorDetails.Message
        Write-Host "Other:" $_
    }
}
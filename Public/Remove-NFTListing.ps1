function Remove-NFTListing {
    param(
        [Parameter(Mandatory=$true)]
        [string] 
        $PublicKey,

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
        $MintAddress
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    $privatekey = Read-Host "Enter the Base58 Private Key that listed the NFT" -MaskInput

    $body = [PSCustomObject]@{
        wallet = @{
            b58_private_key = $privatekey
        }
    } | ConvertTo-Json

    try {
        $api = "https://api.blockchainapi.com/v1/solana/nft/marketplaces/$Marketplace/delist/$Network/$MintAddress"
        $response = Invoke-RestMethod $api -Method 'POST' -Headers $headers -Body $body
        return $response | Format-List
    } catch {
        Write-Host "Status Code:" $_.Exception.Response.StatusCode.value__
        Write-Host "Status Description:" $_.Exception.Response.StatusDescription
        Write-Host "Status Message:" $_.ErrorDetails.Message
        Write-Host "Other:" $_
    }
}
<#
.SYNOPSIS
    Buys a Solana NFT from Solsea or Magic Eden
.PARAMETER MintAddress
    The mint address of the NFT to buy
.PARAMETER Marketplace
    Marketplace where nft should be listed. Solsea or Magic Eden
.PARAMETER Network
    Network to use. Choices are mainnet-beta and devnet.
.PARAMETER Price
    The number of SOL you are expecting to purchase the NFT for. We check the price of the NFT before purchasing it to ensure that it matches your expectation.
#>
function New-NFTPurchase {
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
        [String]
        $Price
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    if (-Not ($SolanaWallet)) {
        Write-Host "Signing Wallet not found. Run Set-SolanaWallet to correct this"
        exit
    }

    $body = [PSCustomObject]@{
        nft_price = [System.Int64]($Lamports*$Price)
    }

    $body | Add-Member -MemberType NoteProperty -Name 'wallet' -Value $SolanaWallet

    try {
        $api = "$ApiUrl/solana/nft/marketplaces/$Marketplace/buy/$Network/$MintAddress"
        $response = Invoke-WebRequest -Uri $api -Headers $headers -Body ($body | ConvertTo-Json)
        return $response
    }
    catch {
        $_
    }
}
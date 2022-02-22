<#
.SYNOPSIS
    Used to Delist an NFT from either Solsea or Magic Eden
.PARAMETER Network
    Network to use. Choices are mainnet-beta and devnet.
.PARAMETER Marketplace
    Marketplace where NFT is listed. Solsea or Magic Eden
.PARAMETER MintAddress
    Exact Mint Address of the NFT you wish to Delist    
#>
function Remove-NFTListing {
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
        $MintAddress
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    if (-Not ($SolanaWallet)) {
        Write-Host "Signing Wallet not found. Run Set-SolanaWallet to correct this"
        exit
    }

    $body = [PSCustomObject]@{}

    $body | Add-Member -MemberType NoteProperty -Name 'wallet' -Value $SolanaWallet

    try {
        $api = "$ApiUrl/solana/nft/marketplaces/$Marketplace/delist/$Network/$MintAddress"
        $response = Invoke-RestMethod $api -Method 'POST' -Headers $headers -Body ($body | ConvertTo-Json)
        return $response | Format-List
    } catch {
        $_
    }
}
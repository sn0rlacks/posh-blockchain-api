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
.PARAMETER MintToPublicKey
    Assign ownership of the NFT to the public key address given. Default is wallet passed.
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
        $Mutable,

        [Parameter(Mandatory=$false)]
        [String]
        $MintToPublicKey
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
        is_mutable = $Mutable
    }

    $body | Add-Member -MemberType NoteProperty -Name 'wallet' -Value $SolanaWallet

    if ($Name) {
        $body | Add-Member  -MemberType NoteProperty -Name 'nft_name' -Value $Name
    }
    if ($Symbol) {
        $body | Add-Member  -MemberType NoteProperty -Name 'nft_symbol' -Value $Symbol
    }
    if ($MintToPublicKey) {
        $body | Add-Member -MemberType NoteProperty -Name 'mint_to_public_key' -Value $MintToPublicKey
    }

    try {
        $api = "$ApiUrl/solana/nft"
        $response = Invoke-RestMethod $api -Method 'POST' -Headers $headers -Body ($body | ConvertTo-Json)
        return $response | Format-List
    } catch {
        $_
    }
}
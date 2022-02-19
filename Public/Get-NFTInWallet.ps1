function Get-NFTInWallet {
    param(
        [Parameter(Mandatory=$true)]
        [string] 
        $PublicKey,

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
        $api = "$ApiUrl/solana/wallet/$Network/$PublicKey/nfts"
        $response = Invoke-RestMethod $api -Method 'GET' -Headers $headers
        return $response
    } catch {
        $_
    }
}
function Get-SolanaWalletBalance {
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

    $body = [PSCustomObject]@{
        public_key = $PublicKey
        unit = "sol"
        network = $Network
    } | ConvertTo-Json

    try {
        $api = "$ApiUrl/solana/wallet/balance"
        $response = Invoke-RestMethod $api -Method 'POST' -Body $body -Headers $headers 
        $solprice = Get-SPLTokenPrice -TokenAddress $wrapped_sol
        foreach ($result in $response) {
            $usd = [Math]::Round(([decimal]$result.balance * [decimal]$solprice.priceUsdt), 2)
            $response | Add-Member -MemberType NoteProperty -Name 'usd_value' -Value $usd
            $response.PSObject.Properties.Remove('network')
        }
        return $response
    } catch {
        PSLog($_)
    }
}
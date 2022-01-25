function Get-SolanaWalletBalance {
    param(
        [Parameter(Mandatory=$true)]
        [string] 
        $PublicKey,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet("devnet", "mainnet-beta")]
        [String] $network
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    $body = [PSCustomObject]@{
        public_key = $PublicKey
        unit = "sol"
        network = $network
    } | ConvertTo-Json

    try {
        $api = "https://api.blockchainapi.com/v1/solana/wallet/balance"
        $response = Invoke-RestMethod $api -Method 'POST' -Body $body -Headers $headers 
        return $response | ConvertTo-Json
    } catch {
        Write-Host "Status Code:" $_.Exception.Response.StatusCode.value__
        Write-Host "Status Description:" $_.Exception.Response.StatusDescription
        Write-Host "Status Message:" $_.ErrorDetails.Message
        Write-Host "Other: You probably need to run BlockchainAPI-Auth cmdlet to store variables!" 
    }
}
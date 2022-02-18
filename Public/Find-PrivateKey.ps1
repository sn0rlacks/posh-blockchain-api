<#
.SYNOPSIS
    Used to derive a Private Key given some private data about the wallet
#>
function Find-PrivateKey {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    [String]$phrase = Read-Host "Enter the Seed Phrase for the Wallet" -MaskInput

    $body = [PSCustomObject]@{
        wallet = @{
            secret_recovery_phrase = $phrase
        }
    } | ConvertTo-Json

    try {
        $api = "$ApiUrl/solana/wallet/private_key"
        $response = Invoke-RestMethod $api -Method 'POST' -Headers $headers -Body $body
        return $response
    } catch {
        $error
    }
}
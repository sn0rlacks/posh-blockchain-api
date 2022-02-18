<#
.SYNOPSIS
    Used to Generate a new Secret Phrase for wallet seed/generation    
#>
function New-SecretPhrase {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    try {
        $api = "$ApiUrl/solana/wallet/generate/secret_recovery_phrase"
        $response = Invoke-RestMethod $api -Method 'POST' -Headers $headers
        return $response
    } catch {
        $error
    }
}
<#
.SYNOPSIS
    Used to Generate a Private Key
#>
function New-PrivateKey {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    try {
        $api = "$ApiUrl/solana/wallet/generate/private_key"
        $response = Invoke-RestMethod $api -Method 'POST' -Headers $headers
        return $response
    } catch {
        $error
    }
}
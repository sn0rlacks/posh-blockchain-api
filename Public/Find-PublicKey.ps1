<#
.SYNOPSIS
    Used to derive a Public Key given the B58 Private Key string
#>
function PublicKey {
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    [String]$privatekey = Read-Host "Enter the B58 Private Key for the Public Address" -MaskInput

    $body = [PSCustomObject]@{
        wallet = @{
            b58_private_key = $privatekey
        }
    } | ConvertTo-Json

    try {
        $api = "$ApiUrl/solana/wallet/public_key"
        $response = Invoke-RestMethod $api -Method 'POST' -Headers $headers -Body $body
        return $response
    } catch {
        Write-Host "Status Code:" $_.Exception.Response.StatusCode.value__
        Write-Host "Status Description:" $_.Exception.Response.StatusDescription
        Write-Host "Status Message:" $_.ErrorDetails.Message
        Write-Host "Other:" $_
    }
}
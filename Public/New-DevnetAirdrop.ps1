<#
.SYNOPSIS
    Used to Airdrop .015 Sol from the devnet
.PARAMETER PublicKey
    The address of the wallet for the Airdrop
#>
function New-DevnetAirdrop {
    param(
        [Parameter(Mandatory=$true)]
        [string] 
        $PublicKey
    )
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    $body = [PSCustomObject]@{
        recipient_address = $PublicKey
    } | ConvertTo-Json

    try {
        $api = "$ApiUrl/solana/wallet/airdrop"
        $response = Invoke-RestMethod $api -Method 'POST' -Headers $headers -Body $body
        return $response
    } catch {
        Write-Host "Status Code:" $_.Exception.Response.StatusCode.value__
        Write-Host "Status Description:" $_.Exception.Response.StatusDescription
        Write-Host "Status Message:" $_.ErrorDetails.Message
        Write-Host "Other:" $_
    }
}
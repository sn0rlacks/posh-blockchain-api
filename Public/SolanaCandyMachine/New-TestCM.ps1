<#
.SYNOPSIS
    Use this endpoint to create a test candy machine so that you can test your minting bot.  
.PARAMETER Network
    Network to use. Choices are mainnet-beta and devnet.
.PARAMETER IncludeGatekeeper
    Whether or not to include a gatekeeper for testing purposes. Only applies to v2 candy machines.
#>
function New-TestCM {
    param(
        [Parameter(Mandatory=$false)]
        [bool] 
        $IncludeGatekeeper,

        [Parameter(Mandatory=$true)]
        [ValidateSet("devnet", "mainnet-beta")]
        [String] 
        $Network
    )
    if (-Not ($SolanaWallet)) {
        Write-Host "Signing Wallet not found. Run Set-SolanaWallet to correct this"
        exit
    }

    $body = [PSCustomObject]@{
        network = $Network
        wallet = $SolanaWallet
    }

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")
    
    if ($IncludeGatekeeper) {
        $body | Add-Member -MemberType NoteProperty -Name 'include_gatekeeper' -Value $IncludeGatekeeper
    }

    try {
        $api = "$ApiUrl/solana/nft/candy_machine"
        Invoke-RestMethod -Uri $api -Headers $headers -Body ($body | ConvertTo-Json)
        return $response
    }
    catch {
        $_    
    }
}
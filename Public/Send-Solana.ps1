<#
.SYNOPSIS
    Used to Send SOL or any Token/NFT to a Recipient address.
.PARAMETER Recipient
    Public wallet address of the recipient.
.PARAMETER Amount
    Amount of SOL/Token you wish to Send. NFTs are limited to 1 per tx at present.
.PARAMETER Network
    Network to use. Choices are mainnet-beta and devnet.
.PARAMETER TokenAddress
    Default is SOL. If you're transfering a token, supply the token address found on the explorer.
    
#>
function Send-SPLTokens {
    param(
        [Parameter(Mandatory=$true)]
        [String]
        $Recipient,

        [Parameter(Mandatory=$true)]
        [String]
        $Amount,

        [Parameter(Mandatory=$true)]
        [ValidateSet("devnet", "mainnet-beta")]
        [String]
        $Network,

        [Parameter(Mandatory=$false)]
        [String]
        $TokenAddress
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    $privatekey = Read-Host "Enter the Base58 Private Key for the sending wallet. THIS IS YOU SIGNING THE TX" -MaskInput

    $body = [PSCustomObject]@{
        recipient_address = $Recepient
        wallet = @{
            b58_private_key = $privatekey
        }
        network = $Network
        amount = $Amount
        token_address = $TokenAddress
    } | ConvertTo-Json

    try {
        $api = "https://api.blockchainapi.com/v1/solana/wallet/transfer"
        $response = Invoke-RestMethod $api -Method 'POST' -Headers $headers -Body $body
        return $response | Format-List
    } catch {
        Write-Host "Status Code:" $_.Exception.Response.StatusCode.value__
        Write-Host "Status Description:" $_.Exception.Response.StatusDescription
        Write-Host "Status Message:" $_.ErrorDetails.Message
        Write-Host "Other:" $_
    }
}
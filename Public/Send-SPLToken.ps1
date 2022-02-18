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
function Send-SPLToken {
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
        wallet = @{
            b58_private_key = $privatekey
        }
        recipient_address = $Recipient
        network = $Network
        amount = $Amount
    }
    
    if ($TokenAddress) {
        $body | Add-Member -MemberType NoteProperty -Name 'token_address' -Value $TokenAddress
        $TokenDecimals = (Get-TokenData -TokenAddress $TokenAddress).data.decimals
        $totalamount = [Int64]$body.amount * [Math]::Pow(10, [Int64]$TokenDecimals)
        $body.amount = [String]$totalamount
    }

    try {
        $api = "$ApiUrl/solana/wallet/transfer"
        $response = Invoke-RestMethod $api -Method 'POST' -Headers $headers -Body ($body | ConvertTo-Json)
        return $response | Format-List
    } catch {
        PSLog($_)
    }
}
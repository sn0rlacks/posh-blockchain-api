<#
.SYNOPSIS
    Used to see the token holdings of the given pubkey
.PARAMETER PublicKey
    Public address of the wallet
.PARAMETER Network
    Network to use. Choices are mainnet-beta and devnet.
#>
function Get-TokenBalances {
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

    try {
        $api = "$ApiUrl/solana/wallet/$Network/$PublicKey/tokens"
        $response = Invoke-RestMethod $api -Method 'GET' -Headers $headers
        foreach ($token in $response) {
            $tokendata = Get-TokenData -TokenAddress $token.mint_address -Url public
            $tokenName = $tokendata.name
            $tokenSymbol = $tokendata.symbol
            $tokenInfo = $tokendata.tag
            $token | Add-Member -MemberType NoteProperty -Name 'token_symbol' -Value $tokenSymbol
            $token | Add-Member -MemberType NoteProperty -Name 'token_name' -Value $tokenName
            $token | Add-Member -MemberType NoteProperty -Name 'token_info' -Value $tokenInfo
        }
        return $response
    } catch {
        PSLog($_)
    }
}
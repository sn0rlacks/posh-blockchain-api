<#
.SYNOPSIS
    Used to search for an NFT collection
.PARAMETER Name
    Name you wish to search on
.PARAMETER SearchMethod
    Method which to use
.PARAMETER Network
    Network which to use. mainnet-beta or devnet
#>
function Find-NFTCollection {
    param(
        [Parameter(Mandatory=$true)]
        [string] 
        $Name,

        [Parameter(Mandatory=$true)]
        [ValidateSet("exact_match", "begins_with")]
        [String] 
        $NameSearchMethod,

        [Parameter(Mandatory=$true, Default='mainnet-beta')]
        [ValidateSet("devnet", "mainnet-beta")]
        [String] 
        $Network
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    $body = [PSCustomObject]@{
        name = $Name
        name_search_method = $NameSearchMethod
    } | ConvertTo-Json

    try {
        $api = "$ApiUrl/solana/nft/search"
        $response = Invoke-RestMethod $api -Method 'POST' -Headers $headers -Body $body
        return $response
    } catch {
        $error
    }
}
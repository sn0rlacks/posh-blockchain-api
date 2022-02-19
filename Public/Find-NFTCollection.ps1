<#
.SYNOPSIS
    Used to search for an NFT collection
.PARAMETER Name
    Name you wish to search on
.PARAMETER SearchMethod
    Method which to use
.PARAMETER UpdateAuthority
    Update authority of the NFT
.PARAMETER Network
    Network which to use. mainnet-beta or devnet
.PARAMETER Uri
    The NFT's uri
.PARAMETER Symbol
    The symbol associated with the candy machine
.PARAMETER MintAddress
    The mint address of the NFT
#>
function Find-NFTCollection {
    param(
        [Parameter(Mandatory=$false)]
        [string] 
        $Name,

        [Parameter(Mandatory=$false)]
        [string] 
        $Update_Authority,

        [Parameter(Mandatory=$false)]
        [string] 
        $Symbol,

        [Parameter(Mandatory=$false)]
        [string] 
        $Uri,

        [Parameter(Mandatory=$false)]
        [string] 
        $MintAddress,

        [Parameter(Mandatory=$true)]
        [ValidateSet("exact_match", "begins_with")]
        [String] 
        $SearchMethod,

        [Parameter(Mandatory=$true)]
        [ValidateSet("devnet", "mainnet-beta")]
        [String] 
        $Network
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")
    $body = [PSCustomObject]@{
        network = $Network
    }
    $body | Add-Member -MemberType NoteProperty -Name ($($PSBoundParameters.Keys)[0]).ToLower() -Value ($($PSBoundParameters.Values)[0])
    $methodName = ($($PSBoundParameters.Keys)[0]).ToLower() + "_search_method"
    $body | Add-Member -MemberType NoteProperty -Name $methodName -Value $SearchMethod
    $body = $body | ConvertTo-Json

    try {
        $api = "$ApiUrl/solana/nft/search"
        $response = Invoke-RestMethod $api -Method 'POST' -Headers $headers -Body $body
        return $response
    } catch {
        $_ 
    }
}
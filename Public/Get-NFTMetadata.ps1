<#
.SYNOPSIS
    Used to retrieve metadata (arweave link etc) and attributes for a given mint address
.PARAMETER MintAddress
    Exact Mint Address of the NFT you wish to retrieve.    
.PARAMETER Network
    Network to use. Choices are mainnet-beta and devnet.
#>
function Get-NFTMetadata {
    param(
        [Parameter(Mandatory=$true)]
        [string] 
        $MintAddress,

        [Parameter(Mandatory=$true)]
        [ValidateSet("devnet", "mainnet-beta")]
        [String] 
        $Network,

        [Parameter(Mandatory=$false)]
        [switch] 
        $UseSolscan        
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("APIKeyID", $Env:blockchainkeyid)
    $headers.Add("APISecretKey", $Env:blockchainsecret)
    $headers.Add("Content-Type", "application/json")

    switch ($UseSolscan) {
        $true { 
            try {
                $api = "$SolscanApi/account?address=$MintAddress"
                $response = (Invoke-RestMethod $api -Method 'GET' -Headers $headers).data
                return $response
            } catch {
                $_
            }
        }
        $false {
            try {
                $api = "$ApiUrl/solana/nft/$Network/$MintAddress"
                $response = (Invoke-RestMethod $api -Method 'GET' -Headers $headers).data
                return $response
            } catch {
                $_
            }
        }
    }
}

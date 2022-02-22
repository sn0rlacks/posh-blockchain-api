<#
.SYNOPSIS
    Get the top BUY transactions on Magic Eden. Sorted by price.
.PARAMETER Count
    How many recent nft transactions to return
.PARAMETER ReturnMoreMetadata
    Fetches the NAME value so that you can determine if a certain collection is popping off.
#>
function Get-TopTransactions {
    param(
        [Parameter(Mandatory=$true)]
        [Int16] 
        $Count,

        [Parameter(Mandatory=$false)]
        [switch] 
        $ReturnMoreMetadata
    )
    
    $txlist = Get-RecentNFTTransactions

    switch ($ReturnMoreMetadata) {
        $true { 
            $sublist = $txlist | Where-Object {$_.exchange -eq "magic-eden" -and $_.operation -eq "buy"} | Select-Object -First $Count | Sort-Object -Property price_sol -Descending
            foreach ($t in $sublist) {
                $meta = Get-NFTMetadata -MintAddress $t.mint_address -Network mainnet-beta -UseSolscan
                $t | Add-Member -MemberType NoteProperty -Name 'name' -Value $meta.tokenInfo.name
            }
            return $sublist
         }
        Default {
            return $txlist | Where-Object {$_.exchange -eq "magic-eden" -and $_.operation -eq "buy"} | Select-Object -First $Count | Sort-Object -Property price_sol -Descending
        }
    }
}
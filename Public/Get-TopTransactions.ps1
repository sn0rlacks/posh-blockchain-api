function Get-TopTransactions {
    param(
        [Parameter(Mandatory=$true)]
        [Int16] 
        $Count
    )
    $txlist = Get-RecentNFTTransactions
    
    return $txlist | Where-Object {$_.exchange -eq "magic-eden" -and $_.operation -eq "buy"} | Select-Object -First $Count | Sort-Object -Property price_sol -Descending
}
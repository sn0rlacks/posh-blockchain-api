<#
.SYNOPSIS
    Utilized AngleSharp library to parse HTML Response Objects. It's fucked. Will figure out how to do natively one day
.PARAMETER ContractAddress
    The contract address of the NFT collection
.PARAMETER Chain
    The chain to search. Options are avax, eth, and bsc
#>
function Get-NFTradeCollectionStats { 
    param(
        [Parameter(Mandatory=$true)]
        [string] 
        $ContractAddress,

        [Parameter(Mandatory=$true)]
        [ValidateSet("avalanche", "eth", "bsc")]
        [string] 
        $Chain
    )

    if (-Not (Get-Package -Name Angle*).Name) {
        Write-Host "This function requires AngleSharp module. It will install now."
        Install-PackageProvider -Name "NuGet"
        Install-Package AngleSharp -SkipDependencies -ErrorAction SilentlyContinue
    }
    
    If ( -Not ([System.Management.Automation.PSTypeName]'AngleSharp.Parser.Html.HtmlParser').Type ) {
        $standardAssemblyFullPath = (Get-ChildItem -Filter '*.dll' -Recurse (Split-Path (Get-Package -Name 'AngleSharp').Source)).FullName | Where-Object {$_ -Like "*standard*"} | Select-Object -Last 1
    
        Add-Type -Path $standardAssemblyFullPath -ErrorAction 'SilentlyContinue'
    } # Terminate If - Not Loaded

    switch ($Chain) {
        "avalanche" {$unit = "AVAX"}
        "eth" {$unit = "ETH"}
        "bsc" {$unit = "BSC"}
    }
    
    $api = "https://nftrade.com/assets/$Chain/$($ContractAddress)?search=&sort=price_asc"

    try {
    $data = Invoke-WebRequest -Uri $api -Method 'GET'
    $parser = New-Object AngleSharp.Html.Parser.HtmlParser
    $parsed_content = $parser.ParseDocument($data.Content)
    $parsed_content = $parsed_content.All | Where-Object ID -eq "__NEXT_DATA__" 
    $json = ($parsed_content.ChildNodes.data | ConvertFrom-Json).props.pageProps
    $CollectionDetails = [PSCustomObject]@{
        ContractName = $json.contract.displayName
        Symbol = $json.contract.symbol
        FloorPrice = $json.tokens.price[0]
        Token = $unit
        Description = $json.contract.description
        Verified = $json.contract.verified
        Trending = $json.contract.trending
    }
    return $CollectionDetails | Format-List
    } catch {
        $_
    }
}

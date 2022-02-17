<#
    .Synopsis
        This is the parent modulescript that connects all the dots
#>
[String]$Script:ApiUrl = 'https://api.blockchainapi.com/v1'
[String]$Script:MEUrl = 'https://api-mainnet.magiceden.io'
[String]$Script:wrapped_sol = "So11111111111111111111111111111111111111112"
[Int64]$Script:Lamports = 1000000000
[String]$Script:SolscanApi = 'https://public-api.solscan.io'
$Public = @( Get-ChildItem -Path ".\Public\*.ps1" -ErrorAction SilentlyContinue )

foreach ($import in $Public) {
    try {
        . $import.FullName
    } catch {
        Write-Error -Message "Failed to import function: $($import.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName
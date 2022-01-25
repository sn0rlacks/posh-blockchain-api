<#
    .Synopsis
        This is the main scaffolding the glues all the pieces together.
#>
$public = @( Get-ChildItem -Path "C:\users\lemons\Onedrive\git\hub\posh-blockchain-api\Public\*.ps1" -ErrorAction SilentlyContinue )

foreach ($import in $public) {
    try {
        . $import.FullName
    } catch {
        Write-Error -Message "Failed to import function: $($import.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName
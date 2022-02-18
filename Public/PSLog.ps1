<#
.SYNOPSIS
    Basic console logger
#>
function PSLog ($_) {
    Write-Host "Status Code:" $_.Exception.Response.StatusCode.value__
    Write-Host "Status Description:" $_.Exception.Response.StatusDescription
    Write-Host "Status Message:" $_.ErrorDetails.Message
    Write-Host "Other:" $_ 
}
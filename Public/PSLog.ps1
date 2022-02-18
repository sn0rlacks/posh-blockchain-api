<#
.SYNOPSIS
    Pulls escrow data for a given collection on Magic Eden marketplace.ME Rate Limit is 120 Calls/mminute and Solanart RL is 50 calls/min
#>
function PSLog ($_) {
    Write-Host "Status Code:" $_.Exception.Response.StatusCode.value__
    Write-Host "Status Description:" $_.Exception.Response.StatusDescription
    Write-Host "Status Message:" $_.ErrorDetails.Message
    Write-Host "Other:" $_ 
}
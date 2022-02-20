
function Get-NFTCollectionStats {
    param(
        [Parameter(Mandatory=$true)]
        [string] 
        $CollectionName,

        [Parameter(Mandatory=$true)]
        [ValidateSet("magic-eden", "solanart")]
        [String]
        $Marketplace
    )

    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Content-Type", "application/json")

    switch($Marketplace) {
        "magic-eden" {
            try {
                $api = "$MEUrl/rpc/getCollectionEscrowStats/$CollectionName"
                $response = Invoke-RestMethod $api -Method 'GET' -Headers $headers -ResponseHeadersVariable 'ResponseHeaders'
                $response | Add-Member -MemberType NoteProperty -Name 'Headers' -Value $ResponseHeaders
                $response.results.floorPrice = $response.results.floorPrice/$Lamports
                $response.results.avgPrice24hr = [Math]::Round(($response.results.avgPrice24hr/$Lamports), 2)
                $response.results.volumeAll = [Math]::Round(($response.results.volumeAll/$Lamports), 2)
                $response.results.volume24hr = [Math]::Round(($response.results.volume24hr/$Lamports), 2)
                $response.results.listedTotalValue = [Math]::Round(($response.results.listedTotalValue/$Lamports), 2)
                Write-Host "RL Remaining: "$response.Headers['X-RateLimit-Remaining']
                return $response.results | Select-Object symbol, floorPrice, avgPrice24hr, listedCount, volume24hr, volumeAll, listedTotalValue, availableAttribues | Format-List
            } catch [System.Management.Automation.RuntimeException]{
                Write-Warning "Collection not found. This means either it's not listed or the format of the name was incorrect"
            } catch [Microsoft.PowerShell.Commands.HttpResponseException]{
                Write-Warning ($_.ErrorDetails.Message | ConvertFrom-Json).error_message  
            }
        }
        "solanart" {
            try {
                $api = "$SolanartUrl/get_floor_price?collection=$CollectionName"
                $response = Invoke-RestMethod $api -Method 'GET' -Headers $headers 
                $master = [PSCustomObject]@{
                    floorPrice = $response.floorPrice
                    count_listed = $response.count_listed
                    medianPrice = $null
                    totalVolume = $null
                }
                $api = "$SolanartUrl/volume_only_collection?collection=$CollectionName"
                $response = Invoke-RestMethod $api -Method 'GET' -Headers $headers -ResponseHeadersVariable 'ResponseHeaders'
                Write-Host "Rate limit remaining for Solanart API: "$ResponseHeaders['X-RateLimit-Remaining']
                $master.medianPrice = $response.medianPrice
                $master.totalVolume = $response.totalVolume
                return $master | Format-List
            }  catch [System.Management.Automation.RuntimeException]{
                Write-Warning "Collection not found. This means either it's not listed or the format of the name was incorrect"
            } catch [Microsoft.PowerShell.Commands.HttpResponseException]{
                Write-Warning ($_.ErrorDetails.Message | ConvertFrom-Json).error_message  
            }
        }
    }
}
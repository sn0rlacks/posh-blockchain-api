<#
.SYNOPSIS
  
.PARAMETER WalletType
    THe wallet used for transactions. Methods of passing are private_key, b58, secret phrase    
#>
function Set-SolanaWallet {
    param(
        [Parameter(Mandatory=$true)]
        [string] 
        [ValidateSet("secret_recovery_phrase", "private_key", "b58_private_key")]
        $WalletType
    )

    $Wallet = Read-Host "This will locally store your wallet. THIS IS YOU APPROVING TX ACTIONS. Enter your" $WalletType -MaskInput

    $Global:SolanaWallet = @{
        $WalletType = $Wallet
    }


    if ($Env:SolanaWallet) {
        $stored = "Your wallet details have been stored locally in this session. Keys will CLEAR after session is terminated"
    }

    return $stored

}
function Enter-BlockchainAPI {
    $Env:blockchainkeyid = Read-Host "Enter your BlockchainAPI Key ID" 
    $Env:blockchainsecret = Read-Host "Enter your BlockchainAPI Secret" -MaskInput

    if ($Env:blockchainkeyid) {
        $stored = "Your credentials have been stored. You can use the entire module freely"
    }

    return $stored
}
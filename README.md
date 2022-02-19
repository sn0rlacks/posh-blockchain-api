# posh-blockchain-api

**This is a WIP**

What started as a wrapper for the wonderful BlockchainAPI by Josh Wolff. See --> https://docs.blockchainapi.com/ for usage of the base API. All credit to https://github.com/joshwolff1 | This is now an amalgamation of tools for getting blockchain data, assets (cross-chain), token data (cross-chain), and more.

## USAGE

1. Clone and Import the module. `Import-Module .\path\to\psm1`
2. Run `Enter-BlockchainAPI` to be prompted to enter API key

![image](https://user-images.githubusercontent.com/32146013/151041501-0aed69e3-c17c-422f-bf1e-24df59731588.png)

Good to go! Run the rest of the cmdlets knowing your API keys are only local in your shell (and the parent API), never outside.

### Example Output

`Get-NFTCollectionData -CollectionName aurory -Marketplace magic-eden`

![image](https://user-images.githubusercontent.com/32146013/154604833-ccb8bf72-64fa-46a4-8aa5-69294fcf4852.png)

### IMPORTANT

`Get-NFTradeCollectionStats` requires the AngleSharp module for powershell. See --> https://github.com/AngleSharp/AngleSharp for more. This is due to POSH 7+ removing dynamic HTTP response object. Opting in for httpclient and basicwebresponse. Makes things challenging, but I'm sure this will be solved soon natively.

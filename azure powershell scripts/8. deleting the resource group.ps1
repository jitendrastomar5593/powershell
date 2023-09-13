#deleting the resource group

$rg = "ps-rg"
$location = "eastus"

Get-AzSubscription | fl

Get-AzResourceGroup -Name $rg -Location $location | Remove-AzResourceGroup -Force
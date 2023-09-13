#create network on Azure

#importing azure module
Import-Module -Name az

#listing the subscriptions
Get-AzSubscription | fl

#listing present RGs with their locations
Get-AzResourceGroup | select ResourceGroupName, Location

cls

$rg = "ps-rg"
$location = "eastus"

#create new virtual network
$vnet = New-AzVirtualNetwork `
-ResourceGroupName $rg `
-Location $location `
-Name psmyvnet010101 `
-AddressPrefix 172.16.0.0/16

#create subnet - 1st subnet
$subnet = Add-AzVirtualNetworkSubnetConfig `
-Name sub-1 `
-AddressPrefix 172.16.1.0/24 `
-VirtualNetwork $vnet

#associating subnet with vnet - write subnet to the vnet - 1st subnet
$vnet | Set-AzVirtualNetwork

##################################################################
### After vnet & subnet gets created, then create below subnet ###
##################################################################

#create subnet - 2nd subnet
$subnet = Add-AzVirtualNetworkSubnetConfig `
-Name sub-2 `
-AddressPrefix 172.16.2.0/24 `
-VirtualNetwork $vnet

#associating subnet with vnet - write subnet to the vnet - 2nd subnet
$vnet | Set-AzVirtualNetwork


#listing the virtual network and subnet
Get-AzVirtualNetwork -ResourceGroupName $rg `
-Name psmyvnet010101 | `
select Subnets

#listing subnet indiviusal subnets
Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name 'sub-1'
Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name 'sub-1'

#listing subnet indiviusal subnets - filtered
Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet | select Name, AddressPrefix


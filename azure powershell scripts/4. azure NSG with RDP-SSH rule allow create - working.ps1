#create NSG on Azure

#importing azure module
Import-Module -Name az

#listing the subscriptions
Get-AzSubscription | fl

#listing present RGs with their locations
Get-AzResourceGroup | select ResourceGroupName, Location

#getting the NSG
#Get-AzNetworkSecurityGroup -ResourceGroupName $rg

cls

$rg = "ps-rg"
$location = "eastus"
$vnet = "psmyvnet010101"

#create NSG
$rdprule = New-AzNetworkSecurityRuleConfig -Name ps-rdp `
-Description "It allows RDP - Allow access" `
-Access Allow `
-Protocol Tcp `
-Direction Inbound `
-Priority 100 `
-SourceAddressPrefix internet `
-SourcePortRange * `
-DestinationAddressPrefix * `
-DestinationPortRange 3389 

$sshrule = New-AzNetworkSecurityRuleConfig -Name ps-ssh `
-Description "It allows SSH - Allow access" `
-Access Allow `
-Protocol Tcp `
-Direction Inbound `
-Priority 101 `
-SourceAddressPrefix internet `
-SourcePortRange * `
-DestinationAddressPrefix * `
-DestinationPortRange 22

$nsg = New-AzNetworkSecurityGroup `
-ResourceGroupName $rg `
-Name psmynsg010101 `
-Location $location `
-SecurityRules $rdprule, $sshrule `
-Force





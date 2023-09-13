$rg = "ps-rg"
$location = "eastus"
$vmname = "vm2016"
$image = "Win2016Datacenter"
$size = "Standard_DS3_v2"
$vnet = "psmyvnet010101"
$vnsg = "psmynsg010101"
$mypubip = "myvirpubip"

$virnet = Get-AzVirtualNetwork -Name $vnet -ResourceGroupName $rg
$virsubnet = get-AzVirtualNetworkSubnetConfig -Name "sub-1" -VirtualNetwork $virnet
$virnsg = Get-AzNetworkSecurityGroup -Name $vnsg -ResourceGroupName $rg

new-azvm -Name $vmname `
-ResourceGroupName $rg `
-Location $location `
-VirtualNetworkName $virnet `
-AddressPrefix 172.16.0.0/16 `
-SubnetAddressPrefix 172.16.1.0/24 `
-SubnetName "sub-1" `
-Credential (Get-Credential) `
-PublicIpAddressName $mypubip `
-OpenPorts 3389,80 -Image $image -Size $size `
-DataDiskSizeInGb 130 -SecurityGroupName $virnsg


#fetching public IP address
$pip = Get-AzPublicIpAddress -Name myvirpubip -ResourceGroupName $rg
#$pip.IpAddress

mstsc.exe /v $pip.IpAddress
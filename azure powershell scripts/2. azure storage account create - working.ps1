#create storage on Azure

#importing azure module
Import-Module -Name az

#listing the subscriptions
Get-AzSubscription | fl

#listing present RGs with their locations
Get-AzResourceGroup | select ResourceGroupName, Location

<#
list of SKU's present:
========================
Replication option					                SkuName parameter
------------------------                            --------------------
Locally redundant storage (LRS)				        Standard_LRS
Zone-redundant storage (ZRS)				        Standard_ZRS
Geo-redundant storage (GRS)				            Standard_GRS
Read-access geo-redundant storage (GRS)			    Standard_RAGRS
Geo-zone-redundant storage (GZRS)			        Standard_GZRS
Read-access geo-zone-redundant storage (RA-GZRS)	Standard_RAGZRS
#>

cls

$rg = "ps-rg"
$location = "eastus"

#creating new storage
try {
New-AzStorageAccount -ResourceGroupName $rg `
-Name psmysto010101 `
-Location $location `
-SkuName Standard_LRS `
-Kind StorageV2 `
-Verbose -ErrorAction Stop
}
catch [ArgumentException] {
write-host "Storage already exists" -BackgroundColor Red
}
catch {
write-host "General failure" -BackgroundColor Red
}

Get-AzStorageAccount -ResourceGroupName $rg | `
select ResourceGroupName, Sku, AccessTier, StatusOfPrimary | fl


#create Blob storage on Azure & upload the data

#importing azure module
Import-Module -Name az

#listing the subscriptions
Get-AzSubscription | fl

#listing present RGs with their locations
Get-AzResourceGroup | select ResourceGroupName, Location

cls

$rg = "ps-rg"
$location = "eastus"
$stoname = "psmysto010101"

#getting storage details
$storageacc = Get-AzStorageAccount -ResourceGroupName $rg -Name $stoname

#fetching context data of storage
$ctx = $storageacc.Context

#Create a container
$containerName = "pstestingblobs"
New-AzStorageContainer -Name $containerName -Context $ctx -Permission blob

#Upload blobs to the container
#########################################################################

$p1 = "E:\Images\1001619.jpg"
$p2 = "E:\Images\100510.jpg"
$p3 = "E:\Images\100519.jpg"
$p4 = "E:\Images\1009977.jpg"


# upload a file to the default account (inferred) access tier
Set-AzStorageBlobContent -File $p1 `
  -Container $containerName `
  -Blob "1001619.jpg" `
  -Context $ctx -Force

# upload a file to the Hot access tier
Set-AzStorageBlobContent -File $p1 `
  -Container $containerName `
  -Blob "100510.jpg" `
  -Context $ctx -Force

# upload another file to the Cool access tier
Set-AzStorageBlobContent -File  $p1 `
  -Container $containerName `
  -Blob "100519.jpg" `
  -Context $ctx -Force

# upload a file to a folder to the Archive access tier
Set-AzStorageBlobContent -File  $p1 `
  -Container $containerName `
  -Blob "1009977.jpg" `
  -Context $ctx  -Force


#uploading the files of a folder to blob
$b2 = "newblob2"

#Create new container 
New-AzStorageContainer -Name $b2 -Context $ctx -Permission Blob

#transfer all files 
ls E:\Images -Recurse | Set-AzStorageBlobContent `
-Container $b2 `
-Context $ctx `
-Verbose 

#download the blob from azure to local system
Get-AzStorageBlobContent -Context $ctx -Container $b2 -Blob "100510.jpg"

#listing all the files from the 
Get-AzStorageBlob -Container $b2 -Context $ctx | measure

#removing the blobs from the container forcefully
Get-AzStorageBlob -Container $b2 -Context $ctx | Remove-AzStorageBlob -Force -Verbose


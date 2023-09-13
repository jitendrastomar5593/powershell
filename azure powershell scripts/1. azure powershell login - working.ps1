#Find Azure latest (AZ) Module
$az = Find-Module AZ
$az | measure

#Find ALL Azure latest (AZ) Module
$azall = Find-Module AZ*
$azall | measure

#list all modules with "compute" in it.
$azall | Where-Object Name -Like *compute*

<#
Tools for PS:
- Powershell prompt (2,3,4,5,5.1)
- Powershell ISE
- Visual Studio Code (VSCode)
- Azure Powershell - Cloud Shell
#>

#finding the AZ module & then installing it.
Find-Module AZ | Install-Module -AllowClobber -Scope AllUsers -Force -Verbose

#login to azure using PS
Connect-AzAccount

#list the subscription details
Get-AzSubscription | fl

#selecting single subscription, in case of multiple subscriptions
Select-AzSubscription "Azure Pass - Sponsorship" | fl

<#
after login, it displays some data i.e, called as CONTEXT DATA.
context data consists of several parts, such as:
    - Environment (like Azure Gov cloud..)
    - Tenant (company)
    - Subscription ()
    - Account (user)
    - Credentials (auths)
#>

#get list of all the resource groups
Get-AzResourceGroup  #list all in details
Get-AzResourceGroup | Select-Object ResourceGroupName  #list only names

#create a new resource group
New-AzResourceGroup -Name cli-rg -Location 'East US' -Force

#enable context autosaving (can be used next time only, have to reconnect.)
Enable-AzContextAutosave

#disconnect context autosave.
Disable-AzContextAutosave

#disconnect
Disconnect-AzAccount


#####saving the context data in the variable (later can be saved into the environment variable also)

#get the subscription details
Get-AzSubscription | fl

#saving the context data in the variable
$azpass = Set-AzContext -Subscription "Azure Pass - Sponsorship" -Name "Azure Pass - ENV Variable"

#using the variable to get the resources info.
Get-AzResourceGroup -Name cli-rg -DefaultProfile $azpass

#removing the resource groups using cotext variable
Remove-AzResourceGroup -Name jeetu -DefaultProfile $azpass -Force -Verbose

#listing the modules
Get-Module -Name AZ*storage* -ListAvailable

#get command from a particular module.
Get-Command *disk* -Module az.*         #all modules
Get-Command *disk* -Module az.compute   #only compute module

#listing the VMs in the subscription.
Get-AzVM                                                     #list all VMs
Get-AzVM -ResourceGroupName web-RG -Status                   #list status of the VM in that RG
(Get-AzVM -ResourceGroupName web-RG -Status).Powerstate      #lists the current state of the VM.

#get the syntax to create a new VM
Get-Command New-AzVM -Syntax 

#get complete details of the cmdlet using online method
Get-Help New-AzVM -Online

#getting list of all the cmdlets from a particular module (say Storage, Network, compute)
Get-Command -Module Az.Storage
Get-Command -Module Az.Storage | measure

Get-Command -Module Az.Network
Get-Command -Module Az.Network | measure

Get-Command -Module Az.Compute
Get-Command -Module Az.Compute | measure

#getting into the objects & properties.
#getting VM info, in various formats
Get-AzVM -Status
Get-AzVM | Select-Object Name
Get-AzVM | Select-Object Name, ResourceGroupName
Get-AzVM | Select-Object Name, ResourceGroupName, Location
Get-AzVM | Select-Object Name, ResourceGroupName, Location, Powerstate

#get list of all the members of a cmdlet
Get-Azvm | Get-Member

#list all the properties of 1st VM in the list.
Get-AzVM | Select-Object -Property * -First 1            #contains list of sub-members (members within members)

#getting into the details of the sub-members of Get-Member cmdlet.
$vm = Get-AzVM -Status | Select-Object -First 1          #Store 1st VM info
$vm                                                      #list 1st VM info
$vm | Select-Object *                                    #list all objects 
$vm | Select-Object -ExpandProperty HardwareProfile      #list only "HardwareProfile" for that VM.
$vm.HardwareProfile.VmSize                               #using (.) dot as object reference.
$vm.OSProfile.WindowsConfiguration.TimeZone              #get the timezone of the vm, when it ON
$vm.NetworkProfile.NetworkInterfaces.Count               #lists number of NICs.
$vm.DiagnosticsProfile.BootDiagnostics.StorageUri        #shows where the VM diagnostics are getting stored.
$vm.StorageProfile.OsDisk.DiskSizeGB
$vm.StorageProfile | ConvertTo-Json -Depth 1             #displays the depth 1 details of the storage
$vm.StorageProfile | ConvertTo-Json -Depth 2             #displays the depth 2 details of the storage, means objects within objects.


###Filtering objects, properties & formating outputs.
$allvms = Get-AzVM                                       #storing all VMs in a variable
$allvms                                                  #listing all VMs from a variable

$firstvm = $allvms | Select-Object -First 1              #storing 1st VM in a variable
$firstvm                                                 #listing 1st VM from a variable

$eastus = $allvms | Where-Object Location -EQ "EastUs"   #storing VM list using their location
$eastus                                                  #listing EASTUS VMs

$v3 = $allvms | Where-Object VMSize -Like "*v3"
$v3                                                      #this will not work, because of the "VMSize" name
if (-not $v3) {write-host -ForegroundColor Cyan "Oops!!! It didn't work"} else {$v3}

#to make it work
$v3 = $allvms | Where-Object HardwareProfile.VMSize -Like "*v3*"
if (-not $v3) {write-host -ForegroundColor Cyan "Oops!!! It didn't work AGAIN"} else {$v3}

#to make it work... Properly
$v3 = $allvms | Where-Object {$_.HardwareProfile.VMSize -Like "*v3*"}
if (-not $v3) {write-host -ForegroundColor Cyan "Oops!!! It didn't work AGAIN"} else {$v3}
if (-not $v3) {write-host -ForegroundColor Cyan "Oops!!! It didn't work AGAIN"} else {$v3.Name}

#using HASHTABLE to fetch the information.
$allvms | Select-Object Name, @{Name="VM Size";Expression={$_.HardwareProfile.VMSize}}

#listing specific values
$sts = get-azvm -Status
$sts | Select-Object Name, @{Name="VM Size";Expression={$_.HardwareProfile.VMSize}}, Powerstate | Format-List

#formatting the output properly
$sts | Format-Custom

#deep-dive into the sub-properties
$sts | Format-Custom -Property DiagnosticsProfile
$sts | Format-Custom -Property DiagnosticsProfile -Depth 1
$sts | Format-Custom -Property DiagnosticsProfile -Depth 2

#formatting the output
$sts
$sts | Select-Object Name, @{Name="VM Size";Expression={$_.HardwareProfile.VMSize}}, Powerstate
$sts | Select-Object Name, @{Name="VM Size";Expression={$_.HardwareProfile.VMSize}}, Powerstate | Format-List

####
##Concepts & parameters.
New-AzResourceGroup -Name "ps-rg" -Location "eastus" -Tag @{Use="RND";Author="Jeetu"}
Get-AzResourceGroup | select ResourceGroupName
Get-AzResourceGroup -Name "ps-rg"
$rndrg = Get-AzResourceGroup -Name "ps-rg"              #storing the values of RG in a variable.
$rndrg | Remove-AzResourceGroup -WhatIf
$rndrg | Remove-AzResourceGroup -Confirm

#Playing with Tags
$rndrg.Tags
$rndrg.Tags = $null
$rndrg.Tags += @{Owner="Jitendra Singh Tomar"}
$rndrg.Tags += @{Purpose="Azure Powershell RnD"}
$rndrg | Set-AzResourceGroup                            #if not executed, then the changes will not be refelected on PORTAL.

#Playing with the LOCATIONS
Get-AzLocation                         #providers = services present in that location
Get-AzLocation | ft                    #formatting TABULAR-wise

#searching for locations with Microsoft.Automation service
Get-AzLocation | Where-Object {$_.Providers -contains "Microsoft.Automation"}
Get-AzLocation | Where-Object {$_.Providers -contains "Microsoft.Automation" -and $_.DisplayName -like "* US*"}
Get-AzLocation | Where-Object {$_.Providers -contains "Microsoft.Automation" -and $_.DisplayName -like "* US*"} | ft
Get-AzLocation | Where-Object {$_.Providers -notcontains "Microsoft.Automation" -and $_.DisplayName -like "* US*"} | ft

#URL: https://subscription.packtpub.com/video/virtualization_and_cloud/9781789134216/73480/73484/concepts-and-parameters-you-need-to-know

#getting any random VM.
$random = Get-AzVM | Get-Random

#fetching details of the random VM
$random.id
$random.StorageProfile.DataDisks
$nic = $random.NetworkProfile.NetworkInterfaces[0]
$nic.id


#fetching resource details
Get-AzResource -ResourceId ($nic.Id)


#time remaining: -4.52
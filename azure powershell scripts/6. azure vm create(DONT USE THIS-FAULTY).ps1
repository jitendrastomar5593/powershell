#create virtual machine on azure using powershell

#connecting to azure vm
Connect-AzAccount

cls

$rg = "ps-rg"
$location = "eastus"
$stoname = "psmysto010101"

$VMAdminUser = "jeetu"
$VMAdminSecurePassword = ConvertTo-SecureString "Pa$$w0rd12345" -AsPlainText -Force
$LocationName = $location
$ResourceGroupName = $rg
$ComputerName = "winsvr2016"
$VMName = "winsvr2016"
$VMSize = "Standard_DS3"

$NetworkName = "psmyvnet010101"
$NICName = "MyNIC"
$SubnetName = "sub-1"
$SubnetAddressPrefix = "172.16.1.0/24"
$VnetAddressPrefix = "172.16.0.0/16"

$SingleSubnet = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressPrefix
$Vnet = New-AzVirtualNetwork -Name $NetworkName -ResourceGroupName $ResourceGroupName -Location $LocationName -AddressPrefix $VnetAddressPrefix -Subnet $SingleSubnet
$NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $ResourceGroupName -Location $LocationName -SubnetId $Vnet.Subnets[0].Id
    
$Credential = New-Object System.Management.Automation.PSCredential ($VMAdminUser, $VMAdminSecurePassword);
    
$VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2012-R2-Datacenter' -Version latest
    
New-AzVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine -Verbose
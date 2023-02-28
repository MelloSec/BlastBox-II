[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$VMName,
    # [Parameter(Mandatory)]
    # [string]$Username,
    # [Parameter(Mandatory)]
    # [string]$Password,
    [Parameter()]
    [string]$Image,
    [Parameter()]
    [string]$Location = "East US",
    [Parameter()]
    [switch]$windows10,
    [Parameter()]
    [switch]$server2022,
    [Parameter()]
    [switch]$Deploy,
    [Parameter()]
    [switch]$Destroy
)



$Username = Read-Host "Enter a username for VM"
$Password = Read-Host "Enter a Password for VM" -AsSecureString
$subscription = Get-AzSubscription
$tenant = Get-AzTenant
$tenantName = "Sludge"
$resourceGroupName = -join("$VMName","-RG")
$myip = Invoke-WebRequest 'http://ifconfig.me/ip' -UseBasicParsing
$myip = $myip.Content

$VNETName = -join("$VMName","-VNET")
$pubName = -join("$VMName","-IP")
$nsgName = -join("$VMName","-NSG")
$subnetName = -join("$VMName","-Subnet")
$soundssketchy = $VMName+33892023
$user = "mellonaut"
$win10image = "MicrosoftWindowsDesktop:Windows-10:21h1-ent:latest"
$server22 = 'Win2022Datacenter'
# if args contain either server or win10, image becomes that variable
if ($server2022) {
    $image = $server22
}
elseif ($windows10) {
    $image = $win10image
}
else {
    Write-Error "Either -server2022 or -windows10 switch must be provided"
    return
}

# Get connected to Azure
function Set-Context {
    if(!( -Name Azure)) { Install-Module Az }
    Import-Module Az
    if(!(get-azcontext)){ Connect-AzAccount }
}
Set-Context

# Create or delete the resource group
if ($Deploy) {
    function Create-RG {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory)]
            [String]$resourceGroupName,
            [Parameter(Mandatory)]
            [String]$location
        )
        if(!(Get-AzResourceGroup -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue))
        {
          New-AzResourceGroup -name $resourceGroupName -location $location
        }
    }
    $rg = Create-RG $resourceGroupName $location

    # Create Rules and NSG

    # Allow Rules
    # $rule1 = New-AzNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" `
    # -Access Allow -Protocol Tcp -Direction Inbound -Priority 300 -SourceAddressPrefix `
    # $myip.ToString() -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389

    # $rule2 = New-AzNetworkSecurityRuleConfig -Name web-rule -Description "Allow HTTP" `
    # -Access Allow -Protocol Tcp -Direction Inbound -Priority 301 -SourceAddressPrefix `
    # $myip.ToString() -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80, 443

    # $rule3 = New-AzNetworkSecurityRuleConfig -Name smb-rule -Description "Allow SMB" `
    # -Access Allow -Protocol Tcp -Direction Inbound -Priority 302 -SourceAddressPrefix `
    # $myip -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 139, 445

        # $rule5 = New-AzNetworkSecurityRuleConfig -Name WinRM -Description "Allow incoming WinRM traffic" `
    # -Access Allow -Protocol Tcp -Direction Inbound -Priority 304 -SourceAddressPrefix $myip `
    # -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange 5985, 5986

    $rule0 = New-AzNetworkSecurityRuleConfig -Name allow-myip-tcp -Description "Allow all inbound TCP traffic from $myIP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 200 `
    -SourceAddressPrefix $myip.ToString() -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange *

    $rule4 = New-AzNetworkSecurityRuleConfig -Name udp-allow-all -Description "Allow all inbound UDP traffic from $myip" `
    -Access Allow -Protocol Udp -Direction Inbound -Priority 300 -SourceAddressPrefix $myip `
    -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange "*"

    # Deny Rules

    $rule6 = New-AzNetworkSecurityRuleConfig -Name tcp-deny-all -Description "Deny all inbound TCP traffic" `
    -Access Deny -Protocol Tcp -Direction Inbound -Priority 401 -SourceAddressPrefix "*" `
    -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange "*"

    $rule7 = New-AzNetworkSecurityRuleConfig -Name udp-deny-all -Description "Deny all inbound UDP traffic" `
    -Access Deny -Protocol Udp -Direction Inbound -Priority 402 -SourceAddressPrefix "*" `
    -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange "*"

    $nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $location -Name `
    "Homeward-Bound" -SecurityRules $rule0,$rule4,$rule6,$rule7

    # Create VNET
    function Create-Networking {
        az network vnet create --name $VNETName --resource-group $resourceGroupName --subnet-name $VMName
    }
    Create-Networking

    $VNet = Get-AzVirtualNetwork -Name $VNETName
    $subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $VNet | Select-Object Name,AddressPrefix
    $VNetSubnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $VNet -Name $VMName

    # Apply NSG to Subnet
    Set-AzVirtualNetworkSubnetConfig -Name $VNetSubnet.Name -VirtualNetwork $VNet -AddressPrefix $VNetSubnet.AddressPrefix -NetworkSecurityGroup $nsg

    # Update the VNET
    $VNet | Set-AzVirtualNetwork


    # Convert password into string for the command
    $passwordPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
    # Create VM
    function Create-VM {
        az vm create --name $VMName --resource-group $resourceGroupName --image $image --generate-ssh-keys --admin-username $user --admin-password $passwordPlainText --vnet-name $VNETName --subnet $VMName --public-ip-sku Standard
    }
    $vm = Create-VM

}
elseif ($Destroy) {
    $resourceGroupName = -join("$VMName","-RG")
    az group delete -n $resourceGroupName --force-deletion-types Microsoft.Compute/virtualMachines
}

Write-Output "Your VM's connection information:"
Write-Output $vm
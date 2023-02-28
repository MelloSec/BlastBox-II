[CmdletBinding()]
param(
    # [Parameter(Mandatory)]
    # [string]$VMName,
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


$VMName = Read-Host "Enter a name for the VM and its resources"
$Username = Read-Host "Enter a username for VM"
$Password = Read-Host "Enter a Password for VM" -AsSecureString
$resourceGroupName = -join("$VMName","-RG")
$myip = Invoke-WebRequest 'http://ifconfig.me/ip' -UseBasicParsing
$myip = $myip.Content
$VNETName = -join("$VMName","-VNET")


$pubName = -join("$VMName","-IP")
$nsgName = -join("$VMName","-NSG")
$subnetName = -join("$VMName","-Subnet")


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
    Write-Output "Az is incompatible with the discontinued AzureRM module."
    Write-Output "If installed, AzureRM will be removed."
    Uninstall-AzureRm 

    if(!( Get-InstalledModule -Name Az)) { Write-Output "Az module not found, please wait while it is installed..."; Install-Module Az }
    Write-Output  "Az module found. Importing to session."
    Import-Module Az
    Write-Output "Checking if you are authenticated with Azure..." 
    Write-Output "If you are prompted to sign in, please continue using credentials with correct permissions."
    if(!(get-azcontext)){ Connect-AzAccount }
    $sub = Get-AzSubscription 
    $tenant = Get-AzTenant

    Write-Output "You are now signed in to $tenant $sub"  
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
        Write-Output "Checking if Resource Group exists with that name."
        if(!(Get-AzResourceGroup -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue))
        {
          Write-Output "Creating new Resource Group $resourceGroupName"  
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

    $rule4 = New-AzNetworkSecurityRuleConfig -Name allow-myip-udp -Description "Allow all inbound UDP traffic from $myip" `
    -Access Allow -Protocol Udp -Direction Inbound -Priority 300 -SourceAddressPrefix $myip `
    -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange "*"

    # Deny Rules

    $rule6 = New-AzNetworkSecurityRuleConfig -Name tcp-deny-all -Description "Deny all inbound TCP traffic" `
    -Access Deny -Protocol Tcp -Direction Inbound -Priority 401 -SourceAddressPrefix "*" `
    -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange "*"

    $rule7 = New-AzNetworkSecurityRuleConfig -Name udp-deny-all -Description "Deny all inbound UDP traffic" `
    -Access Deny -Protocol Udp -Direction Inbound -Priority 402 -SourceAddressPrefix "*" `
    -SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange "*"
    
    Write-Output "Creating Network Security Group"
    $nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $location -Name `
    $nsgName -SecurityRules $rule0,$rule4,$rule6,$rule7

    # $subnet = New-AzVirtualNetworkSubnetConfig `
    #  -Name $subnetName `
    #  -AddressPrefix "10.0.1.0/24"

    # Create VNET
    function Create-Networking {
        Write-Output "Creating Virtual network $VNETName and VM subnet $subnetName"
        
    # Create a PSSubnet object
    $subnet = New-AzVirtualNetworkSubnetConfig `
    -Name $subnetName `
    -AddressPrefix "10.0.1.0/24"

    # Create the virtual network and subnet
    New-AzVirtualNetwork `
        -Name $VNETName `
        -ResourceGroupName $resourceGroupName `
        -Location "EastUS" `
        -AddressPrefix "10.0.0.0/16" `
        -Subnet $subnet `
        -Verbose
    }
    Create-Networking

    $VNet = Get-AzVirtualNetwork -Name $VNETName
    $subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $VNet | Select-Object Name,AddressPrefix
    $VNetSubnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $VNETName -Name $subnetName

    # Apply NSG to Subnet
    Write-Output "Applying NSG to Subnet"
    Set-AzVirtualNetworkSubnetConfig -Name $VNetSubnet.Name -VirtualNetwork $VNet -AddressPrefix $VNetSubnet.AddressPrefix -NetworkSecurityGroup $nsg


    # Update the VNET
    Write-Output "Updating Virtual Network with config"
    $VNet | Set-AzVirtualNetwork


    # Convert password into string for the command
    $passwordPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
    # Create VM
    function Deploy-VM {

        # Create the virtual machine
             New-AzVM `
            -ResourceGroupName $resourceGroupName -Name $VMName -Image $image `
            -GenerateSshKeys -Credential (New-Object System.Management.Automation.PSCredential($Username, $Password)) `
            -VnetName $VNETName -SubnetName $VMName -PublicIpAddressName $pubName -PublicIpAllocationMethod Dynamic -PublicIpSku Standard
    }
    $vm = Deploy-VM

}
elseif ($Destroy) {
    $resourceGroupName = -join("$VMName","-RG")
    Remove-AzResourceGroup -Name $resourceGroupName
}

Write-Output "Your VM's connection information:"
Write-Output $vm
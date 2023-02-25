$location = "East US"
$subscription = Get-AzSubscription
$tenant = Get-AzTenant
$tenantName = "Sludge"
$VMName = 'BlastBox'
$resourceGroupName = -join("$VMName","-RG")
$myip = curl 'http://ifconfig.me/ip'
$VNETName = -join("$VMName","-VNET")
$pubName = -join("$VMName","-IP")
$nsgName = -join("$VMName","-NSG")
$subnetName = -join("$VMName","-Subnet")
$win10image = "MicrosoftWindowsDesktop:Windows-10:21h1-ent:latest"
$server22 = 'Win2022Datacenter'
$soundssketchy = $VMName+33892023
$user = "mellonaut"

# if args contain either server or win10, image becomes that variable
$image = $win10image 

# Get connected to Azure
function Set-Context {
    if(!(Get-Module -ListAvailable -Name Azure)) { Install-Module Az; Import-Module Az }
    if(!(get-azcontext)){ Connect-AzAccount } 
  }
  Set-Context

# CHeck for the RG, Create it if not exists
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

    $rule1 = New-AzNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 300 -SourceAddressPrefix `
    $myip.ToString() -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389

    $rule2 = New-AzNetworkSecurityRuleConfig -Name web-rule -Description "Allow HTTP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 400 -SourceAddressPrefix `
    $myip.ToString() -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80, 443

    $rule3.ToString() = New-AzNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow SMB" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 301 -SourceAddressPrefix `
    $myip -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 445

    $nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $location -Name `
    "Homeward-Bound" -SecurityRules $rule1,$rule2,$rule3 

    # Create VNET
    function Create-Networking {
      # $frontendSubnet       = New-AzVirtualNetworkSubnetConfig -Name FrontEnd -AddressPrefix "10.0.1.0/24" -NetworkSecurityGroup $nsg
      # $backendSubnet        = New-AzVirtualNetworkSubnetConfig -Name BackEnd  -AddressPrefix "10.0.2.0/24" -NetworkSecurityGroup $nsg
      # $subName              = $frontendSubnet.name
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

    # Create VM
    function Create-VM {
      az vm create --name $VMName --resource-group $resourceGroupName --image $image --generate-ssh-keys --admin-username $user --admin-password $soundssketchy --vnet-name $VNETName --subnet $VMName --public-ip-sku Standard
    }
    $vm = Create-VM 




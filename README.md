# BlastBox II

## Private test machines on the fly

### Overview
Provide a Name, -windows10 or -server2022, admin username (and optionally password) and whether to -deploy or -destroy.

If the legacy AzureRM module is installed, it will be removed as it cannot exist side-by-side with the new Az module.

If the Az powershell module isnt installed, it will be and will be imported.

If not connected to azure, script will prompt you to sign in to whichever tenant you have rights to deploy on.

Deploys to "East US" Location by default. Can be changed by specifying "-location centralus", for example.

Image is selected with "-windows10" or "-server2022", with windows11 on the map.
Alterantely, images can be specified using the "-image" flag and the image resource, but this is mmore for testing than a supported feature. It may take some fiddling to get this to work with a managed image or shared image but it's something in the works.

Resource Group is created from the VMName, as well as the VNET, subnet and NSG.

Powershell retrieves your current public IP address and uses this to create rules to allow all traffic from your location and deny rules for anything else.

NSG allow rules are applied at the subnet level.

VM is created into the VNet and subnet behind the NSG, using the admin username and password.

RDP session will be initiated to the machine after it is finished deploying. 


### Deploy
Open powershell.exe, navigate to the folder and run:

```
# Windows 10:

Set-ExecutionPolicy Bypass .\BlastBox.ps1 -windows10 -deploy

# Specify alternate location

Set-ExecutionPolicy Bypass .\BlastBox.ps1 -windows10 -deploy -location centralus
 
# Server 2022:

Set-ExecutionPolicy Bypass .\BlastBox.ps1 -server2022 -deploy

# Specify alternate location

Set-ExecutionPolicy Bypass .\BlastBox.ps1 -server2022 -deploy -location centralus
```

### Destroy
Use the destroy flag to deallocate and destroy the VM with it's associated Resources and Resource Group, including networking.
```
# Windows 10

Set-ExecutionPolicy Bypass .\BlastBox.ps1 -server2022 -destroy

# Server 2022

Set-ExecutionPolicy Bypass .\BlastBox.ps1 -windows10 -destroy
```
## NOTE: Running Destroy will deallocate the VM first, then ask if you want to delete, allowing you to pause and save a few dollars on compute cost if you aren't ready to delete yet.


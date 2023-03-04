# BlastBox II

## Private test machines on the fly. Run scripts, click links, go nuts.

### Overview
Provide a Name, -windows10 or -server2022, admin username (and optionally password) and whether to -deploy or -destroy.

If the legacy AzureRM module is installed, it will be removed as it cannot exist side-by-side with the new Az module.

If the Az powershell module isnt installed, it will be and will be imported.

If not connected to azure, script will prompt you to sign in to whichever tenant you have rights to deploy on.

![image](https://user-images.githubusercontent.com/65114647/222898992-2d2bfdb3-8f5b-4946-b05d-207ea9a7ed02.png)

It will ask you to specify a username and password for the admin user and will continue on from there:

![image](https://user-images.githubusercontent.com/65114647/222898910-331457ac-3285-4586-a7a4-eb4e83aa72da.png)


Deploys to "East US" Location by default. At this time "-location" can be specified on the command line but it wont find your network security group and the machine will not have the security rules applied.

Image is selected with "-windows10" or "-server2022", with windows11 on the map.
Alterantely, images can be specified using the "-image" flag and the image resource, but this is mmore for testing than a supported feature. It may take some fiddling to get this to work with a managed image or shared image but it's something in the works.

Resource Group is created from the VMName, as well as the VNET, subnet and NSG.

Powershell retrieves your current public IP address and uses this to create rules to allow all traffic from your location and deny rules for anything else.

NSG allow rules are applied at the subnet level.

VM is created into the VNet and subnet behind the NSG, using the admin username and password.

RDP session will be initiated to the machine after it is finished deploying.

![image](https://user-images.githubusercontent.com/65114647/222898395-9bf55639-0b4e-49d4-8707-f678e0a1b0ca.png)

Resources can be deallocated or destroyed by pressing up arrow on your keyboard and changing -deploy to -destroy:

![image](https://user-images.githubusercontent.com/65114647/222897627-9f6429a2-e274-4f3a-830b-f11e70123e0b.png)

![image](https://user-images.githubusercontent.com/65114647/222898434-da5e7058-3e3d-4590-a1b6-dbe8738f8ef6.png)


### Deploy
Open powershell.exe, navigate to the folder and run:

```
# Windows 10:

Set-ExecutionPolicy Bypass .\BlastBox.ps1 -windows10 -deploy

 
# Server 2022:

Set-ExecutionPolicy Bypass .\BlastBox.ps1 -server2022 -deploy

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


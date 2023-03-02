# BlastBox II

Provide a Name, -windows10 or -server2022, admin username (and optionally password) and whether to -deploy or -destroy.

If the legacy AzureRM module is installed, it will be removed as it cannot exist side-by-side with the new Az module.

If the Az powershell module isnt installed, it will be and will be imported.

If not connected to azure, script will prompt you to sign in to whichever tenant you have rights to deploy on.

Resource Group is created from the VMName, as well as the VNET, subnet and NSG.

Powershell retrieves and stores your current public IP in a variable and creates Network Security Group rule configurations to allow all TCP and UDP traffic from your IP only.

NSG allow rules are applied at the subnet level.

VM is created into the VNet and subnet behind the NSG, using the admin username and password.

Public IP and VM information will be displayed and an RDP session initiated.

Included is my RepeatOffender scirpt that installs Rasta's CRTO course VM's tools for red teaming, then a bunch of malware development and reversing tools, sysmon, and some configuration.

# Deploy
Open powershell.exe, navigate to the folder and run:

```
# Windows 10:

Set-ExecutionPolicy Bypass .\BlastBox2023.ps1 -windows10 -deploy
 
# Server 2022:

Set-ExecutionPolicy Bypass .\BlastBox2023.ps1 -server2022 -deploy

```

# Destroy
Use the destroy flag to deallocate and destroy the VM with it's associated Resources and Resource Group, including networking.

Set-ExecutionPolicy Bypass .\BlastBox2023.ps1 -server2022 -destroy
Set-ExecutionPolicy Bypass .\BlastBox2023.ps1 -windows10 -destroy

NOTE: Running Destroy will deallocate the VM first, then ask if you want to delete, allowing you to save your progress and a few dollars on compute cost

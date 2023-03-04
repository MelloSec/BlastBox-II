# BlastBox II

## Private test machines on the fly

### Overview
Provide a Name, -windows10 or -server2022, admin username (and optionally password) and whether to -deploy or -destroy.

If the legacy AzureRM module is installed, it will be removed as it cannot exist side-by-side with the new Az module.

If the Az powershell module isnt installed, it will be and will be imported.

If not connected to azure, script will prompt you to sign in to whichever tenant you have rights to deploy on.

Resource Group is created from the VMName, as well as the VNET, subnet and NSG.

Powershell retrieves your current public IP address and uses this to create rules to allow all traffic from your location and deny rules for anything else.

NSG allow rules are applied at the subnet level.

VM is created into the VNet and subnet behind the NSG, using the admin username and password.

RDP session will be initiated to the machine after it is finished deploying. 

Included is a "Scripts" folder with some scripts for installing windows features, tools and monitoring agents.

Sysmon.ps1 will install sysmon using the Swift-on-Security configuration

Including are scripts to install the Log Analytics agent and the Microsoft Monitoring Agent for onboarding to Sentinel

Server-Tools.ps1 should install a domain controller with IIS server, chocolatey, vscode, git and sysinternals

RunMe.ps1 is just a convenience script that will download, extract and run the ChocoLoader and Repeat Offender scripts to install chocolatey and a bunch of security stuff.

Choco-Loader/RepeatOffender contains Rasta Mouse Certified Red Team Operator course VM as the base, then installs malware development and analysis tools that I like to use from there. 
It's muy janky, it doesnt pick git up in path and you have to run the rest of that script again from a new console window. Will bew fixed in the future. 

## Usage
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
## NOTE: Running Destroy will deallocate the VM first, then ask if you want to delete, allowing you to save your progress and a few dollars on compute cost


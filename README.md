# BlastBox II

Provide a Name, image, admin username (and optionally password) and whether to -deploy or -destroy.

If the Azure powershell module isnt installed, it will be and will be imported.

If not connected to azure, script will prompt you to sign in.

Resource Group is created from the name, as well as the VNET, subnet and NSG.

Curl stores your current public IP in a variable and creates Network Security Group rule configurations to allow RDP, web and SMB access to your IP only.

NSG allow rules are applied at the subnet level.

VM is created into the VNet and subnet behind the NSG, using the admin username, if no password provided the password will become the VM's name + 3389 and 2023 for the year.

Public IP will be displayed, RDP in and enjoy.

Included is my RepeatOffender scirpt that installs Rasta's CRTO course VM's tools for red teaming, then a bunch of malware development and reversing tools, sysmon, and some configuration.

# Usage
Open powershell.exe, navigate to the folder and run:

```
Windows 10:
Set-ExecutionPolicy Bypass .\BlastBox2023.ps1 -image windows10 -username Radmin -deploy

With Custom Password:
Set-ExecutionPolicy Bypass .\BlastBox2023.ps1 -image windows10 -username Radmin -password Sup3rS3cur3 

Server 2022:
Set-ExecutionPolicy Bypass .\BlastBox2023.ps1 -image server2022 -username Radmin 

With Custom Password:
Set-ExecutionPolicy Bypass .\BlastBox2023.ps1 -image server2022 -username Radmin -password Sup3rS3cur3

Destroy the RG and VM:
Set-ExecutionPolicy Bypass .\BlastBox2023.ps1 -Destroy

```

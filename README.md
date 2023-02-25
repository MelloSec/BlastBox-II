# BlastBox II

Provide a Name, image, admin username (and optionally password) and whether to -deploy or -destroy.

Resource Group is created from the name, as well as the VNET, subnet and NSG.

Curl stores your current public IP in a variable and creates Network Security Group rule configurations to allow RDP, web and SMB access to your IP only.

NSG allow rules are applied at the subnet level.

VM is created into the VNet and subnet behind the NSG, using the admin username, if no password provided the password will become the VM's name + 3389 and 2023 for the year.

Public IP will be displayed, RDP in and enjoy.

Included is my RepeatOffender scirpt that installs Rasta's CRTO course VM's tools for red teaming, then a bunch of malware development and reversing tools, sysmon, and some configuration.

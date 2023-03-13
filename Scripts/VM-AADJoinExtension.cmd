#!/bin/bash

myResourceGroup="blastBox"
VMName="blastbox"
vmFree="Standard_B1s" # for a cheap size
vmDefault="Standard_D2_v3" # for a free size
username="mellonaut"

az group create --name $myResourceGroup --location $location

az vm create \
    --resource-group $myResourceGroup \
    --name $VMName \
    --image Win2019Datacenter \
    --size $vmFree \
    --assign-identity \
    --admin-username $username

az vm extension set \
    --publisher Microsoft.Azure.ActiveDirectory \
    --name AADLoginForWindows \
    --resource-group $myResourceGroup \
    --vm-name $VMName

az vm extension set \
    --publisher Microsoft.Compute \
    --name CustomScriptExtension \
    --vm-name $VMName \
    --resource-group $myResourceGroup \
    --settings '{\"fileUris\": [\"https://raw.githubusercontent.com/mellosec/blastbox-ii/scripts/repeatoffender/choco-loader.ps1\"], \"commandToExecute\": \"powershell.exe -ExecutionPolicy Unrestricted -File choco-loader.ps1\"}' \
    --protected-settings '{}' \
    --version 1.10

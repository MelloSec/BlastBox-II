location="eastus"
myResourceGroup="blastBox"
VMName="blastbox"

az group create --name $myResourceGroup --location $location

az vm create \
    --resource-group myResourceGroup \
        --name $VMName \
	    --image Win2019Datacenter \
	        --assign-identity \
		    --admin-username azureuser \
		        --admin-password yourpassword

az vm extension set \
    --publisher Microsoft.Azure.ActiveDirectory \
        --name AADLoginForWindows \
	    --resource-group $myResourceGroup \
	        --vm-name $VMName


az account set --subscription "Cargolux Production"

snapshotId=$(az snapshot show --name cv-t-checkmk-01-os-disk-snapshot --resource-group cv-p-checkmk --query [id] -o tsv)
az disk create --resource-group cv-p-checkmk --name cv-p-checkmk-01-os-disk --sku StandardSSD_LRS --size-gb 4 --source $snapshotId --tags chgnumber=CHG0032945
az disk create --resource-group cv-p-checkmk --name cv-p-checkmk-02-os-disk --sku StandardSSD_LRS --size-gb 4 --source $snapshotId --tags chgnumber=CHG0032945

nsgid="/subscriptions/b2d8baaf-07a2-4653-993d-44bb07e0638f/resourceGroups/cv-p-nsg/providers/Microsoft.Network/networkSecurityGroups/cv-p-checkmk-nsg"
subnetid=$(az network vnet subnet show --resource-group cv-p-vnet --name cv-p-checkmk-app-snet --vnet-name cv-p-checkmk-vnet --query id -o tsv)
az vm create --resource-group cv-p-checkmk --location westeurope --name cv-p-checkmk-01 --os-type linux --attach-os-disk cv-p-checkmk-01-os-disk --boot-diagnostics-storage cvpcheckmkdiag --attach-data-disks cv-p-checkmk-01-datadisk-01 --subnet $subnetid --availability-set cv-p-checkmk-avail --public-ip-address "" --private-ip-address "10.119.2.167" --size Standard_B2s --nsg $nsgid --tags chgnumber=CHG0032945 description="CheckMK Monitoring Server"
az vm create --resource-group cv-p-checkmk --location westeurope --name cv-p-checkmk-02 --os-type linux --attach-os-disk cv-p-checkmk-02-os-disk --boot-diagnostics-storage cvpcheckmkdiag --attach-data-disks cv-p-checkmk-02-datadisk-01 --subnet $subnetid --availability-set cv-p-checkmk-avail --public-ip-address "" --private-ip-address "10.119.2.168" --size Standard_B2s --nsg $nsgid --tags chgnumber=CHG0032945 description="CheckMK Monitoring Server"
#Provide the subscription Id of the subscription where managed disk exists
sourceSubscriptionId="e87ebe57-8537-492f-8cb3-88e158940991"

#Provide the name of your resource group where managed disk exists
sourceResourceGroupName="CV-T-CHECKMK"

#Provide the name of the managed disk
managedDiskName="cv-t-checkmk-01-temp-os-disk"

#Set the context to the subscription Id where managed disk exists
az account set --subscription $sourceSubscriptionId

#Get the managed disk Id 
managedDiskId=$(az disk show --name $managedDiskName --resource-group $sourceResourceGroupName --query [id] -o tsv)

#If managedDiskId is blank then it means that managed disk does not exist.
echo 'source managed disk Id is: ' $managedDiskId

#Provide the subscription Id of the subscription where managed disk will be copied to
targetSubscriptionId="b2d8baaf-07a2-4653-993d-44bb07e0638f"

#Name of the resource group where managed disk will be copied to
targetResourceGroupName="cv-p-checkmk"

#Set the context to the subscription Id where managed disk will be copied to
az account set --subscription $targetSubscriptionId

#Copy managed disk to different subscription using managed disk Id
az disk create --resource-group $targetResourceGroupName --name $managedDiskName --source $managedDiskId --tags chgnumber=CHG0032945
param (
    # An object representing the data that was posted to the webhook
    # that executes this runbook.
    [Object]$WebhookData
)
 
Write-Output "Authenticating to Azure with service principal and certificate"
# Ensures that any credentials apply only to the execution of this runbook
Disable-AzContextAutosave –Scope Process

# # Connect to Azure with Run As account
# $ServicePrincipalConnection = Get-AutomationConnection -Name 'AzureRunAsConnection'

# Connect-AzAccount `
#     -ServicePrincipal `
#     -Tenant $ServicePrincipalConnection.TenantId `
#     -ApplicationId $ServicePrincipalConnection.ApplicationId `
#     -CertificateThumbprint $ServicePrincipalConnection.CertificateThumbprint

# $AzContext = Select-AzSubscription -SubscriptionId $ServicePrincipalConnection.SubscriptionID
# Set-AzContext $AzContext

#Connect to Azure using the managed identity of the automation account
Connect-AzAccount -Identity -AccountId "e10f4d88-e7b1-4dc1-92c2-71a9e8cb7a5e" # -Subscription "44de461f-188c-4a56-b3b4-4066756244de" -Tenant "25d39a9f-4441-46a3-866d-2fff6951bd08"

$today = Get-Date -UFormat "%m_%d_%Y_%T"| Foreach-Object {$_ -replace ":", "_"}
$resourceGroupName = "CV-D-DRAKON-HUB_ADMINPB"
$vmName="cv-d-drakon-hub-1"
$Location = "West Europe"
$snapshotName = "osdisk-snap-$today"
 
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
$snapshot = New-AzSnapshotConfig -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id -Location $location -CreateOption copy
New-AzSnapshot -Snapshot $snapshot -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName

Write-Output "Snapshot done"


# Disconnect from Azure
Disconnect-AzAccount
$today = Get-Date -UFormat "%m_%d_%Y_%T"| Foreach-Object {$_ -replace ":", "_"}

Write-Host "Creating the following snapshot: osdisk-snap-$today"

az account set -s "44de461f-188c-4a56-b3b4-4066756244de"
az snapshot create --resource-group cv-d-adminvm --name osdisk-snap-$today --source osdisk

Write-Host "Snapshot done"
$filePath = Get-Location
$curr_file = "serverlist" 
$today = Get-Date -UFormat "%m_%d_%Y"
$iterationCount = 0
$prev_file="$curr_file$today"

if (Test-Path -Path $curr_file -PathType Leaf) {
    rm $prev_file
    mv  $curr_file $prev_file
} else {
    Write-Host "File does not exist at $filePath.`n`n"
}

Write-Host @'

Load the list of VMs in serverlist file
---------------------------------------

'@

# Read the file, split by tabs, and select the first column
(az vm list --output table | Select-Object -Skip 2 ) | ForEach-Object {
    $iterationCount++
    $columns = $_ -split " "  # Backtick-t represents a tab character
    $columns[0]>>$curr_file
 
}

Write-Host " Load DONE `n "

Write-Host @'
Count of VMs in the infrastructure
----------------------------------

'@
Write-Host $iterationCount "VMs"

Write-Host @'

Compare with the previous execution
-----------------------------------

'@
# Compare the contents of the two files
$comparisonResult = Compare-Object -ReferenceObject (Get-Content $curr_file) -DifferenceObject (Get-Content $prev_file)

# Check the result
if ($comparisonResult -eq $null) {
    Write-Host "The files are identical."
} else {
    # Display the differences
    foreach ($difference in $comparisonResult) {
        if ($difference.SideIndicator -eq "=>") {
            Write-Host "Only in $curr_file : $($difference.InputObject)"
        } elseif ($difference.SideIndicator -eq "<=") {
             Write-Host "Only in $prev_file : $($difference.InputObject)"
    }
}
}


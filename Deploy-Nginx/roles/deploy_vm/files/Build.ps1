param (
    $NodeFQDN,
    $Name,
    $VMID,
    $Node,
    $memory,
    $sockets,
    $ipconfig0,
    $ipconfig1,
    $net1,
    $password,
    $Username,
    $Token,
    $TokenName
)

# Define the root path
$rootPath = Split-Path -Path $PSScriptRoot -Parent

# Connect to the Proxmox cluster
& $PSScriptRoot/Connect.ps1 -node $NodeFQDN -Username $Username -TokenName $TokenName -Token $Token | Out-Null

# Define a flag to track if any changes were made
$changesMade = $false

# Build VM from clone
# Check if VM exists before trying to clone
$vmExists = & $PSScriptRoot/CloneFrom-Template.ps1 -Name $Name -VMID $VMID -Node $Node

if ($vmExists -notlike "*exists") {
    $changesMade = $true
}

# Function to check and update VM configuration
function CheckAndUpdate-VMConfig {
    param ($maxRetries = 3)
    
    $retryCount = 0
    while ($retryCount -lt $maxRetries) {
        # Check VM configuration
        $test = & $PSScriptRoot/Review-VMConfig.ps1 -Node $Node -VMID $VMID -NodeFQDN $NodeFQDN -memory $memory -sockets $sockets -ipconfig0 $ipconfig0 -ipconfig1 $ipconfig1

        if (($test -eq "Match") -and ($retryCount -eq 0)) {
            #Write-Host "Configuration matches."
            return "Match1"
        } elseif (($test -eq "Match") -and ($retryCount -gt 0)){
            #Write-Host "Configuration matches."
            return "MatchN"
        }
        else {
            Write-Host "Configuration does not match. Updating..."

            # Update VM configuration
            $keys = & $PSScriptRoot/Get-Token.ps1 -password $password -NodeFQDN $NodeFQDN
            & $PSScriptRoot/Set-Config.ps1 -Node $Node -VMID $VMID -NodeFQDN $NodeFQDN -memory $memory -net1 $net1 -sockets $sockets -ipconfig0 $ipconfig0 -ipconfig1 $ipconfig1 -CSRFPreventionToken $keys.data.CSRFPreventionToken -PVEAuthCookie $keys.data.ticket
        }

        $retryCount++
        Start-Sleep -Seconds 10  # Wait for a few seconds before rechecking
    }

    Write-Host "Maximum retries reached. Configuration might not match."
    Exit 1
}

$configMade = CheckAndUpdate-VMConfig
# Check and update VM configuration
if ($configMade -eq "Match1") {
    #Write-Host "Configuration matches."
} else {
   # Write-Host "Configuration change."
    $changesMade = $true
}

# Check VM power status and turn it on if necessary
$vmPoweredOn = & $PSScriptRoot/Initiate-VM.ps1 -VMID $VMID

if ($vmPoweredOn -eq "Started") {
    $changesMade = $true
}

# Output the result based on whether changes were made
if ($changesMade) {
    
    Write-Output "Changes made"
} else {
    Write-Output "No changes needed"

}

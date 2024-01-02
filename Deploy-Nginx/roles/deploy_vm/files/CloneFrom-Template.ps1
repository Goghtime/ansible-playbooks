
param (
    $Name,
    $VMID,
    $TemplateID = 1000,
    $Node,
    $Storage = "ProxiSCSI"
)

Import-module Corsinvest.ProxmoxVE.Api

# Function to check if the VM lock is released
function Wait-VMUnlock {
    param (
        [Parameter(Mandatory=$true)]
        [int]$VMID
    )

    $timeout = [System.DateTime]::Now.AddMinutes(15)  # Set a 15-minute timeout

    while ($true) {
        try {
            $status = (Get-PveVm -VmIdOrName $VMID).lock
        } catch {
            Write-Error "Failed to get VM status: $_"
            exit 1
        }

        if ($status -ne "clone") {
            Write-Host "VM lock is released. Proceed with further steps."
            return  # Exit the function
        }

        if ([System.DateTime]::Now -ge $timeout) {
            # Timeout reached, throw an error
            Write-Error "Timeout reached while waiting for VM lock to release."
            exit 1
        }

        Write-Host "Cloning in progress..."
        Start-Sleep -Seconds 10  # Adjust the sleep duration as needed
    }
}

try {
    $GetStatus = Get-PveVm -VmIdOrName $VMID

    if ($null -ne $GetStatus) {
        Write-Output "$($GetStatus.name) exists"
        Exit 0
    } else {
        New-PveNodesQemuClone -Vmid $TemplateID -Full -Node $Node -Name $Name -Storage $Storage -Newid $VMID
        Start-Sleep -Seconds 30
        Wait-VMUnlock -VMID $VMID
    }

    Write-Output "VM Cloned"
    # If the script reaches this point without errors, exit with 0
    Exit 0
} catch {
    Write-Error "An error occurred: $_"
    Exit 1
}


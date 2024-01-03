param (
    $VMID
)

Import-module Corsinvest.ProxmoxVE.Api

# Start the VM
$status = Get-PveVm -VmIdorName $VMID

if ($status.status -eq "stopped") {
    $start = Start-PveVm -VmIdorName $VMID
    Start-Sleep -Seconds 120
    if ($start.StatusCode -eq 200){
        Write-Output "Started"
        Exit 0
    } else {
        $start.StatusCode
        Exit 1
    }
} elseif ($status.status -eq "running"){
    Write-Output "Running"
    Exit 0
} else {
    Write-Output "Unexpected state"
    Exit 1
}



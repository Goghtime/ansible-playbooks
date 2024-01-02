param (  
    $Node,
    $VMID,
    $NodeFQDN,
    $memory,
    $sockets,
    $ipconfig0,
    $ipconfig1
)

Import-module Corsinvest.ProxmoxVE.Api

$data = Get-PveNodesQemuConfig -Vmid $VMID -node $Node

if (($memory -eq ($data.Response.data.memory)) -and 
    ($sockets -eq ($data.Response.data.sockets)) -and 
    ($null -ne ($data.Response.data.net1)) -and 
    ($ipconfig0 -eq ($data.Response.data.ipconfig0)) -and 
    ($ipconfig1 -eq ($data.Response.data.ipconfig1))) {
    Write-Output "Match"
    exit 0
} else {
    Write-Output "No match"
    exit 0
}

# If you reach here, it indicates an unexpected issue
Write-Output "Unexpected error occurred"
exit 2

param (
    $Node,
    $VMID,
    $NodeFQDN,
    $PVEAuthCookie,
    $CSRFPreventionToken,
    $memory,
    $sockets,
    $ipconfig0,
    $net1,
    $ipconfig1
)

$uri = "https://$NodeFQDN`:8006/api2/json/nodes/$node/qemu/$vmid/config"

# Define headers
$headers = @{
    "Cookie" = "PVEAuthCookie=$PVEAuthCookie"
    "CSRFPreventionToken" = "$CSRFPreventionToken"
}

# Prepare the body
$body = @{
    "memory" = $memory
    "sockets" = $sockets
    "ipconfig0" = $ipconfig0
    "net1" = $net1
    "ipconfig1" = $ipconfig1
} | ConvertTo-Json
$response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body -ContentType "application/json" -SkipCertificateCheck
    
$response


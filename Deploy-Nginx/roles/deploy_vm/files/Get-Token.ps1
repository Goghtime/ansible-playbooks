
param (
    $NodeFQDN,
    $username = "root%40pam",
    $password
)

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/x-www-form-urlencoded")

$body = "username=$username&password=$password"

$response = Invoke-RestMethod "https://$NodeFQDN`:8006/api2/json/access/ticket" -Method 'POST' -Headers $headers -Body $body -SkipCertificateCheck
$response

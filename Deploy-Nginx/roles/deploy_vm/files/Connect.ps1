param(
    [ValidateSet("192.168.100.80","192.168.100.81","192.168.100.82")]
    [string]$node,
    $Username,
    $Token,
    $TokenName
)

$login = $Username + "!" + $TokenName + "=" + $Token

Connect-PveCluster -HostsAndPorts $node -SkipCertificateCheck -ApiToken $login









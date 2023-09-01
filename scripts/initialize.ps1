param(
    [string]$node_name,
    [string]$ip_address
)

. /scripts/powershell/VMKeystrokes.ps1


$VM = $node_name
$username="admin"
$password="admin"
$newpassword="admin123"

$inputs = $username, $password, "", "y", "y", "n", $newpassword, $newpassword, "n", "config", "ethernet eth0", "ip-address ${ip_address}", "exit", "web-mgmt 0.0.0.0 9090", "ssh 0.0.0.0 22", "exit", "exit"

foreach($input in $inputs) {
	Start-Sleep -Seconds 1
	Set-VMKeystrokes -VMName $VM -StringInput $input -ReturnCarriage $true
}

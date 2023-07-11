. /scripts/powershell/VMKeystrokes.ps1

$vm = "APIConnect-datapower-1"
$username = "admin"
$password = "admin"
$newpassword = "admin123"
$ipcidr1 = "172.22.8.11/26" 
$gateway1 = "172.22.8.1"
$ipcidr2 = "172.22.8.76/26" 
$gateway2 = "172.22.8.65"
$dnsserver = "161.26.0.7"
$fqdn = "pr-apic-dpgw1.apic.nsb.local"
$ip2 = $ipcidr2.Substring(0, $ipcidr2.Length - 3)
$password_reset_user_password = "nsb@12345"

$inputs = $username, $password, "", "y", "y", "n", $newpassword, $newpassword, "y", "y", "y", "y", "n", $ipcidr1, $gateway1, "y", "n", $ipcidr2, $gateway2, "y", "y", "y", $dnsserver, "y", $fqdn, "y", "y", "y", $ip2, "22", "y", $ip2, "9090", "y", "password-reset-user", $password_reset_user_password, $password_reset_user_password, "y", "y", "ondisk", "n", "y", "y", "y"

foreach($input in $inputs) {
	Start-Sleep -Seconds 1
	Set-VMKeystrokes -VMName $VM -StringInput $input -ReturnCarriage $true
}

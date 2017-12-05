Import-Module ActiveDirectory

$OU = "OU=users,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net"

$users = Get-ADUser -Filter 'ProxyAddresses -like "*"' -Properties Name, proxyaddresses -SearchBase $OU
$users | FT
<#$proxies = $user.ProxyAddresses
$newProxies = @()

foreach ($proxy in $proxies) {
    if($proxy -like 'smtp:*@tarkett.com') {
        $newProxies += $proxy -replace "smtp", "SMTP"
    }
    elseif($proxy -like 'SMTP:*@desso.com') {
        $newProxies += $proxy.Replace("SMTP", "smtp")
    }
    else {
        $newProxies += $proxy
    }
}
$user.proxyaddresses = $newProxies
Set-ADUser $user -Replace @{ProxyAddresses=$newProxies}#>
Import-Module ActiveDirectory

$OU = "OU=users,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net"

$users = Get-ADUser -Filter 'Enabled -eq $False' -Properties Name, Enabled -SearchBase $OU #| Enable-ADAccount

$users | FT GivenName, Surname
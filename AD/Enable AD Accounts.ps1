Import-Module ActiveDirectory

$OU = "OU=users,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net"

$adminaccount = Read-Host "Enter _adr account"
$password = Read-Host "Enter password" -AsSecureString

$AdrAcc = "EU\" + $AdrAcc

$PSCredential = New-Object System.Management.Automation.PSCredential($adminaccount, $password)

$user = Get-ADUser -Filter 'Enabled -eq $False' -Properties Name, Enabled -Credential $PSCredential -SearchBase $OU | Enable-ADAccount


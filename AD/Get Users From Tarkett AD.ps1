Import-Module ActiveDirectory

#Single OU
$OU = "OU=users,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net"

$users = Get-ADUser -Filter 'Department -eq "Sales"' -Properties Name, Enabled -SearchBase $OU #| Enable-ADAccount



<#Multiple ou's
$OU=@('OU=users,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net','OU=users,OU=BE01_Holsbeek,OU=_EMEA,DC=eu,DC=intra-global,DC=net')
#$userSpecs = "OU=users,OU=BE04-Dendermonde," + $DEFAULTOU

$users = $ou | foreach { Get-ADUser -Filter 'Enabled -eq "True"' -Properties Name, Enabled -SearchBase $_ }
#>

$users | Sort-Object Name | FT Name, Enabled


#$users  = Get-ADUser -Filter 'Company -like "*Desso*"' -Properties * -SearchBase $DEFAULTOU | FT GivenName, sn, Name | Out-File C:\Users\doorenj\Desktop\accounts.txt

Import-Module ActiveDirectory

#Single OU
#$OU = "OU=users,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net"
$OU = "OU=Desso,OU=ExchangeContacts,DC=eu,DC=intra-global,DC=net"

#Enable accounts
#$users = Get-ADUser -Filter {(Name -like "doorenj")} -Properties * -SearchBase $OU #| Enable-ADAccount


#Change attribute AD User
#$users = Get-ADUser -Filter {(Division -notlike "*")} -Properties Division -SearchBase $OU #| % {Set-ADUser $_ -Division "EMEA"}

#Get-Contacts from Exchange
$contacts = Get-ADObject -Properties * -SearchBase $OU
$contacts


<#Multiple ou's
$OU=@('OU=users,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net','OU=users,OU=BE01_Holsbeek,OU=_EMEA,DC=eu,DC=intra-global,DC=net')
#$userSpecs = "OU=users,OU=BE04-Dendermonde," + $DEFAULTOU

$users = $ou | foreach { Get-ADUser -Filter 'Enabled -eq "True"' -Properties Name, Enabled -SearchBase $_ }
#>

#Export users from company to txt file
#$users  = Get-ADUser -Filter * -Properties * -SearchBase $OU | FT GivenName, sn, Name, Enabled | Out-File C:\Users\doorenj\Desktop\accounts.csv


#$users 

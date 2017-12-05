Import-Module ActiveDirectory

$time = (Get-Date).AddDays(-30)

#Single OU
$OU = "OU=Users,OU=Dendermonde,OU=Sites,DC=desso,DC=int"
$OUPC = "OU=Workstations,OU=Dendermonde,OU=Sites,DC=desso,DC=int"


$users = Get-ADUser -Filter {LastLogonDate -lt $time} -Properties LastLogonDate -SearchBase $OU #| Enable-ADAccount
#$computers = Get-ADComputer -Filter * -Properties LastLogonDate -SearchBase $OUPC


<#Multiple ou's
$OU=@('OU=users,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net','OU=users,OU=BE01_Holsbeek,OU=_EMEA,DC=eu,DC=intra-global,DC=net')
#$userSpecs = "OU=users,OU=BE04-Dendermonde," + $DEFAULTOU

$users = $ou | foreach { Get-ADUser -Filter 'Enabled -eq "True"' -Properties Name, Enabled -SearchBase $_ }
#>

$users | Sort-Object LastLogonDate | FT Name, LastLogonDate #| Export-Csv -NoTypeInformation -Path $env:USERPROFILE\Desktop\Users.csv
#$computers | Sort-Object LastLogonDate | Select-Object Name, LastLogonDate | Export-Csv -NoTypeInformation -Path $env:USERPROFILE\Desktop\Computers.csv


#$users  = Get-ADUser -Filter 'Company -like "*Desso*"' -Properties * -SearchBase $DEFAULTOU | FT GivenName, sn, Name | Out-File C:\Users\doorenj\Desktop\accounts.txt

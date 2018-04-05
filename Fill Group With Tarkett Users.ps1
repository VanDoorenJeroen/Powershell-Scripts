Import-Module ActiveDirectory
#Users OU & Group OU
$OU = "OU=users,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net"
$GROUPOU = "OU=Distribution Lists,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net"

#Get Users & Get group
$users = Get-ADUser -Filter * -Properties * -SearchBase $OU
$group = Get-ADGroup -Filter { Name -like "Desso Dendermonde" } -SearchBase $GROUPOU

#Fill Group with all found users
<#foreach ($user in $users)
{
    Add-ADGroupMember $group -Members $user
}#>
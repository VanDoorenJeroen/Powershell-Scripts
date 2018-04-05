Import-Module ActiveDirectory

$GroupName = "Desso Waalwijk"
$MembersFile = "C:\Users\doorenj\Desktop\Members.txt"
$UsersFile = "C:\Users\doorenj\Desktop\Users.txt"
$SEARCHBASE = "OU=Users,OU=NL02_Waalwijk,OU=_EMEA,DC=eu,DC=intra-global,DC=net"


$users = Get-ADUser -Filter * -Properties DistinguishedName -SearchBase $SEARCHBASE | Sort-Object Ascending | FT Distinguishedname 
#$users | Out-File -Filepath $UsersFile

#Get-ADGroupMember -identity $GroupName -Recursive | Get-ADUser -Property DisplayName | Select DisplayName,Name | Out-File -FilePath $LocationFile
$Groups = Get-ADGroup -Filter { GroupCategory -eq "Distribution" } -Properties Members | Where Name -eq $GroupName
#$members = $Groups.Members | Out-File -FilePath $MembersFile
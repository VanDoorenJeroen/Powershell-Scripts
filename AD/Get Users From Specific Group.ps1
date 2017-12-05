Import-Module ActiveDirectory

$GroupName = "GD_NL02_FormscapePDF_M"
$LocationFile = "C:\Users\doorenj\Desktop\Export.txt"

Get-ADGroupMember -identity $GroupName -Recursive | Get-ADUser -Property DisplayName | Select DisplayName,Name | Out-File -FilePath $LocationFile
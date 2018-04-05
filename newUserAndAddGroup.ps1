Import-Module ActiveDirectory
#Add user to AD with numbers and default pw Tarkett2017
<#for ($i = 36; $i -le 42; $i++){
New-ADUser -Name “BE04_Hydra0$i” -AccountPassword (ConvertTo-SecureString “Tarkett2017” -AsPlainText -Force) -ChangePasswordAtLogon $false -City "Dendermonde" -company “Desso NV” -DisplayName “Terminal 0$i, BE04 Hydra” -Enabled $true -SamAccountName "BE04_Hydra0$i" -Street "Robert Ramlotstraat 89" -Title "BE04 Hydra Terminal 0$i" -Path “OU=users,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net” -givenname "BE04" -surname "Hydra Terminal 0$i" -department “Production” -description “SERVICE : BE04DW700XX” -office “BE04-Dendermonde” -division "EMEA" -PostalCode "9200" -PasswordNeverExpires $true -manager doorenj -Country "BE" -UserPrincipalName ("BE04_Hydra0$i@eu.intra-global.net")
}#>


#Add User BE04_Hydra002 to group BE04_Production_Users
<#Add-ADGroupMember BE04_Production_Users BE04_Hydra002
#>


#Add multiple users to group
#CSV file needs to have first row header with 'Username' with all necessary usernames.
<#
$List = Import-Csv C:\Users\doorenj\Desktop\List.csv

foreach ($user in $List)
{
    $user.Username
    Add-ADGroupMember -Identity "BE04_Internet Users" -Member $user.Username
}#>
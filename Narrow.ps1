Import-Module ActiveDirectory

<#43 = Kantine, 46 = Tufting, 47 = TD, 48 = Ververij, 49 = Spinnerij, 42 = Safetyboard#>
$PC = "BE04DW80042"
#$PCs = @("BE04DW80043","BE04DW80046", "BE04DW80047", "BE04DW80048", "BE04DW80049", "BE04DW80042")
$USERPASSWORD = "Desso2016"

$ADMIN = Read-Host "Geef ADR accountnaam in"
$ADMINPW = Read-Host "Geef paswoord in" -AsSecureString
$ADMINCREDENTIALS = New-Object System.Management.Automation.PSCredential($ADMIN, $ADMINPW)

<# Multiple PC'S

<#Reset pw of all Narrow Service Accounts to Desso2016.
#Start Powershell with _adr account! (Testing with Credentials)
$OU = "OU=users,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net"
Write-Host "Starting to change password"
$users = Get-ADUser -Filter 'Name -like "*narrow*"' -SearchBase $OU
foreach ($user in $users) 
{
    Set-ADAccountPassword -Identity $user.SamAccountName -NewPassword (ConvertTo-SecureString -AsPlainText $USERPASSWORD -Force) -Credential $ADMINCREDENTIALS
}
Write-Host "Passwords changed"

Sleep -s 3



#Restart pc's
Write-Host "Rebooting pc's"
foreach($PC in $PCs)
{
    Restart-Computer -ComputerName $PC -Credential $ADMINCREDENTIALS -Force
}
Write-Host "All done"

#>

<# Single pc #>
$PC
Restart-Computer -ComputerName $PC -Credential $ADMINCREDENTIALS -Force
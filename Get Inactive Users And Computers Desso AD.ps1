Import-Module ActiveDirectory

#Aantal dagen dat de user/pc niet aangemeld is.
$time = (Get-Date).AddDays(-30)

#OU's waar er gezocht gaat worden
$OU = "OU=Users,OU=Waalwijk,OU=Sites,DC=desso,DC=int"
$OUPC = "OU=Workstations,OU=Waalwijk,OU=Sites,DC=desso,DC=int"

#Users en pc's ophalen op basis van laatst aangemeld
$users = Get-ADUser -Filter { LastLogonDate -lt $time -and Enabled -eq $true } -Properties LastLogonDate -SearchBase $OU
$computers = Get-ADComputer -Filter { LastLogonDate -lt $time -and Enabled -eq $true } -Properties LastLogonDate -SearchBase $OUPC

#Wegschrijven in CSV op bureaublad
$users | Sort-Object LastLogonDate | Select-Object Name, LastLogonDate | Export-Csv -NoTypeInformation -Path $env:USERPROFILE\Desktop\Users.csv
$computers | Sort-Object LastLogonDate | Select-Object Name, LastLogonDate | Export-Csv -NoTypeInformation -Path $env:USERPROFILE\Desktop\Computers.csv

Import-Module ActiveDirectory

#Aantal dagen dat de user/pc niet aangemeld is.
$time = (Get-Date).AddDays(-90)


#OU's waar er gezocht gaat worden
<#$OU = "OU=users,OU=NL02_Waalwijk,OU=_EMEA,DC=eu,DC=intra-global,DC=net"
$OUPC = "OU=Computers,OU=NL02_Waalwijk,OU=_EMEA,DC=eu,DC=intra-global,DC=net"#>
$OU = "OU=users,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net"
$OUPC = "OU=Computers,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net"


#Users en pc's ophalen op basis van laatst aangemeld
$users = Get-ADUser -Filter { LastLogonDate -lt $time -and Enabled -eq $true } -Properties LastLogonDate -SearchBase $OU
$computers = Get-ADComputer -Filter { LastLogonDate -lt $time -and Enabled -eq $true } -Properties Description, LastLogonDate -SearchBase $OUPC
$computers | FT Name, Description, LastLogonDate


#Wegschrijven in CSV op bureaublad
$users | Sort-Object LastLogonDate | Select-Object Name, LastLogonDate | Export-Csv -NoTypeInformation -Path $env:USERPROFILE\Desktop\Users.csv
$computers | Sort-Object LastLogonDate | Select-Object Description, Name, LastLogonDate | Export-Csv -NoTypeInformation -Path $env:USERPROFILE\Desktop\Computers.csv
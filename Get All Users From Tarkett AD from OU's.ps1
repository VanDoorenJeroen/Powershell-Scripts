Import-Module ActiveDirectory
$gekozenOU = "Users"
#$OU = "OU=users,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net"
$searchBaseUser = @()
$searchBaseUser += 'OU='+$gekozenOU+',OU=NL01_Oosterhout,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Oosterhout
$searchBaseUser += 'OU='+$gekozenOU+',OU=NL02_Waalwijk,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Waalwijk
$searchBaseUser += 'OU='+$gekozenOU+',OU=NL03_Goirle,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Goirle
$searchBaseUser += 'OU='+$gekozenOU+',OU=NL04_Oss,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Oss
$searchBaseUser += 'OU='+$gekozenOU+',OU=BE01_Holsbeek,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Holsbeek
$searchBaseUser += 'OU='+$gekozenOU+',OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Dendermonde
$searchBaseUser += 'OU='+$gekozenOU+',OU=DE01_Frankenthal,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Frankenthal
$searchBaseUser += 'OU='+$gekozenOU+',OU=DE02_Konz,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Konz
$searchBaseUser += 'OU='+$gekozenOU+',OU=DE03_Eiweiler,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Eiweiler
$searchBaseUser += 'OU='+$gekozenOU+',OU=DE04_Ober-Abtsteinach,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Ober-Absteinach
$searchBaseUser += 'OU='+$gekozenOU+',OU=DE07_Triwo,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Triwo
$searchBaseUser += 'OU='+$gekozenOU+',OU=DE08_Wiesbaden,OU=_EMEA,DC=eu,DC=intra-global,DC=net'  #Wiesbaden
$searchBaseUser += 'OU='+$gekozenOU+',OU=FR01_La-Defense,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #La Defense
$searchBaseUser += 'OU='+$gekozenOU+',OU=FR02_Sedan,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Sedan
$searchBaseUser += 'OU='+$gekozenOU+',OU=FR03_Showroom-Aubervilliers,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Showroom Aubervilliers
$searchBaseUser += 'OU='+$gekozenOU+',OU=FR04_Cuzorn,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Cuzorn
$searchBaseUser += 'OU='+$gekozenOU+',OU=FR07_Auchel,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Auchel
$searchBaseUser += 'OU='+$gekozenOU+',OU=FR09_Donchery-Michaux2,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Donchery-Michaux2
$searchBaseUser += 'OU='+$gekozenOU+',OU=FR11_Donchery-Michaux1,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Donchery-Michaux1
$searchBaseUser += 'OU='+$gekozenOU+',OU=FR13_Toulouse,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Toulouse
$searchBaseUser += 'OU='+$gekozenOU+',OU=UK01_Lenham,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Lenham
$searchBaseUser += 'OU='+$gekozenOU+',OU=UK02_Edinburgh,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Edinburgh
$searchBaseUser += 'OU='+$gekozenOU+',OU=UK04_Abingdon,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Abingdon
$searchBaseUser += 'OU='+$gekozenOU+',OU=UK05_London,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #London
<#$users = ""
foreach ($OU in $searchBaseUser)
{
    $users += Get-ADUser -Filter * -Properties SamAccountName, mail, city  -SearchBase $OU | FT SamAccountName, mail, City #| Out-File -FilePath 'C:\Users\doorenj\Desktop\locatie DMD.txt'
}#>
$users = $searchBaseUser | foreach { Get-ADUser -Filter * -Properties SamAccountName, mail, city  -SearchBase $_ | FT SamAccountName, mail, City }
$users | Out-File -FilePath 'C:\Users\doorenj\Desktop\Users.txt'
$name = Read-Host "Geef username in"
$OU = "OU=users,OU=NL02_Waalwijk,OU=_EMEA,DC=eu,DC=intra-global,DC=net"
$users = Get-ADUser -Filter { Name -eq $name } -Properties * -SearchBase $OU
$SMTPDesso = "SMTP:"+$users.mail
$SMTPTarkett = "smtp:"+$users.'msRTCSIP-PrimaryUserAddress'.Replace("sip:","")
$SMTPExchange = $users.mail.Replace("@desso.com","@exchange.desso")
$SMTPSommer = $SMTPTarkett.Replace("@tarkett.com", "@tarkett-sommer.com")
$X400 = $users.textEncodedORAddress
$X500 = "X500:/o=INTRA-GLOBAL/ou=First Administrative Group/cn=Recipients/cn=_TESSO_"+$users.GivenName+$users.sn.replace(" ","")
$SMTPDesso
$SMTPTarkett
$SMTPExchange
$SMTPSommer
$X400
$X500
$smtp = @()
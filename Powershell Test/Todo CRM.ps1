$PCUSER = ".\pcuser"
$PWPCUSER = ConvertTo-SecureString "Wig4m@" -AsPlainText -Force
$PCUSERCREDENTIALS = New-Object System.Management.Automation.PSCredential($PCUSER, $PWPCUSER)
$test = "test"
$command = 'compmgmt.msc'
start-process powershell.exe -Credential $PCUSERCREDENTIALS -argument "-nologo -noprofile -executionpolicy bypass -command Read-Host"
$PCNAAM = "BE04TW80004"
$NAMEPROCESS = "'explorer.exe'"
$admin = $PCNAAM+"\pcuser"
$password = "Wig4m@" | ConvertTo-SecureString -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential ($admin, $password)

<#How to terminate process#>
#gwmi win32_Process -ComputerName $PCNAAM -Credential $credentials | Sort-Object Caption | FT Caption
#(gwmi win32_Process -Filter "Name=$PROCESS" -ComputerName $PCNAAM -Credential $credentials).create()

<#How to start process wmiobject#>
$process = get-wmiobject -Query "SELECT * FROM Meta_Class WHERE __Class = 'Win32_Process'" -Namespace "root\cimv2" -ComputerName $PCNAAM -Credential $credentials
$result = $process.Create( "notepad.exe" )

#Enter-PSSession -ComputerName $PCNAAM -Credential $credentials

#Invoke-Command -ComputerName $PCNAAM -Credential $credentials -ScriptBlock { Start-Process magnify.exe }
<#Stap 1 - Sysaid installatie#>
Write-Host "Copying Sysaid Folder..."

$LOCALUSER = $env:USERNAME
New-PSDrive –Name “Sysaid” –PSProvider FileSystem –Root “\\desso.int\DFSDesso\ITScripts\Sysaid\Install_client” –Persist
Copy-Item -Path \\desso.int\DFSDesso\ITScripts\Sysaid\Install_client -Destination "C:\Users\$LOCALUSER\Desktop" -Recurse
Remove-PSDrive -Name "Sysaid"

Write-Host "Done copying.`nStarting installation Sysaid..."

C:\Users\$LOCALUSER\Desktop\Install_client\SysAidAgent_14_1.exe /VERYSILENT /URL http://itsupport:80 /account desso /serial CE2A6213DFB18BB2 /SubmitSRShortcut "IT Support"

Write-Host "Sysaid installed!"
Sleep 2

<#Stap 2 - Sysaid melding!!#>

Read-Host "Vergeet PC settings niet aan te passen in SysAid!!<Enter>"
Sleep 3

<#Stap 3 - Reginal Settings#>

Set-Culture nl-be #Format belgium
Set-WinUserLanguageList nl-BE #Language BE
Set-WinHomeLocation -GeoId 21 #Belgium as location
Sleep 10
Write-Host "Copy settings as local admin!"
Sleep 3
Start-Process control.exe -ArgumentList '/name Microsoft.RegionalAndLanguageOptions /page /p:"Administrative"'
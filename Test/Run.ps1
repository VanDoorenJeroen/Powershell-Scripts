$domain = $env:userdomain
if($domain -eq 'EU')
{
    Start-Process powershell.exe -ArgumentList '-file \\ddrnas01\public\software\test\EditPcCredentials.ps1'
}
else
{
    Start-Process powershell -ArgumentList '-file \\ddrnas01\public\software\test\EditPcCredentials.ps1' -Verb RunAs
}
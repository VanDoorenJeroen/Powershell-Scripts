<#Get list of all printers#>
$printers = Get-Printer | Where-Object Name -Like *BE04*

<#Stop sharing printers#>
Write-Host 'Starting to undo sharing..'
foreach ($printer in $printers)
{
    Set-Printer -Name $printer.Name -Shared $false
}
Write-Host 'All printers are not shared anymore'

<#Wait to start sharing again#>

Sleep -s 10

<#Start sharing printers#>
Write-Host 'Starting sharing'
foreach ($printer in $printers)
{
    Set-Printer -Name $printer.Name -Shared $true -ShareName $printer.Name -Published $true
}
Write-Host 'All printers are shared again!'
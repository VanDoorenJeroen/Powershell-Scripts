#Get-Process * -ComputerName "BE04DW70010"

$PROCESSNAAM = "*OPCTray*"

$processes = Gwmi -Class win32_process -ComputerName BE04DW70010 | ? { $_.Name -like $PROCESSNAAM }
foreach ($proces in $processes)
{
    $proces.Path
    <#$returnval = $proces.Terminate()
    $processid = $proces.handle

    if ($returnval.returnvalue -eq 0) {
        Write-Host "The process $processnae terminated"
    }
    else {
        Write-Host "Not done!"
    }#>

}
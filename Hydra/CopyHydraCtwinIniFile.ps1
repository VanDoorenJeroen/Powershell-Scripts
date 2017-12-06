#######################################################################
#                                                                     #
#                                                                     #
#                         Copy CTWIN.ini                              #
#                                                                     #
#                                                                     #
#######################################################################

Set-ExecutionPolicy RemoteSigned

$DESTINATION = "\\BE04SFP001\team$\Hydra Backup\$env:COMPUTERNAME"
$TYPE = "*.ini"
$CURRENTDATE = (Get-Date -Format d)
$CURRENTDATEREPLACED = $CURRENTDATE.Replace("/", "_")
$NUMBEROFDAYS = 14

$dateOneMonthAgo = (Get-Date).AddDays(-$NUMBEROFDAYS).ToString("dd_MM_yyyy")
$dateOneMonthAgoCheck = (Get-Date).AddDays(-$NUMBEROFDAYS).ToShortDateString()
$count = [System.IO.Directory]::GetFiles($DESTINATION, $TYPE).Count
$Location = $DESTINATION + "\ctwin" + $CURRENTDATEREPLACED + ".ini"


if (Test-Path $DESTINATION) { 
    if ($count -gt $NUMBEROFDAYS) {
        Get-ChildItem $DESTINATION | Where-Object { $_.Name -like $TYPE } | Sort-Object Name -Descending | ForEach-Object { if([datetime]::ParseExact($_.ToString().TrimStart("ctwin").TrimEnd(".ini"),"d_M_yyyy",$null).ToShortDateString() -lt $dateOneMonthAgoCheck) { $_.Delete() } }
    }
    Copy-Item "c:\ctwin\ctwin.ini" $Location -Force -Recurse 
}






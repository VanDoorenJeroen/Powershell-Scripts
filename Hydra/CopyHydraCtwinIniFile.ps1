#######################################################################
#                                                                     #
#                                                                     #
#                         Copy CTWIN.ini                              #
#                                                                     #
#                                                                     #
#######################################################################

Set-ExecutionPolicy RemoteSigned

$Destination = "\\BE04SFP001\team$\Hydra Backup\$env:COMPUTERNAME"
$date = (Get-Date -Format d).Replace("/", "_")
$Location = $Destination + "\ctwin" + $date + ".ini"
if (Test-Path $Destination) { Copy-Item "c:\ctwin\ctwin.ini" $Location -Force -Recurse }
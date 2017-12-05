Set-ExecutionPolicy RemoteSigned

$Destination = "\\BE04SFP001\team$\Hydra Backup\$env:COMPUTERNAME\ctwin"
if (Test-Path $Destination) { Remove-Item $Destination -Recurse -Force}
Copy-Item -Path "c:\ctwin" -Destination $Destination -Force -Recurse
Set WshShell = CreateObject("WScript.Shell")
WshShell.RUN "powershell -ExecutionPolicy Bypass -WindowStyle Hidden -NoLogo -file C:\Backup\Copy_Hydra.ps1", 0
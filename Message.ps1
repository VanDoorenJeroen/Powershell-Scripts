$PCNAAM = "BE04LW80079"
$message = Read-Host "Geef boodschap in"
$aantalkeren = Read-Host "Geef aantalkeren in"


for ($i = 0; $i -lt $aantalkeren; $i++){
    $aantal = $aantalkeren - $i
    $boodschap = $message+"`nNog $aantal keren"
    Invoke-WmiMethod -Class Win32_Process -ComputerName $PCNAAM  -Name Create -ArgumentList "C:\Windows\System32\msg.exe * $boodschap" 
}
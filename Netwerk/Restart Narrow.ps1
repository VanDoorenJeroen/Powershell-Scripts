$narrow = "NARROW4-DT","NARROW5-DT","NARROW6-DT","NARROW7-DT","NARROW8-DT","NARROW9-DT" 
foreach ($pc in $narrow) {
Restart-Computer -ComputerName $pc -Force
Write-Host "Restarting $pc.."
sleep -Seconds 5
}
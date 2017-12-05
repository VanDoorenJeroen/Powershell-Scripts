<#Display Adapter#>
$update = Read-Host "Moet driver voor display geinstalleerd worden?"
if ($update -eq "Y"){
    devmgmt.msc
}

<#input variables#>
$NaamPc = Read-Host "Geef naam PC in <Enter>"

<#Name current pc#>
Write-Host "Naam huidige pc: $env:COMPUTERNAME zal gewijzigd worden in $NaamPc"

<#Rename Pc#>
$boolean = Read-Host "Is dit ok? (Y/N)"

if($boolean -eq "Y") {
    (Get-WmiObject Win32_ComputerSystem).Rename($NaamPc)
}

<#Wait for mmc to close to restart#>
$status = Get-Process mmc -ErrorAction SilentlyContinue
DO
{ "Waiting for installation.."
    start-sleep -s 5
    $status = Get-Process mmc -ErrorAction SilentlyContinue
} Until ($status -eq $null)

"Pc will now restart.."
start-sleep -s 3

Restart-Computer
$username = $env:USERNAME
$computername = $env:COMPUTERNAME
$testUser = "Test"
$startpage = "www.google.be"

#Change homepage
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name "Start Page" -Value $startpage

<#Default programma's #>
start-process iexplore.exe 
start-process winword.exe
start-process wmplayer.exe

<#Verwijder Test user #>
$objComp = [ADSI]"WinNT://$computername"
$colUsers = ($objComp.PSBase.children | Where-Object {$_.psBase.schemaClassName -eq "User"} | Select-Object -expand Name)
$userFound = $colUsers -contains $testUser
if ($userFound) { 
    <#Verwijder User#>
    $objComp.Delete("User",$testUser)
    Write-Host "$testUser is verwijderd."
}
else { Write-Host "Geen Test user gevonden" }

<#Configuratie SAP#>
$SAP = Read-Host "Moet SAP geconfigureerd worden? (Y/N)"
if ($SAP -eq "Y") {
    start-process SapLogon.s8l -workingdirectory "C:\Program Files (x86)\SAP\SapSetup\setup\SAL\"
    sleep 10
    $status = Get-Process saplogon -ErrorAction SilentlyContinue
    $statusUpdate = Get-Process NwSapSetup -ErrorAction SilentlyContinue
    DO {
        "Waiting for installation.."
        start-sleep -s 5
        $status = Get-Process saplogon -ErrorAction SilentlyContinue
        $statusUpdate = Get-Process NwSapSetup -ErrorAction SilentlyContinue
        } Until ($status -eq $null -or $statusUpdate -eq $null)
    end-process saplogon
    Wait-Process saplogon
    Copy-Item '\\ddrnas01\Public\software\SAP GUI 7.2\saplogon.ini' -Destination "C:\Users\" + $username + "\Appdata\Roaming\SAP\Common\" -Force
    start-process SapLogon.s8l -workingdirectory "C:\Program Files (x86)\SAP\SapSetup\setup\SAL\"
}

<#Installatie netwerk printers#>
$print = Read-Host "Wilt u een printer installeren? (Y/N)"
if ($print -eq "Y") {
    $dmd = Read-Host "Dendermonde? (Y/N)"
    $wlw = Read-Host "Waalwijk? (Y/N)"
    if ($dmd -eq "Y") {
        explorer.exe \\ddrps001
    }
    if ($wlw -eq "Y") {
        explorer.exe \\walps001
    }
}

<#ToDo#>
Write-Host "Todo`n1. Wijzigen eigenschappen My Documents`n2. Wijzigen eigenschappen Lotus Notes`n3. Installeren extra software"
explorer.exe MyDocuments

<#Done#>
$accept = Read-Host "Thanks for your attention"
<#Default items#>
$domain = "desso.int"

<#input variables#>
$NaamPc = Get-Content env:computername
$gebruiker = Read-Host "Geef naam gebruiker in <Enter>"
$username = Read-Host "Geef naam Administrator in <Enter>"
$password = Read-Host "Geef paswoord in <Enter>" -AsSecureString
$administrator = $domain + "\" + $username

$akkoord = Read-Host "$gebruiker toevoegen aan Lokale admin groep?"

<#If error, reinsert#>
While ($akkoord -eq "N")
{
    $gebruiker = Read-Host "Geef naam gebruiker in <Enter>"
    $username = Read-Host "Geef naam Administrator in <Enter>"
    $password = Read-Host "Geef paswoord in <Enter>" -AsSecureString
    $akkoord = Read-Host "$gebruiker toevoegen aan Lokale admin groep?"
}

<#Test Connection#>
$connectie = Test-Connection -ComputerName ddrfs001 -Quiet

<#If connection, make changes#>
if ($connectie) { 

<#Add to domain#>
    $credential = New-Object System.Management.Automation.PSCredential($administrator,$password)
    Add-Computer -DomainName $domain -Credential $credential

<#Add user to local Admin#>
    $objGroup = [ADSI]("WinNT://$NaamPc/Administrators")
    $objUser = [ADSI]("WinNT://$domain/$gebruiker")
    $objGroup.PSBase.Invoke("Add",$objUser.PSBase.Path)

<#Enable Administrator#>
    Invoke-Command { net user Administrator /Active:Yes }

<#Restarting computer#>
    for ($i = 5; $i -ge 0; $i--) { 
        Write-Host "Computer restarting in"$i 
        Start-Sleep -s 1
    }
    Restart-Computer
}
<#No connection, probably driver#>
else{
    "No connection.`nCheck driver"
    devmgmt.msc
}
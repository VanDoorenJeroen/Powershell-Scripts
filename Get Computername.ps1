#Default location om script te openen, anders foutmelding bij credentials .\pcuser
Set-Location -Path C:\Windows

#Standaard variables
$DEFAULTOU = ",OU=_EMEA,DC=eu,DC=intra-global,DC=net" #Default voor AD OU
$LOCATIENUMMER = 0
$PCUSER = ".\pcuser"

#Alle Functies
Function leesADUserGegevensUit($gebruikersNaam, $locatie)
{
    $searchBaseUser = "OU=Users," + $locatie + $DEFAULTOU

    $filterGebruiker = 'Name -like "*' + $gebruikersNaam + '*"'

    $users = Get-ADUser -Filter $filterGebruiker -Properties DisplayName, Name -SearchBase $searchBaseUser

    return $users
}

<#Gaat uit AD gegevens uitlezen van computer.
User bevat gegevens zoals displayname om op te zoeken.
gebruikersnaam zal gebruikt worden om te filteren op extra gegevens.
Locatie is om te kijken waar er gezocht moet worden#>
Function leesADCompGegevensUit($user, $gebruikersNaam, $locatie)
{
    $naamDisplayName = $user.DisplayName
    $description = '*' + $naamDisplayName + '*'
    $naamName = $user.Name
    $partName = '*' + $naamName.Substring(0,$naamName.Length-1) + '*'
    $searchBaseComp = "OU=Computers," + $locatie + $DEFAULTOU

    try
    {
        $computers = Get-ADComputer -Filter {Description -like $description -or Description -like $partName} -Properties Description, Name -SearchBase $searchBaseComp
    }
    Catch
    {
        "Something went wrong trying to find Computer"
    }
    return $computers
}

<#Blijf herhalen zolang Y antwoorden#>
Do
{
    $LOCATIENUMMER = Read-Host "1. Waalwijk`n2. Dendermonde`n3. Duitsland`n4. Frankrijk`n0. Exit`nWelke locatie?"

    switch ($LOCATIENUMMER)
    {
        1 { $locatie = "OU=NL02_Waalwijk" }
        2 { $locatie = "OU=BE04_Dendermonde" }
        3 { $locatie = "OU=DE08_Wiesbaden" }
        4 { $locatie = "OU=FR01_La-Defense" }
        default { Exit }
    }

    #Importeer module AD
    Import-Module ActiveDirectory

    #Gebruiker invullen
    $gebruikersNaam = Read-Host "Geef gebruikersnaam in"

    $users = leesADUserGegevensUit $gebruikersNaam $locatie 


    While ($users.Count -ne 1 -or $gebruikersNaam -eq "exit")
    {
        Write-Host "Teveel/geen namen gevonden."
        Foreach ($user in $users)
        {
            Write-Host "Gebruiker"$user.DisplayName"heeft als username"$user.Name
        }
        $gebruikersNaam = Read-Host "Gelieve opnieuw in te geven."
        $users = leesADUserGegevensUit $gebruikersNaam $locatie
    }

    $computers = leesADCompGegevensUit $users $gebruikersNaam $locatie

    if($computers -eq $null)
    {
        $naamDisplayName = $users.DisplayName
        Write-Host "Geen pc's gevonden op naam van $naamDisplayName."
    }
    else 
    {
        $listofPcs = @()
        $aantalPcs = 0
        foreach ($pc in $computers)
        {
            $aantalPcs++
            $naam = ($pc.Description -split ":")[2]
            Write-Host "$aantalPcs. De pc van $naam is"$pc.Name
            $listofPcs += $pc.Name
        }
        $connectiePc = Read-Host "Geef nummer op van pc waarme u verbinding wil maken"
        if($connectiePc -le $aantalPcs -and $connectiePc -gt 0)
        {
            $selectiePc = $listofPcs[$connectiePc-1]
            if(Test-Connection  $selectiePc -Count 1 -Quiet)
            {
                $passWordpcUser = Read-Host "Geef paswoord in van .\pcuser" -AsSecureString
                $credentials = New-Object System.Management.Automation.PSCredential($PCUSER,$passWordpcUser)
                start-process "C:\Program Files (x86)\ConfigMGR\bin\i386\CmRcViewer.exe" $selectiePc -Credential($credentials)
            }
            else
            {
                Write-Host "Pc is niet te bereiken"
            }
        }
    }
    $searchMore = Read-Host "Wilt u nog meer opzoeken?"
} while ($searchMore -eq "Y")
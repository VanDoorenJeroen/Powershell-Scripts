1#Default location om script te openen, anders foutmelding bij credentials .\pcuser
Set-Location -Path C:\Windows

#Call functions
. "$PSScriptRoot\Functions.ps1"

#Standaard variables
$DEFAULTOU = ",OU=_EMEA,DC=eu,DC=intra-global,DC=net" #Default voor AD OU
$LOCATIENUMMER = 0
$PCUSER = ".\pcuser"
$KEUZEOVERNAME = 0

<#Blijf herhalen zolang Y antwoorden#>
Do
{
    $LOCATIENUMMER = Read-Host "###Kieus uw locatie###`n1. Nederland`n2. Belgie`n3. Duitsland`n4. Frankrijk`n5. Engeland`n0. Exit`n`nWelke locatie?"

    switch ($LOCATIENUMMER)
    {
        1 { $locatie = "Nederland" }
        2 { $locatie = "Belgie" }
        3 { $locatie = "Duitsland" }
        4 { $locatie = "Frankrijk" }
        5 { $locatie = "Engeland" }
        default { Exit }
    }

    Import-Module ActiveDirectory     #Importeer module AD

    $gebruikersNaam = Read-Host "`nGeef gebruikersnaam in"     #Gebruiker invullen
    if($gebruikersNaam -eq "Exit")
    {
        Exit
    }
    else
    {
        $foundUsers = leesADUserGegevensUit $gebruikersNaam $locatie    #Users opzoeken in AD
    }
    
    While ($foundUsers.Count -ne 1)   #Als geen users gevonden of usernaam = exit, 
    {
        if($gebruikersNaam -eq "exit")
        {
            Exit
        }
        elseif($foundUsers.Count -eq 0)
        {
            "`nGeen gebruikers gevonden."           
        }
        else
        {
            Write-Host "`nTeveel namen gevonden.`n----------------------"
            Foreach ($user in $foundUsers)
            {
                $fysiekePlaats = $user.physicalDeliveryOfficeName.Substring(5)
                Write-Host $fysiekePlaats "gebruiker"$user.DisplayName"heeft als username"$user.SamAccountName
            }
        }
        $gebruikersNaam = Read-Host "`nGelieve opnieuw in te geven."
        $foundUsers = leesADUserGegevensUit $gebruikersNaam $locatie
    }

    $foundComputers = leesADCompGegevensUit $foundUsers $gebruikersNaam $locatie    #Computers opzoeken in AD op basis van user

    $selectedPC = "" #Naam gekozen PC
    $selectedName = "" #Naam gebruiker

    if($foundComputers.Count -eq 0)
    {
        "`nGeen computers gevonden voor "+$foundUsers.DisplayName
    }
    else
    {
        if($foundComputers.Count -ne 1)
        {
            $listofPcs = @()
            $listofNames = @()
            $aantalPcs = 0
            $gekozenPc = 0
            Write-Host "`nTeveel pc's gevonden.`n---------------------"
            Foreach ($pc in $foundComputers)
            {
                $aantalPcs++
                $naam = ($pc.Description -split ":")[2] #Gaat de usernaam uit de description van computer halen
                if($pc -match 'DW') { Write-Host "$aantalPcs. $naam heeft een DESKTOP:"$pc.Name }
                else { Write-Host "$aantalPcs. $naam heeft een LAPTOP:"$pc.Name }
                $listofPcs += $pc.Name
                $listofNames += $naam
            }
            Do
            {
                $gekozenPC = Read-Host "`nGeef nummer op van pc waarmee u verbinding wil maken"
            }While($gekozenPc -notin 1..$aantalPcs)

            $selectedPC = $listofPcs[$gekozenPC-1]
            $selectedName = $listofNames[$gekozenPC-1]
        }
        else 
        {
            $selectedPC = $foundComputers.Name
            $selectedName = ($foundComputers.Description -split ":")[2]
        }
        
        if($selectedPC -match 'DW') { Write-Host "`n$selectedPC : Desktop van$selectedName`n" }
        else { Write-Host "`n$selectedPC : Laptop van$selectedName`n" }
        
        $KEUZEOVERNAME = Read-Host "1. Overname Pc`n2. Check connectiviteit`n3. Open C-schijf`n4. Kopieer computername`n0. Exit`n`nMaak uw keuze"
        
        switch($KEUZEOVERNAME)
        {
            1 { MakeConnectionWithPC($selectedPC) }
            2 { CheckConnectionPC($selectedPC) }
            3 { OpenFolder($selectedPC) }
            4 { $selectedPC | clip.exe }
            default {}
        }
    }
    $searchMore = Read-Host "`nWilt u opnieuw zoeken? (Y/N)"
    Write-Host "`n"
} while ($searchMore -eq "Y")
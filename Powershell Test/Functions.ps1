<#Start
Gaat kijken waar er moet gezocht worden#>
Function GetLocation()
{
    $LOCATIENUMMER = Read-Host "`n###Kieus uw locatie###`n1. Nederland`n2. Belgie`n3. Duitsland`n4. Frankrijk`n5. Engeland`n0. Exit`n`nWelke locatie?"

    switch ($LOCATIENUMMER)
    {
        1 { $locatie = "Nederland" }
        2 { $locatie = "Belgie" }
        3 { $locatie = "Duitsland" }
        4 { $locatie = "Frankrijk" }
        5 { $locatie = "Engeland" }
        default { Exit }
    }
    return $locatie
}

<#Gaat uit AD gegevens uitlezen van User
Selectie op basis van locatie.
Filter op ingegeven gebruikersnaam#>
Function leesADUserGegevensUit($gebruikersNaam, $locatie)
{
    $OUUSERS = "Users"
    $searchBaseUser = getOU $locatie $OUUSERS

    $filterGebruiker = 'Name -like "*' + $gebruikersNaam + '*"'

    $users = $searchBaseUser | foreach { Get-ADUser -Filter $filterGebruiker -Properties DisplayName, Name, physicalDeliveryOfficeName -SearchBase $_ }

    foreach ($user in $users)
    {
        if ($user.Name -eq $gebruikersNaam)
        {
            $users = $user
        }   
    }

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
    $OUCOMPUTERS = "Computers"
    $searchBaseComp = getOU $locatie $OUCOMPUTERS
    $computers = ""

    try
    {
        $computers = $searchBaseComp | foreach { Get-ADComputer -Filter {Description -like $description} -Properties Description, Name -SearchBase $_ }
    }
    Catch
    {
        "Something went wrong trying to find Computer"
        $computers = $null
    }
    return $computers
}

<#Gaat connectie opzetten met geselecteerde pc.
Eerst kijken of er connectie is.
Vervolgens login vragen van pcuser
Dan CmRcViewer met credentials opstarten en geselecteerde pc meegeven#>
Function MakeConnectionWithPC($selectedPC)
{
    if(CheckConnectionPC $selectedPC)
    {
        $credentials = GetPSUserCredentials
        try
        {
            start-process "C:\Program Files (x86)\ConfigMGR\bin\i386\CmRcViewer.exe" $selectedPC -Credential($credentials) -ErrorAction Stop
        }
        Catch [Exception]
        {
            Write-Host "`nPassword of PCUser has expired"
            RemovePSUerCredentials
            MakeConnectionWithPC $selectedPC
        }
    }
}

<#Gaat connectie met pc checken#>
Function CheckConnectionPC($selectedPC)
{
    $testConnection = Test-Connection $selectedPC -Count 1 -Quiet
    if($testConnection -eq $true)
    {
        $ipAddress = Test-Connection $selectedPC -Count 1
        Write-Host "`n$selectedPC is te bereiken op"$ipAddress.IPV4Address.IPAddressToString
        return $true
    } 
    else
    {
        Write-Host "`n$selectedPC is niet te bereiken"
        return $false
    }
}

<#Gaat c-schijf openen van de gevraagde pc#>
Function OpenFolder($selectedPC)
{
    if(CheckConnectionPC $selectedPC)
    {
        $credentials = GetPSUserCredentials
        New-PSDrive -Name Temporary -PSProvider FileSystem -Root "\\$selectedPC\c$" -Credential $credentials
        Invoke-Item "\\$selectedPC\c$"
        Remove-PSDrive -Name Temporary
    }
}

<#Gaat info ophalen van alle disken in de pc
Vervolgens weergeven van vrije schijfruimte en volledige schijf in GB#>
Function GetDiskSpace($selectedPC)
{
    if(CheckConnectionPC $selectedPC)
    {
        $credentials = GetPSUserCredentials
        $disks = Get-WmiObject Win32_LogicalDisk -ComputerName $selectedPC -Credential $credentials | Where-Object {$_.DeviceID -eq "C:"}
        foreach ($disk in $disks)
        {
            $drive = $disk.DeviceID
            "`n$drive heeft nog {0:#.0} GB vrij van de {1:#.0} GB." -f ($disk.FreeSpace/1GB),($disk.Size/1GB)
        }
    }
}

<#PSUser credentials inlezen. Indien 1e keer: ingeven pw + wegschrijven naar $path
Bij de volgende keren, checken of bestand reeds bestaat en indien ja, paswoord uitlezen + gebruiken #>
Function GetPSUserCredentials()
{
    
    $PCUSER = $env:COMPUTERNAME+"\pcuser"
    $PATH = "C:\Users\"+$env:USERNAME+"\Appdata\Local\Microsoft\Windows\stored.txt"
    $fileExists = Test-Path $PATH
    if($fileExists -eq $true)
    {
        $passWordpcUser = Get-Content $PATH | ConvertTo-SecureString
        $credentials = New-Object System.Management.Automation.PSCredential($PCUSER, $passWordpcUser)
        return $credentials
    }
    else
    {
        $passWordpcUser = Read-Host "`nGeef paswoord in van .\pcuser" -AsSecureString 
        $passWordpcUser | ConvertFrom-SecureString | Out-File $PATH
        $credentials = New-Object System.Management.Automation.PSCredential($PCUSER,$passWordpcUser)
        return $credentials
    }
}

Function RemovePSUerCredentials()
{
    $PATH = "C:\Users\"+$env:USERNAME+"\Appdata\Local\Microsoft\Windows\stored.txt"
    Remove-Item $PATH
}

<#Gaat alle OU's uitlezen van een welbepaald land
return de OU's als een array
Mbhv foreach ou's inlezen#>
Function getOU($locatie,$gekozenOU)
{
    $searchBaseUser = @()
    switch($locatie)
    {
        "Nederland" { $searchBaseUser += 'OU='+$gekozenOU+',OU=NL01_Oosterhout,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Oosterhout
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=NL02_Waalwijk,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Waalwijk
                      $searchBaseUser += 'OU=Production,OU=NL02_Waalwijk,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Production
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=NL03_Goirle,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Goirle
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=NL04_Oss,OU=_EMEA,DC=eu,DC=intra-global,DC=net'} #Oss
                                         
        "Belgie" { $searchBaseUser += 'OU='+$gekozenOU+',OU=BE01_Holsbeek,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Holsbeek
                   $searchBaseUser += 'OU='+$gekozenOU+',OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Dendermonde
                   $searchBaseUser += 'OU=Production,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net' } #Production

        "Duitsland" { $searchBaseUser += 'OU='+$gekozenOU+',OU=DE01_Frankenthal,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Frankenthal
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=DE02_Konz,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Konz
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=DE03_Eiweiler,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Eiweiler
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=DE04_Ober-Abtsteinach,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Ober-Absteinach
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=DE07_Triwo,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Triwo
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=DE08_Wiesbaden,OU=_EMEA,DC=eu,DC=intra-global,DC=net' } #Wiesbaden

        "Frankrijk" { $searchBaseUser += 'OU='+$gekozenOU+',OU=FR01_La-Defense,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #La Defense
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=FR02_Sedan,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Sedan
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=FR03_Showroom-Aubervilliers,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Showroom Aubervilliers
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=FR04_Cuzorn,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Cuzorn
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=FR07_Auchel,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Auchel
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=FR09_Donchery-Michaux2,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Donchery-Michaux2
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=FR11_Donchery-Michaux1,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Donchery-Michaux1
                      $searchBaseUser += 'OU='+$gekozenOU+',OU=FR13_Toulouse,OU=_EMEA,DC=eu,DC=intra-global,DC=net' } #Toulouse

        "Engeland" { $searchBaseUser += 'OU='+$gekozenOU+',OU=UK01_Lenham,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Lenham
                     $searchBaseUser += 'OU='+$gekozenOU+',OU=UK02_Edinburgh,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Edinburgh
                     $searchBaseUser += 'OU='+$gekozenOU+',OU=UK04_Abingdon,OU=_EMEA,DC=eu,DC=intra-global,DC=net' #Abingdon
                     $searchBaseUser += 'OU='+$gekozenOU+',OU=UK05_London,OU=_EMEA,DC=eu,DC=intra-global,DC=net'} #London

        default { Exit }                               
    }
    return $searchBaseUser
}
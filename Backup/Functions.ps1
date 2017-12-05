<#Gaat uit AD gegevens uitlezen van User
Selectie op basis van locatie.
Filter op ingegeven gebruikersnaam#>
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

<#Gaat connectie opzetten met geselecteerde pc.
Eerst kijken of er connectie is.
Vervolgens login vragen van pcuser
Dan CmRcViewer met credentials opstarten en geselecteerde pc meegeven#>
Function MakeConnectionWithPC($selectedPC)
{
    if(Test-Connection  $selectedPC -Count 1 -Quiet)
    {
        
        $credentials = GetPSUserCredentials
        start-process "C:\Program Files (x86)\ConfigMGR\bin\i386\CmRcViewer.exe" $selectedPC -Credential($credentials)
    }
    else
    {
        Write-Host "$selectedPC is niet te bereiken"
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
    } 
    else
    {
        Write-Host "`n$selectedPC is niet te bereiken"
    }
}

<#Gaat c-schijf openen van de gevraagde pc#>
Function OpenFolder($selectedPC)
{
    if(Test-Connection $selectedPC -Count 1 -Quiet)
    {
        $credentials = GetPSUserCredentials
        New-PSDrive -Name Temporary -PSProvider FileSystem -Root "\\$selectedPC\c$" -Credential $credentials
        Invoke-Item "\\$selectedPC\c$"
        Remove-PSDrive -Name Temporary
    }
    else
    {
       Write-Host "`n$selectedPC is niet te bereiken" 
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
<#$computers = Get-ADComputer -Filter * -Properties * -SearchBase "OU=Desktops,OU=Workstations,OU=Dendermonde,OU=SITES,DC=desso,DC=int" | Sort-Object -Property Name
Foreach ($pc in $computers) 
{ 
    $naam = $pc.Name.ToString()
    if (Test-Connection $naam -Quiet)
    {
        $objComp = [ADSI]"WinNT://$naam"
        $colUsers = ($objComp.PSBase.children | Where-Object {$_.psBase.schemaClassName -eq "User"} | Select-Object -expand Name)
        $userFound = $colUsers -contains "Test"
        if ($userFound) 
        { 
            ">> $naam heeft Test user <<"
            <#Verwijder User
            #$objComp.Delete("User","Test")
        }
        else
        {
            "$naam heeft geen test user"
        }
    }
    else 
    { 
        "$naam not reachable"
    }
}#>

$computers = Get-ADComputer -Filter * -Properties * -SearchBase "OU=Desktops,OU=Workstations,OU=Dendermonde,OU=SITES,DC=desso,DC=int" -SearchScope OneLevel | Sort-Object -Property Name
Foreach ($pc in $computers) 
{ 
    $naam = $pc.Name.ToString()
    Write-Host $naam
}
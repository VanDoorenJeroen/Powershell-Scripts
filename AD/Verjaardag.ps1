$array = "N","No","Nee","Exit"
$naam = Read-Host "Geef naam in <Enter>"
WHILE ($naam -notin $array)
{
    $user = Get-ADUser -Filter 'DisplayName -like $naam' -Properties *
    if($user -eq $null)
    {
        $naam = Read-Host "Niemand gevonden, geef nieuwe naam in"
    }
    else 
    {
        $datum = $user.employeeAnniv.ToString("dd.MM.yyyy")
        $user | Format-Table @{expression={$user.DisplayName};Label="Naam"}, @{Expression={$datum};Label="Verjaardag"}
        $naam = Read-Host "Geef nieuwe naam in"
    }
}
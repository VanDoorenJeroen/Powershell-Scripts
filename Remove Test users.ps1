<# Remove Local user Test 
for($i = 4; $i -le 9; $i++)
{
    $objComp = [ADSI]"WinNT://NARROW$i-DT"
    $colUsers = ($objComp.PSBase.children | Where-Object {$_.psBase.schemaClassName -eq "User"} | Select-Object -expand Name)
    $userFound = $colUsers -contains "Test"
    if ($userFound) 
    { 
        "NARROW$i-DT heeft Test user"
        $objComp.Delete("user", "test")
        "Test user verwijderd uit NARROW$i-DT" 
    }
    else 
    {
        "NARROW$i heeft geen test user"
    }
}#>

<# Display Local users #>
$computerName = "FLOORSOF-DT"
if ($computerName -eq "") {$computerName = "$env:computername"} 
$computer = [ADSI]"WinNT://$computerName,computer" 
$colUsers = ($computer.psbase.Children | Where-Object { $_.psbase.schemaclassname -eq 'user' } | Select-Object -expand Name)
$colUsers | ForEach-Object { Write-Host $_ }
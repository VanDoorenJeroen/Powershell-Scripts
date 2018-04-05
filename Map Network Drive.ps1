Function Waalwijk
{
    $share = Read-Host "Tot welke share wilt u verbinding maken?`n1. Fileserver 001`n2. Fileserver 002`n3. Walas021`n4. Walas013"
    switch ($share)
    {
        1. { new-PSDrive -Name $naam -Scope Global -PSProvider FileSystem -Root \\walfs001\SharedData -Persist }
        2. { New-PSDrive -Name $naam -Scope Global -PSProvider FileSystem -Root \\walfs002\Shareddata -Persist }
        3. { New-PSDrive -Name $naam -Scope Global -PSProvider FileSystem -Root \\walas021\frm_pdf -Persist }
        4. { New-PSDrive -Name $naam -Scope Global -PSProvider FileSystem -Root \\walas013\Frm_pdf -Persist }
        default {exit}
    }
}

Function Dendermonde
{
    $share = Read-Host "Tot welke share wilt u verbinding maken?`n1. ddrfs001"
    switch ($share)
    {
        1. { new-PSDrive -Name $naam -Scope Global -PSProvider FileSystem -Root \\ddrfs001\SharedData -Persist }
    }
}

$letters = (Get-PSDrive | Where-Object {$_.Name.Length -eq 1}).Name
$naam = Read-Host "Geef letter in"
While($letters.Contains($naam.ToUpper()) -or $naam.Length -ne 1 -or $naam -match "[0-9]")
{
    "Geen goede keuze."
    "Dit zijn de reeds gebruikte letters:"
    $letters
    $naam = Read-Host "Geef nu correcte naam in"
}
$locatie = Read-Host "Tot welke locatie wilt u een netwerkverbinding maken?`n1. Waalwijk`n2. Dendermonde`nX. Exit"
do
{
    switch($locatie)
    {
        1 {Waalwijk}
        2 {Dendermonde}
        X {exit}
        default {exit}
    }
}while ($locatie = Read-Host "Tot welke locatie wilt u een netwerkverbinding maken?`n1. Waalwijk`n2. Dendermonde`nX. Exit")


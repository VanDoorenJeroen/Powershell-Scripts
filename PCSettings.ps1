<#Keuzemenu#>
$antwoord = Read-Host "Wat wilt u doen?`n1. Disk space`n2. MAC adres opvragen`nGeef uw keuze"

<#Opvragen naam pc + testen connectie#>
$naampc = Read-Host "Geef naam pc in"
$testconnectie = Test-Connection -ComputerName $naampc -Count 2 -Quiet
if ($testconnectie -eq $false) 
{ 
    "Host is niet verbonden met het netwerk" 
    Exit 
}

<#afhankelijk van keuze opzoeken wat er moet gedaan worden#>
switch ($antwoord)
{
    1 {
        $comp = Get-WmiObject Win32_LogicalDisk -ComputerName $naampc | Where-Object {$_.Size -gt 0}
        foreach ($disk in $comp)
        {
            $schijf = $disk.DeviceID
            "Schijf $schijf heeft nog {0:#.0} GB vrij van de {1:#.0} GB." -f ($disk.FreeSpace/1GB),($disk.Size/1GB)
        }
    }
    2 {
        $items = Get-WmiObject -Class "Win32_NetworkAdapterConfiguration" -ComputerName $naampc | Where-Object {$_.DNSDomain -eq "desso.int"}
        foreach ($obj in $items)
        {
            Write-Host "IP Address: " $obj.IpAddress[0] "Mac: " $obj.MacAddress
        }
    }
    Default {"Verkeerde nummer ingegeven"}
}
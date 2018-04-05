#Variables where (path) and what (search) to search
$path = "\\walfs001\shareddata"
$search = "DG-WAL-MODIFY D"
$folders = Get-ChildItem $path
$obj = @()
$todo = @()


foreach ($folder in $folders)
{
    $naam = $folder.Name
    $rechten = Get-Acl "$path\$naam" #Get rights from folder
    $waarde = 0
    foreach ($recht in $rechten.Access)
    {
        $value = $recht.IdentityReference.Value
        $props = $recht.FileSystemRights.ToString()
        if($value.Contains($search))
        {
            $obj += New-Object psobject -Property @{
                    Name = $naam
                    Value = $value
                    Property = $props
            }
            $waarde++
        }
    }
}
$obj | Format-Table Name, Value, Property
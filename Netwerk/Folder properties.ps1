#Variables where (path) and what (search) to search
$path = "\\ddrfs001\shareddata"
$search = "GD_BE04"
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
            if($value.Contains("$search-Modify") -and $props.Contains("ReadAndExecute") -or ($value.Contains("$search-Read") -and $props.Contains("Modify"))){
                $obj += New-Object psobject -Property @{
                Name = $naam
                Value = $value
                Property = "------>$props<-----"            
                }
            }
            else {
                $obj += New-Object psobject -Property @{
                    Name = $naam
                    Value = $value
                    Property = $props
                }
            }
            $waarde++
        }
    }
    if($waarde -eq 0) {$todo += $naam}
}
$obj | Format-Table Name, Value, Property
$todo 
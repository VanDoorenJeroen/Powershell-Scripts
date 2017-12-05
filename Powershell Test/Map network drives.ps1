$drives = @("\\ddrfs001\shareddata\IT","\\walfs001\shareddata\IT")

foreach ($drive in $drives)
{
$drive = ls function:[g-z]: -n | ?{ !(test-path $_) } | select -First 2
New-PSDrive -Name $drive -PSProvider FileSystem -Root $drive -Persist
}

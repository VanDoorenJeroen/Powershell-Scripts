<# Remove all files with specific name/extension #>
$Path = C:\Users

Get-ChildItem $Path -Include *.locky -Recurse #| foreach ($_) { Remove-Item $_.FullName }
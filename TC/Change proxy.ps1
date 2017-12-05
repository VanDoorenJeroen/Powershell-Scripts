$path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'

$enabled = Get-ItemProperty $path

if($enabled.ProxyEnable -eq 1) 
{
    Set-ItemProperty -Path $path -Name ProxyEnable -Value 0
    Set-ItemProperty -Path $path -Name ProxyServer -Value ""
    Set-ItemProperty -Path $path -Name ProxyOverride -Value ""
    Write-Host "Proxy is now Disabled"
}
else 
{ 
    Set-ItemProperty -Path $path -Name ProxyEnable -Value 1
    Set-ItemProperty -Path $path -Name ProxyServer -Value "ddras000:8080"
    Set-ItemProperty -Path $path -Name ProxyOverride -Value “<local>”
    Write-Host "Proxy is now enabled"
}
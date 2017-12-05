#Computers waar het op moet geinstalleerd worden
$computers = "DDRTC015","DDRTC016","DDRTC017","DDRTC018","DDRTC019","DDRTC020"

#Geef credentials in.
$cred = Get-Credential

#Overloop alle pc's om software silent install te doen.
foreach ($comp in $computers){
    Invoke-WmiMethod -ComputerName $comp -Class Win32_Process -Name Create -ArgumentList "\\ddrnas01\public\software\vmware\Keyboard LED\keyboard-leds.exe /S" -Credential $cred
}

<#Alternatief maar niet werkende, nog na te kijken
#$command = “cmd.exe /c \\ddrnas01\public\software\vmware\Keyboard LED\keyboard-leds.exe /S”
#$process = Invoke-WmiMethod -ComputerName ITKVM-LT -Class Win32_Process -Name Create -ArgumentList "\\ddrnas01\public\software\vmware\Keyboard LED\keyboard-leds.exe /S"
#$process = [WMICLASS]"\\ITJVD-LT.desso.int\C\CIMV2:win32_process"
#$process.Create($command)
$command = "KeyboardLeds.exe /c C:\Program Files (x86)\Keyboard LEDs"
$proc = [WMICLASS]"\\itjvd-lt\ROOT\CIMV2:win32_process"
$result =  $proc.create($commmand)
#>
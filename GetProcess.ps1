#Get-Process * -ComputerName "BE04DW70010"
$PROCESSNAAM = "DontSleep*"
$HOMEFOLDER = "\\BE04SFP001\home$\doorenj\Windows Scripts\Powershell-Scripts\Hydra"
$HYDRA = Import-Csv $HOMEFOLDER\HydraTerminalBE.csv -Delimiter ";"


<#Check if proccess is running on each computer
AND Delete files#>
$HYDRA | Foreach {
    $terminal = $_.terminal
    if(Test-Connection $terminal -Count 1 -Quiet) {
        [int]$number = [convert]::ToInt32($terminal.Substring($terminal.Length-2))-2
        if($number -lt 10) { $USERNAME = "BE04_Hydra00$number" }
        else { $USERNAME = "BE04_Hydra0$number" }
        $STARTUPPATH = "\\$terminal\c$\Users\$USERNAME\appdata\roaming\Microsoft\Windows\Start Menu\Programs\Startup\$PROCESSNAAM"
        $DESKTOPPATH = "\\$terminal\c$\Users\$USERNAME\Desktop\$PROCESSNAAM"

        <#Check if process is running and delete it#>
        $processes = Gwmi -Class win32_process -ComputerName $terminal -ErrorAction SilentlyContinue | ? { $_.Name -like $PROCESSNAAM }
        if($processes) {
            #$returnVal = $processes.Terminate()
            if ($returnval.returnvalue -eq 0) {
                Write-Host "The process $PROCESSNAAM terminated on $terminal"
            }
            else { "$PROCESSNAAM not succesfully terminated" }
        }
        else{ "$terminal has no $PROCESSNAAM process" }#>
    }

}


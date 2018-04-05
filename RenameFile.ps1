#Get-Process * -ComputerName "BE04DW70010"
$APPNAAM = "ITServices.exe"
$HOMEFOLDER = "\\BE04SFP001\home$\doorenj\Windows Scripts\Powershell-Scripts\Hydra"
$HYDRA = Import-Csv $HOMEFOLDER\HydraTerminalBE.csv -Delimiter ";"


<#Check if proccess is running on each computer
AND Delete files#>
$HYDRA | Foreach {
    $terminal = $_.Terminal
    if(Test-Connection $terminal -Count 1 -Quiet) {
        [int]$number = [convert]::ToInt32($terminal.Substring($terminal.Length-2))-2
        if($number -lt 10) { $USERNAME = "BE04_Hydra00$number" }
        else { $USERNAME = "BE04_Hydra0$number" }
        $APPPATH = "\\" + $terminal + "\C$\Program Files\ITServices\" + $APPNAAM

        <#Check if files exists and delete#>
        if (Test-Path $APPPATH) { Rename-Item $APPPATH "ITServices.exe.old"
        "ITServices $Terminal Renamed!" }
        else { "$terminal No AppPath" }
    }

}

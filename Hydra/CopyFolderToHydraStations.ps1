

$HOMEFOLDER = "\\BE04SFP001\home$\doorenj\Windows Scripts\Powershell-Scripts\Hydra"
$PATHFOLDER = "\\BE04SFP001\team`$\FoCus\Selfcuring_Hydra\"
$FOLDER = "ctwin_backup"

$HYDRA = Import-Csv $HOMEFOLDER\HydraTerminalBE.csv -Delimiter ";"

$HYDRA | Foreach {
    $terminal = $_.Terminal
    $connection = Test-Connection -ComputerName $terminal -Quiet -Count 1
    if (-Not $connection) {
        "$Terminal offline"
    }
    else {
        $CDrive = '\\' + $terminal + '\C$'
        try {
            $Drive = New-PSDrive -Name "T" -PSProvider FileSystem -Root $CDrive -ErrorAction Stop
            $test = $Drive.Root + '\ctwin_backup'
            if (Test-Path -Path $test) {
                Remove-Item $test -Recurse -Force
            }
                Copy-Item $PATHFOLDER\$FOLDER -Destination $CDrive -Recurse -Force
                "$FOLDER naar $Terminal gekopieerd"
                sleep -s 3
                $inifile = $Drive.Root + '\ctwin\ctwin.ini'
                $backup = $Drive.Root + '\ctwin_backup'
                Copy-Item $inifile -Destination $backup -Force
                "Ctwin.ini gekopieerd"
                sleep -s 3
                $username = gwmi win32_computersystem -ComputerName $Terminal | select Username
                $username = $username.Username.Replace("EU\","")
                $startuploc = $drive.Root + '\Users\' + $username + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup'
                $ctwinbackup = '\\BE04SFP001\Team$\Hydra Backup\start_ctwin.bat.lnk'
                Get-ChildItem $startuploc -Include * | Remove-Item -Recurse
                Copy-Item $ctwinbackup -Destination $startuploc -Force
                "start_ctwin gekopieerd"
        }
        Catch {
            "$_ on $terminal"
        }
        Finally {
            if (Get-PSDrive T -ErrorAction SilentlyContinue) { Remove-PSDrive T }
            Restart-Computer -ComputerName $Terminal -Force -Wait -For Wmi -Timeout 60
            "$Terminal rebooted!"
            Sleep -s 5
        }
    }
}
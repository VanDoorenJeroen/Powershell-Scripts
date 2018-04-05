######                                 ######
###                                       ###
###                                       ###
###          RESTART TERMINALS            ###
###                                       ###
###                                       ###
######                                 ######

<# VARIABLES #>

$HOMEFOLDER = "\\BE04SFP001\home$\doorenj\Windows Scripts\Powershell-scripts\Hydra"
#$FILE = "Copy_Hydra.ps1"
#$HYDRA = Import-Csv $HOMEFOLDER\HydraTerminalBE.csv -Delimiter ";"
#$Hydra = @("BE04DW70003","BE04DW70004","BE04DW70005","BE04DW70006","BE04DW70007","BE04DW70008","BE04DW70009","BE04DW70010","BE04DW70011","BE04DW70012")
$Hydra = @("BE04DW700013","BE04DW70014","BE04DW70015","BE04DW70016","BE04DW70017","BE04DW70018","BE04DW70019","BE04DW70020","BE04DW70021","BE04DW70022","BE04DW70023","BE04DW70024","BE04DW70025","BE04DW70026","BE04DW70027","BE04DW70028","BE04DW70029","BE04DW70030","BE04DW70031","BE04DW70032","BE04DW70033","BE04DW70034","BE04DW70035","BE04DW70036","BE04DW70037","BE04DW70038","BE04DW70039","BE04DW70040","BE04DW70041","BE04DW70042")

<# Restart all terminals #>

$Hydra | foreach {
    $Terminal = $_
    $connection = Test-Connection -ComputerName $terminal -Quiet -Count 1
    if (-Not $connection) {
        "$Terminal offline"
    }
    else {
        try {
            Restart-Computer -ComputerName $Terminal -Force -Wait -For Wmi -Timeout 60
            "$Terminal rebooted!"
        }
        Catch {
            "$_ on $terminal"
        }
    }
}
######                                 ######
###                                       ###
###                                       ###
###               COPY FILES              ###
###                                       ###
###                                       ###
######                                 ######


<# VARIABLES #>

$HOMEFOLDER = "\\BE04SFP001\home$\doorenj\Windows Scripts\Powershell\Hydra"
$FILE = "Copy_Hydra.ps1"
$HYDRA = Import-Csv $HOMEFOLDER\Tarkett.csv -Delimiter ";"

<# Copy file to all Hydra terminals #>

$Hydra | foreach {
    $Terminal = $_.Terminal
    $connection = Test-Connection -ComputerName $terminal -Quiet -Count 1
    if (-Not $connection) {
        "$Terminal offline"
    }
    else {
        $CDrive = '\\' + $terminal + '\C$\Backup'
        try {
            $Drive = New-PSDrive -Name "T" -PSProvider FileSystem -Root $CDrive -ErrorAction Stop
            Copy-Item $HOMEFOLDER\$FILE -Destination $CDrive -Force
            "$FILE naar $Terminal gekopieerd"
        }
        Catch {
            "$_ on $terminal"
        }
        Finally {
            if (Get-PSDrive T -ErrorAction SilentlyContinue) { Remove-PSDrive T }
        }
    }
}
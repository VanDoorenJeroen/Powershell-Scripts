######                                 ######
###                                       ###
###                                       ###
###           TEST HYDRA SCRIPT           ###
###                                       ###
###                                       ###
######                                 ######


<# VARIABLES #>

$HOMEFOLDER = "\\BE04SFP001\home$\doorenj\Windows Scripts\Powershell-Scripts\Hydra"
$LOGFILE = "LogsBE.csv"
$HYDRA = Import-Csv $HOMEFOLDER\HydraTerminalBE.csv -Delimiter ";"
$MAILBE = @("DL_BE04_Desso_IT@tarkett.com", "Nicolas.VanDenBossche@tarkett.com", "Gunter.Geysen@Tarkett.com")
#$MAILBE = @("Jeroen.VanDooren@tarkett.com")


<# SEND MAIL #>

Function SendMail {
    $emailSmtpServer = "smtp-eu.intra-global.net"
    $emailFrom = "NoReply@Tarkett.com"
    if($MAILBE.Count -eq 1) {
        $emailTo = $MAILBE[0]
        $emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )
    }
    else {
        $emailTo = $MAILBE[0]
        $emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )
        for($i = 1; $i -lt $MAILBE.count;$i++){
            $emailMessage.To.Add($MAILBE[$i])
        }
    }

    $style = "<style>BODY{font-family: Verdana; font-size: 10pt;}"
    $style = $style + "TABLE{border: 1px solid black; border-collapse: collapse;}"
    $style = $style + "TH{border: 1px solid black; background: #dddddd; padding: 5px; }"
    $style = $style + "TD{border: 1px solid black; padding: 5px; }"
    $style = $style + "</style>"

    $emailMessage.Subject = "Hydra Check" 
    $emailPre = "This message was created on $(Get-Date) from $env:COMPUTERNAME <br/>"
    $emailMessage.IsBodyHtml = $true #true or false depends
    $emailMessage.Body = $HYDRA | ConvertTo-Html -Property Terminal, Printer, Department, Location, 'Printer Status', 'Terminal Notification' -Head $style -PreContent $emailPre | Out-String
 
    $SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer )
    $SMTPClient.EnableSsl = $False
    $SMTPClient.Send( $emailMessage )
}

<# CHECK ALL HYDRA STATIONS #

Checks if:
1. Devices are online
2. If it's possible to make conneciton with PC
3. Checks if the pc has an ini file
4. Checks if the ini file isn't overwritten
5. If CTWIN is running

Returns status of the device with its location and dept

#>

Function CheckAllHydraStations {
    $HYDRA | foreach {
        $Terminal = $_.Terminal
        $TerminalOutput = ""
        $TerminalConnection = Test-Connection -Computername $terminal -Quiet -Count 1
        if (-Not $TerminalConnection) {
            $TerminalOutput = "Offline"
        }
        else {
            $FileExists = '\\' + $terminal + '\C$\ctwin\ctwin.ini'
            $CDrive = '\\' + $terminal + '\C$'
            try {
                $Drive = New-PSDrive -Name "T" -PSProvider "FileSystem" -Root $CDrive -ErrorAction Stop
                if (Test-Path $FileExists) {
                    If ((Get-Item $FileExists).Length -lt 5kb) {
                        $TerminalOutput = "CTWIN overwritten"
                    }
                    else {
                        Try {
                            #$error = Get-WmiObject win32_process -ComputerName $Terminal -Filter "name='tasten32.exe'" -ErrorAction SilentlyContinue
                            $ctwin = Get-WmiObject win32_process -ComputerName $Terminal -Filter "name='ctwin.exe'" -ErrorAction Stop
                            #if ( $error ) {
                            #    $TerminalOutput = "Tasten32 Error"
                            #}
                            if ( $ctwin ) {
                                $TerminalOutput = "OK"
                            }
                            else {
                                $TerminalOutput = "CTWIN not running"
                            }
                        }
                        catch {
                            $TerminalOutput = "$_"
                        }
                    }
                }
                else {
                    $TerminalOutput = "No ini file"
                }
            }
            Catch [System.IO.IOException] {
                $TerminalOutput = "Not reachable"
            }
            Catch {
                $TerminalOutput = "$_"
            }
            Finally {
                 if (Get-PSDrive T -ErrorAction SilentlyContinue) {Remove-PSDrive T}
            }
        
        }
        $TerminalNotification.Add($terminal, $TerminalOutput)
    }
}

<# CHECK ALL HYDRA PRINTERS #>

Function CheckAllHydraPrinters { 
    $HYDRA | Foreach {
        $Printer = $_.Printer
        $PrinterOutput = ""
        $PrinterConnection  = Test-Connection -ComputerName $Printer -Quiet -Count 1 
        switch ($PrinterConnection) {
            $true { $PrinterOutput = "Online" }
            $false { $PrinterOutput = "Offline" }
        }
        if ($Printer -like "*BE04P*") { $PrinterNotification.Add($Printer, $PrinterOutput) }
    }
}

<# CREATE OR OVERWRITE LOGFILE #>

Function CreateLogFile {
    if (Test-Path $HOMEFOLDER\$LOGFILE) {
    $log = Import-Csv $HOMEFOLDER\$LOGFILE -Delimiter "," 
    $log | Foreach { $_ | Add-Member -Type NoteProperty -Name $date -Value $TerminalNotification.Item($_.Terminal) }
    $log | Export-csv $HOMEFOLDER\$LOGFILE -NoTypeInformation
    }
    else{
        [System.Collections.ArrayList]$log = @()
        $log.Add("Terminal,$date")
        foreach ($terminal in $HYDRA) {
            $state = $terminal.Terminal+","+$TerminalNotification.Item($terminal.Terminal)
            $log.Add($state)
        }   
        $log | Out-File $HOMEFOLDER\$LOGFILE 
    }
}

<#Main function#>
$date = Get-Date
$TerminalNotification = @{}
$PrinterNotification = @{}
CheckAllHydraStations
CheckAllHydraPrinters
$HYDRA | Foreach {
    if($_.Printer -like "*BE04P*") { $_ | Add-Member -Type NoteProperty -Name "Printer Status" -Value $PrinterNotification.Item($_.Printer) }
    $_ | Add-Member -type NoteProperty -Name "Terminal Notification" -Value $TerminalNotification.Item($_.Terminal)
}
if($env:COMPUTERNAME -like "BE04LW80002"){
    $HYDRA | FT
}
else {
    SendMail
    CreateLogFile 
}

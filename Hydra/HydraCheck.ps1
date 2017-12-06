﻿######                                 ######
###                                       ###
###                                       ###
###           TEST HYDRA SCRIPT           ###
###                                       ###
###                                       ###
######                                 ######


<# VARIABLES #>

$HOMEFOLDER = "\\BE04SFP001\home$\doorenj\Windows Scripts\Powershell-Scripts\Hydra"
$HYDRA = Import-Csv $HOMEFOLDER\HydraTerminalBE.csv -Delimiter ";"
$MAILBE = @("DL_BE04_Desso_IT@tarkett.com", "Nicolas.VanDenBossche@tarkett.com", "Gunter.Geysen@Tarkett.com")


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
    $emailMessage.Body = $HYDRA | ConvertTo-Html -Property Terminal,Department, Location, Notification -Head $style -PreContent $emailPre | Out-String
 
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
    $Output = ""
    $connection = Test-Connection -Computername $terminal -Quiet -Count 1
    if (-Not $connection) {
        $Output = "Offline"
    }
    else {
        $FileExists = '\\' + $terminal + '\C$\ctwin\ctwin.ini'
        $CDrive = '\\' + $terminal + '\C$'
        try {
            $Drive = New-PSDrive -Name "T" -PSProvider "FileSystem" -Root $CDrive -ErrorAction Stop
            if (Test-Path $FileExists) {
                If ((Get-Item $FileExists).Length -lt 5kb) {
                    $Output = "CTWIN overwritten"
                }
                else {
                    Try {
                        #$error = Get-WmiObject win32_process -ComputerName $Terminal -Filter "name='tasten32.exe'" -ErrorAction SilentlyContinue
                        $ctwin = Get-WmiObject win32_process -ComputerName $Terminal -Filter "name='ctwin.exe'" -ErrorAction Stop
                        #if ( $error ) {
                        #    $Output = "Tasten32 Error"
                        #}
                        if ( $ctwin ) {
                            $Output = "OK"
                        }
                        else {
                            $Output = "CTWIN not running"
                        }
                    }
                    catch {
                        $Output = "$_"
}
                }
            }
            else {
                $Output = "No ini file"
            }
        }
        Catch [System.IO.IOException] {
            $Output = "Not reachable."
        }
        Catch {
            $Output = "$_"
        }
        Finally {
             if (Get-PSDrive T -ErrorAction SilentlyContinue) {Remove-PSDrive T}
        }
        
    }
    $Notification.Add($terminal, $Output)
}
}


<#Main function#>
$date = Get-Date
$Notification = @{}
CheckAllHydraStations
$HYDRA | Foreach {
    $_ | Add-Member -type NoteProperty -Name Notification -Value $Notification.Item($_.Terminal)
}
$HYDRA | FT
SendMail
$log = Import-Csv $HOMEFOLDER\LogsBE.csv -Delimiter "," 
$log | Foreach { $_ | Add-Member -Type NoteProperty -Name $date -Value $Notification.Item($_.Terminal) }
$log | Export-csv $HOMEFOLDER\LogsBE.csv -NoTypeInformation
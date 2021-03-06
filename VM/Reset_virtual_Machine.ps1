#========================================================================================================================================================
# Write some text info to the screen to inform the user what he needs to complete this script.
# PowerCLI must be installed on the pc that will run this script.

cls
write-host "==============================================================================="
write-host "This script will reset the Virtual machine you enter."
write-host "==============================================================================="
write-host ""

#end of info section displayed on the screen.
#========================================================================================================================================================

#========================================================================================================================================================
# Create the inputboxes to collect the needed info to run the script correctly.

write-host "==============================================================================="
$virtual_host = read-host "Enter the name of the Virtual host that will reset. (Example: DDRTC00x)"
$virtual_host = $virtual_host.ToUpper()
write-host "==============================================================================="

cls

#========================================================================================================================================================
# Connect to the connection manager.

write-host "==============================================================================="
write-host "Connecting to the Connection Manager, Virtual host will get the reset command."
write-host "==============================================================================="
Start-Sleep -s 2 

$session = New-PSSession -ComputerName "ddrcman1.desso.int"

Invoke-Command -Session $session -ScriptBlock {Add-PSSnapin VMware*}

Import-PSSession -Session $session -Module VMware*

Get-Pool -pool_id $virtual_host | Get-DesktopVM | Send-VMReset

#end of script.
#========================================================================================================================================================


write-host "==============================================================================="
write-host "Script completed!"
write-host "==============================================================================="
pause
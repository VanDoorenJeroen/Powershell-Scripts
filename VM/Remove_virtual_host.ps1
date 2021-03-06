#========================================================================================================================================================
# Write some text info to the screen to inform the user what he needs to complete this script.
# PowerCLI must be installed on the pc that will run this script.

cls
write-host "==============================================================================="
write-host "This script will Delete the Virtual machine you enter from the VM server,"
write-host " connection manager and from the VEEAM backup."
write-host "==============================================================================="
write-host ""

#end of info section displayed on the screen.
#========================================================================================================================================================

#========================================================================================================================================================
# Create the inputboxes to collect the needed info to run the script correctly.

write-host "==============================================================================="
$virtual_host = read-host "Enter the name of the Virtual host that you will delete. (Example: DDRTC00x)"
$virtual_host = $virtual_host.ToUpper()
write-host "==============================================================================="

cls

#========================================================================================================================================================
# Connect to the connection manager.

write-host "==============================================================================="
write-host "Connecting to the Connection Manager, Virtual host will be deleted."
write-host "==============================================================================="
Start-Sleep -s 2 

$session = New-PSSession -ComputerName "ddrcman1.desso.int"

Invoke-Command -Session $session -ScriptBlock {Add-PSSnapin VMware*}

Import-PSSession -Session $session -Module VMware*

Remove-Pool -pool_id $virtual_host -DeleteFromDisk 1

Remove-PSSession -id 1

Invoke-Command -ComputerName ddras015 -ScriptBlock { 
    Add-PSSnapin VeeamPSSnapIn
    $job = Get-VBRJob | where {$_.name -eq "job12"}
    $oldvm = Get-VBRJobObject ($job) | where {$_.name -eq $using:virtual_host}
    $oldvm.Delete()
    }

write-host "==============================================================================="
write-host "Script completed!"
write-host "==============================================================================="
pause

#end of script.
#========================================================================================================================================================


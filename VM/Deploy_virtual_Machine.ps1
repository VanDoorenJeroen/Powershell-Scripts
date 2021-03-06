#========================================================================================================================================================
# Write some text info to the screen to inform the user what he needs to complete this script.
# PowerCLI must be installed on the pc that will run this script.

cls
write-host "This script will create a new Virtual machine."
write-host "Before continuing you must have the following info to create the host."
write-host "==============================================================================="
write-host "- The managing Vcenterserver. (Example: vcenterddr01)"
write-host "- The name of the physical VM server where you will deploy the virtual host to. (Example: ddrvm05)"
write-host "- Typ of virtual host. Production or office."
write-host "-- For Production type: Production (case sensitive)"
write-host "-- For Office type: Office (case sensitive)"
write-host "- The name of the virtual host that you will deploy. (Example: DDRTC022)"
write-host "- The username That will be used by default on this new virtual machine. (Example: DDRTC022)"
write-host "==============================================================================="
write-host "The deployed VM guest will be added automatically to the veeam backup configuration"
write-host "==============================================================================="

#end of info section displayed on the screen.
#========================================================================================================================================================

#========================================================================================================================================================
# Create the inputboxes to collect the needed info to run the script correctly.

$domain = ".desso.int"
$vcenter_server = read-host "Enter the name of the VCenter server that will manage the new virtual host that you want to deploy. (Example: VCENTERDDR02)"
$vcenter_server_name = $vcenter_server
$vcenter_server = $vcenter_server + $domain.ToUpper()

write-host "==============================================================================="

$vm_server = read-host "Enter the name of the VMWare server where the virtual host will be deployed to. (Example: DDRVM05)"
$data_store = "DS2-" + $vm_server.ToUpper()
$vm_server = $vm_server + $domain.ToUpper()

write-host "==============================================================================="

$virtual_host = read-host "Enter the name of the Virtual host that you  will deploy. (Example: DDRTC00x)"
$virtual_host = $virtual_host.ToUpper()

write-host "==============================================================================="

$virtual_user = read-host "Enter the username that will be used by default on the new VM guest. (Example: DDRTC00x)"
$virtual_user = $virtual_user.ToUpper()

write-host "==============================================================================="

$type_host = read-host "Enter the type of Virtual machine that you want to deploy. (Case sensitive: Production OR Office)"
    if ($type_host -eq "Production"){
        $type_host = "Windows_XP_Production"
        $wizard = "Desso Production"
    }else{
        $type_host = "Windows_7_Office"
        $wizard = "Desso Office"
    }

write-host "==============================================================================="
cls
write-host "==============================================================================="
write-host "Please be patient, script is connecting to the VMWare environment..."
write-host "==============================================================================="
Start-Sleep -s 2

#end of info section displayed on the screen.
#========================================================================================================================================================

#========================================================================================================================================================
# Connect to the vcenterserver, and load all external cmdlets from the connection manager.
# Execute all commands to create the virtualhost

Set-PowerCLIConfiguration -InvalidCertificateAction ignore -ProxyPolicy NoProxy -Confirm:$False
cls
write-host "==============================================================================="
write-host "VMWare Cmdlets are loading into the script"
write-host "==============================================================================="
Start-Sleep -s 2
Connect-VIServer $vcenter_server
cls
write-host "==============================================================================="
write-host "Connected to the Vcenterserver, and deploy of guest will be started"
write-host "==============================================================================="
Start-Sleep -s 2
new-vm -vmhost $vm_server -Name $virtual_host -Template $type_host -Datastore $data_store -OSCustomizationSpec $wizard -DiskStorageFormat Thin
cls
write-host "==============================================================================="
write-host "Guest is deployed, and is now starting up in background"
write-host "==============================================================================="
Start-Sleep -s 2
start-vm -vm $virtual_host
cls
#end of Creating the virtualhost.
#========================================================================================================================================================

#========================================================================================================================================================
# Create a Pool and antitlement on the connection manager.

write-host "==============================================================================="
write-host "Connecting to the Connection Manager, Pool en Entitlement will be created..."
write-host "==============================================================================="
Start-Sleep -s 2 

$session = New-PSSession -ComputerName "ddrcman1.desso.int"

Invoke-Command -Session $session -ScriptBlock {Add-PSSnapin VMware*}

Import-PSSession -Session $session -Module VMware*

Get-DesktopVM -Name $virtual_host | select id | out-file c:\vm_id.txt

$tmp = gc c:\vm_id.txt

$data = $tmp[3] | out-file c:\vm_id.txt

$data = gc c:\vm_id.txt

$vm_host_id = $data.Substring(0,23)

Add-ManualPool -pool_id $virtual_host -DisplayName $virtual_host -vc_name $vcenter_server_name -id $vm_host_id -persistence Persistent

Get-User -Name $virtual_user -domain desso.int | select sid | out-file c:\vm_sid.txt

$tmp = gc c:\vm_sid.txt

$data = $tmp[3] | out-file c:\vm_sid.txt

$data = gc c:\vm_sid.txt

$vm_user_sid = $data.Substring(0,47)

Add-PoolEntitlement -pool_id $virtual_host -sid $vm_user_sid

Remove-PSSession -id 1

Remove-Item C:\vm_id.txt
Remove-Item C:\vm_sid.txt

#end of Creating the pool and the entitlement.
#========================================================================================================================================================

#========================================================================================================================================================
# Add the new created VM host to the correct Veeam Backup / Replication Job.

write-host "==============================================================================="
write-host "Connecting to the Veeam server, host will be added into the replication and backup jobs..."
write-host "==============================================================================="
Start-Sleep -s 2 

if ($vm_server -eq "DDRVM01.DESSO.INT"){
        $veeam_server = "DDRVEAM1"
        $jobname_repl = "DDRVM01 -> DDRVM02"
        $jobname_back_incr = "DDRVM01 Incr -> DDRNAS03"
        $jobname_back_full = "DDRVM01 Full -> DDRNAS03"}
elseif  ($vm_server -eq "DDRVM02.DESSO.INT"){
        $veeam_server = "DDRVEAM1"
        $jobname_repl = "DDRVM02 -> DDRVM03"
        $jobname_back_incr = "DDRVM02 Incr -> DDRNAS03"
        $jobname_back_full = "DDRVM02 Full -> DDRNAS03"}
elseif  ($vm_server -eq "DDRVM03.DESSO.INT"){
        $veeam_server = "DDRVEAM1"
        $jobname_repl = "DDRVM03 -> DDRVM01"
        $jobname_back_incr = "DDRVM03 Incr -> DDRNAS03"
        $jobname_back_full = "DDRVM03 Full -> DDRNAS03"}
elseif  ($vm_server -eq "DDRVM04.DESSO.INT"){
        $veeam_server = "DDRVEAM2"
        $jobname_repl = "DDRVM04 -> DDRVM05"
        $jobname_back_incr = "DDRVM04 Incr -> DDRNAS03"
        $jobname_back_full = "DDRVM04 Full -> DDRNAS03"}
elseif  ($vm_server -eq "DDRVM05.DESSO.INT"){
        $veeam_server = "DDRVEAM2"
        $jobname_repl = "DDRVM05 -> DDRVM07"
        $jobname_back_incr = "DDRVM05 Incr -> DDRNAS03"
        $jobname_back_full = "DDRVM05 Full -> DDRNAS03"}
elseif  ($vm_server -eq "DDRVM07.DESSO.INT"){
        $veeam_server = "DDRVEAM2"
        $jobname_repl = "DDRVM07 -> DDRVM04"
        $jobname_back_incr = "DDRVM07 Incr -> DDRNAS03"
        $jobname_back_full = "DDRVM07 Full -> DDRNAS03"}


Enter-PSSession -ComputerName $veeam_server

Add-PSSnapin VeeamPSSnapIn

$ViHost = Get-VBRServer -Name $vm_server
$job_repl = Get-VBRJob -Name $jobname_repl
$job_back_incr = Get-VBRJob -Name $jobname_back_incr
$job_back_full = Get-VBRJob -Name $jobname_back_full
$jobObject = $ViHost | Find-VBRObject -Name $virtual_host

Add-VBRJobObject -Job $job_repl -Server $ViHost -Objects $JobObject

Add-VBRJobObject -Job $job_back_incr -Server $ViHost -Objects $JobObject

Add-VBRJobObject -Job $job_back_full -Server $ViHost -Objects $JobObject 

exit

write-host "==============================================================================="
write-host "Script completed!"
write-host "==============================================================================="
pause
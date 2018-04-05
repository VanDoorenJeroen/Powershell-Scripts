#Enter name of Task to check
$TASKNAME = "MyCloudNASConnectAutoStartup"

<#Get Last Run Result variable
Remove spaces
Get value after :#>
$task = schtasks /Query /FO LIST /V /TN $TASKNAME | FindStr "Result"
$task = $task.Replace(' ','')
$task = $task.Substring($task.IndexOf(":")+1)

<#Run task if Last Run Result isn't 0 #>
while($task -ne 0)
{
    schtasks /Run /TN $TASKNAME
    Start-Sleep -s 300
}
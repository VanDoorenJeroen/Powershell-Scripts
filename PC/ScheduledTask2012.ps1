<#Restart task when LastTaskResult isn't 0
Only works on Win8.1 & Server2012#>
$TASKNAME = "Sysaid"
$jobs = Get-ScheduledTask -TaskName $TASKNAME | Get-ScheduledTaskInfo
$jobs
foreach ($job in $jobs)
{
    if ($job.LastTaskResult -ne 0)
    {
        Start-ScheduledTask  -TaskName $job.TaskName 
    }
}
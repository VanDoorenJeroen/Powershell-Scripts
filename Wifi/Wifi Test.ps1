$Comp = "192.168.2.1", "192.168.2.2", "192.168.2.3", "192.168.2.4", "192.168.2.6"


Add-Content C:\Users\doorenj\Desktop\IP.txt -value ("1`t`t2`t`t3`t`t4`t`t6`tTIME")
While ($true) {

    foreach ($pc in $Comp){
        if(Test-Connection $pc -Count 1 -Quiet)
        {
            Write-Host "$pc OK"
        }
        else
        {
            
            switch($pc)
            {
                "192.168.2.1" { Add-Content C:\Users\doorenj\Desktop\IP.txt -value ("X`t`t`t`t`t`t`t`t`t"+(Get-Date)) }
                             
                "192.168.2.2" { Add-Content C:\Users\doorenj\Desktop\IP.txt -value ("`t`tX`t`t`t`t`t`t`t"+(Get-Date)) }
                             
                "192.168.2.3" { Add-Content C:\Users\doorenj\Desktop\IP.txt -value ("`t`t`t`tX`t`t`t`t`t"+(Get-Date)) }
                
                "192.168.2.4" { Add-Content C:\Users\doorenj\Desktop\IP.txt -value ("`t`t`t`t`t`tX`t`t`t"+(Get-Date)) }
                
                "192.168.2.6" { Add-Content C:\Users\doorenj\Desktop\IP.txt -value ("`t`t`t`t`t`t`t`tX`t"+(Get-Date)) }
            }
        }
    sleep 1
    }
}
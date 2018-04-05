######                                 ######
###                                       ###
###                                       ###
###             Export Data AD            ###
###                                       ###
###                                       ###
######                                 ######

# IMPORT MODULES #
Import-Module ActiveDirectory

# VARIABLES #
$pcOU = @('OU=Computers,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net',"OU=Production,OU=BE04_Dendermonde,OU=_EMEA,DC=eu,DC=intra-global,DC=net")
$csv = Import-Csv 'C:\Users\doorenj\Downloads\export.csv'  -Delimiter ","
$Output = @()

# START 
$computers = $pcOU | foreach { Get-ADComputer -Filter {Enabled -eq $true} -Properties CN, Description, whenCreated, OperatingSystem -SearchBase $_ }
foreach ($computer in $computers) {
    $description = $computer.Description.Split(':')
    $username = $description[2].Replace("eu\","").Trim()
    $user = Get-ADUser -Filter "CN -eq ""$username""" -Properties *
    $pcCSV = $csv | Where-Object {$_.Name -like $computer.CN}
    if($pcCSV) {
        $model = $pcCSV.Model
        $serial = $pcCSV.Serial
        $assetTag = $computer.CN
        $status = "In Use"
        $mainUser = $user.UserPrincipalName
        $userDeliveryDate = $computer.whenCreated.ToShortDateString()
        $location = "BE04"
        $department = $user.Department
        $tag = $description[1].Trim()
        $operatingSystem = $computer.OperatingSystem
        $osLanguage = "English - United States"
        $hostname = $computer.CN
        $tarkettMasterImage = "Yes"
     }
     else {
        $model = ""
        $serial = ""
        $assetTag = $computer.CN
        $status = "In Use"
        $mainUser = $user.UserPrincipalName
        $userDeliveryDate = $computer.whenCreated.ToShortDateString()
        $location = "BE04"
        $department = $user.Department
        $tag = $description[1].Trim()
        $operatingSystem = $computer.OperatingSystem
        $osLanguage = "English - United States"
        $hostname = $computer.CN
        $tarkettMasterImage = "Yes"        
     }
     $output += $model + ',' + $serial + ',' + $assetTag + ',' + $status + ',' + $mainUser + ',' + $userDeliveryDate + ',' + $location + ',' + $department + ',' + $tag + ',' + $operatingSystem + ',' + $osLanguage + ',' + $hostname + ',' + $tarkettMasterImage
}
$Output | Out-File C:\Users\doorenj\Desktop\Test.csv

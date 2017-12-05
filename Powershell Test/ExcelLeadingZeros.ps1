function Is-Numeric ($Value) {
    return $Value -match "^[\d\.]+$"
}

$csv = Import-Csv C:\Users\doorenj\Desktop\GEGEVENS.csv -Delimiter ';'
foreach ($user in $csv)
{
    if(Is-Numeric ($user.0))
    {
        if($user.0 -match '^\d{8,10}$')
        {
            $user.0 = "0" + $user.0
            $user.0
        }
        elseif($user.0 -match '\d{11,15}')
        {
            $user.0 = "00" + $user.0
            $user.0
        }
    }
    if(Is-Numeric ($user.4))
    {
        if($user.4 -match '^\d{8,10}$')
        {
            $user.4 = "0" + $user.4
            $user.4
        }
        elseif($user.4 -match '\d{11,15}')
        {
            $user.4 = "00" + $user.4
            $user.4
        }

    }
        if(Is-Numeric ($user.5))
    {
        if($user.5 -match '^\d{8,10}$')
        {
            $user.5 = "0" + $user.5
            $user.5
        }
        elseif($user.5 -match '\d{11,15}')
        {
            $user.5 = "00" + $user.5
            $user.5
        }

    }
        if(Is-Numeric ($user.6))
    {
        if($user.6 -match '^\d{8,10}$')
        {
            $user.6 = "0" + $user.6
            $user.6
        }
        elseif($user.6 -match '\d{11,15}')
        {
            $user.6 = "00" + $user.6
            $user.6
        }

    }
}
#$csv | Export-Csv C:\Users\doorenj\Desktop\test2.csv -Delimiter ';' #Geeft " bij output
$csv | ConvertTo-Csv -NoTypeInformation | % {$_.Replace('"','')} | Out-File C:\Users\doorenj\Desktop\output.csv

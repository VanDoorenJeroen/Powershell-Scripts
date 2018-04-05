##################################################################
########                                                  ########
########                                                  ########
########               Create New AD User                 ########
########                                                  ########
########                                                  ########
##################################################################

<#Enable Exchange PS 
#********************
Set-ExecutionPolicy RemoteSigned
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://EUSMP041/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session
#******************** #>
Import-Module ActiveDirectory

<#VARIABLES#>

$LISTAFDELING = @("Communication","Customer Support","Design","Finance","General Management","General Services/Administration","Human Resources/Internal Communication","Information Technology","Installers","Legal","Logistics/Supply Chain","Maintenance","Marketing","Methods/Engineering","Production","Purchasing","Quality","Research & Innovation","Sales";"WCM")
$LISTLOCATION = @("BE04 - Dendermonde","NL02 - Waalwijk","NL03 - Goirle","NL04 - Oss")
$LISTDESCRIPTION = @("LOCAL", "REMOTE", "SERVICE", "VIP", "PROD_GEN","PROD_GEN+","PROD_RES","PROD_RES+")
$DATADENDERMONDE = @("Robert Ramlotstraat 89","Dendermonde", "9200", "BE","DESSO NV")
$DATAWAALWIJK = @("Taxandriaweg 15","Waalwijk","5142 PA","NL", "Desso BV")
$DATAGOIRLE = @()
$DIVISION = "EMEA"

<#FUNCTION
#This will list all lists in variables
#>

function GetOverview ($array)
{
    $i = 1
    ForEach ($element in $array)
    {
        "$i. "+$element
        $i++
    }
}


Write-Host "###-----New AD User-----###`n"
Write-Host "      Choose location`n"
GetOverview $LISTLOCATION 
$Location = Read-Host "`nEnter number of location"
$Location = $LISTLOCATION[$Location-1].Replace(" - ","_")
$FirstName = Read-Host "`nEnter first name"
$LastName = Read-Host "`nEnter last name"
$Account = Read-Host "`nEnter account name"
$Title = Read-Host "`nEnter title"
$Manager = Read-Host "`nEnter manager name (username)"
$UserNameToCopyFrom = Read-Host "`nEnter username to copy rights from"

Write-Host "`n     Choose Department`n"
GetOverview $LISTAFDELING
$Department = Read-Host "`nEnter number of department"
$Department = $LISTAFDELING[$Department - 1]

Write-Host "`n     Choose Description`n"
GetOverview $LISTDESCRIPTION
$Description = Read-Host "`nEnter number of description"
$Description = $LISTDESCRIPTION[$Description - 1] +' :'

Write-Host "`n`nDe gebruiker $FirstName $LastName ($Account) zal aangemaakt worden te $Location met als titel $Title op afdeling $Department."

$DisplayName = $LastName + ", "+$FirstName
$Office = $Location.Replace("_","-")
$Email = $FirstName + "." + $LastName.Replace(" ","") + "@tarkett.com"
$OU = 'OU=Users,OU='+$Location+',OU=_EMEA,DC=eu,DC=intra-global,DC=net'
$Paswoord = "Tarkett2018" | ConvertTo-SecureString -AsPlainText -Force

#Get Address
Switch ($Location)
{
    "BE04_Dendermonde" { $Street = $DATADENDERMONDE[0]
                         $City = $DATADENDERMONDE[1]
                         $PostalCode = $DATADENDERMONDE[2]
                         $Country = $DATADENDERMONDE[3]
                         $Company = $DATADENDERMONDE[4] }
    "NL02_Waalwijk" { $Street = $DATAWAALWIJK[0]
                      $City = $DATAWAALWIJK[1]
                      $PostalCode = $DATAWAALWIJK[2]
                      $Country = $DATAWAALWIJK[3]
                      $Company = $DATAWAALWIJK[4] }
}


$Confirm = Read-Host "FirstName: $FirstName`nLastName: $LastName`nNaam: $DisplayName`nDescription: $Description`nOffice: $Office`nEmail: $Email`nDivision: $DIVISION`nStreet: $Street`nCity: $City`nPostcode: $PostalCode`nCountry: $Country`nOU: $OU`nIs de informatie correct?(Y/N)"

if ($Confirm -eq "Y") {
    try
    {
        $props = @{
            Name = $Account
            SamAccountName = $Account
            Path = $OU
            DisplayName = $DisplayName
            GivenName = $FirstName
            Surname = $LastName
            UserPrincipalName = $Account+'@eu.intra-global.net'
            Title = $Title
            Description = $Description
            Enabled = $true
            AccountPassword = $Paswoord
            Department = $Department
            Office = $Office
            Country = $Country
            StreetAddress = $Street
            City = $City
            PostalCode = $PostalCode
            EmailAddress = $Email
            Company = $Company
            Manager = $Manager
            Division = $DIVISION
        }
        New-ADUser @props
        Write-Host "`n`nDe gebruiker $FirstName $LastName ($Account) werd aangemaakt te $Location met als titel $Title op afdeling $Department."
    }
    catch
    {
        $_
        Exit
    }
    if($CopyFromUser -ne "")
    {
        try 
        {
            $CopyFromUser = Get-ADUser $UserNameToCopyFrom -prop Memberof
            $CopyToUser = Get-ADUser $Account -prop Memberof
            $CopyFromUser.MemberOf | Where {$CopyToUser.MemberOf -notcontains $_ } | Add-ADGroupMember -Member $CopyToUser -ErrorAction SilentlyContinue
        }
        catch
        {
            $_
        }
    }
}

<#        $UserNameToCopyFrom = "hermansk"
        
        try 
        {
            $CopyFromUser = Get-ADUser $UserNameToCopyFrom -prop Memberof
            $CopyToUser = Get-ADUser $Account -prop Memberof
            $CopyFromUser.MemberOf | Where {$Account.MemberOf -notcontains $_ } | Add-ADGroupMember -Member $Account -ErrorAction SilentlyContinue
        }
        catch
        {
            $_
        }#>
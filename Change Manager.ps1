Import-Module ActiveDirectory

#Admin credentials to make the change in AD
$AdminUsername = Read-Host "Enter your Tarkett AD account"
$AdminPassword = Read-Host "Enter your password" -AsSecureString
$credentials = New-Object System.Management.Automation.PSCredential($AdminUsername,$AdminPassword)

#Get username of the to-be-replaced manager, find him in AD & get his DN
$CurrentManagerToFind = Read-Host "`nGet username of old manager"
$CurrentManager = Get-ADUser -Filter "Name -eq '$CurrentManagerToFind'"
$CurrentManagerFilter = $CurrentManager.DistinguishedName

#Get username of the new manager and find him in AD
$NewManagerToFind = Read-Host "`nGet username of new manager"
$NewManager = Get-ADUser -Filter "Name -eq '$NewManagerToFind'"

#Get all users with old manager
$users = Get-ADUser -Properties Manager -Filter "Manager -eq '$CurrentManagerFilter'"
$users | FT Name, givenName, Surname


Write-Host "For all these users, the manager"$CurrentManager.givenName, $CurrentManager.Surname "will be replaced by"$NewManager.givenName, $NewManager.Surname
$answer = Read-Host "-----------------`nIs this ok? (Y/N)"
if($answer = "Y")
{
    $number = 0
    foreach ($user in $users)
    {
        $user.Manager = $NewManager.DistinguishedName
#        Set-ADUser -Instance $user -Credential $credentials
        $number++
    }
    Write-Host "In total," $number "users had their manager property changed to"$NewManager.GivenName, $NewManager.SurName
}
else
{
    "Nothing was changed"
}


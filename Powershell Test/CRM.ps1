#Gets logged on user, and removes EU\
$LOCALUSER = Get-WMIObject -class Win32_ComputerSystem | Select-String "EU" -InputObject {$_.username}
$LOCALUSER = $LOCALUSER -replace [Regex]::Escape("EU\"),""

#Default path
$DEFAULTCRMPATH = "\\ddrnas01\public\software\Tarkett Software\CRM" #"\\walnas01\softw$\Tarkett Software\CRM"
$LOCALDESKTOPPATH = "C:\Users\"+$LOCALUSER+"\Desktop"

#Credentials PCUser
$PCUSER = ".\pcuser"
$PWPCUSER = ConvertTo-SecureString "Wig4m@" -AsPlainText -Force
$PCUSERCREDENTIALS = New-Object System.Management.Automation.PSCredential($PCUSER, $PWPCUSER)

#Credentials desso-account
$ADMIN = "desso\wa-jvdooren"
$PWADMIN =  ConvertTo-SecureString "tjNTx456" -AsPlainText -Force
$ADMINCREDENTIALS = New-Object System.Management.Automation.PSCredential($ADMIN, $PWADMIN)

#Languages
$NL = @("\NL Versie",
        "\NL Versie\1. Default CRM\Delivery", 
        "\NL Versie\2. Microsoft_CRM_Outlook_Client_13Sp1Ur1_x86_R1.0_NL_W8.1\Delivery", 
        "\NL Versie\3. Microsoft_CRM_Outlook_Client_13sp1Ur3_x86_R1_NL-NL_W8.1\Delivery", 
        "\NL Versie\4. Tarkett.WindowsStoreApp_3.3.0.14_x64_Test\Dependencies\x64",
        "\NL Versie\4. Tarkett.WindowsStoreApp_3.3.0.14_x64_Test")
$UK = "\UK Versie"
$DE = "\DE Versie"

#Name installing software
$PROGRAM = @("CRM", "Outlook Plugin", "Outlook Plugin 2", "Tarkett WindowstoreApp")

<#Copy files from NAS to Desktop. 
Uses desso credentials to logon on NAS#>
Function CopyFilesNASToDesktop($language)
{
    Write-Host "Starting copying files to Desktop"
    $source = $DEFAULTCRMPATH+$language
    New-PSDrive -Name "Software" -Root $DEFAULTCRMPATH -PSProvider FileSystem -Credential $ADMINCREDENTIALS
    Copy-Item $source -Destination $LOCALDESKTOPPATH -Recurse
    Remove-PSDrive -Name "Software"
    Write-Host "It's all on the desktop!"
    Sleep 5
}

<#Installs CRM software#>
Function InstallCRM($path, $Name)
{
    $InstallPath = $LOCALDESKTOPPATH + $path + "\install.cmd"
    Start-Process $InstallPath -Credential $PCUSERCREDENTIALS
    sleep 2
    Write-Host "--- Starting installation $Name---"
    while(Get-Process "cmd" -ErrorAction SilentlyContinue)
    {
        Write-Host "Installing $Name..."
        Sleep 5
    }
    Write-Host "--- Done installing $Name ---`n`n"
    Sleep 5
}

Function InstallPowerUP($path, $admin)
{
    $InstallPath = $LOCALDESKTOPPATH + $path
    $path = Resolve-Path $InstallPath
    cd $path
    if($admin) 
    { 
        $command = "Add-AppxPackage *.appx"
        start-process powershell.exe -Credential $PCUSERCREDENTIALS -argument "-nologo -noprofile -executionpolicy bypass -command $command"
    }
    else
    {
        Add-AppxPackage *.appx 
    }
    Sleep 5
}


$SITE = Read-Host "Choose language`n`t1. NL`n`t2. UK`n`t3. DE`nNumber"
Switch ($SITE) {
    1 { CopyFilesNASToDesktop $NL[0] 
        InstallCRM $NL[1] $PROGRAM[0] 
        InstallCRM $NL[2] $PROGRAM[1]
        InstallCRM $NL[3] $PROGRAM[2]
        InstallPowerUp $NL[4] $true
        InstallPowerUP $NL[5] $true
        InstallPowerUP $NL[5] $false
        }
    2 { $CRMPATH = $DEFAULTCRMPATH+"\UK Versie" }
    3 { $CRMPATH = $DEFAULTCRMPATH+"\DE Versie" }
    default { Write-Host "Wrong choice!" }
}
Read-Host "Everything is installed!`nYou can now start with the configuration <Enter>`n"
Start-Process Outlook.exe
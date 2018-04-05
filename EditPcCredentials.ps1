Function EditRegTarkett()
{
    [Byte[]] $key = (1..16)
    $passWordpcUser = Get-Content \\ddrnas01\Public\software\Test\test.txt | ConvertTo-SecureString -Key $key
    $PCUSER = '.\pcuser'
    $credentials = New-Object System.Management.Automation.PSCredential($PCUSER,$passWordpcUser)
    start-process regedit -Credential($credentials)
}

Function EditRegDesso ()
{
    Set-ExecutionPolicy RemoteSigned
    start-process regedit
}

Function CallScript()
{
    $LOCATION = $env:USERDOMAIN
    switch($LOCATION)
    {
        'EU' { EditRegTarkett }
        'Desso' { EditRegDesso }
    }
}
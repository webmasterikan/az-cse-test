Set-ExecutionPolicy Unrestricted

<#
--- Run the IKAN ALM setup script as user not system account. Necessary for WSL.
#>
# Get arguments from ARM template
$myUsername = $Args[0]
$Mypassword = $Args[1]
$MyResourceGroupName = $Args[2]

# Set a machine name var ($env is a redefined var)
$machineName = $env:COMPUTERNAME

# Creating the credential object
$credentialUsername = $env:COMPUTERNAME+'\'+$myUsername
$credentialPassword =  ConvertTo-SecureString $Mypassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($credentialUsername, $credentialPassword)

# Set the local path for the script on the machine ($PSScriptRoot is a predefined var e.g. "C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.12\Downloads\0")
$command = $PSScriptRoot + "\ikanalm-setup.ps1"

# Enable-PSRemoting is not necessary since we're targeting a Windows Server
# Passing arguments to the called script to enable credential object creation
Invoke-Command -FilePath $command -Credential $credential -ComputerName $machineName -ArgumentList $myUsername, $Mypassword, $MyResourceGroupName

Set-ExecutionPolicy Unrestricted

<#
--- Change services to run under the current user and start the services
#>
# Getting the arguments from the calling script and prepending the username
$myUsername = '.\'+$Args[0]
$myPassword = $Args[1]

# Stop, set and start the services
$ikanalmServices = @('Tomcat9','almsvr59','almagent59')

foreach ($i in $ikanalmServices) {
  $svc=gwmi win32_service -filter "name='$i'"
  $svc.StopService()
  $svc.change($null,$null,$null,$null,$null,$null,$myUsername,$myPassword,$null,$null,$null)
  $svc.StartService()
}


<#
--- Set ResourceGroup name
#>
$MyResourceGroupName = $Args[2]
Add-Content -Path "C:\temp\rgn.txt" -Value $MyResourceGroupName


<#
--- Install license
#>
Start-Process -FilePath "almlt.bat" -WorkingDirectory "C:\alm\system\config" -ArgumentList "install C:\temp\alm_license.lic" -WindowStyle "Hidden" -Wait


<#
--- Create shortcut
#>
$Shell = New-Object -ComObject ("WScript.Shell")

$ShortCut = $Shell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\IKAN ALM.lnk")

$ShortCut.TargetPath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$ShortCut.Arguments = "http://localhost:8080/alm/"
$ShortCut.WorkingDirectory = "C:\Program Files (x86)\Microsoft\Edge\Application\"
$ShortCut.WindowStyle = 1
$ShortCut.IconLocation = "C:\webservers\apache-tomcat-9.0.60\webapps\alm\images\run-ikanalm.ico, 0"

$ShortCut.Save()


$ShortCutVSCode = $Shell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio Code.lnk")

$ShortCutVSCode.TargetPath = "C:\ide\Microsoft VS Code\Code.exe"
$ShortCutVSCode.WorkingDirectory = "C:\ide\Microsoft VS Code"
$ShortCutVSCode.WindowStyle = 1
$ShortCutVSCode.IconLocation = "C:\ide\Microsoft VS Code\Code.exe, 0"

$ShortCutVSCode.Save()


<#
--- Copy shortcut to desktop
#>
$commandIa = @'
cmd.exe /C copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\IKAN ALM.lnk" %USERPROFILE%\Desktop
'@
Invoke-Expression -Command:$commandIa

$commandVS = @'
cmd.exe /C copy "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio Code.lnk" %USERPROFILE%\Desktop
'@
Invoke-Expression -Command:$commandVS


<#
--- Register and import the distro
#>
#wsl --set-default-version 1
#Add-AppxPackage "C:\ubuntu\Ubuntu_2004.2021.825.0_x64.appx"
#$distro = "Ubuntu"
#$location = "C:\wsl"
#wsl --import $distro $location "C:\temp\Ubuntu-fs.tar"


<#
--- Disable the first run experience in Edge
#>
reg import C:\temp\edge.reg

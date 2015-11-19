﻿#Set Variables
$TPathbase = "hklm:\software\policies\microsoft\windows\safer\codeidentifiers\"
$TPathroot = "hklm:\software\policies\microsoft\windows\safer\codeidentifiers\0\"
$TPathroot1 = "hklm:\software\policies\microsoft\windows\safer\codeidentifiers\0\paths\"
$CPVersion = "3"
$Root0 = Test-Path $TPathroot
$Root1 = Test-Path $TPathroot1
$Root2 = Test-Path $TPathbase
$exetypes = "ADE ADP BAS BAT CHM CMD COM CPL CRT EXE HLP HTA INF INS ISP LNK MDB MDE MSC MSI MSP MST OCX PCD PIF REG SCR SHS URL VB WSC"
#Begin Root Item Property Verification Config Switches
$Value =(Get-Itemproperty $TPathbase -Name "DefaultLevel"-ErrorAction SilentlyContinue) 
 if($Value -ne 262144){Set-ItemProperty -Path $TPathBase -Name DefaultLevel -Value 262144 -Type DWord}
$Value2 =(Get-ItemProperty $TPathbase -Name "authenticodeenabled"-ErrorAction SilentlyContinue) 
 if($Value2 -ne 0) {Set-ItemProperty -Path $TPathbase -Name authenticodeenabled -Value 0 -Type DWord}
$Value3 =(Get-ItemProperty $TPathbase -Name "ExecutableTypes"-ErrorAction SilentlyContinue) 
if ($Value3 -ne $exetypes){Set-ItemProperty $TPathbase -Name ExecutableTypes -Value $exetypes -Type Multistring}
$Value4 =(Get-ItemProperty $TPathbase -Name "PolicyScope"-ErrorAction SilentlyContinue) 
if ($Value4 -ne 0) {Set-ItemProperty $TPathbase -Name PolicyScope -Value 0 -Type DWord}
$Value5 =(Get-ItemProperty $TPathbase -Name "TransparentEnabled"-ErrorAction SilentlyContinue)
if ($Value5 -ne 1) {Set-ItemProperty $TPathbase -Name TransparentEnabled -Value 1 -Type DWord}
#Begin Folder Verification
If ($Root0 -ne $true)
{Set-Location HKLM:
New-Item -Path $TPathroot
}
If ($Root1 -ne $true)
{Set-Location HKLM:
New-Item -Path $TPathroot1
}
#Begin Verify of Lockdown
$TPathroot2 = "hklm:\software\policies\microsoft\windows\safer\codeidentifiers\262144\"
$TPathroot3 = "hklm:\software\policies\microsoft\windows\safer\codeidentifiers\262144\paths\"
$Root2 = Test-Path $TPathroot2
$Root3 = Test-Path $TPathroot3
If ($Root2 -ne $True) 
{Set-Location HKLM:
New-Item -Path $TPathroot2
}
If ($Root3 -ne $true)
{Set-Location HKLM:
New-Item -Path $TPathroot3
}#Begin Verify
$TPath = "hklm:\software\policies\microsoft\windows\safer\codeidentifiers\0\paths\{03d23f20-8648-4748-b527-259632??????}"
$CLV = Test-Path $TPath
If ($CLV -eq $True) 
{Clear-Host
Write-Output "CP Lockdown is in Place"
}
$Readversion = (Get-ItemProperty -Path $TPathbase -Name cpVersion).cpVersion
If ($cpVersion -eq $Readversion)
{Write-Output "Update not Needed"
Exit 0 } 
Else
{Write-Output "Lockdown is not in Place/or update needed"
######################  Begin Block
$LocalPath = ("%userprofile%\AppData\Local\","%userprofile%\AppData\Roaming\","%userprofile%\AppData\LocalLow\*\","%appdata%\*\","%userprofile%\AppData\","%userprofile%\AppData\LocalLow\","%userprofile%\AppData\Roaming\*\","%appdata%\","%programdata%\Microsoft\Windows\Start Menu\Programs\Startup\","%userprofile%\","%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\","%allusersprofile%\")
ForEach ($LP in $LocalPath)
{
$Exten = ("*.scr","*.com","*.pif","*.exe")
ForEach ($ext in $Exten)
{
$Location = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\safer\codeidentifiers\0\Paths\'
$Subkey =  "{03d23f20-8648-4748-b527-259632"
$Subsuf = get-random -Minimum (111111) -Maximum (999999)
$Fullsub = $Subkey + $Subsuf +"}"
$Fullpath = $Location + $Fullsub
$DExt = $LP + $ext
Push-Location
Set-Location HKLM:
New-Item -Path $Location -Name $FullSub
New-ItemProperty -Path $Fullpath -Name Description -PropertyType String -Value "Crypto Lockdown" -Force 
New-ItemProperty -Path $Fullpath -Name SaferFlags -PropertyType DWORD -Value 0 -Force 
New-ItemProperty -Path $Fullpath -Name ItemData -PropertyType ExpandString -Value $DExt -Force 
Pop-Location
}}
######################## Begin White List
######################
$LocalPath = ("%userprofile%\AppData\Local\","%userprofile%\AppData\Roaming\","%userprofile%\AppData\LocalLow\*\","%appdata%\*\","%userprofile%\AppData\","%userprofile%\AppData\LocalLow\","%userprofile%\AppData\Roaming\*\","%appdata%\","%programdata%\Microsoft\Windows\Start Menu\Programs\Startup\","%userprofile%\","%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\","%allusersprofile%\")
ForEach ($LP in $LocalPath)
{
$Apps = ("calc.exe","Spotify.exe","V-Safe100.exe","SpWebInst0.exe","SpotifySetup.exe")
ForEach ($App in $Apps)
{
$Location = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\safer\codeidentifiers\262144\Paths\'
$Subkey =  "{03d23f20-8648-4748-b527-259632"
$Subsuf = get-random -Minimum (111111) -Maximum (999999)
$Fullsub = $Subkey + $Subsuf +"}"
$Fullpath = $Location + $Fullsub
$DExt = $LP + $App
Push-Location
Set-Location HKLM:
New-Item -Path $Location -Name $FullSub
New-ItemProperty -Path $Fullpath -Name Description -PropertyType String -Value "Crypto Lockdown" -Force 
New-ItemProperty -Path $Fullpath -Name SaferFlags -PropertyType DWORD -Value 0 -Force 
New-ItemProperty -Path $Fullpath -Name ItemData -PropertyType ExpandString -Value $DExt -Force 
Pop-Location
}}
$Version =(Get-Itemproperty $TPathbase -Name "CPEVersion"-ErrorAction SilentlyContinue) 
 if($Value -ne $cpversion){Set-ItemProperty -Path $TPathBase -Name CPVersion -Value $CPVersion -Type DWord}
Clear-Host
Write-Output "LockDown Script Complete"
Exit 0
}
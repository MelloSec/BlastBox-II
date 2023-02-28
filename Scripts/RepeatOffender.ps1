
# GitHub
Invoke-WebRequest -Uri https://github.com/dnSpy/dnSpy/releases/latest/download/dnSpy-netframework.zip -OutFile "$env:TEMP\dnSpy-netframework.zip"
Expand-Archive -Path "$env:TEMP\dnSpy-netframework.zip" -DestinationPath C:\tools\dnSpy

# Need to refresh or reload here
git clone https://github.com/BloodHoundAD/SharpHound3.git C:\tools\SharpHound3
git clone https://github.com/dafthack/MailSniper.git C:\tools\MailSniper
git clone https://github.com/decoder-it/juicy-potato.git C:\tools\juicy-potato
git clone https://github.com/djhohnstein/SharpChrome.git C:\tools\SharpChrome
git clone https://github.com/FortyNorthSecurity/Egress-Assess.git C:\tools\Egress-Assess
git clone https://github.com/FSecureLABS/SharpGPOAbuse.git C:\tools\SharpGPOAbuse
git clone https://github.com/gentilkiwi/mimikatz.git C:\tools\mimikatz
git clone https://github.com/GhostPack/Seatbelt.git C:\tools\Seatbelt
git clone https://github.com/HarmJ0y/DAMP.git C:\tools\DAMP
git clone https://github.com/hfiref0x/UACME.git C:\tools\UACME
git clone https://github.com/leechristensen/SpoolSample.git C:\tools\SpoolSample
git clone https://github.com/NetSPI/PowerUpSQL.git C:\tools\PowerUpSQL
git clone https://github.com/p3nt4/PowerShdll.git C:\tools\PowerShdll
git clone https://github.com/PowerShellMafia/PowerSploit.git C:\tools\PowerSploit
git clone https://github.com/rasta-mouse/MiscTools.git C:\tools\MiscTools
git clone https://github.com/rasta-mouse/Sherlock.git C:\tools\Sherlock
git clone https://github.com/rasta-mouse/Watson.git C:\tools\Watson
git clone https://github.com/tevora-threat/SharpView.git C:\tools\SharpView
git clone https://github.com/TheWover/donut.git C:\tools\donut
git clone https://github.com/ZeroPointSecurity/PhishingTemplates.git C:\tools\PhishingTemplates

# IE first run
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer"
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main"
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" -Name DisableFirstRunCustomize -Value 1

# BloodHound
Invoke-WebRequest -Uri 'https://github.com/BloodHoundAD/BloodHound/releases/latest/download/BloodHound-win32-x64.zip' -OutFile "$env:TEMP\BloodHound.zip"
Expand-Archive -Path "$env:TEMP\BloodHound.zip" -DestinationPath C:\tools\
Rename-Item -Path C:\tools\BloodHound-win32-x64\ -NewName BloodHound
Invoke-WebRequest -Uri 'https://neo4j.com/artifact.php?name=neo4j-community-4.0.0-windows.zip' -OutFile "$env:TEMP\neo4j.zip"
Expand-Archive -Path "$env:TEMP\neo4j.zip" -DestinationPath C:\tools\
Rename-Item -Path C:\tools\neo4j-community-4.0.0\ -NewName Neo4j

## Visual Studio
Invoke-WebRequest -Uri 'https://visualstudioclient.gallerycdn.vsassets.io/extensions/visualstudioclient/microsoftvisualstudio2017installerprojects/1.0.0/1620063166533/InstallerProjects.vsix' -OutFile "$Downloads\InstallerProjects.vsix"
Invoke-WebRequest -Uri 'https://download.microsoft.com/download/E/E/D/EEDF18A8-4AED-4CE0-BEBE-70A83094FC5A/BuildTools_Full.exe' -OutFile "$Downloads\BuildTools.exe"
Enable-WindowsOptionalFeature -FeatureName NetFx3 -Online

# GPRegistryPolicy
Install-Module GPRegistryPolicy -Force

# Networking
# ## VMware
# netsh interface ip set address "Ethernet1" static 192.168.152.101 255.255.255.0 192.168.152.100

# ## VBox
# netsh interface ip set address "Ethernet 2" static 192.168.152.101 255.255.255.0 192.168.152.100

# route add -p 10.8.0.0 mask 255.255.255.0 192.168.152.100
# route add -p 10.9.0.0 mask 255.255.255.0 192.168.152.100
# route add -p 10.10.110.0 mask 255.255.255.0 192.168.152.100
# Add-Content C:\Windows\System32\drivers\etc\hosts "192.168.152.100 kali"

# UI
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force
Set-WindowsExplorerOptions -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableExpandToOpenFolder -EnableShowRibbon
Install-ChocolateyShortcut -shortcutFilePath "C:\Users\Public\Desktop\tools.lnk" -targetPath C:\tools\
Install-ChocolateyShortcut -shortcutFilePath "C:\Users\Public\Desktop\Neo4j.lnk" -targetPath "C:\tools\Neo4j\bin\neo4j.bat" -arguments "console" -runAsAdmin

New-Item -Path C:\ -Name BGInfo -ItemType Directory -ErrorAction SilentlyContinue
Invoke-WebRequest -Uri 'https://github.com/ZeroPointSecurity/RTOVMSetup/raw/master/wallpaper.jpg' -OutFile "C:\BGInfo\wallpaper.jpg"
Invoke-WebRequest -Uri 'https://github.com/ZeroPointSecurity/RTOVMSetup/raw/master/bginfo.bgi' -OutFile "C:\BGInfo\bginfo.bgi"
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\ -Name BGInfo -Value "C:\tools\sysinternals\Bginfo64.exe /accepteula /iC:\BGInfo\bginfo.bgi /timer:0"

# Misc
$DesktopPath = [Environment]::GetFolderPath("Desktop")
Remove-Item -Path "C:\Users\Public\Desktop\Boxstarter Shell.lnk"
Remove-Item -Path C:\Temp\ -Recurse -Force

# House keeping and Updates
Disable-BingSearch
Set-TaskbarOptions -Dock Bottom
Set-ExplorerOptions -showHiddenFilesFoldersDrives -showFileExtensions

# Install required modules
Install-Module -Name Az -Force
Install-Module -Name AzureAD -Force
Install-Module -Name MSOnline -Force
Install-Module -Name ExchangeOnlineManagement -Force
Install-Module -Name AADInternals -Force
Install-Module -Name Microsoft.Graph -Scope AllUsers -Force

# Import and connect to the modules
Import-Module Az
Import-Module AzureAD
Import-Module MSOnline
Import-Module ExchangeOnlineManagement
Import-Module AADInternals
Import-Module Microsoft.Graph


# Install Software
choco install tabby -y
choco install googlechrome -y
choco install firefox -y
choco install brave -y
choco install git -y
choco install poshgit -y
choco install vscode-powershell -y
choco install openvpn -y
choco install powertoys -y

# Install Visual Studio and Dev tooling
# choco install sysinternals --params "/InstallDir:C:\tools\sysinternals"
# choco install visualstudio2019community -y
choco install dotnet-sdk --version=5.0.100 -y
choco install dotnet-sdk -y
choco install mingw -y
choco install python3 -y
choco install pip -y
choco install golang  -y
choco install x64dbg.portable -y
choco install ollydbg -y
choco install ida-free -y
choco install wireshark -y
choco install reshack -y

# Install Malware related tooling
choco install -y autohotkey
choco install -y ngrok
choco install -y wireguard
choco install -y dotpeek
choco install -y ghidra
choco install -y cutter 
choco install -y pestudio
choco install -y pebear
choco install -y pesieve
choco install -y hollowshunter
choco install -y dependencywalker  
choco install -y ilspy
choco install -y dnspy
choco install -y procmon
choco install -y procdot
choco install -y processhacker
choco install -y fiddler
choco install -y regshot
choco install -y dnscrypt-proxy

# Set a nice wallpaper : 
write-host "Setting a nice wallpaper"
$web_dl = new-object System.Net.WebClient
$wallpaper_url = "http://tessier-ashpool.s3.amazonaws.com/computerdesktop.jpg"
$wallpaper_file = "C:\Users\Public\Pictures\desktop.jpg"
$web_dl.DownloadFile($wallpaper_url, $wallpaper_file)
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Users\Public\Pictures\desktop.jpg" /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperStyle /t REG_DWORD /d "0" /f 
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v StretchWallpaper /t REG_DWORD /d "2" /f 
reg add "HKEY_CURRENT_USER\Control Panel\Colors" /v Background /t REG_SZ /d "0 0 0" /f

# Install Sysmon with Swift on Security
Set-ExecutionPolicy -Bypass
mkdir "C:\sysmon";
Invoke-WebRequest -Uri "https://github.com/mellonaut/sysmon/raw/main/sysmon.zip" -OutFile "C:\sysmon\sysmon.zip";
Expand-Archive "c:\sysmon\sysmon.zip" -DestinationPath "C:\sysmon";
cd "c:\sysmon";
c:\sysmon\sysmon.exe -acceptEula -i c:\sysmon\sysmon-swift.xml



Enable-PSRemoting -Force
Update-Help
Enable-WindowsUpdate
Enable-RemoteDesktop
Install-WindowsUpdate

# Domain Controller
$Domain = 'earth.sunn'
$DSRMPassword = 'Password123!'
# $NetworkID = '10.0.0.69'
# $NewIPv4DNSServer = "8.8.8.8"
# $InterfaceIndex = (Get-NetAdapter).ifIndex
# $CurrentIPv4Address = (Get-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4").IPAddress
# Remove-NetIpAddress -InterfaceIndex $InterfaceIndex -IPAddress $CurrentIPv4Address
# Set-NetIpAddress -InterfaceIndex $InterfaceIndex -AddressFamily "IPv4" -IPAddress "$CurrentIPv4Address" -PrefixLength 24 | Out-Null
# Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ("127.0.0.1", "$NewIPv4DNSServer")

Write-Verbose "Installing AD DS feature..."

Install-WindowsFeature -Name "AD-Domain-Services" -IncludeManagementTools
Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools


Write-Verbose "Installing new forest: $Domain"
    
$Password = ConvertTo-SecureString -AsPlainText -String $DSRMPassword -Force
$NetbiosName = $Domain.split(".")[0].ToUpper()

Install-ADDSForest -DomainName "$Domain" -DomainNetbiosName "$NetbiosName" -SafeModeAdministratorPassword $Password -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -LogPath "C:\Windows\NTDS" -DomainMode "WinThreshold" -ForestMode "WinThreshold" -NoRebootOnCompletion:$false -InstallDNS:$false -Force:$true

# Install boxstarter with chocolatey and basic configuration
. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter –Force
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Set-TimeZone -Name "Eastern Standard Time" -Verbose

Refreshenv

choco install -y tabby
choco install -y git
choco install -y poshgit
choco install -y vscode
choco install sysinternals -y

Set-ExecutionPolicy -Bypass
mkdir "C:\sysmon";
Invoke-WebRequest -Uri "https://github.com/mellonaut/sysmon/raw/main/sysmon.zip" -OutFile "C:\sysmon\sysmon.zip";
Expand-Archive "c:\sysmon\sysmon.zip" -DestinationPath "C:\sysmon";
cd "c:\sysmon";
c:\sysmon\sysmon.exe -acceptEula -i c:\sysmon\sysmon-swift.xml


Install-ADDSForest -DomainName mellosec.sunn -InstallDNs

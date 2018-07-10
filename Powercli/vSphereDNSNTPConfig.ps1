﻿# PowerCLI Script to Configure DNS and NTP on ESXi Hosts
# PowerCLI Session must be connected to vCenter Server using Connect-VIServer

# Define variables
$vCServer = "10.2.225.20"
$VCUser = "root"
$VCUserPass = 'Tr!t3cH1'
#Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer -Server $VCServer  -User $VCUser -Password $VCUserPass

# Prompt for Primary and Alternate DNS Servers
$dnspri = '10.2.226.254'
$dnsalt = ''

# Prompt for Domain
$domainname = 'ebr911.net'

#Prompt for NTP Servers
$ntpone = '10.201.1.62'
$ntptwo = ''

$esxHosts = get-VMHost

foreach ($esx in $esxHosts) {

   Write-Host "Configuring DNS and Domain Name on $esx" -ForegroundColor Green
   Get-VMHostNetwork -VMHost $esx | Set-VMHostNetwork -DomainName $domainname -DNSAddress $dnspri , $dnsalt -Confirm:$false

   
   Write-Host "Configuring NTP Servers on $esx" -ForegroundColor Green
   Add-VMHostNTPServer -NtpServer $ntpone , $ntptwo -VMHost $esx -Confirm:$false

 
   Write-Host "Configuring NTP Client Policy on $esx" -ForegroundColor Green
   Get-VMHostService -VMHost $esx | where{$_.Key -eq "ntpd"} | Set-VMHostService -policy "on" -Confirm:$false

   Write-Host "Restarting NTP Client on $esx" -ForegroundColor Green
   Get-VMHostService -VMHost $esx | where{$_.Key -eq "ntpd"} | Restart-VMHostService -Confirm:$false

}
Write-Host "Done!" -ForegroundColor Green

disconnect-viserver * -force
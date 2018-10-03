#PowerShell filter to add date/timestamps
filter timestamp {"$(Get-Date -Format G): $_"}

# Shutdown all running VMs and hosts in the Compute Cluster
Connect-VIServer -Server labvcsa.etherbacon.net -User administrator@vsphere.local -Password "G0lden*ak"
"Shutting down all VMs in Compute Cluster ..." |timestamp
$vmlista = Get-VM -Location Compute | where{$_.PowerState -eq 'PoweredOn'}
foreach ($vm in $vmlista)
    {
    Shutdown-VMGuest -VM $vm -Confirm:$false | Format-List -Property VM, State
    }
"Waiting for all VMs in Compute Cluster to shut down ..." |timestamp
do {
    "The following VM(s) are still powered on:"|timestamp
    $pendingvmsa = (Get-VM -Location Compute | where {$_.PowerState -eq 'PoweredOn'})
    $pendingvmsa | Format-List -Property Name, PowerState
    sleep 1
} until($pendingvmsa -eq $null)
"All VMs in Compute Cluster are powered off ..."|timestamp

# Shutdown all hosts in the Compute Cluster
$vmhosta = Get-VMHost -Location Compute | where {$_.PowerState -eq 'PoweredOn'}
foreach ($host in $vmhosta)
    {
    Stop-VMHost -Confirm:$false -Force | Format-List -Property VM, State
    }
"Waiting for all Hosts in Compute Cluster to shut down ..." |timestamp
do {
    "The following Hosts(s) are still powered on:"|timestamp
    $pendinghosta = (Get-VMHost -Location Compute | where {$_.PowerState -eq 'PoweredOn'})
    $pendinghosta | Format-List -Property Name, PowerState
    sleep 1
} until($pendinghosta -eq $null)
"All Hosts in Compute Cluster are powered off ..."|timestamp

"Disconnecting from VC ..."|timestamp
Disconnect-VIServer -Server * -Force -Confirm:$false

# Connecting to LABESXIM01 to shutdown any VMs running there
"Connecting to LABESXM01 ..."|timestamp
Connect-VIServer -Server 10.10.200.10 -User root -Password "G0lden*ak"
"Shutting down all guests on LABESXM01 ..."|timestamp
$vmlist0 = Get-VM | where {$_.PowerState -eq 'PoweredOn'}
foreach ($vm0 in $vmlist0) {
    Shutdown-VMGuest -VM $vm0 -Confirm:$false | Format-List -Property VM, State
}
"Waiting for all guests to shut down ..."|timestamp
do {
    "The following VM(s) are still powered on:"|timestamp
    $pendingvms0 = (Get-VM | where {$_.PowerState -eq 'PoweredOn'})
    $pendingvms0 | Format-List -Property Name, PowerState
    sleep 10
} until($pendingvms0 -eq $null)
"VMs are all powered off..."|timestamp

"Disconnecting from LABESXM01 ..."|timestamp
Disconnect-VIServer -Server * -Force -Confirm:$false

# Connecting to LABESXIM02 to shutdown any VMs running there
"Connecting to LABESXM01 ..."|timestamp
Connect-VIServer -Server 10.10.200.15 -User root -Password "G0lden*ak"
"Shutting down all guests on LABESXM01 ..."|timestamp
$vmlist0 = Get-VM | where {$_.PowerState -eq 'PoweredOn'}
foreach ($vm0 in $vmlist0) {
    Shutdown-VMGuest -VM $vm0 -Confirm:$false | Format-List -Property VM, State
}
"Waiting for all guests to shut down ..."|timestamp
do {
    "The following VM(s) are still powered on:"|timestamp
    $pendingvms0 = (Get-VM | where {$_.PowerState -eq 'PoweredOn'})
    $pendingvms0 | Format-List -Property Name, PowerState
    sleep 10
} until($pendingvms0 -eq $null)
"VMs are all powered off..."|timestamp

"Disconnecting from LABESXM01 ..."|timestamp
Disconnect-VIServer -Server * -Force -Confirm:$false

ipmitool -I lanplus -H 10.10.205.5 -U admin -P "admin" power soft
ipmitool -I lanplus -H 10.10.205.10 -U admin -P "admin" power  soft
ipmitool -I lanplus -H 10.10.205.15 -U admin -P "admin" power  soft
ipmitool -I lanplus -H 10.10.205.20 -U admin -P "admin" power  soft
ipmitool -I lanplus -H 10.10.205.25 -U admin -P "admin" power  soft
ipmitool -I lanplus -H 10.10.205.30 -U admin -P "admin" power  soft
ipmitool -I lanplus -H 10.10.205.100 -U admin -P "admin" power soft
ipmitool -I lanplus -H 10.10.205.105 -U admin -P "admin" power soft
ipmitool -I lanplus -H 10.10.205.110 -U admin -P "admin" power soft
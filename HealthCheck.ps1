# Philip Casey, 2023
# This script enables Health Check on Distributed Switches
# Reference: VMware Code Capture
# Integrated by Philip Casey

# Type name of distributed switches in quotes. Add or remove the number of distributed switches you need to enable.
$vDS1 = ""
$vDS2 = ""
$vDS3 = ""

# Connect to vCenter. Type name of vcenter address in quotes.
$vCenter = ""
Connect-VIServer -Server $vCenter

# Set HealthCheck Configuration to Enabled
$healthcheck = New-Object VMware.Vim.DVSHealthCheckConfig[] (2)
$healthcheck[0] = New-Object VMware.Vim.VMwareDVSVlanMtuHealthCheckConfig
$healthcheck[0].Enable = $true
$healthcheck[0].Interval = 1
$healthcheck[1] = New-Object VMware.Vim.VMwareDVSTeamingHealthCheckConfig
$healthcheck[1].Enable = $true
$healthcheck[1].Interval = 1

# Save confiuration. Add or remove the number of distributed switches you need.
$_this = Get-View -VIObject $vDS1
$_this.UpdateDVSHealthCheckConfig_Task($healthcheck)
$_this = Get-View -VIObject $vDS2
$_this.UpdateDVSHealthCheckConfig_Task($healthcheck)
$_this = Get-View -VIObject $vDS3
$_this.UpdateDVSHealthCheckConfig_Task($healthcheck)

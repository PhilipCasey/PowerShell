# Export OVF Template
# This script exports a VM as an OVF Template to the local machine
# VMware vSphere 8
# PowerCLI 13.1
# Created by Philip Casey, 2023
# https://GitHub.com/PhilipCasey

# Connect to vCenter. Type name of vcenter address in quotes.
$vCenter = ""
Connect-VIServer -Server $vCenter

# Type names of items in quotes.
$VMname = "" #Name of VM as seen in vCenter
$OVFName = "" #Name of new OVF Template
$OVFPath = "" #Path to save OVF files C:\FolderName

# Get items from vCenter
$VM = Get-VM -Name $VMname
$CDDrive = Get-CDDrive -VM $VM

# Remove media from virtual drive on VM so it's not included in the OVF file.
Set-CDDrive -CD $CDDrive -NoMedia -Confirm:$false

# Export OVF Template
# NOTE: VM must be powered-off first
Get-VM -Name $VM | Export-VApp -Destination $OVFPath -Format OVF -Name $OVFName -Force

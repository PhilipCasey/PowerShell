# How to use Powershell to configure BIOS Settings via iDRAC
# Created by Philip Casey

# To run these commands, you will need the Dell iDRAC Tools installed
# The following commands are built on 9.1.0-2771_A00
# You can find the installer at https://www.dell.com/support/home/en-ca/drivers/driversdetails?driverid=n3gc9  >  OM-DRAC-Dell-Web-WINX64-9.1.0-2771_A00.exe

# Important, you may need to create an alias for the RACADM exe path for Powershell to know where it is.
Set-Alias racadm 'C:\Program Files\Dell\SysMgt\rac5\racadm.exe'

# RACADM is the command you will use to send commands to iDRAC
# RACADM -r tells it to start a remote session to the ip address specified after it. Example: RACADM -R 192.168.1.1
#        after the IP address you will specify a useranme with -u and password with -p
#        I recommend putting them into a variable first because every send command requires all three.

#iDRAC Variables (Modify these for your network)
$iDRAC_ip = "192.168.1.1"
# If you have more than one server to change, you can create an array of the IPs and use a For Loop to iterate through each.
$iDRAC_array = @(
"192.168.1.1",
"192.168.1.2",
"192.168.1.3"
)
$iDRAC_user = "Username"
$iDRAC_pass = "Password"
####################################################################################
# Here is the RACADM session information (no commands are being passed to iDRAC yet)
RACADM -r $iDRAC_ip -u $iDRAC_user -p $iDRAC_pass

# An easy way to see all the iDRAC settings you can access, do a Get command
RACADM -r $iDRAC_ip -u $iDRAC_user -p $iDRAC_pass Get

# To select an item of the GET list, simply add it after Get
RACADM -r $iDRAC_ip -u $iDRAC_user -p $iDRAC_pass Get BIOS

# To select a sub item of the previous item, use the dot notation to change levels
RACADM -r $iDRAC_ip -u $iDRAC_user -p $iDRAC_pass Get BIOS.SysInformation
####################################################################################
# If you want to set a setting, first find the setting path using the above method. 
# Again use the dot notation to select the setting. Running the below command will output the setting.
RACADM -r $iDRAC_ip -u $iDRAC_user -p $iDRAC_pass Get iDRAC.NTPConfigGroup.NTP1

# To make a change to that setting, use the SET command, followed by the path to the setting with the desired setting after it.
RACADM -r $iDRAC_ip -u $iDRAC_user -p $iDRAC_pass SET iDRAC.NTPConfigGroup.NTP1 192.168.1.55
# Or from a variable
RACADM -r $iDRAC_ip -u $iDRAC_user -p $iDRAC_pass SET iDRAC.NTPConfigGroup.NTP1 $NTP

If the setting you're changing is a dropdown menu item in the web console, put the setting in quotes
RACADM -r $iDRAC_ip -u $iDRAC_user -p $iDRAC_pass SET iDRAC.WebServer.TLSProtocol "TLS 1.2 or Higher"
####################################################################################
# Some settings won't apply until a change job is created, ran, and server is rebooted.
# Create new job and perform -r Graceful reboot
RACADM -r $iDRAC_ip -u $iDRAC_user -p $iDRAC_pass jobqueue create BIOS.Setup.1-1 -r Graceful

# For more information on creating a job queue
RACADM -r $iDRAC_ip -u $iDRAC_user -p $iDRAC_pass jobqueue help create
####################################################################################
If you want to run the command on all of your servers in the array. Use a foreach loop
foreach($server in $iDRAC_array){
  RACADM -r $server -u $iDRAC_user -p $iDRAC_pass SET iDRAC.NTPConfigGroup.NTP1 $NTP
}
####################################################################################
# I hope this helps you! Good luck

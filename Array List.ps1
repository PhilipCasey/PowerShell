# How to create a multi column array list in PowerShell
# Created by Philip Casey

# Array List Format
$ArrayListVarName = New-Object -type System.Collections.ArrayList
$ArrayListVarName.Add([PSCustomObject]@{column1name="value1";column2name="value2";column3name="value3"})
$ArrayListVarName.Add([PSCustomObject]@{column1name="value11";column2name="value22";column3name="value33"})
$ArrayListVarName.Add([PSCustomObject]@{column1name="value111";column2name="value222";column3name="value333"})

# Running the variable outputs the contents to the console
$ArrayListVarName

#############################################################################################
#Example 

$Networks = New-Object -type System.Collections.ArrayList
$Networks.Add([PSCustomObject]@{vSwitch="vswitch0";"PortGroup"="ESXi Management";vLan="5"})
$Networks.Add([PSCustomObject]@{vSwitch="vswitch1";"PortGroup"="VM Network";vLan="10"})
$Networks.Add([PSCustomObject]@{vSwitch="vswitch1";"PortGroup"="vSAN";vLan="3"})
$Networks.Add([PSCustomObject]@{vSwitch="vswitch2";"PortGroup"="Fault Tolerance";vLan="2"})

$Networks

#############################################################################################
#Filtering 

# Reference one row of items
# 0 is the first entry in the array, counting up
$Networks[0]
$Networks[3]

# Reference one column of one item
$Networks.PortGroup

# Output a list of items in one column
$Networks.vlan

# Output a list of items in one column without showing duplicates
$Networks.vswitch | Select -Unique

# Filter by name
$Networks | Where-Object PortGroup -match "ESXi"
$Networks | Where-Object vSwitch -match "1"
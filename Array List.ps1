# Three or more column Dictionary / Array List in PowerShell

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
$Networks.Add([PSCustomObject]@{vSwitch="vswitch0";"Port Group"="ESXi Management";vLan="5"})
$Networks.Add([PSCustomObject]@{vSwitch="vswitch1";"Port Group"="VM Network";vLan="10"})
$Networks.Add([PSCustomObject]@{vSwitch="vswitch1";"Port Group"="vSAN";vLan="3"})
$Networks.Add([PSCustomObject]@{vSwitch="vswitch2";"Port Group"="Fault Tolerance";vLan="2"})

$Networks

# Reference one row of items
$Networks[1]

# Reference one column of one item
$Networks[3].'Port Group'

# Output a list of items in one column
$Networks.vlan

# Output a list of items in one column without showing duplicates
$Networks.vswitch | Select -Unique
# Created by Philip Casey, 2024
# Example of how to import a CSV file of Variables into PowerShell

# This example CSV file contains three columns: "Description","Variable","Value"
# For Example: 
# Description    | Variable    | Value
# ------------------------------------------------
# Name of Server | $ServerName | Server01
# Server IP      | $Server_IP  | 192.168.1.1

# Path to CSV file
$csvFile = 'C:\test.csv'

# This section imports the CSV file and the ForEach-Object processes through each item in the CSV file
Import-CSV $csvFile | ForEach-Object {
	# The $_ tells it to pull the current item being processed, then using Dot Syntax accesses the .Variable, which is the "Variable" column and assigns it to a temporary variable called $item.
	$item = $_.Variable 

	# This If statement tests if $item is empty box in the CSV file and skips it.
	if(Test-Path variable:$item){
		#skip
	} else {
		# This creates a new variable using dot syntax to access the columns: Description,Variable,Value from the CSV. 
		# The substring(1) removes the $ sign from the variable name in the CSV.
		New-Variable -name $_.Variable.substring(1) -value $_.Value -Description $_.Description
	}
}

# Here is the same code without my comments:
Import-CSV $csvFile | ForEach-Object {
	$item = $_.Variable 
	if(Test-Path variable:$item){
	} else {
		New-Variable -name $_.Variable.substring(1) -value $_.Value -Description $_.Description
	}
}

# I hope this helps! 

# Created by Philip Casey

# To start a background job (process) in Powershell, put your commands inside a Script Block Variable. Then use the Start-Job command to run the script block.
# Start-Job starts a new powershell session in the background that doesn't have access to variables, functions, or active connections from your current session. 
# You can use the ArgumentList in conjunction with param to import variables. 

# Example of variables
$jobName = "MyJob"
$ip = "192.168.1.1"
$anotherVariable = "Testing connection to $ip"
$thisVariableWontWork = "Notice how this variable isn't accessible in the script block"


# This is where you put your commands to be run in the background process.
$scriptBlock = {
    param(
        # Use param() to import variables from session you're running this job from. If you don't, this new job will not have access to the variables that are loaded. 
        # Add variables here that are being passed in via Argument list. The argumentlist variables MUST be in the same order as they appear in the start-job argumentlist section.
        $ip,
        $anotherVariable
    )

    # Add your commands here
    Write-Host $anotherVariable
    Test-Connection -Destination $ip
    Write-Host "If you see the variable it will be here: $thisVariableWontWork"

# End of ScriptBlock
}

# To start the job, set the script block and the argumentlist variables to import into the background process. 
# The argumentlist variables MUST be in the same order as they appear in the param section of the script block
Start-Job -name $jobName -ScriptBlock $scriptBlock -ArgumentList $ip,$anotherVariable



# Examples of interacting with the job

# To see the status of all jobs
Get-Job

# Wait for the job with the name MyJob to complete before Powershell will proceed to the next line of code
Wait-Job  -Name $jobName

# To see the output from you job
Receive-Job -Name $jobName

# Wait for all jobs to complete before Powershell will proceed to the next line of code
Wait-Job -Name *

# Stop all jobs from running
Stop-Job -name $jobName

# Remove all jobs
Remove-Job -Name *

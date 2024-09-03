# Writen By Philip Casey
# Simple formula for determining the factorial of a number

function Get-Factorial(){
param(
[Parameter(Mandatory)]
    [int]$Number
)

    # Start by setting the factorial to 1 instead of the default 0
    $Factorial = 1

# Count down from your number
    for($i = $Number; $i -gt 0; $i--){

        # Multiply the factorial my the number in the current counter
        $Factorial *= $i
    }
    Write-host "Factorial of $Number is $factorial"
}

# Test case of 4 should be 24
Get-Factorial -Number 4

# Test case of 6 should be 720
Get-Factorial -Number 6

# You can also write it with number inside ()
# Test case of 5 should be 120
Get-Factorial(5)

# Test case of 1 should be 1
Get-Factorial(1)

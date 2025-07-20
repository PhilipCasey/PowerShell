# Simple Powershell RAW Metar Converter Project
# Created by Philip Casey
######################################################################################

# Input the full airport identifier
$airportID = "KCHS"

######################################################################################

# GET Metar from Aviation Weather Center API
$metarAPI = curl.exe -X 'GET' "https://aviationweather.gov/api/data/metar?ids=$airportID&format=json" -H 'accept: */*' 2>$null | ConvertFrom-Json

# Split the string into an array so each item can be assigned based on its format
$metarArray = ($metarAPI.rawOb).Split(" ")

######################################################################################
# Functions 

# To convert Zulu time to EST time
function Convert-ToLocal(){
    $zulu = $metarapi.rawOb.Split(" ") | Where-Object {($_ -like "*Z")}
    $zulu = ([int]$zulu.Substring(2,4))

    $DSTCheck = Get-Date
    $DSTCheck = $DSTCheck.IsDaylightSavingTime()
    $timezoneOffset = if($DSTCheck){ ((Get-TimeZone).BaseUtcOffset)+([timespan]::ParseExact('0100', 'hhmm', $null)) } else { (Get-TimeZone).BaseUtcOffset }
    $timezone = if($DSTCheck){((Get-TimeZone).DaylightName) } else {((Get-TimeZone).StandardName)}
    
    $timezoneAbbr = @{
        "Eastern Daylight Time" = "EDT"
        "Eastern Standard Time" = "EST"
        "Central Daylight Time" = "CDT"
        "Central Standard Time" = "CST"
        "Mountain Daylight Time" = "MDT"
        "Mountain Standard Time" = "MST"
        "Pacific Daylight Time" = "PDT"
        "Pacific Standard Time" = "PST"
    }

    $zulu = [timespan]::ParseExact("$zulu", 'hhmm', $null)
    $localTime = $zulu + $timezoneOffset

    $12hrclock = [timespan]::ParseExact('1200', 'hhmm', $null)
    if($localTime.hours -lt 13){
        $12hr = ($localTime).ToString("h':'mm")
        } else {
        $12hr = ($localTime - $12hrclock).ToString("h':'mm")
        }

    if($localTime.Hours -lt 12){
        Return "$12hr AM $($timezoneAbbr[$timezone])"
    } else {
        Return "$12hr PM $($timezoneAbbr[$timezone])"
    }
}

##############################################

function Convert-Temperature($temperature){
        $F = convertToFahrenheit($temperature)
        $temperature = "$([int]$temperature)°C ($F°F)"
        return $temperature
}

##############################################

# Convert Celsius to Fahrenheit
function convertToFahrenheit($C){
    $F = ([MATH]::Round([double]$C*9/5+32))
    return $F
}


##############################################

# Convert Wind Information

function Convert-Winds(){
    $windOutput = $null
    if ($metarAPI.wspd -eq 0) {
        $windOutput = "Winds calm"
    }
    elseif ($metarAPI.wspd -ge 1) {
        $windSpeed = $metarAPI.wspd
    }
    elseif ($metarAPI.wgst -gt 0) {
        $windSpeed = "$($metarAPI.wspd) - $($metarAPI.wgst)"
    }

    $windOutput = "$($metarAPI.wdir)° at $($windSpeed) kts"
    return $windOutput

}

##############################################

# Cloud Conversion
function Convert-Clouds(){
    # Create new variable for arraylist
    $cloudOutput = @()

    foreach($cloud in $metarAPI.clouds){
        switch($cloud){
                { ($_.cover -eq "CLR") } { $cloudOutput  = "Clear below 12,000" }
                { ($_.cover -eq "FEW") } { $cloudOutput += "Few" + " " + ("{0:N0}" -f $($_.base)) + "'"     }
                { ($_.cover -eq "SCT") } { $cloudOutput += "Scattered" + " " + ("{0:N0}" -f $($_.base)) + "'"     }
                { ($_.cover -eq "BKN") } { $cloudOutput += "Broken" + " " + ("{0:N0}" -f $($_.base)) + "'"      }
                { ($_.cover -eq "OVC") } { $cloudOutput += "Overcast" + " " + ("{0:N0}" -f $($_.base)) + "'"      }
        }
    }

    return $cloudOutput

}

######################################################################################

function Convert-altimeter(){
    # Parcel Altimeter from raw data
    $altimeter = (($metarAPI.rawOb).Split(" ") | Where-Object {($_.Length -eq 5) -and ($_ -like "*A*")}).Substring(1,4)/100
    $altimeter = "{0:F2}" -f $altimeter

    return $altimeter

}

######################################################################################

#old
foreach($item in $metarArray){
    switch ($item){

        # Wind and Vis
        {($_ -like "00000*")}  {write-host "Winds calm"}
        {($_ -like "VRB*") -and ($_ -notlike "00000*") -and ($_ -notlike "*G*")}  {
            write-host "Variable at" ([MATH]::Round(([int]$_.Substring(3,2))*1.15))"MPH"
        }

    }
}

############################################################################################

function Get-RelativeHumidity(){
param(
    [double]$temp, 
    [double]$dewp
)

$expDewp = [math]::Exp((17.625 * $dewp) / (243.04 + $dewp))
$expTemp = [math]::Exp((17.625 * $temp) / (243.04 + $temp))

$RH = 100 * ($expDewp / $expTemp)
$RH = [math]::Round($RH)

return $RH

}

############################################################################################

function Get-DensityAltitude(){
param(
    [double]$altimeter
)

# Density Altitude = Pressure Altitude + [120 × (OAT − ISA Temp)]

$PA = [math]::Round((29.92 - $converterAltimeter) * 1000 + $metarAPI.elev)
$ISA = 15 - (2 * ([Math]::Round($PA / 1000)))

$DA = $PA + (120 * ($metarAPI.temp - $ISA))
$DA = "{0:N0}" -f $DA
return $DA

}

############################################################################################

#Assembled 

function Convert-Metar($metar){

    # Create new variable for ordered hashtable
    $metarOutput = [ordered]@{}

    # RAW Metar
    $metarOutput.Add("METAR",$($metarAPI.rawOb))

    # Time
    $convertedTime = Convert-ToLocal
    $metarOutput.Add("Time",$convertedTime)

    # Wind
    $convertedWinds = Convert-Winds
    $metarOutput.Add("Wind",$convertedWinds)

    # Visibility
    $metarOutput.Add("Visibility","$($metarAPI.visib) sm")

    # Clouds
    $convertedClouds = Convert-Clouds
    $metarOutput.Add("Clouds (AGL)",$convertedClouds)

    # Temperature
    $convertedTemp = Convert-Temperature($metarAPI.temp)

    $metarOutput.Add("Temperature",$convertedTemp)

    # Dewpoint
    $convertedDew = Convert-Temperature($metarAPI.dewp)
    $metarOutput.Add("Dewpoint",$convertedDew)

    # Altimeter
    $converterAltimeter = Convert-Altimeter
    $metarOutput.Add("Altimeter","$converterAltimeter inHg")

    # Humidity
    $humidity = Get-RelativeHumidity -temp $metarAPI.temp -dewp $metarAPI.dewp
    $metarOutput.Add("Humidity","$humidity%")

    # Density Altitude
    $DA = Get-DensityAltitude -altimeter $converterAltimeter
    $metarOutput.Add("Density Altitude (incorrect, due to wrong field elevation in API","$DA'")

    return $metarOutput

#end of function
}

Convert-Metar -metar $metarAPI 
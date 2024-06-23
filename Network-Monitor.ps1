<#
[SCRIPT] 
    Network Monitor
[VERSION]
    v1.6.22.24
[AUTHOR]
    Deadx_xSmile
[DESCRIPTION]
    This script constantly pings a set IP address at a user defined interval
    to check for network connectivity. If the script detects a drop in the 
    network, it logs the date/time of the start of the outage, and then saves
    the end and total time of the outage once network connectivity has been
    restored. The script outputs a log file inside a folder created using the 
    Year and Month of when the script is ran. The log file has the full Date
    of when the script started running as part of its filename. 
[OUTPUT FILES]
    YYYY-MM\Outage-Log_YYYY-MM-DD.csv
[READ ME]
    \README.md
        Make sure to open the 'README.md' file found in the same directory as 
        the script. This file goes over the settings below that you MUST FIRST
        SETUP OR THE SCRIPT WILL NOT RUN PROPERLY!
#>

# Set the Main Variables For How the Script Runs; Please Remember to Change the "0" in $TestIP to a Valid IP Address
$TestIP = "0"
$ScriptEndpoint = (Get-Date).AddMinutes(720)
$ScriptInterval = 5

# Make Sure a Valid IP Address Has Been Set Above
if ($TestIP -notmatch '^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$') {
    Write-Host -ForegroundColor DarkRed "VALID IP ADDRESS NOT SET! SCRIPT WILL NOW CLOSE; PLEASE CHECK THE 'README.md' FILE BEFORE RUNNING!"
    Exit
}

# Initialize Other Varaibles and Set Default Values
$TimeCheck = Get-Date 
$NetworkStatus = $true
$OutageCount = 0 

# Define Log File Path and File
$FolderLocation = "$PSScriptRoot\" + (Get-Date).ToString("yyyy-MM") <# Uses The Scripts Location & Current Date for Log File Location #>
$LogFile = $FolderLocation + "\Outage-Log_" + (Get-Date).ToString("yyyy-MM-dd") + ".csv" <# Log File Locationm; Change 'Outage-Log_' to a Custom Name if Desired #>

if (-not (Test-Path $LogFile)) {
    [void](New-Item -Path $LogFile -ItemType File -Force)
    "Start-Time,Start-Date,End-Time,End-Date,Duration,Count" | Out-File -FilePath $LogFile -Encoding UTF8
} 

# Function to Output Test Results to the Log File
function Update-Logfile {
    param (
        [string]$OutputFile,
        [datetime]$LogStart,
        [datetime]$LogEnd,
        [int]$LogCount
    )
    # Calculate Length Of the Outage in Seconds
    $LogLegnth = [System.Math]::Round($($LogEnd - $LogStart).TotalSeconds)

    # Output the Test Results to the Log File
    $LogOutput = "$($LogStart.ToString("HH:mm:ss")),$($LogStart.ToString("MM/dd/yyyy")),$($LogEnd.ToString("HH:mm:ss")),$($LogEnd.ToString("MM/dd/yyyy")),$($LogLegnth),$($LogCount)"
    $LogOutput | Out-File -FilePath $OutputFile -Append -Encoding UTF8
}

# Intro Text 
Write-Host -ForegroundColor Cyan "Starting Ping Tests; Script Will Run Until $($ScriptEndpoint.ToString('hh:mm:ss tt, MM-dd-yyyy'))"
Write-Host -ForegroundColor Magenta "------------------------------------------------------------------"

# Loop for Time Set by $ScriptEndpoint
while ($TimeCheck -lt $ScriptEndpoint) {

    # Perform Connection Test Against Set IP
    $PingResults = Test-Connection -ComputerName $TestIP -Count 1 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

    # If and Switch Statements to Check the Results of the Ping Test and Perform Tasks Based on those Results
    if ($PingResults) {
        switch ($NetworkStatus) {
            $true {
                # Write to Console Status of the Network
                Write-Host -ForegroundColor Green "Network Still Connected At $(Get-Date -f 'hh:mm:ss tt'), on $(Get-Date -f 'D')"
            }
            $false { 
                # Set Current Network Status and Get Date for the Outage End
                $NetworkStatus = $true
                $OutageEnd = Get-Date
                $OutageCount++

                # Write to Console Status of the Network
                Write-Host -ForegroundColor Magenta "------------------------------------------------------------------"
                Write-Host -ForegroundColor Green "Network Connectivity Restored At $($OutageEnd.ToString('hh:mm:ss tt')), on $($OutageEnd.ToString('D')); Logging Outage"

                # Write Results to the Log File
                Update-Logfile -OutputFile $LogFile -LogStart $OutageStart -LogEnd $OutageEnd -LogCount $OutageCount
            }
            Default {
                Write-Host -ForegroundColor DarkRed "SCRIPT ERROR DURING SWITCH STATEMENT! EXITING SCRIPT! Exit Code: SS-01"
                Exit
            }
        }
    } 
    else {
        switch ($NetworkStatus) {
            $true { 
                # Set Current Network Status and Get Date for the Outage Start
                $NetworkStatus = $false
                $OutageStart = Get-Date

                # Write to Console Status of the Network
                Write-Host -ForegroundColor Magenta "------------------------------------------------------------------"
                Write-Host -ForegroundColor DarkRed "NETWORK HAS GONE DOWN AT $($OutageStart.ToString('hh:mm:ss tt')), ON $($OutageStart.ToString('D').ToUpper())"
            }
            $false { 
                # Write to Console Status of the Network
                Write-Host -ForegroundColor Red "Network Still Down At $(Get-Date -f 'hh:mm:ss tt'), on $(Get-Date -f 'D')"
            }
            Default {
                Write-Host -ForegroundColor DarkRed "SCRIPT ERROR DURING SWITCH STATEMENT! EXITING SCRIPT! Exit Code: SS-02"
                Exit
            }
        }
    }

    # Wait to Perform Next Network Ping Test
    Start-Sleep -Seconds $ScriptInterval

    # Update Current Time 
    $TimeCheck = Get-Date
}

Write-Host -ForegroundColor Magenta "------------------------------------------------------------------"
Write-Host -ForegroundColor Cyan "Network Testing Has Finished At $($OutageStart.ToString('hh:mm tt')), on $($OutageStart.ToString('D'))\nYou may now close this window..."

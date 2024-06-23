# Network Monitor
This script constantly pings a set IP address at a user defined interval to check for network connectivity. If the script detects a drop in the  network, it logs the date/time of the start of the outage, and then saves the end and total time of the outage once network connectivity has been restored. The script outputs a log file inside a folder created using the  Year and Month of when the script is ran. The log file has the full Date of when the script started running as part of its filename. 
# How To Use
First open the following script file in any text editor; you need to first need to enter basic settings in the script:
```
Network-Monitor.ps1
```
Look for the following Variables directly after the big comment/information section (contained between <# #> PowerShell comment brackets), and set how you want the script to run.
## Script Settings
The first variable in the script, this will be the IP address the script will attempt to contact to make sure you have an active internet connection. Make sure this is an IP you are not going to get in trouble for pinging constantly, and that it is one that will always be up (or else you will get false internet outage results). Google can help you find good IP's that others use for this task. The script will automatically stop if it detects an invaid IP address set here.
```
$TestIP = "0" 
```

This variable sets how long the script will run, and can be changed to however long you like. By default I have it set to run for 12 hours, which is 720 minutes. You can set this to 1 day by changing the number in the parentheses. You can also change the 'AddMinutes(x)' part to 'AddDays(x)', and simply set it to (1) to run for one full day. Just remember you can always close the script manually, or hit 'Ctrl+C' to force a PowerShell script to stop while running. 
```
$ScriptEndpoint = (Get-Date).AddMinutes(2) 
```

The final user editable variable is the interval, or how long the script waits before sending another ping. This is also in seconds, so you can set it very fast or give it time. 3-10 seconds would be good, and if you are only looking for major outages, you can set the interval even longer. 
```
$ScriptInterval = 3 
```
## Script Output
The script will export a CSV file under a subfolder based on where the 'Network-Monitor.ps1' script is located. The script uses the date to create a folder using Year-Month. 

EX: If you ran the script on July 20th, 2005 then the script would create this folder:
```
2025-07
```

The CSV file the script outputs to that folder starts with 'Outage-Log_', then has the full date using Year-Month-Day, followed by '.csv'.

EX: Using our above date of July 20th, 2005, then our folder and file structure would look like the following (Text warped with <> are Folders, a - before text is a file):
```
<FOLDER CONTAINTING THE SCRIPT>
    <2025-06>
        -Outage-Log_2025-07-20.csv
```
# License
Distributed under the GNU GPL-3.0 license; please check the 'LICENSE' file in the GitHub repository for more information. 
# Disclaimer 
The following is the disclaimer that applies to all scripts, functions, one-liners, etc. This disclaimer supersedes any disclaimer included in any script, function, one-liner, etc.

You running this script/function means you will not blame the author(s) if this breaks your stuff. This script/function is provided AS IS without warranty of any kind. Author(s) disclaim all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event shall author(s) be held liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the script or documentation. Neither this script/function, nor any part of it other than those parts that are explicitly copied from others, may be republished without author(s) express written permission. Author(s) retain the right to alter this disclaimer at any time. For the most up to date version of the disclaimer, see https://ucunleashed.com/code-disclaimer.



$tempPath = "C:\ComputerInventory"
$tempPathExists = Test-Path -Path $tempPath  

if ($tempPathExists) {}

else {
New-Item -Path C:\ -Name "ComputerInventory" -ItemType Directory
Set-Location -Path C:\ComputerInventory
}







masterFunc

function masterFunc {




Write-Host -ForegroundColor Red "*****************************************************"
Write-Host -ForegroundColor Red "Welcome to the Computer Quick Information Utility"
write-host ""
Write-Host -ForegroundColor Red "Please select one of the options below"
Write-Host -ForegroundColor Red "1. Monitor Information"
Write-Host -ForegroundColor Red "2. Processor Info"
Write-Host -ForegroundColor Red "3. RAM information"
Write-Host -ForegroundColor Red "4. Disk Information"
Write-Host -ForegroundColor Red "5. Installed Software"
Write-Host -ForegroundColor Red "6. Service Status"
Write-Host -ForegroundColor Red "7. Exit"




$userSelection = Read-Host -Prompt "Enter your selection:"

switch ($userSelection) {
    1 { monitorInformation }
    2 { processorInfo }
    3 { ramInfo }
    7 { exit 0 }
        
    Default { Write-Host -ForegroundColor Red "Please make a selection!"

    masterFunc

}
}

}


function monitorInformation {
  
    

#This defines the CIM to get the monitor manufacturer and model information.
$monitors = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorID


#This loop grabs the monitors from the previous command and then
#grabs the VideoOutputTech information and evaluates the number returned. The loop has been modified such that it pairs the information found about the
#monitor model and brand with the connection type.
#This array can be updated with newer video display tech as necessary.
#These outputs are documented here: 
#https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/d3dkmdt/ne-d3dkmdt-_d3dkmdt_video_output_technology



foreach ($monitor in $monitors) {

    #This first statement is required to keep the connection type paired with its correct monitor. If this isn't here, it will return both values for each monitor found
    $connectionParameter = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorConnectionParams | 
                        Where-Object { $_.InstanceName -eq $monitor.InstanceName }

    $connectionType = switch ($connectionParameter.VideoOutputTechnology) {
        -1 { "Unknown" }
        0 { "VGA" }
        4 { "DVI" }
        5 { "HDMI" }
        10 { "DisplayPort" }
        11 { "Miracast" }
        12 { "USBCALT" }
        default { "Other" }
    }
    
#This if statement was added because the string value in PowerShell CANNOT return null. The whole script fucks up.
if ($monitor.UserFriendlyName -eq $null) {$model = "Value is null. Most likely a laptop display"}
else { $model = [System.Text.Encoding]::ASCII.GetString($monitor.UserFriendlyName).Trim([char]0) }

    $manufacturer = [System.Text.Encoding]::ASCII.GetString($monitor.ManufacturerName).Trim([char]0)
    $serial = [System.Text.Encoding]::ASCII.GetString($monitor.SerialNumberID).Trim([char]0)
    

#Write the results.
    Write-Host "" #padding
    Write-Host ""
    Write-Host ""
    Write-Host -ForegroundColor Yellow "Monitor: $model"
    Write-Host -ForegroundColor Red "------------------------"
    Write-Host -ForegroundColor Yellow "Manufacturer: $manufacturer"
    Write-Host -ForegroundColor Red "------------------------"
    Write-Host -ForegroundColor Yellow "Serial Number: $serial"
    Write-Host -ForegroundColor Red "------------------------"
    Write-Host -ForegroundColor Yellow "Connection Type: $connectionType"
    Write-Host -ForegroundColor Red "------------------------"
    Write-Output "" #padding


}

main

}


function processorInfo {
    
   

$processorName = Get-WmiObject Win32_Processor | Select-Object -Property "Name"
$processorMaxSpeed = Get-WmiObject Win32_Processor | Select-Object -Property "MaxClockSpeed"
$processorCurrentSpeed = Get-WmiObject Win32_Processor | Select-Object -ExpandProperty "CurrentClockSpeed"
$processorHealthStatus = Get-WmiObject Win32_Processor | Select-Object -Property "Status"

Write-Host $processorCurrentSpeed
Write-Host "The type of processorCurrentSpeed is: $($processorCurrentSpeed.GetType().Name)"

#Start-Sleep -Seconds 25

 # Ensure floating-point division
 $convertedClockSpeed = [double]$processorCurrentSpeed / 1000

 #$integerConvClockSpd = [int]$convertedClockSpeed


#$convertedClockSpeed = $processorCurrentSpeed / 1000
#$integerConvClockSpd = [double]$convertedClockSpeed


#Write-Host $integerConvClockSpd

#Start-Sleep -Seconds 20


    #Write the results.
    Write-Host "" #padding
    Write-Host ""
    Write-Host ""
    Write-Host -ForegroundColor Yellow "Processor Name: $processorName"
    Write-Host -ForegroundColor Red "------------------------"
    Write-Host -ForegroundColor Yellow "Processor Base Speed: $convertedClockSpeed Ghz"
    Write-Host -ForegroundColor Red "------------------------"
    Write-Host -ForegroundColor Yellow "Processor Maximum Speed: $processorMaxSpeed Ghz"
    Write-Host -ForegroundColor Red "------------------------"
    Write-Host -ForegroundColor Yellow "Processor Health Status: $processorHealthStatus"
    Write-Host -ForegroundColor Red "------------------------"
    Write-Output "" #padding
    
    masterFunc
}


function ramInfo {
    
    Write-Host -ForegroundColor Red "Not implemented. Start over."
    
    masterFunc
}
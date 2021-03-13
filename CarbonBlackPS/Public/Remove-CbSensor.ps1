<#
    .SYNOPSIS
    Remove sensor from Carbon Black console.
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/devices-api/#delete-sensor
    
    .PARAMETER SensorID
    Sensor ID of device to remove from Carbon Black console. This is the safest method and ensures you target the correct device.

    .PARAMETER ComputerName
    Name of the device to remove from Carbon Black console. Use at your own risk, if there are multiple devices named similar to the value specified you may target a device you don't intend to.
    Highly recommend using in conjunction with -WhatIf first to ensure that the intended device is targeted.
    
    .EXAMPLE
    Remove-CbSensor -SensorID 12345678

    .EXAMPLE
    Remove-CbSensor -ComputerName "tim-pc"

#>

function Remove-CbSensor {

    [CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(ParameterSetName='ComputerName', Mandatory=$true)]
        [string]$ComputerName,

        [Parameter(ParameterSetName='SensorID', Mandatory=$true)]
        [int]$SensorID

    )

    $jsonBody = "{
    ""action_type"": ""DELETE_SENSOR""
}"

    $psObjBody = $jsonBody | ConvertFrom-Json    

    if ($SensorID) {
        try {
            $device = Get-CbDevice -SensorID $SensorID
            if (($device.status -eq "DEREGISTERED") -or ($device.status -eq "UNINSTALLED")) {
                $psObjBody | Add-Member -Name "device_id" -Value @($SensorID) -MemberType NoteProperty
            } else {
                throw "ERROR: Device must exist and be in either a 'DEREGISTERED' or 'UNINSTALLED' state to remove the sensor."
                break
            }
        }
        catch {
            throw "ERROR: Device must exist and be in either a 'DEREGISTERED' or 'UNINSTALLED' state to remove the sensor."
            break
        }
    }
    if ($ComputerName) {
        try {
            $device = Get-CbDevice -Search $ComputerName
            if (($device.status -eq "DEREGISTERED") -or ($device.status -eq "UNINSTALLED")) {
                $psObjBody | Add-Member -Name "device_id" -Value @($device.id) -MemberType NoteProperty
            } else {
                throw "ERROR: Device must exist and be in either a 'DEREGISTERED' or 'UNINSTALLED' state to remove the sensor."
                break
            }
        }
        catch {
            throw "ERROR: Device must exist and be in either a 'DEREGISTERED' or 'UNINSTALLED' state to remove the sensor."
            break
        }
    }

    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/device_actions"
        Method     = "Post"
        Body       = $jsonBody
    }

    if ($PSCmdlet.ShouldProcess($device.name, "remove sensor from console")) {
        $result = Invoke-CbMethod @Parameters
        $result
    }

}
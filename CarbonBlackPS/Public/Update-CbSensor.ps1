<#
    .SYNOPSIS
    Updates Carbon Black sensor version on a device.
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/devices-api/#update-sensor-version
    
    .PARAMETER SensorID
    Sensor ID of device to update. This is the safest method and ensures you target the correct device.

    .PARAMETER ComputerName
    Name of the device to update. Use at your own risk, if there are multiple devices named similar to the value specified you may target a device you don't intend to.
    Highly recommend using in conjunction with -WhatIf first to ensure that the intended device is targeted.
    
    .EXAMPLE
    Update-CbSensor -SensorID 12345678 -SensorVersion 3.6.0.1979

    .EXAMPLE
    Update-CbSensor -ComputerName "tim-pc" -SensorVersion 3.6.0.1979

#>

function Update-CbSensor {

    [CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(ParameterSetName='ComputerName', Mandatory=$true)]
        [string]$ComputerName,

        [Parameter(ParameterSetName='SensorID', Mandatory=$true)]
        [int]$SensorID,

        [Parameter(ParameterSetName='SensorID', Mandatory=$true)]
        [Parameter(ParameterSetName='ComputerName', Mandatory=$true)]
        [string]$SensorVersion

    )

    $jsonBody = "{
    ""action_type"": ""UPDATE_SENSOR_VERSION"",
    ""options"": {
        ""sensor_version"": {

        }
    }
}"

    $psObjBody = $jsonBody | ConvertFrom-Json    

    if ($SensorID) {
        $psObjBody | Add-Member -Name "device_id" -Value @($SensorID) -MemberType NoteProperty
        $device = Get-CbDevice -SensorID $SensorID
        $psObjBody.options.sensor_version | Add-Member -Name $device.sensor_kit_type -Value $SensorVersion -MemberType NoteProperty
    }
    if ($ComputerName) {
        try {
            $device = Get-CbDevice -Search $ComputerName
        }
        catch {
            throw "Unable to find device."
            break
        }
        $psObjBody | Add-Member -Name "device_id" -Value @($device.id) -MemberType NoteProperty
        $psObjBody.options.sensor_version | Add-Member -Name $device.sensor_kit_type -Value $SensorVersion -MemberType NoteProperty
    }

    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/device_actions"
        Method     = "Post"
        Body       = $jsonBody
    }

    if ($PSCmdlet.ShouldProcess($device.name, "update sensor version to $SensorVersion")) {
        $result = Invoke-CbMethod @Parameters
        $result
    }

}
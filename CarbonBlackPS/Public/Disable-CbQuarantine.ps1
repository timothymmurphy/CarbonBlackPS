<#
    .SYNOPSIS
    Disables quarantine for a device within Carbon Black.
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/devices-api/#quarantine
    
    .PARAMETER SensorID
    Sensor ID to unquarantine. This is the safest method and ensures you target the correct device.

    .PARAMETER ComputerName
    Name of the device to unquarantine. Use at your own risk, if there are multiple devices named similar to the value specified you may target a device you don't intend to.
    Highly recommend using in conjunction with -WhatIf first to ensure that the intended device is targeted.
    
    .EXAMPLE
    Disable-CbQuarantine -SensorID 12345678

    .EXAMPLE
    Disable-CbQuarantine -ComputerName "tim-pc"

#>

function Disable-CbQuarantine {

    [CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(ParameterSetName='ComputerName', Mandatory=$true)]
        [string]$ComputerName,

        [Parameter(ParameterSetName='SensorID', Mandatory=$true)]
        [int]$SensorID

    )

    $jsonBody = "{
    ""action_type"": ""QUARANTINE"",
    ""options"": {
        ""toggle"": ""OFF""
    }
}"

    $psObjBody = $jsonBody | ConvertFrom-Json    

    if ($SensorID) {
        $psObjBody | Add-Member -Name "device_id" -Value @($SensorID) -MemberType NoteProperty
        $device = Get-CbDevice -SensorID $SensorID
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
    }

    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/device_actions"
        Method     = "Post"
        Body       = $jsonBody
    }

    if ($PSCmdlet.ShouldProcess($device.name, "unquarantine")) {
        $result = Invoke-CbMethod @Parameters
        $result
    }

}
<#
    .SYNOPSIS
    Establishes Live Response session with a device.
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/live-response-api/#start-session
    
    .PARAMETER SensorID
    Sensor ID to establish session with.

    .EXAMPLE
    Start-CbLRSession -SensorID 1234567

#>

function Start-CbLRSession {

    param (

        [Parameter(Mandatory=$true)]
        [int]$SensorID

    )

    $jsonBody = "{
    ""device_id"": ""$SensorID""
}"

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/liveresponse/sessions"
        Method     = "Post"
        Body       = $jsonBody
    }

    $result = Invoke-CbMethod @Parameters
    $result
    

}
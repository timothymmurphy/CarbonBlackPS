<#
    .SYNOPSIS
    Closes Live Response session.
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/live-response-api/#close-session
    
    .PARAMETER SessionID
    Sensor ID to establish session with.

    .EXAMPLE
    Remove-CbLRSession -SessionID 1234567

#>

function Remove-CbLRSession {

    param (

        [Parameter(Mandatory=$true)]
        [string]$SessionID

    )

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/liveresponse/sessions/$SessionID"
        Method     = "Delete"
    }

    $result = Invoke-CbMethod @Parameters
    $result
    

}
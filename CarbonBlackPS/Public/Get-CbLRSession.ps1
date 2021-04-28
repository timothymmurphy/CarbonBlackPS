<#
    .SYNOPSIS
    Get Live Response session information.
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/live-response-api/#get-session-by-id
    https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/live-response-api/#get-all-sessions
    
    .EXAMPLE
    Get-CbLRSession

    Returns all Live Response sessions
    
    .EXAMPLE
    Get-CbLRSession -SessionID 7008:1234567

    Returns information for individual session

#>

function Get-CbLRSession {

    param (

        [string]$SessionID

    )

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/liveresponse/sessions"
        Method        = "Get"
    }

    if ($SessionID) {$Parameters.UriPostOrgKey = "/liveresponse/sessions/$SessionID"}

    $result = Invoke-CbMethod @Parameters
    $result
    

}
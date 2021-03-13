<#
    .SYNOPSIS
    Fetch the notes created for the specified alert
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/alerts-api/#get-notes
    
    .PARAMETER AlertID
    Alert ID of the alert to attach the note to    

    .EXAMPLE
    Get-CbAlertNote -AlertID $alertID 
#>

function Get-CbAlertNote {

    param (

        [Parameter(Mandatory=$true)]
        [string]$AlertID

    )

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/alerts/$AlertID/notes"
        Method        = "Get"
    }

    $result = Invoke-CbMethod @Parameters
    $result.results

}
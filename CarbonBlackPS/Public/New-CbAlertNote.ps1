<#
    .SYNOPSIS
    Add segments of text to an alert to track notes while investigating the potential threat.
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/alerts-api/#create-note
    
    .PARAMETER Note
    The text value of the note to be attached to the specific alert

    .PARAMETER AlertID
    Alert ID of the alert to attach the note to    

    .EXAMPLE
    New-CbAlertNote -AlertID $alertID -Note "Currently investigating..."
#>

function New-CbAlertNote {

    param (

        [Parameter(Mandatory=$true)]
        [string]$AlertID,

        [Parameter(Mandatory=$true)]
        [string]$Note

    )

    $jsonBody = "{
    ""note"": ""$Note""
}"

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/alerts/$AlertID/notes"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-CbMethod @Parameters
    $result

}
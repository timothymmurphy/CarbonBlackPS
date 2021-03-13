<#
    .SYNOPSIS
    Deletes the specified note for the specified alert
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/alerts-api/#delete-note
    
    .PARAMETER AlertID
    Alert ID of the alert to remove the note from   
    
    .PARAMETER NoteID
    Note ID of the note to delete

    .EXAMPLE
    Remove-CbAlertNote -AlertID $alertID -NoteID $noteID
#>

function Remove-CbAlertNote {

    param (

        [Parameter(Mandatory=$true)]
        [string]$AlertID,

        [Parameter(Mandatory=$true)]
        [string]$NoteID

    )

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/alerts/$AlertID/notes/$NoteID"
        Method        = "Delete"
    }

    $result = Invoke-CbMethod @Parameters
    $result

}
<#
    .SYNOPSIS
    Updates the status of an alert.
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/alerts-api/#create-workflow
    
    .PARAMETER AlertID
    Alert ID of the alert's status to update

    .PARAMETER State
    Workflow state to set. Options are "DISMISSED" or "OPEN"    

    .PARAMETER RemediationState
    Description or justification for the change  

    .PARAMETER Comment
    Comment to include with the operation

    .EXAMPLE
    Set-CbAlert -AlertID $alertID -State DISMISSED -RemediationState "Remediated" -Comment "Validated by Tim"
#>

function Set-CbAlert {

    param (

        [Parameter(Mandatory=$true)]
        [string]$AlertID,

        [Parameter(Mandatory=$true)]
        [ValidateSet("DISMISSED", "OPEN")]
        [string]$State,

        [string]$RemediationState,

        [string]$Comment

    )

    $jsonBody = "{
    ""state"": ""$State""
}"

    $psObjBody = $jsonBody | ConvertFrom-Json    

    if ($RemediationState) {$psObjBody | Add-Member -Name "remediation_state" -Value $RemediationState -MemberType NoteProperty}
    if ($Comment) {$psObjBody | Add-Member -Name "comment" -Value $Comment -MemberType NoteProperty}

    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/alerts/$AlertID/workflow"
        Method     = "Post"
        Body       = $jsonBody
    }

    $result = Invoke-CbMethod @Parameters
    $result

}
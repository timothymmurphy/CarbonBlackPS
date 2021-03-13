<#
    .SYNOPSIS
    Updates a threat with the current state of the remediation. This will dismiss all future alerts that are associated with the thread_id when marked as DISMISSED
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/alerts-api/#create-threat-workflow
    
    .PARAMETER ThreatID
    Threat ID of the threat to update

    .PARAMETER State
    Workflow state to set. Options are "DISMISSED" or "OPEN"    

    .PARAMETER RemediationState
    Description or justification for the change  

    .PARAMETER Comment
    Comment to include with the operation

    .EXAMPLE
    Set-CbThreat -ThreatID $threatID -State DISMISSED -RemediationState "Remediated" -Comment "Validated by Tim"
#>

function Set-CbThreat {

    param (

        [Parameter(Mandatory=$true)]
        [string]$ThreatID,

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
        UriPostOrgKey = "/threat/$ThreatID/workflow"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-CbMethod @Parameters
    $result

}
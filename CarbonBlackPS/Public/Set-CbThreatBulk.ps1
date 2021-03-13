<#
    .SYNOPSIS
    Bulk update threat workflow by threat_id
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/alerts-api/#bulk-create-threat-workflows
    
    .PARAMETER ThreatID
    Threat ID of the threat to update

    .PARAMETER State
    Workflow state to set. Options are "DISMISSED" or "OPEN"    

    .PARAMETER RemediationState
    Description or justification for the change  

    .PARAMETER Comment
    Comment to include with the operation

    .EXAMPLE
    Set-CbThreatBulk -ThreatID $threatID -State DISMISSED -RemediationState "Remediated" -Comment "Validated by Tim"
#>

function Set-CbThreatBulk {

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
    ""state"": ""$State"",
    ""threat_id"": [
        ""$ThreatID""
    ]
}"

    $psObjBody = $jsonBody | ConvertFrom-Json    

    if ($RemediationState) {$psObjBody | Add-Member -Name "remediation_state" -Value $RemediationState -MemberType NoteProperty}
    if ($Comment) {$psObjBody | Add-Member -Name "comment" -Value $Comment -MemberType NoteProperty}

    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/threat/workflow/_criteria"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-CbMethod @Parameters
    $result

}
<#
    .SYNOPSIS
    Get the current status of a bulk workflow request
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/alerts-api/#get-bulk-workflow-status
    
    .PARAMETER RequestID
    Request ID supplied when a bulk workflow was created

    .EXAMPLE
    Get-CbWorkflowStatus -RequestID $requestID
#>

function Get-CbWorkflowStatus {

    param (

        [Parameter(Mandatory=$true)]
        [string]$RequestID

    )

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/workflow/status/$RequestID"
        Method        = "Get"
        Body          = $jsonBody
    }

    $result = Invoke-CbMethod @Parameters
    $result

}
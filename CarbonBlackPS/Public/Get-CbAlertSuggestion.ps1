<#
    .SYNOPSIS
    Get recommendations for key or values based on the specified search query
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/alerts-api/#get-alert-search-suggestions
    
    .PARAMETER Search
    The query string for which you want completion suggestions. If this is left blank, all key suggestions will be returned.

    .EXAMPLE
    Get-CbAlertSuggestion -Search "query"
#>

function Get-CbAlertSuggestion {

    param (

        [string]$Search

    )

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/alerts/search_suggestions?suggest.q=$Search"
        Method        = "Get"
        Body          = $jsonBody
    }

    $result = Invoke-CbMethod @Parameters
    $result.suggestions

}
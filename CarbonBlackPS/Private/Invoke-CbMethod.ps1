function Invoke-CbMethod {
    <#
    .SYNOPSIS
    Invocation of the Carbon Black API call
    #>
    
    param (
        [Parameter(Mandatory = $true)]
        [string]$UriPreOrgKey,

        [Parameter(Mandatory = $true)]
        [string]$UriPostOrgKey,

        [Parameter(Mandatory = $true)]
        [string]$Method,

        [string]$Body
    )
    
    #Retrieve Configuration Values
    $config      = Get-CbConfig
    $environment = $config.environment
    $apiSecret   = $config.apiSecret
    $apiID       = $config.apiID
    $orgKey      = $config.orgKey
    $apiKey      = "$apiSecret/$apiID"
    $targetUrl   = $environment + $UriPreOrgKey + $orgKey + $UriPostOrgKey

    # Create headers
    $headers = @{
        "X-Auth-Token" = $apiKey
        "Content-Type" = "application/json"
    }


    # Set mandatory parameters
    $splatParameters = @{
        Uri         = $targetUrl
        Method      = $Method
        Headers     = $headers
    }

    if ($Body) {
        $splatParameters.Add("Body", $Body)
    }

    # Invoke the API
    try {
        $webResponse = Invoke-RestMethod @splatParameters
    }
    catch {
        throw "Error: Bad response received."
    }

    if ($webResponse) {
        return $webResponse
    }
    
}
    
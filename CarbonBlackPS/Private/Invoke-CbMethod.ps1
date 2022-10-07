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
	write-host "The config: "
	write-host ($config | convertto-json)
    $environment = $config.environment
#    $apiSecret   = $config.apiSecret
#    $apiID       = $config.apiID
    $orgKey      = $config.orgKey
#    $apiKey      = "$apiSecret/$apiID"
    $apiKey = $config.apiKey
	$customKey = $config.customKey
    $targetUrl   = $environment + $UriPreOrgKey + $orgKey + $UriPostOrgKey
	
	write-host ( $config | format-list)
write-host "environment: " + $config.environment + $environment
write-host "UriPreOrgKey: " + $URIpreOrgKey
write-host "orgKey: " + $config.orgkey + $orgKey
write-host "UriPostOrgKey: " + $UriPostOrgKey
    # Create headers
    $headers = @{
        "X-Auth-Token" = $customKey
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
	write-host ($splatParameters | convertto-json)
# Invoke the API
<#
    try {
        $webResponse = Invoke-RestMethod @splatParameters
    }
    catch {
        throw "Error: Bad response received: "
    }
#>
$webResponse = Invoke-RestMethod @splatParameters #temp, to get full error
    if ($webResponse) {
        return $webResponse
    }
    
}
    
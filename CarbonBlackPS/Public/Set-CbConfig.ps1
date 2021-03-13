#Credit to https://mattbobke.com/2018/11/12/building-a-powershell-module-part-3-json-config-files-are-awesome/ for inspiration
function Set-CbConfig {
    <#
        .SYNOPSIS
        Set required values to make Carbon Black API calls.

        .DESCRIPTION
        Sets the API Secret, API ID, Org Key, and Environment which are required to make any API calls.

        .PARAMETER Environment
        Carbon Black environment (found in URL for your Carbon Black Cloud console), possible values include "https://defense-eap01.conferdeploy.net", "https://dashboard.confer.net", "https://defense.conferdeploy.net", "https://defense-prod05.conferdeploy.net", "https://defense-eu.conferdeploy.net", "https://defense-prodnrt.conferdeploy.net", "https://defense-prodsysd.conderdeploy.net"
        See official Carbon Black documentation for guidance: https://developer.carbonblack.com/reference/carbon-black-cloud/authentication/#constructing-your-request

        .PARAMETER ApiSecret
        API Secret

        .PARAMETER ApiID
        API ID

        .PARAMETER OrgKey
        Org Key

        .EXAMPLE
        Set-CbConfig -Environment "https://defense-prod05.conferdeploy.net" -ApiSecret "apiSecret_goes_here" -ApiID "apiID_goes_here" -OrgKey "orgKey_goes_here"
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("https://defense-eap01.conferdeploy.net", "https://dashboard.confer.net", "https://defense.conferdeploy.net", "https://defense-prod05.conferdeploy.net", "https://defense-eu.conferdeploy.net", "https://defense-prodnrt.conferdeploy.net", "https://defense-prodsysd.conderdeploy.net")]
        [string]$Environment,
        
        [Parameter(Mandatory = $true)]
        [string]$ApiSecret,
        
        [Parameter(Mandatory = $true)]
        [string]$ApiID,
        
        [Parameter(Mandatory = $true)]
        [string]$OrgKey
    )

    try {
        Write-Verbose -Message 'Checking for existing configuration...'
        $config = Get-Content -Path "$PSScriptRoot\..\config.json" -ErrorAction 'Stop' | ConvertFrom-Json
        Write-Verbose -Message 'Stored config.json found.'
    } 
    catch {
        Write-Verbose -Message 'No configuration found - starting with empty configuration.'
        $jsonString = @'
{   
    "environment" : "",
    "apiSecret" : "",
    "apiID" : "",
    "orgKey" : ""
}
'@
        $config = $jsonString | ConvertFrom-Json
    }

    if ($Environment) {$config.environment = $Environment}
    if ($ApiSecret) {$config.apiSecret = $ApiSecret}
    if ($ApiID) {$config.apiID = $ApiID}
    if ($OrgKey) {$config.orgKey = $OrgKey}

    Write-Verbose -Message 'Setting config.json.'
    $config | ConvertTo-Json | Set-Content -Path "$PSScriptRoot\..\config.json"
}
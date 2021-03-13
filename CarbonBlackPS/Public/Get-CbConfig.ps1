#Credit to https://mattbobke.com/2018/11/12/building-a-powershell-module-part-3-json-config-files-are-awesome/ for inspiration
function Get-CbConfig {
    <#
        .SYNOPSIS
        Get Carbon Black API configuration.

        .DESCRIPTION
        Get Carbon Black API configuration.

        .EXAMPLE
        Get-CbConfig
    #>

    [CmdletBinding()]
    param()

    try {
        Write-Verbose -Message 'Getting content of config.json and returning as a PSCustomObject.'
        $config = Get-Content -Path "$PSScriptRoot\..\config.json" -ErrorAction 'Stop' | ConvertFrom-Json

        $config = [PSCustomObject] @{
            environment = $config.environment;
            apiSecret   = $config.apiSecret;
            apiID       = $config.apiID;
            orgKey      = $config.orgKey;
        }

        return $config

    } 
    catch {
        throw "Unable to find existing configuration file. Use 'Set-CbConfig' to create one."
    }
}
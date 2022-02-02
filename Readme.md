# CarbonBlackPS
A PowerShell API wrapper for Carbon Black.

# Setup
## PowerShell Gallery Installation
1. Open PowerShell and run `Install-Module -Name CarbonBlackPS` to install the module from PowerShell Gallery
2. Open PowerShell and run `Import-Module CarbonBlackPS` to import the module
3. Next run `Set-CbConfig` to create your `config.json` file with your appropriate API keys. After this has been generated, all of the commands in this module will work.

    - Example: `Set-CbConfig -Environment "https://defense-prod05.conferdeploy.net" -ApiSecret "YOUR_API_SECRET" -ApiID "YOUR_API_ID" -OrgKey "YOUR_ORG_KEY"`
      - Note: Environment will vary - see [here](https://developer.carbonblack.com/reference/carbon-black-cloud/authentication/#constructing-your-request) for more details.

## Manual Installation
1. Download and extract `CarbonBlackPS` folder contents to one of the following directories:
    - `C:\Users\$username\Documents\WindowsPowerShell\Modules\CarbonBlackPS` (local user scoped installation)
    - `C:\Program Files\WindowsPowerShell\Modules\CarbonBlackPS` (global system installation)
    
2. Open PowerShell and run `Import-Module CarbonBlackPS` to import the module  

3. Next run `Set-CbConfig` to create your `config.json` file with your appropriate API keys. After this has been generated, all of the commands in this module will work.

    - Example: `Set-CbConfig -Environment "https://defense-prod05.conferdeploy.net" -ApiSecret "YOUR_API_SECRET" -ApiID "YOUR_API_ID" -OrgKey "YOUR_ORG_KEY"`
      - Note: Environment will vary - see [here](https://developer.carbonblack.com/reference/carbon-black-cloud/authentication/#constructing-your-request) for more details.

# Commands
## Devices API
- Get-CbDevice
- Get-CbDeviceExport
- Get-CbFacetDevice
- Enable-CbQuarantine
- Disable-CbQuarantine
- Enable-CbBypass
- Disable-CbBypass
- Enable-CbBackgroundScan
- Disable-CbBackgroundScan
- Update-CbPolicy
- Update-CbSensor
- Uninstall-CbSensor
- Remove-CbSensor
## Alerts API
- Get-CbAlert
- Get-CbFacetAlert
- Set-CbAlert
- Set-CbAlertBulk
- Set-CbThreat
- Set-CbThreatBulk
- Get-CbWorkflowStatus
- Get-CbAlertSuggestion
- New-CbAlertNote
- Get-CbAlertNote
- Remove-CbAlertNote
## Live Response API
- Get-CbLRSession
- Start-CbLRSession
- Remove-CbLRSession

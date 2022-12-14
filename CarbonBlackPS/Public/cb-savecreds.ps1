<#
    .SYNOPSIS
    Prompt for credentials and variables.
    Save them in the current directory encrypted with Windows' SecureString.


    .DESCRIPTION
    Prompt for credentials and variables.
    Save them in the current directory encrypted with Windows' SecureString.


    .EXAMPLE
    Set-CbConfig, Get-CbConfig
#>

function Get-CbConfig {

    [CmdletBinding()]
    param()

    $PSCHostname = ""
    $orgKey = ""
    $APIAuthToken = ""
    $CustomAuthToken = ""
    if ($psISE) {
        $credentialsFile = Join-Path (Split-Path -Path $psISE.CurrentFile.FullPath) "cb-credentials.enc"
      }
      else {
        $credentialsFile = Join-Path $PSScriptRoot "cb-credentials.enc"
      }
##############################################################

  if (Test-Path $credentialsFile -PathType Leaf) { #If credentials.enc file exists
      cls
      Write-Host "Found saved credentials file`nDecrypted contents:`n"
      $marshal= [runtime.interopservices.marshal]
      $content = Get-Content $credentialsFile
      $credentials = @{}
      for ($z=0; $z -lt $content.count; $z++) {

          $cred = $content[$z] | ConvertTo-SecureString
          $cred = $marshal::PtrToStringAuto( $marshal::securestringToBSTR($cred) )
          $credentials[$z] = $cred
          Write-Host $credentials[$z]
        }
        $apiURL = $credentials[0]
        $PSCHostname = $credentials[1]
        $orgKey = $credentials[2]
        $APIAuthToken = $credentials[3]
        $CustomAuthToken = $credentials[4]

        $config = [PSCustomObject] @{
          environment = $PSCHostName
          apiSecret   = ($CustomAuthToken -split "/")[0]
          apiID       = ($CustomAuthToken -split "/")[1]
          apiAccessLevelSecret = ($APIAuthToken -split "/")[0]
          apiAccessLevelID     = ($APIAuthToken -split "/")[1]
        }
        Write-Host "`nIf you don't want to use this information, quit the script and delete or rename the credentials.enc file`n"
      }
  else { #credentials.enc file doesn't exist
    if (!$PSCHostname) {
        cls
        $PSCHostname = Read-Host "Enter your Carbon Black Cloud URL. Example: https://defense-prod05.conferdeploy.net`n"
        if (-Not ($PSCHostName -match "^https://[A-Z0-9-]+\.[A-Z0-9]+\.net$")) {
          Write-Host ([string]$PSCHostName + " might not be a CBC API url. Double-check and re-run the script if necessary")
          pause
        }
    }

    if (!$APIAuthToken) {
        cls
        $APIAuthTokenID = Read-Host "API Credentials for 'Access Level' of API`nEnter the API ID"
        if (-Not ($APIAuthTokenID -match "^[A-Z0-9]{10}$")) { Write-Host ([string]$APIAuthTokenID + " does not look like an API ID. Double-check and re-run the script if necessary")
      pause }
        cls
        $APIAuthTokenSecretKey = Read-Host "API Credentials for 'Access Level' of API`nEnter the API Secret Key"
        if (-Not ($APIAuthTokenSecretKey -match "^[A-Z0-9]{24}$")) { Write-Host ([string]$APIAuthTokenSecretKey + " does not look like an API Secret Key. Double-check and re-run the script if necessary")
      pause }
        $APIAuthToken = $APIAuthTokenSecretKey + "/" + $APIAuthTokenID
    }

    if (!$CustomAuthToken) {
        cls
        $CustomAuthTokenID = Read-Host "API Credentials for Custom 'Access Level'`nEnter the API ID"
        if (-Not ($CustomAuthTokenID -match "^[A-Z0-9]{10}$")) { Write-Host ([string]$CustomAuthTokenID + " does not look like an API ID. Double-check and re-run the script if necessary")
      pause }
        cls
        $CustomAuthTokenSecretKey = Read-Host "API Credentials for Custom 'Access Level'`nEnter the API Secret Key"
        if (-Not ($CustomAuthTokenSecretKey -match "^[A-Z0-9]{24}$")) { Write-Host ([string]$CustomAuthTokenSecretKey + " does not look like an API Secret Key. Double-check and re-run the script if necessary")
      pause }
        $CustomAuthToken = $CustomAuthTokenSecretKey + "/" + $CustomAuthTokenID
    }
    if (!$orgKey) {
        cls
        try {
           $orgkey = (Invoke-Restmethod -uri "https://defense-prod05.conferdeploy.net/appservices/v1/delegations/" -Headers ($header | convertto-json)).organizations.orgKey }
        catch {
           $orgKey = Read-Host "Enter the ORG KEY"
           if (-Not ($orgKey -match "^[A-Z0-9]{8}$")) {
             Write-Host ([string]$orgKey + " does not look like an Org Key; check in your Console in Settings->General and re-run the script if necessary. `n" +
           "You often get extra spaces or newlines if you copy and paste directly from the web UI.")
           pause
           }
        }
    }

    cls
    Write-Host "Encrypting the following credentials and writing cb-credentials.enc`n`n$ApiURL`n$PSCHostname`n$orgKey`n$APIAuthToken`n$CustomAuthToken`n"
    pause

    $encPSCHostname = ConvertTo-SecureString $PSCHostname -AsPlainText -Force
    $encPSCHostname = $encPSCHostname | ConvertFrom-SecureString
    Add-Content $credentialsFile $encPSCHostname

    $encOrgKey = ConvertTo-SecureString $orgKey -AsPlainText -Force
    $encOrgKey = $encOrgKey | ConvertFrom-SecureString
    Add-Content $credentialsFile $encOrgKey

    $encAPIAuthToken = ConvertTo-SecureString $APIAuthToken -AsPlainText -Force
    $encAPIAuthToken = $encAPIAuthToken | ConvertFrom-SecureString
    Add-Content $credentialsFile $encAPIAuthToken

    $encCustomAuthToken = ConvertTo-SecureString $CustomAuthToken -AsPlainText -Force
    $encCustomAuthToken = $encCustomAuthToken | ConvertFrom-SecureString
    Add-Content $credentialsFile $encCustomAuthToken

  } #end else
  function pause
  {
      Read-Host -Prompt "Press Enter to continue"
  }

}

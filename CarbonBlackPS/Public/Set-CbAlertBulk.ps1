<#
    .SYNOPSIS
    Bulk update alerts by search definition.
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/alerts-api/#bulk-create-workflows
    
    .PARAMETER Search
    Query in lucene syntax and/or including value searches

    .PARAMETER State
    Workflow state to set. Options are "DISMISSED" or "OPEN"    

    .PARAMETER RemediationState
    Description or justification for the change  

    .PARAMETER Comment
    Comment to include with the operation
    
    .PARAMETER Category
    Search criteria for category  

    .PARAMETER SensorID
    Search criteria for sensor ID

    .PARAMETER ComputerName
    Search criteria for name of machine. 

    .PARAMETER OperatingSystem
    Search criteria for operating system
    
    .PARAMETER OperationgSystemVersion
    Search criteria for version of operating system

    .PARAMETER GroupResults
    Specify whether to group results or not

    .PARAMETER AlertID
    Search criteria for alert ID

    .PARAMETER LegacyAlertID
    Search criteria for legacy alert ID

    .PARAMETER MinimumSeverity
    Search criteria for minimum severity

    .PARAMETER PolicyName
    Search criteria for policy name

    .PARAMETER ProcessName
    Search criteria for process name

    .PARAMETER FileHash
    Search criteria for SHA-256 file hash

    .PARAMETER Reputation
    Search criteria for reputation

    .PARAMETER Tag
    Search criteria for tag

    .PARAMETER TargetValue
    Search criteria for target value

    .PARAMETER Username
    Search criteria for device username

    .PARAMETER Type
    Search criteria for type

    .PARAMETER Workflow
    Search criteria for workflow

    .PARAMETER PolicyID
    Search criteria for policy ID

    .PARAMETER ThreatID
    Search criteria for threat ID

    .EXAMPLE
    Set-CbAlertBulk -AlertID $alertID -State DISMISSED -RemediationState "Remediated" -Comment "Validated by Tim"
#>

function Set-CbAlertBulk {

    param (

        [Parameter(Mandatory=$true)]
        [ValidateSet("DISMISSED", "OPEN")]
        [string]$State,

        [string]$RemediationState,

        [string]$Comment,

        [ValidateSet("THREAT", "MONITORED")]
        [string]$Category,

        [int]$SensorID,

        [string]$ComputerName,

        [ValidateSet("WINDOWS", "MAC", "LINUX", "OTHER")]
        [string]$OperatingSystem,

        [string]$OperatingSystemVersion,

        [switch]$GroupResults,

        [string]$AlertID,

        [string]$LegacyAlertID,

        [int]$MinimumSeverity,

        [string]$PolicyName,

        [string]$ProcessName,

        [string]$FileHash,

        [ValidateSet("KNOWN_MALWARE", "SUSPECT_MALWARE", "PUP", "NOT_LISTED", "ADAPTIVE_WHITE_LIST", "COMMON_WHITE_LIST", "TRUSTED_WHITE_LIST", "COMPANY_BLACK_LIST")]
        [string]$Reputation,

        [string]$Tag,

        [ValidateSet("LOW", "MEDIUM", "HIGH", "MISSION_CRITICAL")]
        [string]$TargetValue,

        [string]$Username,

        [string]$Type,

        [string]$Workflow,

        [int]$PolicyID,

        [string]$ThreatID

    )

    $jsonBody = "{
    ""state"": ""$State""
}"

    $psObjBody = $jsonBody | ConvertFrom-Json    

    if ($RemediationState) {$psObjBody | Add-Member -Name "remediation_state" -Value $RemediationState -MemberType NoteProperty}
    if ($Comment) {$psObjBody | Add-Member -Name "comment" -Value $Comment -MemberType NoteProperty}
    if ($Search) {$psObjBody | Add-Member -Name "query" -Value $Search -MemberType NoteProperty}
    if ($ComputerName -or $Category -or $SensorID -or $OperatingSystem -or $OperatingSystemVersion -or $GroupResults -or $AlertID -or $LegacyAlertID -or $MinimumSeverity -or $PolicyName -or $ProcessName -or $FileHash -or $Reputation -or $Tag -or $TargetValue -or $Username -or $Type -or $Workflow -or $PolicyID -or $ThreatID) {
        $psObjBody | Add-Member -Name "criteria" -Value ([PSCustomObject]@{}) -MemberType NoteProperty

        if ($ComputerName) {
            try {
                $device = Get-CbDevice -Search $ComputerName
                $psObjBody.criteria | Add-Member -Name "device_name" -Value @($device.name) -MemberType NoteProperty    
            }
            catch {
                throw "ERROR: No device found with that name."
                break
            }
        }
        if ($Category) {$psObjBody.criteria | Add-Member -Name "category" -Value @($Category) -MemberType NoteProperty}
        if ($SensorID) {$psObjBody.criteria | Add-Member -Name "device_id" -Value @($SensorID) -MemberType NoteProperty}
        if ($OperatingSystem) {$psObjBody.criteria | Add-Member -Name "device_os" -Value @($OperatingSystem) -MemberType NoteProperty}
        if ($OperatingSystemVersion) {$psObjBody.criteria | Add-Member -Name "device_os_version" -Value @($OperatingSystemVersion) -MemberType NoteProperty}
        if ($GroupResults) {
            $psObjBody.criteria | Add-Member -Name "group_results" -Value $true -MemberType NoteProperty
        } else {
            $psObjBody.criteria | Add-Member -Name "group_results" -Value $false -MemberType NoteProperty
        }
        if ($AlertID) {$psObjBody.criteria | Add-Member -Name "id" -Value @($AlertID) -MemberType NoteProperty}
        if ($LegacyAlertID) {$psObjBody.criteria | Add-Member -Name "legacy_alert_id" -Value @($LegacyAlertID) -MemberType NoteProperty}
        if ($MinimumSeverity) {$psObjBody.criteria | Add-Member -Name "minimum_severity" -Value $MinimumSeverity -MemberType NoteProperty}
        if ($PolicyName) {$psObjBody.criteria | Add-Member -Name "policy_name" -Value @($PolicyName) -MemberType NoteProperty}
        if ($ProcessName) {$psObjBody.criteria | Add-Member -Name "process_name" -Value @($ProcessName) -MemberType NoteProperty}
        if ($FileHash) {$psObjBody.criteria | Add-Member -Name "process_sha256" -Value @($FileHash) -MemberType NoteProperty}
        if ($Reputation) {$psObjBody.criteria | Add-Member -Name "reputation" -Value @($Reputation) -MemberType NoteProperty}
        if ($Tag) {$psObjBody.criteria | Add-Member -Name "tag" -Value @($Tag) -MemberType NoteProperty}
        if ($TargetValue) {$psObjBody.criteria | Add-Member -Name "target_value" -Value @($TargetValue) -MemberType NoteProperty}
        if ($Username) {$psObjBody.criteria | Add-Member -Name "device_username" -Value @($Username) -MemberType NoteProperty}
        if ($Type) {$psObjBody.criteria | Add-Member -Name "type" -Value @($Type) -MemberType NoteProperty}
        if ($Workflow) {$psObjBody.criteria | Add-Member -Name "workflow" -Value @($Workflow) -MemberType NoteProperty}
        if ($PolicyID) {$psObjBody.criteria | Add-Member -Name "policy_id" -Value @($PolicyID) -MemberType NoteProperty}
        if ($ThreatID) {$psObjBody.criteria | Add-Member -Name "threat_id" -Value @($ThreatID) -MemberType NoteProperty}
    }

    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/alerts/workflow/_criteria"
        Method     = "Post"
        Body       = $jsonBody
    }

    $result = Invoke-CbMethod @Parameters
    $result

}
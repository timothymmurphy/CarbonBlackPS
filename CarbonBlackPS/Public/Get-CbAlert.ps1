<#
    .SYNOPSIS
    Search alerts within Carbon Black. 
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/alerts-api/#alert-search
    
    .PARAMETER Search
    Query in lucene syntax and/or including value searches
    
    .PARAMETER Rows
    Maximum number of rows to return
    
    .PARAMETER Start
    Row to begin returning results from
    
    .PARAMETER SortField
    Field to sort results on. Must be used in conjunction with -SortOrder parameter
  
    .PARAMETER SortOrder
    Specifies ascending or descending order for sorting
  
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

    .PARAMETER SensorID
    Search criteria for sensor ID

    .PARAMETER PolicyID
    Search criteria for policy ID

    .PARAMETER ThreatID
    Search criteria for threat ID

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
   
    .EXAMPLE
    Get-CbAlert -Search "Query"
   
    .EXAMPLE
    Get-CbAlert -OperatingSystem "Linux" -MinimumSeverity 3 -SortField "last_event_time" -SortOrder "asc" -PolicyID 12345
    
    Returns results for all alerts for Linux machines in a given policy with a minimum severity of 3, sorted in ascending order by last event time.
#>

function Get-CbAlert {
    param (
        [string]$Search,

        [int]$Rows,

        [int]$Start,

        [ValidateSet("first_event_time", "last_event_time", "create_time", "last_update_time", "severity", "target_value")]
        [string]$SortField,

        [ValidateSet("ASC", "DESC")]
        [string]$SortOrder,

        [string]$ComputerName,

        [ValidateSet("WINDOWS", "MAC", "LINUX", "OTHER")]
        [string]$OperatingSystem,

        [string]$OperatingSystemVersion,

        [switch]$GroupResults,

        [string]$AlertID,

        [string]$LegacyAlertID,

        [int]$MinimumSeverity,

        [int]$SensorID,

        [int]$PolicyID,

        [string]$ThreatID,

        [string]$PolicyName,

        [string]$ProcessName,

        [string]$FileHash,

        [string]$Reputation,

        [string]$Tag,

        [ValidateSet("LOW", "MEDIUM", "HIGH", "MISSION_CRITICAL")]
        [string]$TargetValue,

        [string]$Username,

        [string]$Type,

        [string]$Workflow
    )

    $jsonBody = "{
        
    }"

    $psObjBody = $jsonBody |  ConvertFrom-Json    

    if ($Search) {$psObjBody | Add-Member -Name "query" -Value $Search -MemberType NoteProperty}
    if ($Rows) {$psObjBody | Add-Member -Name "rows" -Value $Rows -MemberType NoteProperty}
    if ($Start) {$psObjBody | Add-Member -Name "start" -Value $Start -MemberType NoteProperty}
    if ($SortField -or $SortOrder) {
        $psObjBody | Add-Member -Name "sort" -Value @([PSCustomObject]@{}) -MemberType NoteProperty

        if ($SortOrder) {$psObjBody.sort | Add-Member -Name "order" -Value $SortOrder -MemberType NoteProperty}
        if ($SortField) {$psObjBody.sort | Add-Member -Name "field" -Value $SortField -MemberType NoteProperty}
    }
    if ($ComputerName -or $OperatingSystem -or $OperatingSystemVersion -or $GroupResults -or $AlertID -or $LegacyAlertID -or $MinimumSeverity -or $SensorID -or $PolicyID -or $ThreatID -or $PolicyName -or $ProcessName -or $FileHash -or $Reputation -or $Tag -or $TargetValue -or $Username -or $Type -or $Workflow) {
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
        if ($SensorID) {$psObjBody.criteria | Add-Member -Name "device_id" -Value @($SensorID) -MemberType NoteProperty}
        if ($PolicyID) {$psObjBody.criteria | Add-Member -Name "policy_id" -Value @($PolicyID) -MemberType NoteProperty}
        if ($ThreatID) {$psObjBody.criteria | Add-Member -Name "threat_id" -Value @($ThreatID) -MemberType NoteProperty}
        if ($PolicyName) {$psObjBody.criteria | Add-Member -Name "policy_name" -Value @($PolicyName) -MemberType NoteProperty}
        if ($ProcessName) {$psObjBody.criteria | Add-Member -Name "process_name" -Value @($ProcessName) -MemberType NoteProperty}
        if ($FileHash) {$psObjBody.criteria | Add-Member -Name "process_sha256" -Value @($FileHash) -MemberType NoteProperty}
        if ($Reputation) {$psObjBody.criteria | Add-Member -Name "reputation" -Value @($Reputation) -MemberType NoteProperty}
        if ($Tag) {$psObjBody.criteria | Add-Member -Name "tag" -Value @($Tag) -MemberType NoteProperty}
        if ($TargetValue) {$psObjBody.criteria | Add-Member -Name "target_value" -Value @($TargetValue) -MemberType NoteProperty}
        if ($Username) {$psObjBody.criteria | Add-Member -Name "device_username" -Value @($Username) -MemberType NoteProperty}
        if ($Type) {$psObjBody.criteria | Add-Member -Name "type" -Value @($Type) -MemberType NoteProperty}
        if ($Workflow) {$psObjBody.criteria | Add-Member -Name "workflow" -Value @($Workflow) -MemberType NoteProperty}
    }

    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/alerts/_search"
        Method     = "Post"
        Body       = $jsonBody
    }

    $result = Invoke-CbMethod @Parameters

    $result.results
}
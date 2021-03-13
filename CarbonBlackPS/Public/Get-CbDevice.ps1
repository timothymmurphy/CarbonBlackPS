<#
    .SYNOPSIS
    Search devices within Carbon Black. 
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/devices-api/#search-devices
    
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
  
    .PARAMETER ExcludeVersion
    Exclude certain version of the sensor from results. 
    Format: os:#.#.#.#; e.g. -ExcludeVersion windows:3.6.0.1979

    .PARAMETER VCenterUUID
    Search criteria for vCenter UUID 
    
    .PARAMETER VMUUID
    Search criteria for VM UUID 

    .PARAMETER DeploymentType
    Search criteria for sensor deployment type

    .PARAMETER TargetPriority
    Search criteria for target priority

    .PARAMETER SensorID
    Search criteria for sensor ID

    .PARAMETER PolicyID
    Search criteria for policy ID

    .PARAMETER ADGroupID
    Search criteria for AD group ID

    .PARAMETER OperatingSystem
    Search criteria for operating system

    .PARAMETER Status
    Search criteria for status
   
    .EXAMPLE
    Get-CbDevice -Search "Query"
   
    .EXAMPLE
    Get-CbDevice -OperatingSystem "Linux" -SortField "last_contact_time" -SortOrder "asc" -PolicyID linux:156249
    
    Returns results for all Linux machines in a given policy, sorted in ascending order by last contact time.
    
    .EXAMPLE
    Get-CbDevice -Search "Query" -ExcludeVersion "windows:3.6.0.1979"

    Returns results for all machines matching the search except for Windows machines running sensor version 3.6.0.1979
#>

function Get-CbDevice {
    param (
        [string]$Search,

        [int]$Rows,

        [int]$Start,

        [ValidateSet("target_priority", "policy_name", "name", "last_contact_time", "av_pack_version", "login_user_name", "os_version", "sensor_version", "vm_name", "esx_host_name", "cluster_name", "vm_ip", "vulnerability_severity", "vulnerability_score")]
        [string]$SortField,

        [ValidateSet("ASC", "DESC")]
        [string]$SortOrder,

        [string]$ExcludeVersion,

        [string]$VCenterUUID,

        [string]$VMUUID,

        [ValidateSet("ENDPOINT", "WORKLOAD")]
        [string]$DeploymentType,

        [ValidateSet("LOW", "MEDIUM", "HIGH", "MISSION_CRITICAL")]
        [string]$TargetPriority,

        [int]$SensorID,

        [int]$PolicyID,

        [int]$ADGroupID,

        [ValidateSet("WINDOWS", "MAC", "LINUX", "OTHER")]
        [string]$OperatingSystem,

        [ValidateSet("PENDING", "REGISTERED", "UNINSTALLED", "DEREGISTERED", "ACTIVE", "INACTIVE", "ERROR", "ALL", "BYPASS_ON", "BYPASS", "QUARANTINE", "SENSOR_OUTOFDATE", "DELETED", "LIVE")]
        [string]$Status

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
    if ($ExcludeVersion) {
        $psObjBody | Add-Member -Name "exclusions" -Value ([PSCustomObject]@{}) -MemberType NoteProperty
        $psObjBody.exclusions | Add-Member -Name "sensor_version" -Value @($ExcludeVersion) -MemberType NoteProperty
        
    }
    if ($VCenterUUID -or $VMUUID -or $DeploymentType -or $TargetPriority -or $SensorID -or $PolicyID -or $ADGroupID -or $OperatingSystem -or $Status) {
        $psObjBody | Add-Member -Name "criteria" -Value ([PSCustomObject]@{}) -MemberType NoteProperty

        if ($VCenterUUID) {$psObjBody.criteria | Add-Member -Name "vcenter_uuid" -Value @($VCenterUUID) -MemberType NoteProperty}
        if ($VMUUID) {$psObjBody.criteria | Add-Member -Name "vm_uuid" -Value @($VMUUID) -MemberType NoteProperty}
        if ($DeploymentType) {$psObjBody.criteria | Add-Member -Name "deployment_type" -Value @($DeploymentType) -MemberType NoteProperty}
        if ($TargetPriority) {$psObjBody.criteria | Add-Member -Name "target_priority" -Value @($TargetPriority) -MemberType NoteProperty}
        if ($SensorID) {$psObjBody.criteria | Add-Member -Name "id" -Value @($SensorID) -MemberType NoteProperty}
        if ($PolicyID) {$psObjBody.criteria | Add-Member -Name "policy_id" -Value @($PolicyID) -MemberType NoteProperty}
        if ($ADGroupID) {$psObjBody.criteria | Add-Member -Name "ad_group_id" -Value @($ADGroupID) -MemberType NoteProperty}
        if ($OperatingSystem) {$psObjBody.criteria | Add-Member -Name "os" -Value @($OperatingSystem) -MemberType NoteProperty}
        if ($Status) {$psObjBody.criteria | Add-Member -Name "status" -Value @($Status) -MemberType NoteProperty}
    }

    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/devices/_search"
        Method     = "Post"
        Body       = $jsonBody
    }

    $result = Invoke-CbMethod @Parameters

    $result.results
}
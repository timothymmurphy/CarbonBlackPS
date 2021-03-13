<#
    .SYNOPSIS
    Exports CSV of devices matching search.
    Official Carbon Black documentation: https://developer.carbonblack.com/reference/carbon-black-cloud/platform/latest/devices-api/#export-devices-csv
    
    .PARAMETER Search
    Device value search query string
    
    .PARAMETER SortField
    Field to sort results on. Must be used in conjunction with -SortOrder parameter
  
    .PARAMETER SortOrder
    Specifies ascending or descending order for sorting
  
    .PARAMETER DeploymentType
    The device's deployment type, a classification that is determined by its lifecycle management policy

    .PARAMETER TargetPriority
    Device target priorities to match

    .PARAMETER PolicyID
    Carbon Black Cloud Policy ID to match

    .PARAMETER ADGroupID
    Search criteria for AD group ID

    .PARAMETER Status
    Device statuses to match
   
    .EXAMPLE
    Get-CbDeviceExport -Status "ACTIVE" -FilePath "C:\Example\Path\export.csv"
#>

function Get-CbDeviceExport {
    param (

        [ValidateSet("target_priority", "policy_name", "name", "last_contact_time", "av_pack_version", "login_user_name", "os_version", "sensor_version", "vm_name", "esx_host_name", "cluster_name", "vm_ip", "vulnerability_severity", "vulnerability_score")]
        [string]$SortField,

        [ValidateSet("ASC", "DESC")]
        [string]$SortOrder,

        [ValidateSet("ENDPOINT", "WORKLOAD")]
        [string]$DeploymentType,

        [ValidateSet("LOW", "MEDIUM", "HIGH", "MISSION_CRITICAL")]
        [string]$TargetPriority,

        [string]$Search,

        [int]$PolicyID,

        [int]$ADGroupID,

        [Parameter(Mandatory=$true)]
        [ValidateSet("PENDING", "REGISTERED", "UNINSTALLED", "DEREGISTERED", "ACTIVE", "INACTIVE", "ERROR", "ALL", "BYPASS_ON", "BYPASS", "QUARANTINE", "SENSOR_OUTOFDATE", "DELETED", "LIVE")]
        [string]$Status,

        [Parameter(Mandatory=$true)]
        [string]$FilePath

    )

    $queryString = "?status=$Status"

    if ($SortField) {$queryString += "?sort_field=$SortField"}
    if ($SortOrder) {$queryString += "?sort_order=$SortOrder"}
    if ($DeploymentType) {$queryString += "?deployment_type=$DeploymentType"}
    if ($TargetPriority) {$queryString += "?target_priority=$TargetPriority"}
    if ($Search) {$queryString += "?query_string=$Search"}
    if ($PolicyID) {$queryString += "?policy_id=$PolicyID"}
    if ($ADGroupID) {$queryString += "?ad_group_id=$ADGroupID"}

    $Parameters = @{
        UriPreOrgKey  = "/appservices/v6/orgs/"
        UriPostOrgKey = "/devices/_search/download$($queryString)"
        Method     = "Get"
    }

    $result = Invoke-CbMethod @Parameters

    $result | Out-File -FilePath $FilePath
}
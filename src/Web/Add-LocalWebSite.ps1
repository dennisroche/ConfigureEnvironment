function Add-LocalWebSite {
    param (
        $WebSiteName,
        $WebSiteLocation,
        $HostName,
        $AppPool
    )

    Write-Host "Configuring Local WebSite"
    $PSBoundParameters | ConvertTo-Json

    Add-LocalhostDnsEntryToHostsFile @PSBoundParameters
    Add-WebSite @PSBoundParameters
}
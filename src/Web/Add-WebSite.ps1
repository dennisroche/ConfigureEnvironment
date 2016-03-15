function Add-WebSite {
    param (
        [string]$WebSiteName,
        [string]$WebSiteLocation,
        [string]$HostName,
        [string]$AppPool,
        [switch]$UseSSL,
        [string]$EnableAnonymousAuthentication,
        [string]$EnableWindowsAuthentication,
        [string]$UsingLocalDb
    )

    $PSBoundParameters | ConvertTo-Json

    Write-Host "Adding '$WebSiteName' to IIS at '$HostName' " -NoNewline

    if (-Not (Test-Path $WebSiteLocation)) {
        New-Item $WebSiteLocation -ItemType Directory -ErrorAction Stop | Out-Null
    }

    if (-Not (Test-Path "$WebSiteLocation\*")) {
        Copy-Item -Path "C:\inetpub\wwwroot\*.*" -Destination $WebSiteLocation -ErrorAction Continue | Out-Null
    }

    if ($EnableAnonymousAuthentication -eq '') {
        $EnableAnonymousAuthentication = 'false'
    }

    if ($EnableWindowsAuthentication -eq '') {
        $EnableWindowsAuthentication = 'false'
    }

    $AppCmd = "$env:WinDir\system32\inetsrv\AppCmd.exe"

    # Set up IIS site / app pool
    & $AppCmd add apppool /name:$AppPool /managedRuntimeVersion:v4.0 /managedPipelineMode:Integrated | %{ Write-Verbose "[AppCmd] $_" }
    & $AppCmd set config /section:applicationPools "/[name='$AppPool'].processModel.identityType:NetworkService" | %{ Write-Verbose "[AppCmd] $_" }
    & $AppCmd add site /name:"$WebSiteName" /physicalPath:$WebSiteLocation /bindings:http/*:80:$HostName | %{ Write-Verbose "[AppCmd] $_" }
    & $AppCmd set app "$WebSiteName/" /applicationPool:"$AppPool" | %{ Write-Verbose "[AppCmd] $_" }

    if ([boolean]$UsingLocalDb) {
        # LocalDB requires identityType:LocalSystem
        & $AppCmd set config /section:applicationPools "/[name='$AppPool'].processModel.identityType:LocalSystem" | %{ Write-Verbose "[AppCmd] $_" }
    }

    # Change anonymous identity to auth as app-pool identity instead of IUSR_...
    & $AppCmd set config /section:anonymousAuthentication /username:"" --password | %{ Write-Verbose "[AppCmd] $_" }
    
    # Set Authentication
    & $AppCmd set config "$WebSiteName" /section:anonymousAuthentication /enabled:$AllowAnonymous /commit:apphost | %{ Write-Verbose "[AppCmd] $_" }
    & $AppCmd set config "$WebSiteName" /section:windowsAuthentication /enabled:$AllowWindows /commit:apphost | %{ Write-Verbose "[AppCmd] $_" }

    if ($UseSSL) {
        # If you want to add HTTPS (but you need an appropriate SSL cert installed)
        & $AppCmd set site /site.name $WebSiteName "/+bindings.[protocol='https',bindingInformation='*:443:{LOCAL_APP_DOMAIN_NAME}']" | %{ Write-Verbose "[AppCmd] $_" }
    }

    if ($WebSiteLocation -ne '') {
        # Give Network Service permission to read the site files
        & icacls "$WebSiteLocation" /inheritance:e /T /grant """NETWORK SERVICE:(OI)(CI)F""" | Out-Null
    }

    Write-Host "[Done]" -ForegroundColor Green
}
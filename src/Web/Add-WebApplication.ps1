function Add-WebApplication {
    param (
        [string]$WebApplicationName,
        [string]$WebApplicationLocation,
        [string]$HostName,
        [string]$AppPool,
        [string]$ParentSite,
        [string]$EnableAnonymousAuthentication,
        [string]$EnableWindowsAuthentication
    )

    $PSBoundParameters | ConvertTo-Json

    Write-Host "Adding '$WebApplicationName' as Application to parent '$ParentSite' " -NoNewline

    if ($WebApplicationLocation -ne '') {
        if (-Not (Test-Path $WebApplicationLocation)) {
            New-Item $WebApplicationLocation -ItemType Directory -ErrorAction Stop | Out-Null
        }
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
    & $AppCmd add app /site.name:"$ParentSite" /path:/"$WebApplicationName" /physicalPath:$WebApplicationLocation | %{ Write-Verbose "[AppCmd] $_" }
    & $AppCmd set app /app.name:"$ParentSite/$WebApplicationName" /applicationPool:"$AppPool" | %{ Write-Verbose "[AppCmd] $_" }

    # Change anonymous identity to auth as app-pool identity instead of IUSR_...
    & $AppCmd set config "$ParentSite/$WebApplicationName" /section:anonymousAuthentication /username:"" --password | %{ Write-Verbose "[AppCmd] $_" }

    # Set Authentication
    & $AppCmd set config "$ParentSite/$WebApplicationName" /section:anonymousAuthentication /enabled:$EnableAnonymousAuthentication /commit:apphost | %{ Write-Verbose "[AppCmd] $_" }
    & $AppCmd set config "$ParentSite/$WebApplicationName" /section:windowsAuthentication /enabled:$EnableWindowsAuthentication /commit:apphost | %{ Write-Verbose "[AppCmd] $_" }

    # # Give Network Service permission to read the site files
    & icacls "$WebApplicationLocation" /inheritance:e /T /grant """NETWORK SERVICE:(OI)(CI)F""" | Out-Null

    Write-Host "[Done]" -ForegroundColor Green
}
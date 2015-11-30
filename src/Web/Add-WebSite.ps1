function Add-WebSite {
    param (
        [parameter(Mandatory)][string]
        $WebSiteName,
        [parameter(Mandatory)][string]
        $WebSiteLocation,
        [parameter(Mandatory)][string]
        $HostName,
        [parameter(Mandatory)][string]
        $AppPool,
        [parameter()][switch]
        $UseSSL
    )

    Write-Host "Adding '$WebSiteName' to IIS at '$HostName' " -NoNewline

    if (-Not (Test-Path $WebSiteLocation)) {
        New-Item $WebSiteLocation -ItemType Directory -ErrorAction Stop | Out-Null
    }

    $AppCmd = "$env:WinDir\system32\inetsrv\AppCmd.exe"

    # Set up IIS site / app pool
    & $AppCmd add apppool /name:$AppPool /managedRuntimeVersion:v4.0 /managedPipelineMode:Integrated | %{ Write-Verbose "[AppCmd] $_" }
    & $AppCmd set config /section:applicationPools "/[name='$AppPool'].processModel.identityType:NetworkService" | %{ Write-Verbose "[AppCmd] $_" }
    & $AppCmd add site /name:"$WebSiteName" /physicalPath:$WebSiteLocation /bindings:http/*:80:$HostName | %{ Write-Verbose "[AppCmd] $_" }
    & $AppCmd set app "$WebSiteName/" /applicationPool:"$AppPool" | %{ Write-Verbose "[AppCmd] $_" }

    # Enable Windows Authenication
    & $AppCmd set config "$WebSiteName" /section:windowsAuthentication /enabled:true /commit:apphost | %{ Write-Verbose "[AppCmd] $_" }

    if ($UseSSL) {
        # If you want to add HTTPS (but you need an appropriate SSL cert installed)
        & $AppCmd set site /site.name $WebSiteName "/+bindings.[protocol='https',bindingInformation='*:443:{LOCAL_APP_DOMAIN_NAME}']" | %{ Write-Verbose "[AppCmd] $_" }
    }

    # Change anonymous identity to auth as app-pool identity instead of IUSR_...
    & $AppCmd set config /section:anonymousAuthentication /username:"" --password | %{ Write-Verbose "[AppCmd] $_" }

    # Give Network Service permission to read the site files
    & icacls "$WebSiteLocation" /inheritance:e /T /grant """NETWORK SERVICE:(OI)(CI)F""" | %{ Write-Verbose "[Icacls] $_" }

    Write-Host "[Done]" -ForegroundColor Green
}
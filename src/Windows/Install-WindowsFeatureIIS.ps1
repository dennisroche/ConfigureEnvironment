#
# Install Internet Information Services
#
function Install-WindowsFeatureIIS {

    Write-Host "Checking Internet Information Services (IIS) " -NoNewline

    Write-Host "[Installing]" -ForegroundColor Yellow
    Write-Host "Installing Internet Information Services (IIS) " -NoNewline

    $Dism = "$Env:WinDir\Sysnative\dism.exe"
    if (-Not (Test-Path $Dism)) {
        $Dism = "dism.exe"
    }

    & $Dism /Online /English /LogLevel:4 /Enable-Feature /All /FeatureName:IIS-ApplicationDevelopment /FeatureName:IIS-ASPNET /FeatureName:IIS-ASPNET45 /FeatureName:IIS-BasicAuthentication /FeatureName:IIS-WindowsAuthentication /featurename:IIS-ManagementConsole | %{ Write-Host "[DISM] $_" }

    Write-Host "[Done]" -ForegroundColor Green
}
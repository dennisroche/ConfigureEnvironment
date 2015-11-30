#
# Install Internet Information Services
#
function Install-WindowsFeatureIIS {

    Write-Host "Checking Internet Information Services (IIS) " -NoNewline

    If (Test-Path 'HKLM:\SOFTWARE\Microsoft\InetStp') {
        Write-Host "Installed" -ForegroundColor Green
        Return
    }

    Write-Host "[Installing]" -ForegroundColor Yellow

    Write-Host "Installing Internet Information Services (IIS) " -NoNewline
    $Dism = "$Env:WinDir\Sysnative\dism.exe"
    & $Dism /Online /English /LogLevel:4 /Enable-Feature /All /FeatureName:IIS-ApplicationDevelopment /FeatureName:IIS-ASPNET /FeatureName:IIS-ASPNET45 /FeatureName:IIS-WindowsAuthentication | %{ Write-Verbose "[DISM] $_" }

    Write-Host "[Done]" -ForegroundColor Green
}
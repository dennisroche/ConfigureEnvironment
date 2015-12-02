
function Invoke-ConfigureWebEnvironment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ScriptBlock]$ConfigureScript
    )

    if (-Not (Test-IsAdmin)) {
        Write-Warning "Local Administrator privileges are required as need to add DNS entry to Hosts, exiting"
        Exit 1
    }

    try {
        # Ensure Internet Information Service is installed
        Install-WindowsFeatureIIS
        Set-DisableLoopbackCheck

        &$ConfigureScript $SolutionRoot

        Write-Host
        Write-Host -ForegroundColor Green "Success!"
    } finally {
    }
}
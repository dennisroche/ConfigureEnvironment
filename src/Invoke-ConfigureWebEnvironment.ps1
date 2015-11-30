
function Invoke-ConfigureWebEnvironment {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullorEmpty()]
        [ValidateScript({ Test-Path $_ })]
        [string]$SolutionRoot,

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

        &$ConfigureScript $SolutionRoot

        Write-Host
        Write-Host -ForegroundColor Green "Success!"
    } finally {

    }
}
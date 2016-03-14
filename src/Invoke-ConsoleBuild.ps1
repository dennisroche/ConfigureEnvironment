
function Invoke-ConsoleApplication {
    [CmdletBinding()]
    param(
        [string]$ProjectPath,

        [string]$SolutionDir,

        [Parameter(Mandatory)]
        [ScriptBlock]$ConfigureScript
    )

    try {
        $PathToExecutable = Invoke-MsBuild -ProjectPath $ProjectPath -SolutionDir $SolutionDir

        Push-Location (Get-Item $PathToExecutable).Directory
        &$ConfigureScript $PathToExecutable

        Write-Host
        Write-Host -ForegroundColor Green "Success!"
    } finally {
        Pop-Location
    }
}
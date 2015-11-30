[CmdletBinding()]
param()

# Error handling
$ErrorActionPreference = "Stop"
trap
{
    Pop-Location
    $Host.UI.WriteErrorLine($_)
    Exit 1
}

# Include scripts
Get-ChildItem $PSScriptRoot -Recurse -Include *.ps1 -Exclude 'ConfigureEnvironment.ps1' | %{ . $_.FullName }
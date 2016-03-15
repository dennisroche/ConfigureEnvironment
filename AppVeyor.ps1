[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
trap {
    Write-Error $_
    Exit 1
}

$ModuleName = $env:ModuleName
$SourceFolder = $env:SourceFolder
$BuildNumber = $env:APPVEYOR_BUILD_NUMBER

# Add APPVEYOR_BUILD_FOLDER to modules path to enable discovery
$env:psmodulepath = $env:psmodulepath + ";" + $env:APPVEYOR_BUILD_FOLDER

# Use PSScriptAnalyzer to static analyse PS1 https://github.com/powershell/psscriptanalyzer
Import-Module -Name PSScriptAnalyzer -Force

# Rules
$analysePath = Join-Path $env:APPVEYOR_BUILD_FOLDER $SourceFolder

Write-Output "Invoke-ScriptAnalyzer -Path "$analysePath" -IncludeRule $rules.RuleName -Recurse"
$errorRules = Get-ScriptAnalyzerRule -Severity Error
$errors = Invoke-ScriptAnalyzer -Path "$analysePath" -IncludeRule $errorRules.RuleName -Recurse
$errors

if ($errors.Count -gt 0) {
    Write-Warning "Analysis of ModuleName resulted $($errors.Count) errors"
    Exit 1
}
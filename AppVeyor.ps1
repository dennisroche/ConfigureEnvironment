[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
trap {
    Write-Error $_
    Exit 1
}

$ModuleName = $env:ModuleName
$PublishingNugetKey = $env:nugetKey
$Psd1Path = "./$ModuleName.psd1"
$BuildNumber = $env:APPVEYOR_BUILD_NUMBER

# Use PSScriptAnalyzer to static analyse PS1 https://github.com/powershell/psscriptanalyzer
Import-Module -Name PSScriptAnalyzer -Force -Verbose

# Rules
Write-Output 'Invoke-ScriptAnalyzer -Path "$($env:APPVEYOR_BUILD_FOLDER)" -IncludeRule $rules.RuleName -Recurse'
$rules = Get-ScriptAnalyzerRule -Severity Warning,Error
$results = Invoke-ScriptAnalyzer -Path "$($env:APPVEYOR_BUILD_FOLDER)" -IncludeRule $rules.RuleName -Recurse
$results

if ($results.Count -gt 0) {
     Write-Host "Analysis of ModuleName resulted $($results.Count) warnings or errors"
     Exit 1
}
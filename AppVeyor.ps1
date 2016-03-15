[CmdletBinding()]
param()

$ModuleName = $env:ModuleName
$ModuleLocation = $env:APPVEYOR_BUILD_FOLDER
$PublishingNugetKey = $env:nugetKey
$Psd1Path = "./$ModuleName.psd1"
$BuildNumber = $env:APPVEYOR_BUILD_NUMBER

$ErrorActionPreference = "Stop"
trap {
    Write-Error $_
    Exit 1
}

# Use PSScriptAnalyzer to static analyse code https://github.com/powershell/psscriptanalyzer
Import-Module -Name PSScriptAnalyzer

$rules = Get-ScriptAnalyzerRule -Severity Warning,Error
$results = Invoke-ScriptAnalyzer -Path "C:\Program Files\WindowsPowerShell\Modules\$ModuleName" -IncludeRule $rules.RuleName -Recurse
$results

if ($results.Count -gt 0) {
     Write-Host "Analysis of ModuleName resulted $($results.Count) warnings or errors"
     Exit 1
}
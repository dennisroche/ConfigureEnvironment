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

# Add APPVEYOR_BUILD_FOLDER to modules path to enable discovery 
$env:psmodulepath = $env:psmodulepath + ";" + $env:APPVEYOR_BUILD_FOLDER

# Use PSScriptAnalyzer to static analyse PS1 https://github.com/powershell/psscriptanalyzer
Import-Module -Name PSScriptAnalyzer -Force

# Rules
$rules = Get-ScriptAnalyzerRule -Severity Warning,Error
$results = Invoke-ScriptAnalyzer -Path "C:\Program Files\WindowsPowerShell\Modules\$ModuleName" -IncludeRule $rules.RuleName -Recurse
$results

if ($results.Count -gt 0) {
     Write-Host "Analysis of ModuleName resulted $($results.Count) warnings or errors"
     Exit 1
}
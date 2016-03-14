@{
    ModuleVersion = '0.1.1.0'
    GUID = '0EA32B45-828F-466B-A2B9-4B2FBDF1B281'
    Author = 'Dennis Roche'
    Description = 'A PowerShell module that bootstraps your development environment, configurable with a terse scripts'
    PowerShellVersion = '4.0'
    CLRVersion = '4.0'
    DotNetFrameworkVersion = '4.5'
    ScriptsToProcess = @('ConfigureEnvironment.ps1')
    FunctionsToExport = 'Invoke-Configure*', 'Invoke-ConsoleApplication', 'Add-LocalWebSite', 'Add-WebApplication', 'Add-LocalhostDnsEntryToHostsFile'
}
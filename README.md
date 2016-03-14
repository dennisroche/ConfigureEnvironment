# Configure Environment [![Build status](https://ci.appveyor.com/api/projects/status/o59sxa1tscs5f69s/branch/master?svg=true)](https://ci.appveyor.com/project/dennisroche/configureenvironment/branch/master)

A PowerShell module that bootstraps your development environment to use Internet Information Servies (IIS), configurable with a terse script

**Example**

As a WebSite

```ps1
# Setup Environment
$BasePath = Resolve-Path "$PSScriptRoot\.."

Invoke-ConfigureWebEnvironment {

    $Website = @{
        HostName = "mysite.yourcompany.local"
        WebSiteName = "MyWebsite"
        WebSiteLocation = "$BasePath\src\MySite.Web"
        AppPool = "MyWebsite Local"
    }
    Add-WebSite @Website
    Add-LocalhostDnsEntryToHostsFile $($Website.HostName)
}
```

As a Web Application (includes parent site)

```ps1
# Setup Environment
$BasePath = Resolve-Path "$PSScriptRoot\.."

Invoke-ConfigureWebEnvironment {

    $ApiLocal = @{
        HostName = "api-local.yourcompany.local"
        WebSiteName = "API Local"
        WebSiteLocation = "C:\inetpub\api-local"
        AppPool = "API Local"
    }
    Add-WebSite @ApiLocal
    Add-LocalhostDnsEntryToHostsFile $($ApiLocal.HostName)

    $ServiceApi = @{
        WebApplicationName = "Service"
        WebApplicationLocation = "$BasePath\src\Service.WebApi"
        AppPool = "API Local Service"
        ParentSite = "$($ApiLocal.WebSiteName)"
        EnableAnonymousAuthentication = "true"
        EnableWindowsAuthentication = "true"
    }
    Add-WebApplication @ServiceApi
}
```

If you need the script to self bootstrap, then add the following to the top.

```ps1
if (-Not (Get-Module -ListAvailable -Name ConfigureEnvironment)) {
    iex ((New-Object net.webclient).DownloadString('https://raw.githubusercontent.com/dennisroche/ConfigureEnvironment/master/Install.ps1'))
}

Import-Module ConfigureEnvironment -Force
```

Installation
=============


### Manual Install

Download [ConfigureEnvironment.zip](https://github.com/dennisroche/ConfigureEnvironment/releases/download/latest/ConfigureEnvironment.zip). 
Extract the contents into `C:\Users\[User]\Documents\WindowsPowerShell\modules\ConfigureEnvironment` or a location relative to your project.


### Scripted Install

Open a PowerShell console or the PowerShell ISE and run the following:

```ps1
iex ((New-Object net.webclient).DownloadString('https://raw.githubusercontent.com/dennisroche/ConfigureEnvironment/master/Install.ps1'))
```

This will download the latest release from GitHub and unpack it in your PowerShell modules directory.

To run the above script, `Execution Policy` should be set to at least Bypass. See [about_Execution_Policies](https://technet.microsoft.com/en-us/library/hh847748.aspx) for more details.


### PowerShell Gallery Install (Requires PowerShell v5)

```ps1
Save-Module -Name ConfigureEnvironment -Path <path>
```

```ps1
Install-Module -Name ConfigureEnvironment
```

_See the [PowerShell Gallery](http://www.powershellgallery.com/packages/ConfigureEnvironment/) for the complete details and instructions._


#### Autorun in Visual Studio

Want to automatically execute the environment script on project load in Visual Studio 2015? 

This can be achieved using a combination of a DNX Project (i.e. new project.json format) and the Task Runner Explorer. 

1. Create a DNX project (see included Example)
2. Install the [ASP.NET 5 Scripts Task Runner](https://visualstudiogallery.msdn.microsoft.com/9397a2da-c93a-419c-8408-4e9af30d4e36) by [Mads Kristensen](https://visualstudiogallery.msdn.microsoft.com/site/search?f%5B0%5D.Type=User&f%5B0%5D.Value=Mads%20Kristensen) to enable DNX Script discovery
3. Add a DNX Script to the `project.json`

Once you have DNX Scripts, you can use "Task Runner Explorer" `View > Other Windows > Task Runner Explorer` to bind a script to run at project load.

# ConfigureEnvironment

A PowerShell module that bootstraps your development environment to use Internet Information Servies (IIS), configurable with a terse script

**Example**

    Push-Location $PSScriptRoot
    Import-Module .\ConfigureEnvironment\ConfigureEnvironment.psd1 -Force

    Invoke-ConfigureWebEnvironment (Resolve-Path "$PSScriptRoot\..") {
        param (
            [string]$Solution
        )

        $ServiceLocatorApi = @{
            HostName = "webapp.local.company.com"
            WebSiteName = "WebApp"
            WebSiteLocation = "$Solution\src\WebApp"
            AppPool = "DefaultAppPool"
        }
    }


Installation
=============


### Manual Install

Download [ConfigureEnvironment.zip](https://github.com/dennisroche/ConfigureEnvironment/releases/download/v0.1-alpha/ConfigureEnvironment.zip). 
Extract the contents into `C:\Users\[User]\Documents\WindowsPowerShell\modules\ConfigureEnvironment` or a location relative to your project.


### Scripted Install

Open a PowerShell console or the PowerShell ISE and run the following:

```
iex ((New-Object net.webclient).DownloadString('https://raw.githubusercontent.com/dennisroche/ConfigureEnvironment/master/install.ps1'))
```

This will download the latest release from GitHub and unpack it in your PowerShell modules directory.

To run the above script, `Execution Policy` should be set to at least Bypass. See [about_Execution_Policies](https://technet.microsoft.com/en-us/library/hh847748.aspx) for more details.


### PowerShell Gallery Install (Requires PowerShell v5)

```
Save-Module -Name ConfigureEnvironment -Path <path>
```

```
Install-Module -Name ConfigureEnvironment
```

_See the [PowerShell Gallery](http://www.powershellgallery.com/packages/ConfigureEnvironment/) for the complete details and instructions._


#### Autorun

To automatically execute the environment script on project load install the [Command Task Runner by Mads Kristensen](https://visualstudiogallery.msdn.microsoft.com/e6bf6a3d-7411-4494-8a1e-28c1a8c4ce99).
# ConfigureEnvironment

A PowerShell module that bootstraps your development environment to use Internet Information Servies (IIS), configurable with a terse script




How to use
=============


### Manual Install

Download [ConfigureEnvironment.zip](https://github.com/dennisroche/ConfigureEnvironment/releases/download/Latest/ConfigureEnvironment.zip) and extract the contents into `C:\Users\[User]\Documents\WindowsPowerShell\modules\ConfigureEnvironment`

_Create these directories if they don't exist_

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
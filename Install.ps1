# Error handling
$ErrorActionPreference = "Stop"

trap
{
    Pop-Location
    $Host.UI.WriteErrorLine($_)
    Exit 1
}

# Install-ModuleFromGitHub
function Install-ModuleFromGitHub {
    param (
        [parameter(Mandatory)][string]
        $GitHubUser,
        [parameter(Mandatory)][string]
        $Project
    )

    try 
    {
        $Url = "https://github.com/$GitHubUser/$Project/releases/download/Latest/$Project.zip"
        $InstallPath = Join-Path -Path (Split-Path -Path $Profile) -ChildPath "\Modules\$Project"

        if (!(Test-Path -Path $InstallPath)) {
            New-Item -Path $InstallPath -ItemType Directory | Out-Null
        }

        $DownloadPath = Join-Path -Path $InstallPath -ChildPath "$Project.zip"
        Invoke-WebRequest -Uri $Url -OutFile $DownloadPath
        Expand-Archive -Path $DownloadPath -DestinationPath $InstallPath
    }
    finally 
    {
        Remove-Item -Path $DownloadPath
    }
}

Install-ModuleFromGitHub -GitHubUser 'dennisroche' -Project 'ConfigureEnvironment'
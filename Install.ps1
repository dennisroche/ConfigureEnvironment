#Requires -Version 4.0
$ErrorActionPreference = "Stop"

trap
{
    Pop-Location
    $Host.UI.WriteErrorLine($_)
}

# Install-ModuleFromGitHub
function Install-ModuleFromGitHub {
    param (
        [parameter(Mandatory)][string]
        $GitHubUser,
        [parameter(Mandatory)][string]
        $Project
    )

    function Expand-Zip {
        param (
            [Parameter(Position=0, Mandatory)]
            [ValidateNotNullorEmpty()]
            [ValidateScript({ Test-Path $_ })]
            [ValidatePattern("\.zip$")]
            [string]$Path,

            [Parameter(Position=1, Mandatory)]
            [ValidateNotNullorEmpty()]
            [string]$DestinationPath
        )

        New-Item -ItemType Directory -Force -Path $DestinationPath | Out-Null
        [System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') | Out-Null
        [System.IO.Compression.ZipFile]::ExtractToDirectory((Resolve-Path $Path), (Resolve-Path $DestinationPath))
    }

    try 
    {
    	# Note: you need to tag the release with `latest' for this to work
        $Url = "https://github.com/$GitHubUser/$Project/releases/download/latest/$Project.zip"
        $InstallPath = Join-Path -Path (Split-Path -Path $Profile) -ChildPath "\Modules\$Project"

        if ((Test-Path -Path $InstallPath)) {
            Remove-Item -Path $InstallPath -Recurse -Force | Out-Null
        } else {
            New-Item -Path $InstallPath -ItemType Directory | Out-Null
        }

        $DownloadPath = "$env:temp\$Project.zip"
        $ExtractPath = "$env:temp\$([guid]::NewGuid().ToString())"

        Invoke-WebRequest -Uri $Url -OutFile $DownloadPath
        Expand-Zip -Path $DownloadPath -DestinationPath $ExtractPath
        
        Copy-Item $ExtractPath -Destination $InstallPath -Recurse
        Write-Host -ForegroundColor Green "Successfully installed $Project to '$InstallPath'"
    }
    finally 
    {
        Remove-Item -Path $ExtractPath -Recurse -Force | Out-Null
        Remove-Item -Path $DownloadPath | Out-Null
    }
}

Install-ModuleFromGitHub -GitHubUser 'dennisroche' -Project 'ConfigureEnvironment'
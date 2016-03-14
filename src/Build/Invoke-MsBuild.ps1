function Invoke-MsBuild {
    param (
        [parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ })]
        [ValidatePattern("\.csproj$")]
        [string]$ProjectPath,

        [parameter()][string]
        $Configuration ="Release",

        [parameter()][string]
        $Platform = "AnyCpu",
        
        [parameter()]
        [ValidateScript({ Test-Path $_ })]
        [ValidatePattern("\\$")]
        [string]$SolutionDir

    )

    function Get-MsBuildPath
    {
        # Get the path to the directory that the latest version of MSBuild is in
        $MsBuildToolsVersionsStrings = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\MSBuild\ToolsVersions\' | Where-Object { $_ -match '[0-9]+\.[0-9]' } | Select-Object -ExpandProperty PsChildName
        $MsBuildToolsVersions = $MsBuildToolsVersionsStrings | ForEach-Object { [Convert]::ToDouble($_) }
        $LargestMsBuildToolsVersion = $MsBuildToolsVersions | Sort-Object -Descending | Select-Object -First 1 
        $MsBuildToolsVersionsKeyToUse = Get-Item -Path ('HKLM:\SOFTWARE\Microsoft\MSBuild\ToolsVersions\{0:n1}' -f $LargestMsBuildToolsVersion)
        $MsBuildDirectoryPath = $MsBuildToolsVersionsKeyToUse | Get-ItemProperty -Name 'MSBuildToolsPath' | Select -ExpandProperty 'MSBuildToolsPath'

        $MsBuildPath = (Join-Path -Path $MsBuildDirectoryPath -ChildPath 'msbuild.exe')
        if(-Not (Test-Path $MsBuildPath -PathType Leaf))
        {
            throw 'MsBuild.exe was not found on the system'
        }

        Return $MsBuildPath
    }

    Write-Host "Rebuilding project '$ProjectPath' as $Configuration|$Platform " -NoNewline

    $MSBuild = Get-MsBuildPath
    & "$MSBuild" $ProjectPath /t:Build /p:Configuration=$Configuration /p:Platform=$Platform /p:SolutionDir=$SolutionDir /verbosity:normal | %{ Write-Verbose "[MSBuild] $_" }
    if ($LastExitCode -eq 0) {
        Write-Host "[Done]" -ForegroundColor Green

        $Item = Get-Item $ProjectPath
        Return "$($Item.Directory)\bin\$Configuration\$($Item.BaseName).exe"
    } else {
        Write-Host "[Failed]" -ForegroundColor Red
        Throw "Failed to build project '$ProjectPath'"
    }
}
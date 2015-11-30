function Add-LocalhostDnsEntryToHostsFile {
    param (
        $HostName,
        $WebSiteName
    )

    Add-DnsEntryToHostsFile -IpAddress 127.0.0.1 -HostName $HostName -Comment "Local IIS Entry for $WebSiteName"
}

function Add-DnsEntryToHostsFile {
    param (
        [parameter(Mandatory)][string]
        $IPAddress,
        [parameter(Mandatory)][string]
        $HostName,
        [parameter(Mandatory)][string]
        $Comment
    )

    $HostsLocation = "$env:windir\System32\drivers\etc\hosts"
    $NewHostEntry = "$IPAddress $HostName #$Comment"

    Write-Host "Adding '$NewHostEntry' to hosts file " -NoNewline

    if ((Get-Content $HostsLocation) -contains $NewHostEntry) {
        Write-Host "[Already Exists]" -ForegroundColor Green
        Return
    }

    Add-Content -Path $HostsLocation -Value $NewHostEntry;

    # Validate entry
    if ((Get-Content $HostsLocation) -contains $NewHostEntry) {
        Write-Host "[Done]" -ForegroundColor Green
    } else {
        Write-Host "[Failed]" -ForegroundColor Red
    }
}
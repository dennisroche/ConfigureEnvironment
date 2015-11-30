function Execute-SqlScript {
    param (
        [parameter(Mandatory)][string]
        $SqlInstance,
        [parameter(Mandatory)][string]
        $ScriptLocation
    )

    & sqlcmd -S "$SqlInstance" -E -i "$ScriptLocation" | %{ Write-Host "[SqlCmd $SqlInstance] $_" }
}
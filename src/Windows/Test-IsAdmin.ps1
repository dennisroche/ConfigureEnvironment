function Test-IsAdmin {
    $Identity = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    Return $Identity.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}
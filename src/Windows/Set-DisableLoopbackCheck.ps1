function Set-DisableLoopbackCheck {
    Write-Host "Setting DisableLoopbackCheck so that Windows Authenication will work locally. For more information https://support.microsoft.com/en-us/kb/896861"
    New-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\Lsa\ -Name DisableLoopbackCheck -PropertyType DWORD -Value 1 -Force
}
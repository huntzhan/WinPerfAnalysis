param(
    # Python Version
    [Parameter(Mandatory = $false)]
    [string]
    $PythonVersion = '3.6.1',

    # Using File Name.
    [Parameter(Mandatory = $false)]
    [Switch]
    $UsingFilenameToSearchInstaller = $false,
    # Installer Filename
    [Parameter(Mandatory = $false)]
    [string]
    $InstallerFilename = 'python-3.6.1-amd64.exe',

    # Temp Folder
    [Parameter(Mandatory = $false)]
    [string]
    $TempFolder = 'C:\Windows\Temp',

    # Using HTTP Download Method
    [Parameter(Mandatory = $false)]
    [Switch]
    $UsingHTTPDownload = $true,
    # Remote Download URL
    [Parameter(Mandatory = $false)]
    [string]
    $RemoteUrlEndpoint = 'https://www.python.org/ftp/python/',

    # Using Share Folder.
    [Parameter(Mandatory = $false)]
    [Switch]
    $UsingShareFolderDownload = $false,
    # Share Folder Path
    [Parameter(Mandatory = $false)]
    [string]
    $RemoteShareFolder = ''
)


Write-Host $PythonVersion
Write-Host $UsingFilenameToSearchInstaller
Write-Host $InstallerFilename
Write-Host $TempFolder
Write-Host $UsingHTTPDownload
Write-Host $RemoteUrlEndpoint
Write-Host $UsingShareFolderDownload
Write-Host $RemoteShareFolder


function LocalPythonInstallerFilename() {
    return "python-" + (Get-Date -Format "yyyy-MM-dd-HH-mm-ss") + ".exe"
}


# Check existance of temp folder.
if (-Not (Test-Path -Path $TempFolder -PathType 'Container')) {
    Write-Host "Temporary Path [$TempFolder] Not Exists, Stop."
    return -1
}

$localInstaller = Join-Path $TempFolder (LocalPythonInstallerFilename)
Write-Host "Local installer will be save in $localInstaller"

# Download installer.
if ($UsingHTTPDownload) {
    $remoteUrl = $RemoteUrlEndpoint
    if (-Not $UsingFilenameToSearchInstaller) {
        $remoteUrl += "$($PythonVersion)/python-$($PythonVersion)-amd64.exe"
    } else {
        $remoteUrl += $InstallerFilename
    }

    Write-Host "Downloading $remoteUrl"
    $client = New-Object System.Net.WebClient
    $client.DownloadFile($remoteUrl, $localInstaller)

} elseif ($UsingShareFolderDownload) {
    Write-Host "Not Implemented"
    return -1   
}

Write-Host "Installing."
Start-Process $localInstaller "/quiet InstallAllUsers=1 PrependPath=1" -NoNewWindow -Wait
Write-Host "Done"
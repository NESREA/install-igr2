# install-igr2.ps1
# Script for download and installation of IGR2 GitHub repository on Windows

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$repo = 'IGR2'
$arch = $repo + '.zip'
$url = 'https://github.com/NESREA/' + $repo + '/zipball/master'
$statusIsOk = '200'
$response = Invoke-WebRequest -Uri $url -PassThru -Outfile $arch
if ($response.StatusCode -ne $statusIsOk) {
    Write-Error "There was a problem downloading $arch"
}

Write-Host  "Installing '$arch' ... "
if ($PSVersionTable.PSVersion.Major -ge 5) {
    Expand-Archive $arch 
} else {
    $shell = New-Object -Com shell.application
    $zip = $shell.NameSpace($arch)
    foreach($item in $zip.items())
    {
        $shell.NameSpace($repo).copyhere($item)
    }
}
                   
$mainDir = $(Get-ChildItem $repo).Name
Get-Location | 
    Join-Path -ChildPath $repo |
    Join-Path -ChildPath $mainDir | 
    Move-Item
Remove-Item @($repo, $arch) -Recurse -Force
Rename-Item -Path $mainDir -NewName $repo
if ($(gci).Name.Contains($arch)) {
    Write-Host "Done.`n"
}

# install-igr2.ps1
# Script for download and installation of IGR2 GitHub repository on Windows

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$repo = 'IGR2'
$arch = $repo + '.zip'
$response = Invoke-WebRequest -Uri https://github.com/NESREA/IGR2/zipball/master -PassThru -Outfile $arch
if ('200' -ne $response.StatusCode) {
    Write-Error "There was problem downloading $arch"
}

Write-Host  "Installing '$arch' ... "
Expand-Archive $arch
$mainDir = $(gci $repo).Name
Get-Location | 
    Join-Path -ChildPath $repo |
    Join-Path -ChildPath $mainDir | 
    Move-Item
Remove-Item @($repo, $arch) -Recurse -Force
Rename-Item -Path $mainDir -NewName $repo
if ($(gci).Name.Contains($arch)) {
    Write-Host "Done.`n"
}

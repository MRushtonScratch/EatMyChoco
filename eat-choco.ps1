$chocolateyArgs = "-y"
[array] $chocolateyPackages = "googlechrome",
            "7zip",
            "putty.install",
            "cmder",
            "curl",
            "fiddler4",
            "git",
            "poshgit",
            "gitextensions",
            "nuget.commandline",
            "visualstudiocode",
            "agentransack",
            "nodejs.install"

Function Install-ChocoPackage([string] $package, [string]$args)
{
    Write-Host "Installing package - $package $args"
    choco install $package $args
}

Function Install-Chocolatey
{
    Write-Host
    Write-Host "Installing Chocolatey"
    Write-Host "--------------------"
    $choco = choco | Out-String
    $chocoInstalled = $choco.Contains("Chocolatey v")

    if ($chocoInstalled) {
        Write-Host
        Write-Host "Chocolatey Installed"
        Write-Host "--------------------"
    }
    else {
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
}

Function Install-ChocolateyPackages([array]$chocoPackages, [string]$chocoArgs)
{
    Write-Host
    Write-Host "Installing Packages"
    Write-Host "-------------------"
    foreach ($package in $chocoPackages) 
    {    
        Install-ChocoPackage $package param($chocoArgs)
    }   

}

Function WaitForKey {
	Write-Host
	Write-Host "Press any key to continue..." -ForegroundColor Black -BackgroundColor White
	[Console]::ReadKey($true) | Out-Null
}


If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $args" -Verb RunAs
	Exit
}

Install-Chocolatey
Install-ChocolateyPackages $chocolateyPackages $chocolateyArgs
WaitForKey

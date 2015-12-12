Import-Module "$PSScriptRoot\AnsiColorize.psm1"

function Write-JenkinsConsole {
    <#
        .SYNOPSIS
            Wrapper for Write-Host for use in Jenkins with AnsiColor Plugin.

        .DESCRIPTION
            Adds ANSI SGR codes based on -foregroundColor and -backgroundColor.

            Only does so if it detects a Jenkins environment using Get-InsideJenkinsEnvironment
    #>

    param()

    if(Get-InsideJenkinsEnvironment){
        Write-HostAnsi @Args
    } else {
        Write-Host @Args
    }
}

function Get-InsideJenkinsEnvironment {
    <#
        .SYNOPSIS
            Returns whether the script is being run inside a Jenkins environment.

    #>

    return $Env:Workspace -ne $null
}
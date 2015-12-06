function Write-HostAnsi {
     <#
        .SYNOPSIS
            Wrapper for Write-Host, adds ANSI SGR codes based on -foregroundColor and -backgroundColor
    #>

    param(
        $object,
        $foregroundColor,
        $backgroundColor
    )
    
    $writeHostSplatArgs = @{}
    $ansiSgrCodes = @()

    if($foregroundColor -ne $null){
        $ansiSgrCodes += Convert-ForegroundColorToAnsi $foregroundColor
        $writeHostSplatArgs.add("foregroundColor", $foregroundColor)
    }

    if($backgroundColor -ne $null){
        $ansiSgrCodes += Convert-BackgroundColorToAnsi $backgroundColor
        $writeHostSplatArgs.add("backgroundColor", $backgroundColor)
    }

    if($foregroundColor -ne $null -or $backgroundColor -ne $null){
        $newObject = Colorize-Text -text $object -ansiSgrCode $ansiSgrCodes
        Write-Host $newObject @writeHostSplatArgs @args
    } else {
        Write-Host $object @args
    }
}

function Colorize-Text {
    <#
    .SYNOPSIS
        Adds ANSI SGR codes to a string.
    
    .DESCRIPTION
        Adds ANSI SGR codes to a string.
        
    .PARAMETER text
        Text to be transformed.
    .PARAMETER ansiSgrCode
        ANSI SGR number to insert.
        See https://en.wikipedia.org/wiki/ANSI_escape_code for details
        Or use the [AnsiColor] enum.

        Also accepts an array of SGR numbers, and will apply all of them.
        
    .NOTES
        Designed to play nicely with https://wiki.jenkins-ci.org/display/JENKINS/AnsiColor+Plugin
  
    .EXAMPLE
        Colorize-Text -text "Hello World." -ansiSgrCode ([AnsiColor]::ForegroundRed -as [int])
    
    .EXAMPLE
        Colorize-Text -text "Hello World." -ansiSgrCode @( ([AnsiColor]::ForegroundRed -as [int]), ([AnsiColor]::BackgroundYellow -as [int]) )

    #>
    param(
        $text,
        $ansiSgrCode #https://en.wikipedia.org/wiki/ANSI_escape_code#graphics
    )

    $ansiCodeString;
    if($ansiSgrCode -is [array]){
        foreach($code in $ansiSgrCode){
            $ansiCodeString += "[${code}m"
        }
    } else {
        $ansiCodeString = "[${ansiSgrCode}m"
    }

    return [char]27 + "$ansiCodeString$text" + [char]27 + "[0m"
}

Add-Type -TypeDefinition @"
    public enum AnsiColor {
        ForegroundBlack = 30,
        ForegroundRed = 31,
        ForegroundGreen = 32,
        ForegroundYellow = 33,
        ForegroundBlue = 34,
        ForegroundMagenta = 35,
        ForegroundCyan = 36,
        ForegroundWhite = 37,
        BackgroundBlack = 40,
        BackgroundRed = 41,
        BackgroundGreen = 42,
        BackgroundYellow = 43,
        BackgroundBlue = 44,
        BackgroundMagenta = 45,
        BackgroundCyan = 46,
        BackgroundWhite = 47,
    }
"@

$foregroundColorAnsiCodes = @{
    #https://msdn.microsoft.com/en-us/library/system.consolecolor(v=vs.110).aspx
    #Converted to closest ANSI SGR equivalent
    "Black" = [AnsiColor]::ForegroundBlack -as [int];
    "White" = [AnsiColor]::ForegroundWhite -as [int];
    "Blue" = [AnsiColor]::ForegroundBlue -as [int];
    "DarkBlue" = [AnsiColor]::ForegroundBlue -as [int];
    "Green" = [AnsiColor]::ForegroundGreen -as [int];
    "DarkGreen" = [AnsiColor]::ForegroundGreen -as [int];
    "Cyan" = [AnsiColor]::ForegroundCyan -as [int];
    "DarkCyan" = [AnsiColor]::ForegroundCyan -as [int];
    "Red" = [AnsiColor]::ForegroundRed -as [int];
    "DarkRed" = [AnsiColor]::ForegroundRed -as [int];
    "Magenta" = [AnsiColor]::ForegroundMagenta -as [int];
    "DarkMagenta" = [AnsiColor]::ForegroundMagenta -as [int];
    "Yellow" = [AnsiColor]::ForegroundYellow -as [int];
    "DarkYellow" = [AnsiColor]::ForegroundYellow -as [int];

    #No equivalent
    "Gray" = [AnsiColor]::ForegroundBlack -as [int];
    "DarkGray" = [AnsiColor]::ForegroundBlack -as [int];
}

$backgroundColorAnsiCodes = @{
    #https://msdn.microsoft.com/en-us/library/system.consolecolor(v=vs.110).aspx
    #Converted to closest ANSI SGR equivalent
    "Black" = [AnsiColor]::BackgroundBlack -as [int];
    "White" = [AnsiColor]::BackgroundWhite -as [int];
    "Blue" = [AnsiColor]::BackgroundBlue -as [int];
    "DarkBlue" = [AnsiColor]::BackgroundBlue -as [int];
    "Green" = [AnsiColor]::BackgroundGreen -as [int];
    "DarkGreen" = [AnsiColor]::BackgroundGreen -as [int];
    "Cyan" = [AnsiColor]::BackgroundCyan -as [int];
    "DarkCyan" = [AnsiColor]::BackgroundCyan -as [int];
    "Red" = [AnsiColor]::BackgroundRed -as [int];
    "DarkRed" = [AnsiColor]::BackgroundRed -as [int];
    "Magenta" = [AnsiColor]::BackgroundMagenta -as [int];
    "DarkMagenta" = [AnsiColor]::BackgroundMagenta -as [int];
    "Yellow" = [AnsiColor]::BackgroundYellow -as [int];
    "DarkYellow" = [AnsiColor]::BackgroundYellow -as [int];

    #No equivalent
    "Gray" = [AnsiColor]::BackgroundBlack -as [int];
    "DarkGray" = [AnsiColor]::BackgroundBlack -as [int];
}

function Convert-ForegroundColorToAnsi {
    param(
        $foregroundColor 
    )

    return $foregroundColorAnsiCodes[$foregroundColor]
}

function 
Convert-BackgroundColorToAnsi {
    param(
        $backgroundColor
    )

    return $backgroundColorAnsiCodes[$backgroundColor]
}
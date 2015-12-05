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
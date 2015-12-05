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
        Also accepts an array of SGR numbers, and will apply all of them.
        
    .NOTES
        Designed to play nicely with https://wiki.jenkins-ci.org/display/JENKINS/AnsiColor+Plugin
  
    .EXAMPLE
        Colorize-Text -text "Hello World." -ansiSgrCode 33
    
    .EXAMPLE
        Colorize-Text -text "Hello World." -ansiSgrCode @(33, 44)
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
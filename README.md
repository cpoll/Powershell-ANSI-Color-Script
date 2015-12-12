Powershell script to insert ANSI SGR parameters (specifically ANSI color) into strings, and a wrapper for Write-Host that translates -ForegroundColor and -BackgroundColor parameters into ANSI color strings.

Designed for use with the Jenkins AnsiColor Plugin at https://wiki.jenkins-ci.org/display/JENKINS/AnsiColor+Plugin 

Usage:
	Copy AnsiColorize.psm1 and Write-JenkinsConsole.psm1 to the same folder.
	Import-Module Write-JenkinsConsole.psm1
	Use Write-JenkinsConsole as a replacement to Write-Host
		Note that piped input is not yet supported
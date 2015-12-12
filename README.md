Powershell script to insert ANSI SGR parameters (specifically ANSI color) into strings, and a wrapper for Write-Host that translates -ForegroundColor and -BackgroundColor parameters into ANSI color strings.

Designed for use with the Jenkins AnsiColor Plugin at https://wiki.jenkins-ci.org/display/JENKINS/AnsiColor+Plugin 

## Usage:
	1. Copy AnsiColorize.psm1 and Write-JenkinsConsole.psm1 to the same folder.
	2. Import-Module Write-JenkinsConsole.psm1
	3. Use Write-JenkinsConsole as a replacement to Write-Host
		* __Note that piped input is not yet supported__
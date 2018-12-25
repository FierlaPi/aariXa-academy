<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
.INPUTS
    Inputs to this cmdlet (if any)
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    The component this cmdlet belongs to
.ROLE
    The role this cmdlet belongs to
.FUNCTIONALITY
    The functionality that best describes this cmdlet
#>
function DeployModule {
    [CmdletBinding(DefaultParameterSetName = 'Default Location',
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium')]
    Param (
        # Deployment type (User, ProgramFiles, System)
        [Parameter(Position = 0,
            ParameterSetName = 'Default Location')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("User", "Program", "System")]
        [Alias("dt")]
        [String] $DeploymentType = "User",

        # Path to compressed module package
        [Parameter(Mandatory = $true,
            Position = 1)]
        [System.IO.FileInfo] $Path,

        # Destination path for the module
        [Parameter(Mandatory = $true,
            Position = 1,
            ParameterSetName = 'Custom Location')]
        [System.IO.FileInfo] $DestinationPath,

        # Forcing installation
        [Parameter()]
        [Switch]$Force
    )

    begin {
        $defaultDstPath = $env:PSModulePath.Split([System.IO.Path]::PathSeparator)
        $userProfilePath = $env:USERPROFILE
        $programFilesPath = $env:ProgramFiles
        $systemPath = Join-Path $env:SystemRoot "\System32"

        [String] $systemDstPath = $null
        [String] $programFilesDstPath = $null
        [String] $userDstPath = $null

        $defaultDstPath | ForEach-Object {
            $p = [System.IO.FileInfo]$_
            if ($p.FullName.StartsWith($userProfilePath, "CurrentCultureIgnoreCase") -and ($p.FullName.Contains("WindowsPowerShell")) ) {
                $userDstPath = $p
            }
            elseif ($p.FullName.StartsWith($programFilesPath, "CurrentCultureIgnoreCase") -and ($p.FullName.Contains("WindowsPowerShell")) ) {
                $programFilesDstPath = $p
            }
            elseif ($p.FullName.StartsWith($systemPath, "CurrentCultureIgnoreCase") -and ($p.FullName.Contains("WindowsPowerShell")) ) {
                $systemDstPath = $p
            }
        }
        Write-Verbose $("User Module path        : " + $userDstPath)
        Write-Verbose $("ProgramFiles Module path: " + $programFilesDstPath)
        Write-Verbose $("System Module path      : " + $systemDstPath)
    }

    process {
        if ($pscmdlet.ShouldProcess("Target", "Operation")) {
            [System.IO.FileInfo]$dstPath = $null
            switch ($DeploymentType) {
                'System' {
                    $dstPath = $systemDstPath
                }
                'ProgramFiles' {
                    $dstPath = $programFilesDstPath
                }
                'User' {
                    $dstPath = $userDstPath
                }
                Default {
                    $dstPath = $DestinationPath
                }
            }
            Write-Verbose $dstPath

            if ((Test-Path $dstPath) -and (Test-Path $Path)) {
                Expand-Archive -Path $Path -DestinationPath $dstPath -Force:$Force -Verbose
            }
        }
    }

    end {
    }
}

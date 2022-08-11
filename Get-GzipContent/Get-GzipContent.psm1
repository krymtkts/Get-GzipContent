using namespace System.Text
using namespace System.IO

<#
.SYNOPSIS
Gets the content of the gzip archive at the specified location.
.DESCRIPTION
The Get-GzipContent gets the content of gzip archive at the location specified by the path.
Use default text encoding to output.
.EXAMPLE
Get-GzipContent -Path .\archive.gz
Get the content of archive.gz.
.EXAMPLE
Get-ChildItem -Path 'file*.gz' | Get-GzipContent
Get the contents of archives.
.EXAMPLE
Get-GzipContent -Path 'file*.gz'
Get the contents of archives.
.PARAMETER Path
The path of the compressed archive file.
#>
function Get-GzipContent {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
        [ValidateScript( { $_ | Test-Path -PathType Leaf })]
        [String[]] $Path,
        [Parameter()]
        [String] $Delimiter = [System.Environment]::NewLine
    )
    Begin {
        $Encoding = [Encoding]::Default
    }
    Process {
        $Path | Get-Item | Select-Object -ExpandProperty FullName | ForEach-Object {
            $filePath = $_
            Write-Verbose "Get-GzipContent from $filePath"
            try {
                $fs = New-Object FileStream $filePath, ([FileMode]::Open), ([FileAccess]::Read), ([FileShare]::Read)
                $gs = New-Object Compression.GzipStream $fs, ([Compression.CompressionMode]::Decompress)
                $reader = New-Object StreamReader ($gs, $Encoding)
                $line = $null;
                $count = 0
                while ($null -ne ($line = $reader.ReadLine() )) {
                    $line -split $Delimiter | ForEach-Object {
                        Write-Output $_
                        $count++
                    }
                }
                Write-Verbose "Contents count is $count"
            }
            catch {
                Write-Error "Failed to decompress $filePath $($PSItem.Exception.message)"
                throw
            }
            finally {
                Write-Verbose 'Try release resources.'
                $reader, $gs, $fs | Where-Object { $null -ne $_ } | ForEach-Object { $_.Close() }
                Write-Verbose 'Released.'
            }
        }
    }
}
Set-Alias zcat Get-GzipContent
Export-ModuleMember -Function 'Get-GzipContent' -Alias 'zcat'

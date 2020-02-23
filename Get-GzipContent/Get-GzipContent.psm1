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
.PARAMETER Path
The path of the compressed archive file.
#>
function Get-GzipContent {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $True, ValueFromPipeline = $True)]
        [ValidateScript( { $_ | Test-Path -PathType Leaf })]
        [String[]] $Path
    )
    Begin {
        $Encofing = [Encoding]::Default
    }
    Process {
        foreach ($p in $Path) {
            $filePath = (Get-Item -Path $p).FullName
            Write-Verbose "Get-GzipContent from $filePath"
            try {
                $input = New-Object FileStream $filePath, ([FileMode]::Open), ([FileAccess]::Read), ([FileShare]::Read)
                $gzip = New-Object Compression.GzipStream $input, ([Compression.CompressionMode]::Decompress)
                $output = New-Object MemoryStream
                $gzip.CopyTo($output)
                $content = $Encofing.GetString($output.ToArray())
                Write-Verbose "Content length $($content.Length)"
                Write-Output $content
            }
            finally {
                foreach ($s in @($output, $gzip, $input)) {
                    if ($s) {
                        $s.Close()
                    }
                }
            }
        }
    }
}
Set-Alias zcat Get-GzipContent
Export-ModuleMember -Function 'Get-GzipContent' -Alias 'zcat'

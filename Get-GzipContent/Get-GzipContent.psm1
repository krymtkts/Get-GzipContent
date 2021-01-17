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
        [String[]] $Path
    )
    Begin {
        $Encofing = [Encoding]::Default
    }
    Process {
        foreach ($p in $Path) {
            $filePaths = (Get-Item -Path $p).FullName
            Write-Verbose "Get-GzipContent from $filePaths"
            foreach ($filePath in $filePaths) {
                Write-Verbose "Get-GzipContent from $filePath"
                try {
                    $inputS = New-Object FileStream $filePath, ([FileMode]::Open), ([FileAccess]::Read), ([FileShare]::Read)
                    $gzipS = New-Object Compression.GzipStream $inputS, ([Compression.CompressionMode]::Decompress)
                    $outputS = New-Object MemoryStream
                    $gzipS.CopyTo($outputS)
                    $content = $Encofing.GetString($outputS.ToArray())
                    Write-Verbose "Content length $($content.Length)"
                    Write-Output $content
                }
                catch {
                    Write-Error "Failed to decompress $filePath $($PSItem.Exception.message)"
                    throw
                }
                finally {
                    foreach ($s in @($outputS, $gzipS, $inputS)) {
                        if ($s) {
                            $s.Close()
                        }
                    }
                }
            }
        }
    }
}
Set-Alias zcat Get-GzipContent
Export-ModuleMember -Function 'Get-GzipContent' -Alias 'zcat'

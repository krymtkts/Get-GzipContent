# Get-GzipContent

[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/Get-GzipContent?style=flat-square)](https://www.powershellgallery.com/packages/Get-GzipContent)

Gets the content of the gzip archive at the specified location. like `zcat`.

## Usage

The Get-GzipContent gets the content of gzip archive at the location specified by the path.
Get-GzipContent uses default text encoding to output.

Get the content of archive.gz

```powershell
Get-GzipContent -Path .\archive.gz
```

Get the contents of archives.

```powershell
Get-ChildItem -Path 'file*.gz' | Get-GzipContent
```

## Installation

### 1. Get module

#### Installing via PowerShellGet

Get-GzipContent is available on the PowerShell Gallery. You can install using the PowerShellGet module.

[PowerShell Gallery | Get-GzipContent](https://www.powershellgallery.com/packages/Get-GzipContent/)

```powershell
Install-Module Get-GzipContent
```

#### Clone the repository

Clone the repository to your PowerShell module path.
Check your module pathes by executing `$env:PSModulePath`.

Sample command is below.

```powershell
cd ($env:PSModulePath -split ';')[0]
git clone https://github.com/krymtkts/Get-GzipContent
```

### 2. Import module

The command is below. Add `-Force` paramter when you update module.

```powershell
Import-Module -Name Get-GzipContent
```

Add `Import-Module` to your profile if you want.
Check your profile by executing `$profile`.

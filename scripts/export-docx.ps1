<#
.SYNOPSIS
  Convert a markdown file under output/ to .docx using Pandoc.

.DESCRIPTION
  Wraps `pandoc <input>.md -o <output>.docx`. Used standalone or invoked by the /export-docx skill.

.PARAMETER File
  Path to a .md file. Required unless -Auto is used.

.PARAMETER Auto
  Auto-detect the most-recently-modified .md under output/.

.PARAMETER Output
  Optional explicit output path. Default: same path with .md replaced by .docx.

.EXAMPLE
  scripts\export-docx.ps1 -File output\one-pagers\living-expense-tracker.md

.EXAMPLE
  scripts\export-docx.ps1 -Auto
#>
[CmdletBinding(DefaultParameterSetName='File')]
param(
  [Parameter(ParameterSetName='File', Mandatory=$true, Position=0)]
  [string]$File,

  [Parameter(ParameterSetName='Auto', Mandatory=$true)]
  [switch]$Auto,

  [Parameter()]
  [string]$Output
)

$ErrorActionPreference = 'Stop'

# Verify pandoc is on PATH
$pandocCmd = Get-Command pandoc -ErrorAction SilentlyContinue
if (-not $pandocCmd) {
  Write-Error "pandoc not found on PATH. Install via 'winget install JohnMacFarlane.Pandoc' and restart your shell."
  exit 2
}

# Resolve input
if ($Auto) {
  $candidates = Get-ChildItem -Path 'output' -Recurse -Filter '*.md' -File -ErrorAction SilentlyContinue
  if (-not $candidates) {
    Write-Error "No .md files found under output/."
    exit 1
  }
  $InputFile = ($candidates | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
  Write-Host "[export-docx] Auto-detected: $InputFile"
} else {
  if (-not (Test-Path -LiteralPath $File -PathType Leaf)) {
    Write-Error "File not found: $File"
    exit 1
  }
  $InputFile = (Resolve-Path -LiteralPath $File).Path
}

if (-not $InputFile.ToLower().EndsWith('.md')) {
  Write-Error "Expected a .md file, got: $InputFile"
  exit 1
}

# Resolve output path
if ($Output) {
  $OutputFile = $Output
} else {
  $OutputFile = [System.IO.Path]::ChangeExtension($InputFile, '.docx')
}

# Ensure output directory exists
$OutputDir = Split-Path -Parent $OutputFile
if ($OutputDir -and -not (Test-Path -LiteralPath $OutputDir)) {
  New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Run pandoc
Write-Host "[export-docx] pandoc '$InputFile' -> '$OutputFile'"
& pandoc $InputFile -o $OutputFile
if ($LASTEXITCODE -ne 0) {
  Write-Error "pandoc failed with exit code $LASTEXITCODE"
  exit $LASTEXITCODE
}

$size = (Get-Item -LiteralPath $OutputFile).Length
Write-Host "[export-docx] Wrote $OutputFile ($size bytes)"
exit 0

<#
.SYNOPSIS
  Convert a markdown or plain-text file under output/ to .docx using Pandoc.

.DESCRIPTION
  Wraps `pandoc <input>.md -o <output>.docx`. Accepts `.md` and `.txt` source files
  (Pandoc handles both). Used standalone or invoked by the /export-docx skill.

.PARAMETER File
  Path to a .md or .txt file. Required unless -Auto is used.

.PARAMETER Auto
  Auto-detect the most-recently-modified .md or .txt under output/.

.PARAMETER Output
  Optional explicit output path. Default: same path with the source extension replaced by .docx.

.EXAMPLE
  scripts\export-docx.ps1 -File output\one-pagers\living-expense-tracker.md

.EXAMPLE
  scripts\export-docx.ps1 -File output\notes\meeting.txt

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
  $candidates = Get-ChildItem -Path 'output' -Recurse -File -ErrorAction SilentlyContinue |
                Where-Object { $_.Extension -in '.md','.txt' }
  if (-not $candidates) {
    Write-Error "No .md or .txt files found under output/."
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

$inputLower = $InputFile.ToLower()
if (-not ($inputLower.EndsWith('.md') -or $inputLower.EndsWith('.txt'))) {
  Write-Error "Expected a .md or .txt file, got: $InputFile"
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

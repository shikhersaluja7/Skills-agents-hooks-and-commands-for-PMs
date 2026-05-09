<#
.SYNOPSIS
  Claude Code Stop hook. Detects markdown saved under output/ in the recent past and emits
  a system-reminder so the next Claude turn offers the PM an optional .docx export.

.DESCRIPTION
  Runs as a Stop hook (registered in .claude/settings.json). Scans output/**/*.md for files
  modified within the last $WindowSeconds (default 90). For each fresh file, prints a
  system-reminder block to stdout. Always exits 0 - hook failures must never break the session.

.PARAMETER WindowSeconds
  How far back to look (in seconds) for recently-modified .md files. Default 90.

.NOTES
  Mute with environment variable: CLAUDE_SKILLS_DOCX_PROMPT=off
#>
[CmdletBinding()]
param(
  [int]$WindowSeconds = 90
)

$ErrorActionPreference = 'Continue'

# Mute via env var
if ($env:CLAUDE_SKILLS_DOCX_PROMPT -eq 'off') {
  exit 0
}

# Bail out cleanly if there is no output/ directory
if (-not (Test-Path -LiteralPath 'output' -PathType Container)) {
  exit 0
}

$cutoff = (Get-Date).AddSeconds(-$WindowSeconds)

try {
  $fresh = Get-ChildItem -Path 'output' -Recurse -Filter '*.md' -File -ErrorAction SilentlyContinue |
           Where-Object { $_.LastWriteTime -ge $cutoff }
} catch {
  exit 0
}

if (-not $fresh) {
  exit 0
}

# Emit one system-reminder per fresh file (typically just one)
foreach ($f in $fresh) {
  $rel = (Resolve-Path -LiteralPath $f.FullName -Relative -ErrorAction SilentlyContinue)
  if (-not $rel) { $rel = $f.FullName }
  $relForward = $rel -replace '\\', '/'

  Write-Host ""
  Write-Host "<system-reminder>"
  Write-Host "A markdown output was just saved at: $relForward"
  Write-Host "Optionally offer the PM a .docx export of this file. If they accept, run:"
  Write-Host "  powershell -NoProfile -ExecutionPolicy Bypass -File ./scripts/export-docx.ps1 -File `"$relForward`""
  Write-Host "Or invoke the /export-docx skill. To mute these prompts, set CLAUDE_SKILLS_DOCX_PROMPT=off."
  Write-Host "</system-reminder>"
}

exit 0

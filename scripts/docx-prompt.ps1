<#
.SYNOPSIS
  Claude Code Stop hook. Detects markdown or CSV files saved under output/ in the recent past
  and emits a system-reminder so the next Claude turn offers the PM an optional Office export.

.DESCRIPTION
  Runs as a Stop hook (registered in .claude/settings.json). Scans output/ for `.md`, `.txt`,
  and `.csv` files modified within the last $WindowSeconds (default 90). For each fresh file,
  prints a format-appropriate system-reminder block to stdout. Always exits 0 - hook failures
  must never break the session.

  Per the workspace File Format Policy, skills save artifacts in native formats first; this
  hook offers the optional Office conversion only after the save lands.

.PARAMETER WindowSeconds
  How far back to look (in seconds) for recently-modified files. Default 90.

.NOTES
  Mute with environment variable: CLAUDE_SKILLS_DOCX_PROMPT=off (covers all formats this hook
  scans for; the env-var name is preserved for backward compatibility).
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
  $fresh = Get-ChildItem -Path 'output' -Recurse -File -ErrorAction SilentlyContinue |
           Where-Object { ($_.Extension -in '.md','.txt','.csv') -and ($_.LastWriteTime -ge $cutoff) }
} catch {
  exit 0
}

if (-not $fresh) {
  exit 0
}

# Emit one system-reminder per fresh file. Format determines target export skill.
foreach ($f in $fresh) {
  $rel = (Resolve-Path -LiteralPath $f.FullName -Relative -ErrorAction SilentlyContinue)
  if (-not $rel) { $rel = $f.FullName }
  $relForward = $rel -replace '\\', '/'

  if ($f.Extension -in '.md','.txt') {
    $exportSkill = '/export-docx'
    $exportScript = './scripts/export-docx.ps1'
    $targetFormat = '.docx'
  } else {
    $exportSkill = '/export-xlsx'
    $exportScript = './scripts/export-xlsx.ps1'
    $targetFormat = '.xlsx'
  }

  Write-Host ""
  Write-Host "<system-reminder>"
  Write-Host "A native output was just saved at: $relForward"
  Write-Host "Per the workspace File Format Policy, optionally offer the PM a $targetFormat export of this file."
  Write-Host "If they accept, run:"
  Write-Host "  powershell -NoProfile -ExecutionPolicy Bypass -File $exportScript -File `"$relForward`""
  Write-Host "Or invoke the $exportSkill skill. To mute these prompts, set CLAUDE_SKILLS_DOCX_PROMPT=off."
  Write-Host "</system-reminder>"
}

exit 0

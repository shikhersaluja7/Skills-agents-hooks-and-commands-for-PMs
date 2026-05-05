<#
    humanizer-check.ps1 - Validate markdown files against the Humanized Writing Standard
    
    Scans staged or specified .md files for:
      - Em dashes and en dashes used as em dashes
      - Banned words and phrases
      - Banned paragraph starters (with frequency limit)
    
    Usage:
      .\scripts\humanizer-check.ps1                    # Check all staged .md files
      .\scripts\humanizer-check.ps1 -Files "README.md","CLAUDE.md"  # Check specific files
    
    Exit codes:
      0 = clean
      1 = violations found (blocks commit)
#>

param(
    [string[]]$Files
)

$root = Split-Path $PSScriptRoot -Parent

# Support both array invocation (-Files @('a','b')) and a single comma-separated string
# (which is what `pwsh -File ... -Files "a,b,c"` produces from a shell script).
if ($Files) {
    $Files = $Files | ForEach-Object { $_ -split ',' } | Where-Object { $_.Trim() } | ForEach-Object { $_.Trim() }
}

# If no files specified, check all staged .md files
if (-not $Files) {
    $staged = git diff --cached --name-only --diff-filter=ACM 2>$null | Where-Object { $_ -match '\.md$' }
    if (-not $staged) {
        Write-Host "[humanizer] No staged .md files to check."
        exit 0
    }
    $Files = $staged | ForEach-Object { Join-Path $root $_ }
}

$emDash = [char]0x2014
$enDash = [char]0x2013

$bannedWords = @(
    "delve", "leverage", "utilize",
    "robust", "seamless", "cutting-edge", "holistic",
    "synergy", "paradigm shift", "unprecedented", "game-changing",
    "groundbreaking", "next-level", "state-of-the-art", "innovative approach",
    "myriad", "vast majority", "constellation of", "intricate tapestry"
)

$bannedPhrases = @(
    "it's important to note", "it should be noted",
    "in terms of", "at the end of the day",
    "in today's world", "moving forward"
)

$bannedStarters = @(
    "However,", "Furthermore,", "Moreover,", "Therefore,",
    "In conclusion,", "Interestingly,", "As mentioned,",
    "Additionally,", "Consequently,", "Nevertheless,"
)

$totalViolations = 0

foreach ($filePath in $Files) {
    # Resolve relative paths using Resolve-Path or Join-Path
    $file = $filePath
    if (-not (Test-Path $filePath -ErrorAction SilentlyContinue)) {
        $candidate = Join-Path $root $filePath
        if (Test-Path $candidate -ErrorAction SilentlyContinue) {
            $file = $candidate
        } else {
            continue
        }
    }

    # Hard guard: only process .md files. Auto-fixing dashes in scripts, configs, or
    # bash hooks corrupts syntax (e.g. `git diff -- '*.md'` becomes `git diff - '*.md'`).
    if ($file -notmatch '\.md$') { continue }

    $relPath = $file.Replace("$root\", "").Replace("$root/", "")

    # Skip sample files and skill references - these are team-authored reference documents for tonality
    if ($relPath -match '^samples[\\/]' -or $relPath -match '[\\/]references[\\/]') { continue }

    $lines = Get-Content $file
    $fileViolations = @()
    $fileFixes = @()
    $inCodeBlock = $false

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        $lineNum = $i + 1

        # Track code blocks (skip content inside ```)
        if ($line -match '^```') { $inCodeBlock = -not $inCodeBlock; continue }
        if ($inCodeBlock) { continue }

        # Skip lines that document the rules themselves (listing banned words/phrases)
        # These lines mention banned items in a "here's what NOT to use" context
        if ($line -match '^\s*-\s*\*\*Banned' -or
            $line -match 'Banned words:' -or
            $line -match 'Banned phrases:' -or
            $line -match 'no "delve"' -or
            $line -match '^\s*-\s*Banned' -or
            $line -match 'banned words.*never use' -or
            $line -match 'Never use:' -or
            $line -match 'Avoid starting paragraphs with:' -or
            $line -match 'Also banned:') { continue }

        # SAFETY: Dash auto-fixes perform character-for-character substitution only.
        # They never remove surrounding text. If changing this logic, preserve all content.

        # Em dashes - auto-fix by replacing with single dash
        if ($line -match $emDash) {
            $fixed = $line -replace $emDash, ' - '
            # Clean up double spaces around the replacement
            $fixed = $fixed -replace '  - ', ' - '
            $fixed = $fixed -replace ' -  ', ' - '
            $lines[$i] = $fixed
            $fileFixes += "  Line $lineNum [em dash -> single dash]: $($line.Trim())"
        }

        # En dashes used in prose (skip tables and YAML) - auto-fix
        if ($line -match $enDash -and $line -notmatch '^\|' -and $line -notmatch '^---') {
            $fixed = $lines[$i] -replace $enDash, ' - '
            $fixed = $fixed -replace '  - ', ' - '
            $fixed = $fixed -replace ' -  ', ' - '
            $lines[$i] = $fixed
            $fileFixes += "  Line $lineNum [en dash -> single dash]: $($line.Trim())"
        }

        # Double dashes used as em dashes in prose - auto-fix (skip YAML frontmatter, tables, code)
        if ($line -match ' -- ' -and $line -notmatch '^\|' -and $line -notmatch '^---') {
            $fixed = $lines[$i] -replace ' -- ', ' - '
            $lines[$i] = $fixed
            $fileFixes += "  Line $lineNum [double dash -> single dash]: $($line.Trim())"
        }

        # Banned words
        foreach ($word in $bannedWords) {
            if ($line -match "\b$([regex]::Escape($word))\b") {
                $fileViolations += "  Line $lineNum [banned word '$word']: $($line.Trim())"
            }
        }

        # Banned phrases
        foreach ($phrase in $bannedPhrases) {
            if ($line -match [regex]::Escape($phrase)) {
                $fileViolations += "  Line $lineNum [banned phrase]: $($line.Trim())"
            }
        }

        # Banned starters
        foreach ($starter in $bannedStarters) {
            if ($line.TrimStart().StartsWith($starter)) {
                $fileViolations += "  Line $lineNum [banned starter '$starter']: $($line.Trim())"
            }
        }
    }

    # Write back auto-fixed content if any dashes were replaced
    if ($fileFixes.Count -gt 0) {
        Set-Content -Path $file -Value $lines -Encoding UTF8
        Write-Host "AUTO-FIXED in $relPath ($($fileFixes.Count) dash replacements):"
        $fileFixes | ForEach-Object { Write-Host $_ }
    }

    if ($fileViolations.Count -gt 0) {
        Write-Host "VIOLATIONS in $relPath ($($fileViolations.Count)):"
        $fileViolations | ForEach-Object { Write-Host $_ }
        $totalViolations += $fileViolations.Count
    }
}

if ($totalViolations -gt 0) {
    Write-Host "`n[humanizer] FAILED: $totalViolations violation(s) found. Fix before committing."
    exit 1
} else {
    Write-Host "[humanizer] All staged .md files pass the Humanized Writing Standard."
    exit 0
}

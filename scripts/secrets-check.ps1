<#
    secrets-check.ps1 - Block commits that leak credentials, MCP registration paths,
    SSO/login tokens, or any user-specific config that should stay local.

    Scans:
      - Token prefixes (sk-, ghp_, gho_, github_pat_, xoxb-, xoxp-, AKIA, sk_live_, JWT, PEM private key)
      - Concrete user-specific paths (C:\Users\<actual>, /Users/<actual>, /home/<actual>)
      - Secret-shaped assignments (api_key="...", client_secret: "...", password="...", etc.)

    Allowlist (skipped entirely):
      - LICENSE (legitimate copyright authorship)
      - This script itself (the patterns are defined here)
      - .gitignore, .gitattributes (config; lists patterns, not values)
      - Lockfiles (package-lock.json, yarn.lock, poetry.lock, pnpm-lock.yaml)
      - input/, output/, samples/, **/references/ (gitignored or example/training material)

    Allowlist (within patterns):
      - Generic usernames in paths (Public, Default, you, user, username, admin, root, runner, etc.)
      - Placeholder values in assignments (your-..., example-..., placeholder, change-me, dummy, etc.)
      - Anything wrapped in <angle-brackets>

    Usage:
      .\scripts\secrets-check.ps1                    # Check staged files
      .\scripts\secrets-check.ps1 -Files "a,b,c"     # Check specific files
      .\scripts\secrets-check.ps1 -All               # Audit every tracked file

    Exit codes:
      0 = clean
      1 = violations found (blocks commit / push)
#>

param(
    [string[]]$Files,
    [switch]$All
)

$root = Split-Path $PSScriptRoot -Parent

# Support array form and shell-script comma-separated form (matches humanizer-check.ps1).
if ($Files) {
    $Files = $Files | ForEach-Object { $_ -split ',' } | Where-Object { $_.Trim() } | ForEach-Object { $_.Trim() }
}

# Resolve file list
if ($All) {
    Push-Location $root
    try { $tracked = git ls-files 2>$null } finally { Pop-Location }
    if (-not $tracked) {
        Write-Host "[secrets-check] git ls-files returned no files."
        exit 0
    }
    $Files = $tracked | ForEach-Object { Join-Path $root $_ }
} elseif (-not $Files) {
    Push-Location $root
    try { $staged = git diff --cached --name-only --diff-filter=ACM 2>$null } finally { Pop-Location }
    if (-not $staged) {
        Write-Host "[secrets-check] No staged files to check."
        exit 0
    }
    $Files = $staged | ForEach-Object { Join-Path $root $_ }
}

# --- Token / shape patterns (high confidence) ---
$tokenPatterns = @(
    @{ Name = 'OpenAI/Anthropic-style key'; Re = [regex]'sk-[A-Za-z0-9_\-]{20,}' },
    @{ Name = 'GitHub PAT (classic)';        Re = [regex]'ghp_[A-Za-z0-9]{30,}' },
    @{ Name = 'GitHub OAuth token';          Re = [regex]'gho_[A-Za-z0-9]{30,}' },
    @{ Name = 'GitHub fine-grained PAT';     Re = [regex]'github_pat_[A-Za-z0-9_]{50,}' },
    @{ Name = 'Slack bot token';             Re = [regex]'xoxb-[A-Za-z0-9\-]{20,}' },
    @{ Name = 'Slack user token';            Re = [regex]'xoxp-[A-Za-z0-9\-]{20,}' },
    @{ Name = 'AWS access key id';           Re = [regex]'\bAKIA[0-9A-Z]{16}\b' },
    @{ Name = 'Stripe live key';             Re = [regex]'sk_live_[A-Za-z0-9]{20,}' },
    @{ Name = 'JWT';                         Re = [regex]'\beyJ[A-Za-z0-9_\-]{10,}\.[A-Za-z0-9_\-]{10,}\.[A-Za-z0-9_\-]{10,}\b' },
    @{ Name = 'PEM private key';             Re = [regex]'-----BEGIN (?:RSA |EC |DSA |OPENSSH |ENCRYPTED )?PRIVATE KEY-----' }
)

# --- User-specific path detection ---
$userAllowlist = @(
    'Public','Default','default','me','you','user','username','admin','root',
    'developer','dev','example','placeholder','runner','actions-runner',
    'vscode','node','ContainerAdministrator','ContainerUser'
)
$userAllowAlt = ($userAllowlist | ForEach-Object { [regex]::Escape($_) }) -join '|'
$userPathRe = [regex]"(?:C:\\Users\\|/Users/|/home/)(?!(?:$userAllowAlt)\b|<[^>]+>|your[\-_]|example[\-_])[A-Za-z][A-Za-z0-9._\-]+"

# --- Secret-shaped assignment detection ---
# Matches: secret_key = "longvalue" / api_key: 'longvalue' / password="longvalue"
# Captures: $1 = key name, $2 = value
$secretAssignRe = [regex]"(?i)\b(client_secret|api[_-]?key|access[_-]?token|refresh[_-]?token|private[_-]?key|password|passwd|bearer[_\s-]*token|auth[_-]?token)\b\s*[:=]\s*[`"']([A-Za-z0-9_+/=.\-]{16,})[`"']"

# Allowlist for the captured value: placeholders, examples, common dummy values.
$valuePlaceholderRe = [regex]'(?i)^(?:your[_-]?|example[_-]?|placeholder|change[_-]?me|dummy|sample|fake|test[_-]?only|x{4,}|<.+>|sk-fake|ghp_fake|redacted)'

# --- File / directory skip lists ---
$skipFilesExact = @(
    'LICENSE',
    'scripts/secrets-check.ps1',
    '.gitignore',
    '.gitattributes',
    'package-lock.json',
    'pnpm-lock.yaml',
    'poetry.lock',
    'yarn.lock'
)
$skipDirRe   = [regex]'(^|[\\/])(samples|references|node_modules|\.venv|input|output|\.git)([\\/]|$)'
$binaryExtRe = [regex]'(?i)\.(png|jpg|jpeg|gif|ico|pdf|docx|doc|xlsx|xls|zip|tar|gz|exe|dll|bin|jar|woff|woff2|ttf|otf)$'

$maxFileSize = 5MB
$totalViolations = 0

foreach ($filePath in $Files) {
    $file = $filePath
    if (-not (Test-Path $filePath -ErrorAction SilentlyContinue)) {
        $candidate = Join-Path $root $filePath
        if (Test-Path $candidate -ErrorAction SilentlyContinue) {
            $file = $candidate
        } else { continue }
    }

    $item = Get-Item -LiteralPath $file -ErrorAction SilentlyContinue
    if (-not $item -or $item.PSIsContainer) { continue }
    if ($item.Length -gt $maxFileSize) { continue }

    $relPath = $file.Replace("$root\","").Replace("$root/","")
    $relForward = $relPath -replace '\\', '/'

    if ($skipFilesExact -contains $relForward) { continue }
    if ($relPath -match $skipDirRe) { continue }
    if ($relPath -match $binaryExtRe) { continue }

    try {
        $content = Get-Content -LiteralPath $file -ErrorAction Stop
    } catch { continue }
    if (-not $content) { continue }

    $fileViolations = @()

    for ($i = 0; $i -lt $content.Count; $i++) {
        $line = $content[$i]
        $lineNum = $i + 1

        # Token / shape patterns
        foreach ($tp in $tokenPatterns) {
            if ($tp.Re.IsMatch($line)) {
                $fileViolations += "  Line $lineNum [$($tp.Name)]: $($line.Trim())"
            }
        }

        # User-specific paths
        if ($userPathRe.IsMatch($line)) {
            $fileViolations += "  Line $lineNum [user-specific path]: $($line.Trim())"
        }

        # Secret-shaped assignments (apply value allowlist)
        foreach ($m in $secretAssignRe.Matches($line)) {
            $value = $m.Groups[2].Value
            if ($valuePlaceholderRe.IsMatch($value)) { continue }
            $key = $m.Groups[1].Value
            $preview = if ($value.Length -gt 12) { $value.Substring(0,8) + '...' } else { $value }
            $fileViolations += "  Line $lineNum [secret '$key' = $preview]: $($line.Trim())"
        }
    }

    if ($fileViolations.Count -gt 0) {
        Write-Host "VIOLATIONS in $relPath ($($fileViolations.Count)):"
        $fileViolations | ForEach-Object { Write-Host $_ }
        $totalViolations += $fileViolations.Count
    }
}

if ($totalViolations -gt 0) {
    Write-Host ""
    Write-Host "[secrets-check] FAILED: $totalViolations violation(s) found."
    Write-Host ""
    Write-Host "Move secrets, MCP registration paths, and SSO/login tokens out of tracked files."
    Write-Host "  - Use environment variables or '~/.claude.json' (user scope) instead of repo files."
    Write-Host "  - Replace user-specific paths with placeholders like '<you>' or '<full path>'."
    Write-Host "  - If a flag is a false positive, refine the pattern or extend the allowlist in scripts/secrets-check.ps1."
    exit 1
} else {
    Write-Host "[secrets-check] No secrets, tokens, or user-specific paths detected in scanned files."
    exit 0
}

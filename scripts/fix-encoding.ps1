param([string]$File)

$bytes = [System.IO.File]::ReadAllBytes($File)
$content = [System.Text.Encoding]::UTF8.GetString($bytes)

# Fix mojibaked Harvey balls
$ctrl8F = [char]0x008F
$content = $content.Replace("â - $ctrl8F", [char]0x25CF)  # ●
$content = $content.Replace([string]([char]0x00E2) + " - " + [char]0x2022, [string][char]0x25D5)  # ◕
$content = $content.Replace([string]([char]0x00E2) + " - " + [char]0x2018, [string][char]0x25D1)  # ◑
$content = $content.Replace([string]([char]0x00E2) + " - " + [char]0x201C, [string][char]0x25D4)  # ◔
$content = $content.Replace([string]([char]0x00E2) + " - " + [char]0x2039, [string][char]0x25CB)  # ○

# Also try the literal text patterns from terminal output
$content = $content.Replace("â - •", [string][char]0x25D5)   # ◕
$content = $content.Replace("â - '", [string][char]0x25D1)   # ◑ 
$content = $content.Replace("â - ‹", [string][char]0x25CB)   # ○

# Fix mojibaked em dashes
$content = $content.Replace("â€"", " -")

# Write back as UTF-8
[System.IO.File]::WriteAllText($File, $content, (New-Object System.Text.UTF8Encoding $true))
Write-Host "Fixed encoding in $File"

# Verify Harvey balls
$has_filled = $content.Contains([string][char]0x25CF)
$has_3q = $content.Contains([string][char]0x25D5)
$has_half = $content.Contains([string][char]0x25D1)
$has_1q = $content.Contains([string][char]0x25D4)
$has_empty = $content.Contains([string][char]0x25CB)
Write-Host "● present: $has_filled"
Write-Host "◕ present: $has_3q"
Write-Host "◑ present: $has_half"
Write-Host "◔ present: $has_1q"
Write-Host "○ present: $has_empty"

# Check for remaining mojibake
$remaining = ([regex]::Matches($content, 'â')).Count
Write-Host "Remaining 'â' chars: $remaining"

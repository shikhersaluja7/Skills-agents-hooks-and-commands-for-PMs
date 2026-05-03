# convert-docx.ps1 — Batch convert all .docx files under Sample Data/ to .md using pandoc
# Usage: .\scripts\convert-docx.ps1
# Prerequisites: pandoc installed (winget install JohnMacFarlane.Pandoc)

$root = Join-Path $PSScriptRoot ".." "Sample Data"
$docxFiles = Get-ChildItem -Path $root -Filter "*.docx" -Recurse

if ($docxFiles.Count -eq 0) {
    Write-Host "No .docx files found under $root"
    exit 0
}

Write-Host "Found $($docxFiles.Count) .docx files to convert."

$converted = 0
$skipped = 0

foreach ($file in $docxFiles) {
    $mdPath = [System.IO.Path]::ChangeExtension($file.FullName, ".md")

    if (Test-Path $mdPath) {
        Write-Host "  SKIP (already exists): $($file.Name)"
        $skipped++
        continue
    }

    Write-Host "  Converting: $($file.Name)"
    & pandoc $file.FullName -f docx -t markdown --wrap=none -o $mdPath 2>&1

    if ($LASTEXITCODE -eq 0) {
        $converted++
    } else {
        Write-Warning "  FAILED: $($file.Name)"
    }
}

Write-Host "`nDone. Converted: $converted, Skipped: $skipped, Total: $($docxFiles.Count)"

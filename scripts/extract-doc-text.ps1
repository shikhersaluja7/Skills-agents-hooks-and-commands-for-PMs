<#
    extract-doc-text.ps1 - Extract text from .doc/.docx files using Word COM
    Saves as .md files next to the originals.
#>
param([string]$InputDir)

$root = Split-Path $PSScriptRoot -Parent
if (-not [System.IO.Path]::IsPathRooted($InputDir)) {
    $InputDir = Join-Path $root $InputDir
}

$word = New-Object -ComObject Word.Application
$word.Visible = $false

try {
    Get-ChildItem $InputDir -Filter "*.docx" | Where-Object { $_.Name -notmatch '_real|_copy|_converted' } | ForEach-Object {
        $src = $_.FullName
        $mdPath = [System.IO.Path]::ChangeExtension($src, ".md")
        Write-Host "Extracting text: $($_.Name)"
        
        $doc = $word.Documents.Open($src)
        $text = $doc.Content.Text
        $doc.Close([ref]$false)
        
        # Basic markdown formatting: split paragraphs
        $text = $text -replace "`r`n", "`n"
        $text = $text -replace "`r", "`n"
        
        Set-Content $mdPath $text -Encoding UTF8
        Write-Host "  -> $([System.IO.Path]::GetFileName($mdPath)) ($($text.Length) chars)"
    }
} finally {
    $word.Quit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
}

Write-Host "Done."

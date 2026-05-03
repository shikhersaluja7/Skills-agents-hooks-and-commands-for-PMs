<#
    convert-ole-doc.ps1 - Convert OLE2 .doc files to proper .docx using Word COM
    Usage: .\scripts\convert-ole-doc.ps1 -InputDir "input/Blog-input"
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
        $dst = $src -replace '\.docx$', '_real.docx'
        Write-Host "Converting: $($_.Name)"
        $doc = $word.Documents.Open($src)
        $doc.SaveAs2([ref]$dst, [ref]12)  # 12 = wdFormatXMLDocument (.docx)
        $doc.Close([ref]$false)
        Write-Host "  -> $([System.IO.Path]::GetFileName($dst))"
    }
} finally {
    $word.Quit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
}

Write-Host "Done."

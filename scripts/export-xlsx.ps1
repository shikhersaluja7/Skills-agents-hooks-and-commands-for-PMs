<#
.SYNOPSIS
  Convert a CSV file under output/ to .xlsx using openpyxl (via Python).

.DESCRIPTION
  Wraps `python` + `openpyxl` to convert a `.csv` file into a `.xlsx` workbook with one
  sheet named after the source file. Used standalone or invoked by the /export-xlsx skill.
  Mirrors `scripts/export-docx.ps1` shape and parameters.

.PARAMETER File
  Path to a .csv file. Required unless -Auto is used.

.PARAMETER Auto
  Auto-detect the most-recently-modified .csv under output/.

.PARAMETER Output
  Optional explicit output path. Default: same path with .csv replaced by .xlsx.

.EXAMPLE
  scripts\export-xlsx.ps1 -File output\reports\monthly-spend.csv

.EXAMPLE
  scripts\export-xlsx.ps1 -Auto
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

# Verify python is on PATH
$pythonCmd = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCmd) {
  Write-Error "python not found on PATH. Install Python 3.9+ and ensure pip can install openpyxl."
  exit 2
}

# Verify openpyxl is importable
$openpyxlCheck = & python -c "import openpyxl; print('ok')" 2>&1
if ($LASTEXITCODE -ne 0) {
  Write-Error "openpyxl not installed. Run 'pip install openpyxl' (already a dependency of scripts/translate-inputs.py)."
  exit 2
}

# Resolve input
if ($Auto) {
  $candidates = Get-ChildItem -Path 'output' -Recurse -Filter '*.csv' -File -ErrorAction SilentlyContinue
  if (-not $candidates) {
    Write-Error "No .csv files found under output/."
    exit 1
  }
  $InputFile = ($candidates | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
  Write-Host "[export-xlsx] Auto-detected: $InputFile"
} else {
  if (-not (Test-Path -LiteralPath $File -PathType Leaf)) {
    Write-Error "File not found: $File"
    exit 1
  }
  $InputFile = (Resolve-Path -LiteralPath $File).Path
}

if (-not $InputFile.ToLower().EndsWith('.csv')) {
  Write-Error "Expected a .csv file, got: $InputFile"
  exit 1
}

# Resolve output path
if ($Output) {
  $OutputFile = $Output
} else {
  $OutputFile = [System.IO.Path]::ChangeExtension($InputFile, '.xlsx')
}

# Ensure output directory exists
$OutputDir = Split-Path -Parent $OutputFile
if ($OutputDir -and -not (Test-Path -LiteralPath $OutputDir)) {
  New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Build the Python conversion script as a here-string. Reads the CSV, writes a single-sheet xlsx.
$pyScript = @'
import sys, csv, os
from openpyxl import Workbook

src = sys.argv[1]
dst = sys.argv[2]
sheet_name = os.path.splitext(os.path.basename(src))[0][:31]  # Excel sheet name max 31 chars

wb = Workbook()
ws = wb.active
ws.title = sheet_name

with open(src, "r", encoding="utf-8-sig", newline="") as f:
    reader = csv.reader(f)
    for row in reader:
        ws.append(row)

wb.save(dst)
print(f"WROTE {dst}")
'@

# Write the python script to a temp file (avoids shell-escaping pitfalls)
$tempPy = New-TemporaryFile
$tempPyPath = $tempPy.FullName + '.py'
Move-Item -LiteralPath $tempPy.FullName -Destination $tempPyPath -Force
try {
  Set-Content -LiteralPath $tempPyPath -Value $pyScript -Encoding UTF8

  Write-Host "[export-xlsx] python openpyxl '$InputFile' -> '$OutputFile'"
  & python $tempPyPath $InputFile $OutputFile
  if ($LASTEXITCODE -ne 0) {
    Write-Error "python conversion failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
  }
} finally {
  if (Test-Path -LiteralPath $tempPyPath) { Remove-Item -LiteralPath $tempPyPath -Force }
}

$size = (Get-Item -LiteralPath $OutputFile).Length
Write-Host "[export-xlsx] Wrote $OutputFile ($size bytes)"
exit 0

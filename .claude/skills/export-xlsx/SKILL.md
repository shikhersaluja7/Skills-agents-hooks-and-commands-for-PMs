---
name: export-xlsx
description: "Convert a saved CSV file to an Excel .xlsx workbook for sharing or analysis in Excel. Use when: export to xlsx, generate excel, convert csv to excel, share spreadsheet, save as excel, send to excel, csv to xlsx, excel export."
argument-hint: "Optional path to a single .csv file under output/. If omitted, the most-recently-modified .csv under output/ is auto-detected."
---

# Export Xlsx - CSV to Excel Workbook

Convert a CSV file saved under `output/` to an `.xlsx` workbook so it can be opened in Excel, formatted, charted, or circulated. Wraps `scripts/export-xlsx.ps1` (which uses Python + openpyxl) behind a PM-friendly slash command.

Follow the **PM-in-the-Loop Contract** and the **File Format Policy** from workspace instructions. Confirm before writing any file.

## How You Work

### 1. Resolve the input

If the PM supplied a path:
- Source must be a `.csv` file under `output/`. Refuse other extensions or sources outside `output/`.

If no argument:
- Auto-detect the most-recently-modified `.csv` under `output/` and confirm with the PM before proceeding.

### 2. Confirm before converting

Show the PM:
- The resolved input path.
- The planned `.xlsx` output path (default: same path with `.csv` replaced by `.xlsx`).

Wait for the PM to approve ("yes", "go", "convert", "save").

### 3. Convert

Run `scripts/export-xlsx.ps1 -File <input>.csv`. The script writes the `.xlsx` next to the source.

If openpyxl is missing the script returns exit 2 with a message telling the PM to run `pip install openpyxl`. Surface that message and stop.

### 4. Report

Tell the PM:
- The output path.
- File size.
- A suggested next move: open in Excel, share with reviewer, or use the `office-excel` MCP later if installed for richer downstream interaction.

## Inputs

- One `.csv` file under `output/`.
- Optional explicit output path passed through the script's `-Output` parameter.

## Outputs

- A single-sheet `.xlsx` workbook next to the source `.csv`. Sheet name is derived from the source filename (truncated to Excel's 31-char limit).

## Rules

- Refuse sources outside `output/`. Reason: enforces the workspace File Format Policy that converts only happen on approved native artifacts.
- Never overwrite or modify the source `.csv`.
- The resulting `.xlsx` is gitignored (it lives under `output/`, which is local-only by workspace rule).
- Do not auto-produce `.xlsx` alongside `.csv` from any other skill. This skill (and the Stop hook prompt) are the only paths to `.xlsx` generation.

## Common Use Cases

| Use case | Invocation |
|---|---|
| Single artifact for review | `/export-xlsx output/reports/monthly-spend.csv` |
| Auto-most-recent (after a skill saves a CSV) | `/export-xlsx` |
| Custom output path | Pass `-Output <path>` to the script directly |

## Related

- **Stop hook** (`scripts/docx-prompt.ps1`) auto-detects fresh `.csv` saves under `output/` and prompts Claude to offer this skill. Mute with `CLAUDE_SKILLS_DOCX_PROMPT=off`.
- **`/export-docx` skill** is the parallel slash command for `.md` / `.txt` -> `.docx` via Pandoc.
- **`office-excel` MCP server** (optional, registered via `claude mcp add`) gives Claude richer ability to read and write Excel files directly. The File Format Policy in `CLAUDE.md` describes when each path is the right choice.

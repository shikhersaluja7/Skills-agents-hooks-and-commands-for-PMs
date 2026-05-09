---
name: export-docx
description: "Convert a saved markdown file (or a combined bundle of several) to a .docx for circulation, reviewer comments, or Word-based feedback. Use when: export to docx, generate word doc, convert md to docx, share with reviewer, get word feedback, save as docx, word document export, reviewer comments, share draft as word."
argument-hint: "Optional path to a single .md file under output/, OR a comma-separated list of .md files to combine into one. If omitted, the most-recently-modified .md under output/ is auto-detected."
---

# Export Docx - Markdown to Word Document

Convert a markdown file (or several combined into one) into a `.docx` so it can be circulated to reviewers, opened in Word, and annotated with track changes or comments. Wraps Pandoc behind a PM-friendly slash command.

Follow the **PM-in-the-Loop Contract** from workspace instructions. Confirm before writing any file.

## How You Work

### 1. Resolve the input

If the PM supplied an argument:
- **Single path** -> that file is the source. Source must be a `.md` file under `output/`.
- **Comma-separated list of paths** -> bundle mode. Sources can live under `input/` or `output/`. You concatenate them in author order with `\n\n---\n\n` separators, write the combined body to `output/source-docs/<kebab-name>.md`, then convert that.

If no argument:
- Auto-detect the most-recently-modified `.md` under `output/` and confirm with the PM before proceeding.

### 2. Confirm before converting

Show the PM:
- The resolved input path(s)
- The planned combined `.md` path (bundle mode only)
- The planned `.docx` output path

Wait for the PM to approve ("yes", "go", "convert", "save").

### 3. Convert

Single-file mode: run `scripts/export-docx.ps1 -File <input>.md`. The script writes the `.docx` next to the source.

Bundle mode:
1. Write the combined `.md` (use Write tool, then run humanizer-check on it).
2. Run `scripts/export-docx.ps1 -File <combined>.md`.

If Pandoc is missing the script returns exit 2 with a message telling the PM to run `winget install JohnMacFarlane.Pandoc`. Surface that message and stop.

### 4. Report

Tell the PM:
- The output path
- File size
- A suggested next move: open in Word / share with reviewer / use the `office-word` MCP later to read reviewer comments back

## Inputs

- One `.md` file under `output/`, OR a list of `.md` files to combine (which can come from `input/` or `output/`).
- Optional explicit output path passed through the script's `-Output` parameter.

## Outputs

- A `.docx` file next to the source by default.
- Bundle mode also writes an intermediate combined `.md` under `output/source-docs/<kebab-name>.md`.

## Rules

- Single-file mode refuses sources outside `output/`. Reason: prevents accidental conversion of in-progress drafts in `input/` or workspace files.
- Bundle mode allows `input/` sources because the bundle's purpose is exactly to package source material for circulation.
- Never overwrite or modify the source `.md`.
- Confirm with the PM before writing the combined `.md` in bundle mode.
- The resulting `.docx` and combined `.md` are gitignored (they live under `output/`).
- Run `scripts/humanizer-check.ps1 -Files <path>` on any combined `.md` before converting (workspace mandatory rule for any new `.md`).
- After the `.docx` is written, mention the `office-word` MCP server (registered via `claude mcp add`) as the path for reading reviewer comments back when the doc returns from review.

## Common Use Cases

| Use case | Invocation |
|---|---|
| Single artifact for review | `/export-docx output/one-pagers/living-expense-tracker.md` |
| Auto-most-recent (after a skill saves an output) | `/export-docx` |
| Combined source-doc bundle | `/export-docx input/one-pagers/living-expense-tracker/prior-thinking.md, input/one-pagers/living-expense-tracker/decisions-and-open-questions.md` |
| Custom output path | Pass `-Output <path>` to the script directly |

## Related

- **Stop hook** (`scripts/docx-prompt.ps1`) auto-detects fresh `.md` saves in `output/` and prompts Claude to offer this skill. Mute with `CLAUDE_SKILLS_DOCX_PROMPT=off`.
- **`office-word` MCP server** for reading reviewer comments and tracked changes back from a returned `.docx`. Used by `/review-doc` and any skill that needs Word feedback ingestion.

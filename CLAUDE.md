# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Working on This Repository

The two sections below cover what a Claude session needs to know when *editing this repo* (skills, scripts, hooks, docs). The rules further down (PM-in-the-Loop, humanizer, style guide) apply when *running skills* on behalf of a PM. Both modes coexist.

### Dual-ecosystem layout

The repo maintains two parallel skill ecosystems and keeps them in sync:

- `.github/skills/<name>/SKILL.md` - Copilot skill (slash command in GHCP Chat)
- `.github/agents/<name>.agent.md` - Copilot agent with tool restrictions (5 agents: skill-improver, frontend-developer, backend-developer, tester, ideation)
- `.github/prompts/<name>.prompt.md` - Slash-command alias for an agent (e.g., `/improve-skill` -> `@skill-improver-ghcp`)
- `.claude/skills/<name>/SKILL.md` - Claude skill, mirroring the GHCP side
- `CLAUDE.md` <-> `.github/copilot-instructions.md` - workspace instructions, mirrored

`scripts/sync-skills.ps1` keeps these aligned. The Copilot agent <-> Claude skill mapping for the 5 dev/research agents is special: each side keeps its own frontmatter, only the body content is synced. Agent frontmatter has `tools` and `user-invocable`; Claude skill frontmatter has `name: <name>-claude` and `description`.

**Edit one side only.** The pre-commit hook handles the other side. Don't manually duplicate changes.

### The hook pipeline

`.githooks/pre-commit` runs four steps in order. If any fails, the commit aborts:

1. `scripts/sync-skills.ps1 -Apply -Staged` - Mirror any drift between `.github/` and `.claude/`. Stages updated files into the commit.
2. `scripts/update-docs.ps1 -Apply -Staged` - Regenerate the `<!-- SKILL-TABLE-START -->` tables in README, both user guides, and both onboarding docs, plus the `<!-- PLAN-SKILLS-START -->` inventory table in `PLAN.md`. Regenerate the `<!-- REVIEW-DOC-TYPES-START -->` table in `review-doc/SKILL.md`. Auto-seed missing per-skill mini-sections in user guides via `Ensure-SkillSections` (see below).
3. `scripts/humanizer-check.ps1` on staged `.md` files - block banned words, banned phrases, banned starters, em dashes.
4. `scripts/secrets-check.ps1` on every staged file (any extension) - block credentials, MCP/SSO/login tokens, and user-specific paths from leaking into tracked content. Patterns include token prefixes (`sk-`, `ghp_`, `xoxb-`, `AKIA`, JWT, PEM private keys), concrete user home paths (`C:\Users\<actual>`, `/Users/<actual>`, `/home/<actual>`), and secret-shaped assignments (`api_key="..."`, `client_secret: "..."`). Allowlist covers placeholders (`<you>`, `your-...`, `example-...`), generic accounts (`Public`, `Default`, `runner`), `LICENSE`, lockfiles, and the script itself. Run audit-mode with `scripts/secrets-check.ps1 -All`.

`.githooks/pre-push` runs verify-only versions of the same four steps against `$UPSTREAM..HEAD` files. It blocks the push if any drift, doc-staleness, humanizer, or secrets violation is found rather than auto-fixing.

Required one-time setup after cloning: `git config core.hooksPath .githooks`.

### Common commands

```powershell
# Dry-run: show what would change without modifying files
.\scripts\sync-skills.ps1
.\scripts\update-docs.ps1

# Apply changes (drops -Staged when running outside a commit)
.\scripts\sync-skills.ps1 -Apply
.\scripts\update-docs.ps1 -Apply

# Humanizer check on specific files
scripts/humanizer-check.ps1 -Files "path/to/file.md","path/to/other.md"

# Secrets check (audit every tracked file)
scripts/secrets-check.ps1 -All

# Convert non-markdown inputs (.docx, .xlsx, .csv, .html, .json) to .md
python scripts/translate-inputs.py input/<type>/<project>/
```

There are no automated tests in this repo. The "test" for any change is: run the four scripts dry, then the apply-able ones with `-Apply`, and confirm a second run reports zero changes (idempotent). The secrets check has no `-Apply` mode by design - violations require human review.

### Adding a skill, agent, or prompt

1. Create `.github/skills/<new-name>/SKILL.md` (or `.github/agents/<name>.agent.md`, or `.github/prompts/<name>.prompt.md`) with the right frontmatter. The SKILL.md `description` field needs `Use when: keyword1, keyword2, ...` so the LLM router can match it.
2. Commit. The pre-commit hook:
   - Creates the matching `.claude/skills/<new-name>/SKILL.md` (with `name: <new-name>-claude` for facade agents).
   - Adds the row to every skill table.
   - Auto-seeds an editable mini-section stub in both user guides between `<!-- SKILL-SECTION-START: <name> -->` and `<!-- SKILL-SECTION-END: <name> -->` markers. Replace the stub with a real walkthrough when ready; the script never modifies content between existing markers.

If a new agent gets a slash-command alias (like `improve-skill` for `skill-improver`), add an entry to `$agentPromptAlias` in `update-docs.ps1` so the alias appears in the GHCP table. Without that map entry, only the `@<name>-ghcp` form shows.

If a new artifact's user-facing coverage is grouped with peers in a shared section (like the dev agents in user-guide section 8), add its name to `$artifactsCoveredWithoutMarkers` in `update-docs.ps1` to suppress the auto-stub.

### PowerShell 5.1 gotchas

- **`Set-Content -Encoding UTF8` emits a BOM.** Always write files with `[System.IO.File]::WriteAllText($path, $content, (New-Object System.Text.UTF8Encoding $false))`. README.md and `.github/copilot-instructions.md` previously broke when the script BOM-corrupted them.
- **`BaseName` strips only the last extension.** For `improve-skill.prompt.md`, `BaseName` is `improve-skill.prompt`. Strip the trailing `.prompt` explicitly.
- **`.githooks/*` and `*.sh` are locked to LF endings via `.gitattributes`.** Git for Windows' `/bin/sh` cannot spawn hooks with CRLF in the shebang. If you write a hook from PowerShell, run `dos2unix` or use `[System.IO.File]::WriteAllText` with `\n` line endings, then `chmod +x`.
- **The sync script normalizes line endings before comparing** (`scripts/sync-skills.ps1`). Don't add byte-comparison shortcuts back in - that re-introduces false-positive drift on Windows.

### Where things live

- `scripts/` - all automation. Pipeline scripts: `sync-skills.ps1`, `update-docs.ps1`, `humanizer-check.ps1`, `secrets-check.ps1`. Input conversion: `translate-inputs.py`, plus the `convert-*.ps1`, `extract-doc-text.ps1`, and `*-encoding.*` helpers for legacy/OLE/mojibake cases. Output conversion: `export-docx.ps1`, `export-xlsx.ps1`, `md-to-pdf.py`, and the `docx-prompt.ps1` Stop hook.
- `.githooks/` - git hooks (pre-commit, pre-push). Activated via `git config core.hooksPath .githooks`.
- `.github/hooks/sync-skills.json` - Copilot PostToolUse hook (re-runs sync after Copilot edits).
- `.claude/settings.json` - Claude Stop hook (re-runs sync after a Claude session ends).
- `docs/` - user-facing docs. `ghcp-user-guide.md` and `claude-user-guide.md` are the primary entry points; the two `*-cowork-onboarding.md` files mirror their tables for cowork-specific onboarding.
- `input/` and `output/` - PM workspace. Both gitignored; created locally per project.
- `CONTRIBUTING.md` - contributor entry point (the four contribution categories and manual-run commands). `PLAN.md` - auto-generated skill/agent/script inventory with status; do not hand-edit its `<!-- PLAN-SKILLS -->` table.

---

# PM Skills - Workspace Instructions

These instructions apply to every skill, command, agent, hook, and workflow in this workspace. They are loaded automatically by GitHub Copilot (via `.github/copilot-instructions.md`) and Claude (via `CLAUDE.md`).

---

## PM-in-the-Loop Contract

Every skill in this workspace follows the PM-in-the-Loop principle:

1. **The PM decides.** The agent ideates, researches, and drafts. The PM makes all final decisions. Nothing is saved to a file until the PM explicitly approves.
2. **Decision points are flagged.** When the agent needs PM judgment (priority, wording, scope, strategy), it marks the spot with `> **PM Decision Required:** <what needs deciding and why>`.
3. **Assumptions are marked.** When the agent fills in missing information, it marks it with `> **Assumption:** <what was assumed and why>`.
4. **Research is opt-in.** The agent offers to research competitors, market context, or best practices. The PM decides what to include. Never auto-include research findings.
5. **Drafts are shown in chat first.** The agent shows the full draft in chat with a `## DRAFT - Awaiting PM Approval` header. Only after the PM approves does the agent save the file.

---

## Humanized Writing Standard

All generated content must follow these rules to eliminate AI-sounding patterns.

### Banned Words
Never use: delve, leverage, utilize, robust, seamless, cutting-edge, holistic, synergy, paradigm shift, unprecedented, game-changing, groundbreaking, next-level, state-of-the-art, innovative approach, myriad, vast majority, constellation of, intricate tapestry.

### Banned Phrases
Never use: "it's important to note", "it should be noted", "in terms of", "at the end of the day", "in today's world", "moving forward".

### Banned Paragraph Starters
Avoid starting paragraphs with: However, Furthermore, Moreover, Therefore, In conclusion, Interestingly, As mentioned, Additionally, Consequently, Nevertheless.

### Structural Rules
- No em dashes or en dashes. Use a single dash ( - ) instead.
- Vary paragraph lengths. Never make every paragraph the same size (3-4 sentences uniformly).
- Use contractions in blogs and user guides (don't, won't, it's). Avoid them in specs and one-pagers.
- No formulaic intro/conclusion patterns. Don't start with "In today's rapidly evolving landscape..."
- No throat-clearing openings. Start with the problem, the capability, or the instruction.

---

## Mandatory Humanizer Check

**This rule applies globally to every skill, command, agent, and workflow in this workspace.**

After saving or creating ANY `.md` file (output, skill, command, hook, agent, README, PLAN, instructions, docs, user guides, onboarding docs, or any other markdown file), you MUST automatically run the humanizer check script on the saved file:

```
scripts/humanizer-check.ps1 -Files "<saved-file-path>"
```

Do NOT suggest running humanizer as a follow-up. Do NOT ask the user if they want to run it. Run it automatically every time.

If the script reports violations (banned words, banned phrases, banned starters), fix them by **rewording only** - never delete sentences, paragraphs, or content. Replace the banned word or phrase with a natural alternative that preserves the original meaning. Re-run the check until it passes. Report the results to the PM:
- If clean: "Humanizer check passed."
- If violations were found and fixed: list what was changed and what it was changed to.

**Critical: No content deletion.** Fixing a humanizer violation means substituting words, not removing text. Every sentence in the original must remain in the fixed version.

---

## File Format Policy

**This rule applies globally to every skill, command, agent, and workflow in this workspace.**

The repo separates *native, code-friendly* formats (`.md`, `.csv`, `.json`, `.txt`) from *Office sharing* formats (`.docx`, `.xlsx`, `.pptx`). Native is always the source of truth. Office formats are optional, secondary, and explicit. The policy has two sub-rules: one for inputs the PM hands a skill, one for outputs a skill produces.

### Input ingestion (B.1)

When a skill needs to ingest a non-markdown file (`.docx`, `.pptx`, `.xlsx`, `.pdf`, `.csv`, `.html`, `.json`, etc.), follow check-decide-dispatch. Do not ask the PM redundant questions when only one path is possible.

1. **Detect** the file format.
2. **Check what is available** this session:
   - Is an MCP for that format registered AND callable? (`office-word` for `.docx`, `office-powerpoint` for `.pptx`, `office-excel` for `.xlsx`.)
   - Is `scripts/translate-inputs.py` able to convert this format? (Handles `.docx`, `.xlsx`, `.csv`, `.html`, `.json`. Does NOT handle `.pptx`.)
3. **Decide and dispatch:**
   - **Both paths available** (MCP installed AND converter handles this format): **ask the PM** which to use. Save the answer for the duration of the skill invocation so a multi-file batch does not re-ask.
   - **Only MCP available** (e.g. `.pptx`): proceed with the MCP automatically. No question. Surface a single FYI line: "Read [file] directly via the `office-<format>` MCP - no converter fallback exists for this format."
   - **Only converter available** (MCP not installed for this format): **proceed with conversion automatically.** No question. After the conversion, surface a single FYI line: "Converted [file] via translate-inputs.py. Installing the `office-<format>` MCP gives a richer ingestion (slide layouts, formulas, comments, etc.). See README's Optional Office MCPs if you want it." One mention per skill invocation, not per file.
   - **Neither path available** (legacy `.ppt`, `.xls`, or unsupported format): tell the PM, list the options (install an MCP, convert externally with Office or LibreOffice, paste the content), and wait for direction.

**Autonomous mode** (PM is AFK, skill running with PM-stand-in): when both options exist, default to the converter path because `translate-inputs.py` is the always-works baseline. Surface the deferred choice in the handoff summary so the PM can re-run with their preferred mode if they wanted MCP-direct.

**Do not** silently auto-convert when an MCP is available - that is the case where the PM gets to choose. The legacy "non-md input always auto-triggers translate-inputs.py" behavior is retired by this policy. Auto-convert remains correct *only* when the MCP path is unavailable, and even then the FYI nudge keeps the PM informed of the upgrade path.

### Output generation (B.2)

Skills save artifacts in native, code-friendly formats by default: `.md` for prose, `.csv` for tabular data, `.json` for structured data, `.txt` for plain notes. The native file is the source of truth. It flows into version control, downstream skills, and code that consumes the artifact.

Conversion to Office formats (`.docx`, `.xlsx`) is **optional, secondary, and explicit**. It happens **only after the PM has approved the native artifact** and either explicitly asks for the conversion or accepts the offer surfaced by the Stop hook. Skills do not auto-produce Office-format outputs alongside the native file at save time.

Conversion paths:
- `.md` or `.txt` -> `.docx` via `scripts/export-docx.ps1` or the `/export-docx` slash command (Pandoc).
- `.csv` -> `.xlsx` via `scripts/export-xlsx.ps1` or the `/export-xlsx` slash command (openpyxl, or the `office-excel` MCP if installed).

The Stop hook (`scripts/docx-prompt.ps1`) detects fresh `.md`, `.txt`, and `.csv` saves under `output/` and emits a system-reminder offering the relevant Office export. Mute via the existing `CLAUDE_SKILLS_DOCX_PROMPT=off` environment variable (covers all formats this hook scans).

**Why native-first:** the artifacts in `output/` feed code workflows, version control diffs, and downstream skill ingestion. Native formats (`.md`, `.csv`, `.txt`, `.json`) are diffable, scriptable, and parseable without Office. Office formats are for circulation to human reviewers; they should follow approval, not lead it.

---

## Sharing Output as Office Formats

The discoverability hook for the File Format Policy's output side. Components in the repo:

- **Stop hook (`scripts/docx-prompt.ps1`)** - fires when Claude finishes a turn and detects any `.md`, `.txt`, or `.csv` saved under `output/` within the last 90 seconds. The hook emits a system-reminder so Claude offers the PM the right Office export per format. Mute with environment variable `CLAUDE_SKILLS_DOCX_PROMPT=off`.

- **Slash command `/export-docx`** - explicit invocation for `.md` or `.txt` -> `.docx`. Bundle mode supports combining several source files into one Word doc. Wraps `scripts/export-docx.ps1`, which calls Pandoc.

- **Slash command `/export-xlsx`** - explicit invocation for `.csv` -> `.xlsx`. Wraps `scripts/export-xlsx.ps1`, which uses Python + openpyxl.

- **Office MCP servers (optional)** - `office-word`, `office-powerpoint`, `office-excel`, all registered via `claude mcp add`. Let skills like `/review-doc` ingest reviewer comments and tracked changes back from returned Office files. Pure Python (python-docx, python-pptx, openpyxl); no M365 subscription or MS Office install required. See README's Optional section for install commands.

Generated Office files live next to their native source under `output/` (gitignored). Pandoc must be installed for `.docx` export (`winget install JohnMacFarlane.Pandoc`). The Office MCPs are `office-word-mcp-server`, `office-powerpoint-mcp-server`, and `excel-mcp-server` from PyPI.

---

## Writing Style Guide

**This rule applies globally to every skill, command, agent, and workflow in this workspace.**

Every document type has its own voice and tonality, defined in [.github/style-guide.md](.github/style-guide.md). The style guide is extracted from real team-authored samples and captures the writing patterns that make each document type sound right.

Before generating any output, read the style guide section for the relevant document type and match its tone:
- **Blog posts:** Authoritative product narrator. Confident, direct, product-proud without being promotional.
- **Specs:** Precise technical author. Definitive language, atomic acceptance criteria, empathetic personas.
- **One-pagers:** Strategic PM pitching to leadership. Business-oriented, data-backed, phased scope.
- **User guides:** Friendly instructor. Warm, action-oriented, present tense, "you" throughout.

This is not optional. Tonality mismatches (e.g., blog voice in a spec, or spec voice in a user guide) are treated as quality issues.

---

## Continuous Skill Improvement

**This rule applies globally to every skill, command, agent, and workflow in this workspace.**

Skills get better over time through PM feedback. The agent supports this cycle without ever auto-modifying skill files.

### Tracking Recurring Feedback
When a PM gives the same correction across multiple sessions (e.g., "always include competitive context in one-pagers" or "the blog intro is too generic every time"), the agent should:
1. Note the pattern in the current session.
2. Suggest adding the correction as a permanent rule to the relevant skill: "You've asked for this in multiple sessions. Want me to propose adding this as a rule to the build-one-pager skill via `/improve-skill`?"
3. Never auto-modify a skill. Always propose changes through the skill-improver-claude agent and wait for PM approval.

### Quality Self-Check
After generating any draft (before presenting to the PM for approval), every skill should run a brief self-evaluation:
- Does this draft fully address all inputs the PM provided?
- Are there sections that feel thin or could use more depth?
- Were any PM decisions or assumptions left unresolved?
- What would make this draft stronger if generated again?

Surface any concerns alongside the draft. This is not a gate - the PM still sees and approves the draft. It's a transparency step that helps the PM catch issues faster.

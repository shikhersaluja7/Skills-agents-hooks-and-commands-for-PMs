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

`.githooks/pre-commit` runs three steps in order. If any fails, the commit aborts:

1. `scripts/sync-skills.ps1 -Apply -Staged` - Mirror any drift between `.github/` and `.claude/`. Stages updated files into the commit.
2. `scripts/update-docs.ps1 -Apply -Staged` - Regenerate the `<!-- SKILL-TABLE-START -->` tables in README, both user guides, and both onboarding docs. Regenerate the `<!-- REVIEW-DOC-TYPES-START -->` table in `review-doc/SKILL.md`. Auto-seed missing per-skill mini-sections in user guides via `Ensure-SkillSections` (see below).
3. `scripts/humanizer-check.ps1` on staged `.md` files - block banned words, banned phrases, banned starters, em dashes.

`.githooks/pre-push` runs verify-only versions of the same three steps against `$UPSTREAM..HEAD` markdown files. It blocks the push if any are out of sync rather than auto-fixing.

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

# Convert non-markdown inputs (.docx, .xlsx, .csv, .html, .json) to .md
python scripts/translate-inputs.py input/<type>/<project>/
```

There are no automated tests in this repo. The "test" for any change is: run the three scripts dry, then again with `-Apply`, and confirm `-Apply` is idempotent (a second run reports zero changes).

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

- `scripts/` - all automation. `sync-skills.ps1`, `update-docs.ps1`, `humanizer-check.ps1`, `translate-inputs.py`.
- `.githooks/` - git hooks (pre-commit, pre-push). Activated via `git config core.hooksPath .githooks`.
- `.github/hooks/sync-skills.json` - Copilot PostToolUse hook (re-runs sync after Copilot edits).
- `.claude/settings.json` - Claude Stop hook (re-runs sync after a Claude session ends).
- `docs/` - user-facing docs. `ghcp-user-guide.md` and `claude-user-guide.md` are the primary entry points; the two `*-cowork-onboarding.md` files mirror their tables for cowork-specific onboarding.
- `input/` and `output/` - PM workspace. Both gitignored; created locally per project.

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

## Sharing Drafts as .docx

Many PM artifacts get circulated to reviewers who prefer Word documents (track changes, inline comments, formal review). The repo supports this with three components:

- **Stop hook (`scripts/docx-prompt.ps1`)** - fires when Claude finishes a turn and detects any `.md` saved under `output/` within the last 90 seconds. The hook emits a system-reminder so Claude offers the PM an optional `.docx` export. Mute with environment variable `CLAUDE_SKILLS_DOCX_PROMPT=off`.

- **Slash command `/export-docx`** - explicit invocation when the PM doesn't want to wait for the hook or wants to bundle multiple source files into one combined Word doc. Wraps `scripts/export-docx.ps1`, which calls Pandoc.

- **`office-word` MCP server** - registered with Claude Code via `claude mcp add`. Lets `/review-doc` (and any other skill) read reviewer comments and tracked changes back from a returned `.docx`. Use it when feedback comes in.

Generated `.docx` files live next to their source `.md` under `output/` (gitignored by default). Pandoc must be installed for export to work (`winget install JohnMacFarlane.Pandoc`). The MCP server is `office-word-mcp-server` from PyPI (`pip install office-word-mcp-server`).

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

# Onboarding PM Skills to Claude Cowork (VS Code Extension)

This guide covers how to set up and use PM Skills with the Claude Cowork extension in VS Code. Claude Cowork brings Claude Code into VS Code as an integrated chat panel. If your team uses Claude Cowork, this guide shows you how the skills work, what loads automatically, and how to keep Copilot users in sync.

---

## Table of Contents

1. [What is Claude Cowork?](#1-what-is-claude-cowork)
2. [Prerequisites](#2-prerequisites)
3. [Setting Up the Workspace](#3-setting-up-the-workspace)
4. [Using the Skills](#4-using-the-skills)
5. [How Skills Load and Execute](#5-how-skills-load-and-execute)
6. [Using Development Agents](#6-using-development-agents)
7. [The Skill-Improver Skill](#7-the-skill-improver-skill)
8. [Hooks and Automation](#8-hooks-and-automation)
9. [Keeping Copilot Users in Sync](#9-keeping-copilot-users-in-sync)
10. [Adding or Editing Skills](#10-adding-or-editing-skills)
11. [Troubleshooting](#11-troubleshooting)
12. [Frequently Asked Questions](#12-frequently-asked-questions)

---

## 1. What is Claude Cowork?

Claude Cowork is Anthropic's VS Code extension. It provides the same Claude Code capabilities you'd get from the terminal, but embedded in the VS Code interface as a chat panel. It reads the same configuration files as the Claude Code CLI: `CLAUDE.md` for workspace instructions, `.claude/skills/` for skills, and `.claude/settings.json` for hooks.

If you've used Claude Code in the terminal with this repo, the experience in Cowork is identical. Same skills, same instructions, same outputs.

---

## 2. Prerequisites

### What you need installed

| Tool | How to install | Required? |
|------|---------------|-----------|
| VS Code | [code.visualstudio.com](https://code.visualstudio.com/) | Yes |
| Claude Cowork extension | VS Code Marketplace | Yes |
| Git | `winget install Git.Git` | Yes |
| PowerShell 5.1+ | Pre-installed on Windows. `brew install powershell` on macOS. | Yes (runs sync and humanizer scripts) |
| Python 3.9+ | `winget install Python.Python.3.11` | Only for .docx/.xlsx/.html input conversion |
| Python packages | `pip install openpyxl beautifulsoup4 requests markdownify mammoth` | Only if Python is installed |
| Pandoc | `winget install JohnMacFarlane.Pandoc` | Only for .docx conversion |

A Claude subscription (Pro, Team, or Enterprise) or an Anthropic Console account is also needed. The PM Skills repository should be cloned locally.

---

## 3. Setting Up the Workspace

### Clone and open

1. Clone the PM Skills repository.
2. Open the folder in VS Code.
3. Open the Claude Cowork panel from the VS Code sidebar.

### Enable the sync hook (one time)

Run this once in your terminal after cloning:

```
git config core.hooksPath .githooks
```

### What Claude Cowork reads on startup

When Cowork opens the workspace, it automatically loads:

- **`CLAUDE.md`** (repo root). Contains the PM-in-the-Loop contract and Humanized Writing Standard. These rules apply to every interaction, not just skill invocations.
- **`.claude/skills/`** directory. Each subfolder with a `SKILL.md` becomes an available skill. Claude discovers them by reading the `description` field in each SKILL.md's frontmatter.
- **`.claude/settings.json`**. Configures the Stop hook that runs the sync script when your session ends.

You don't register or import skills. Drop a folder into `.claude/skills/` with a valid SKILL.md and it's live.

---

## 4. Using the Skills

### Invoke with slash commands

Type `/` in the Cowork chat to see available skills:

<!-- SKILL-TABLE-START -->
| Command | What it does |
|---------|-------------|
| `/backend-developer-claude` | Senior backend engineer and systems architect |
| `/build-agentic-experience` | Build agentic workflow artifacts for conversational AI: scenario catalogs, journey scripts, or evaluation datasets |
| `/build-announcement-email` | Draft an announcement email for product launches, previews, breaking changes, product updates, or stakeholder enablement |
| `/build-architecture` | Create an architecture document (HLD or LLD) from strategy docs, one-pagers, specs, or meeting transcripts |
| `/build-blog` | Draft a blog post for your community blog, your engineering blog, or LinkedIn |
| `/build-compete` | Generate competitive analysis or scorecard comparing your product against competitors |
| `/build-customer-story` | Write a customer story from meeting transcripts and PM inputs |
| `/build-demo-script` | Write a demo script for product walkthroughs, conference talks, leadership reviews, or feature deep dives |
| `/build-documentation` | Write your documentation platform-style public documentation from specs, one-pagers, blogs, or transcripts |
| `/build-golden-dataset` | Generate a golden evaluation dataset from product inputs and user personas |
| `/build-mbr` | Write a monthly business review document with hypothesis-driven analysis |
| `/build-one-pager` | Write a one-pager document for leadership and partner teams |
| `/build-spec` | Build, refine, or review product specifications |
| `/build-strategy-doc` | Write an exec-ready strategy document for leadership and cross-org reviews |
| `/build-user-guide` | Write a customer-facing user guide or product walkthrough |
| `/build-user-research` | Build a customer validation research kit: hypotheses, survey, and interview guide |
| `/frontend-developer-claude` | Senior frontend engineer and UI architect |
| `/ideation-claude` | Deep research and ideation partner for PMs |
| `/review-doc` | Review any document for completeness, critical gaps, and alternative approaches |
| `/skill-improver-claude` | Analyze and improve Copilot skills using web research and best practices (Claude) |
| `/tester-claude` | Senior QA engineer and test architect |
<!-- SKILL-TABLE-END -->

### Invoke with natural language

Skip the slash command if you prefer. Describe your task in plain language:

```
I need to write a spec for the new migration agent feature based on this one-pager
```

Claude matches your request to the build-spec skill based on keywords in the description field.

### The PM-in-the-Loop flow

Every skill follows the same pattern:

1. Asks what source material you have (one-pager, spec, transcript, docs, mockups, freeform)
2. Asks clarifying questions (skipping anything your input already covered)
3. Offers optional web research (you decide what to include)
4. Generates a draft labeled `DRAFT - Awaiting PM Approval`
5. Flags items needing your judgment with `PM Decision Required`
6. Saves to `output/<type>/` only after you say "approve", "save", or "looks good"

### Building a user research kit

The `/build-user-research` skill generates up to three connected artifacts in a gated flow: a hypotheses list, an unmoderated survey, and a moderated interview guide. You choose which artifacts to produce (hypotheses only, hypotheses + survey, all three, or interview guide only from existing survey data). Each artifact builds on the previous one, and you approve each before the skill proceeds.

Drop source material into `input/user-research/<project-name>/`, invoke the skill, and answer 9 clarifying questions. The final question lets you pick your artifact combination. Outputs save to `output/user-research/`.

Every hypothesis gets an ID (H1, H2...) that traces through survey questions and interview questions. When you provide survey analysis results, the interview guide calibrates probing depth per hypothesis: brief for confirmed, deep for partial, and exploratory for rejected findings.

---

## 5. How Skills Load and Execute

Claude Cowork loads skills progressively, similar to how GitHub Copilot handles them:

1. **Discovery.** Claude scans `.claude/skills/` and reads the `name` and `description` from each SKILL.md frontmatter. This is lightweight, roughly 100 tokens per skill.
2. **Instruction loading.** When a skill is relevant (either because you invoked it or Claude matched your request to its description), the full SKILL.md body loads into context.
3. **Resource loading.** Files in the `references/` subfolder (templates, examples) load only when the skill body references them.

With 6 skills installed, the discovery overhead is under 1000 tokens. The full instruction set for any single skill is under 5000 tokens. Reference files load on demand.

---

## 6. Using Development Agents

Three development agents are available for coding tasks directly in Claude Cowork. Each is a senior engineer with spec-driven workflows and safety guardrails.

| Agent | Command | What it does |
|-------|---------|-------------|
| **Frontend Developer** | `/frontend-developer` | Builds UI components, implements designs, enforces accessibility (WCAG 2.1 AA) |
| **Backend Developer** | `/backend-developer` | Builds APIs, database schemas, microservices with OWASP security |
| **Tester** | `/tester` | Writes unit/integration/E2E tests, analyzes coverage, security testing |

### Giving them a spec

```
/frontend-developer Build the dashboard component from the spec in input/specs/dashboard/
```

The agent reads the spec, flags unclear requirements, and writes code. It also accepts design mocks, API contracts, and screenshots as input.

### Safety guarantees

All agents block OWASP Top 10 violations, privacy issues (no PII in logs), and dark patterns (confirmshaming, hidden costs). These are non-negotiable.

### Inter-agent collaboration

Agents invoke each other as subagents. Frontend asks Backend to propose API contracts. Backend asks Tester for test cases. Results are shown to you for approval.

---

## 7. The Skill-Improver Skill

On the Claude side, skill-improver is a skill (not an agent, since Claude's skill format doesn't support agents with tool restrictions).

```
/skill-improver build-blog
```

It reads the target skill's SKILL.md and reference files, searches the web for current best practices in that domain, and presents a structured report: what works well, gaps found, specific changes recommended with rationale and sources.

You decide which improvements to apply. The skill edits files only after your approval.

On the Copilot side, the same workflow exists as an agent (`@skill-improver-claude`) with tool restrictions (`read, search, edit, web`). The sync hook keeps both versions' instructions aligned while each side retains its own frontmatter.

---

## 8. Hooks and Automation

### Claude Stop hook

Configured in `.claude/settings.json`:

```json
{
  "hooks": {
    "Stop": [
      {
        "type": "command",
        "command": "powershell -NoProfile -ExecutionPolicy Bypass -File ./scripts/sync-skills.ps1 -Apply",
        "timeout": 30
      }
    ]
  }
}
```

When your Cowork session ends, the sync script runs and updates any `.github/skills/` files that fell behind. This ensures your edits reach Copilot users on the next git pull.

### Git pre-commit hook

On every `git commit`, `.githooks/pre-commit` runs the sync script with the `-Staged` flag. Out-of-sync files are copied, updated, and included in your commit automatically. This is the primary guarantee that both `.claude/skills/` and `.github/skills/` stay identical.

### What gets synced

| Claude side | Copilot side | Method |
|---|---|---|
| `CLAUDE.md` | `.github/copilot-instructions.md` | Full file copy, newer wins |
| `.claude/skills/<name>/` | `.github/skills/<name>/` | Full file plus references, newer wins |
| `.claude/skills/skill-improver/SKILL.md` | `.github/agents/skill-improver.agent.md` | Body content synced, frontmatter preserved |

---

## 9. Keeping Copilot Users in Sync

If your team has PMs on GitHub Copilot or M365 Copilot, the sync automation keeps them aligned:

- **During your session:** The Stop hook runs when Cowork closes, syncing local files.
- **On commit:** The pre-commit hook stages both `.claude/skills/` and `.github/skills/` versions. Teammates pulling from git get both.
- **From the Copilot side:** A PostToolUse hook (`.github/hooks/sync-skills.json`) syncs from Copilot to Claude when Copilot users edit files.

The result: edit on one platform, commit, push. Everyone gets the update regardless of which tool they use.

---

## 10. Adding or Editing Skills

### Editing a skill

1. Open `.claude/skills/<skill-name>/SKILL.md` in VS Code.
2. Make your changes.
3. Commit. The pre-commit hook copies changes to `.github/skills/<skill-name>/`.

### Creating a new skill

1. Create `.claude/skills/<your-skill-name>/SKILL.md`:
   ```yaml
   ---
   name: your-skill-name
   description: "What it does. Use when: keyword 1, keyword 2."
   argument-hint: "Input the PM provides"
   ---
   ```
2. Add the skill instructions (follow the PM-in-the-Loop workflow pattern).
3. Optionally add `references/` with templates or examples.
4. Commit. The hook creates `.github/skills/<your-skill-name>/` for Copilot users.

### Updating workspace instructions

Edit `CLAUDE.md` at the repo root. Commit. The hook syncs to `.github/copilot-instructions.md`.

---

## 11. Troubleshooting

**Skills don't show up when I type `/`.**
Verify `.claude/skills/` contains subfolders with valid SKILL.md files. Each SKILL.md needs a `name` that matches the folder name and a `description` in the frontmatter.

**CLAUDE.md rules aren't being followed.**
Make sure `CLAUDE.md` is at the repo root (not inside `.claude/`). Claude reads it from the root of the workspace directory.

**The sync hook doesn't fire on commit.**
Run `git config core.hooksPath` and check it returns `.githooks`. If it returns nothing or a different path, run `git config core.hooksPath .githooks`.

**A skill generates content with em dashes or banned words.**
The Humanized Writing Standard is in `CLAUDE.md`. Check that it hasn't been accidentally modified. Run `.\scripts\sync-skills.ps1` to verify it matches `.github/copilot-instructions.md`.

**Sync runs but nothing changes.**
Both sides are already in sync. The script only copies when files differ. Run it in dry-run mode (`.\scripts\sync-skills.ps1` without `-Apply`) to confirm.

---

## 12. Frequently Asked Questions

**Q: Is Claude Cowork VS Code the same as Claude Code terminal?**
Same engine, different interface. Cowork runs Claude Code inside VS Code as a chat panel. `CLAUDE.md`, `.claude/skills/`, and `.claude/settings.json` work identically in both.

**Q: Do I need to install skills separately for Cowork?**
No. Clone the repo, open the folder in VS Code, and the skills are available. Claude discovers them from `.claude/skills/` on startup.

**Q: Can I use terminal Claude Code and Cowork on the same repo?**
Yes. They read the same files. Skills, settings, and hooks work in both. You can switch between them freely.

**Q: The build-spec skill references a template. Where does it come from?**
Templates live in `.claude/skills/build-spec/references/spec-template.md`. Claude loads reference files when the SKILL.md body points to them with relative paths like `[template](./references/spec-template.md)`.

**Q: My teammate uses Copilot. Will their skill edits show up for me?**
Yes, after they commit and push. The pre-commit hook on their side staged both `.github/skills/` and `.claude/skills/` into the same commit. When you pull, you get the Claude-side copy.

**Q: Can I override the Humanized Writing Standard for one guide?**
Add the override in the specific skill's SKILL.md body. Skill-level instructions take precedence over `CLAUDE.md` for that workflow.

**Q: Where are generated files saved?**
All outputs go to `output/<type>/`: `output/specs/`, `output/blogs/`, `output/user-guides/`. These folders are gitignored since outputs are project-specific.

---

*PM Skills are workflow aids for artifact generation. Decisions on acceptance criteria, strategic positioning, and evaluation logic are always yours.*

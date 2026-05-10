# Onboarding PM Skills to M365 Copilot (Cowork)

This guide covers how to set up and use PM Skills with M365 Copilot in VS Code. If you're using M365 Copilot as your coding agent (instead of or alongside GitHub Copilot), the skills in this repo work out of the box. This guide explains the setup, what to expect, and how to maintain skill parity with Claude users on your team.

---

## Table of Contents

1. [What is M365 Copilot in VS Code?](#1-what-is-m365-copilot-in-vs-code)
2. [Prerequisites](#2-prerequisites)
3. [Setting Up the Workspace](#3-setting-up-the-workspace)
4. [Using the Skills](#4-using-the-skills)
5. [How Skills Load and Execute](#5-how-skills-load-and-execute)
6. [Development Agents](#6-development-agents)
7. [Agents, Prompts, and Hooks](#7-agents-prompts-and-hooks)
8. [Keeping Claude Users in Sync](#8-keeping-claude-users-in-sync)
9. [Adding or Editing Skills](#9-adding-or-editing-skills)
10. [Troubleshooting](#10-troubleshooting)
11. [Frequently Asked Questions](#11-frequently-asked-questions)

---

## 1. What is M365 Copilot in VS Code?

M365 Copilot in VS Code uses the same Agent Skills standard as GitHub Copilot. Skills stored in `.github/skills/` are portable across GitHub Copilot, M365 Copilot, Copilot CLI, and the Copilot coding agent. If you've used GitHub Copilot with this repo, the experience is identical.

The Agent Skills standard is an open specification (agentskills.io) that defines how AI agents discover, load, and use skill folders. Any tool that supports this standard can use the skills in this repo without modification.

---

## 2. Prerequisites

### What you need installed

| Tool | How to install | Required? |
|------|---------------|-----------|
| VS Code | [code.visualstudio.com](https://code.visualstudio.com/) | Yes |
| M365 Copilot or GitHub Copilot extension | VS Code Marketplace | Yes (either one works, they share skill infrastructure) |
| Git | `winget install Git.Git` | Yes |
| PowerShell 5.1+ | Pre-installed on Windows. `brew install powershell` on macOS. | Yes (runs sync and humanizer scripts) |
| Python 3.9+ | `winget install Python.Python.3.11` | Only for .docx/.xlsx/.html input conversion |
| Python packages | `pip install openpyxl beautifulsoup4 requests markdownify mammoth` | Only if Python is installed |
| Pandoc | `winget install JohnMacFarlane.Pandoc` | Only for .docx conversion |

Agent mode must be enabled in the Copilot Chat panel. The PM Skills repository should be cloned locally.

If you already have GitHub Copilot working with these skills, M365 Copilot picks up the same `.github/skills/` folder. No additional configuration is required.

---

## 3. Setting Up the Workspace

### Clone and open

1. Clone the PM Skills repository to your machine.
2. Open the folder in VS Code (`File > Open Folder`).
3. Open the Copilot Chat panel from the sidebar.

### Enable the sync hook (one time)

```
git config core.hooksPath .githooks
```

This activates a pre-commit hook that keeps the `.github/skills/` and `.claude/skills/` folders synchronized. Even if you only use M365 Copilot, this matters because teammates on Claude Code need to stay aligned.

### What loads automatically

When VS Code opens the workspace, M365 Copilot reads:

- `.github/copilot-instructions.md` for workspace-level instructions (the PM-in-the-Loop contract and Humanized Writing Standard)
- `.github/skills/` for all available skill definitions
- `.github/agents/` for the skill-improver agent
- `.github/prompts/` for the improve-skill slash command
- `.github/hooks/` for the PostToolUse sync hook

You don't need to configure or register any of these. VS Code discovers them from the folder structure.

---

## 4. Using the Skills

Type `/` in the chat input to see all available skills:

<!-- SKILL-TABLE-START -->
| Command | What it does |
|---------|-------------|
| `@backend-developer-ghcp` | Senior backend engineer and systems architect (GHCP) |
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
| `/export-docx` | Convert a saved markdown file (or a combined bundle of several) to a .docx for circulation, reviewer comments, or Word-based feedback |
| `/export-xlsx` | Convert a saved CSV file to an Excel .xlsx workbook for sharing or analysis in Excel |
| `@frontend-developer-ghcp` | Senior frontend engineer and UI architect (GHCP) |
| `@ideation-ghcp` | Deep research and ideation partner for PMs (GHCP) |
| `/review-doc` | Review any document for completeness, critical gaps, and alternative approaches |
| `@skill-improver-ghcp` or `/improve-skill` | Analyze and improve Copilot skills using web research and best practices (GHCP) |
| `@tester-ghcp` | Senior QA engineer and test architect (GHCP) |
<!-- SKILL-TABLE-END -->

You can also select `@skill-improver-ghcp` from the agent picker to invoke the skill improvement agent directly.

Every skill follows the PM-in-the-Loop workflow: gather inputs, ask questions, optional web research, generate a draft labeled `DRAFT - Awaiting PM Approval`, flag decision points, and save only after you approve.

### Quick example

```
/build-spec your product wave planning for sequencing workload migrations
```

The skill asks what source material you have (one-pager, transcript, telemetry data, etc.), asks clarifying questions, generates an 11-section spec, and waits for your approval before saving to `output/specs/`.

### Building a user research kit

The `/build-user-research` skill generates up to three connected artifacts in a gated flow: a hypotheses list, an unmoderated survey, and a moderated interview guide. You choose which artifacts to produce (hypotheses only, hypotheses + survey, all three, or interview guide only from existing survey data). Each artifact builds on the previous one, and you approve each before the skill proceeds.

Drop source material into `input/user-research/<project-name>/`, invoke the skill, and answer 9 clarifying questions. The final question lets you pick your artifact combination. Outputs save to `output/user-research/`.

Every hypothesis gets an ID (H1, H2...) that traces through survey questions and interview questions. When you provide survey analysis results, the interview guide calibrates probing depth per hypothesis: brief for confirmed, deep for partial, and exploratory for rejected findings.

---

## 5. How Skills Load and Execute

Skills use progressive loading to keep your context efficient:

1. **Discovery.** The agent reads the `name` and `description` fields from each SKILL.md frontmatter. This costs roughly 100 tokens per skill. With 6 skills installed, that's about 600 tokens of discovery overhead.
2. **Instructions loading.** When you invoke a skill (or the agent decides it's relevant based on your request), it loads the full SKILL.md body. Each skill body is under 5000 tokens.
3. **Resource access.** Reference files (templates, examples) in the `references/` subfolder load only when the skill explicitly references them during execution.

This means you can install dozens of skills without bloating every conversation. Only the relevant skill loads its full instructions.

---

## 6. Development Agents

Three specialized development agents are available for coding tasks. Each is a senior engineer that accepts specs and writes production-quality code.

| Agent | Invocation | What it does |
|-------|-----------|-------------|
| **Frontend Developer** | `@frontend-developer-ghcp` | Builds UI components, implements designs, enforces accessibility (WCAG 2.1 AA) |
| **Backend Developer** | `@backend-developer-ghcp` | Builds APIs, database schemas, microservices with OWASP security |
| **Tester** | `@tester-ghcp` | Writes unit/integration/E2E tests, analyzes coverage, security testing |

Select an agent from the agent picker, then give it a spec or describe the feature to build. All agents enforce security (OWASP Top 10), privacy (no PII in logs), and accessibility (WCAG 2.1 AA) by default. They refuse to write code with dark patterns.

Agents can invoke each other as subagents for collaborative work (negotiating API contracts, generating test cases). Handoff buttons appear after each response for manual transitions between agents.

---

## 7. Agents, Prompts, and Hooks

Beyond skills and development agents, this repo includes:

### Agent: skill-improver

Located at `.github/agents/skill-improver.agent.md`. This is a specialized agent with restricted tools (`read, search, edit, web`). It analyzes skills and suggests improvements based on web research. Invoke it via `@skill-improver-ghcp` in the agent picker or through the `/improve-skill` prompt.

### Prompt: improve-skill

Located at `.github/prompts/improve-skill.prompt.md`. This is a slash command alias that delegates to the skill-improver agent. Type `/improve-skill build-spec` to analyze the build-spec skill.

### Hook: sync-skills

Located at `.github/hooks/sync-skills.json`. This Copilot hook triggers `scripts/sync-skills.ps1` after file edits (PostToolUse event). If M365 Copilot modifies a skill file during your session, the Claude-side copy updates immediately.

---

## 8. Keeping Claude Users in Sync

Your team may have PMs using Claude Code or Claude Cowork instead of (or alongside) M365 Copilot. The repo maintains parity through three sync layers:

| Trigger | When it runs | What it syncs |
|---------|-------------|---------------|
| Git pre-commit hook | Every `git commit` | All skills, agents, instructions |
| Copilot PostToolUse hook | After file edits in Copilot | Skills and references |
| Claude Stop hook | When a Claude session ends | Skills and references |

The sync script (`scripts/sync-skills.ps1`) copies newer files from `.github/skills/` to `.claude/skills/` and vice versa. It also syncs `.github/copilot-instructions.md` with `CLAUDE.md` at the repo root, and keeps the skill-improver agent body aligned with its Claude skill equivalent.

You edit on whatever platform you use. The hooks handle cross-platform distribution.

---

## 9. Adding or Editing Skills

### Editing

Open `.github/skills/<skill-name>/SKILL.md` and make your changes. Commit. The pre-commit hook syncs to `.claude/skills/`.

### Creating a new skill

1. Create `.github/skills/<your-skill-name>/SKILL.md`:
   ```yaml
   ---
   name: your-skill-name
   description: "What it does. Use when: keyword 1, keyword 2."
   argument-hint: "What the PM provides"
   ---
   ```
2. Write instructions following the PM-in-the-Loop pattern (gather inputs, clarify, research, draft, approve, save).
3. Optionally add `references/` with templates.
4. Commit. The hook creates `.claude/skills/<your-skill-name>/` for Claude users.

### Updating workspace instructions

Edit `.github/copilot-instructions.md` and commit. The hook syncs to `CLAUDE.md`.

---

## 10. Troubleshooting

**Skills don't appear when I type `/`.**
Check that the `.github/skills/` folder exists and each skill has a valid `SKILL.md` with `name` and `description` in the frontmatter. The `name` must match the folder name.

**The sync hook doesn't run on commit.**
Verify `git config core.hooksPath` returns `.githooks`. If not, run `git config core.hooksPath .githooks`.

**A skill loads but produces generic output.**
The skill's instructions might not have loaded fully. Try invoking it directly with `/build-spec` instead of relying on keyword matching. Direct invocation forces the full SKILL.md to load.

**The agent picker doesn't show @skill-improver-ghcp.**
Check that `.github/agents/skill-improver.agent.md` exists and has `user-invocable: true` in the frontmatter.

---

## 11. Frequently Asked Questions

**Q: Is there any difference between M365 Copilot and GitHub Copilot for these skills?**
No. Both use the same Agent Skills standard, read from `.github/skills/`, and follow the same discovery and loading process. The skills are portable across both platforms.

**Q: Do I need both `.github/skills/` and `.claude/skills/`?**
If you only use M365 Copilot, you only need `.github/skills/`. The `.claude/skills/` folder exists for teammates using Claude Code. The sync hook keeps both folders aligned so you don't have to think about it.

**Q: Can I use these skills in Copilot CLI?**
Yes. The Agent Skills standard works across VS Code, CLI, and the coding agent. If you run Copilot CLI in a checkout of this repo, it discovers the skills from `.github/skills/`.

**Q: How do I check what's installed?**
Type `/skills` in the chat input to open the Configure Skills menu. Or browse `.github/skills/` in the file explorer.

**Q: My teammate edited a skill in Claude Code. How do I get the update?**
Pull the latest from git. The pre-commit hook on their side staged both the `.claude/skills/` and `.github/skills/` versions into the same commit. When you pull, you get the `.github/skills/` copy automatically.

---

*PM Skills are workflow aids, not decision-makers. Acceptance criteria, sizing logic, and strategic positioning are always the PM's call.*

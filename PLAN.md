# PM Skills - Plan and Inventory

This document tracks every skill, agent, command, hook, and script in the repo, along with its current status. It's auto-updated by `scripts/update-docs.ps1` on every commit.

## Skills

Skills are the core PM workflows. Each skill lives in `.github/skills/<name>/SKILL.md` (Copilot) and `.claude/skills/<name>/SKILL.md` (Claude), kept in sync by `sync-skills.ps1`.

<!-- PLAN-SKILLS-START -->
| Skill | Command | Description | Status |
|-------|---------|-------------|--------|
| **backend-developer** | `@backend-developer-ghcp` | Senior backend engineer and systems architect (GHCP) | Ready to use |
| **backend-developer-claude** | `/backend-developer-claude` | Senior backend engineer and systems architect | Ready to use |
| **build-agentic-experience** | `/build-agentic-experience` | Build agentic workflow artifacts for conversational AI: scenario catalogs, journey scripts, or evaluation datasets | Ready to use |
| **build-announcement-email** | `/build-announcement-email` | Draft an announcement email for product launches, previews, breaking changes, product updates, or stakeholder enablement | Ready to use |
| **build-architecture** | `/build-architecture` | Create an architecture document (HLD or LLD) from strategy docs, one-pagers, specs, or meeting transcripts | Ready to use |
| **build-blog** | `/build-blog` | Draft a blog post for your community blog, your engineering blog, or LinkedIn | Ready to use |
| **build-compete** | `/build-compete` | Generate competitive analysis or scorecard comparing your product against competitors | Ready to use |
| **build-customer-story** | `/build-customer-story` | Write a customer story from meeting transcripts and PM inputs | Ready to use |
| **build-demo-script** | `/build-demo-script` | Write a demo script for product walkthroughs, conference talks, leadership reviews, or feature deep dives | Ready to use |
| **build-documentation** | `/build-documentation` | Write your documentation platform-style public documentation from specs, one-pagers, blogs, or transcripts | Ready to use |
| **build-golden-dataset** | `/build-golden-dataset` | Generate a golden evaluation dataset from product inputs and user personas | Ready to use |
| **build-mbr** | `/build-mbr` | Write a monthly business review document with hypothesis-driven analysis | Ready to use |
| **build-one-pager** | `/build-one-pager` | Write a one-pager document for leadership and partner teams | Ready to use |
| **build-spec** | `/build-spec` | Build, refine, or review product specifications | Ready to use |
| **build-strategy-doc** | `/build-strategy-doc` | Write an exec-ready strategy document for leadership and cross-org reviews | Ready to use |
| **build-user-guide** | `/build-user-guide` | Write a customer-facing user guide or product walkthrough | Ready to use |
| **build-user-research** | `/build-user-research` | Build a customer validation research kit: hypotheses, survey, and interview guide | Ready to use |
| **export-docx** | `/export-docx` | Convert a saved markdown file (or a combined bundle of several) to a .docx for circulation, reviewer comments, or Word-based feedback | Ready to use |
| **export-xlsx** | `/export-xlsx` | Convert a saved CSV file to an Excel .xlsx workbook for sharing or analysis in Excel | Ready to use |
| **frontend-developer** | `@frontend-developer-ghcp` | Senior frontend engineer and UI architect (GHCP) | Ready to use |
| **frontend-developer-claude** | `/frontend-developer-claude` | Senior frontend engineer and UI architect | Ready to use |
| **ideation** | `@ideation-ghcp` | Deep research and ideation partner for PMs (GHCP) | Ready to use |
| **ideation-claude** | `/ideation-claude` | Deep research and ideation partner for PMs | Ready to use |
| **review-doc** | `/review-doc` | Review any document for completeness, critical gaps, and alternative approaches | Ready to use |
| **skill-improver** | `@skill-improver-ghcp` | Analyze and improve Copilot skills using web research and best practices (GHCP) | Ready to use |
| **skill-improver-claude** | `/skill-improver-claude` | Analyze and improve Copilot skills using web research and best practices (Claude) | Ready to use |
| **tester** | `@tester-ghcp` | Senior QA engineer and test architect (GHCP) | Ready to use |
| **tester-claude** | `/tester-claude` | Senior QA engineer and test architect | Ready to use |
<!-- PLAN-SKILLS-END -->

## Agents

Agents exist on both platforms with structural asymmetry:
- **GHCP agents** (`.github/agents/<name>.agent.md`) have tool restrictions and inherit workspace instructions automatically. Invoked with `@name`.
- **Claude sub-agents** (`.claude/agents/<name>.md`) run in isolated context and do NOT inherit `CLAUDE.md`. For skill-improver, the sub-agent is a thin facade that loads the full instructions from the corresponding Claude skill via the `skills:` frontmatter field.

The sync script keeps body content in sync between the GHCP agent and the Claude skill, then auto-regenerates the Claude agent facade on every sync.

| Agent | GHCP | Claude | Invocation | Description | Status |
|-------|------|--------|------------|-------------|--------|
| **ideation** | `.github/agents/ideation.agent.md` (tools: read/search/web) | `.claude/agents/ideation.md` (facade) + `.claude/skills/ideation/SKILL.md` | `@ideation-ghcp` | Deep research and ideation partner for PMs. 5 modes: Exploration, Validation, Competitive Intelligence, Trend Analysis, Deep Dive. | Ready to use |
| **skill-improver** | `.github/agents/skill-improver.agent.md` (tools: read/search/edit/web) | `.claude/agents/skill-improver.md` (facade) + `.claude/skills/skill-improver/SKILL.md` | `@skill-improver-ghcp` or `/improve-skill` | Reads an existing skill, researches best practices online, and suggests targeted improvements. | Ready to use |
| **frontend-developer** | `.github/agents/frontend-developer.agent.md` (tools: read/search/edit/terminal/web) | `.claude/agents/frontend-developer.md` (facade) + `.claude/skills/frontend-developer/SKILL.md` | `@frontend-developer-ghcp` | Senior frontend engineer. Spec-driven, WCAG 2.1 AA, dark pattern blocking, clickstop planning. | Ready to use |
| **backend-developer** | `.github/agents/backend-developer.agent.md` (tools: read/search/edit/terminal/web) | `.claude/agents/backend-developer.md` (facade) + `.claude/skills/backend-developer/SKILL.md` | `@backend-developer-ghcp` | Senior backend engineer. OWASP Top 10, API design, observability, clickstop planning. | Ready to use |
| **tester** | `.github/agents/tester.agent.md` (tools: read/search/edit/terminal/web) | `.claude/agents/tester.md` (facade) + `.claude/skills/tester/SKILL.md` | `@tester-ghcp` | Senior QA engineer. Testing pyramid (70/20/10), security testing, clickstop planning. | Ready to use |

## Prompt Commands

Prompt files (`.github/prompts/<name>.prompt.md`) are slash-command aliases that delegate to agents or skills.

| Command | Delegates To | Description | Status |
|---------|-------------|-------------|--------|
| `/improve-skill` | `@skill-improver-ghcp` agent | Shortcut to invoke the skill-improver agent. Accepts a skill name as argument (e.g., `/improve-skill build-spec`). | Ready to use |

## Hooks

Hooks are automations that run at specific trigger points to keep the repo consistent.

### Git Hooks

| Hook | Trigger | Description | Status |
|------|---------|-------------|--------|
| **pre-commit** | Every `git commit` | Three-step pipeline: (1) sync skills between `.github/` and `.claude/`, (2) auto-update skill tables in README and user guides (and this plan), (3) run humanizer check on staged `.md` files. Blocks commit if humanizer check fails. Located at `.githooks/pre-commit`. | Ready to use |

### Copilot Hooks

| Hook | Trigger | Description | Status |
|------|---------|-------------|--------|
| **sync-skills (PostToolUse)** | After Copilot uses `create_file`, `replace_string_in_file`, or `multi_replace_string_in_file` | Runs `sync-skills.ps1` then `update-docs.ps1` to keep both platforms and all docs in sync after every file edit. Defined in `.github/hooks/sync-skills.json`. | Ready to use |

### Claude Hooks

| Hook | Trigger | Description | Status |
|------|---------|-------------|--------|
| **Stop hook** | When Claude stops generating | Runs `sync-skills.ps1` then `update-docs.ps1` to sync platforms and docs after each Claude turn. Defined in `.claude/settings.json`. | Ready to use |

## Scripts

Automation scripts in `scripts/` that power hooks and utilities.

| Script | Description | Status |
|--------|-------------|--------|
| **sync-skills.ps1** | Bidirectional sync between `.github/` and `.claude/` skill artifacts. Syncs SKILL.md files, references/ folders, agent body content (GHCP agent to Claude skill), and workspace instructions (copilot-instructions.md to CLAUDE.md). Auto-regenerates Claude agent facades from skill metadata to account for platform asymmetry (GHCP agents inherit workspace instructions; Claude sub-agents don't). Uses last-modified-wins conflict resolution. Supports dry run, apply, and staged modes. | Ready to use |
| **update-docs.ps1** | Scans the live inventory of skills, agents, prompts, and hooks, then regenerates tables between marker comments in README.md, user guides, onboarding docs, and PLAN.md. Supports dry run, apply, and staged modes. | Ready to use |
| **humanizer-check.ps1** | Validates markdown files against the Humanized Writing Standard. Checks for em dashes, banned words/phrases, and overused paragraph starters. Used as the final gate in the pre-commit hook; blocks commit on violations. | Ready to use |
| **convert-docx.ps1** | Batch converts all `.docx` files under `Sample Data/` to `.md` using Pandoc. Skips files that already have a `.md` counterpart. | Ready to use |
| **translate-inputs.py** | Converts various input file formats (.docx, .xlsx, .csv, .html, .json, URLs) to markdown for skill consumption. Used by skills to auto-convert PM source material in input folders. Supports mammoth, openpyxl, beautifulsoup4, and markdownify. | Ready to use |

## Workspace Instructions

| File | Description | Status |
|------|-------------|--------|
| **.github/copilot-instructions.md** | Copilot workspace instructions. Contains the PM-in-the-Loop contract, Humanized Writing Standard, mandatory humanizer check rule, and writing style guide reference. Synced to CLAUDE.md. | Ready to use |
| **CLAUDE.md** | Claude workspace instructions. Auto-synced copy of `.github/copilot-instructions.md`. Should never be edited directly. | Ready to use |

## Docs

| Doc | Description | Status |
|-----|-------------|--------|
| **docs/ghcp-user-guide.md** | Getting started guide for using PM Skills with GitHub Copilot in VS Code. | Ready to use |
| **docs/claude-user-guide.md** | Getting started guide for using PM Skills with Claude Code (terminal). | Ready to use |
| **docs/m365-cowork-onboarding.md** | Onboarding guide for using PM Skills with M365 Copilot (Cowork) in VS Code. | Ready to use |
| **docs/claude-cowork-onboarding.md** | Onboarding guide for using PM Skills with Claude Cowork extension in VS Code. | Ready to use |

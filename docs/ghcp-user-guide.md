# PM Skills for GitHub Copilot: A Guide for your product PMs

This guide walks PMs on the your product team through using PM Skills in GitHub Copilot. You'll learn how to generate specs, blogs, and user guides from your source material, and how to update and extend the skills yourself.

---

## Table of Contents

1. [Getting Started](#1-getting-started)
2. [Using Skills to Generate Artifacts](#2-using-skills-to-generate-artifacts)
3. [Building a Spec](#3-building-a-spec)
4. [Reviewing and Refining a Spec](#4-reviewing-and-refining-a-spec)
5. [Writing a Blog Post](#5-writing-a-blog-post)
6. [Creating a User Guide](#6-creating-a-user-guide)
7. [Building a User Research Kit](#7-building-a-user-research-kit)
8. [Using Development Agents](#8-using-development-agents)
9. [Improving a Skill](#9-improving-a-skill)
10. [Updating or Adding Skills](#10-updating-or-adding-skills)
11. [How the Sync Automation Works](#11-how-the-sync-automation-works)
12. [Tips & Tricks](#12-tips--tricks)
13. [Frequently Asked Questions](#13-frequently-asked-questions)

---

## 1. Getting Started

### Prerequisites

- VS Code with the GitHub Copilot extension installed
### What you need installed

| Tool | How to install | Required? |
|------|---------------|-----------|
| VS Code | [code.visualstudio.com](https://code.visualstudio.com/) | Yes |
| GitHub Copilot extension | VS Code Marketplace: search `GitHub.copilot` and `GitHub.copilot-chat` | Yes |
| Git | `winget install Git.Git` | Yes |
| PowerShell 5.1+ | Pre-installed on Windows. `brew install powershell` on macOS. | Yes (runs sync and humanizer scripts) |
| Python 3.9+ | `winget install Python.Python.3.11` | Only if you use the input translation script for .docx, .xlsx, .html files |
| Python packages | `pip install openpyxl beautifulsoup4 requests markdownify mammoth` | Only if Python is installed |
| Pandoc | `winget install JohnMacFarlane.Pandoc` | Only for .docx conversion |

- Agent mode enabled in Copilot Chat (this is the default in recent versions)
- The PM Skills repository cloned locally

### Opening the workspace

1. Open VS Code.
2. Open the PM Skills repository folder (`File > Open Folder`).
3. Open Copilot Chat by clicking the Copilot icon in the sidebar or pressing `Ctrl+Shift+I`.

### One-time setup after cloning

Run these commands once in the terminal:

```bash
# Required: enable the sync hook
git config core.hooksPath .githooks

# Optional: set up Python for input file conversion
python -m venv .venv
.venv\Scripts\activate
pip install openpyxl beautifulsoup4 requests markdownify mammoth
```

The sync hook runs automatically on every commit after this. You won't need to think about it again.

### What loads automatically

When Copilot opens the workspace, it reads `.github/copilot-instructions.md`. This file contains the PM-in-the-Loop rules and the Humanized Writing Standard that every skill follows. You don't need to reference it directly. It's always active in the background.

---

## 2. Using Skills to Generate Artifacts

### How to invoke a skill

Type `/` in Copilot Chat to see available skills:

<!-- SKILL-TABLE-START -->
| Command | What it does |
|---------|-------------|
| `@backend-developer-ghcp` or `/improve-skill` | Senior backend engineer and systems architect (GHCP) |
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
| `@frontend-developer-ghcp` or `/improve-skill` | Senior frontend engineer and UI architect (GHCP) |
| `@ideation-ghcp` or `/improve-skill` | Deep research and ideation partner for PMs (GHCP) |
| `/review-doc` | Review any document for completeness, critical gaps, and alternative approaches |
| `@skill-improver-ghcp` or `/improve-skill` | Analyze and improve Copilot skills using web research and best practices (GHCP) |
| `@tester-ghcp` or `/improve-skill` | Senior QA engineer and test architect (GHCP) |
<!-- SKILL-TABLE-END -->

You can also just describe what you want in plain language. Copilot matches your request to the right skill based on keywords. Typing "write a spec for the new migration agent feature" triggers the build-spec skill without needing the slash command.

### The PM-in-the-Loop workflow

Every skill follows the same five-step pattern. Here's what to expect:

1. **You provide source material.** The skill asks what you're working with: a one-pager, transcript, doc, spec, or freeform description.
2. **You answer clarifying questions.** The skill asks about scope, audience, and success criteria. If your source material already answers some of these, skip them.
3. **Optional web research.** The skill can search the web for competitor features, industry standards, or community discussions. You decide what makes it into the draft.
4. **The skill generates a draft.** It appears in chat labeled `DRAFT - Awaiting PM Approval`. Items needing your judgment are flagged with `PM Decision Required`.
5. **You approve.** Say "approve", "save", or "looks good" and the file is written to the `output/` folder.

Nothing is saved until you explicitly approve. You're always in control.

---

## 3. Building a Spec

### Starting a spec

1. In Copilot Chat, type `/build-spec` followed by a brief description:
   ```
   /build-spec your product wave planning feature for sequencing workload migrations
   ```
2. The skill presents a menu of source material options. Pick what you have: one-pager, user guide, telemetry data, business insights, interview transcripts, user study, competitor analysis, existing spec, or just a freeform description.
3. Provide your material. Paste content directly into chat, or point to a file path in the workspace.
4. Answer the clarifying questions (problem, scope, integrations, constraints, success criteria, risks, phasing).
5. If you want competitive context, tell the skill. Say something like "research what AWS Migration Hub does for wave planning" and it'll search the web.

### What you get

A complete 11-section spec covering document control, product vision, user personas, feature inventory, feature specifications (with user stories and acceptance criteria as checkboxes), user journeys as Mermaid diagrams, non-functional requirements, risk register, success metrics, roadmap with dependency graph, and glossary.

The acceptance criteria section matters most. Developers code directly from it. Each criterion is specific, testable, and uses the checkbox format (`- [ ]`) so developers can check items off as they build.

### Decision points

The draft flags items that need your input:

```
> **PM Decision Required:** The acceptance criteria for F3 assume JWT-based auth.
> Confirm this matches your team's auth strategy, or specify the alternative.
```

Review these, provide your answer, and the skill incorporates your decision.

### Saving

After you approve, the file is saved to `output/specs/<feature-name>-spec.md`.

---

## 4. Reviewing and Refining a Spec

The `/build-spec` skill operates in three modes: Build, Refine, and Review. You don't need separate commands.

### Reviewing a spec

Type `/build-spec` and ask for a review:

```
/build-spec Review the spec at output/specs/wave-planning-spec.md
```

The review covers structure completeness (all 14 sections checked), acceptance criteria quality, vague language detection, humanized writing violations, cross-reference consistency, and a developer readiness score rated 1-5. Critical blockers are listed at the top.

The review stays in chat. It's not saved as a file. At the end, you get specific refine instructions for each recommendation.

### Refining a spec

Type `/build-spec` with a refine request:

```
/build-spec Refine output/specs/wave-planning-spec.md - Add GDPR compliance requirements to the NFR section and a new risk for EU data residency
```

The skill reads the spec, shows you a summary of proposed changes, waits for your go-ahead, then applies them in-place. It handles cascading updates automatically: if you add a feature, the acceptance criteria, experience surfaces, and telemetry all get updated too.

---

## 5. Writing a Blog Post

1. Type `/build-blog` with your topic:
   ```
   /build-blog announcement for the new your product wave planning feature
   ```
2. Provide source material: one-pager, spec, release notes, customer story, feature announcement notes, presentation summary, or freeform description.
3. Answer questions about audience, platform, tone, key takeaways, call to action, and length.
4. If you want, request research on what competitors or the community are saying.
5. Review the draft. Approve. The file saves to `output/blogs/<title>.md`.

The blog follows your community blog conventions: hook paragraph up front, capability sections with specifics, customer quotes (if you have them), and a "Get Started Today" section at the end with doc links.

---

## 6. Creating a User Guide

1. Type `/build-user-guide` with the product or feature name:
   ```
   /build-user-guide your product application assessment feature
   ```
2. This skill accepts the widest range of inputs. Docs, Word files, blogs, one-pagers, specs, meeting transcripts, HTML mockups, screenshots, and freeform descriptions all work.
3. You'll be asked about audience (end users, IT admins, or both), guide style (task-based walkthrough, reference manual, or a mix), key tasks to cover, and preferred length.
4. The draft includes `[Screenshot: ...]` placeholders wherever a visual would help. Your design team fills these in later.
5. Approve and save to `output/user-guides/<name>-guide.md`.

---

## 7. Building a User Research Kit

The `/build-user-research` skill generates up to three connected artifacts: a customer validation hypotheses list, an unmoderated survey questionnaire, and a moderated interview guide. Each artifact builds on the previous one.

### Starting a research kit

1. Drop your source material into `input/user-research/<project-name>/`. One-pagers, specs, telemetry exports, field notes, survey analysis reports, and product documentation URLs all work.
2. Type `/build-user-research` in Copilot Chat:
   ```
   /build-user-research Linux migration customer validation
   ```
3. Answer 9 clarifying questions covering product scope, target personas, riskiest assumptions, known signals, business context, research maturity, customer access, and constraints.
4. The last question asks which artifacts you want. Pick one of five options:

| Option | What you get | Best for |
|--------|-------------|----------|
| A | Hypotheses only | Quick assumption framing for a new product area |
| B | Hypotheses + Survey | Quantitative validation first, interviews decided later |
| C | Hypotheses + Interview Guide | Small sample size or qualitative-first approach |
| D | All three | High-stakes decisions needing both breadth and depth |
| E | Interview Guide only | Follow-up study with existing hypotheses and survey data |

### Three gated outputs

The skill shows each artifact as a draft in chat. You approve before it moves to the next.

**Gate 1 - Hypotheses.** Testable assumptions in "We believe [persona] will [behavior] because [signal]" format, grouped by risk type (Value, Usability, Feasibility, Viability) and journey stage (Discover, Assess/Plan, Execute, Post-migration). Includes a competitive landscape table and product doc checks per hypothesis. Saved to `output/user-research/<name>-hypotheses.md`.

**Gate 2 - Survey.** Screening questions with `[Disqualify]` markers, hypothesis-mapped question blocks (Likert, multi-select, ranking, open-ended), skip logic, branching by segmentation variables, and an interview recruitment question. A traceability table maps every question back to a hypothesis ID. Saved to `output/user-research/<name>-survey.md`.

**Gate 3 - Interview Guide.** Timed sections with transition prompts, scenario blocks clustering related hypotheses into conversation prompts, moderator aids (laddering techniques, listen-fors, debrief protocol). When you provide survey results, the guide calibrates depth per hypothesis: brief validation for confirmed findings, deep probing for partial results, and exploration of why rejected assumptions were wrong. Saved to `output/user-research/<name>-interview-guide.md`.

### Typical workflow for a full research initiative

1. Provide source material and select **Option D** (all three artifacts)
2. Approve the hypotheses list at Gate 1
3. Approve the survey at Gate 2
4. Run the survey (target 100-150 responses), analyze the results
5. Place the analysis report and raw CSV in `input/user-research/<project-name>/survey-data/`
6. Re-invoke the skill with **Option E** or continue the session - the interview guide calibrates depth based on your survey findings
7. Approve the interview guide at Gate 3

### Traceability

Every hypothesis gets an ID (H1, H2, H3...). Survey questions and interview questions trace back to these IDs. The interview guide adds a Survey Finding column (Confirmed, Partial, Rejected, New) so you can see the quantitative backdrop for each qualitative probe.

---

## 8. Using Development Agents

Three development agents and one research agent are available. Development agents accept specs, write production-quality code, and enforce security and accessibility standards. The research agent does deep ideation and market analysis.

### Switching to an agent

Select the agent from the agent picker dropdown in Copilot Chat:

- `@frontend-developer-ghcp` - Senior frontend engineer (React, Angular, Vue, CSS, accessibility)
- `@backend-developer-ghcp` - Senior backend engineer (APIs, databases, microservices, security)
- `@tester-ghcp` - Senior test engineer (unit, integration, E2E, coverage, security testing)
- `@ideation-ghcp` - Deep research and ideation (market analysis, competitive intelligence, trend analysis)

### Giving them a spec

```
@frontend-developer-ghcp Build the migration dashboard component from the spec in input/specs/dashboard/
```

The agent reads the spec, flags unclear requirements with **Spec Question** callouts, and proceeds with implementation. You can also provide design mocks, API contracts, user guides, or screenshots.

### Repo initialization

On first activation in a repo, development agents automatically:
1. Scan the project structure and existing code patterns
2. Read the spec and user guide
3. Run `@ideation-ghcp` to validate the approach and check competitor patterns
4. Create a `plan-forward/` folder with a clickstop-based delivery plan

### Clickstop-based planning

Agents break work into clickstops - feature slices sized to fit within your token budget. Each clickstop includes frontend + backend + tests for one coherent capability. When tokens run out, progress is saved to `plan-forward/status.md` and resumed in the next session.

### Using handoff buttons

After an agent finishes, handoff buttons appear:

- After frontend work: **Write Frontend Tests**, **Define API Contract**, or **Research Before Building**
- After backend work: **Write Backend Tests**, **Build UI for This API**, or **Research Before Building**
- After testing: **Fix Frontend Issues**, **Fix Backend Issues**, or **Research Testing Approaches**

### Using the ideation agent

```
@ideation-ghcp Explore the competitive landscape for cloud migration assessment tools
```

The ideation agent searches across Substack, Reddit, YouTube, competitor blogs, analyst reports, and academic papers. It offers 5 research modes: Exploration, Validation, Competitive Intelligence, Trend Analysis, and Deep Dive. After research, it can hand off findings to any skill (`/build-one-pager`, `/build-spec`, `/build-compete`).

Every content-generation skill also offers ideation as an optional step during the research phase.

### Safety guarantees

All development agents enforce these standards without being asked:

- OWASP Top 10 security compliance
- WCAG 2.1 AA accessibility (frontend)
- No PII in logs or error responses
- No dark patterns in UI code
- Dependency license verification

---

## 9. Improving a Skill

The `@skill-improver-ghcp` agent is a meta-tool. Point it at any skill and it researches current best practices online, compares them against the skill's instructions, and recommends specific improvements.

### Using the agent picker

Select `@skill-improver-ghcp` from the agent picker in Copilot Chat, then tell it which skill to analyze:

```
@skill-improver-ghcp Review the build-spec skill and suggest improvements
```

### Using the slash command

```
/improve-skill build-spec
```

Both approaches produce the same result: the agent reads the SKILL.md and reference files, searches the web for best practices (PM spec templates, developer complaints about specs, community patterns), and presents a structured report with strengths, gaps, and proposed changes. You approve which changes to apply.

---

## 10. Updating or Adding Skills

### Editing an existing skill

Skills are markdown files in `.github/skills/<skill-name>/`. To update one:

1. Open `.github/skills/<skill-name>/SKILL.md` in VS Code.
2. Make your changes to the instructions, template references, or writing rules.
3. Commit. The pre-commit hook automatically copies your changes to `.claude/skills/<skill-name>/` so Claude users get the update too.

You only edit the `.github/` version. The sync handles the rest.

### Adding a new skill

1. Create a folder: `.github/skills/<new-skill-name>/`
2. Add a `SKILL.md` file with this frontmatter:
   ```yaml
   ---
   name: new-skill-name
   description: "What it does. Use when: keyword 1, keyword 2, keyword 3."
   argument-hint: "What the PM provides as input"
   ---
   ```
3. Write the body: instructions following the PM-in-the-Loop workflow (gather inputs, ask questions, research, draft, approve, save).
4. Optionally add a `references/` subfolder with templates or examples.
5. Commit. The hook creates the matching `.claude/skills/<new-skill-name>/` automatically.

The `description` field is how Copilot decides when to load the skill. Put specific trigger phrases after "Use when:" so the right skill gets matched.

### Updating workspace instructions

The Humanized Writing Standard and PM-in-the-Loop rules live in `.github/copilot-instructions.md`. If you update this file and commit, the hook syncs the changes to `CLAUDE.md` (Claude's equivalent workspace instructions) automatically.

---

## 11. How the Sync Automation Works

The repo uses three sync mechanisms to keep Copilot and Claude artifacts aligned. You don't need to manage this manually, but understanding it helps when troubleshooting.

### What gets synced

| Copilot side | Claude side | How it syncs |
|---|---|---|
| `.github/copilot-instructions.md` | `CLAUDE.md` | Full file copy, newer file wins |
| `.github/skills/<name>/` | `.claude/skills/<name>/` | Full file + references, newer wins |
| `.github/agents/skill-improver.agent.md` | `.claude/skills/skill-improver/SKILL.md` | Body content synced, each side keeps its own frontmatter |

### Three sync layers

**Git pre-commit hook.** On every `git commit`, the hook at `.githooks/pre-commit` runs `scripts/sync-skills.ps1`. Out-of-sync files are updated and staged into your commit. This is the primary sync mechanism.

**Copilot PostToolUse hook.** The file `.github/hooks/sync-skills.json` triggers the sync after Copilot edits files. If Copilot modifies a skill during your session, the Claude copy updates immediately.

**Claude Stop hook.** The file `.claude/settings.json` triggers the sync when a Claude session ends. If a teammate works in Claude, the Copilot side catches up.

### The skill-improver edge case

On the Copilot side, skill-improver is an agent (`.github/agents/skill-improver.agent.md`) with tool restrictions: `read, search, edit, web`. On the Claude side, it's a skill (`.claude/skills/skill-improver/SKILL.md`) because Claude doesn't support agents. The sync keeps their body content identical while preserving each side's frontmatter format.

### Running the sync manually

```powershell
.\scripts\sync-skills.ps1              # Dry run, shows what would change
.\scripts\sync-skills.ps1 -Apply       # Apply changes
```

---

## 12. Tips & Tricks

**Skip the slash command.** Describe what you want in plain English. "Help me write a spec for the new discovery feature" works just as well as `/build-spec`. Copilot matches based on keywords.

**Paste source material directly.** You don't need to save a one-pager to a file first. Paste the text into chat and the skill works with it.

**Chain skills together.** A productive sequence: write a spec with `/build-spec`, review it with `/build-spec` in Review mode, fix the flagged issues with `/build-spec` in Refine mode, then generate a blog from the finished spec using `/build-blog`. Each skill reads the previous output.

**Be specific with research requests.** When the skill offers web research, give it a direction. "Research how AWS Migration Hub handles wave planning" gets better results than just "yes, do research."

**Edit one side only.** When modifying skills, just edit `.github/skills/`. The pre-commit hook handles `.claude/skills/`. Don't manually duplicate changes.

**Dry-run the sync.** Before committing, run `.\scripts\sync-skills.ps1` to see if anything is out of sync. No changes are applied without the `-Apply` flag.

---

## 13. Frequently Asked Questions

**Q: Where do generated files go?**
All outputs save to `output/<type>/` folders: `output/specs/`, `output/blogs/`, `output/user-guides/`. These are gitignored because they're project-specific artifacts, not shared assets.

**Q: Can I use these skills in any repo?**
The skills work in any workspace that has the `.github/skills/` folder. Clone the PM Skills repo, open it in VS Code, and the skills are available through Copilot Chat.

**Q: What if the skill asks something I don't know?**
Skip it or say "I'm not sure, use your best judgment." The skill makes a reasonable assumption and marks it with `> **Assumption:**` so you can validate later.

**Q: Can I cancel a draft?**
Yes. Don't say "approve" and nothing gets saved. Ask for revisions, start over, or close the chat. The draft only exists in the conversation.

**Q: How do I know which skills are available?**
Type `/` in Copilot Chat to see the list. Or browse the `.github/skills/` folder in the repo.

**Q: The sync hook isn't firing. What's wrong?**
Check that you've run `git config core.hooksPath .githooks` after cloning. Verify with `git config core.hooksPath`, which should return `.githooks`.

**Q: Can I add a skill without creating the Claude version?**
Yes, but you don't need to think about it. Create it in `.github/skills/` and the hook creates the Claude copy on your next commit.

**Q: I want to relax the writing rules for a specific skill. Can I?**
The rules in `.github/copilot-instructions.md` apply globally. To override for one skill, add the exception in that skill's SKILL.md body. The skill-level instruction takes precedence for that specific workflow.

---

*These skills help PMs generate product artifacts faster. Final decisions on acceptance criteria, strategic positioning, sizing, and evaluation logic always rest with the PM.*

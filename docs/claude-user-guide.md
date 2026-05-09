# PM Skills for Claude Code: A Guide for your product PMs

This guide walks PMs on the your product team through using PM Skills in Claude Code and Cowork. You'll learn how to generate specs, blogs, and user guides, how to update skills, and what automations run behind the scenes to keep everything in sync.

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
10. [Building an Agentic Experience](#10-building-an-agentic-experience)
11. [Drafting an Announcement Email](#11-drafting-an-announcement-email)
12. [Building an Architecture Doc](#12-building-an-architecture-doc)
13. [Generating Competitive Analysis](#13-generating-competitive-analysis)
14. [Writing a Customer Story](#14-writing-a-customer-story)
15. [Building a Demo Script](#15-building-a-demo-script)
16. [Writing Documentation Articles](#16-writing-documentation-articles)
17. [Generating a Golden Dataset](#17-generating-a-golden-dataset)
18. [Writing a Monthly Business Review](#18-writing-a-monthly-business-review)
19. [Drafting a One-Pager](#19-drafting-a-one-pager)
20. [Writing a Strategy Doc](#20-writing-a-strategy-doc)
21. [Reviewing Any Document](#21-reviewing-any-document)
22. [Updating or Adding Skills](#22-updating-or-adding-skills)
23. [How the Sync Automation Works](#23-how-the-sync-automation-works)
24. [Tips & Tricks](#24-tips--tricks)
25. [Frequently Asked Questions](#25-frequently-asked-questions)

---

## 1. Getting Started

### Prerequisites

### What you need installed

| Tool | How to install | Required? |
|------|---------------|-----------|
| Claude Code (terminal) | `curl -fsSL https://claude.ai/install.sh \| bash` (macOS/Linux) or `irm https://claude.ai/install.ps1 \| iex` (Windows) | Pick one |
| Claude Cowork (VS Code) | VS Code Marketplace: search for Claude Cowork | Pick one |
| VS Code | [code.visualstudio.com](https://code.visualstudio.com/) | Required for Cowork, not for terminal CLI |
| Git | `winget install Git.Git` | Yes |
| PowerShell 5.1+ | Pre-installed on Windows. `brew install powershell` on macOS. | Yes (runs sync and humanizer scripts) |
| Python 3.9+ | `winget install Python.Python.3.11` | Only for .docx/.xlsx/.html input conversion |
| Python packages | `pip install openpyxl beautifulsoup4 requests markdownify mammoth` | Only if Python is installed |
| Pandoc | `winget install JohnMacFarlane.Pandoc` | Only for .docx conversion |

- A Claude subscription (Pro, Team, or Enterprise) or Anthropic Console account
- The PM Skills repository cloned locally

### Opening the workspace

**Claude Code (terminal):**
1. Open your terminal.
2. Navigate to the PM Skills repository folder.
3. Run `claude` to start a session.

**Cowork (VS Code):**
1. Open VS Code with the Cowork extension installed.
2. Open the PM Skills repository folder.
3. Open the Cowork chat panel from the sidebar.

### One-time setup after cloning

```bash
# Required: enable the sync hook
git config core.hooksPath .githooks

# Optional: set up Python for input file conversion
python -m venv .venv
.venv\Scripts\activate
pip install openpyxl beautifulsoup4 requests markdownify mammoth
```

### What loads automatically

Two things happen when Claude starts a session in this workspace:

1. Claude reads `CLAUDE.md` at the repository root. This file contains the PM-in-the-Loop rules and the Humanized Writing Standard that every skill follows.
2. Claude loads `.claude/settings.json`, which configures a hook that runs the skill sync script when your session ends.

Skills in `.claude/skills/` are discovered based on their `description` field. You don't need to register them anywhere.

---

## 2. Using Skills to Generate Artifacts

### Invoking a skill

Type `/` to see all available skills:

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
| `/export-docx` | Convert a saved markdown file (or a combined bundle of several) to a .docx for circulation, reviewer comments, or Word-based feedback |
| `/frontend-developer-claude` | Senior frontend engineer and UI architect |
| `/ideation-claude` | Deep research and ideation partner for PMs |
| `/review-doc` | Review any document for completeness, critical gaps, and alternative approaches |
| `/skill-improver-claude` | Analyze and improve Copilot skills using web research and best practices (Claude) |
| `/tester-claude` | Senior QA engineer and test architect |
<!-- SKILL-TABLE-END -->

You can also skip the slash command entirely. Describing what you want in plain language works too. "I need to write a spec for the new migration agent" triggers the build-spec skill based on keyword matching against skill descriptions.

### The PM-in-the-Loop workflow

Every skill follows the same pattern:

1. **You provide source material.** The skill asks what you have: one-pager, transcript, doc, spec, mockups, or a freeform description.
2. **You answer clarifying questions.** Scope, audience, success criteria. Skip questions your source material already covers.
3. **Optional web research.** The skill can search the web for competitor features or community discussions. You pick what goes into the draft.
4. **The skill generates a draft.** It appears labeled `DRAFT - Awaiting PM Approval` with `PM Decision Required` flags on items needing your judgment.
5. **You approve.** Say "approve", "save", or "looks good" and the file is written to the `output/` folder.

Nothing is saved without your explicit go-ahead.

---

## 3. Building a Spec

1. Type `/build-spec` with a brief description:
   ```
   /build-spec your product wave planning feature for sequencing workload migrations
   ```
2. Pick your source material from the menu: one-pager, user guide, telemetry data, business insights, interview transcripts, user study, competitor analysis, existing spec, or freeform description.
3. Paste your material directly into chat, or reference a file path.
4. Answer clarifying questions about the problem, scope, integrations, constraints, success criteria, risks, and phasing.
5. Optionally ask for competitive research. Say "research what [Competitor product] does for [feature]" to get targeted results.

### What you get

A complete spec with 11 sections: document control, product vision, user personas, feature inventory, feature specifications (user stories plus acceptance criteria as checkboxes), user journeys as Mermaid diagrams, non-functional requirements, risk register, success metrics, roadmap with dependency graph, and glossary.

Acceptance criteria use the `- [ ]` checkbox format so developers can check them off as they build. Each criterion is specific and testable. No "should" or "might" or "fast response time." Instead: "response time under 200ms."

Decision points are flagged clearly. Review them, provide your input, and approve when you're satisfied. The file saves to `output/specs/<feature-name>-spec.md`.

---

## 4. Reviewing and Refining a Spec

The `/build-spec` skill operates in three modes: Build, Refine, and Review. You don't need separate commands.

### Reviewing

```
/build-spec Review the spec at output/specs/wave-planning-spec.md
```

You get a structured audit covering structure completeness across all 14 sections, acceptance criteria quality, vague language detection, humanized writing violations, cross-reference consistency, critical blockers at the top, and a developer readiness score (1-5 across six dimensions).

The review stays in chat. It includes specific refine instructions for each recommendation so you can act immediately.

### Refining

```
/build-spec Refine output/specs/wave-planning-spec.md - Add a new feature F10 for batch migration scheduling
```

The skill reads the spec, shows you its proposed changes, and waits for your approval before editing. When it applies changes, it handles cascading updates automatically. Adding a feature updates acceptance criteria, experience surfaces, and telemetry together.

---

## 5. Writing a Blog Post

```
/build-blog announcement for your product wave planning
```

Provide source material (spec, release notes, customer story, one-pager, or freeform), answer questions about audience, tone, length, and call to action, then review the draft. The blog follows your community blog patterns: a hook paragraph, capability sections with specifics, customer quotes if available, and a "Get Started Today" section at the end.

Saves to `output/blogs/<title>.md`.

---

## 6. Creating a User Guide

```
/build-user-guide your product application assessment
```

This skill takes the widest range of inputs. Docs, Word files, blogs, one-pagers, specs, meeting transcripts, HTML mockups, screenshots, and freeform descriptions all work. You'll be asked about the audience (end users, IT admins, or both), guide style (task-based walkthrough, reference manual, or a mix), and preferred length.

The draft inserts `[Screenshot: ...]` placeholders wherever a visual would help. Your design team fills these in later. Saves to `output/user-guides/<name>-guide.md`.

---

## 7. Building a User Research Kit

The `/build-user-research` skill generates up to three connected artifacts: a customer validation hypotheses list, an unmoderated survey questionnaire, and a moderated interview guide. Each artifact builds on the previous one.

### Starting a research kit

1. Drop your source material into `input/user-research/<project-name>/`. One-pagers, specs, telemetry exports, field notes, survey analysis reports, and product documentation URLs all work.
2. Type `/build-user-research` in Claude Code or Cowork:
   ```
   /build-user-research [Your product] customer validation
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

Three specialized development agents handle coding tasks. Each is a senior engineer that accepts specs, writes production-quality code, and enforces security and accessibility standards.

### Starting a development agent session

In Claude Code, invoke agents by name:

```
/frontend-developer Build the dashboard component from the spec in input/specs/dashboard/
```

Or use the agent directly:

```
/backend-developer Design a REST API for the assessment service based on the spec in input/specs/assessment-api/
```

### Available agents

| Agent | Command | Specialization |
|-------|---------|----------------|
| **Frontend Developer** | `/frontend-developer` | React/Angular/Vue, CSS, accessibility (WCAG 2.1 AA), responsive design, Core Web Vitals |
| **Backend Developer** | `/backend-developer` | REST/GraphQL APIs, database design, microservices, OWASP security, observability |
| **Tester** | `/tester` | Unit/integration/E2E tests, test strategy, coverage analysis, security testing |

### What they do with specs

The agents read your spec, flag unclear requirements with **Spec Question** callouts, and proceed with implementation. You can also provide design mocks, API contracts, screenshots, or database schemas.

### Safety guarantees

All three agents enforce these standards automatically:

- OWASP Top 10 security compliance
- WCAG 2.1 AA accessibility (frontend)
- No PII in logs or error responses
- No dark patterns in UI code
- Dependency license verification

### Inter-agent collaboration

Agents can invoke each other. Frontend asks Backend to propose an API contract. Backend asks Tester to generate test cases before implementation. The results are shown to you for approval before either agent proceeds.

### Using the ideation skill

```
/ideation-claude Explore the competitive landscape for cloud migration assessment tools
```

The ideation skill is a deep research and ideation partner. It searches across Substack, Reddit, Hacker News, YouTube, competitor blogs, analyst reports, GitHub, Stack Overflow, and academic papers - then synthesizes findings instead of returning links. It offers five research modes: Exploration (open-ended scanning), Validation (stress-testing assumptions), Competitive Intelligence, Trend Analysis, and Deep Dive (a single topic to the bottom).

Ideation can also assume personas (customer, competitor PM, analyst, engineering lead, end user, CFO/CTO) to attack a problem from different angles. After research, hand the findings off to any other skill: `/build-one-pager`, `/build-spec`, `/build-compete`, or `/build-strategy-doc`.

Every content-generation skill in this workspace also offers ideation as an optional step during its own research phase, so you don't need to invoke it separately.

---

## 9. Improving a Skill

The skill-improver is a meta-skill. Tell it which skill to review and it researches current best practices online:

```
/skill-improver build-blog
```

It reads the target skill's SKILL.md and reference files, searches the web for best practices (blog writing guides, community feedback, competitor patterns), and presents a structured report. The report covers what the skill does well, gaps it found, and specific changes it recommends with rationale and sources.

You decide which improvements to apply. The skill-improver edits the files after your approval.

---

<!-- SKILL-SECTION-START: build-agentic-experience -->
## 10. Building an Agentic Experience

```
/build-agentic-experience scenario catalog for the readiness assessment chat
```

Use this skill when you need to define how an AI assistant should handle conversations for a feature. It runs in three modes: **Scenario Catalog** (exhaustive prompt-response pairs across edge cases), **Journey Script** (a linear happy-path walkthrough for demos or testing), and **Eval Dataset** (12-column structured test cases for accuracy measurement). Tell the skill which mode you need, or it'll infer from your phrasing.

### What you get

Mode-specific output. The scenario catalog returns numbered sections of `Prompt | Response | Suggested Prompts` tables, with three suggested follow-ups after every response. Journey scripts arrive as persona-driven walkthroughs in a User/AI/Prompts table. Eval datasets ship with task taxonomy, variant coverage, and an optional JSONL companion file for direct ingestion into evaluation tooling.

Saves to `output/eval-datasets/`, `output/scenario-catalogs/`, or `output/journey-scripts/` depending on the mode.
<!-- SKILL-SECTION-END: build-agentic-experience -->

---

<!-- SKILL-SECTION-START: build-announcement-email -->
## 11. Drafting an Announcement Email

```
/build-announcement-email GA launch for wave planning to field sellers
```

Drop in your topic (or a path to a spec, one-pager, blog draft, or release notes) and tell the skill who the email is for. The audience drives everything: tone, structure, what to lead with, what to skip. Customers, field sellers, partners, internal leadership, and engineering teams each get a different shape.

### What you get

A custom-structured email built for this specific announcement. The skill proposes a section outline first (subject line, opening, capability blocks, CTAs, links), waits for your approval on the structure, then drafts each section. Source material gets pulled in for accurate specifics. If a fact is missing, you get a targeted question instead of placeholder text.

Saves to `output/emails/<title>.md`.
<!-- SKILL-SECTION-END: build-announcement-email -->

---

<!-- SKILL-SECTION-START: build-architecture -->
## 12. Building an Architecture Doc

```
/build-architecture HLD for the migration agent platform
```

Hand it a strategy doc, one-pager, spec, or meeting transcript and the skill drafts a matching architecture document. The source type drives the depth: strategy docs produce ground-up HLDs, one-pagers produce extension architectures, specs produce LLDs. You can combine multiple sources for a mixed scope.

### What you get

A complete architecture document covering system boundaries, component responsibilities, data architecture, communication patterns, security, and execution phasing. HLDs lean into system context and layering. LLDs go deep on data models, API contracts, state machines, error handling, and testing. The skill calls out every alternative considered and why the chosen path won.

Saves to `output/architecture-docs/<name>.md`.
<!-- SKILL-SECTION-END: build-architecture -->

---

<!-- SKILL-SECTION-START: build-compete -->
## 13. Generating Competitive Analysis

```
/build-compete your-product vs competitor-1 across migration planning
```

Use this for either a narrative competitive analysis (qualitative, multi-section) or a scorecard (quantified comparison matrix). The skill ingests competitor docs, sales feedback, customer interviews, analyst reports, blog posts, and URLs to fetch. You can also kick off optional deep research through `/ideation-claude` before drafting starts.

### What you get

Narrative analyses come back with an Executive Summary, pillar-by-pillar comparison, positioning markers, and evidence-backed claims that cite specific source URLs. Scorecards are structured tables with pillars, categories, parameters, and ratings. Either format can be exported to .docx if you provide a reference template.

Saves to `output/compete-analysis/<topic>-compete-analysis.md` or `output/compete-analysis/<topic>-compete-scorecard.md`.
<!-- SKILL-SECTION-END: build-compete -->

---

<!-- SKILL-SECTION-START: build-customer-story -->
## 14. Writing a Customer Story

```
/build-customer-story acme-corp
```

This skill builds customer stories from meeting transcripts and your direct inputs only. Drop transcript files into `input/customer-stories/<customer-name>/` (any format - .docx, .txt, .md), or paste them into chat. If you offer other source types like one-pagers or blogs, the skill redirects you to the right tool.

### What you get

Two formats to pick from. **Internal customer learnings** captures issues, learnings, and action items with named owners and ETAs - the format leadership reviews use. **Public case study** structures as challenge, solution, results with attributed quotes for company blogs or partner channels.

Saves to `output/customer-stories/<customer>.md`.
<!-- SKILL-SECTION-END: build-customer-story -->

---

<!-- SKILL-SECTION-START: build-demo-script -->
## 15. Building a Demo Script

```
/build-demo-script wave planning for the conference keynote
```

Use this for product walkthroughs, conference talks, leadership reviews, or feature deep dives. Source material can be specs, one-pagers, transcripts, docs, or existing demo scripts you want to extend or adapt for a different audience.

### What you get

A beat-by-beat script with timing per section, transition markers, talk track, and `[Screenshot: ...]` placeholders for each visual moment. The structure adapts to demo type: keynotes get more narrative arc, deep dives get more technical depth, leadership reviews lead with business impact.

Saves to `output/demo-scripts/<name>.md`.
<!-- SKILL-SECTION-END: build-demo-script -->

---

<!-- SKILL-SECTION-START: build-documentation -->
## 16. Writing Documentation Articles

```
/build-documentation sql assessment overview
```

Drafts your-docs-site-style public documentation from specs, one-pagers, blogs, transcripts, or existing docs you want to update. The skill translates internal language into customer-facing documentation voice and matches your-docs-site's article conventions.

### What you get

A documentation article with the right frontmatter for its type. The skill picks from four article types based on the content: **Overview** (concept doc), **Quickstart** (5-15 min walkthrough), **How-to** (task-focused), or **Tutorial** (end-to-end). Output includes prerequisites, step tables, settings tables, screenshot placeholders, and Next Steps links.

Saves to `output/documentation/<name>.md`.
<!-- SKILL-SECTION-END: build-documentation -->

---

<!-- SKILL-SECTION-START: build-golden-dataset -->
## 17. Generating a Golden Dataset

```
/build-golden-dataset your-product readiness assessment API
```

Generates persona-driven evaluation datasets for any AI system, API, or product. You give the skill source data (API responses, CSV exports, info exports, conversation logs) plus user personas, and it produces the questions those personas would ask along with exact expected responses derived from the source data.

### What you get

A markdown table with question and expected-response columns, plus an evaluation formula showing how each answer was derived from the source. Every row is traceable back to a specific data point. The format is ready to plug into accuracy measurement workflows.

Saves to `output/golden-datasets/<product-name>-golden-dataset.md`.
<!-- SKILL-SECTION-END: build-golden-dataset -->

---

<!-- SKILL-SECTION-START: build-mbr -->
## 18. Writing a Monthly Business Review

```
/build-mbr april-2026
```

Builds a leadership-facing monthly business review around hypothesis-driven analysis. The skill expects you to drive the analytical narrative. It helps structure, write, and polish, but never auto-generates insights from data without your direction. Drop telemetry exports, compete intel, customer stories, and the prior month's MBR into `input/mbr/<period>/`.

### What you get

A structured MBR with KPI/OKR scorecards, hypothesis-driven highlights and lowlights, customer spotlights, compete signals, and action items with owners and ETAs. Continuity from the prior month carries forward: open follow-ups, trend deltas, and recurring themes appear in the right sections.

Saves to `output/mbr/<period>.md`.
<!-- SKILL-SECTION-END: build-mbr -->

---

<!-- SKILL-SECTION-START: build-one-pager -->
## 19. Drafting a One-Pager

```
/build-one-pager network assessment problem space
```

Pitches a problem, solution approach, and execution plan to leadership and partner teams. The skill helps you **ideate** first - it presents options, tradeoffs, and angles before drafting. If you provide a strategy doc that covers multiple investment areas, the skill can decompose it and propose which one-pagers to extract.

### What you get

A document covering the problem with data points, customer evidence, the proposed solution and alternatives considered, scope boundaries, phasing across H1/H2/Future, success metrics, and stakeholder map. Tone matches strategic PM-to-leadership.

Saves to `output/one-pagers/<name>.md`.
<!-- SKILL-SECTION-END: build-one-pager -->

---

<!-- SKILL-SECTION-START: build-strategy-doc -->
## 20. Writing a Strategy Doc

```
/build-strategy-doc your-product H1 fy26 strategy
```

Builds an executive-ready strategy document for VP, CVP, or your-executive-reviewer-tier reviews. The skill stitches together telemetry, customer stories, competitive analysis, product investments, and business context into a single strategic narrative, not a feature list.

### What you get

A pillar-driven document with an executive summary that compresses the entire story into one page, customer evidence blocks after every strategic claim, compete insight blocks after every investment, "Why this approach?" inline rationale, data-backed claims (every percentage and number cited), and explicit scope boundaries answering "what about X?" questions before reviewers ask.

Saves to `output/strategy-docs/<name>.md`.
<!-- SKILL-SECTION-END: build-strategy-doc -->

---

<!-- SKILL-SECTION-START: review-doc -->
## 21. Reviewing Any Document

```
/review-doc output/specs/wave-planning-spec.md
```

Reviews any document type - strategy docs, one-pagers, specs, architecture docs, compete analyses, scorecards, user guides, customer stories, blogs - against a 16-type review framework. Optionally pass the source document the review subject was built from for alignment checking.

### What you get

Two deliverables in chat. **Critical Evaluation** is a structured analysis covering completeness, gaps, alternative approaches, and external context from web research. **Inline Comments** are located, line-by-line feedback the author can act on directly.

The review stays in chat. Files are not saved unless you explicitly ask.
<!-- SKILL-SECTION-END: review-doc -->

---

## 22. Updating or Adding Skills

### Editing an existing skill

Skills live in `.claude/skills/<skill-name>/`. To update one:

1. Open `.claude/skills/<skill-name>/SKILL.md`.
2. Make your changes.
3. Commit. The pre-commit hook copies your changes to `.github/skills/<skill-name>/` so Copilot users get the update too.

You only edit the `.claude/` version. The sync handles the Copilot side.

### Adding a new skill

1. Create a folder: `.claude/skills/<new-skill-name>/`
2. Add a `SKILL.md` file:
   ```yaml
   ---
   name: new-skill-name
   description: "What it does. Use when: keyword 1, keyword 2, keyword 3."
   argument-hint: "What the PM provides as input"
   ---
   ```
3. Write the instructions in the body. Follow the PM-in-the-Loop pattern: gather inputs, ask questions, optional research, generate draft, wait for approval, save.
4. Optionally add a `references/` subfolder with templates or examples.
5. Commit. The hook creates the Copilot version at `.github/skills/<new-skill-name>/`.

The `description` field determines when Claude loads the skill. Include specific trigger phrases after "Use when:" for accurate matching.

### Updating workspace instructions

The Humanized Writing Standard and PM-in-the-Loop contract live in `CLAUDE.md` at the repo root. Edit and commit. The hook syncs to `.github/copilot-instructions.md` (Copilot's equivalent) automatically.

---

## 23. How the Sync Automation Works

The repo keeps Claude and Copilot artifacts in sync through three mechanisms. You don't need to manage this yourself, but understanding it helps when troubleshooting.

### What gets synced

| Claude side | Copilot side | How it works |
|---|---|---|
| `CLAUDE.md` | `.github/copilot-instructions.md` | Full file copy, newer file wins |
| `.claude/skills/<name>/` | `.github/skills/<name>/` | Full file plus references, newer wins |
| `.claude/skills/skill-improver/SKILL.md` | `.github/agents/skill-improver.agent.md` | Body content synced, each side keeps its own frontmatter |

### Three sync layers

**Claude Stop hook.** Configured in `.claude/settings.json`. When your Claude session ends, the sync script runs and updates any Copilot files that fell behind.

**Git pre-commit hook.** On every `git commit`, the hook at `.githooks/pre-commit` runs `scripts/sync-skills.ps1`. Out-of-sync files are updated and staged into your commit. This is the primary sync that ensures both sides are committed together.

**Copilot PostToolUse hook.** Configured in `.github/hooks/sync-skills.json`. If a teammate edits skills through Copilot, the Claude side updates when those files are modified.

### Why skill-improver is special

On the Claude side, skill-improver is a skill (`.claude/skills/skill-improver/SKILL.md`). On the Copilot side, it's an agent (`.github/agents/skill-improver.agent.md`) with explicit tool restrictions: `read, search, edit, web`. This separation exists because Copilot supports agents with tool access control while Claude uses skills for the same purpose.

The sync keeps their body content (the actual instructions, workflow, and constraints) identical. Each side retains its own frontmatter: the agent file has `tools` and `user-invocable` fields, the skill file has `name` and `description`.

### Running the sync manually

```powershell
.\scripts\sync-skills.ps1              # Dry run, shows what would change
.\scripts\sync-skills.ps1 -Apply       # Apply changes
```

---

## 24. Tips & Tricks

**Describe what you want naturally.** "Help me write a blog about the new discovery feature" works without any slash commands. Claude matches keywords against skill descriptions.

**Paste source material directly.** Don't bother saving a one-pager to a file. Paste the text into chat and the skill works with it immediately.

**Chain skills for a full workflow.** Write a spec with `/build-spec`, catch gaps with `/build-spec` in Review mode, fix them with `/build-spec` in Refine mode, then turn the finished spec into a blog using `/build-blog`. Each skill reads the previous output.

**Give research requests a direction.** Instead of "yes, research competitors", try "research how [Competitor product] handles assessment reports." Specific angles produce better results.

**Edit skills on one side.** Update `.claude/skills/` and the pre-commit hook handles `.github/skills/`. No manual copying needed.

**Run a sync dry-run before committing.** `.\scripts\sync-skills.ps1` shows what's out of sync without changing anything. Add `-Apply` to fix it.

**Audit skills periodically.** Run `/skill-improver build-spec` every few months. It searches the web for new patterns and community feedback that could strengthen your skills.

---

<!-- SKILL-SECTION-START: export-docx -->
## 25. Exporting Drafts as .docx

```
/export-docx output/one-pagers/living-expense-tracker.md
```

Converts a saved markdown file (or several combined into one) to a `.docx` so you can circulate it, get track-changes feedback, or print it. Wraps Pandoc behind a PM-friendly slash command.

The skill runs in two modes. **Single-file** mode takes one `.md` under `output/` and writes the `.docx` alongside it. **Bundle** mode takes a comma-separated list of `.md` files (which can come from `input/` or `output/`), concatenates them with `---` separators, saves the combined `.md` under `output/source-docs/<name>.md`, and converts that. Bundle mode is the right pick when you want one Word doc that captures all the source material a reviewer needs.

If you don't pass an argument, the skill auto-detects the most-recently-modified `.md` under `output/` and asks before converting.

### Auto-prompt

After any skill saves an `.md` under `output/`, a Stop hook (`scripts/docx-prompt.ps1`) emits a system-reminder so the next Claude turn offers you the conversion. Mute it with `CLAUDE_SKILLS_DOCX_PROMPT=off` if it gets noisy.

### Reviewer comments back

When a `.docx` returns from review with comments and tracked changes, the `office-word` MCP server (registered via `claude mcp add`) reads them. Hand the file to `/review-doc` along with a note that you want comment ingestion.

### What you get

The `.docx` next to the source `.md`, plus a chat report with the output path and file size. Generated `.docx` files live under `output/` and are gitignored by default. Pandoc must be installed (`winget install JohnMacFarlane.Pandoc`).
<!-- SKILL-SECTION-END: export-docx -->

---
## 25. Frequently Asked Questions

**Q: Where do generated files go?**
All outputs save to `output/<type>/` folders: `output/specs/`, `output/blogs/`, `output/user-guides/`. These are gitignored because they're project-specific.

**Q: What's the difference between CLAUDE.md and copilot-instructions.md?**
Same content, different consumers. Claude reads `CLAUDE.md`. Copilot reads `.github/copilot-instructions.md`. The sync hook keeps them identical.

**Q: What if I update a skill and forget to commit?**
The Claude Stop hook syncs locally when your session ends, but the Copilot side only reaches your teammates after you commit and push. Make it a habit to commit after substantial skill edits.

**Q: Can I skip the approval step and save directly?**
No. The PM-in-the-Loop contract requires explicit approval before saving. This protects against the agent making calls about acceptance criteria, positioning, or metrics without your sign-off.

**Q: How do I check the sync is working?**
Run `git config core.hooksPath` and verify it returns `.githooks`. Then run `.\scripts\sync-skills.ps1` for a dry run to see if anything is out of sync.

**Q: I edited a skill in Claude but my teammate using Copilot doesn't see the change.**
The sync operates locally. After editing, commit and push. Your teammate pulls and gets both the `.claude/` and `.github/` versions, since the hook stages both into the same commit.

**Q: What's the skill-improver for?**
It's a meta-skill for keeping other skills sharp. Point it at any skill (like "build-spec") and it researches current best practices online, compares them to the skill's instructions, and suggests targeted improvements. Think of it as a periodic skill health check.

**Q: Can I override the writing rules for one specific guide?**
The Humanized Writing Standard in `CLAUDE.md` applies to all skills. To make an exception for one skill (say, allowing em dashes in a specific customer-facing doc), add the override directly in that skill's SKILL.md body.

---

*These skills help PMs generate product artifacts faster. Decisions on acceptance criteria, strategic positioning, sizing, and evaluation logic always rest with the PM.*

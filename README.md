# PM Skills

An AI-powered toolkit of skills, agents, and automation for product managers. Generate specs, blogs, user guides, competitive analysis, golden datasets, and more - while specialized development agents handle frontend, backend, and testing work.

PMs use skills through natural language in their IDE. Type `/build-spec` or `/build-blog` in GitHub Copilot Chat, Claude Code, or Cowork and follow the guided workflow. Switch to `@frontend-developer-ghcp`, `@backend-developer-ghcp`, or `@tester-ghcp` for development tasks with spec-driven, security-first coding. Every skill and agent works on both platforms with identical behavior.

## Quick Start

```bash
# 1. Clone the repo
git clone <your-clone-url>
cd Skills

# 2. Enable the sync hook (one-time)
git config core.hooksPath .githooks

# 3. Open in VS Code
code .

# 4. Type /build-spec in Copilot Chat or Claude Cowork
```

## Available Skills

<!-- SKILL-TABLE-START -->
| Skill | Command | Copilot | Claude | What it does |
|-------|---------|---------|--------|--------------|
| **backend-developer** | `@backend-developer-ghcp` | yes | no | Senior backend engineer and systems architect (GHCP) |
| **backend-developer-claude** | `/backend-developer-claude` | no | yes | Senior backend engineer and systems architect |
| **build-agentic-experience** | `/build-agentic-experience` | yes | yes | Build agentic workflow artifacts for conversational AI: scenario catalogs, journey scripts, or evaluation datasets |
| **build-announcement-email** | `/build-announcement-email` | yes | yes | Draft an announcement email for product launches, previews, breaking changes, product updates, or stakeholder enablement |
| **build-architecture** | `/build-architecture` | yes | yes | Create an architecture document (HLD or LLD) from strategy docs, one-pagers, specs, or meeting transcripts |
| **build-blog** | `/build-blog` | yes | yes | Draft a blog post for your community blog, your engineering blog, or LinkedIn |
| **build-compete** | `/build-compete` | yes | yes | Generate competitive analysis or scorecard comparing your product against competitors |
| **build-customer-story** | `/build-customer-story` | yes | yes | Write a customer story from meeting transcripts and PM inputs |
| **build-demo-script** | `/build-demo-script` | yes | yes | Write a demo script for product walkthroughs, conference talks, leadership reviews, or feature deep dives |
| **build-documentation** | `/build-documentation` | yes | yes | Write your documentation platform-style public documentation from specs, one-pagers, blogs, or transcripts |
| **build-golden-dataset** | `/build-golden-dataset` | yes | yes | Generate a golden evaluation dataset from product inputs and user personas |
| **build-mbr** | `/build-mbr` | yes | yes | Write a monthly business review document with hypothesis-driven analysis |
| **build-one-pager** | `/build-one-pager` | yes | yes | Write a one-pager document for leadership and partner teams |
| **build-spec** | `/build-spec` | yes | yes | Build, refine, or review product specifications |
| **build-strategy-doc** | `/build-strategy-doc` | yes | yes | Write an exec-ready strategy document for leadership and cross-org reviews |
| **build-user-guide** | `/build-user-guide` | yes | yes | Write a customer-facing user guide or product walkthrough |
| **build-user-research** | `/build-user-research` | yes | yes | Build a customer validation research kit: hypotheses, survey, and interview guide |
| **export-docx** | `/export-docx` | yes | yes | Convert a saved markdown file (or a combined bundle of several) to a .docx for circulation, reviewer comments, or Word-based feedback |
| **frontend-developer** | `@frontend-developer-ghcp` | yes | no | Senior frontend engineer and UI architect (GHCP) |
| **frontend-developer-claude** | `/frontend-developer-claude` | no | yes | Senior frontend engineer and UI architect |
| **ideation** | `@ideation-ghcp` | yes | no | Deep research and ideation partner for PMs (GHCP) |
| **ideation-claude** | `/ideation-claude` | no | yes | Deep research and ideation partner for PMs |
| **review-doc** | `/review-doc` | yes | yes | Review any document for completeness, critical gaps, and alternative approaches |
| **skill-improver** | `@skill-improver-ghcp` | yes | no | Analyze and improve Copilot skills using web research and best practices (GHCP) |
| **skill-improver-claude** | `/skill-improver-claude` | no | yes | Analyze and improve Copilot skills using web research and best practices (Claude) |
| **tester** | `@tester-ghcp` | yes | no | Senior QA engineer and test architect (GHCP) |
| **tester-claude** | `/tester-claude` | no | yes | Senior QA engineer and test architect |
<!-- SKILL-TABLE-END -->

## How It Works

Every skill follows two core principles:

**1. PM-in-the-Loop.** The agent ideates, researches, and drafts. The PM makes all final decisions. Nothing is saved to a file until the PM explicitly approves. Decision points are flagged with `> **PM Decision Required:**` callouts.

**2. Humanized Writing.** All generated content follows a strict writing standard that removes AI-sounding patterns. No em dashes, no formulaic paragraph structures, no overused AI words. The full ruleset lives in [.github/copilot-instructions.md](.github/copilot-instructions.md).

### Typical Workflow

1. PM types `/build-spec` (or `/build-blog`) in Copilot Chat or Claude Code
2. The agent asks what source material the PM has (one-pager, interview transcript, telemetry, etc.)
3. PM provides material and answers clarifying questions
4. The agent optionally researches competitors or market context (PM decides what to include)
5. The agent generates a DRAFT shown in chat with PM Decision Required callouts
6. PM reviews, requests changes, approves
7. File is saved to `output/specs/` or `output/blogs/`

### Providing Your Own Input

Skills accept source material in three ways:

- **Input folder.** Drop files into `input/<type>/<project-name>/` (e.g., `input/specs/wave-planning/`). The skill scans them automatically. Supports .docx, .xlsx, .csv, .html, .json, and URLs listed in a `sources.md` manifest.
- **Inline.** Paste content directly into chat or provide file paths.
- **URLs.** Share web links. The skill fetches and converts them.

The `input/` and `output/` directories are gitignored. You create them locally and populate them with your own data - nothing in those folders is committed to the repo.

Non-markdown files are converted automatically using `scripts/translate-inputs.py`.

## Prerequisites

### Required (pick one or both AI tools)

| Tool | Install | Purpose |
|------|---------|---------|
| VS Code | [code.visualstudio.com](https://code.visualstudio.com/) | IDE for both Copilot and Claude Cowork |
| GitHub Copilot extension | VS Code Marketplace: `GitHub.copilot` + `GitHub.copilot-chat` | Copilot Chat with agent mode |
| Claude Code (terminal) | `curl -fsSL https://claude.ai/install.sh \| bash` (macOS/Linux) or `irm https://claude.ai/install.ps1 \| iex` (Windows) | Claude CLI |
| Claude Cowork extension | VS Code Marketplace | Claude in VS Code |

You need at least one of: GitHub Copilot or Claude Code/Cowork. Both work.

### Required for all setups

| Tool | Install | Purpose |
|------|---------|---------|
| Git | `winget install Git.Git` | Version control + sync hooks |
| PowerShell 5.1+ | Pre-installed on Windows. `brew install powershell` on macOS. | Runs sync, update-docs, humanizer, and secrets-check scripts |

### Optional (for input file conversion)

| Tool | Install | Purpose |
|------|---------|---------|
| Python 3.9+ | `winget install Python.Python.3.11` | Runs translate-inputs.py |
| Python packages | `pip install openpyxl beautifulsoup4 requests markdownify mammoth python-docx` | Converts .xlsx, .html, .docx to markdown and exports .docx |
| Pandoc | `winget install JohnMacFarlane.Pandoc` | Converts both directions: .docx -> markdown (input) and markdown -> .docx (output via `/export-docx`) |

### Optional (for `.docx` export and Word reviewer feedback)

The repo ships a `/export-docx` slash command and a Stop hook that prompts you after any `.md` is saved under `output/`. It can also ingest reviewer comments and tracked changes from a returned `.docx` via an MCP server.

| Tool | Install | Purpose |
|------|---------|---------|
| Pandoc | `winget install JohnMacFarlane.Pandoc` | Same install as above; `/export-docx` runs `pandoc input.md -o input.docx` |
| office-word-mcp-server | `pip install office-word-mcp-server` | MCP server that reads `.docx` files (comments, tracked changes) for `/review-doc` and similar workflows |
| MCP registration | `claude mcp add office-word --scope user -- "<full path to word_mcp_server.exe>"` | One-time registration with Claude Code; verify with `claude mcp list` (health-check should show `Connected`) |

The MCP entry point is the `word_mcp_server.exe` console script that pip drops into your Python `Scripts` directory (e.g. `C:\Users\<you>\AppData\Roaming\Python\Python<ver>\Scripts\word_mcp_server.exe`). Pass the full path to `claude mcp add` because the Scripts directory may not be on the PATH that Claude Code uses when launching the server.

To mute the auto-prompt after every save, set the environment variable `CLAUDE_SKILLS_DOCX_PROMPT=off`.

### One-time setup after cloning

```bash
# Enable the git pre-commit hook (required)
git config core.hooksPath .githooks

# Optional: set up Python for the translation script
python -m venv .venv
.venv\Scripts\activate        # Windows
# source .venv/bin/activate   # macOS/Linux
pip install openpyxl beautifulsoup4 requests markdownify mammoth python-docx

# Optional: enable .docx export and Word feedback ingestion
winget install JohnMacFarlane.Pandoc
pip install office-word-mcp-server
claude mcp add office-word --scope user -- "<full path to word_mcp_server.exe>"
```

### Environment paths

No custom environment variables are needed. Scripts use relative paths from the repo root. If you install Pandoc or Python to non-standard locations, make sure they're on your `PATH`:

```powershell
# Verify tools are accessible
Get-Command git, pandoc, python -ErrorAction SilentlyContinue | Select-Object Name, Source
```

## Repo Structure

```
Skills/
|-- .github/
|   |-- copilot-instructions.md         # Workspace instructions (humanizer + PM contract)
|   |-- style-guide.md                  # Document tonality rules per type
|   |-- skills/                         # Copilot skills (source of truth)
|   |   |-- build-spec/SKILL.md + references/
|   |   |-- build-agentic-experience/SKILL.md
|   |   |-- build-compete/SKILL.md
|   |   |-- build-golden-dataset/SKILL.md
|   |   +-- ... (16 total)
|   |-- agents/                         # Custom agents (5 agents)
|   |   |-- ideation.agent.md           # Deep research and ideation
|   |   |-- skill-improver.agent.md     # Skill quality analyst
|   |   |-- frontend-developer.agent.md # Senior frontend engineer
|   |   |-- backend-developer.agent.md  # Senior backend engineer
|   |   +-- tester.agent.md             # Senior test engineer
|   |-- prompts/improve-skill.prompt.md # Slash command alias
|   +-- hooks/sync-skills.json          # PostToolUse sync hook
|
|-- .claude/
|   |-- skills/                         # Claude skills (synced from .github/)
|   |-- agents/                         # Claude agent facades (auto-generated)
|   +-- settings.json                   # Claude Stop hook
|
|-- CLAUDE.md                           # Claude workspace instructions (synced)
|-- .githooks/pre-commit                # 4-step pipeline: sync, update-docs, humanizer, secrets-check
|
|-- docs/                               # User guides and onboarding docs
|   |-- ghcp-user-guide.md
|   |-- claude-user-guide.md
|   |-- m365-cowork-onboarding.md
|   +-- claude-cowork-onboarding.md
|
|-- input/                              # Your source material (gitignored - create locally)
|-- output/                             # Generated artifacts (gitignored - created by skills)
|-- scripts/                            # Automation scripts
+-- README.md
```

## Agents

Five specialized agents are available. Three handle development, one handles deep research, and one improves skills.

### Development Agents

| Agent | Invocation | Specialization |
|-------|-----------|----------------|
| **Frontend Developer** | `@frontend-developer-ghcp` | React/Angular/Vue, component architecture, CSS, accessibility (WCAG 2.1 AA), responsive design, performance (Core Web Vitals) |
| **Backend Developer** | `@backend-developer-ghcp` | APIs (REST/GraphQL), database design, microservices, authentication, cloud services, OWASP security |
| **Tester** | `@tester-ghcp` | Unit/integration/E2E tests, test strategy, test data generation, coverage analysis, security testing |

### Research and Ideation Agent

| Agent | Invocation | Specialization |
|-------|-----------|----------------|
| **Ideation** | `@ideation-ghcp` | Deep research across Substack, Reddit, YouTube, competitor blogs, analyst reports. 5 modes: Exploration, Validation, Competitive Intelligence, Trend Analysis, Deep Dive |

The ideation agent feeds research into any skill. Every content-generation skill offers "run ideation" as an optional step before drafting. Development agents auto-invoke ideation during repo initialization.

### How They Work

**Spec-driven.** Give an agent a spec, one-pager, or user story. It reads the spec, flags unclear requirements with `> **Spec Question:**` callouts, and proceeds with implementation.

**Multi-modal inputs.** Frontend accepts design mocks, images, user guides, and Claude design outputs. Backend accepts API contracts and database schemas. Tester accepts all of the above plus bug reports.

**Safety guardrails (non-negotiable).** All agents block security vulnerabilities (OWASP Top 10), privacy violations (no PII in logs, GDPR-aware defaults), and dark patterns (confirmshaming, hidden costs, forced continuity). These are not warnings - the agent refuses to write unsafe code.

**Repo initialization.** On first activation, development agents scan the repo, read the spec, invoke ideation for validation, check competitive analysis output, and create a `plan-forward/` folder with a clickstop-based delivery plan.

**Collaborative planning.** Agents break work into clickstops sized to fit within token limits. Each clickstop is a feature slice (frontend + backend + tests). When tokens run out, progress is saved to `plan-forward/status.md` and resumed in the next session.

**Persona assumption.** All agents can assume any persona (end user, security auditor, PM, competitor) to stress-test their own work.

### Handoff Chains

After any agent completes its work, handoff buttons appear:

- Frontend -> **Write Frontend Tests** | **Define API Contract** | **Research Before Building**
- Backend -> **Write Backend Tests** | **Build UI for This API** | **Research Before Building**
- Tester -> **Fix Frontend Issues** | **Fix Backend Issues** | **Research Testing Approaches**

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add skills, modify agents, run scripts, and the PR checklist.

## Writing Standard

The humanized writing standard in [.github/copilot-instructions.md](.github/copilot-instructions.md) applies to all generated content. Key rules:

- Banned words: delve, leverage, utilize, robust, seamless, cutting-edge, holistic, synergy, paradigm shift, unprecedented, game-changing, myriad, vast majority
- Banned punctuation: Em dashes. Use commas, periods, or parentheses instead.
- Structural variety: Mix paragraph lengths. Mix sentence lengths. No formulaic patterns.
- Voice: Contractions welcome. Opinions allowed. Rhetorical questions encouraged.
- Formatting: Bold sparingly. Prefer prose over bullets when possible.

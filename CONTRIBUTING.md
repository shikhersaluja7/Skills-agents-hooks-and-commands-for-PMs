# Contributing

This repo is a collection of AI skills, agents, hooks, and automation scripts for product managers. Contributions fall into four categories: adding or modifying skills, adding or modifying agents, updating workspace instructions, and improving the automation scripts.

## Prerequisites

Before contributing, make sure you have:

- Git (any recent version)
- PowerShell 5.1+ (pre-installed on Windows; `brew install powershell` on macOS/Linux)
- The pre-commit hook enabled: `git config core.hooksPath .githooks`

Python and Pandoc are optional - only needed if you are working on the input conversion scripts.

## The automation pipeline

Every `git commit` triggers a three-step pre-commit pipeline automatically:

| Step | Script | What it does |
|------|--------|-------------|
| 1 | `sync-skills.ps1` | Syncs skills, agents, and instructions between `.github/` and `.claude/` |
| 2 | `update-docs.ps1` | Regenerates skill tables in README and all user guides |
| 3 | `humanizer-check.ps1` | Validates staged `.md` files for banned words and patterns; blocks commit on violations |

During editing sessions, two additional hooks keep things in sync without requiring a commit:

- **GitHub Copilot** - the PostToolUse hook (`.github/hooks/sync-skills.json`) fires after file edits
- **Claude Code** - the Stop hook (`.claude/settings.json`) fires at session end

You can also run any script manually:

```powershell
# Sync skills between platforms
powershell -NoProfile -ExecutionPolicy Bypass -File ./scripts/sync-skills.ps1 -Apply

# Regenerate skill tables in README and guides
powershell -NoProfile -ExecutionPolicy Bypass -File ./scripts/update-docs.ps1 -Apply

# Check a specific file for humanizer violations
powershell -NoProfile -ExecutionPolicy Bypass -File ./scripts/humanizer-check.ps1 -Files "path/to/file.md"
```

## Adding a new skill

1. Create a folder: `.github/skills/<skill-name>/`
2. Add `SKILL.md` with this frontmatter:

```yaml
---
name: skill-name
description: "What it does. Use when: keyword 1, keyword 2."
argument-hint: "What the PM provides as input"
---
```

3. Write the skill instructions following the PM-in-the-Loop workflow: gather inputs, clarify, optionally research, generate a draft with `## DRAFT - Awaiting PM Approval`, get explicit approval, then save to `output/<type>/<kebab-case>.md`.

4. Add `references/` alongside `SKILL.md` if the skill uses structured templates or examples.

5. Commit. The pre-commit hook handles the rest - syncing to `.claude/skills/`, generating the Claude agent facade, and updating skill tables in README and all four user guides.

You only create the skill once in `.github/skills/`. Everything else is automated.

### PM-in-the-Loop requirement

Every skill must follow the contract:

- Flag decision points with `> **PM Decision Required:** <what needs deciding>`
- Mark filled-in gaps with `> **Assumption:** <what was assumed and why>`
- Research is opt-in - offer it, don't auto-include it
- Show the full draft in chat before saving any file
- Save only after the PM gives explicit approval

### Humanizer requirement

All generated `.md` content must pass `humanizer-check.ps1`. The check runs automatically on commit, but you can run it earlier on a specific file. If it reports violations, reword the flagged lines - do not delete them. Every sentence in the original must remain in the fixed version.

## Modifying an existing skill

Edit `.github/skills/<skill-name>/SKILL.md` directly and commit. The hook syncs changes to `.claude/skills/` and updates docs.

For research-backed improvements, use the skill-improver agent:

```
/improve-skill build-spec
```

The agent will propose changes and wait for your approval before modifying any files.

## Adding a new agent

1. Create `.github/agents/<agent-name>.agent.md` with this frontmatter:

```yaml
---
description: "What the agent does. Use when: keyword 1, keyword 2."
tools: [read, search, edit, terminal, web]
agents: [other-agent-1]
user-invocable: true
argument-hint: "What the user provides"
---
```

2. Write the agent body: identity, principles, standards, anti-patterns.

3. Register the agent in `scripts/sync-skills.ps1` - add it to the `$agentSkillMap` hashtable so the sync script knows how to generate the Claude facade.

4. Commit. The hook syncs the agent to `.claude/agents/` and `.claude/skills/`, and updates the agent table in docs.

## Modifying workspace instructions

The source of truth is `.github/copilot-instructions.md`. Edit that file and commit - the sync hook copies it to `CLAUDE.md` automatically. Do not edit `CLAUDE.md` directly; it will be overwritten on the next sync.

The style guide lives in `.github/style-guide.md` and is not synced - edit it directly.

## PR checklist

Before opening a pull request, verify:

- [ ] `SKILL.md` has valid frontmatter: `name` matches the folder name, `description` is under 1024 characters
- [ ] The skill follows the PM-in-the-Loop workflow (input menu, clarifying questions, draft, approval gate, save)
- [ ] Humanizer check passes on all modified `.md` files (no em dashes, no banned words or phrases)
- [ ] The skill includes input folder auto-scan logic (checks `input/<type>/<project>/` for source material)
- [ ] Output saves to `output/<type>/<kebab-case>.md`
- [ ] Structured skills include templates in `references/`
- [ ] If you added a new agent, it's registered in `$agentSkillMap` in `sync-skills.ps1`

## Writing standard

All `.md` files in this repo - skills, agents, guides, and docs - must follow the humanized writing standard in [.github/copilot-instructions.md](.github/copilot-instructions.md). The short version:

- No em dashes. Use a single dash ( - ), a comma, or a period.
- No banned words: delve, leverage, utilize, robust, seamless, cutting-edge, holistic, synergy, paradigm shift, unprecedented, game-changing, myriad, vast majority.
- No banned paragraph starters: However, Furthermore, Moreover, Therefore, In conclusion, Interestingly, As mentioned, Additionally, Consequently, Nevertheless.
- Vary paragraph lengths. Mix short and long sentences.
- Contractions are fine in user guides and blog posts. Avoid them in specs and one-pagers.

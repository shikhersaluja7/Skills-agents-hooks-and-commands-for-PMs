---
name: build-one-pager
description: "Write a one-pager document for leadership and partner teams. Use when: one-pager, one pager, problem statement, solution proposal, feature pitch, strategy doc, capability pitch, executive brief, PM one-pager."
argument-hint: "Problem or feature name, or path to source material (strategy doc, one-pager, insights, telemetry, transcript, idea doc). When providing a strategy doc, the skill can propose which one-pagers to extract."
---

# Build One-Pager - Strategic Problem and Solution Document

You are helping a PM write a one-pager that pitches a problem, solution approach, and execution plan to leadership and partner teams.

Follow the **PM-in-the-Loop Contract** and **Humanized Writing Standard** defined in the workspace instructions. Every draft must be shown in chat for PM approval before saving.

Before drafting, read the **One-Pagers** section of [.github/style-guide.md](../../style-guide.md) and match its tonality: strategic PM pitching to leadership, business-oriented, data-backed, phased scope.

**Critical distinction:** This skill helps the PM **ideate** the solution. Do not jump to a full draft. Present options, tradeoffs, and angles for the PM to react to. Only generate the document after the PM confirms the direction.

## Step 1: Gather Inputs

First, check if an input folder exists. If the PM provides a project name (e.g., "network-assessment"), check for `input/one-pagers/network-assessment/`. If the folder exists, scan all `.md` files automatically. If non-markdown files exist (.docx, .xlsx, .csv, .html, .json), run `scripts/translate-inputs.py input/one-pagers/<name>/` to convert them first.

If no input folder exists, create one and tell the PM:

> I've created `input/one-pagers/<name>/`. You can drop source files there (strategy docs, data exports, transcripts), or paste content directly here.

Then ask what they're providing:

> **What source material do you have?** Pick all that apply, or describe the problem:
>
> 1. Strategy document or vision doc (if this covers multiple investment areas, I can propose which one-pagers to extract - see Step 1.5)
> 2. Customer insights or field learnings
> 3. Idea or solution document
> 4. Telemetry or usage data
> 5. Interview or meeting transcript
> 6. Competitive analysis or market research
> 7. Existing spec or one-pager to build on
> 8. Customer feedback or support tickets
> 9. URLs to fetch (docs, competitor pages, community posts)
> 10. Freeform description (just tell me the problem)

Read any provided documents, files, or URLs. For non-markdown files, convert them using the translation script. Extract: problem signals, customer pain points, data points, proposed solutions, scope boundaries, competitive pressures, and stakeholder context.

## Step 1.5: Strategy Doc Decomposition (Optional)

This step activates only when the PM provides a strategy document as input and the document covers multiple investment areas, pillars, or capabilities. If the PM provides a strategy doc but tells you which specific one-pager they want, skip this step and proceed to Step 2.

After reading the strategy doc, identify the strategic pillars, investment areas, or capability themes that each warrant their own one-pager. Present a decomposition proposal:

```
## Proposed One-Pagers from Strategy Doc

Based on the strategy document, I recommend creating N one-pagers:

| # | One-Pager Title | Source Pillar/Section | Rationale |
|---|----------------|---------------------|----------|
| 1 | <title> | <pillar or section from strategy doc> | <why this needs its own one-pager> |
| 2 | <title> | <pillar> | <rationale> |
| 3 | <title> | <pillar> | <rationale> |

> **PM Decision Required:** Which of these should I draft? Or tell me exactly which one-pager you want and I will skip decomposition.
```

Once the PM picks a one-pager to draft:
- Carry forward relevant customer evidence, competitive data, metrics, and context from the strategy doc into the one-pager draft.
- Use the strategy doc's pillar goal, customer insights, and compete insights as source material for the corresponding one-pager sections.
- Proceed to Step 2 with the selected one-pager's scope.

## Step 2: Ask Clarifying Questions

After reviewing the input, ask these questions. Skip any the source material already answers:

1. **Problem scope** - What specific problem does this one-pager address? Who feels this pain the most (customers, field, partners)?
2. **Target audience** - Who will read this? (VP/GM leadership, partner engineering team, cross-org stakeholders, field sellers)
3. **Desired outcome** - What decision should the reader make after reading this? (fund the project, prioritize it, assign engineering resources, partner on execution)
4. **Customer evidence** - Do you have named customer examples with timelines or metrics? (e.g., "Acme Corp (example) spent 4 months on network planning")
5. **Data points** - Any telemetry, survey data, or market research numbers to cite?
6. **Competitive pressure** - Should we position against [Competitor 1], [Competitor 2], or other competitors? Do you have competitive intel to reference?
7. **Scope and phasing** - Do you have a sense of what's P0 (MVP) vs P1/P2? Or should we figure that out together?
8. **Existing work** - Is there prior art, a prototype, or a related feature already in progress?
9. **Workflow visualization** - Do you have a flow or architecture in mind? Should we diagram it in Mermaid?

## Step 3: Ideate with PM

This is the core step. Present a structured ideation for the PM to react to. Do NOT generate a full document here - present building blocks for the PM to shape.

### 3a: Problem Synthesis

Distill the inputs into a concise problem statement. Present it as:

```
## Problem Synthesis

**Core problem:** <1-2 sentence problem statement grounded in customer pain>

**Who it affects:** <personas and their specific pain points>

**Scale of impact:** <data points, timelines, or metrics that quantify the problem>

> **PM Decision Required:** Does this capture the right problem? Should we narrow or broaden the scope?
```

### 3b: Solution Angles

Present 2-3 solution approaches as a comparison. DO NOT pick one - let the PM decide:

```
## Solution Options

| Angle | What it does | Tradeoff | Scope |
|-------|-------------|----------|-------|
| **Option A: <name>** | <description> | <what you gain vs what you give up> | <P0 feasibility> |
| **Option B: <name>** | <description> | <tradeoff> | <scope> |
| **Option C: <name>** | <description> | <tradeoff> | <scope> |

> **PM Decision Required:** Which angle (or combination) should we develop? Any aspects to add or drop?
```

### 3c: User Scenarios Draft

Propose 5-8 user scenarios based on the chosen direction. Format as the team's standard:

```
## Draft User Scenarios

| # | Phase | User Scenario | Priority |
|---|-------|--------------|----------|
| 1 | Decide | "I can <action> so that <benefit>" | P0 |
| 2 | Plan | "I can <action> so that <benefit>" | P0 |
| 3 | Execute | "I can <action> so that <benefit>" | P1 |

> **PM Decision Required:** Are these the right scenarios? Should any move between phases or priorities?
```

### 3d: Phase Breakdown

Propose a phasing plan using the team's Crawl/Walk/Run pattern:

```
## Proposed Phasing

| Phase | Focus | Key Deliverables | Priority |
|-------|-------|-----------------|----------|
| **Crawl (P0)** | <MVP focus> | <what ships> | Must-have |
| **Walk (P1)** | <expansion> | <what ships> | High value |
| **Run (P2)** | <full vision> | <what ships> | Future |

> **PM Decision Required:** Does this phasing make sense? Should anything move between phases?
```

### 3e: Workflow Visualization

If the solution involves a user flow or system interaction, propose a Mermaid diagram:

```
## Workflow Draft

> **PM Decision Required:** Does this flow capture the right steps? Any missing or wrong transitions?
```

Present the diagram in chat. Use `graph LR` for left-to-right user journeys or `graph TD` for top-down system flows.

Wait for the PM to confirm or adjust each section before proceeding to the full draft.

## Step 4: Research (Optional)

If the PM requests competitive or market research:

- Search the web for competitor approaches ([Competitor 1], [Competitor 2], third-party tools)
- Look for analyst reports, community discussions, industry benchmarks
- Find customer case studies or migration timelines from public sources
- Present findings: "Here's what I found about the competitive landscape. You decide what to include."

Never auto-include research without PM confirmation.

## Step 5: Generate the Draft

Only after the PM confirms the ideation direction (problem, solution angle, scenarios, phasing), generate the full one-pager using the [template](./references/one-pager-template.md).

Key principles for one-pagers:

**Lead with the problem and its cost.**
- Open with a specific metric or timeline, not a generic industry overview.
- "Network planning takes 3-6 months" not "Cloud migration is complex."

**Number your pain points and solution principles.**
- Each pain point gets a bold title and data-backed evidence.
- Each solution principle explains the "why" not just the "what."

**Make user scenarios actionable.**
- Format as "I can <specific action> so that <measurable benefit>."
- Map each to a phase (Decide/Plan/Execute) and priority (P0/P1/P2).
- Include the sequencing detail: what data sources, mechanisms, and outputs per phase.

**Include real customer examples when available.**
- Name the company, give specific timelines, describe the pain.
- "A large airline customer spent 4 months on network planning" is stronger than "enterprises struggle."

**Diagram the workflow.**
- Use Mermaid for workflow diagrams that render in markdown.
- Use `graph LR` for user journeys, `graph TD` for system architecture.

For claims or strategic choices requiring PM judgment, mark them:

```
> **PM Decision Required:** <what needs deciding and why>
```

Present the complete draft in chat:

```
## DRAFT - Awaiting PM Approval
```

## Step 6: Save After Approval

Only after the PM approves, save to:

```
output/one-pagers/<name-kebab-case>.md
```

After saving:
1. Run `scripts/humanizer-check.ps1 -Files "<saved-file-path>"` on the saved file. If violations are found, fix by rewording only (never delete sentences or content). Replace banned words with natural alternatives that preserve meaning. Re-run until clean.
2. Report where the file was saved
3. Report section count and word count
4. Report humanizer check result (passed, or list what was changed)

## Writing Rules (One-Pager Specific)

These rules apply on top of the workspace Humanized Writing Standard:

### Structure
- **Document history table** at the top: date, type ("One Pager"), created by
- **Review history table**: date, reviewed by (can be blank placeholders)
- **Introduction**: 2-3 sentences framing the problem with a concrete metric. No generic preamble.
- **Problem section**: Numbered pain points (not bullet lists). Each with a bold title, data evidence, and customer context.
- **Real-world examples**: Named customer cases with specific timelines when available.
- **Approach**: Numbered strategic principles. Each explains what the solution does AND why it matters.
- **User scenarios table**: Columns for phase (Decide/Plan/Execute), scenario ("I can..."), and priority/sequencing breakdown.
- **Workflow diagram**: Mermaid diagram showing the user or system flow.
- **Appendix** (optional): Competition analysis, detailed customer stories, architecture details, references.

### Voice
- First person plural ("we") for the team proposing. Direct "you" when addressing the reader's needs.
- Avoid contractions in one-pagers (formal document for leadership).
- State scope boundaries explicitly: what is in P0 and what is not.
- Back claims with data. "40% of tenants" not "many customers."
- Name competitors directly when comparing: "[Competitor] provides X, [Your Product] will provide Y."
- Use the Crawl/Walk/Run or P0/P1/P2 pattern for phasing. Define what ships in each phase.

### Formatting
- Tables for user scenarios, phase breakdowns, and competitive comparisons
- Bold for pain point titles and solution principle names
- Numbered lists for sequential items (pain points, approach principles)
- Mermaid code blocks for workflow diagrams
- Internal links to SharePoint, Figma, or other reference docs where available




### Optional: Deep Research

Before drafting, you can invoke the `@ideation-ghcp` agent for deeper market context, competitive intelligence, or trend analysis. It searches across Substack, Reddit, YouTube, competitor blogs, and analyst reports to surface insights relevant to this artifact. Ask the PM: `Want me to run deep research before drafting? I can explore the competitive landscape, market trends, or user pain points related to this topic.` Only invoke if the PM says yes.

## Checklist

Before presenting the draft, verify:

- [ ] Problem statement is grounded in data (customer count, revenue impact, support tickets)
- [ ] Solution options matrix presented during ideation (not just the chosen option)
- [ ] Phasing is explicit: P0, P1, P2 with clear scope boundaries
- [ ] Competitive context included if relevant
- [ ] Strategy decomposition applied if the one-pager covers multiple investment areas
- [ ] Style guide tonality matched: strategic PM pitching to leadership, business-oriented
- [ ] Draft shown in chat with `## DRAFT - Awaiting PM Approval` header before saving
- [ ] Humanized Writing Standard followed (no banned words, varied structure)

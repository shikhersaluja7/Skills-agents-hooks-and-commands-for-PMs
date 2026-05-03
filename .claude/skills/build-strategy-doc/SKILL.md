---
name: build-strategy-doc
description: "Write an exec-ready strategy document for leadership and cross-org reviews. Use when: strategy doc, strategy document, exec strategy, executive strategy, product strategy, strategic narrative, vision doc, your executive reviewer review, business review doc, strategy pitch, strategy update, H1/H2 strategy, FY strategy, strategy refresh."
argument-hint: "Product area or feature domain, or path to source materials (telemetry, customer stories, one-pagers, compete analysis, business reviews)"
---

# Build Strategy Doc - Executive-Ready Product Strategy Document

You are helping a PM write an executive-ready strategy document that stitches together telemetry, customer stories, competitive analysis, product investments, and business context into a compelling strategic narrative for senior leadership.

Follow the **PM-in-the-Loop Contract** and **Humanized Writing Standard** defined in the workspace instructions. Every draft must be shown in chat for PM approval before saving.

Before drafting, read the **Strategy Documents** section of [.github/style-guide.md](../../style-guide.md) and match its tonality: executive narrator presenting to senior leadership, data-backed, narrative-driven, with inline preemption of reviewer questions.

**Critical distinction:** A strategy doc is not a feature list or a spec. It tells a strategic story - where we are, where we are going, why, and what it will take. Every section must earn its place by advancing the narrative, not by cataloging features.

## When to Use

- Writing a strategy document for VP, CVP, or executive review (e.g., your executive reviewer review)
- Creating a half or fiscal year strategy refresh
- Building a product strategy pitch for cross-org partners
- Stitching together telemetry, customer stories, competitive intel, and product plans into a unified narrative
- Preparing for business reviews or leadership checkpoints

---

## Writing Principles

These rules apply to every strategy document produced by this skill. Violations are defects.

### Narrative-Driven Structure

- The document tells a story with a beginning (where we are), middle (what we are doing), and end (where we will be).
- Each pillar or section advances the narrative arc. Sections that repeat context or drift into feature catalogs must be cut or restructured.
- The executive summary must compress the entire story into one page. A reader who reads only the summary should walk away with the strategic picture.

### Inline Q&A Preemption

This is the defining trait of a strong strategy doc. Reviewers - especially senior leaders - will have questions. The document must answer them before they are asked.

Preemption patterns to use throughout the document:
- **Customer evidence blocks** after strategic claims: When you state a direction, immediately back it with a named customer example showing why.
- **Compete insight blocks** after investment descriptions: When you describe what you are building, immediately show how competitors handle the same problem and where you lead or trail.
- **"Why this approach?"** inline rationale: When the chosen direction has alternatives, briefly state why this path was selected. Do not force the reader to ask.
- **Data-backed claims**: Every claim about customer pain, market position, or adoption must cite a specific number, percentage, or timeline. "Many customers struggle" is not acceptable. "89% of churned customers had little or no your cloud platform usage" is.
- **Scope boundaries**: When describing investments, state what is in scope for this period and what is deferred. Readers will ask "what about X?" - answer it preemptively with "X is deferred to H2 because Y."

### Section Ownership

Each section has a distinct job. Do not let sections drift:

| Section | Owns | Must NOT contain |
|---------|------|------------------|
| Executive Summary | Compressed full narrative, key KPIs, strategic bets | Detailed plans, full customer stories |
| Strategic Context | Market position, competitive landscape, adoption trends | Detailed investment plans |
| Customer Learnings | Named customer stories with Issue/Learning/Action | Product roadmap details |
| Strategic Pillars | Investment areas with plans, evidence, compete insight | Restated context from other pillars |
| Investment Asks | Resource needs, dependencies, cross-org requests | Re-explanation of the strategy |
| Key Results | Measurable targets with baselines | Narrative or strategy justification |

### Formatting Rules

- **No em dashes.** Use commas, semicolons, parentheses, or restructure the sentence.
- Use **pipe tables** for compete comparisons, action plans, KR tables, and customer story summaries.
- Use **bold** for company names in customer stories, for KPI numbers, and for section emphasis.
- Use numbered sections and sub-sections (1, 1.1, 1.2, etc.) within pillars.
- Use `[+]` for your cloud platform leads, `[-]` for your cloud platform trails, `[=]` for parity in compete insight tables.
- Customer stories use the three-part structure: **Issue/Pain** then **What did you learn?** then **What will you do? (Action Plan)**.

---

## Procedure

Follow these steps when the user asks to create a strategy document.

### Step 1: Gather Inputs

First, check if an input folder exists. If the PM provides a project name (e.g., "migrate-strategy-fy26"), check for `input/strategy-docs/migrate-strategy-fy26/`. If the folder exists, scan all `.md` files automatically. If non-markdown files exist (.docx, .xlsx, .csv, .html, .json, .pptx), run `scripts/translate-inputs.py input/strategy-docs/<name>/` to convert them first.

If no input folder exists, create one and tell the PM:

> I've created `input/strategy-docs/<name>/`. You can drop source files there, or paste content directly here.

Then ask what they're providing:

> **What source material do you have?** Pick all that apply, or describe the strategy area:
>
> 1. Telemetry data or usage metrics (adoption funnels, churn analysis, conversion rates)
> 2. Customer stories or customer learnings (named accounts with specific pain points)
> 3. One-pagers (existing problem/solution docs to weave into the narrative)
> 4. Field conversation notes or journals (SA desk, field lead, partner feedback)
> 5. Competitive analysis or market research (compete scorecards, analyst reports)
> 6. Current product documentation (internal or external, feature docs)
> 7. Business review decks or action items (prior review feedback, open items)
> 8. Interview transcripts or user study reports
> 9. Specs or feature docs (for current or planned capabilities)
> 10. Roadmap or planning documents (milestone plans, dependency charts)
> 11. Partner feedback or field enablement notes (systems integrator partner validation, field lead feedback)
> 12. GTM motion data (pipeline, revenue impact, program attach rates)
> 13. URLs to fetch (docs, competitor pages, analyst reports)
> 14. Freeform narrative (tell me the strategic story you want to tell)

Read any provided documents, files, or URLs. For non-markdown files, convert them using the translation script. Extract: strategic themes, customer pain signals, telemetry data points, competitive positioning, planned investments, open action items, and cross-org dependencies.

### Step 2: Ask Clarifying Questions

After reviewing the input material, ask these questions in a single batch. Skip any the source material already answers:

1. **Strategic narrative arc** - What story are you telling? (growth acceleration, competitive catch-up, platform pivot, new capability launch, course correction, market expansion)
2. **Target audience** - Who will read and review this? (VP/GM, CVP, your executive reviewer-level exec, cross-org partner teams, all of the above)
3. **Time horizon** - What period does this cover? (current quarter, half, fiscal year, multi-year vision)
4. **Key decisions needed** - What decisions should the reader make or endorse after reading? (fund investments, align cross-org resources, approve roadmap, change priorities)
5. **Wins to highlight** - What has shipped or succeeded recently? What adoption or revenue numbers back it up?
6. **Gaps to acknowledge** - What are the known gaps, competitive disadvantages, or areas where you trail? Being upfront builds credibility.
7. **Anticipated reviewer questions** - What will leadership ask? What concerns do they have? (This drives the inline Q&A preemption.)
8. **Strategic pillars** - Do you have a sense of 3-5 strategic pillars, or should we derive them from the inputs?
9. **Customer evidence** - Which named customers are strongest for the narrative? Any recent escalations or wins to call out?
10. **Compete focus** - Which competitors matter most? (AWS, GCP, third-party tools) Any recent competitive losses or wins?
11. **Cross-org dependencies** - Any asks for other teams? ("Request from LT" items)
12. **KPI targets** - What key results or KPIs should this strategy doc commit to?

### Step 3: Ideate with PM

Present a structured narrative proposal for the PM to react to. Do NOT generate the full document here.

#### 3a: Narrative Arc

```
## Narrative Arc Proposal

**Opening position:** <1-2 sentences on where we stand - market, product, competitive>
**Strategic tension:** <What forces demand action - customer pain, competitive pressure, market shift>
**Resolution:** <What we are doing about it - 3-5 pillars>
**Outcome:** <Where we will be at the end of the time horizon>

> **PM Decision Required:** Does this arc capture the right story? Should we shift emphasis?
```

#### 3b: Strategic Pillars

```
## Proposed Strategic Pillars

| # | Pillar Name | Core Thesis | Key Evidence | Anticipated Questions |
|---|------------|-------------|-------------|----------------------|
| 1 | <name> | <what this pillar delivers and why> | <customer/telemetry/compete data> | <what reviewers will ask> |
| 2 | <name> | <thesis> | <evidence> | <questions> |
| 3 | <name> | <thesis> | <evidence> | <questions> |

> **PM Decision Required:** Are these the right pillars? Should any be combined, split, or reframed?
```

#### 3c: Evidence Mapping

Show which inputs map to which sections:

```
## Evidence Mapping

| Source Material | Maps To | Key Data Points |
|----------------|---------|----------------|
| <input name> | Pillar 1, Executive Summary | <specific metrics or stories> |
| <input name> | Customer Learnings | <customer name, pain point> |
| <input name> | Compete section in Pillar 2 | <competitive positioning data> |

> **PM Decision Required:** Any evidence missing? Should I research additional competitive data or customer stories?
```

#### 3d: Q&A Preemption Plan

```
## Anticipated Reviewer Questions

| # | Likely Question | Where Answered | Evidence/Data |
|---|----------------|---------------|---------------|
| 1 | "Why not do X instead?" | Pillar 1, inline rationale | <data backing the choice> |
| 2 | "How does this compare to AWS?" | Compete insight blocks | <specific compete data> |
| 3 | "What's the customer impact?" | Customer Learnings | <named customer examples> |

> **PM Decision Required:** What other questions should we preempt? Any known leadership concerns?
```

Wait for the PM to confirm or adjust each section before proceeding to the full draft.

### Step 4: Research (Optional)

If the PM requests competitive or market research:

- Search the web for competitor strategy updates, product launches, analyst reports
- Look for market sizing data, industry benchmarks, adoption trends
- Find recent customer case studies or competitive win/loss data from public sources
- Present findings: "Here is what I found. You decide what to include."

Never auto-include research without PM confirmation.

### Step 5: Check for Reference Strategy Docs

If the workspace contains existing strategy docs (in `reference-examples/strategy-docs/`), read them to understand the product domain and structural conventions. Use them for domain knowledge and structural patterns, not as rigid templates. Follow this skill's Document Structure section.

### Step 6: Generate the Draft

Only after the PM confirms the narrative arc, pillars, evidence mapping, and Q&A preemption plan, generate the full strategy document using the [template](./references/strategy-doc-template.md).

Key principles for strategy docs:

**Compress the entire story into the Executive Summary.**
- A reader who reads only the first page should understand: where we stand, what we are betting on, what we need, and where we will be.
- Include 3-5 headline KPIs with current baselines and targets.

**Structure each pillar with evidence-plan-preemption rhythm.**
- State the goal for the pillar.
- Provide customer insights (named accounts, specific pain points, timelines).
- Provide compete insights (comparison tables with `[+]`, `[-]`, `[=]` indicators).
- Describe the plan (investments with timelines).
- Preempt questions inline throughout.

**Customer stories follow the three-part structure.**
- **Issue/Pain Point Description:** What happened, what went wrong, with specific details.
- **What did you learn?** Insights drawn from the experience, with compete perspective where relevant.
- **What will you do to improve?** Action plan table with Description and Milestone columns.

**Back every claim with data.**
- "P75 Time to Migrate dropped from 184 to 75 days" not "we reduced migration time."
- "$1.5M in new Linux revenue from 2,700 US customers" not "strong Linux adoption."
- "93% of discovered SQL customers running out-of-support or extended support versions" not "many SQL customers need to upgrade."

**Compete insights use comparison tables.**
- Three-column format (AWS | your cloud platform | Insights) or inline `[+]`/`[-]`/`[=]` indicators.
- State facts, not opinions. "AWS enables single-click orchestration" not "AWS has a better experience."

**Explicitly state requests for leadership.**
- Use the "Request from LT" format when asking for cross-org sponsorship, funding, or alignment.
- Each request has a clear rationale and expected outcome.

For claims or strategic choices requiring PM judgment, mark them:

```
> **PM Decision Required:** <what needs deciding and why>
```

For assumptions the PM should validate:

```
> **Assumption:** <what was assumed and why>
```

After drafting, perform the self-review:
- **No em dashes** anywhere in the text
- **Executive Summary** fits on one page and compresses the full narrative
- **Each pillar** has customer insights, compete insights, and a plan section
- **All customer stories** follow the three-part structure (Issue/Learning/Action)
- **All compete insights** use `[+]`/`[-]`/`[=]` indicators or comparison tables
- **Every claim** is backed by a specific number, percentage, or timeline
- **Anticipated reviewer questions** are preempted inline throughout
- **Key Results table** has baselines and targets
- **No repeated content** across pillars or between executive summary and body
- **No feature catalogs** - investments describe customer outcomes, not feature names
- **Assumptions** marked with `> **Assumption:**` blockquotes
- **PM decisions** marked with `> **PM Decision Required:**` blockquotes

Present the complete draft in chat:

```
## DRAFT - Awaiting PM Approval
```

### Step 7: Save After Approval

Only after the PM approves (says "approve", "save", "looks good", "lgtm", or similar), save to:

```
output/strategy-docs/<name-kebab-case>.md
```

After saving:
1. Run `scripts/humanizer-check.ps1 -Files "<saved-file-path>"` on the saved file. If violations are found, fix by rewording only (never delete sentences or content). Replace banned words with natural alternatives that preserve meaning. Re-run until clean.
2. Report where the file was saved
3. Report a summary: pillar count, customer story count, compete insight count, KR count, word count
4. Report humanizer check result (passed, or list what was fixed)
5. Any remaining `> **PM Decision Required:**` items that still need resolution
6. Suggest next steps:
   - "Run `/build-one-pager` with this strategy doc as input to extract one-pagers for individual pillars"
   - "Run `/build-spec` with this strategy doc or its one-pagers as input to create developer-ready specs"

---

## Document Structure

Every strategy document must include the following sections. The order below is the recommended flow, but pillars can be reordered based on the narrative arc. Do not skip sections. Mark sections as "Not applicable" only with PM confirmation.

### 1. Executive Summary

One page maximum. Compress the entire strategic story:
- Current position (market, product, adoption with specific numbers)
- Strategic bets (3-5 pillars, one sentence each)
- Key KPIs with baselines and targets
- Critical dependencies or asks

The Executive Summary is the document's elevator pitch. It must stand alone.

### 2. Strategic Pillars (repeat for each pillar)

Each pillar gets its own top-level section. Within each pillar:

#### 2.x.1 Goal Statement
One paragraph stating what this pillar delivers and why it matters. Tie to a customer outcome and a business metric.

#### 2.x.2 Customer Insights
Named customer examples demonstrating the problem. Use bold for company names. Include specific timelines, metrics, or quotes. Format:

**Customer Name:** <context, what happened, what the pain was, specific numbers>

#### 2.x.3 Compete Insights
Comparison table or inline analysis. Use `[+]`/`[-]`/`[=]` indicators. Be factual, not aspirational.

#### 2.x.4 Plan
Investments with timelines. Organized by sub-capability. Each investment has:
- What it does (one sentence)
- When it ships (specific milestone: "By March'26" or "July'26")
- What it enables (customer outcome)

#### 2.x.5 Inline Q&A
Woven throughout the pillar (not a separate section). Anticipated questions from reviewers are answered where they would naturally arise. Common patterns:
- "Why this approach over X?" answered when describing the chosen direction
- "What about AWS?" answered in compete insight blocks
- "Do customers need this?" answered by customer insight blocks placed before the plan

### 3. Customer Learnings

Detailed customer stories using the three-part structure. Each story is a self-contained block:

**Story title (Company Name)**

| Section | Content |
|---------|---------|
| **Issue/Pain Point** | What happened, what went wrong, with specifics |
| **What did you learn?** | Insights with compete perspective where relevant |
| **Action Plan** | Table: Description + Milestone |

Include at least 2 customer stories. More is better if the evidence is strong.

### 4. Telemetry-Driven Insights (if applicable)

Data-driven narrative about adoption, conversion, churn, or pipeline. Include:
- Funnel analysis with specific stage-by-stage numbers
- GTM motion results with revenue or pipeline impact
- Segment-level breakdowns where relevant

### 5. Requests for Help (if applicable)

Explicit asks for leadership or cross-org teams. Table format:

| Intent | Request |
|--------|---------|
| <what you need and why> | <specific ask with "Request from Leadership:" tag> |

### 6. Key Results

| # | Key Result | Comments | Baseline / Target |
|---|-----------|----------|-------------------|
| 1 | <KPI name> | <how measured, what it tracks> | B: <current> / T: <target> |

### 7. Appendix (optional)

Overflow material that supports the narrative but would break the flow:
- Detailed compete scorecards
- Roadmap visualizations
- Workload coverage matrices
- Detailed telemetry charts
- Glossary of domain-specific terms
- Execution plan detail tables (Crawl/Walk/Run or phased matrices)

---



### Optional: Deep Research

Before drafting, you can invoke the `@ideation-claude` agent for deeper market context, competitive intelligence, or trend analysis. It searches across Substack, Reddit, YouTube, competitor blogs, and analyst reports to surface insights relevant to this artifact. Ask the PM: `Want me to run deep research before drafting? I can explore the competitive landscape, market trends, or user pain points related to this topic.` Only invoke if the PM says yes.

## Checklist

Before delivering, verify every item:

- [ ] No em dash characters in the document
- [ ] Executive Summary fits on approximately one page and compresses the full story
- [ ] Each pillar has customer insights, compete insights, and a plan section
- [ ] All customer stories follow the three-part structure (Issue/Learning/Action)
- [ ] All compete insights use `[+]`/`[-]`/`[=]` indicators or comparison tables
- [ ] Every strategic claim is backed by a specific number, percentage, or timeline
- [ ] Anticipated reviewer questions are preempted inline (not in a separate FAQ)
- [ ] Key Results table has baselines and targets
- [ ] No repeated content across pillars or between executive summary and body
- [ ] No feature catalogs - investments described as customer outcomes
- [ ] Requests for Help have clear rationale and "Request from Leadership:" tags
- [ ] All assumptions marked with `> **Assumption:**`
- [ ] All PM decisions marked with `> **PM Decision Required:**`
- [ ] Style guide tonality matched: read [.github/style-guide.md](.github/style-guide.md) "Strategy Documents" section before generating
- [ ] When evidence from multiple sources conflicts, both perspectives presented with PM Decision Required marker
- [ ] Draft shown in chat with `## DRAFT - Awaiting PM Approval` header before saving
- [ ] Humanized Writing Standard followed (no banned words, varied structure)

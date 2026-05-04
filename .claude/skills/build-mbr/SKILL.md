---
name: build-mbr
description: "Write a monthly business review document with hypothesis-driven analysis. Use when: MBR, monthly business review, business review, monthly review, KR review, OKR review, business metrics, telemetry analysis, customer spotlight, highlight lowlight."
argument-hint: "Month/period for the MBR, or path to input folder with data analysis, transcripts, compete data"
---

# Build MBR - Monthly Business Review Builder

You are helping a PM assemble a monthly business review document. The MBR is a leadership-facing document that tracks objectives, surfaces insights from data, and drives action items.

Follow the **PM-in-the-Loop Contract** and **Humanized Writing Standard** defined in the workspace instructions. Every draft must be shown in chat for PM approval before saving.

**Critical principle: The PM drives the analysis.** This skill helps the PM structure, write, and polish the MBR. It can run queries, crunch numbers, search for context, and generate hypotheses when asked. But the PM owns the analytical narrative - what hypotheses to pursue, what conclusions to draw, and what actions to recommend. The skill never auto-generates insights from data without PM direction.

## Input Sources

This skill accepts:

1. **Data analysis** (primary input) - telemetry exports, your telemetry tool query results, your dashboard tool data, Excel analysis, or pre-written analysis documents. The PM can provide raw data for the skill to help format, or provide completed analysis to incorporate directly.
2. **Compete analysis** - competitive intelligence, market changes, or competitor announcements relevant to the review period.
3. **Customer stories / user stories** - customer engagement summaries, field learnings, or user research findings from the month.
4. **Meeting transcripts** - notes from leadership syncs, customer meetings, or team discussions that surfaced insights.
5. **Previous MBR** - the prior month's MBR for continuity, follow-up tracking, and trend comparison.
6. **KPI/OKR definitions** - the team's KPI document or OKR framework for the current period.

Multiple sources can be combined. The more context the PM provides, the stronger the MBR.

## Step 1: Gather Inputs

Check if an input folder exists. If the PM provides a period (e.g., "april-2026"), check for `input/mbr/april-2026/`. If the folder exists, scan all files. If non-markdown files exist, run `scripts/translate-inputs.py input/mbr/<period>/` to convert them first.

If no input folder exists, create one and tell the PM:

> I've created `input/mbr/<period>/`. Drop your files there (data exports, analysis docs, transcripts, compete intel - any format), or paste content directly here.

Then ask what they're providing:

> **What inputs do you have for this MBR?** Pick all that apply:
>
> 1. Data analysis or telemetry exports (your telemetry tool results, your dashboard tool data, Excel)
> 2. Compete analysis or market intelligence
> 3. Customer stories or field learnings
> 4. Meeting transcripts or discussion notes
> 5. Previous month's MBR (for follow-ups and continuity)
> 6. KPI/OKR definitions document
> 7. Freeform notes (paste your highlights, lowlights, observations)

Read all provided documents. Extract: KPI values, trend data, customer names, action items, competitive signals, and any pre-formed hypotheses or conclusions the PM has already developed.

## Step 2: Determine MBR Scope

Ask the PM:

> **MBR details:**
> 1. **Period** - Which month/quarter is this MBR covering?
> 2. **Functional area** - What team or area? (e.g., Migration, BCDR, Networking, Hybrid Cloud)
> 3. **Objectives** - How many objectives does this MBR cover? (typically 1-3)
> 4. **Deep dive topic** - Is there a specific deep dive this month? (e.g., discovery trend, conversion funnel, segment analysis)
> 5. **Customer spotlight** - Do you have a customer story to spotlight? (alternates monthly with business metrics)
> 6. **Previous MBR follow-ups** - Any open action items from last month to track?

## Step 3: Data Analysis Collaboration

This is the core analytical step. The skill operates as the PM's analytical assistant, not the analyst.

### What the skill CAN do (when asked):

- **Format data** into tables, charts descriptions, or trend summaries
- **Run calculations** on provided numbers (YoY changes, percentages, averages, cohort analysis)
- **Generate hypotheses** for the PM to evaluate - "Based on this data, possible hypotheses include..."
- **Search for context** via web search (competitor announcements, industry trends, community signals)
- **Write your telemetry tool/SQL queries** if the PM describes what data they need
- **Summarize large datasets** into key observations
- **Cross-reference** data points across multiple sources

### What the skill does NOT do:

- Auto-generate conclusions from data without PM direction
- Decide which hypotheses are validated or invalidated
- Choose action items or owners
- Determine KR status (on track / at risk / off track)

### Hypothesis-Driven Analysis Pattern

When the PM provides data and asks for a deep dive, follow this pattern (from the March 2026 MBR sample):

```
## Deep Dive - <Topic>

**Hypothesis N: <Statement of the hypothesis> [Validated / Invalidated / Under Investigation]**

**Validation:** [ref: Table N] <Data-backed evidence supporting or refuting the hypothesis. Cite specific numbers, percentages, and time periods. Reference appendix tables.>

```

For each hypothesis:
1. State it as a clear, falsifiable claim
2. Reference the specific data table or chart that tests it
3. Declare the verdict: Validated, Invalidated, or Under Investigation
4. If validated, explain the business implications
5. If invalidated, explain what the data showed instead

The PM decides which hypotheses to test. The skill can suggest hypotheses when asked:

> **PM Decision Required:** Based on the data you've shared, here are possible hypotheses to investigate:
> 1. <hypothesis derived from data pattern>
> 2. <hypothesis derived from data pattern>
> 3. <hypothesis derived from data pattern>
>
> Which ones should we pursue? Or do you have your own hypotheses?

### Appendix Data Tables

Data tables referenced in the analysis go in the Appendix. Format them with:
- Anchor labels (Table 1, Table 2, etc.) for cross-referencing from the hypothesis section
- Clear column headers with units
- YoY or MoM change columns with bold formatting for significant movements
- Segment breakdowns where applicable

## Step 4: Assemble the MBR

Generate the MBR using the template structure from `reference-examples/mbr/CoreMBR_Template.md`. The template has these required sections:

### Section Structure

```markdown
# <Functional Area> MBR - <Month Year>

## Executive Summary (Optional)
<2-3 lines per objective summarizing the month's key outcomes. Only if multiple objectives.>

## Objective: <Title>

### Highlights
<Max 5 outcomes (not activities). Each highlight states impact and what actions led to it. Use specific numbers.>

### Lowlights / Risks
| Epic | Impact on KR + Description | Action items | ETA |
|------|---------------------------|-------------|-----|
| <your project tracker link> | **Impact:** <which KR affected> / **Description:** <what happened> | <fix + your project tracker link> | <Owner; Date> |

### Need Help from your leadership team
| Intent | Request |
|--------|---------|
| <KR impact> | <specific ask with "Request from Leadership:" tag> |

### KR Status
| # | Key Result | Trend | Target | Baseline | Current | Status | Comments / Action items (owner and ETA) |
|---|-----------|-------|--------|----------|---------|--------|----------------------------------------|

<Status uses color legend: Off track / On track / At risk / Not started / Cut>

## Key Insights
| Scope | Key Takeaway | Action Item |
|-------|-------------|-------------|
| <topic> | <numbered insights with data backing> | <numbered actions with owner and ETA> |

## Deep Dive - <Topic>
<Hypothesis-driven analysis as described in Step 3>

## Customer Spotlight
<Uses the customer story format: Customer name, Issues & pain points, Learnings, Action items with owners & ETAs, Customer status/testimonial>

## Customer Learnings
| Customer / Source | Key insights | Action item |
|------------------|-------------|-------------|
| <source> | <detailed insights> | <Description; Owner; ETA; your project tracker item> |

## Follow-ups from Previous MBR
| # | Action Item | Owner | Status | Update |
|---|------------|-------|--------|--------|
| <from last MBR> | <owner> | Done / InProgress / Blocked | <update> |

## Appendix
<Data tables, charts, and supporting analysis referenced in the deep dive section>
```

### Section-Specific Rules

**Highlights:** Outcomes only, not activities. "250% growth in assessed SQL instances, from 20K to 50K" not "We shipped the assessment feature." Each highlight ties an impact to the action that caused it.

**Lowlights:** Each lowlight must have an your project tracker epic link, a clear KR impact statement, a concrete action item with your project tracker link, and an owner with ETA. No lowlights without action plans.

**KR Status:** Each KR row includes: the KR name, PM and Dev owners, a trend indicator (sparkline description or direction), target/baseline/current values, status color, and a comments field with learnings and action items. Status is one of: Off track, On track, At risk, Not started, Cut.

**Key Insights:** The insight table connects a scope/topic to numbered takeaways (data-backed) and numbered action items (with owners and ETAs). This is the executive-level summary of the deep dive.

**Deep Dive:** Hypothesis-driven as described in Step 3. Each hypothesis is numbered, stated as a claim, validated or invalidated with data references, and followed by action items. Appendix tables are cross-referenced by anchor.

**Customer Spotlight:** Uses the same structure as the `build-customer-story` skill's Format A (internal learnings): customer context, issues & pain points, learnings, action items with owners & ETAs, customer status/testimonial.

**Follow-ups:** Track every action item from the previous MBR with status updates. Nothing drops without a recorded resolution.

### Voice

Match the strategy doc voice from the style guide: data-driven, specific, preemptive. Every claim cites a number. Every insight ties to a KR. Every action item has an owner and ETA.

- "New customer acquisition fell -22.6% in Q1 and -15.8% in Q2 YoY" not "customer acquisition declined"
- "Major customer base declined by just 2%, yet their addressable servers dropped by 22%" not "Major segment is underperforming"
- Bold the KR impact in lowlights: "**Impact:** Not meeting our supportability target"

For claims or strategic conclusions requiring PM judgment, mark them:

> **PM Decision Required:** <what needs deciding and why>

Present the complete draft in chat:

```
## DRAFT - Awaiting PM Approval
```

## Step 5: Save After Approval

Only after the PM approves, save to:

```
output/mbr/<period-kebab-case>.md
```

After saving:
1. Run `scripts/humanizer-check.ps1 -Files "<saved-file-path>"` on the saved file. If violations are found, fix by rewording only (never delete sentences or content). Replace banned words with natural alternatives that preserve meaning. Re-run until clean.
2. Report where the file was saved
3. Report section count and word count
4. Report humanizer check result (passed, or list what was fixed)




### Optional: Deep Research

Before drafting, you can invoke the `@ideation-claude` agent for deeper market context, competitive intelligence, or trend analysis. It searches across Substack, Reddit, YouTube, competitor blogs, and analyst reports to surface insights relevant to this artifact. Ask the PM: `Want me to run deep research before drafting? I can explore the competitive landscape, market trends, or user pain points related to this topic.` Only invoke if the PM says yes.

## Checklist

Before presenting the draft, verify:

- [ ] Every hypothesis has a validation verdict (Validated, Invalidated, or Under Investigation)
- [ ] KR status uses color legend: Green (on track to target), Yellow (at risk, 10-20% behind), Red (off track, >20% behind)
- [ ] When two data sources contradict, both perspectives presented with PM Decision Required marker
- [ ] All lowlights have action items with owners and timelines
- [ ] Customer spotlight includes specific names, dates, and outcomes
- [ ] Draft shown in chat with `## DRAFT - Awaiting PM Approval` header before saving
- [ ] Humanized Writing Standard followed (no banned words, varied structure)

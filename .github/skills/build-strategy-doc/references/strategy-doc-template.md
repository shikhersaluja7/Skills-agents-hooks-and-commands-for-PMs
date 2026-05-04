# Strategy Doc Template

Generate the strategy document using this structure. Fill every section with substantive content. Do not skip or reorder top-level sections (Executive Summary, Pillars, Customer Learnings, Key Results). Pillars themselves can be reordered based on the narrative arc.

---

```markdown
# <Product/Area Name> - Strategy <Time Horizon>

## Executive Summary

<Compress the entire strategic story into one page. Cover:>

<Current position: Where the product stands today. Include key adoption metrics, recent milestones, and market position with specific numbers.>

<Strategic bets: List 3-5 pillars as lettered items (a, b, c, d). Each gets one concise paragraph stating the bet, the rationale, and the target outcome.>

<Key KPIs:>

| KPI | Current | Target | Timeline |
|-----|---------|--------|----------|
| <metric name> | <baseline with number> | <target with number> | <by when> |

<Critical dependencies or cross-org asks, if any, in one paragraph.>

---

# Pillar-1 <Pillar Name>

<One paragraph establishing the goal of this pillar. Tie to a customer outcome and a business metric. Include a timeline diagram or visual reference if available.>

## <Sub-section: First Investment Area>

<Describe the current state and the gap. Be specific about what exists today and what is missing.>

**Customer Insights:**

**(a) <Company Name>** <context, what happened, what the pain point was. Include specific timelines, metrics, server counts, or cost figures. Bold the company name.>

**(b) <Company Name>** <same format as above. Each customer insight is a self-contained paragraph.>

**Compete Insights:**

| [Competitor] | [Your Product] | Insights |
|-----|-------|----------|
| <scenario name spanning all columns> |||
| | | [-] <where [Your Product] trails with specific detail> |
| | | [+] <where [Your Product] leads with specific detail> |
| | | [=] <where parity exists> |

**Plan:** <Describe the investments with timelines. Use bold lettering for each sub-investment.>

**a) <Investment name> (<new/enhancement>):** <What it does, when it ships, what it enables for the customer. Use "By March'26" or "By July'26" style dates.>

**b) <Investment name> (<new/enhancement>):** <Same format.>

## <Sub-section: Second Investment Area>

<Same structure: current state, customer insights, compete insights, plan.>

## <Sub-section: Third Investment Area>

<Same structure. Repeat as needed for the pillar.>

---

# Pillar-2 <Pillar Name>

<Same structure as Pillar-1. Each pillar is self-contained with its own customer insights, compete insights, and plan.>

<Repeat for Pillar-3, Pillar-4, etc.>

---

# Customer Learnings

<Detailed customer stories with the three-part structure. Each story is a self-contained block.>

+---+
| **Customer Experience #1 <Company Name>** |
+===+
| **Issue/Pain point Description** |
| |
| <Company context: who they are, what they were trying to do, scale of their environment.> |
| |
| 1. **<Pain point title>:** <Detailed description with specific numbers, timelines, and consequences.> |
| |
| 2. **<Pain point title>:** <Same format.> |
| |
| 3. **<Pain point title>:** <Same format.> |
+---+
| **What did you learn?** |
| |
| 1. **<Learning title>:** <Insight drawn from the experience. Include compete perspective where relevant.> |
| |
|    - **Compete perspective:** <How [Competitor 1]/[Competitor 2] handles this, and what it means for our strategy.> |
| |
| 2. **<Learning title>:** <Same format.> |
+---+
| **What will you do to improve? What is the action plan?** |
| |
| | Description | Milestone | |
| |---|---| |
| | **Product** || |
| | <Action item with bold title> | <Timeline> | |
| | <Action item> | <Timeline> | |
| | **GTM** || |
| | <GTM action item> | <Timeline> | |
+---+

<Repeat for Customer Experience #2, #3, etc.>

---

# Telemetry-Driven Insights

<Data narrative about adoption, conversion, churn, or pipeline. Structure by topic.>

**a) <Topic>:** <Data-driven narrative with specific numbers. E.g., "$<X>M in new product revenue from <N> customers." Include funnel analysis, segment breakdowns, and pipeline impact where available.>

**b) <Topic>:** <Same format.>

---

# Requests for Help

| Intent | Request |
|--------|---------|
| <What you need and why> | <Detailed request. End with "**Request from Leadership:** <specific ask>"> |
| <Intent> | <Request> |

---

# Key Results

| # | Key Result | Comments | Baseline / Target |
|---|-----------|----------|-------------------|
| 1 | <KPI name: description> | <How measured, what it tracks, caveats> | B: <current number> / T: <target number> |
| 2 | <KPI name> | <Comments> | B: <baseline> / T: <target> |

---

# Appendix

## Appendix - <Topic: e.g., Workload Coverage Compete>

<Detailed compete scorecards, workload coverage matrices, or other supporting data tables that would break the flow of the main narrative.>

## Appendix - <Topic: e.g., Roadmap>

<Visual roadmap references, Mermaid diagrams, or image references.>

## Appendix - <Topic: e.g., Execution Plan Detail>

<Crawl/Walk/Run matrices or phased execution tables with Source/Target/Capability columns.>

## Appendix - Glossary

| Term | Definition |
|------|-----------|
| <Term> | <Plain-language definition> |
```

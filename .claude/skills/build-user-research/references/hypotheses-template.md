# Hypotheses Template - Customer Validation Hypotheses List

> **Example:** See `reference-examples/one-pagers/HYpothesis list for UR skill.docx` for a real hypothesis list with 14 hypotheses organized by theme (Discovery & Onboarding Barriers, Assessment & Planning Gaps, Migration Execution & Tooling Preferences, Messaging & GTM, Containerization). See `reference-examples/surveys/` for planning call transcripts showing how PM and researcher brainstorm and refine hypotheses together.

Generate the hypotheses list using this structure. Fill every section with substantive content grounded in the PM's source material.

---

```markdown
# <Product/Feature Area> - Customer Validation Hypotheses

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | <today's date> | <author or "PM Team"> | Initial hypotheses list |

**Status:** Draft, pending validation.
**Research context:** <1-2 sentences on why this research is being conducted - what decision it informs.>

---

## 1. Research Context

### 1.1 Background

<2-3 paragraphs describing what prompted this research. What signals, data, or observations suggest there are open questions worth investigating? Reference any telemetry, prior research, or business context the PM provided.>

### 1.2 Research Objective

<1 paragraph: what this research aims to validate or reject, and what decisions the findings will inform.>

### 1.3 Target Personas

| Persona | Description | Why included |
|---------|-------------|-------------|
| <Persona 1> | <Role, context, relevance> | <What hypotheses apply to them> |
| <Persona 2> | <Role, context, relevance> | <What hypotheses apply to them> |

### 1.4 Product Journey Stages

Define the journey stages that hypotheses span. Customize based on the product area.

| Stage | Description | Key decisions at this stage |
|-------|-------------|---------------------------|
| Discover | <How users find and inventory their environment> | <e.g., tool selection, access model, scope> |
| Assess/Plan | <How users evaluate readiness and plan the move> | <e.g., target selection, sizing, wave planning> |
| Execute/Migrate | <How users perform the actual migration> | <e.g., tooling, automation, validation> |
| Post-migration | <How users optimize after landing> | <e.g., cost management, modernization, monitoring> |

> **PM Decision Required:** Confirm or customize these journey stages for your product area. All hypotheses, survey sections, and interview themes will align to these stages.

### 1.5 Competitive Landscape

<Summary of competitor equivalents found during input gathering. Include only competitors the PM approved for inclusion.>

| Capability Area | <Your Product> | <Competitor 1> | <Competitor 2> |
|----------------|---------------|----------------|----------------|
| <Capability at Discover stage> | <status> | <status> | <status> |
| <Capability at Assess/Plan stage> | <status> | <status> | <status> |
| <Capability at Execute stage> | <status> | <status> | <status> |
| <Capability at Post-migration stage> | <status> | <status> | <status> |

<1-2 paragraphs on key differentiators and gaps that inform hypotheses. Reference specific capabilities, not general positioning.>

---

## 2. Hypotheses

### 2.1 Value Hypotheses

These test whether customers find the proposed solution valuable enough to adopt.

| ID | Hypothesis | Priority | Validation Method | Personas | Journey Stage |
|----|-----------|----------|-------------------|----------|---------------|
| H1 | We believe <persona> will <behavior/preference> because <reason/signal>. | High/Medium/Low | Survey / Interview / Both | <Persona names> | Discover / Assess / Execute / Post |
| H2 | We believe <persona> will <behavior/preference> because <reason/signal>. | High/Medium/Low | Survey / Interview / Both | <Persona names> | Discover / Assess / Execute / Post |

### 2.2 Usability Hypotheses

These test whether customers can accomplish their goals with the current or proposed experience.

| ID | Hypothesis | Priority | Validation Method | Personas | Journey Stage |
|----|-----------|----------|-------------------|----------|---------------|
| H3 | We believe <persona> will <behavior/preference> because <reason/signal>. | High/Medium/Low | Survey / Interview / Both | <Persona names> | Discover / Assess / Execute / Post |

### 2.3 Feasibility Hypotheses

These test whether technical, operational, or ecosystem constraints affect adoption.

| ID | Hypothesis | Priority | Validation Method | Personas | Journey Stage |
|----|-----------|----------|-------------------|----------|---------------|
| H4 | We believe <persona> will <behavior/preference> because <reason/signal>. | High/Medium/Low | Survey / Interview / Both | <Persona names> | Discover / Assess / Execute / Post |

### 2.4 Viability Hypotheses

These test whether business model, pricing, or go-to-market factors affect adoption.

| ID | Hypothesis | Priority | Validation Method | Personas | Journey Stage |
|----|-----------|----------|-------------------|----------|---------------|
| H5 | We believe <persona> will <behavior/preference> because <reason/signal>. | High/Medium/Low | Survey / Interview / Both | <Persona names> | Discover / Assess / Execute / Post |

### 2.5 Journey-Stage View

The same hypotheses regrouped by journey stage for a connected flow view.

| Journey Stage | Hypothesis IDs | Key theme at this stage |
|--------------|----------------|------------------------|
| Discover | H1, H3 | <e.g., Discovery tooling and access barriers> |
| Assess/Plan | H2, H4 | <e.g., Readiness gaps and target recommendations> |
| Execute/Migrate | H5 | <e.g., Execution automation and tooling preferences> |
| Post-migration | - | <e.g., Optimization and modernization paths> |

---

## 3. Hypothesis Priority Summary

| Priority | Count | IDs |
|----------|-------|-----|
| High | <n> | H1, H2, ... |
| Medium | <n> | H3, ... |
| Low | <n> | H5, ... |

---

## 4. Validation Plan

| Method | Hypotheses Covered | Target Sample Size | Timeline |
|--------|-------------------|-------------------|----------|
| Unmoderated Survey | <H-IDs> | <n respondents> | <target date> |
| Moderated Interviews | <H-IDs> | <n participants> | <target date> |

---

## 5. Open Questions

<Bullet list of questions that emerged during hypothesis formulation but don't fit the hypothesis format. These may inform future research or need PM input before converting to hypotheses.>

- <Open question 1>
- <Open question 2>
```

---

## Template Rules

- **Minimum 5 hypotheses** across the 4 categories. Not every category needs entries, but Value and at least one other category must have hypotheses.
- **Hypothesis format is strict:** "We believe [persona] will [behavior/preference] because [reason/signal]." Every hypothesis must name a specific persona, a testable behavior, and a grounding reason.
- **Priority reflects business impact:** High = blocks a decision or launch. Medium = informs strategy. Low = nice to know.
- **Validation method must be explicit:** Survey (quantitative, at scale), Interview (qualitative, in depth), or Both.
- **No vague hypotheses.** "We believe customers want better tooling" is not testable. "We believe Linux-heavy migration leads will prefer CLI-based discovery over portal-based workflows because their teams use command-line tools for infrastructure management" is testable.
- **Ground hypotheses in signals.** Every "because" clause should reference real data, telemetry, prior research, customer feedback, or observable market behavior - not speculation.
- Follow the **Humanized Writing Standard** from workspace instructions for all prose sections.

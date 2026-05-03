# Survey Template - Unmoderated Survey Questionnaire

> **Example:** See `reference-examples/surveys/Linux Survey Questions 2026 copy.docx` for a real survey with screening (role, OS composition, migration stage), disqualification markers, branching logic, and hypothesis-mapped questions across the migration journey. See `reference-examples/interview-questions/1st version of Linux survey draft before Deepa.docx` for a raw PM draft before researcher refinement.

Generate the survey using this structure. Adapt sections based on the approved hypotheses. Every question must map back to at least one hypothesis ID.

---

```markdown
# <Product/Feature Area> - Unmoderated Survey Questionnaire

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | <today's date> | <author or "PM Team"> | Initial survey |

**Status:** Draft, pending review.
**Hypotheses source:** <path to approved hypotheses file>
**Target respondents:** <n respondents>
**Estimated completion time:** <n minutes>

---

## 1. Survey Objective

<1-2 paragraphs: what this survey validates, which hypotheses it targets, and what decisions the results will inform. Reference the approved hypotheses document.>

**Insight-driven hypothesis summary:** <1 paragraph restating the core research thesis from the hypotheses document.>

---

## 2. Screening Questions

These questions filter respondents to ensure the right audience. Mark disqualification criteria clearly.

### Q-S1: <Screening question text>

- Option A
- Option B
- Option C [Disqualify]
- Option D

**Type:** Single-select
**Purpose:** <What this screens for - e.g., "Identify candidate role/persona">

### Q-S2: <Screening question text>

- Option A
- Option B
- Option C

**Type:** Single-select / Multi-select
**Purpose:** <Screening purpose>

<Include 3-6 screening questions. Cover: role/persona identification, relevant experience or estate profile, current stage/maturity. Mark disqualification options with [Disqualify].>

---

## 3. Profiling Questions

These capture respondent context for cohort analysis without filtering anyone out.

### Q-P1: <Profiling question text>

- Option A
- Option B
- Option C
- Other (please specify)

**Type:** Single-select / Multi-select
**Maps to:** Respondent segmentation

### Q-P2: <Profiling question text>

| Range | Option |
|-------|--------|
| < 100 | Small |
| 100-1000 | Medium |
| 1000-5000 | Large |
| 5000+ | Enterprise |

**Type:** Single-select
**Maps to:** Respondent segmentation

<Include 3-5 profiling questions. Cover: organization size, technology stack, motivations, current tooling.>

---

## 4. Core Questions - <Journey Stage: e.g., Discover> - <Theme Name>

<1 sentence introducing this section's journey stage and theme, and which hypotheses it validates. Align themed sections to the journey stages defined in the approved hypotheses (e.g., Discover -> Assess/Plan -> Execute -> Post-migration). This creates a connected flow where the survey follows the same progression the customer experiences.>

### Q1: <Question text>

- Option A
- Option B
- Option C
- Option D
- Other (please specify)

**Type:** Single-select / Multi-select / Ranking
**Maps to:** H<n>, H<n>
**Skip logic:** <If applicable - e.g., "If Option A, skip to Q4">

### Q2: <Question text>

| Scale | Label |
|-------|-------|
| 1 | Strongly disagree |
| 2 | Disagree |
| 3 | Neutral |
| 4 | Agree |
| 5 | Strongly agree |

**Type:** Likert scale (1-5)
**Maps to:** H<n>

### Q3: <Question text>

**Type:** Open-ended (text)
**Maps to:** H<n>
**Max length:** <word/character limit if applicable>

<Continue with questions for this theme. Group related questions together.>

---

## 5. Core Questions - <Journey Stage: e.g., Assess/Plan> - <Theme Name>

<Repeat the pattern from Section 4 for the next journey stage. Typical surveys have 2-4 themed sections, one per journey stage. Maintain the connected flow: Discover -> Assess/Plan -> Execute -> Post-migration.>

---

## 6. Core Questions - <Journey Stage: e.g., Execute/Migrate> - <Theme Name>

<Continue as needed. Each section maps to a journey stage and its associated hypotheses.>

---

## 7. Closing Questions

### Q-C1: <Catch-all open-ended question - e.g., "Is there anything else about [topic] that we didn't ask but should have?">

**Type:** Open-ended (text)
**Maps to:** Exploratory

### Q-C2: Would you be willing to participate in a 45-60 minute follow-up interview to discuss your responses in more detail?

- Yes (please provide your email: _________)
- No

**Type:** Single-select with optional text
**Maps to:** Interview recruitment

---

## 8. Hypothesis-to-Question Traceability

| Hypothesis ID | Hypothesis (short form) | Survey Questions |
|---------------|------------------------|-----------------|
| H1 | <abbreviated hypothesis> | Q-S2, Q1, Q3 |
| H2 | <abbreviated hypothesis> | Q2, Q5 |
| H3 | <abbreviated hypothesis> | Q4, Q6, Q7 |

<Every hypothesis from the approved list must appear in this table. If a hypothesis has no survey questions (interview-only), note "Interview only" in the Survey Questions column.>

---

## 9. Survey Design Notes

**Question count:** <total questions, excluding screeners>
**Estimated time:** <minutes>
**Distribution plan:** <how/where the survey will be sent>
**Analysis plan:** <what cohort splits will be applied - e.g., by OS composition, by role, by migration stage>
```

---

## Template Rules

- **Every core question must map to at least one hypothesis ID.** No orphan questions.
- **Every hypothesis from the approved list must appear in the traceability table.** If a hypothesis is interview-only, mark it explicitly.
- **Screening questions come first** and must include `[Disqualify]` markers on options that filter out respondents who don't match the target audience.
- **Question types must be explicit:** Single-select, Multi-select, Likert scale (specify range), Ranking, Open-ended (text). Include scale labels for Likert questions.
- **Skip logic must be documented** where one answer changes the subsequent question flow. Format: "If [option], skip to Q[n]" or "If [option], show Q[n]".
- **Limit multi-select questions** to "Pick top N" or "Select all that apply" - specify which.
- **Profiling questions** capture context for analysis (role, org size, tooling) but do not filter respondents.
- **Include at least one open-ended question per themed section** to capture unanticipated insights.
- **Close with an interview recruitment question** to build the pipeline for the moderated interview phase.
- **Target 15-25 core questions** (excluding screeners and profiling). More than 25 risks drop-off.
- Follow the **Humanized Writing Standard** from workspace instructions for all prose sections.

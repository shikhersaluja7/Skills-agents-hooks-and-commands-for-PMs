# Interview Guide Template - Moderated User Interview Script

> **Example:** See `reference-examples/interview-questions/Linux Moderated Interview Questions_2026.docx` for a real interview guide with timed sections (Introduction, Warm-up, Discovery, Plan & Assess, Execute, Wrap-up), moderator aids, laddering techniques, and listen-fors. See `reference-examples/interviews/` for actual conversation transcripts showing probing dynamics and participant responses.

Generate the interview guide using this structure. Ground all questions in the approved hypotheses and approved survey. The interview digs deeper where the survey provides breadth.

---

```markdown
# <Product/Feature Area> - Moderated Interview Guide

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | <today's date> | <author or "PM Team"> | Initial interview guide |

**Status:** Draft, pending review.
**Hypotheses source:** <path to approved hypotheses file>
**Survey source:** <path to approved survey file>
**Target participants:** <n participants>
**Session duration:** 45-60 minutes

---

## 1. Research Objectives

<2-3 bullet points: what this interview aims to uncover that the survey cannot. Focus on the "why" behind survey responses, edge cases, workflow details, and emotional/motivational factors.>

- <Objective 1>
- <Objective 2>
- <Objective 3>

### Participant Profile

| Attribute | Criteria |
|-----------|----------|
| **Role** | <target roles> |
| **Experience** | <relevant experience required> |
| **Recruitment source** | <e.g., survey respondents who opted in, customer advisory board, partner network> |
| **Screening criteria** | <what qualifies/disqualifies a participant> |

---

## 2. Session Structure

| Section | Duration | Purpose |
|---------|----------|---------|
| Introduction & Consent | 2-3 min | Set context, get recording permission |
| Warm-up & Role Context | 5 min | Build rapport, understand participant background |
| <Core Theme 1> | 12-15 min | <Which hypotheses this covers> |
| <Core Theme 2> | 12-15 min | <Which hypotheses this covers> |
| <Core Theme 3> | 10-12 min | <Which hypotheses this covers> |
| Wrap-up | 3-5 min | Open floor, capture what we missed |
| **Total** | **45-55 min** | |

---

## 3. Introduction & Consent (2-3 min)

> **Script:** Thanks for joining. We're exploring how <context of research>. We'll cover <high-level topics>. With your permission, we'll record for internal research only; responses will be anonymized. You may blur or hide anything sensitive if sharing your screen. Is it okay to proceed with recording?

---

## 4. Warm-up & Role Context (5 min)

**Goal:** Build rapport and understand the participant's background before diving into research questions.

**Q-W1:** <Warm-up question about their role and how it intersects with the research topic.>

**Q-W2:** <Question about their current environment/estate/setup relevant to the research.>

> **Transition:** "Great context. Let's walk through [topic area 1]..."

---

## 5. <Core Theme 1 - Journey Stage: Discover - e.g., "Discovery & Current Practices"> (12-15 min)

**Goal:** <What this section aims to uncover. Reference hypothesis IDs.>
**Maps to:** H<n>, H<n>
**Journey Stage:** Discover

### Q1: <Primary question>

**Probing follow-ups:**
- <Follow-up if they mention X>
- <Follow-up if they mention Y>
- <Follow-up to quantify: "How often?" / "How many?">

### Q2: <Primary question>

**Probing follow-ups:**
- <Follow-up for specifics: "Can you walk me through the last time you...?">
- <Follow-up for comparison: "How does that differ from...?">

### Q3: <Primary question>

**Probing follow-ups:**
- <Follow-up for emotion/motivation: "What was frustrating about that?">
- <Follow-up for alternatives: "What did you try instead?">

> **Transition:** "That's really helpful. Now let's talk about [topic area 2]..."

---

## 6. <Core Theme 2 - Journey Stage: Assess/Plan - e.g., "Planning & Decision Making"> (12-15 min)

**Goal:** <What this section uncovers. Reference hypothesis IDs.>
**Maps to:** H<n>, H<n>
**Journey Stage:** Assess/Plan

### Q4: <Primary question>

**Probing follow-ups:**
- <Follow-up>
- <Follow-up>

### Q5: <Primary question>

**Probing follow-ups:**
- <Follow-up>
- <Follow-up>

### Q6: <Primary question>

**Probing follow-ups:**
- <Follow-up>
- <Follow-up>

> **Transition:** "Let's shift to [topic area 3]..."

---

## 7. <Core Theme 3 - Journey Stage: Execute - e.g., "Execution & Tooling"> (10-12 min)

**Goal:** <What this section uncovers. Reference hypothesis IDs.>
**Maps to:** H<n>, H<n>
**Journey Stage:** Execute/Migrate

### Q7: <Primary question>

**Probing follow-ups:**
- <Follow-up>
- <Follow-up>

### Q8: <Primary question>

**Probing follow-ups:**
- <Follow-up>
- <Follow-up>

> **Transition:** "We're almost done. A couple of closing questions..."

---

## 8. Wrap-up (3-5 min)

**Q-WU1:** Are there any non-negotiables for <topic area> that we haven't discussed? <e.g., security controls, compliance, naming conventions>

**Q-WU2:** If you could ask the <product/engineering> team to fix one thing about <topic>, what would it be?

**Q-WU3:** Is there anything we didn't ask that we should have?

> **Script:** "Thank you for your time. Your input directly shapes what we build. We'll share findings with the team and may follow up if we have clarifying questions. Is that okay?"

---

## 9. Hypothesis-to-Question Traceability

| Hypothesis ID | Hypothesis (short form) | Survey Finding | Interview Questions | Survey Questions (cross-ref) |
|---------------|------------------------|---------------|--------------------|-----------------------------|
| H1 | <abbreviated hypothesis> | Confirmed (82%) | Q1, Q2 | Q-S2, Q1, Q3 |
| H2 | <abbreviated hypothesis> | Partial (58/42) | Q4, Q5 | Q2, Q5 |
| H3 | <abbreviated hypothesis> | Rejected | Q7, Q8 | Q4, Q6 |
| H14 | <newly emerged from survey> | New | Q9 | - |

<Every hypothesis must appear. The Survey Finding column shows the quantitative backdrop so the moderator calibrates interview depth: spend less time on confirmed hypotheses, more on partial/rejected/new. If no survey was conducted, mark all as "No survey data" and treat all hypotheses equally in the interview.>

---

## 10. Moderator Aids

### Transitions

Use these to move between sections naturally:
- "Let's rewind to..."
- "If I shadowed your team on migration day..."
- "What made that choice obvious?"
- "If you had a magic button..."
- "You mentioned [X] earlier - can you expand on that?"

### Laddering Techniques

When a response is surface-level, probe deeper using:
- **Impact:** "What breaks if that doesn't work?"
- **Evidence:** "What data did you use to make that call?"
- **Alternatives:** "What else did you consider?"
- **Constraints:** "What prevented you from doing it differently?"
- **Repeatability:** "Is that how it works every time, or was this a special case?"

### Listen-fors

Tag these themes during note-taking if they emerge (even if not directly asked):
- <Listen-for 1 - e.g., "sudo/SSH comfort level">
- <Listen-for 2 - e.g., "tool sprawl signals">
- <Listen-for 3 - e.g., "IaC expectations beyond rehost">
- <Listen-for 4 - e.g., "governance or compliance gates">

<Customize listen-fors based on the hypothesis themes. These help the notetaker tag responses in real time.>

---

## 11. Logistics & Roles

| Role | Responsibility |
|------|---------------|
| **Moderator** | Drives the conversation, manages time, asks questions |
| **Notetaker** | Captures responses, tags listen-fors in real time |
| **Observer** | Listens only, no interruptions. Shares observations post-session |

### Timekeeper Landmarks

| Time | Milestone |
|------|-----------|
| 5 min | Warm-up complete, transition to Core Theme 1 |
| 20 min | Core Theme 1 complete, transition to Core Theme 2 |
| 35 min | Core Theme 2 complete, transition to Core Theme 3 |
| 47 min | Core Theme 3 complete, transition to Wrap-up |
| 55 min | Session ends |
```

---

## Template Rules

- **Every core question must map to at least one hypothesis ID.** No exploratory fishing without grounding.
- **Every hypothesis must appear in the traceability table** showing combined survey + interview coverage.
- **Probing follow-ups are mandatory** for every primary question. Include 2-3 follow-ups per question covering: specifics ("walk me through the last time..."), quantification ("how often/many?"), emotion ("what was frustrating?"), and alternatives ("what else did you try?").
- **Timed sections are mandatory.** The moderator needs to know when to transition. Include transition prompts between every section.
- **Include a scripted introduction** with consent language for recording.
- **Include moderator aids:** transitions, laddering techniques, and listen-fors. These are grounded in the hypothesis themes, not generic.
- **Include logistics:** role assignments (moderator, notetaker, observer) and timekeeper landmarks.
- **Warm-up questions build rapport** before diving into research. Ask about role and current environment, not the research topic directly.
- **Wrap-up must include** the "magic wand" question ("if you could fix one thing...") and the "what did we miss?" question.
- **Target 8-12 primary questions** across all core themes. More than 12 risks rushing through the session.
- **Interview questions complement the survey**, not duplicate it. Where the survey asks "what?", the interview asks "why?" and "how?".
- Follow the **Humanized Writing Standard** from workspace instructions for all prose sections.

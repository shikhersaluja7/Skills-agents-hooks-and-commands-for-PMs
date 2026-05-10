---
name: build-golden-dataset
description: "Generate a golden evaluation dataset from product inputs and user personas. Use when: golden dataset, ground truth dataset, evaluation data, test data generation, benchmark data, accuracy testing, model evaluation, QA golden set, reference dataset, validation dataset, persona-based testing, API evaluation, response grading."
argument-hint: "Product or feature to generate golden dataset for"
---

# Build Golden Dataset

Generate a golden evaluation dataset for any product, feature, or AI system. The PM provides source data (API responses, CSV/Excel files, info exports) and user personas. The skill generates the questions those personas would ask, derives the exact expected responses from the source data, and produces an evaluation-ready dataset the PM can iterate on.

This skill follows the column structure modeled after `a golden dataset file with question and expected-response columns` - with "questions" and "expected response" as core columns, plus an evaluation formula showing how each answer was derived from the source data.

## When to Use

- You need to evaluate an AI assistant's accuracy against a known dataset
- You want to benchmark an API, chatbot, or copilot experience against ground truth
- You need test cases derived from real product data, not invented scenarios
- You want persona-specific questions that reflect how actual users interact with the system

## Procedure

### Step 1: Gather Inputs

Collect the source material that defines the product's behavior and data. This is the ground truth from which all expected responses will be derived.

If an `input/golden-datasets/<project-name>/` folder exists, auto-scan it. Otherwise, ask the PM to provide or paste source material.

**Accepted input types:**
- **API responses / API contracts** - OpenAPI/Swagger specs, sample JSON payloads, Postman collections, REST response bodies
- **CSV / Excel files** - Data exports, inventory lists, telemetry data, user data, assessment results
- **Info exports** - Product documentation, help articles, feature descriptions, knowledge base articles
- **Conversation logs** - Chat transcripts showing real user interactions and system responses
- **Existing test cases** - Acceptance criteria, QA test plans, regression suites
- **URLs** - Links to live endpoints, documentation pages, or dashboards

For non-markdown files, follow the **File Format Policy** in `CLAUDE.md`. The policy handles MCP-direct ingestion when an Office MCP is registered, auto-conversion via `scripts/translate-inputs.py input/golden-datasets/<project-name>/` as the fallback, and the FYI nudge that points unaware users at the optional MCPs.

Read and parse every input file. Build a mental model of the data: what columns exist, what values are present, what calculations are possible, what relationships exist between data points.

### Step 2: Ask Clarifying Questions

Use the ask-questions tool to batch these in one response:

1. **Product/system**: What product, feature, or AI system is this golden dataset for?
2. **Personas**: Who will interact with this system? Provide role, context, and proficiency level for each persona. (e.g., "Enterprise IT Admin migrating 500 VMs", "CTO reviewing migration cost report", "Developer evaluating assessment results")
3. **Evaluation type**: What are you measuring? (accuracy, completeness, response quality, factual correctness, task completion, formula/calculation correctness)
4. **System output format**: What format does the system being tested produce? (free text responses, structured JSON, tables, charts, calculations, markdown)
5. **Test case count**: How many test cases per persona? (minimum viable: 10, standard: 25, comprehensive: 50+)
6. **Grading approach**: How will responses be graded? (binary pass/fail, rubric 1-5, weighted scoring, LLM-as-judge, human review)
7. **Known failure modes**: Are there specific edge cases, failure modes, or error types to prioritize?
8. **Multi-turn scenarios**: Should the dataset include multi-turn conversation sequences?

### Step 3: Define Personas

For each persona the PM specified, generate a persona card:

```
### Persona: <Name>
- **Role:** <Job title and organizational context>
- **Technical proficiency:** <Novice / Intermediate / Expert>
- **Goals:** <What they're trying to accomplish with this system>
- **Question patterns:** <How they typically phrase requests - technical jargon vs plain language>
- **Information priorities:** <What they care about most: cost, performance, compliance, timeline, risk, security>
- **Typical session:** <How long they interact, how many questions per session, what triggers them to use the system>
```

Show all persona cards to the PM for approval before proceeding.

> **PM Decision Required:** Review and approve the persona definitions. Add, remove, or modify personas before question generation begins.

### Step 4: Generate Questions Per Persona

Analyze the source inputs (API contracts, CSVs, exports, docs) and generate the questions each persona would realistically ask. Every question must be answerable from the provided source data.

**Question categories:**

| Category | Description | Example |
|----------|-------------|---------|
| **Data retrieval** | Direct lookups from the source data | "How many records belong to product line A?" |
| **Calculation** | Computed values requiring formulas | "What is the estimated monthly cost for migrating these 5 workloads?" |
| **Comparison** | Cross-referencing multiple data points | "How does the target platform cost compare to our current on-prem TCO?" |
| **Filtering/aggregation** | Subsets and summaries of the data | "Show me all servers with more than 16GB RAM not in the migration plan" |
| **Interpretation** | Explaining what the data means | "What does the readiness assessment say about our SQL cluster?" |
| **Action/recommendation** | Suggesting next steps based on data | "What should I prioritize in wave 1?" |
| **Edge case** | Missing data, conflicting info, out-of-scope | "What happens if I migrate a server that has no performance data?" |

**Rules for question generation:**
- Questions must be phrased in the persona's voice (novice uses plain language, expert uses technical terms)
- Every question must be answerable from the provided inputs - no questions requiring external knowledge
- Include a mix of simple (single-field lookup) and complex (multi-step calculation) questions
- Each persona should have questions across at least 4 of the 7 categories
- Edge case questions should test system boundaries: empty results, null values, conflicting data, ambiguous queries

### Step 5: Generate Expected Responses and Eval Column

For each question, derive the exact expected response from the source data. The eval column contains the **ground truth answer** - the actual value computed from the input dataset. This is not a rubric or checklist. It is the concrete answer the system must produce.

**For each question, produce:**

| Field | What to include |
|-------|-----------------|
| **Expected Response** | The exact, correct answer derived from the source data. Include specific numbers, values, lists, or text. This is what the system should output. |
| **Eval (Exact Value)** | The ground truth extracted or computed from the input. For counts: the number. For sums: the total. For lists: the exact items. For text: the verbatim passage or synthesized fact. |
| **Eval Formula** | How the exact value was derived. The computation or extraction path. Examples: `COUNT rows WHERE category='A' in inventory.csv`, `SUM(column E, rows 2-48)`, `$.results.totalMonthlyCost from assessment-api-response.json`, `FILTER WHERE RAM > 16 AND migration_wave IS NULL` |
| **Source Reference** | Which input file, row, column, field, or API path the answer comes from |

**Derivation rules by question category:**
- **Data retrieval**: Extract the exact value from the source (count, lookup, field value)
- **Calculation**: Show the formula AND the computed result (e.g., `SUM(monthlyCost) for rows WHERE app='Acme ERP (example)' = $12,450/mo`)
- **Comparison**: Show both values being compared and the delta
- **Filtering**: List the exact matching rows/items with their key attributes
- **Interpretation**: Extract the relevant data points and the conclusion they support
- **Action/recommendation**: Cite the data points that drive the recommendation
- **Edge case**: State the expected system behavior (error message, empty result, clarification request)

### Step 6: Coverage Analysis

Present a coverage matrix to the PM:

**Personas x Categories:**
| Persona | Data Retrieval | Calculation | Comparison | Filtering | Interpretation | Action | Edge Case | Total |
|---------|---------------|-------------|------------|-----------|---------------|--------|-----------|-------|
| Persona 1 | N | N | N | N | N | N | N | N |
| Persona 2 | N | N | N | N | N | N | N | N |

**Difficulty Distribution:**
| Persona | Easy | Medium | Hard | Total |
|---------|------|--------|------|-------|
| Persona 1 | N | N | N | N |
| Persona 2 | N | N | N | N |

Flag gaps:
- Missing categories for any persona
- Uneven difficulty distribution (too many easy, not enough hard)
- Categories with zero edge cases
- Personas with no multi-turn scenarios (if multi-turn was requested)

### Step 7: Draft Review

Present the complete dataset in chat, organized by persona.

## DRAFT - Awaiting PM Approval

For each persona, show the full table:

| ID | Persona | Category | Question | Expected Response | Eval (Exact Value) | Eval Formula | Source Reference | Difficulty | Multi-turn | Pass Criteria | Fail Criteria |
|----|---------|----------|----------|-------------------|--------------------|--------------|-----------------|------------|------------|---------------|---------------|
| P1-DR-001 | ... | Data retrieval | ... | ... | ... | ... | ... | Easy | No | ... | ... |

**ID format:** `P<persona#>-<category code>-<sequence>` where category codes are: DR (data retrieval), CA (calculation), CO (comparison), FI (filtering), IN (interpretation), AC (action), EC (edge case).

### Step 8: PM Iteration

The PM reviews and requests changes. Common iterations:

- "Add more edge cases for the IT Admin persona"
- "The expected answer for Q12 should account for the discount rate"
- "Remove the CTO persona and add a Security Analyst"
- "These calculation questions are too simple - add some multi-step ones"
- "Add multi-turn sequences where the user refines their question"

Regenerate only the affected sections. Re-present the updated dataset for another review round. Repeat until the PM approves.

### Step 9: Save

After PM approval, save the dataset:

**Primary output:** `output/golden-datasets/<product-name>-golden-dataset.md`

**Additional export options (offer to the PM):**
- **JSONL** - For programmatic evaluation pipelines. One JSON object per test case.
- **CSV** - For spreadsheet analysis and sharing with QA teams.
- **Per-persona split** - Separate files per persona for distributed review.

Run the humanizer check:
```
scripts/humanizer-check.ps1 -Files "output/golden-datasets/<product-name>-golden-dataset.md"
```

Report to the PM:
- File location and size
- Total test cases generated
- Breakdown by persona and category
- Coverage matrix summary
- Humanizer check result

## Output Schema

Each test case in the dataset has these fields:

| Field | Description |
|-------|-------------|
| **ID** | Unique identifier: `P<persona#>-<category>-<seq>` (e.g., P1-DR-001) |
| **Persona** | Which persona asks this question |
| **Category** | Data retrieval / Calculation / Comparison / Filtering / Interpretation / Action / Edge case |
| **Question** | The natural-language question the persona would ask |
| **Expected Response** | The full, correct response the system should produce |
| **Eval (Exact Value)** | The ground truth value extracted or computed from the source data |
| **Eval Formula** | How the exact value was derived (extraction path, calculation, filter expression) |
| **Source Reference** | Input file + row/column/field/API path the answer derives from |
| **Difficulty** | Easy / Medium / Hard |
| **Multi-turn** | Yes/No - is this part of a conversation sequence? |
| **Prior Context** | If multi-turn, summary of what was said in previous turns |
| **Pass Criteria** | What constitutes a passing response (exact match, within tolerance, must contain) |
| **Fail Criteria** | What causes failure (wrong number, hallucination, missing data, fabricated fact) |



### Optional: Deep Research

Before drafting, you can invoke the `@ideation-ghcp` agent for deeper market context, competitive intelligence, or trend analysis. It searches across Substack, Reddit, YouTube, competitor blogs, and analyst reports to surface insights relevant to this artifact. Ask the PM: `Want me to run deep research before drafting? I can explore the competitive landscape, market trends, or user pain points related to this topic.` Only invoke if the PM says yes.

## Checklist

Before presenting the draft, verify:

- [ ] Every question is answerable from the provided source data (no external knowledge required)
- [ ] Every eval value is the exact ground truth derived from the inputs
- [ ] Every eval formula shows the derivation path (file, row, column, calculation)
- [ ] Each persona has questions across at least 4 of 7 categories
- [ ] Difficulty distribution is intentional, not accidental
- [ ] Edge cases test real system boundaries (empty results, null values, conflicting data)
- [ ] Multi-turn sequences (if requested) have clear prior context
- [ ] Pass/fail criteria are unambiguous and verifiable
- [ ] No questions use data that doesn't exist in the provided inputs
- [ ] Question phrasing matches each persona's voice and proficiency level

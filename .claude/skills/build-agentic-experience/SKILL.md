---
name: build-agentic-experience
description: "Build agentic workflow artifacts for conversational AI: scenario catalogs, journey scripts, or evaluation datasets. Use when: agentic workflow, scenario catalog, journey script, happy path journey, eval dataset, evaluation dataset, copilot conversation flows, chat experience spec, prompt-response catalog, AI assistant prompts, test accuracy of agent responses, LLM evaluation."
argument-hint: "Feature or domain description. For journeys: journey type (lift-and-shift or modernization). For eval: step name and milestone."
---

# Build Agentic Experience

You are an agentic experience specialist helping PMs define conversational AI interactions for your product's AI assistant. You create three types of artifacts that work together: scenario catalogs define exhaustive interactions, journey scripts create linear happy paths, and eval datasets test agent accuracy.

Follow the **PM-in-the-Loop Contract** and **Humanized Writing Standard** from workspace instructions.

## Mode Selection

This skill operates in three modes. Ask the PM which mode they need, or infer from context:

| Mode | When to Use | What it Produces |
|------|-------------|-----------------|
| **Scenario Catalog** | Defining exhaustive prompt-response pairs for a feature | Full catalog with edge cases, refinement flows, and multi-section coverage |
| **Journey Script** | Creating a linear happy path walkthrough for demo or testing | Persona-driven script with User/AI/Prompts table format |
| **Eval Dataset** | Generating test cases to measure agent response accuracy | Structured dataset with 12-column schema, task taxonomy, and variant coverage |

If the PM says "scenario catalog", "agentic workflow", "conversation flows" -> **Scenario Catalog mode**
If the PM says "journey", "happy path", "walkthrough", "demo script for your AI assistant" -> **Journey Script mode**
If the PM says "eval dataset", "test cases", "accuracy testing", "grounding test" -> **Eval Dataset mode**

## Shared Conventions (All Modes)

### Three-Part Response Structure

Every AI assistant response across all modes follows this structure:
1. **Explanation/Response** to the user query
2. **Recommended Next Step** with clear rationale
3. **Three Suggested Prompts:** (1) advances forward, (2) explains deeper concept, (3) skips to end goal

### Placeholder Conventions

| Placeholder | Meaning |
|-------------|---------|
| `<N>` | Count (servers, databases, apps) |
| `<App1>`, `<App2>` | Application names |
| `<Region>` | your cloud platform region |
| `<X>` minutes | Estimated time |
| `$<X>`/mo | Monthly cost |
| `<P>%` | Percentage |

### Writing Rules (All Modes)
- No em dashes. Use commas, semicolons, or restructure.
- Natural user language in prompts - not robotic or formal.
- Responses must reference user's current state via placeholders.
- Progressive disclosure - don't dump all information at once.

### Optional: Deep Research

Before drafting, you can invoke the `@ideation-claude` agent for deeper market context, competitive intelligence, or trend analysis. Ask the PM: `Want me to run deep research before drafting?` Only invoke if the PM says yes.

---

# Mode A: Scenario Catalog
## Writing Principles

These rules apply to every scenario catalog produced by this skill. Violations of these rules are defects.

### Prompt Design Principles

- **Natural language only.** Prompts must sound like real users typing in a chat box. No formal or robotic phrasing.
- **Multiple entry points.** For key actions, provide 2-3 variant phrasings users might type (e.g., "Assess my workloads" / "Run an assessment" / "What are my migration options?").
- **Contextual intelligence.** Responses must reference the user's current state (scope, parameters, inventory counts, prior decisions) using dynamic placeholders.
- **Progressive disclosure.** Do not dump all information at once. Lead users through a journey with each response revealing the right amount of detail for that step.
- **Opinionated but transparent.** The assistant recommends a path but always explains why and provides alternatives.

- Use **pipe tables** for prompt-response pairs within each sub-section.
- Table columns are always: `Prompt | Response | Suggested Prompts`
- Use `<br>` for line breaks within table cells.
- Use **bold** for key terms, metric names, status labels, and section headers within responses.
- Use backtick-wrapped placeholders for dynamic data: `` `<N>` ``, `` `<App1>` ``, `` `$<X>` ``, `` `<P>%` ``
- Use numbered sections and sub-sections (1, 1.1, 1.2, 2, 2.1, etc.).
- Separate table rows with the standard markdown pipe syntax.

### Placeholder Convention

All dynamic values in responses must use angle-bracket placeholders. Standard placeholders:

| Placeholder | Represents |
|---|---|
| `<N>`, `<M>`, `<L>`, `<K>` | Counts (servers, databases, web apps, applications) |
| `$<X>`, `$<A>`, `$<B>` | Cost values |
| `<P>%`, `<P1>%`, `<P2>%` | Percentages |
| `<App1>`, `<App2>` | Application names |
| `<server1>`, `<server2>` | Server names |
| `<Region>` | your cloud platform region |
| `<SKU>` | your cloud platform SKU or VM size |
| `<name>` | Assessment or resource name |
| `<description>` | Dynamic description text |

### Exhaustiveness Requirement

The catalog must be **exhaustive**. For each sub-section:
- Cover the happy path (user follows the recommended flow)
- Cover alternative paths (user skips ahead, goes back, or chooses a different option)
- Cover clarification prompts (user asks "what does X mean?")
- Cover disagreement prompts (user pushes back on a recommendation)

### No Vague Language in Responses

Never use "should", "might", "possibly", "as appropriate" in assistant responses. Be definitive. Use concrete numbers (via placeholders), specific recommendations, and clear rationale.

### Assumption and Decision Markers

Where information is missing from source material, make assumptions and mark them:

```
> **Assumption:** <what you assumed and why>
```

For items requiring PM judgment:

```
> **PM Decision Required:** <what needs deciding and why>
```

---

## Procedure

Follow these steps when the user asks to create an agentic workflow scenario catalog.

### Step 1: Gather Inputs

Determine what source material is available. The best input is a product spec for the feature. If the PM provides a path or pastes content, read it.

If no source material is provided, ask:

> **What source material do you have?** Pick all that apply:
>
> 1. Product specification document (provide path or paste content)
> 2. Feature one-pager or design document
> 3. Existing agentic workflow catalog to extend
> 4. API documentation or data model
> 5. User research or interview transcripts
> 6. Competitor copilot/chat experience to reference
> 7. URLs to fetch (docs pages, competitor experiences)
> 8. Freeform description of the feature and its agentic surface

Read any provided documents. Extract: feature capabilities, user actions, data entities, parameters, workflows, decision points, error states.

### Step 2: Identify the Workflow Domain

From the source material, identify:

1. **Primary user actions** the agentic surface supports (create, explore, customize, compare, export, etc.)
2. **Key entities** the user interacts with (assessments, workloads, applications, reports, etc.)
3. **Parameters and settings** the user can control
4. **Decision points** where the user chooses between options
5. **Data outputs** the user expects (summaries, breakdowns, comparisons, exports)
6. **Error and edge case states** (missing data, conflicting inputs, empty results)

Present a proposed **section outline** to the PM for approval before writing. The outline maps to the workflow phases (see Document Structure below).

### Step 3: Check for Reference Catalogs

If the workspace contains existing agentic workflow catalogs, read them to understand:
- The product domain context
- The response style and tone
- The level of detail in responses
- How placeholders are used

Match the style and depth of existing catalogs in the workspace.

### Step 4: Ask Clarifying Questions

After reviewing inputs, ask clarifying questions in a single batch. Skip questions the source material already answers.

1. **Scope** - What is the complete set of user actions this agentic workflow covers? Any actions explicitly out of scope?
2. **User personas** - Who are the primary users of this chat experience? (IT admin, PM, architect, developer, partner)
3. **Entry points** - How does the user arrive at this workflow? (direct prompt, suggested action, portal context, continuation of prior conversation)
4. **Data context** - What data does the assistant have access to? (discovered inventory, assessment results, business case, project settings)
5. **Integration** - Does this workflow reference or hand off to other workflows? (e.g., assessment creation flows into results exploration)
6. **Tone** - Is the assistant concise and data-driven, or more explanatory and educational? (Default: concise and data-driven with option to explain deeper via Prompt 2)
7. **Constraints** - Any restrictions on what the assistant can or cannot do? (e.g., cannot execute actions, only recommends)

### Step 5: Generate the Draft

Write each section following the Document Structure below. Fill every sub-section with substantive prompt-response pairs.

**For each sub-section:**
1. Identify all possible user prompts for this topic (aim for 2-5 prompt rows per sub-section)
2. Write the response following the three-part structure
3. Ensure the three suggested prompts connect to other parts of the catalog (creating a navigable web of interactions)
4. Include variant phrasings for common entry-point prompts

**Self-review before delivering:**
- [ ] Every response has all three parts (Explanation, Recommended Next Step, Three Suggested Prompts)
- [ ] Prompt 1 always advances, Prompt 2 always explains deeper, Prompt 3 always skips ahead
- [ ] No em dashes anywhere
- [ ] All dynamic values use `<placeholder>` syntax
- [ ] Edge cases section covers insufficient data, conflicting inputs, and empty results
- [ ] Back-and-forth section covers disagreements, scope changes, and multi-turn clarification
- [ ] Suggested prompts cross-reference other sections (not just the current sub-section)
- [ ] No orphan prompts (every suggested prompt is answerable somewhere in the catalog)
- [ ] Table format is consistent: `Prompt | Response | Suggested Prompts` columns

Present the complete draft in chat with this header:

```
## DRAFT - Awaiting PM Approval
```

### Step 6: Save After Approval

Only after the PM approves (says "approve", "save", "looks good", "lgtm", or similar), save to:

```
[Feature Name] Agentic Workflow - Scenario Catalog.md
```

in the specifications folder. After saving, report:
1. Where the file was saved
2. A summary: section count, sub-section count, total prompt-response pair count, total unique suggested prompts count
3. Any remaining `> **PM Decision Required:**` items that still need resolution

---

## Document Structure

Every agentic workflow scenario catalog must include the following elements. The specific sections vary by feature domain, but the structure and format are fixed.

### 1. Header

```markdown
# [Feature Name] Agentic Workflow - Exhaustive Scenario Catalog

**Document Status:** Draft v0.1
**PM Author:** [Name]
**PM Reviewer:** TBD
**Engineering Reviewer:** TBD
**UX Reviewer:** TBD
**Date Created:** [Month Year]
**Date Last Updated:** [Month Year]
**Document Status:** Draft v0.1
```

### 2. Purpose Statement

A brief paragraph stating:
- What this document defines (prompts, responses, follow-ups)
- Who it is for (Engineering consumption)
- What it covers (the specific agentic workflow surface)

### 3. Response Structure Declaration

State the three-part response structure explicitly so engineering knows the pattern:

```markdown
**Response Structure:** Every AI response in this document follows a three-part structure:
1. **Explanation/Response** to the user query
2. **Recommended Next Step** with clear rationale
3. **Three Suggested Prompts:**
   - Prompt 1: Advances the user forward in the journey, aligned with the recommended next step
   - Prompt 2: Explains a deeper concept related to the current topic
   - Prompt 3: Skips the recommended step and goes directly to the user's likely end goal
```

### 4. Table of Contents

Numbered, with sub-sections listed. Must match actual sections.

### 5. Workflow Sections

The core of the catalog. Organize into logical phases of the user journey. Each phase becomes a numbered top-level section. Each topic within a phase becomes a sub-section.

**Typical phase structure (adapt to the feature domain):**

| Phase | Covers | Example Sub-sections |
|---|---|---|
| **Creation/Setup** | Initiating the workflow, configuring parameters | Entry points, scope selection, parameter customization, confirmation |
| **Results Overview** | Presenting top-level results after creation | Summary, key insights, high-level comparison |
| **Deep-Dive Analysis** | Drilling into specific aspects of results | Category breakdowns, individual item exploration, comparative analysis |
| **Recommendations** | Providing guidance based on results | Strategy recommendations, target-specific guidance, optimization suggestions |
| **Cost/Impact Analysis** | Financial or impact-oriented exploration | Cost breakdowns, savings scenarios, what-if analysis |
| **Scoped/Filtered Views** | Viewing results for specific subsets | Per-application views, tag-filtered views, cross-entity comparison |
| **Modification** | Changing scope, parameters, or inputs after creation | Scope changes, parameter updates, re-run triggers |
| **Export and Reporting** | Getting data out of the system | Export formats, report generation, presentation support |
| **Edge Cases** | Handling errors and unexpected states | Insufficient data, conflicting inputs, empty results |
| **Back-and-Forth Refinement** | Iterative conversation patterns | Disagreements, scope refinement, multi-turn clarification, undo |

Not all phases apply to every feature. Include only the phases relevant to the workflow being documented. But **Edge Cases** and **Back-and-Forth Refinement** are always required.

### 6. Sub-Section Format

Every sub-section follows this pattern:

```markdown
### X.Y Sub-Section Title

| Prompt | Response | Suggested Prompts |
|---|---|---|
| [Natural language user prompt] | [Three-part response with explanation, recommended next step, and context] | 1. "[Advance prompt]"<br>2. "[Explain deeper prompt]"<br>3. "[Skip ahead prompt]" |
```

**Rules for the table:**
- Each row is one complete interaction (prompt + response + suggestions)
- Multiple rows per sub-section when there are variant phrasings or distinct prompts for the same topic
- Responses use `<br>` for line breaks within cells
- Suggested prompts are numbered 1, 2, 3 and wrapped in quotes
- Bold headings within response cells for structure (e.g., **Scope:**, **Settings applied:**, **Recommended Next Step:**)

### 7. Cross-References

Suggested prompts must form a connected graph. Every suggested prompt in the catalog has a corresponding prompt-response row somewhere in the document. If a suggested prompt leads to a section not yet written, add it or mark it:

```
> **PM Decision Required:** Suggested prompt "[prompt text]" references a workflow not covered in this catalog. Add it or remove?
```

---



### Optional: Deep Research

Before drafting, you can invoke the `@ideation-claude` agent for deeper market context, competitive intelligence, or trend analysis. It searches across Substack, Reddit, YouTube, competitor blogs, and analyst reports to surface insights relevant to this artifact. Ask the PM: `Want me to run deep research before drafting? I can explore the competitive landscape, market trends, or user pain points related to this topic.` Only invoke if the PM says yes.

## Checklist

Before delivering, verify every item:

- [ ] Header metadata present (Author, Reviewers, Status, Dates)
- [ ] Purpose statement present
- [ ] Response structure declaration present
- [ ] Table of Contents present and matches actual sections
- [ ] Every response has three parts: Explanation, Recommended Next Step, Three Suggested Prompts
- [ ] Prompt 1 advances, Prompt 2 explains deeper, Prompt 3 skips ahead (in every row)
- [ ] No em dash characters anywhere
- [ ] All dynamic values use `<placeholder>` syntax consistently
- [ ] Edge Cases section present with at least: insufficient data, conflicting inputs, empty results
- [ ] Back-and-Forth Refinement section present with at least: disagreement, scope change, multi-turn clarification
- [ ] Multiple entry-point phrasings for the primary workflow action
- [ ] Every suggested prompt maps to an answerable prompt-response row in the catalog
- [ ] No vague language ("should", "might", "possibly") in assistant responses
- [ ] All assumptions marked with `> **Assumption:**`
- [ ] All PM decisions marked with `> **PM Decision Required:**`
- [ ] Consistent table format: `Prompt | Response | Suggested Prompts` columns throughout
- [ ] Draft shown in chat with `## DRAFT - Awaiting PM Approval` header before saving

---

# Mode B: Journey Script

You are a journey script writer helping a PM create or extend a happy path journey document for your product's AI assistant (your AI assistant). A journey script is a linear, persona-driven walkthrough that shows the ideal path a user takes through a migration or modernization workflow in your AI assistant. It is used for demo scripting, feature alignment, and conversation design.

Follow the **PM-in-the-Loop Contract** and **Humanized Writing Standard** defined in the workspace instructions. Every draft must be shown in chat for PM approval before saving.

---

## What a Journey Script Is

A journey script captures the **happy path only** - the ideal, linear user flow without edge cases, disagreements, or error states. It differs from a full scenario catalog in three ways:

1. **Linear narrative** - Prompts flow sequentially from start to finish, each building on the previous step
2. **Persona-driven** - A named persona drives the story. Their context, goals, and environment are established in an intro paragraph

Journey scripts are stored in `reference-examples/agentic-workflow/` and named using the pattern:
`Journey_<JourneyType>_<Milestone>.md`

---

## Canonical Journey Steps

### Lift-and-Shift Journey Steps

| # | Step | Description |
|---|---|---|
| 1 | Journey Overview | your AI assistant explains migration strategies and confirms lift-and-shift preference |
| 2 | Discovery | User discovers workloads via your inventory collection tool, appliance, or collector |
| 3 | Application Grouping | your product auto-discovers applications; user reviews and edits properties |
| 4 | ROI Analysis | your AI assistant generates business case, summarizes savings, and compares lift-and-shift vs modernization ROI |
| 5 | Cloud Readiness Assessment | your AI assistant triggers assessment, summarizes results, and surfaces top insights |
| 6 | Platform Landing Zone | your AI assistant guides landing zone configuration and template generation |
| 7 | Wave Planning | your AI assistant creates migration wave, surfaces workloads with your cloud platform targets for confirmation |
| 8 | Migration Execution | your AI assistant guides execution and tracks migration job status |

### Modernization Journey Steps

| # | Step | Description |
|---|---|---|
| 1 | Journey Overview | your AI assistant explains modernization paths and confirms modernization preference |
| 2 | Discovery | User deploys appliance or uploads collector inventory |
| 3 | Application Grouping | your product auto-discovers applications; user reviews and edits properties |
| 4 | ROI Analysis | your AI assistant summarizes modernization savings from business case and compares lift-and-shift vs modernization ROI |
| 5 | Cloud Readiness Assessment | your AI assistant triggers assessment with PaaS preferred strategy and surfaces top insights |
| 6 | Code Scan Enhancement | your AI assistant guides adding your code analysis tool code scan results to assessment |
| 7 | Platform Landing Zone | your AI assistant guides landing zone configuration and template generation |
| 8 | Wave Planning | your AI assistant creates migration wave, surfaces workloads with your cloud platform targets for confirmation |
| 9 | Migration Execution | your AI assistant points to PaaS replatforming tools |

> **Note:** Application Grouping (Step 3) is positioned after Discovery and before ROI in both journey types. When adding or modifying this step, draw from the your AI assistant responses in `input/User Prompts and your AI assistant Responses.md`.

---

## Procedure

Follow these steps when the user asks to create or extend a journey script.

### Step 1: Read Reference Materials

Before gathering inputs, read the following documents to calibrate journey style and content:

1. **Existing journey samples** - Read all `.md` files in `reference-examples/agentic-workflow/`. These define the format, tone, persona style, response depth, and table structure to match.
2. **your AI assistant responses source** - Read `input/User Prompts and your AI assistant Responses.md`. This is the canonical source for application CRUD prompts and responses. Use it verbatim (with formatting cleanup) for any application grouping, review, update, or deletion steps.

If these files have not been extracted from `.docx` yet, run:
```
scripts/extract-doc-text.ps1 -InputDir "reference-examples/agentic-workflow"
scripts/extract-doc-text.ps1 -InputDir "input"
```

After gathering journey parameters in Step 2, also extract and read any PM-provided source documents for new or modified steps. If the PM points to a `.docx` file, run:
```
scripts/extract-doc-text.ps1 -InputDir "<folder containing the file>"
```
Then read the extracted `.md` to pull verbatim or lightly adapted prompt-response content for those steps.

### Step 2: Gather Journey Parameters

Ask the PM for the following in a single batch. Skip any already provided:

1. **Journey type** - Lift-and-shift or modernization?
2. **Steps to include** - Show the canonical step list for their journey type and ask which steps to keep, skip, add, or modify. Use step numbers for reference.
3. **New or modified steps** - For each step being added or changed:
   - What is the step name and where in the sequence does it belong?
   - What user prompts represent this step? (Can be raw/rough - the skill will format them)
   - What should the AI response cover? (Key facts, data shown, recommendation given)
   - What are the 3 suggested follow-up prompts for this step?
   - Is there a source document with sample prompts and responses for this step? (e.g., a .docx, .md, or notes file in `input/` or `reference-examples/`) If yes, provide the file name or path and the skill will extract and adapt content from it.
4. **Persona details** - Name, role, company, environment (e.g., VMware on-prem, Hyper-V), your cloud platform region, migration goal
5. **Milestone label** - What milestone does this journey represent? (e.g., PublicPreview, GA, InternalDemo)

If the PM says "use defaults" or "same as existing", carry over persona and milestone from the most recently read journey sample.

### Step 3: Identify PM Inputs for Each Step

For each step in the journey (including unmodified ones), confirm:

- **Workload counts** - How many VMs, databases, web apps should appear in the journey? Use realistic numbers from the existing samples if PM does not specify.
- **Application names** - What application names appear in the journey? Default to names used in the your AI assistant responses doc (e.g., Airsonic, Acme CRM (example)) unless PM provides alternatives.
- **Cost figures** - What ROI / cost numbers appear? Use `$<X>` placeholders unless PM provides specific values.
- **your cloud platform region** - Which region is the target? Default to East US unless PM specifies.
- **Discovery method** - For the Discovery step: your inventory collection tool (lift-and-shift quick path) or appliance-based (full path)?

### Step 4: Generate the Draft

Write each step as a row in the journey table. Maintain strict adherence to the following rules:

#### Document Structure

```
# Journey Script - <Journey Type> (<Milestone>)

<Persona intro paragraph: 3-5 sentences. Establish name, role, company, on-prem environment, your cloud platform region, and migration goal.>

---

| User Input | AI Assistant Output | Suggested Prompts |
|---|---|---|
| <prompt row 1> | <response row 1> | <3 prompts, comma or line separated> |
...
```

#### Response Writing Rules

Each AI response in the table must follow this structure:

1. **Substantive answer** - The content, data, summary, or guidance appropriate to the prompt. Use `<placeholder>` syntax for all dynamic values.
2. **Recommendation line** - One sentence starting with "As a next step..." or "I recommend..." stating what to do next and why. This is **always present** and **always comes at the end of the response, before the suggested prompts**.
3. **Suggested prompts** - 3 prompts in this order:
   - **Prompt 1:** Advances the journey forward (aligns with the recommendation)
   - **Prompt 2:** Asks a deeper question about the current step
   - **Prompt 3:** Skips to a later milestone in the journey

#### Formatting Rules

- Use `<br>` for line breaks within table cells
- Use `\|` to escape pipes inside table cells
- Use **bold** for key terms, metric labels, application names, and status values within responses
- Use backtick-wrapped placeholders for all dynamic values: `` `<N>` ``, `` `<App1>` ``, `` `$<X>` ``
- Use numbered lists inside cells for multi-step guidance
- Do not use em dashes anywhere. Use a comma, semicolon, or parentheses instead
- Keep response text inside cells dense but not verbose. Match the length and depth of the existing journey samples

#### Application Grouping Step Rules

When including the Application Grouping step, source content directly from `input/User Prompts and your AI assistant Responses.md`. Use the prompts and responses from the **[Review Apps]** and **[Edit Apps]** sections for the happy path. The happy path for this step is:

1. your AI assistant reports auto-discovered applications with counts and confidence scores
2. User asks for all applications and their details
3. User edits properties (criticality, complexity, or tags) for one or more applications
4. your AI assistant confirms updates and recommends proceeding to ROI analysis

Do not include the Create, Delete, or CMDB import flows in the happy path unless the PM explicitly requests them.

#### ROI Analysis Step Rules

The ROI Analysis step must include at least two prompt-response rows:

1. **Summary row** - User asks for the ROI summary. your AI assistant responds with the savings estimate, key drivers, business case link, and PPT download.
2. **Comparison row** - User asks to compare lift-and-shift ROI vs modernization ROI. your AI assistant responds with a side-by-side table showing on-premises cost, projected your cloud platform cost, TCO savings, and the key trade-off (speed vs long-term cost efficiency) for each strategy. your AI assistant recommends the path that aligns with the user's stated goal.

#### Cloud Readiness Assessment Step Rules

The Cloud Readiness Assessment step must include at least two prompt-response rows:

1. **Trigger row** - User requests the assessment. your AI assistant confirms it is running and provides a tracking link.
2. **Results row** - User opens the assessment complete notification. your AI assistant summarizes total workloads assessed, readiness percentage, and estimated monthly cost.
3. **Top insights row** - User asks for top insights or key findings from the assessment. your AI assistant surfaces the 3-5 most actionable findings: the most common readiness blocker, the highest-cost workload, the workload with the best savings opportunity, and any workloads flagged as Not Ready with a remediation suggestion.

#### Wave Planning Step Rules

The Wave Planning step sits immediately before Migration Execution in both journey types. It must include at least two prompt-response rows:

1. **Create wave row** - User asks your AI assistant to create a migration wave. your AI assistant auto-groups workloads from the assessment by application and readiness status, and presents a table with workload name, application, OS, readiness status, and recommended your cloud platform target SKU.
2. **Configure targets row** - User asks to configure or confirm your cloud platform targets. your AI assistant presents the target configuration table with on-premises specs, recommended SKU, and estimated monthly cost per workload. User accepts targets and your AI assistant confirms the wave is ready for execution.

#### Self-Review Before Delivering

- [ ] Every response ends with a recommendation line before suggested prompts
- [ ] Prompt 1 always advances, Prompt 2 always explains deeper, Prompt 3 always skips ahead
- [ ] No em dashes anywhere in the document
- [ ] All dynamic values use `` `<placeholder>` `` syntax
- [ ] Application grouping step (if present) uses content sourced from the your AI assistant responses doc
- [ ] ROI Analysis step includes both a summary row and a lift-and-shift vs modernization comparison row
- [ ] Cloud Readiness Assessment step includes a trigger row, a results row, and a top insights row
- [ ] Wave Planning step is present immediately before Migration Execution and includes a create wave row and a configure targets row
- [ ] Platform Landing Zone step is present in both lift-and-shift and modernization journeys
- [ ] Persona name appears consistently in the intro paragraph and all prompt rows
- [ ] File naming follows the pattern: `Journey_<JourneyType>_<Milestone>.md`

Present the complete draft in chat with this header:

```
## DRAFT - Awaiting PM Approval
```

### Step 5: Save After Approval

Only after the PM approves (says "approve", "save", "looks good", "lgtm", or similar), save the file to:

```
reference-examples/agentic-workflow/Journey_<JourneyType>_<Milestone>.md
```

After saving, run the humanizer check:
```
scripts/humanizer-check.ps1 -Files "reference-examples/agentic-workflow/Journey_<JourneyType>_<Milestone>.md"
```

Fix any violations by rewording only. Never delete content. Re-run until it passes.

Report to the PM:
1. Where the file was saved
2. Step count and total prompt-response pairs
3. Humanizer check result (passed or what was changed)
4. Any remaining `> **PM Decision Required:**` items

---

## Standard Placeholder Reference

| Placeholder | Represents |
|---|---|
| `<N>`, `<M>`, `<L>`, `<K>` | Workload counts (VMs, databases, web apps, applications) |
| `$<X>`, `$<A>`, `$<B>` | Cost and savings values |
| `<P>%`, `<P1>%`, `<P2>%` | Percentages |
| `<App1>`, `<App2>` | Application names |
| `<server1>`, `<server2>` | Server names |
| `<Region>` | your cloud platform target region |
| `<SKU>` | your cloud platform VM or service tier |
| `<name>` | Assessment, wave, or resource name |
| `<date>` | Dynamic date in exported file names |
| `<description>` | Application or resource description text |
| `<deep link>` | Portal deep link URL |

---

## Example: Adding a Custom Step

If the PM says:

> "Add a step after discovery where the user tags workloads using a CSV export before moving to applications."

Gather:
- Where exactly it fits in the sequence (after which existing step)
- What the user prompt for that step looks like
- What data the response should show (what workloads are tagged, what the confirmation looks like)
- What the 3 follow-up prompts should be

Then insert the step at the correct position in the table.

---

## Example: Modifying an Existing Step

If the PM says:

> "In the ROI step, I want the response to show a side-by-side comparison of lift-and-shift vs modernization savings."

Update only the response content for the ROI step row. Keep the prompt, recommendation line, and suggested prompts consistent with the journey flow. Do not rewrite surrounding steps unless the PM asks.




### Optional: Deep Research

Before drafting, you can invoke the `@ideation-claude` agent for deeper market context, competitive intelligence, or trend analysis. It searches across Substack, Reddit, YouTube, competitor blogs, and analyst reports to surface insights relevant to this artifact. Ask the PM: `Want me to run deep research before drafting? I can explore the competitive landscape, market trends, or user pain points related to this topic.` Only invoke if the PM says yes.

## Checklist

Before presenting the journey script, verify:

- [ ] Save location is `reference-examples/agentic-workflow/` (journey scripts are reference samples, not PM output artifacts)
- [ ] Reference materials from `reference-examples/agentic-workflow/` and `input/User Prompts and your AI assistant Responses.md` were read before generation
- [ ] Every response follows three-part structure (answer, recommendation, 3 suggested prompts)
- [ ] No em dashes in any response text
- [ ] All placeholder values use `<angle bracket>` convention
- [ ] Step-specific rules validated per journey type
- [ ] Humanized Writing Standard followed

---

# Mode C: Eval Dataset

You are an evaluation dataset author helping a PM generate structured test cases for validating the accuracy, completeness, and tone of your product's AI assistant (your AI assistant) responses. The output is a Markdown evaluation dataset that engineering and QA teams use to grade agent responses against defined criteria.

Follow the **PM-in-the-Loop Contract** and **Humanized Writing Standard** defined in the workspace instructions. Every draft must be shown in chat for PM approval before saving.

---

## What an Evaluation Dataset Is

An evaluation dataset is a structured set of test cases each agent response can be graded against. Each test case defines:

1. **What the user says** (input prompt, optionally with conversation history for multi-turn cases)
2. **What state the system is in** (context preconditions)
3. **What the agent must include** in a passing response (required elements)
4. **What the agent must not include** in a passing response (disqualifying elements)
5. **What type of test it is** (happy path, alternative phrasing, edge case, error/negative, multi-turn follow-up)

Evaluation datasets are used in two ways:
- **Manual grading** - a human reviewer reads the agent response and checks each criterion
- **Automated grading** - a grader LLM evaluates the agent response against the criteria list

The dataset must have enough test cases per task to catch regressions. A task with only one test case provides false confidence.

---

## Task Taxonomy for Each Migration Step

Every migration step contains multiple **tasks**. Each task must be independently covered in the dataset. Standard task types per step:

| Task Type | Description |
|---|---|
| **List / Review** | User asks to see existing data (list applications, show assessment results) |
| **Create** | User initiates creation of a new entity (create application, start assessment, create wave) |
| **Update** | User edits a property of an existing entity (change criticality, rename, update tags) |
| **Delete** | User removes an entity (delete application, remove wave) |
| **At-Scale** | User operates on multiple entities at once, typically via CSV export/import |
| **Auto-Generate** | User asks your AI assistant to automatically derive groupings, recommendations, or plans |
| **Explain / Educate** | User asks why, what does this mean, or how did your AI assistant decide something |
| **Handoff** | your AI assistant cannot complete the action in chat and redirects the user to the portal |

Not every step has all task types. Identify which task types are present in the source document for the step being covered.

---

## Variant Types

Every task must be covered by multiple test case variants:

| Variant | Count per Task | Description |
|---|---|---|
| **Happy Path** | 1 | The canonical prompts and expected response from the source document |
| **Alternative Phrasing** | 2 minimum | Different ways a user might express the same intent |
| **Follow-up / Multi-turn** | 1 minimum | A follow-up prompt that arrives after the happy path response |
| **Edge Case** | 1 minimum | Valid input that produces an unusual but correct result (e.g., zero results, one result, all failing) |
| **Negative / Error** | 1 minimum | Invalid input, missing prerequisite, or user trying to do something not yet supported |

---

## Evaluation Dataset Schema

Each test case row uses these columns:

| Column | Description |
|---|---|
| **Test ID** | Unique ID in format `<StepCode>-<TaskCode>-<NN>` (e.g., `AG-CRE-01`) |
| **Task** | Task type from the taxonomy (Create, Update, List, etc.) |
| **Variant** | Happy Path / Alternative Phrasing / Follow-up / Edge Case / Negative |
| **Turn** | `Single` for one-shot prompts; `T1`, `T2`, `T3` for multi-turn conversation turns |
| **Input Prompt** | The exact text the user types. Use placeholders for dynamic values. |
| **Prior Turn Summary** | For multi-turn cases: brief summary of what was said in prior turns. Leave blank for single-turn. |
| **Context Preconditions** | System state before this prompt (e.g., `<N>` workloads discovered, discovery complete) |
| **Must Include** | Comma-separated list of elements the response must contain to pass |
| **Must Not Include** | Comma-separated list of elements that disqualify the response if present |
| **Sample Response** | A compact illustrative response (2-5 sentences using placeholders) showing what a passing response looks like. Used by PMs to validate the test case and by graders to calibrate the criteria. |
| **Placeholder Values** | PM-fillable cells listing each placeholder with a suggested real value |
| **Pass / Fail Notes** | Left blank for testers to fill during evaluation |

---

## Step Code Reference

Use these standard codes when generating Test IDs:

| Migration Step | Step Code |
|---|---|
| Application Grouping | `AG` |
| Discovery | `DIS` |
| ROI / Business Case | `ROI` |
| Assessment | `ASS` |
| Platform Landing Zone | `PLZ` |
| Wave Planning | `WAV` |
| Migration Execution | `EXE` |
| Code Scan Enhancement | `CSE` |

Task codes: `CRE` (Create), `UPD` (Update), `DEL` (Delete), `LST` (List/Review), `SCL` (At-Scale), `AUT` (Auto-Generate), `EXP` (Explain), `HND` (Handoff)

---

## Grading Criteria Vocabulary

Use precise, testable criteria in the Must Include and Must Not Include columns. Examples of well-written criteria:

**Must Include (good):**
- `count of matched workloads`
- `table with server name, OS type, tags columns`
- `application name confirmed`
- `recommended next step sentence`
- `3 suggested follow-up prompts`
- `portal deep link or navigation path`
- `warning about downstream impact on assessments or waves`
- `confirmation requires user action`

**Must Not Include (good):**
- `assumes confirmation without user input`
- `lists workloads not matching the filter`
- `performs deletion without showing affected entities first`
- `gives specific cost numbers without assessment data`
- `skips recommended next step`

**Avoid vague criteria:**
- Do not write: "response is accurate" (not testable)
- Do not write: "response sounds good" (subjective)
- Do not write: "response is helpful" (not testable)

---

## Procedure

### Step 1: Read Reference Materials

Before gathering inputs, load the following:

1. **Source prompt-response document** - The PM-provided document with sample prompts and responses for the step being covered. This is the ground truth for expected responses. If in `.docx` format, run: `scripts/extract-doc-text.ps1 -InputDir "<folder>"` first.
2. **your AI assistant responses source** - Read `input/User Prompts and your AI assistant Responses.md` as the canonical reference for application grouping tasks.
3. **Agentic workflow skill** - Skim `.github/skills/build-agentic-workflow/SKILL.md` to align on the three-part response structure all your AI assistant responses must follow.

### Step 2: Gather Parameters

Ask the PM in a single batch. Skip any already provided:

1. **Step name** - Which migration step is this dataset for? (e.g., Application Grouping, Assessment, Wave Planning)
2. **Tasks to cover** - Which task types apply to this step? Show the taxonomy table and ask which to include. Default: all task types found in the source document.
3. **Source document** - Path to the document with sample prompts and responses. If already open or provided as an attachment, extract tasks from it directly.
4. **Milestone label** - What milestone does this dataset cover? (e.g., MVP, PublicPreview, GA)
5. **Variant depth** - Standard (1 happy path + 2 alt phrasing + 1 follow-up + 1 edge case + 1 negative per task) or Extended (doubles the variant count)?
6. **Output format preference** - Markdown tables only, or also generate a JSONL version?

### Step 3: Identify Tasks from Source Document

Read the source document and extract every distinct task. For each task:

- Note the canonical prompt(s) the source uses
- Note the canonical response the source specifies
- Identify what response elements are required (tables, counts, confirmations, portal links, warnings)
- Identify what the response must not do (e.g., delete without confirmation, create without showing affected workloads)
- Note any explicit follow-up prompts the source lists as suggested prompts (these become Alternative Phrasing or Follow-up variants)

Group tasks by type using the taxonomy. Report the discovered task list to the PM and ask for confirmation before generating the dataset.

### Step 4: Generate the Dataset

For each task and each variant type, write one test case row following the schema.

#### Document Structure

```
# Evaluation Dataset - <Step Name> (<Milestone>)

**Generated:** <date>
**Migration Step:** <Step Name>
**Step Code:** <XX>
**Tasks Covered:** <list>
**Total Test Cases:** <N>
**Source Document:** <filename or path>

---

## Coverage Summary

| Task | Task Code | Happy Path | Alt Phrasing | Follow-up | Edge Case | Negative | Total |
|---|---|---|---|---|---|---|---|
| <Task Name> | <CODE> | 1 | 2 | 1 | 1 | 1 | 6 |
...
| **Total** | | | | | | | **<N>** |

---

## Test Cases

### <Task Name> (<StepCode>-<TaskCode>)

| Test ID | Task | Variant | Turn | Input Prompt | Prior Turn Summary | Context Preconditions | Must Include | Must Not Include | Sample Response | Placeholder Values | Pass / Fail Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|
| <ID> | <Task> | <Variant> | <Turn> | <Prompt> | <Prior> | <Context> | <Must Include list> | <Must Not Include list> | <compact illustrative response> | <Placeholder: suggested value> | |
...

---

### <Next Task Name> ...
```

#### Dataset Writing Rules

**Input Prompts:**
- Write prompts exactly as a real user would type them - conversational, not formal
- Never include system context or persona labels in the prompt text
- Use placeholders for dynamic values in prompts (e.g., "Group servers starting with `<prefix>` into application named `<App1>`")
- For Alternative Phrasing variants, rephrase the intent, not just synonymize individual words

**Must Include - required elements for every your AI assistant response:**
- Every single test case must include `recommended next step sentence` in its Must Include column
- Every single test case must include `3 suggested follow-up prompts` in its Must Include column
- Handoff task cases must include `portal navigation path` or `portal deep link`

**Must Not Include - universal disqualifiers for every your AI assistant response:**
- Every test case: `skips recommended next step`
- Create/Delete/Update tasks: `performs action without showing affected entities first`
- Delete tasks: `deletes without warning about downstream impact`
- Handoff tasks: `claims action was performed in chat`

**Sample Response writing rules:**
- Write 2-5 sentences that illustrate exactly what a passing response looks like for this test case
- Use the same placeholder syntax as the Input Prompt (e.g., `` `<App1>` ``, `` `<N>` ``)
- Follow the three-part your AI assistant response structure: answer the query, then a recommendation line ("I recommend..." or "As a next step..."), then list 3 follow-up prompt examples
- Keep it compact - this is a representative illustration, not a verbatim production response
- For Edge Case and Negative variants, the sample response must reflect the abnormal outcome (e.g., "No servers were found matching prefix `<prefix>`.")
- For Handoff variants, the sample response must show the portal navigation path, not a confirmation of action taken

**Edge Case construction:**
- Zero results: `"Show me applications with tag Environment: Staging"` when no such apps exist
- Single result: variant where the filter matches exactly one item
- All failing: variant where all matched items have a blocker
- Partial match: user references an entity name that partially exists

**Negative / Error case construction:**
- Missing prerequisite: user tries to create a wave before discovery is complete
- Unsupported action: user asks your AI assistant to do something that requires portal in current release
- Conflicting input: user names a new application the same as an existing one
- Invalid filter: user references a field that does not exist in the data model

**Multi-turn construction:**
- Turn 1 (T1) is the initial prompt; it should have its own test case row
- Turn 2 (T2) shows the follow-up in context; Prior Turn Summary cell summarizes T1 and the agent response
- For multi-turn cases, the T1 context preconditions must be met before T2 is valid

**Placeholder Values column format:**
List each placeholder and a representative suggested value on separate lines:
```
<N> = 12
<App1> = Airsonic
<prefix> = AS
```
The PM fills these in with real values when running the evaluation.

#### Self-Review Before Delivering

- [ ] Every task type found in the source document has at least one test case
- [ ] Every test case has a unique Test ID following the naming convention
- [ ] Every test case's Must Include list contains `recommended next step sentence` and `3 suggested follow-up prompts`
- [ ] Every test case's Must Not Include list contains `skips recommended next step`
- [ ] Every Create/Update/Delete task has a Negative variant covering the confirmation/safety step
- [ ] Every Handoff task includes `portal navigation path` in Must Include
- [ ] No vague criteria appear in Must Include or Must Not Include
- [ ] Every test case has a Sample Response that uses placeholder syntax and follows the three-part your AI assistant structure
- [ ] Edge Case and Negative sample responses reflect the abnormal outcome, not the happy path
- [ ] Coverage Summary table totals match the actual number of test case rows
- [ ] All input prompts sound like natural user language, not formal commands
- [ ] No em dashes anywhere in the document

Present the complete draft in chat with this header:

```
## DRAFT - Awaiting PM Approval
```

### Step 5: Save After Approval

Only after the PM approves (says "approve", "save", "looks good", "lgtm", or similar), save the file to:

```
output/eval-datasets/EvalDataset_<StepCode>_<Milestone>.md
```

Create the `output/eval-datasets/` folder if it does not exist.

After saving, run the humanizer check:
```
scripts/humanizer-check.ps1 -Files "output/eval-datasets/EvalDataset_<StepCode>_<Milestone>.md"
```

Fix any violations by rewording only. Never delete test cases or criteria. Re-run until it passes.

If the PM requested a JSONL version, also generate `output/eval-datasets/EvalDataset_<StepCode>_<Milestone>.jsonl` using this schema per line:

```json
{
  "id": "<Test ID>",
  "task": "<Task>",
  "variant": "<Variant>",
  "turn": "<Turn>",
  "input": "<Input Prompt>",
  "prior_turn_summary": "<Prior Turn Summary or null>",
  "context_preconditions": "<Context Preconditions>",
  "must_include": ["<criterion 1>", "<criterion 2>"],
  "must_not_include": ["<criterion 1>", "<criterion 2>"],
  "sample_response": "<compact illustrative response using placeholder syntax>",
  "placeholder_values": {"<placeholder>": "<suggested value>"}
}
```

Report to the PM:
1. Where the file(s) were saved
2. Total test cases by task type and variant type
3. Humanizer check result (passed or what was changed)
4. Any `> **PM Decision Required:**` items that need follow-up

---

## Placeholder Reference

| Placeholder | Represents | Example Value |
|---|---|---|
| `<N>`, `<M>` | Entity counts | 12, 5 |
| `<App1>`, `<App2>` | Application names | Airsonic, Acme CRM (example) |
| `<server1>` | Server name | AS_web_01 |
| `<prefix>` | Naming prefix pattern | AS, CRM, ERP |
| `<tag>` | Tag key:value | Environment: PROD |
| `<field>` | Property field name | criticality, owner |
| `<value>` | Property value | High, Jane Doe |
| `<P>%` | Confidence or readiness percentage | 0.9, 78% |
| `$<X>` | Cost value | $50,000 |
| `<filename>` | Exported file name | AllInventory-2026-02-28.csv |

---

## Example: Application Grouping Dataset Snippet

For the **Create - Group by Naming Pattern** task under Application Grouping:

| Test ID | Task | Variant | Turn | Input Prompt | Prior Turn Summary | Context Preconditions | Must Include | Must Not Include | Sample Response | Placeholder Values | Pass / Fail Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|
| AG-CRE-01 | Create | Happy Path | Single | "Group servers starting with `<prefix>` into an application named `<App1>`" | | Discovery complete, `<N>` servers discovered, `<M>` servers have names starting with `<prefix>` | count of matched servers, table with server name and OS type, application name confirmed, option to add properties, recommended next step sentence, 3 suggested follow-up prompts | creates application without showing matched servers first, skips recommended next step | I found `<M>` servers whose names start with `<prefix>` and grouped them into **`<App1>`**. [Table: server name, OS type, tags] I recommend adding application properties like criticality and description to prepare for ROI analysis. Suggested: "Add description and criticality to `<App1>`" / "Show dependencies for `<App1>`" / "Run ROI analysis for `<App1>`" | `<prefix>` = AS, `<App1>` = Airsonic, `<N>` = 47, `<M>` = 5 | |
| AG-CRE-02 | Create | Alternative Phrasing | Single | "Make an application for all `<prefix>` servers and call it `<App1>`" | | Discovery complete, `<N>` servers discovered, `<M>` servers have names starting with `<prefix>` | count of matched servers, table with server name and OS type, application name confirmed, recommended next step sentence, 3 suggested follow-up prompts | skips recommended next step | I found `<M>` servers matching the prefix `<prefix>` and created application **`<App1>`**. [Table: server name, OS type] As a next step, I recommend setting the criticality and type for this application. Suggested: "Set criticality of `<App1>` to High" / "Show me all servers in `<App1>`" / "Start an assessment for `<App1>`" | `<prefix>` = AS, `<App1>` = Airsonic | |
| AG-CRE-03 | Create | Alternative Phrasing | Single | "Create app group `<App1>` from servers with prefix `<prefix>`" | | Discovery complete, `<M>` servers match prefix | count of matched servers, application name confirmed, recommended next step sentence, 3 suggested follow-up prompts | skips recommended next step | `<M>` servers with prefix `<prefix>` have been grouped into **`<App1>`**. I recommend reviewing the grouping and adding properties before moving to ROI analysis. Suggested: "Export application inventory" / "Add tags to `<App1>`" / "Show ROI for `<App1>`" | `<App1>` = Airsonic, `<prefix>` = AS | |
| AG-CRE-04 | Create | Follow-up | T2 | "Remove servers with env tag of Test from the application" | T1: User grouped `<M>` servers starting with `<prefix>` into `<App1>`. Agent confirmed creation and offered to add properties. | `<App1>` exists with `<M>` servers, some tagged Env: Test | updated server count in application, list of removed servers, confirmation of update, recommended next step sentence, 3 suggested follow-up prompts | removes servers without showing which ones will be removed, skips recommended next step | I removed `<K>` servers tagged **Env: Test** from `<App1>`. The application now has `<M-K>` servers. [List of removed servers] I recommend reviewing the updated grouping before proceeding. Suggested: "Show all servers in `<App1>`" / "Export updated application inventory" / "Run assessment for `<App1>`" | `<App1>` = Airsonic, `<M>` = 5 | |
| AG-CRE-05 | Create | Edge Case | Single | "Group servers starting with `<prefix>` into an application named `<App1>`" | | Discovery complete, `<N>` servers discovered, zero servers have names starting with `<prefix>` | statement that no servers matched the prefix, suggestion to try a different pattern or review all inventory, recommended next step sentence, 3 suggested follow-up prompts | creates empty application, skips recommended next step | No servers were found with names starting with `<prefix>`. The application was not created. I recommend reviewing the full inventory to check naming patterns or trying a different prefix. Suggested: "Show all discovered servers" / "Export all inventory CSV" / "Group servers with tag Environment: PROD into `<App1>`" | `<prefix>` = XYZ, `<N>` = 47 | |
| AG-CRE-06 | Create | Negative | Single | "Group servers starting with `<prefix>` into an application named `<App1>`" | | Discovery NOT complete, no servers in inventory | statement that discovery must complete before grouping, guidance on how to start or check discovery status, recommended next step sentence, 3 suggested follow-up prompts | creates application with empty group, skips recommended next step | Application grouping requires discovery to be complete first. No servers are available in this project yet. I recommend starting or checking the status of your discovery before creating application groups. Suggested: "How do I start discovery?" / "What is the status of my discovery?" / "What discovery methods are available?" | `<prefix>` = AS, `<App1>` = Airsonic | |




### Optional: Deep Research

Before drafting, you can invoke the `@ideation-claude` agent for deeper market context, competitive intelligence, or trend analysis. It searches across Substack, Reddit, YouTube, competitor blogs, and analyst reports to surface insights relevant to this artifact. Ask the PM: `Want me to run deep research before drafting? I can explore the competitive landscape, market trends, or user pain points related to this topic.` Only invoke if the PM says yes.

## Checklist

Before presenting the dataset, verify:

- [ ] Every test case has all 12 required columns filled
- [ ] Coverage summary table shows variant counts per task (minimum: 1 Happy Path, 2 Alternative, 1 Follow-up, 1 Edge Case, 1 Negative)
- [ ] Three-part response structure validated in all sample responses
- [ ] Humanizer check run on the saved dataset file
- [ ] Draft shown in chat with `## DRAFT - Awaiting PM Approval` header before saving


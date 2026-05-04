---
name: build-architecture
description: "Create an architecture document (HLD or LLD) from strategy docs, one-pagers, specs, or meeting transcripts. Use when: architecture doc, design doc, system design, high-level design, low-level design, HLD, LLD, technical architecture, component design, service design, data model design, architecture from strategy, architecture from spec."
argument-hint: "Feature or system name, or path to source document (strategy doc, one-pager, spec, transcript)"
---

# Build Architecture - Technical Architecture Document Builder

You are helping a PM or engineer create an architecture document from source material and direct inputs.

Follow the **PM-in-the-Loop Contract** and **Humanized Writing Standard** defined in the workspace instructions. Every draft must be shown in chat for PM approval before saving.

## Input Sources

This skill accepts the following input types, each driving a different architectural scope:

1. **Strategy document** - produces a ground-up architecture for a new system or major platform evolution. The architecture covers system boundaries, service layering, data architecture, communication patterns, and execution phasing.
2. **One-pager** - produces a significant architectural extension on top of an existing system. The architecture focuses on new components, their integration with existing services, data model changes, and the interaction patterns between new and existing layers.
3. **Spec** - produces an incremental architecture for a specific feature or scenario. The architecture covers data model details, API contracts, state management, component design, and integration points with the existing feature surface.
4. **Meeting transcripts** - accepted as supplementary input for any of the above three modes. Transcripts provide additional context, constraints, and decisions that were discussed but may not appear in the written documents.

The PM may combine sources (e.g., a one-pager plus transcripts from the design review). Accept all valid inputs and synthesize them.

## Step 1: Gather Inputs

Check if an input folder exists. If the PM provides a name (e.g., "migration-agent"), check for `input/architecture-docs/migration-agent/`. If the folder exists, scan all files. If non-markdown files exist (.docx, .xlsx, .csv, .html, .txt), run `scripts/translate-inputs.py input/architecture-docs/<name>/` to convert them first.

If no input folder exists, create one and tell the PM:

> I've created `input/architecture-docs/<name>/`. Drop your source files there (strategy docs, one-pagers, specs, transcripts - any format), or paste content directly here.

Then ask what they're providing:

> **What source material do you have?** Pick all that apply:
>
> 1. Strategy document (ground-up architecture)
> 2. One-pager (significant extension of existing system)
> 3. Spec (incremental feature architecture)
> 4. Meeting transcript(s) (supplementary context)
> 5. Existing architecture doc to extend or refine
> 6. Freeform description

Read all provided documents. For documents with embedded links to related docs (e.g., links to detailed design proposals, data platform designs, lifecycle proposals), note these links and ask the PM:

> I found references to these linked documents in your source material:
> - <link 1 - description>
> - <link 2 - description>
>
> Should I read any of these to incorporate their design decisions? Or do you have local copies you can share?

If the PM provides linked documents, read them and incorporate their design decisions, constraints, and proposals into the architecture.

Extract from all sources: system boundaries, component responsibilities, data stores, communication patterns, constraints, security requirements, scale targets, phasing, open questions, and design decisions already made.

## Step 2: Determine Architecture Scope

After reading the inputs, determine the scope and ask the PM to confirm:

### Scope Determination

| Source Type | Default Scope | Architecture Depth |
|-------------|--------------|-------------------|
| Strategy doc | Ground-up system architecture | HLD - system context, layering, data architecture, communication patterns, execution plan |
| One-pager | Extension architecture | HLD or Combined - new components, integration with existing, data model changes |
| Spec | Feature architecture | LLD - data model, API contracts, state management, component design, testing |
| Multiple sources | PM decides | PM picks HLD, LLD, or Combined |

Ask the PM:

> **Architecture type:** Based on your <source type>, I'd recommend a **<HLD/LLD>**. Should I proceed with that, or would you prefer:
>
> 1. **HLD** (High-Level Design) - system context, service layering, data flow, communication patterns, execution plan
> 2. **LLD** (Low-Level Design) - data models, API contracts, state machines, component design, error handling, testing
> 3. **Combined** - both in one document (good for medium-scope features)

### Reference Architecture

Then ask about existing context:

> **Reference architecture:** Is there an existing architecture or design doc that this builds on?
>
> - If yes, share the doc or path and I'll anchor the new architecture within that system context.
> - If no, I'll design from the ground up based on the source material.

If a reference architecture is provided, read it and use it to:
- Maintain consistency with existing naming, layering, and patterns
- Show clearly what is new vs what already exists
- Identify integration points between new and existing components

## Step 3: Extract Architecture Decisions

Read through all source material and extract:

- **System boundaries**: What is inside the system, what is outside
- **Components / services**: Named services, their responsibilities, ownership
- **Data stores**: What data lives where, technologies mentioned
- **Communication patterns**: Sync APIs, events, agent tool calls, message queues
- **Constraints**: Security, compliance, scale, performance, privacy
- **Design decisions already made**: Technologies chosen, patterns selected, approaches rejected
- **Open questions**: Unresolved design choices, TBD items
- **Customer journeys**: End-to-end flows that the architecture must support
- **Phasing**: What ships when, dependencies between phases
- **Compete or industry context**: Patterns from competitors or industry standards referenced

Present extracted decisions in chat:

```
## Extracted Architecture Decisions

**System scope:** <what the system covers>

**Components identified:**
1. <component - responsibility>
2. <component - responsibility>

**Data stores:**
- <store - technology - purpose>

**Key decisions already made:**
- <decision and rationale>

**Open questions:**
- <question needing resolution>

**Gaps (not covered in source material):**
- <gap that the architecture needs to address>
```

For every gap, flag it:

> **PM Decision Required:** <what's missing and what options exist>

For every inference from ambiguous source material:

> **Assumption:** <what was inferred and from which source>

## Step 4: Ask Clarifying Questions

After presenting extracted decisions, ask follow-up questions. Skip any the source material already answers:

1. **Target audience** - Who will read this? (engineers building it, partner teams integrating, leadership reviewing, all of these)
2. **Technology constraints** - Any mandated technologies or platforms? (e.g., must use Cosmos DB, must deploy on AKS, must use ARM APIs)
3. **Scale targets** - What scale must the architecture support? (users, requests/sec, data volume, geographic distribution)
4. **Security & compliance** - Any specific compliance requirements? (CMK, BYOS, GDPR, FedRAMP, tenant isolation)
5. **Existing patterns to follow** - Does your team have established patterns for service communication, data access, or deployment that this architecture should match?
6. **Diagram preferences** - Any specific diagram types you want included? (ER diagrams, sequence diagrams, state machines, deployment topology)
7. **Depth on specific sections** - Any component that needs extra depth vs others that can stay high-level?

## Step 5: Generate the Draft

Generate the architecture document using the appropriate template from [the template reference](./references/architecture-template.md).

### Architecture Generation Rules

**Diagrams are mandatory.** Every architecture document must include Mermaid diagrams. At minimum:

- **HLD**: System context diagram + layered architecture diagram + at least one data flow or communication pattern diagram
- **LLD**: ER diagram + at least one sequence diagram showing the primary interaction flow + state diagram if the feature has lifecycle states
- **Combined**: All of the above

Use the Diagram Type Reference table in the template to pick the right diagram type for each concept.

**Simplicity over formalism.** Follow the Pragmatic Engineer principle: the architecture should be explainable on a whiteboard. Use plain boxes and arrows. Avoid UML formalism unless the PM requests it. Name components in plain language.

**Every decision needs an alternative.** The Alternatives Considered section must have at least one rejected option for each significant decision, with clear reasoning on what was gained and what was given up.

**Tradeoffs are explicit.** For every design choice, state the tradeoff. "We chose event-driven communication for inter-service updates because it reduces temporal coupling, at the cost of eventual consistency and more complex debugging."

**Ground in the source material.** Architecture decisions should trace back to requirements in the source document. If the strategy doc says "reduce time to migrate from 184 days to 75 days", the architecture should explain how each component contributes to that target.

**Match the team's voice.** Architecture docs in this workspace use a direct, technical voice. State facts and decisions, not possibilities. "The system uses Cosmos DB for OLTP" not "The system could potentially use Cosmos DB." Use the spec voice from the style guide: precise, definitive, concise.

### Source-Specific Guidelines

**From strategy doc (ground-up):**
- Start with the vision and challenges section from the strategy doc
- Map each strategic pillar or investment to architectural components
- Include customer journey flows as sequence diagrams
- Cover the full stack: experience layer, service layer, data layer, AI/ML layer if applicable
- Include an execution plan that maps architecture components to strategy phases
- Reference the your product AI Ready Architecture sample in `reference-examples/architecture/` for structure patterns

**From one-pager (extension):**
- Start by showing the existing system context, then highlight what's new
- Use color or labeling in diagrams to distinguish new components from existing ones
- Focus on integration points: how new components connect to existing services
- Cover data model changes (new tables, schema modifications)
- Reference the AutomaticApplicationDiscoveryToAccelerateMigrations sample for structure patterns

**From spec (incremental):**
- Start with the parent architecture reference
- Focus on data model (ER diagrams, table definitions), API contracts, and state management
- Include component-level design with function signatures and interaction flows
- Cover error handling, testing strategy, and tech debt
- Reference the Medicine Tracker architecture sample in `reference-examples/architecture/` for depth and structure patterns

For claims or design choices requiring PM judgment, mark them:

> **PM Decision Required:** <what needs deciding and why>

Present the complete draft in chat:

```
## DRAFT - Awaiting PM Approval
```

## Step 6: Save After Approval

Only after the PM approves, save to:

```
output/architecture-docs/<name-kebab-case>.md
```

After saving:
1. Run `scripts/humanizer-check.ps1 -Files "<saved-file-path>"` on the saved file. If violations are found, fix by rewording only (never delete sentences or content). Replace banned words with natural alternatives that preserve meaning. Re-run until clean.
2. Report where the file was saved
3. Report section count, word count, and diagram count
4. Report humanizer check result (passed, or list what was fixed)

## Architecture Writing Rules

These rules apply on top of the workspace Humanized Writing Standard:

### Voice
- Precise and definitive. Use "The system uses X" not "The system could use X."
- State tradeoffs directly. "This adds complexity but reduces latency" not "this approach has various considerations."
- No marketing language. "Cosmos DB stores tenant data with per-partition isolation" not "a world-class data platform provides enterprise-grade storage."
- Name technologies and patterns directly. Avoid vague references like "a suitable database" or "an appropriate messaging system."

### Diagrams
- Every diagram must have a text explanation below it. Diagrams supplement prose, they do not replace it.
- Use consistent naming between diagrams and text. If you call it "Discovery Service" in the text, label it "Discovery Service" in the diagram, not "SDS."
- Label arrows with what flows across them (data type, event name, API call), not just connection lines.
- Keep diagrams focused. One concept per diagram. Split complex systems across multiple diagrams rather than cramming everything into one.

### Structure
- Start concrete. Open with what the system does and the business problem, not a generic overview of the problem domain.
- Sections should build progressively: context first, then structure, then details, then decisions and risks.
- Tables for structured comparisons (alternatives, components, data stores). Prose for rationale and narrative.
- Code blocks for API schemas, configuration, and implementation examples - but only in LLD documents.

### Decision Documentation
- Every "why" needs a "why not." For each chosen approach, document at least one alternative considered and the reasoning for rejection.
- Separate facts from opinions. When you state a design decision, ground it in a constraint from the source material. When you make an inference, mark it as an assumption.
- Open questions are not failures. Catalog them with severity and owner. An architecture doc with honest open questions is stronger than one that papers over uncertainty.



### Optional: Deep Research

Before drafting, you can invoke the `@ideation-ghcp` agent for deeper market context, competitive intelligence, or trend analysis. It searches across Substack, Reddit, YouTube, competitor blogs, and analyst reports to surface insights relevant to this artifact. Ask the PM: `Want me to run deep research before drafting? I can explore the competitive landscape, market trends, or user pain points related to this topic.` Only invoke if the PM says yes.

## Checklist

Before presenting the draft, verify:

- [ ] All components diagrammed (Mermaid) with data flow and failure paths shown
- [ ] Alternatives documented with tradeoffs for every major design decision
- [ ] Security considerations addressed in each layer
- [ ] Style guide tonality: read [.github/style-guide.md](.github/style-guide.md) for precise technical author voice
- [ ] Draft shown in chat with `## DRAFT - Awaiting PM Approval` header before saving
- [ ] Humanized Writing Standard followed (no banned words, varied structure)

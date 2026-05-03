---
name: build-demo-script
description: "Write a demo script for product walkthroughs, conference talks, leadership reviews, or feature deep dives. Use when: demo script, demo, product demo, conference demo, Ignite demo, feature demo, LT demo, leadership demo, your executive reviewer demo, your CEO demo, YouTube script, product walkthrough, talk track, demo walkthrough, create demo script."
argument-hint: "Demo topic or feature name, or path to source document (spec, one-pager, docs, transcript)"
---

# Build Demo Script - Interactive Demo Script Builder

You are helping a PM write a demo script from source documents and direct inputs.

Follow the **PM-in-the-Loop Contract** and **Humanized Writing Standard** defined in the workspace instructions. Every draft must be shown in chat for PM approval before saving.

## Input Sources

This skill accepts:

1. **Specs** - feature specifications with acceptance criteria and user journeys
2. **One-pagers** - capability pitches with user scenarios and phasing
3. **Meeting transcripts** - discussions about what to demo, audience expectations, timing constraints
4. **Documentation** - product docs, user guides, your-docs-site.com pages
5. **Existing demo scripts** - to extend, update, or adapt for a different audience
6. **Freeform description** - the PM describes what they want to demo

Multiple sources can be combined.

## Step 1: Gather Inputs

Check if an input folder exists. If the PM provides a name (e.g., "ignite-migration-agent"), check for `input/demo-scripts/ignite-migration-agent/`. If the folder exists, scan all files. If non-markdown files exist (.docx, .xlsx, .csv, .html, .txt), run `scripts/translate-inputs.py input/demo-scripts/<name>/` to convert them first.

If no input folder exists, create one and tell the PM:

> I've created `input/demo-scripts/<name>/`. Drop your source files there (specs, one-pagers, docs, transcripts - any format), or paste content directly here.

Then ask what they're providing:

> **What source material do you have?** Pick all that apply:
>
> 1. Spec or feature document
> 2. One-pager or strategy doc
> 3. Meeting transcript (demo planning discussion)
> 4. Product documentation or user guide
> 5. Existing demo script to update or adapt
> 6. Freeform description (just tell me what to demo)

Read all provided documents. Extract: features to showcase, user journeys, product capabilities, competitive differentiators, customer pain points solved, and specific UI flows or screens mentioned.

## Step 2: Determine Demo Type

Ask the PM which demo type to produce:

> **What type of demo is this?**
>
> 1. **End-to-end product demo** (external) - Full product walkthrough for customers, partners, or YouTube. Covers the complete journey from problem to solution. Shows multiple capabilities connected. Typically 10-20 minutes.
> 2. **Feature deep dive** (external) - Focused walkthrough of a single feature or capability. Shows setup, usage, and outcomes in detail. Aimed at practitioners who want to learn how to use it. Typically 5-10 minutes.
> 3. **Leadership demo** (internal) - Demo for your executive reviewer, your CEO, CVP, or similar leadership review. Multiple presenters with handoffs. Emphasizes strategic customer impact, competitive wins, and business metrics. Tight, polished, no filler. Typically 5-15 minutes.
> 4. **Conference demo** (external) - For Ignite, Build, or similar conference sessions. Conversational narrative from a customer persona's point of view. Tells a story with the product as the tool that solves the problem. Typically 10-20 minutes.

Then ask:

> **Additional details:**
> 1. **Duration target** - How long should the demo run? (minutes)
> 2. **Audience** - Who specifically is watching? (customers, developers, IT pros, leadership, field sellers, partners)
> 3. **Key message** - What is the single most important thing the audience should take away?
> 4. **Customer scenario** - Is there a specific customer name or proxy scenario to use? (e.g., "Acme Corp (example) datacenter exit", "Example Corp VMware renewal")
> 5. **Multi-presenter?** - Is this a single presenter or are there handoffs between speakers?
> 6. **Live or recorded?** - Will this be performed live on stage, recorded as a video, or both?
> 7. **Environment** - What demo environment exists? (portal, CLI, agent chat, pre-configured tenant)

## Step 3: Extract Demo Beats

Read through the source material and extract the demo flow as a sequence of "beats" - the key moments in the demo where something happens on screen or a point is made to the audience.

Present the extracted beats:

```
## Proposed Demo Beats

| # | Beat | What happens on screen | Talk track theme | Duration |
|---|------|----------------------|-----------------|----------|
| 1 | <beat name> | <UI action or transition> | <what the presenter says about> | <est. seconds> |
| 2 | <beat name> | <action> | <theme> | <seconds> |
```

> **PM Decision Required:** Are these the right beats? Should any be added, removed, or reordered?

## Step 4: Generate the Draft

Generate the demo script using the format that matches the demo type. Reference the samples in `reference-examples/demo-scripts/` for voice and structure patterns.

### Format Rules by Demo Type

#### End-to-End Product Demo (YouTube / Customer)

Structure (from Appcentricity and YouTube 2024 samples):
- **Table of contents** at the top listing all sections
- **Introduction** - 2-3 sentences framing the product and the journey. No lengthy context setting.
- **Sections per journey stage** (e.g., Discovery, Business Case, Assessment, Migration) - each section is a mini-chapter
- **Within each section**: Talk track text describing what the presenter says and does. Intersperse with screenshot placeholders (`/` or `[Screenshot: <description>]`) showing what's on screen.
- **Conclusion** - Summary of key takeaways as a bulleted list. Keep it under 4 bullets.
- Use second person ("you") when addressing the audience directly. First person ("I") when narrating actions.

Voice: Friendly instructor showing the product. Confident but not salesy. Walk the audience through each action. "I can see that...", "Here your product is recommending...", "You can modify..."

#### Feature Deep Dive

Structure (from HA script and SQL Assessment samples):
- **Slide references** - `<Slide N>` markers for PowerPoint transitions
- **Pre-requisites section** listing what must be set up before the demo
- **Step-by-step numbered instructions** with bold action descriptions
- **Screenshot placeholders** after each significant step
- **Next steps section** at the end pointing to docs or related features
- **Multiple presenter handoffs** marked with `<Name>` tags if applicable

Voice: Technical practitioner guiding a peer. More detailed than end-to-end demos. Shows configuration details, edge cases, and specific UI elements. "Let me walk you through...", "You'll notice that...", "This is particularly useful when..."

#### Leadership Demo (your executive reviewer / your CEO)

Structure (from your executive reviewer and your CEO demo samples):
- **Numbered sections** matching the story arc (Introduction, Discovery, Business Case, Assessment, Migration)
- **Bold text for talk track** - the words the presenter says are in bold
- **Portal URLs or links** inline for the presenter to click during the demo
- **Screenshot images** embedded between talk track lines showing exactly what's on screen
- **Presenter handoff markers** - `Now let me handover to my colleague <Name> to present...`
- **Customer proof points** woven into the talk track - "Case in point, Northwind Corp has used your product to migrate over 15K machines..."
- **PPT transition markers** - `[PPT]` indicating when to switch to slides

Voice: Polished executive narrative. Every word counts. Lead with customer impact and competitive positioning. Show the product working, not how it works. "your product has been used by several strategic customers such as DataHealth Inc, Northwind Corp...", "This helps sellers make a strong case for your cloud platform."

#### Conference Demo (Ignite / Build)

Structure (from your AI assistant VMware Rehost Ignite sample):
- **Customer persona narrative** - the entire script is told from the customer's perspective. "I am a cloud architect at Example Corp. VMware license is up for renewal..."
- **Conversational turns** between the persona and the product (especially for agentic/copilot demos): persona states intent, product responds with recommendation, persona confirms or adjusts
- **Short paragraphs** - each beat is 1-3 sentences
- **Transition markers** for moving between product surfaces - `<Transition to portal>`
- **No screenshots** - just narrative flow (visuals are handled by the live demo or recorded screen)
- **Closing statement** tying the journey together - "Thanks to your cloud platform Copilot Migration agent, I quickly created and executed a reliable plan..."

Voice: Storyteller narrating a customer journey. Present tense. The audience should feel like they're watching the customer solve their problem in real time. "I want to move my servers...", "The agent has analyzed...", "I got a successful buy-in..."

### Common Rules (All Types)

- **Show the product working.** Every section must describe what's on screen. Never talk about a capability without showing it.
- **Lead with the "so what".** Before showing a feature, state why it matters. "To build confidence before committing resources..." then show the business case.
- **Use real-sounding numbers.** "$92,000 savings over 3 years", "45 workloads", "119 SQL Server instances" - never vague quantities.
- **Competitive context where natural.** "Without the need for deploying any agent" (vs. competitor approaches). Don't call out competitors by name in external demos unless the PM approves.
- **Time the script.** Estimate ~150 words per minute for spoken delivery. Flag if the script exceeds the target duration.
- **Mark all transition points.** Portal-to-slides, presenter handoffs, and surface switches must be explicitly marked.
- **Screenshot/screen placeholders.** Use `[Screenshot: <description>]` or `[Screen: <portal blade / CLI output / agent chat>]` to mark where visuals go. For leadership demos, include portal URLs if available.
- **No marketing superlatives.** Let the product speak. "Discovers 263 servers across VMware, Hyper-V, and bare metal" beats "provides industry-leading discovery capabilities."

### Appendix Section (Optional)

For leadership and conference demos, include an appendix with:
- **Tabs to open** - pre-staged browser tabs with portal URLs
- **Pre-requisites** - what must be configured in the demo environment before the session
- **Fallback plan** - what to do if a live demo step fails (pre-recorded backup, skip to next beat)
- **Timing breakdown** - estimated duration per section

Present the complete draft in chat:

```
## DRAFT - Awaiting PM Approval
```

## Step 5: Save After Approval

Only after the PM approves, save to:

```
output/demo-scripts/<name-kebab-case>.md
```

After saving:
1. Run `scripts/humanizer-check.ps1 -Files "<saved-file-path>"` on the saved file. If violations are found, fix by rewording only (never delete sentences or content). Replace banned words with natural alternatives that preserve meaning. Re-run until clean.
2. Report where the file was saved
3. Report estimated duration (word count / 150 words per minute)
4. Report humanizer check result (passed, or list what was fixed)




### Optional: Deep Research

Before drafting, you can invoke the `@ideation-claude` agent for deeper market context, competitive intelligence, or trend analysis. It searches across Substack, Reddit, YouTube, competitor blogs, and analyst reports to surface insights relevant to this artifact. Ask the PM: `Want me to run deep research before drafting? I can explore the competitive landscape, market trends, or user pain points related to this topic.` Only invoke if the PM says yes.

## Checklist

Before presenting the draft, verify:

- [ ] Every beat has a "what happens on screen" annotation
- [ ] Transitions between beats are smooth and motivated
- [ ] Timing per section adds up to target duration (word count / 150 WPM)
- [ ] Screenshot or recording placeholders present for key moments
- [ ] Fallback plan noted for live demo failures
- [ ] Draft shown in chat with `## DRAFT - Awaiting PM Approval` header before saving
- [ ] Humanized Writing Standard followed (no banned words, varied structure)

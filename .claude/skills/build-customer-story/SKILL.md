---
name: build-customer-story
description: "Write a customer story from meeting transcripts and PM inputs. Use when: customer story, case study, customer win, reference story, customer success story, customer testimonial, transcript to customer story, customer learnings, field learnings, customer engagement summary."
argument-hint: "Customer name, or path to transcript folder (e.g., input/customer-stories/acme-corp/)"
---

# Build Customer Story - Transcript-Based Customer Story Builder

You are helping a PM write a customer story from meeting transcripts and direct PM inputs. No other source types are accepted.

Follow the **PM-in-the-Loop Contract** and **Humanized Writing Standard** defined in the workspace instructions. Every draft must be shown in chat for PM approval before saving.

## Input Rules (Strict)

This skill accepts exactly two types of input:

1. **Meeting transcripts** - recordings, notes, or summaries from meetings with the customer or their representatives (specialists, field specialists, account teams, partners, technical advisors, consulting services, delivery services teams).
2. **PM inputs** - the PM's own knowledge provided directly in chat (context, clarifications, corrections, additional data points they know firsthand).

If the PM offers other source types (one-pagers, blogs, specs, web research, competitor docs, decks), respond:

> This skill builds customer stories exclusively from meeting transcripts and your direct inputs. Drop transcript files into the input folder, or paste transcript content here. For other source types, consider the `build-blog` or `build-one-pager` skill instead.

## Step 1: Gather Transcripts

Check if an input folder exists. If the PM provides a customer name (e.g., "acme-corp"), check for `input/customer-stories/acme-corp/`. If the folder exists, scan all files.

If non-markdown files exist, follow the **File Format Policy** in `CLAUDE.md`. The policy handles MCP-direct ingestion when an Office MCP is registered, auto-conversion via `scripts/translate-inputs.py input/customer-stories/<customer-name>/` as the fallback, and the FYI nudge that points unaware users at the optional MCPs. Then read all `.md` and `.txt` files.

If no input folder exists, create one and tell the PM:

> I've created `input/customer-stories/<customer-name>/`. Drop your meeting transcripts there (any format - .docx, .txt, .md), or paste transcript content directly here.

If the PM pastes transcript content in chat, that counts as valid input. Proceed with what's available.

## Step 2: Choose Output Format

After reading the transcripts, ask the PM which format to produce:

> **Which format should this customer story use?**
>
> 1. **Internal customer learnings** (default) - Issues, learnings, action items with owners and ETAs. Used in strategy reviews and leadership presentations. *(Matches the Global Motors, Apex Consulting, TelcoNet format in `reference-examples/customer-stories/`.)*
> 2. **Public case study** - Challenge, solution, results with customer quotes. For your company blog, your product blog, or partner channels.

If the PM does not specify, default to **Format A (internal customer learnings)**.

## Step 3: Extract Facts from Transcripts

Read through all transcript content and extract:

- **Customer identity**: Company name, industry, size, geography, partnership context
- **Scale numbers**: Server count, application count, datacenter count, regions, timelines, dollar amounts
- **Pain points**: What problems did the customer describe? What tools failed them? What took too long?
- **Speaker roles**: Identify who said what - customer vs. your company specialist vs. field specialist vs. partner vs. PM
- **Direct quotes**: Capture verbatim quotes with speaker attribution
- **Products and tools mentioned**: your product, competitor tools, third-party tools, internal tools
- **Outcomes and metrics**: What worked, what improved, measurable results
- **Competitive context**: Any mentions of [Competitor 1], [Competitor 2], or third-party alternatives
- **Action items discussed**: What follow-ups were agreed on, with owners and timelines if mentioned
- **Customer sentiment**: Positive feedback, concerns, feature requests

Present the extracted facts in chat as a structured summary:

```
## Extracted Facts from Transcripts

**Customer:** <name, industry, scale>

**Pain Points Identified:**
1. <pain point with source quote>
2. <pain point>

**Learnings / Insights:**
1. <learning>
2. <learning>

**Quotes Captured:**
- "<quote>" - <speaker, role>
- "<quote>" - <speaker, role>

**Metrics / Numbers:**
- <metric with source>

**Action Items Mentioned:**
- <action, owner if named, ETA if mentioned>

**Gaps (information not in transcripts):**
- <what's missing that the PM may need to fill in>
```

For every gap, use:

> **PM Decision Required:** <what's missing and why it matters for the story>

For every inference you made from ambiguous transcript content, use:

> **Assumption:** <what you inferred and from which part of the transcript>

## Step 4: Ask Clarifying Questions

After presenting extracted facts, ask follow-up questions. Skip any the transcripts already answer:

**Common to both formats:**

1. **Audience** - Who will read this? (leadership, field team, partner, public)
2. **Sensitivity** - Any NDA restrictions? Should we anonymize the customer name or specific details?
3. **Quote attribution** - Which quotes can be attributed by name and title? Any that need to stay anonymous?
4. **Missing metrics** - Are there numbers you know that weren't in the transcript? (timeline savings, cost reduction, server counts)
5. **Corrections** - Anything in the transcript that's outdated or inaccurate that you want to correct?

**Format A (internal learnings) - additional questions:**

6. **Action item owners** - For action items without named owners in the transcript, who should own each?
7. **ETAs** - For action items without timelines, what are the target dates?
8. **Compete context** - Should we add compete perspectives to the learnings? Do you have compete intel not in the transcript?

**Format B (public case study) - additional questions:**

6. **Hero metric** - What's the single most impressive number from this engagement?
7. **Headline quote** - Which customer quote should be the pull-quote?
8. **Products to feature** - Which your company products and features should be named?
9. **Publication target** - Where will this be published? (your company blog, your product blog, LinkedIn, partner channel)

## Step 5: Generate the Draft

Generate the customer story using the appropriate format from [the template](./references/customer-story-template.md).

### Format A - Internal Customer Learnings

Match the voice and structure from the team's existing customer stories (Global Motors, Apex Consulting, TelcoNet in `reference-examples/customer-stories/`):

- **Customer context paragraph**: Dense with facts - company name, scale, partnership context, project scope. Every number from the transcript.
- **Issues & pain points**: Numbered, each with a bold descriptive title and 1-2 detail paragraphs. Name specific tools, timelines, teams. Use the customer's framing where possible.
- **Learnings**: Numbered, each with a bold title. Tie each learning to a product insight (gap, strength, or behavior pattern). Include "Compete perspective:" sub-bullets where the transcript mentions competitors.
- **Action items**: Numbered with owner name and ETA. Keep the format tight: description + owner + date.
- **Customer status / testimonial**: Direct quotes or paraphrased feedback with speaker attribution.

Voice: Factual, internal-audience, concise. Write as a PM documenting learnings for the team. No marketing language. State problems directly. Name tools and competitors without hedging.

### Format B - Public Case Study

Match the blog-adjacent voice from the style guide:

- **Title**: Customer + action verb + outcome + with + your company product
- **Customer profile table**: Company, industry, size, region, products used
- **Challenge**: Business problem first, then technology. Specific scale and timeline. Customer quote.
- **Solution**: Chronological journey. Name features and approaches. What did the customer experience?
- **Results**: Numbered metrics with business context. Customer quote on outcomes.
- **What's next**: Grounded in transcript, not aspirational marketing.

Voice: Confident narrator telling the customer's story. Third person for the customer, occasional "we" for your company. Let the customer's own words carry the emotional weight through quotes.

### Hard Rules (Both Formats)

- **Never fabricate quotes.** Every quote must come verbatim or near-verbatim from a transcript. If you paraphrase, mark it as paraphrased and attribute the speaker.
- **Never invent metrics.** If a number is not in the transcript or provided by the PM, do not make one up. Flag it with `> **PM Decision Required:** <what metric is needed and where it would go>`.
- **Never add web research.** This skill works from transcripts and PM inputs only.
- **Anonymize on request.** If the PM requests anonymization, replace the company name with a descriptor ("a global financial services firm") and remove identifying details.
- **Attribute every insight.** Tie each pain point, learning, and quote back to a specific speaker role (customer, field specialist, specialist, partner, account team).

Present the complete draft in chat:

```
## DRAFT - Awaiting PM Approval
```

## Step 6: Save After Approval

Only after the PM approves, save to:

```
output/customer-stories/<customer-kebab-case>.md
```

After saving:
1. Run `scripts/humanizer-check.ps1 -Files "<saved-file-path>"` on the saved file. If violations are found, fix by rewording only (never delete sentences or content). Replace banned words with natural alternatives that preserve meaning. Re-run until clean.
2. Report where the file was saved
3. Report word count
4. Report humanizer check result (passed, or list what was fixed)




### Optional: Deep Research

Before drafting, you can invoke the `@ideation-claude` agent for deeper market context, competitive intelligence, or trend analysis. It searches across Substack, Reddit, YouTube, competitor blogs, and analyst reports to surface insights relevant to this artifact. Ask the PM: `Want me to run deep research before drafting? I can explore the competitive landscape, market trends, or user pain points related to this topic.` Only invoke if the PM says yes.

## Checklist

Before presenting the draft, verify:

- [ ] Every quote attributed to a specific speaker from the transcript
- [ ] No fabricated metrics or statistics
- [ ] Anonymization applied if PM requested it
- [ ] Narrative arc present (challenge, journey, outcome)
- [ ] Customer email summaries and support ticket summaries accepted as input alongside transcripts
- [ ] Draft shown in chat with `## DRAFT - Awaiting PM Approval` header before saving
- [ ] Humanized Writing Standard followed (no banned words, varied structure)

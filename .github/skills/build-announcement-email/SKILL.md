---
name: build-announcement-email
description: "Draft an announcement email for product launches, previews, breaking changes, product updates, or stakeholder enablement. Use when: announcement email, email announcement, feature launch email, GA email, preview email, deprecation email, breaking change email, product update email, newsletter email, field enablement email, partner email, stakeholder email."
argument-hint: "Email topic, audience, or path to source document (spec, one-pager, release notes, etc.)"
---

# Build Announcement Email - Interactive Email Drafting Skill

You are a PM communications writer helping draft announcement emails for the your product team.

Follow the **PM-in-the-Loop Contract** and **Humanized Writing Standard** defined in the workspace instructions. Every draft must be shown in chat for PM approval before saving.

---

## When to Use

Use this skill when a PM needs to write any of these:
- Feature launch or GA announcement to customers, field, or partners
- Preview or private preview invitation
- Breaking change or deprecation notice
- Monthly product update or newsletter
- Internal stakeholder announcement (leadership, partner teams, engineering)
- Partner or field team enablement email (account executives, solution architects)

---

## Step 1: Understand the Intent

Start by understanding what the PM wants to announce and who should receive it. Ask these two questions first:

> 1. **What are you announcing?** (feature GA, preview launch, deprecation, product update, internal milestone, field enablement, or describe it)
> 2. **Who is the audience?** (customers, field/sellers, partners, internal leadership, cross-team engineering, or mixed)

If the PM already stated both in their initial message, skip to Step 2.

---

## Step 2: Offer Source Material Intake

Before building structure, ask if the PM has source material that can provide context on the feature:

> **Do you have any source material I can use to build context on this feature?** This helps me draft accurate, specific content instead of placeholders. I can work with:
>
> - Specs, one-pagers, or design docs
> - Release notes or changelogs
> - Blog post drafts or published blogs
> - Customer-facing documentation or URLs
> - Previous announcement emails on this topic
> - Presentation decks or demo notes
> - Freeform notes (paste anything relevant)
>
> You can paste content here, share file paths, drop files in `input/emails/<topic-name>/`, or share URLs. If you don't have material handy, I'll ask you targeted questions to build context as we go.

**Note on authenticated URLs:** SharePoint and other authenticated URLs cannot be fetched directly. If the PM shares these, ask them to download the files and drop them in `input/emails/<topic-name>/`, or paste the content into chat.

If the PM provides material:
- Check `input/emails/<topic-name>/` for files. If non-markdown files exist (.docx, .xlsx, .csv, .html, .json), run `scripts/translate-inputs.py input/emails/<topic-name>/` to convert them.
- Read all provided documents, files, or URLs.
- Extract: key capabilities, timelines, audience signals, customer impact, required actions, links, metrics, team contributors.

After reading source material, confirm product names before proceeding:

> **Please confirm the exact product names** for any your cloud platform services, features, or tools mentioned in this email. Product names change (e.g., your NoSQL service for MongoDB was renamed to your document database), and I want to use the current names throughout.

If the PM says they don't have material, proceed to Step 3 and gather context through questions. Still ask the product name confirmation question at the start of Step 3.

---

## Step 3: Generate a Custom Email Structure

Based on the email type, audience, and any source material, generate a proposed section outline tailored to this specific email. Do NOT use a fixed template. Build the structure dynamically based on what makes sense for this announcement.

Present the proposed outline to the PM as a numbered section list:

> **Here is the structure I recommend for this email:**
>
> 1. **Subject line**
> 2. **Opening** - [describe what this section will cover]
> 3. **[Section name]** - [describe purpose]
> 4. **[Section name]** - [describe purpose]
> ... (as many sections as needed)
> N. **Signature block**
>
> **For each section, would you like to:**
> - **(a) Write it yourself** - you provide the content and I'll format it to fit the email
> - **(b) Have me draft it** - I'll ask you targeted questions to get the details I need, then draft it for you
> - **(c) Mix** - tell me which sections you'll write and which I should draft
>
> You can also add, remove, or reorder sections.

**Section selection guidance** - Use the intent, audience, and source material to pick the right sections. Below is the section catalog. Not every email needs every section. Pick only what fits.

### Section Catalog

**Core sections (almost always included):**
- **Subject line** - Clear, specific, includes product name and action type
- **Opening paragraph** - The headline news in 1-2 sentences
- **Key capabilities / What's new** - What the reader can do now (bullets or numbered list)
- **Call-to-action** - What the reader should do next
- **Resources / Links** - Docs, blog, portal, demo links
- **Signature block** - Sender name and role

**Situational sections (include based on email type and PM answers):**
- **Value proposition** - Why this matters for the reader's scenario (good for preview and field emails)
- **Traction / Impact metrics** - Numbers from prior phase: customer count, VMs migrated, CSAT, latency (good for GA and stakeholder emails)
- **Customer validation** - Named customer scenarios, partner quotes, seller quotes (requires PM approval for every name)
- **Timeline / Key dates** - GA date, deprecation date, migration deadline, preview window (required for breaking changes; useful for previews)
- **Required action** - What the reader MUST do and by when (required for breaking changes and deprecations)
- **Migration path / Alternative** - What replaces the deprecated thing (required for breaking changes)
- **How to sign up / Get started** - Steps to opt in or try the feature (good for previews)
- **Known limitations** - What the preview does not yet support (good for previews)
- **Successes and Opportunities** - Balanced framing of wins and gaps (good for leadership emails)
- **What's Next / Roadmap** - 2-4 upcoming items that signal momentum (good for GA and cross-team emails)
- **Help us spread the word** - Amplification ask with blog, LinkedIn, video, docs links (good for GA)
- **Acknowledgements / Credits** - Team recognition grouped by role (standard for cross-team and v-team emails)
- **Talking points** - Customer-facing sound bites the field team can reuse directly (good for enablement emails)
- **Common customer questions** - FAQ format, 2-4 items (good for enablement and customer emails)
- **Demo / Video** - Link to demo recording or walkthrough (include when available)

**Reference prior announcements:** Check `reference-examples/emails/` and `reference-examples/emails/extracted/` for prior announcement emails. If any cover a similar topic or audience (e.g., a PostgreSQL preview email when writing a MongoDB preview email), offer to use it as a structural reference:

> I found prior announcement emails that may be useful as a structural reference: [list matching emails]. Want me to use any of these to guide the tone and structure?

**Confirm key terminology:** For technical emails (preview launches, assessments, migration features), ask the PM to confirm terminology that will appear throughout the email:

> **Are there specific technical terms I should use?** For example, readiness categories (Ready, Conditionally Ready vs. Ready with Conditions), migration path names, or assessment property labels. I want to match what customers and engineers will see in the product.

Wait for the PM to confirm the structure and their preference (write themselves vs. agent-drafted vs. mix) before proceeding.

---

## Step 4: Build Each Section

Work through the confirmed sections in order. For each section:

**If the PM chose to write it themselves (option a):**
- Ask them to provide the content for that section
- Format and fit it to the email voice and structure
- Flag any issues (too long, missing details, tone mismatch) as suggestions, not blockers

**If the PM chose agent-drafted (option b):**
- Ask targeted questions to gather just enough context for that section. Be specific about what you need. Examples:
  - For **Key capabilities**: "What are the 3-4 headline features? Give me a one-liner on each."
  - For **Metrics**: "Do you have numbers from preview? Customer count, usage, CSAT, anything quantifiable?"
  - For **Customer validation**: "Any customer or partner names I can reference? Any quotes from sellers or architects?"
  - For **Credits**: "Which teams contributed? I need names grouped by role (engineering, PM, UX, docs, marketing, leadership)."
  - For **Roadmap**: "What are the 2-3 things coming next after this launch?"
- If the source material already answers a question, draft the section from that context and show it to the PM for confirmation instead of re-asking.
- Draft the section and show it inline. The PM confirms, edits, or rejects before you move to the next section.

**If the PM provides a mix:**
- Follow option (a) for sections they write and option (b) for sections they want drafted. Track which is which.

**Offer alternatives for high-visibility sentences.** For the subject line, opening sentence, and closing sentence of key sections, present 2-3 options instead of a single draft. These are the lines readers notice most, and giving the PM choices produces better results than a single take-it-or-leave-it draft.

After each section is confirmed, move to the next one. Do not draft the full email in one shot unless the PM explicitly asks for that.

---

## Step 5: Assemble and Present the Full Draft

Once all sections are confirmed individually, assemble the complete email and present it:

```
## DRAFT - Awaiting PM Approval
```

Before presenting, run through the writing rules below and fix any violations.

**Email writing rules (apply on top of the Humanized Writing Standard):**

### Subject Line
- Clear and specific. The reader should know the purpose without opening the email.
- Include the product name and action type. "your product: PostgreSQL Assessment now generally available" not "Exciting news from the team!"
- Under 60 characters if possible. Under 80 maximum.
- No ALL CAPS words (exception: `[ANNOUNCEMENT]` tag is acceptable). No exclamation marks in the subject line.
- **Emoji in subject lines:** Allowed for internal team and cross-team emails (ðŸ“¢, ðŸŽ‰, ðŸš€ are common on this team). Avoid emoji in customer-facing or formal leadership-to-board emails.

### Structure
- **5-8 paragraphs** with clear visual breaks. No walls of text.
- **Bold the first sentence** of each key section to support scanning.
- Use **short paragraphs** (2-3 sentences each). Mix lengths for rhythm.
- **Bullet lists** for capabilities, required actions, and links. Numbered lists for sequential steps.
- **One call-to-action** that stands out. Bold it or put it on its own line. If there are multiple actions, prioritize one as primary.

### Voice
- Write for someone who has 30 seconds to scan. Lead every paragraph with its point.
- Be specific. "Assess PostgreSQL instances for migration to your managed database service" not "assess your database workloads."
- **Team announcement voice:** "We are thrilled/excited/pleased to announce..." is this team's standard opening for milestone emails. Use it for cross-team and v-team announcements. For customer-facing emails, prefer the reader's perspective: "You can now..." or "Your team can now..."
- Avoid generic filler openings. No "I hope this email finds you well" or "I wanted to reach out to share..." Start with the news or the team opening.
- Contractions are fine for field and customer emails. Avoid them for formal leadership communications.
- No marketing superlatives. Let the capability speak for itself.
- **Celebratory but grounded.** Team emails can be warm and appreciative ("A heartfelt thank you to everyone who contributed"). Keep it authentic, not corporate.

### Audience-Specific Adjustments
- **Customers:** Focus on what they can do and why it helps them. Link to docs and portal.
- **Field teams:** Focus on what to tell customers and how to demo. Include talking points and collateral links.
- **Internal leadership:** Focus on business impact, metrics, and strategic relevance. Include customer/revenue context.
- **Partners:** Focus on joint value and enablement materials. Include co-sell or marketplace context if relevant.

### Formatting
- No em dashes. Use commas, periods, or parentheses.
- No colored text or excessive formatting (emails render differently across clients).
- Links should be descriptive. "[View the PostgreSQL assessment documentation](url)" not "[click here](url)."
- Emoji section headers (ðŸ’¡, ðŸ“£, ðŸ™) are acceptable in internal team emails to break up long announcements.

For claims, positioning, dates, or distribution decisions that require PM judgment, mark them:

```
> **PM Decision Required:** <what needs deciding and why>
```

For information you filled in from context but could not verify, mark it:

```
> **Assumption:** <what was assumed and why>
```

---

## Step 6: Save After Approval

Only after the PM approves the assembled draft, save to:

```
output/emails/<title-kebab-case>.md
```

After saving:
1. Run `scripts/humanizer-check.ps1 -Files "<saved-file-path>"` on the saved file. If violations are found, fix by rewording only (never delete sentences or content). Replace banned words with natural alternatives that preserve meaning. Re-run until clean.
2. Ask the PM: **"Would you also like a Word document (.docx) version?"** Emails are often pasted into Outlook, and a .docx makes that easier. If yes, convert the markdown to .docx using the `scripts/md_to_docx.py` conversion approach or `pandoc` if available, and save alongside the .md file.
3. Report where the file(s) were saved
4. Report word count
5. Report humanizer check result (passed, or list what was fixed)
6. List any remaining `PM Decision Required` items that still need resolution

---

## Step 7: Gather Feedback and Improve the Skill

After the email is saved and delivered, ask the PM for feedback on the drafting process:

> **Quick feedback to improve this skill for next time:**
>
> 1. What worked well in this session?
> 2. What was frustrating or took too many rounds to get right?
> 3. Were there questions I should have asked earlier (or skipped entirely)?
> 4. Any terminology, formatting, or structural preferences I should remember for future emails?

Based on the PM's answers, identify concrete improvements to the skill. Present them as a numbered list with a brief description of what would change:

> **Based on your feedback, here are improvements I can make to the skill:**
>
> 1. [Improvement description]
> 2. [Improvement description]
> ...
>
> **Which of these would you like me to incorporate?** (all, a subset by number, or none)

Only after the PM confirms which improvements to apply:
- Edit this SKILL.md file to incorporate the approved changes
- Run `scripts/humanizer-check.ps1 -Files "<skill-file-path>"` on the updated SKILL.md
- Report what was changed and where in the skill

Do not update the skill without PM approval. If the PM declines or says "none," skip this step.

---



### Optional: Deep Research

Before drafting, you can invoke the `@ideation-ghcp` agent for deeper market context, competitive intelligence, or trend analysis. It searches across Substack, Reddit, YouTube, competitor blogs, and analyst reports to surface insights relevant to this artifact. Ask the PM: `Want me to run deep research before drafting? I can explore the competitive landscape, market trends, or user pain points related to this topic.` Only invoke if the PM says yes.

## Checklist

Run this checklist on the assembled draft before presenting to the PM:

- [ ] Subject line is clear, specific, under 80 characters, and contains the product name
- [ ] Email type matches what the PM asked for (launch, preview, breaking change, update, internal, enablement)
- [ ] Audience is correct and tone matches (formal for leadership, conversational for field, direct for customers)
- [ ] The single most important message is in the first paragraph
- [ ] Required actions are clearly stated and easy to find (bolded or bulleted)
- [ ] All dates and timelines are included and accurate
- [ ] Links are descriptive and functional (no "click here")
- [ ] No em dashes anywhere
- [ ] No banned words or phrases from the Humanized Writing Standard
- [ ] No generic filler openings ("I hope this finds you well", "I wanted to reach out"). Team openings like "We are thrilled to announce" are allowed.
- [ ] No marketing superlatives ("best-in-class", "industry-leading")
- [ ] Paragraphs vary in length (not all the same size)
- [ ] One clear primary call-to-action
- [ ] PM Decision Required markers on all unverified claims, dates, customer names, or distribution decisions
- [ ] Assumption markers on all filled-in information
- [ ] Every section was individually confirmed by the PM before assembly

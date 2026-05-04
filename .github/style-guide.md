# Writing Style Guide - Skill-Specific Tonality

This guide defines the writing voice and tone for each document type produced by PM skills. Every skill must follow the tonality rules for its document type, in addition to the Humanized Writing Standard.

The patterns below are extracted from real team-authored samples. Match them.

---

## Blog Posts

**Voice:** Authoritative product narrator. You are writing on behalf of the team that built the product. Speak directly to the reader about what the product does and why it matters.

**Tone characteristics:**
- Confident and direct. State capabilities as facts, not possibilities. "[Your Product] facilitates agentless discovery" not "[Your Product] can help facilitate discovery."
- Product-proud without being promotional. Let capabilities and specifics do the selling. Never use superlatives like "best-in-class" or "industry-leading."
- Conversational but professional. Use contractions where natural ("you'll", "it's", "don't"). Avoid stiff corporate phrasing.
- First person plural ("we") for the product team. Direct "you" for the reader.

**Structure patterns (from samples):**
- Open with the problem or context in 2-3 sentences. No "In this blog post, we'll explore..." preamble.
- Bold subheadings that describe a capability or benefit, not generic labels. "Confidence before you move: Quick Insights without exposure" not "Feature 1: Discovery."
- Short paragraphs (2-4 sentences). Mix paragraph lengths. Never make every paragraph the same size.
- Numbered lists for capabilities or steps when there are 3+ items. Inline prose for 1-2 items.
- Customer quotes as blockquotes with attribution when available.
- Close with a "Get started today" section containing 2-5 concrete next steps with links.

**What to avoid:**
- Starting the post with a generic overview of cloud migration or digital transformation.
- Describing features abstractly. Always ground capabilities in what the user sees or does.
- Ending paragraphs with vague forward-looking statements like "and much more."

**Example sentence patterns from team blogs:**
- "Within hours, business leaders receive actionable recommendations based on real environmental data, enabling confident decisions."
- "The agent coordinates handoffs between infrastructure, database, application, and security teams, keeping humans involved throughout the process."
- "These enhancements in your product underscore our commitment to providing comprehensive, user-friendly, and efficient migration solutions."

---

## Product Specifications

**Voice:** Precise technical author. You are writing for developers and QA engineers who will build and test from this document. Clarity beats elegance.

**Tone characteristics:**
- Definitive. Use "must", "does", "is". Never "should" or "might" in acceptance criteria.
- Concise. Each sentence carries one fact or one requirement. Compound sentences are fine for context, but acceptance criteria are atomic.
- Human. Personas speak in quotes. Vision statements describe real pain points with empathy. "People forget doses, run out of medicines unexpectedly, and lose track of which family member takes what."
- Technical where needed, plain where possible. "SQLite uses WAL mode by default" is fine. "The paradigm of persistence guarantees eventual consistency" is not.

**Structure patterns (from samples):**
- Document control table at the top with version, date, author, changes.
- Product vision starts with a problem statement grounded in real user frustration, not market analysis.
- Personas use attribute tables with a closing quote. Each persona feels like a real person.
- Feature inventory as a table with ID, name, phase, status, priority, personas.
- Acceptance criteria use checkbox format: `- [ ] <When X, then Y>` or `- [ ] <Component does Z>`.
- User stories follow: "As a [persona], I can [specific action] so that [measurable benefit]."
- Mermaid diagrams for user journeys using `graph LR`.
- NFRs organized into tables with metric and target columns.

**What to avoid:**
- Vague acceptance criteria. "System responds quickly" is wrong. "Response time under 200ms" is right.
- Placeholder text or TBD entries. Make reasonable assumptions and mark them with `> **Assumption:**`.
- Marketing language in a spec. No "next-generation" or "world-class."
- Passive voice in acceptance criteria. "Data is saved" should be "Tapping Save writes the record to SQLite."

**Example patterns from team specs:**
- "Managing multiple prescriptions for a family is complex and error-prone."
- "Name and dosage are required fields; form shows alert if either is empty on save."
- "Archived medicines (`is_active = 0`) disappear from the list but remain in the database."

---

## One-Pagers

**Voice:** Strategic PM pitching to leadership and partner teams. You are making the case for why this work matters and how it will be executed.

**Tone characteristics:**
- Business-oriented. Lead with the problem size, customer impact, and competitive pressure. Numbers and data points carry weight.
- Direct and structured. Busy stakeholders skim. Put the conclusion first, supporting detail second.
- Specific about scope. State what is in and what is out. Name phase boundaries, priority labels (P0/P1/P2), and sequencing.
- Factual claims backed by data. "40% of tenants migrating databases using native tooling had also discovered their SQL Server instances through your product." Not "many customers use your product for database discovery."

**Structure patterns (from samples):**
- Document history table (date, type, author) and review history.
- Introduction paragraph that frames the problem with a concrete metric or timeline. "Network design and planning during migration remains a major bottleneck, often taking 3-6 months."
- Problem section with numbered pain points, each titled with a bold summary.
- Approach section describing the solution direction with numbered principles.
- User scenarios table with columns for scenario description and priority/phase breakdown.
- Phase breakdown using named stages (Crawl/Walk/Run or P0/P1/P2) with scope per phase.
- Real customer examples with names and timelines when available.
- Competitive context woven into pain points and approach, not in a separate section.

**What to avoid:**
- Abstract problem statements without numbers. "Customers struggle with network planning" needs a timeline or percentage.
- Overlong introductions. Get to the problem in 2-3 sentences.
- Missing scope boundaries. Every capability must map to a phase and priority level.
- Proposing solutions without tying them to a specific user pain point.

**Example patterns from team one-pagers:**
- "Our objective is to cut network planning time by ~50% and increase post-migration satisfaction."
- "A large airline customer required ~2 months of requirement gathering and another 2 months of design work to plan their target platform integration."
- "As a user, I can discover all my on-premises network assets and dependencies in a few clicks."

---

## User Guides

**Voice:** Friendly instructor sitting next to the reader. You are showing someone how to use the product, not explaining how it was built.

**Tone characteristics:**
- Warm and direct. Use "you" and "your" throughout. "When you open the app for the first time, you will see the Sign In screen."
- Encouraging. Assume the reader is smart but new. "Well done!" after completing a flow is fine. Never condescending.
- Present tense. "The app fills in the Name, Dosage, Instructions, and Doctor fields automatically." Not "The app will fill in..."
- Action-oriented. Every section tells the reader what to do, not what the feature is.

**Structure patterns (from samples):**
- Welcome sentence and table of contents with anchor links at the top.
- "Getting Started" section covers first launch, login, and privacy reassurance.
- Core task sections named as actions: "Adding a Medicine", "Tracking Your Daily Doses", not "Medicine Module" or "Dose Tracking Feature."
- Numbered steps for sequential actions. Bullets for non-sequential options.
- Tables for comparing options (e.g., frequency types, time groups).
- "Tip:", "Important:", and "Note:" blockquotes for callouts.
- Bold formatting for every UI element: **Save**, **Settings**, **Add New**.
- Error handling covered inline with troubleshooting bullets under each feature.
- FAQ section at the end for common questions.

**What to avoid:**
- Describing internal implementation. The reader does not need to know about SQLite or API endpoints.
- Passive instructions. "The Save button should be tapped" should be "Tap **Save**."
- Walls of text without action steps. Every section needs numbered instructions or clear decision points.
- Assuming prior knowledge of the product. Define terms on first use.

**Example patterns from team user guides:**
- "Tap the green **Take** button on a dose card. The card turns green with a checkmark, and one unit is automatically deducted from your stock count."
- "Tap **Sign In** - a secure browser window opens where you can log in with your email and password, or with your Google account."
- "If the scan fails: 'Could not connect' - check your internet connection and try again."

---

## Strategy Documents

**Voice:** Executive narrator presenting to senior leadership. You are making the case for where the product stands, where it is going, and what it will take to get there. The document must answer reviewer questions before they are asked.

**Tone characteristics:**
- Data-driven and specific. Every claim about customer pain, market position, or adoption cites a number, percentage, or timeline. "89% of churned customers had little or no product usage" not "many customers churn."
- Narrative-driven. The document tells a story with a clear arc - current position, strategic tension, planned investments, target outcome. Sections advance the arc rather than catalog features.
- Confident but honest. Acknowledge gaps and competitive disadvantages directly. "[Competitor] leads with single-click orchestration" is stronger than pretending the gap does not exist.
- Preemptive. Inline Q&A answers questions before reviewers ask them. Customer insights appear before investment descriptions to establish "why." Compete insights appear alongside plans to address "what about the competition?"

**Structure patterns (from samples):**
- Executive summary compresses the full story into one page with headline KPIs.
- Strategic pillars (3-5), each with: goal statement, customer insights (named accounts, bold company names), compete insights (comparison tables with `[+]`/`[-]`/`[=]` indicators), plan (investments with specific timelines).
- Customer stories use the three-part structure: Issue/Pain Point, What did you learn?, Action Plan (table with Description and Milestone columns).
- Compete perspective woven inline within each pillar and customer story, not isolated in a separate section.
- "Request from Leadership:" tags for explicit leadership asks.
- Key Results table with KPI, Comments, Baseline/Target columns.
- Appendix for detailed compete scorecards, roadmaps, execution matrices, and glossary.

**What to avoid:**
- Feature catalogs disguised as strategy. Every investment must tie to a customer outcome and a business metric, not just describe what the feature does.
- Unsupported claims. "Customers struggle with migration" needs a P75/P90 metric, a named customer, or a survey data point.
- Repeating context across pillars. Each pillar is self-contained. If Pillar 2 needs background from Pillar 1, reference it rather than restating it.
- Starting with market analysis or industry overview. Start with the product's current position and the strategic tension that drives the investments.
- Aspirational compete positioning. State facts: "[Competitor] provides X. [Your Product] does not yet provide Y. By [target date], we will close this gap."

**Example patterns from team strategy docs:**
- "P75 Time to Migrate from 184 (FY25) to 75 days. The SA and field lead P75 KPI data across strategic accounts show friction clusters in two distinct phases."
- "**A large enterprise customer** discovered 23,000+ servers (92% Linux) with rapid execution (Collect Data 9 days, Prepare Assessment 6 days)."
- "[-] [Competitor] enables high speed discovery and allows customers to bring their own data (via CMDBs, third-party tools)."
- "[+] [Your Product] provides a self-serve ROI/TCO calculator across infrastructure, data, and web apps."
- "The [Region] [Product] GTM motion generated $<X> in new [product] revenue from <N> customers."

---

## General Rules (All Document Types)

These apply across every skill, in addition to the document-specific tonality above:

1. **Match the sample voice.** When generating any document, match the tone from the corresponding sample type. Blog tone for blogs. Spec tone for specs. Do not mix them.
2. **Ground claims in specifics.** Replace "fast" with a number. Replace "many customers" with a percentage or count. Replace "easy to use" with what the user actually does.
3. **Vary paragraph length.** Short paragraphs (1-2 sentences) for emphasis. Medium (3-4 sentences) for explanation. Never uniform.
4. **Use contractions in blogs and user guides.** Don't, won't, can't, it's. Avoid them in specs and one-pagers where precision matters.
5. **No throat-clearing openings.** Never start with "In today's rapidly evolving landscape..." or similar filler. Start with the problem, the capability, or the instruction.
6. **Show the product working.** For any capability mention, describe what the user sees or does. "You click Accelerate Migration and the agent begins discovery" not "the capability provides discovery functionality."

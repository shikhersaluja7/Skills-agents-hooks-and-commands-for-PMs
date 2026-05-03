# PM Skills - Workspace Instructions

These instructions apply to every skill, command, agent, hook, and workflow in this workspace. They are loaded automatically by GitHub Copilot (via `.github/copilot-instructions.md`) and Claude (via `CLAUDE.md`).

---

## PM-in-the-Loop Contract

Every skill in this workspace follows the PM-in-the-Loop principle:

1. **The PM decides.** The agent ideates, researches, and drafts. The PM makes all final decisions. Nothing is saved to a file until the PM explicitly approves.
2. **Decision points are flagged.** When the agent needs PM judgment (priority, wording, scope, strategy), it marks the spot with `> **PM Decision Required:** <what needs deciding and why>`.
3. **Assumptions are marked.** When the agent fills in missing information, it marks it with `> **Assumption:** <what was assumed and why>`.
4. **Research is opt-in.** The agent offers to research competitors, market context, or best practices. The PM decides what to include. Never auto-include research findings.
5. **Drafts are shown in chat first.** The agent shows the full draft in chat with a `## DRAFT - Awaiting PM Approval` header. Only after the PM approves does the agent save the file.

---

## Humanized Writing Standard

All generated content must follow these rules to eliminate AI-sounding patterns.

### Banned Words
Never use: delve, leverage, utilize, robust, seamless, cutting-edge, holistic, synergy, paradigm shift, unprecedented, game-changing, groundbreaking, next-level, state-of-the-art, innovative approach, myriad, vast majority, constellation of, intricate tapestry.

### Banned Phrases
Never use: "it's important to note", "it should be noted", "in terms of", "at the end of the day", "in today's world", "moving forward".

### Banned Paragraph Starters
Avoid starting paragraphs with: However, Furthermore, Moreover, Therefore, In conclusion, Interestingly, As mentioned, Additionally, Consequently, Nevertheless.

### Structural Rules
- No em dashes or en dashes. Use a single dash ( - ) instead.
- Vary paragraph lengths. Never make every paragraph the same size (3-4 sentences uniformly).
- Use contractions in blogs and user guides (don't, won't, it's). Avoid them in specs and one-pagers.
- No formulaic intro/conclusion patterns. Don't start with "In today's rapidly evolving landscape..."
- No throat-clearing openings. Start with the problem, the capability, or the instruction.

---

## Mandatory Humanizer Check

**This rule applies globally to every skill, command, agent, and workflow in this workspace.**

After saving or creating ANY `.md` file (output, skill, command, hook, agent, README, PLAN, instructions, docs, user guides, onboarding docs, or any other markdown file), you MUST automatically run the humanizer check script on the saved file:

```
scripts/humanizer-check.ps1 -Files "<saved-file-path>"
```

Do NOT suggest running humanizer as a follow-up. Do NOT ask the user if they want to run it. Run it automatically every time.

If the script reports violations (banned words, banned phrases, banned starters), fix them by **rewording only** - never delete sentences, paragraphs, or content. Replace the banned word or phrase with a natural alternative that preserves the original meaning. Re-run the check until it passes. Report the results to the PM:
- If clean: "Humanizer check passed."
- If violations were found and fixed: list what was changed and what it was changed to.

**Critical: No content deletion.** Fixing a humanizer violation means substituting words, not removing text. Every sentence in the original must remain in the fixed version.

---

## Writing Style Guide

**This rule applies globally to every skill, command, agent, and workflow in this workspace.**

Every document type has its own voice and tonality, defined in [.github/style-guide.md](.github/style-guide.md). The style guide is extracted from real team-authored samples and captures the writing patterns that make each document type sound right.

Before generating any output, read the style guide section for the relevant document type and match its tone:
- **Blog posts:** Authoritative product narrator. Confident, direct, product-proud without being promotional.
- **Specs:** Precise technical author. Definitive language, atomic acceptance criteria, empathetic personas.
- **One-pagers:** Strategic PM pitching to leadership. Business-oriented, data-backed, phased scope.
- **User guides:** Friendly instructor. Warm, action-oriented, present tense, "you" throughout.

This is not optional. Tonality mismatches (e.g., blog voice in a spec, or spec voice in a user guide) are treated as quality issues.

---

## Continuous Skill Improvement

**This rule applies globally to every skill, command, agent, and workflow in this workspace.**

Skills get better over time through PM feedback. The agent supports this cycle without ever auto-modifying skill files.

### Tracking Recurring Feedback
When a PM gives the same correction across multiple sessions (e.g., "always include competitive context in one-pagers" or "the blog intro is too generic every time"), the agent should:
1. Note the pattern in the current session.
2. Suggest adding the correction as a permanent rule to the relevant skill: "You've asked for this in multiple sessions. Want me to propose adding this as a rule to the build-one-pager skill via `/improve-skill`?"
3. Never auto-modify a skill. Always propose changes through the skill-improver-claude agent and wait for PM approval.

### Quality Self-Check
After generating any draft (before presenting to the PM for approval), every skill should run a brief self-evaluation:
- Does this draft fully address all inputs the PM provided?
- Are there sections that feel thin or could use more depth?
- Were any PM decisions or assumptions left unresolved?
- What would make this draft stronger if generated again?

Surface any concerns alongside the draft. This is not a gate - the PM still sees and approves the draft. It's a transparency step that helps the PM catch issues faster.

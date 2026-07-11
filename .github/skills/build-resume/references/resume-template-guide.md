# Resume Template Guide

This file documents `resume.tex`, the LaTeX template used by the `build-resume` skill. The skill reads `resume.tex`, substitutes the placeholders below with the PM-approved content, and writes the result to `output/resumes/<name>/<name>-neutral.tex` (or `<name>-for-<company-or-role>.tex` for tune mode).

The template stays close to the structure of `sample-data/latex-resume-code/ShikherSalujaResumeNov2024.tex`. All custom environments (`highlights`, `onecolentry`, `twocolentry`, `header`) and the ATS guard (`\pdfgentounicode=1`) are preserved.

## Placeholders

| Placeholder | What goes in | Example |
|---|---|---|
| `{{CANDIDATE_NAME}}` | Full display name | `Shikher Saluja` |
| `{{HEADER_CONTACT_BLOCK}}` | Inline contact + links block; see "Header contact block" below | (see below) |
| `{{PROFESSIONAL_SUMMARY}}` | 3-4 sentence summary, with `\textbf{...}` around the keywords the skill identified as load-bearing | `\textbf{Principal Product Manager}` with experience in ... |
| `{{SKILLS_DOMAIN_LABEL}}` / `{{SKILLS_DOMAIN}}` | Label + comma-separated list for the domain-focused skills line | `Cloud and Infrastructure` / `Azure, Cloud migration, ...` |
| `{{SKILLS_CRAFT_LABEL}}` / `{{SKILLS_CRAFT}}` | Label + list for craft skills | `Product Development` / `Product strategy, Feature specification, ...` |
| `{{SKILLS_LEADERSHIP_LABEL}}` / `{{SKILLS_LEADERSHIP}}` | Label + list for leadership skills | `Leadership` / `Thought leadership, Technology evangelism, ...` |
| `{{EXPERIENCE_BLOCK}}` | Pre-assembled LaTeX for all roles; see "Experience block skeleton" below | (see below) |
| `{{EXTRA_CURRICULAR_BLOCK}}` | LaTeX block for activities; bold sub-headings + `\vspace{0.2 cm}` between entries | (see below) |
| `{{EDUCATION_BLOCK}}` | Pre-assembled LaTeX for education entries | (see below) |
| `{{LAST_UPDATED}}` | Month + year string, e.g. `June 2026` | `June 2026` |

## Header contact block

Replace `{{HEADER_CONTACT_BLOCK}}` with mbox-wrapped entries separated by `\kern 5.0 pt%` pairs. Include the entries the PM approved (typically location, email, phone, LinkedIn, optionally portfolio / Substack / GitHub).

Pattern for each entry:

```latex
\mbox{<displayed-text>}%
\kern 5.0 pt%
\kern 5.0 pt%
```

For links, wrap with `\hrefWithoutArrow{<url>}{<displayed-text>}`. Escape underscores in displayed text (`\_`).

Example (location + email + phone + LinkedIn):

```latex
\mbox{Hyderabad, India}%
\kern 5.0 pt%
\kern 5.0 pt%
\mbox{\hrefWithoutArrow{mailto:shikher\_saluja2015@pgp.isb.edu}{shikher\_saluja2015@pgp.isb.edu}}%
\kern 5.0 pt%
\kern 5.0 pt%
\mbox{\hrefWithoutArrow{tel:+91-9620200453}{+91-9620200453}}%
\kern 5.0 pt%
\kern 5.0 pt%
\mbox{\hrefWithoutArrow{https://www.linkedin.com/in/shikher-saluja-9649a443/}{LinkedIn}}%
```

The trailing `%` on each line suppresses unwanted whitespace; do not drop them.

## Experience block skeleton

For each top-level role (e.g., one employer, one title span), open a `twocolentry` for the title + date range, then a `onecolentry` wrapping the highlights. Inside that `onecolentry`, sub-roles get their own nested `twocolentry` for the sub-role title + sub-date-range, followed by a `highlights` environment for the bullets.

### Single role, flat bullets

```latex
\begin{twocolentry}{<start> – <end>}
    \textbf{<Title>}, <Employer> -- <Location>
\end{twocolentry}
\begin{onecolentry}
    \begin{highlights}
        \item <bullet with \textbf{bold metric or term}>.
        \item <bullet with embedded link: \href{https://...}{\textcolor{blue}{<anchor text>}}>.
    \end{highlights}
\end{onecolentry}

\vspace{0.2 cm}
```

### Single role with nested sub-roles (scope changes inside one employer)

```latex
\begin{twocolentry}{<overall start> – Present}
    \textbf{<Top-level title>}, <Employer> -- <Location>
\end{twocolentry}
\begin{onecolentry}
    \begin{twocolentry}{<sub-role start> – Present}
      Cloud Service -- \textbf{<Sub-role product>}: <plain-language gloss of what it does, e.g. "move applications from on-premises / public clouds to Azure">
    \end{twocolentry}
    \begin{highlights}
        \item \textbf{Built} \href{https://...}{\textcolor{blue}{<feature>}} ground up
            \begin{itemize}
                \item Nested detail with \textbf{metric} and \textbf{outcome}.
                \item Another nested detail.
            \end{itemize}
        \item \textbf{Drive} <next thread of work>
            \begin{itemize}
                \item Nested detail.
            \end{itemize}
    \end{highlights}

    \begin{twocolentry}{<earlier sub-role start> – <end>}
      Cloud Service -- \textbf{<earlier sub-role product>}: <plain-language gloss of what it does>
    \end{twocolentry}
    \begin{highlights}
        \item ...
    \end{highlights}
\end{onecolentry}

\vspace{0.2 cm}
```

### Per-role bullet rules

- Action-verb-first; present tense for the current role, past tense for prior roles.
- State the problem, the action, and the impact in every bullet, in plain language a non-domain reader follows. A reviewer who has never used the product should still understand why the work mattered.
- Gloss each product and sub-role on its title line with a short "what it does" clause (see the sub-role skeleton above). Prefer a widely-understood job title on the role line (e.g. "Group Product Manager"); keep an internal ladder label in parentheses only when it adds credibility.
- Wrap load-bearing keywords (metrics, product names, awards, customer names) in `\textbf{...}`.
- Embed proof links using `\href{<url>}{\textcolor{blue}{<anchor text>}}` so they appear blue.
- Escape `%`, `&`, `$`, `#`, `_`, `{`, `}` in plain prose. Common cases: `20\%`, `\$1Bn`, `R\&D`.
- Never invent metrics or claims. The Markdown source the `.tex` is generated from should already have `> **PM Decision Required:**` flags for any unsubstantiated metric; those flags get resolved before the `.tex` is generated.

## Education block skeleton

One `twocolentry` per institution + `onecolentry` with `highlights` for honors and projects:

```latex
\begin{twocolentry}{<start> – <end>}
    \textbf{<Institution>}, <Degree>
\end{twocolentry}
\begin{onecolentry}
    \begin{highlights}
        \item \textbf{CGPA: <value>} (<context>); <distinctions>.
        \item <Project or thesis sentence, with embedded \href{...}{\textcolor{blue}{...}} where applicable>.
    \end{highlights}
\end{onecolentry}

\vspace{0.2 cm}
```

## Extra-curricular block skeleton

Bold the activity name, then prose. Separate entries with `\vspace{0.2 cm}`:

```latex
\textbf{<Activity name>:} <Prose with embedded \href{...}{\textcolor{blue}{...}} where applicable>.

\vspace{0.2 cm}
\textbf{<Next activity>:} ...
```

## Page-fit heuristic

The skill estimates page fit before showing the draft. Constants tuned against `sample-data/latex-resume-code/ShikherSalujaResumeNov2024.tex` (which fits on 2 pages at 10pt with the geometry above):

| Variable | Value |
|---|---|
| Approx. characters per typeset line at 10pt with the current geometry | 110 |
| Approx. typeset lines per page (after subtracting header + section title spacing) | 55 |
| Per-bullet vertical overhead in lines | 0.5 |
| Per-section vertical overhead in lines | 2.5 |

To estimate lines used: sum of (each bullet's character count / 110, ceiling) plus 0.5 per bullet plus 2.5 per section. Under 55 lines means 1 page; 55 to 110 lines means 2 pages. **The 2-page cap is a hard limit:** an estimate above 110 lines must be trimmed down before the draft is shown - cut the lowest-value whole bullets and re-estimate, never present a 3-page draft.

These are rough estimates only. The skill surfaces the estimated page count alongside the draft so the PM can verify against Overleaf if a tighter fit matters.

## Humanizer note

`resume.tex` is a code artifact, not prose. The `scripts/humanizer-check.ps1` step the skill runs after save targets the `.md` file only. The `.tex` is generated from the approved `.md`, so any banned-word fixes happen upstream before the `.tex` is written.

## Compile notes

Hand off the generated `.tex` to the PM with these options:

1. **Overleaf** — paste the `.tex` into a new Overleaf project, click Recompile. No local install needed.
2. **Local pdflatex** — `pdflatex <name>-neutral.tex` from the output folder. Requires a TeX distribution (MiKTeX, TeX Live, MacTeX).
3. **Local tectonic** — `tectonic <name>-neutral.tex`. Single-binary alternative; auto-fetches required packages.

The template uses only mainstream CTAN packages, so any of the three paths produces the same PDF.

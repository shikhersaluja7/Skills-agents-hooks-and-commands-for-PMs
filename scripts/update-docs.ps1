<#
    update-docs.ps1 - Auto-update skill tables in user guides and README
    
    Scans .github/skills/, .claude/skills/, .github/agents/, .github/prompts/,
    and .github/hooks/ to build the current inventory, then regenerates the
    skill table section in each doc between <!-- SKILL-TABLE-START --> and
    <!-- SKILL-TABLE-END --> markers.

    Also regenerates the repo structure tree between <!-- TREE-START -->
    and <!-- TREE-END --> markers in README.md.
    
    Usage:
      .\scripts\update-docs.ps1              # Dry run
      .\scripts\update-docs.ps1 -Apply       # Apply changes
      .\scripts\update-docs.ps1 -Apply -Staged  # Apply and stage
#>

param(
    [switch]$Apply,
    [switch]$Staged
)

$root = Split-Path $PSScriptRoot -Parent
$changes = @()

# --- Scan the live inventory ---

function Get-SkillInfo {
    param([string]$SkillDir)
    $skillFile = Join-Path $SkillDir "SKILL.md"
    if (-not (Test-Path $skillFile)) { return $null }
    $content = Get-Content $skillFile -Raw
    $name = ""
    $desc = ""
    $hint = ""
    if ($content -match '(?m)^name:\s*(.+)$') { $name = $Matches[1].Trim() }
    if ($content -match 'description:\s*"([^"]*)"') { $desc = $Matches[1] }
    elseif ($content -match "description:\s*'([^']*)'") { $desc = $Matches[1] }
    # Extract short description (before "Use when:")
    $shortDesc = $desc
    if ($desc -match '^(.+?)\.\s*Use when:') { $shortDesc = $Matches[1].Trim() }
    return @{ Name = $name; Description = $shortDesc; FullDescription = $desc }
}

function Get-AgentInfo {
    param([string]$AgentFile)
    if (-not (Test-Path $AgentFile)) { return $null }
    $content = Get-Content $AgentFile -Raw
    $desc = ""
    $hint = ""
    if ($content -match 'description:\s*"([^"]*)"') { $desc = $Matches[1] }
    elseif ($content -match "description:\s*'([^']*)'") { $desc = $Matches[1] }
    $shortDesc = $desc
    if ($desc -match '^(.+?)\.\s*Use when:') { $shortDesc = $Matches[1].Trim() }
    $name = [System.IO.Path]::GetFileNameWithoutExtension($AgentFile) -replace '\.agent$', ''
    return @{ Name = $name; Description = $shortDesc; FullDescription = $desc }
}

# Collect Copilot skills
$ghSkillsDir = Join-Path (Join-Path $root ".github") "skills"
$ghSkills = @()
if (Test-Path $ghSkillsDir) {
    Get-ChildItem $ghSkillsDir -Directory | ForEach-Object {
        $info = Get-SkillInfo $_.FullName
        if ($info) { $ghSkills += $info }
    }
}

# Collect Claude skills
$clSkillsDir = Join-Path (Join-Path $root ".claude") "skills"
$clSkills = @()
if (Test-Path $clSkillsDir) {
    Get-ChildItem $clSkillsDir -Directory | ForEach-Object {
        $info = Get-SkillInfo $_.FullName
        if ($info) { $clSkills += $info }
    }
}

# Collect agents
$agentsDir = Join-Path (Join-Path $root ".github") "agents"
$agents = @()
if (Test-Path $agentsDir) {
    Get-ChildItem $agentsDir -File -Filter "*.agent.md" | ForEach-Object {
        $info = Get-AgentInfo $_.FullName
        if ($info) { $agents += $info }
    }
}

# Collect prompts
$promptsDir = Join-Path (Join-Path $root ".github") "prompts"
$prompts = @()
if (Test-Path $promptsDir) {
    Get-ChildItem $promptsDir -File -Filter "*.prompt.md" | ForEach-Object {
        # BaseName strips only the last extension (.md), leaving ".prompt".
        $name = $_.BaseName -replace '\.prompt$', ''
        $prompts += $name
    }
}

# Build the unified skill table (for README and GHCP guide)
# Merge: Copilot skills + agents that are also Claude skills
$allNames = @()
$ghSkills | ForEach-Object { if ($allNames -notcontains $_.Name) { $allNames += $_.Name } }
$clSkills | ForEach-Object { if ($allNames -notcontains $_.Name) { $allNames += $_.Name } }
$agents | ForEach-Object { if ($allNames -notcontains $_.Name) { $allNames += $_.Name } }

# Build table for README (shows both platforms)
$readmeTable = "| Skill | Command | Copilot | Claude | What it does |`n"
$readmeTable += "|-------|---------|---------|--------|--------------|`n"
foreach ($name in ($allNames | Sort-Object)) {
    $ghMatch = $ghSkills | Where-Object { $_.Name -eq $name }
    $clMatch = $clSkills | Where-Object { $_.Name -eq $name }
    $agMatch = $agents | Where-Object { $_.Name -eq $name }
    
    $desc = ""
    if ($ghMatch) { $desc = $ghMatch.Description }
    elseif ($clMatch) { $desc = $clMatch.Description }
    elseif ($agMatch) { $desc = $agMatch.Description }
    
    $hasGH = if ($ghMatch -or $agMatch) { "yes" } else { "no" }
    $hasCL = if ($clMatch) { "yes" } else { "no" }

    $cmd = "``/$name``"
    if ($agMatch -and -not $ghMatch) { $cmd = "``@$name-ghcp``" }

    # Check if there's a prompt alias
    $promptName = $prompts | Where-Object { $_ -match $name }

    $readmeTable += "| **$name** | $cmd | $hasGH | $hasCL | $desc |`n"
}

# Build table for Copilot guides (simpler)
# Explicit map of agents that also have a slash-command alias. Add new aliases
# here when an agent gets a matching prompt - avoids fuzzy "-match" matching that
# previously appended /improve-skill to every agent row.
$agentPromptAlias = @{ "skill-improver" = "improve-skill" }

$copilotTable = "| Command | What it does |`n"
$copilotTable += "|---------|-------------|`n"
foreach ($name in ($allNames | Sort-Object)) {
    $ghMatch = $ghSkills | Where-Object { $_.Name -eq $name }
    $agMatch = $agents | Where-Object { $_.Name -eq $name }
    if (-not $ghMatch -and -not $agMatch) { continue }
    $desc = if ($ghMatch) { $ghMatch.Description } elseif ($agMatch) { $agMatch.Description } else { "" }
    if ($agMatch -and -not $ghMatch) {
        $cmd = "``@$name-ghcp``"
        if ($agentPromptAlias.ContainsKey($name)) {
            $alias = $agentPromptAlias[$name]
            if ($prompts -contains $alias) {
                $cmd += " or ``/$alias``"
            }
        }
    } else {
        $cmd = "``/$name``"
    }
    $copilotTable += "| $cmd | $desc |`n"
}

# Build table for Claude guides
$claudeTable = "| Command | What it does |`n"
$claudeTable += "|---------|-------------|`n"
foreach ($name in ($allNames | Sort-Object)) {
    $clMatch = $clSkills | Where-Object { $_.Name -eq $name }
    if (-not $clMatch) { continue }
    $claudeTable += "| ``/$($clMatch.Name)`` | $($clMatch.Description) |`n"
}

# Build table for PLAN.md (shows full description and status)
$planTable = "| Skill | Command | Description | Status |`n"
$planTable += "|-------|---------|-------------|--------|`n"
foreach ($name in ($allNames | Sort-Object)) {
    $ghMatch = $ghSkills | Where-Object { $_.Name -eq $name }
    $clMatch = $clSkills | Where-Object { $_.Name -eq $name }
    $agMatch = $agents | Where-Object { $_.Name -eq $name }

    $desc = ""
    if ($ghMatch) { $desc = $ghMatch.FullDescription }
    elseif ($clMatch) { $desc = $clMatch.FullDescription }
    elseif ($agMatch) { $desc = $agMatch.FullDescription }

    # Clean "Use when:" suffix for the plan table
    if ($desc -match '^(.+?)\.\s*Use when:') { $desc = $Matches[1].Trim() }

    $cmd = "``/$name``"
    if ($agMatch -and -not $ghMatch) { $cmd = "``@$name-ghcp``" }

    $planTable += "| **$name** | $cmd | $desc | Ready to use |`n"
}

# --- Update docs ---

function Update-DocSection {
    param(
        [string]$FilePath,
        [string]$StartMarker,
        [string]$EndMarker,
        [string]$NewContent
    )
    if (-not (Test-Path $FilePath)) { return }
    
    $content = Get-Content $FilePath -Raw
    $pattern = "(?s)($([regex]::Escape($StartMarker)))\r?\n.*?\r?\n($([regex]::Escape($EndMarker)))"
    
    if ($content -match $pattern) {
        $replacement = "$StartMarker`n$NewContent`n$EndMarker"
        $newContent = $content -replace $pattern, $replacement
        
        if ($newContent -ne $content) {
            $relPath = $FilePath.Replace("$root\", "").Replace("$root/", "")
            $script:changes += "DOC-UPDATE: $relPath"
            if ($Apply) {
                # Write UTF-8 without BOM. PowerShell 5.1's Set-Content -Encoding UTF8 emits a BOM.
                $utf8NoBom = New-Object System.Text.UTF8Encoding $false
                [System.IO.File]::WriteAllText($FilePath, $newContent, $utf8NoBom)
                if ($Staged) { git add $FilePath 2>$null }
            }
        }
    }
}

# Define which docs get which table
$docsWithTables = @(
    @{ Path = Join-Path $root "README.md"; Table = $readmeTable; Tag = "SKILL-TABLE" },
    @{ Path = Join-Path $root "PLAN.md"; Table = $planTable; Tag = "PLAN-SKILLS" },
    @{ Path = Join-Path (Join-Path $root "docs") "ghcp-user-guide.md"; Table = $copilotTable; Tag = "SKILL-TABLE" },
    @{ Path = Join-Path (Join-Path $root "docs") "m365-cowork-onboarding.md"; Table = $copilotTable; Tag = "SKILL-TABLE" },
    @{ Path = Join-Path (Join-Path $root "docs") "claude-user-guide.md"; Table = $claudeTable; Tag = "SKILL-TABLE" },
    @{ Path = Join-Path (Join-Path $root "docs") "claude-cowork-onboarding.md"; Table = $claudeTable; Tag = "SKILL-TABLE" }
)

foreach ($doc in $docsWithTables) {
    Update-DocSection `
        -FilePath $doc.Path `
        -StartMarker "<!-- $($doc.Tag)-START -->" `
        -EndMarker "<!-- $($doc.Tag)-END -->" `
        -NewContent $doc.Table.TrimEnd()
}

# --- Auto-seed per-artifact mini-sections in user guides ---
# Whenever a new skill/agent/prompt is added, the user guides should grow a
# matching mini-section so PMs see what it does. This function appends an
# editable stub (between SKILL-SECTION markers) for any artifact that lacks
# one. It never modifies content between an existing pair of markers, so
# PM-written prose is preserved across runs.

# Artifacts whose coverage already lives in shared/multi-skill sections of the
# user guides (sections 3 through 9). These do not get individual stubs because
# their user-facing walkthrough is grouped with peers.
$artifactsCoveredWithoutMarkers = @(
    "build-spec",                # GHCP/Claude guide sections 3-4
    "build-blog",                # section 5
    "build-user-guide",          # section 6
    "build-user-research",       # section 7
    "frontend-developer",        # section 8 (GHCP agent name)
    "frontend-developer-claude", # section 8 (Claude skill name)
    "backend-developer",         # section 8
    "backend-developer-claude",  # section 8
    "tester",                    # section 8
    "tester-claude",             # section 8
    "ideation",                  # section 8 (GHCP agent name)
    "ideation-claude",           # section 8 (Claude skill name)
    "skill-improver",            # section 9
    "skill-improver-claude"      # section 9
)

function Get-SkillOutputPath {
    param([string]$SkillFile)
    if (-not (Test-Path $SkillFile)) { return $null }
    $content = Get-Content $SkillFile -Raw
    if ($content -match 'output/([a-z0-9-]+)/') {
        return "output/$($Matches[1])/"
    }
    return $null
}

function Build-StubSection {
    param(
        [hashtable]$Item,
        [string]$Platform
    )
    $name = $Item.Name
    $desc = $Item.Description
    if (-not $desc) { $desc = "Auto-generated entry. Add a description in the skill or agent file." }
    $outputPath = $Item.OutputPath
    if (-not $outputPath) { $outputPath = "output/$name/" }

    if ($Platform -eq "ghcp" -and $Item.IsAgent) {
        $cmd = "@$name-ghcp"
    } else {
        $cmd = "/$name"
    }

    $stub = @"
<!-- SKILL-SECTION-START: $name -->
## Using $name

``````
$cmd <example argument>
``````

$desc

Saves to ``$outputPath``.

> *Auto-generated stub. Replace with a walkthrough following the style of section 5 (build-blog) or section 6 (build-user-guide).*
<!-- SKILL-SECTION-END: $name -->

---

"@
    return $stub
}

function Ensure-SkillSections {
    param(
        [string]$DocPath,
        [array]$Inventory,
        [string]$Platform
    )
    if (-not (Test-Path $DocPath)) { return }
    $content = Get-Content $DocPath -Raw

    if ($content -notmatch '## \d+\. Frequently Asked Questions') {
        return
    }

    $additions = @()
    foreach ($item in $Inventory) {
        $marker = "<!-- SKILL-SECTION-START: $($item.Name) -->"
        if ($content -match [regex]::Escape($marker)) { continue }
        $stub = Build-StubSection -Item $item -Platform $Platform
        $additions += $stub
        $relPath = $DocPath.Replace("$root\", "").Replace("$root/", "")
        $script:changes += "DOC-STUB: $relPath - added section for $($item.Name)"
    }

    if ($additions.Count -eq 0) { return }

    $allStubs = ($additions -join "")
    $newContent = $content -replace '(?=## \d+\. Frequently Asked Questions)', $allStubs

    if ($Apply) {
        # Write UTF-8 without BOM. PowerShell 5.1's Set-Content -Encoding UTF8 emits a BOM.
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($DocPath, $newContent, $utf8NoBom)
        if ($Staged) { git add $DocPath 2>$null }
    }
}

# Build the GHCP inventory: skills + agents (excluding shared-section coverage)
$ghcpStubInventory = @()
foreach ($s in $ghSkills) {
    if ($artifactsCoveredWithoutMarkers -contains $s.Name) { continue }
    $skillFile = Join-Path (Join-Path $ghSkillsDir $s.Name) "SKILL.md"
    $ghcpStubInventory += @{
        Name = $s.Name
        Description = $s.Description
        OutputPath = (Get-SkillOutputPath $skillFile)
        IsAgent = $false
    }
}
foreach ($a in $agents) {
    if ($artifactsCoveredWithoutMarkers -contains $a.Name) { continue }
    $ghcpStubInventory += @{
        Name = $a.Name
        Description = $a.Description
        OutputPath = $null
        IsAgent = $true
    }
}

# Build the Claude inventory: skills only (Claude exposes everything as skills)
$claudeStubInventory = @()
foreach ($s in $clSkills) {
    if ($artifactsCoveredWithoutMarkers -contains $s.Name) { continue }
    $skillFile = Join-Path (Join-Path $clSkillsDir $s.Name) "SKILL.md"
    $claudeStubInventory += @{
        Name = $s.Name
        Description = $s.Description
        OutputPath = (Get-SkillOutputPath $skillFile)
        IsAgent = $false
    }
}

Ensure-SkillSections -DocPath (Join-Path (Join-Path $root "docs") "ghcp-user-guide.md") -Inventory $ghcpStubInventory -Platform "ghcp"
Ensure-SkillSections -DocPath (Join-Path (Join-Path $root "docs") "claude-user-guide.md") -Inventory $claudeStubInventory -Platform "claude"

# --- Update review-doc document type table ---
# Scan all output-producing skills and build the review focus table.
# Each skill that saves to output/ gets a row. The mapping from skill name
# to doc type label and review focus lives here. New skills without a mapping
# get an "Other" row so the review-doc skill is never missing a type.

$reviewDocTypes = [ordered]@{
    "build-strategy-doc"      = @{ Label = "Strategy doc"; Focus = "Strategic coherence, data backing, customer evidence, compete coverage, pillar completeness, investment-to-outcome mapping" }
    "build-one-pager"         = @{ Label = "One-pager"; Focus = "Problem specificity, data points, scope boundaries, phasing clarity, user scenarios, customer evidence" }
    "build-spec"              = @{ Label = "Spec"; Focus = "Developer readiness, acceptance criteria testability, surface coverage (Portal/API/Agentic), section drift, I-can statement coverage" }
    "build-architecture"      = @{ Label = "Architecture doc"; Focus = "Design completeness, alternatives considered, diagram coverage, tradeoff documentation, security, data model" }
    "build-compete-analysis"  = @{ Label = "Compete analysis / scorecard"; Focus = "Factual accuracy, coverage breadth, missing competitors, outdated claims, differentiation clarity" }
    "build-compete-scorecard" = @{ Label = "Compete analysis / scorecard"; Focus = "Factual accuracy, coverage breadth, missing competitors, outdated claims, differentiation clarity" }
    "build-user-guide"        = @{ Label = "User guide"; Focus = "Action orientation, completeness of flows, error handling, terminology consistency, audience appropriateness" }
    "build-customer-story"    = @{ Label = "Customer story"; Focus = "Quote attribution, metric sourcing, narrative coherence, sensitivity handling" }
    "build-blog"              = @{ Label = "Blog"; Focus = "Hook strength, audience targeting, CTA clarity, claim substantiation" }
    "build-documentation"     = @{ Label = "Documentation"; Focus = "Learn conventions compliance, article type fit, prerequisite completeness, settings table coverage, screenshot placement, Next Steps links" }
    "build-demo-script"       = @{ Label = "Demo script"; Focus = "Beat flow coherence, timing accuracy, transition markers, screenshot/screen placeholders, audience fit, talk track naturalness" }
    "build-mbr"               = @{ Label = "MBR"; Focus = "Hypothesis validation rigor, KR status accuracy, data backing, action item completeness (owners and ETAs), follow-up tracking" }
    "build-announcement-email"= @{ Label = "Announcement email"; Focus = "Audience targeting, CTA clarity, key message prominence, link accuracy, tone fit" }
    "build-eval-dataset"      = @{ Label = "Eval dataset"; Focus = "Scenario coverage, ground truth accuracy, edge case representation, prompt-response alignment, grounding completeness" }
    "build-user-research"     = @{ Label = "User research"; Focus = "Hypothesis clarity, question neutrality, survey flow, interview guide completeness, research method fit" }
}

# Scan skills for output/ paths to find any new output-producing skills not in the map
$outputSkills = @()
if (Test-Path $ghSkillsDir) {
    Get-ChildItem $ghSkillsDir -Directory | ForEach-Object {
        $sf = Join-Path $_.FullName "SKILL.md"
        if (Test-Path $sf) {
            $sc = Get-Content $sf -Raw
            if ($sc -match 'output/') {
                $sn = $_.Name
                if (-not $reviewDocTypes.Contains($sn) -and $sn -ne "review-doc" -and $sn -ne "review-spec" -and $sn -ne "refine-spec") {
                    # Extract short description for the label
                    $label = ($sn -replace '^build-', '') -replace '-', ' '
                    $label = (Get-Culture).TextInfo.ToTitleCase($label)
                    $reviewDocTypes[$sn] = @{ Label = $label; Focus = "Structural coherence, clarity, completeness, audience fit" }
                }
            }
        }
    }
}

# Deduplicate labels (compete-analysis and compete-scorecard share a row)
$seenLabels = @{}
$reviewTable = "| Document Type | Key Review Focus |`n"
$reviewTable += "|--------------|-----------------|`n"
foreach ($entry in $reviewDocTypes.GetEnumerator()) {
    $label = $entry.Value.Label
    if ($seenLabels.ContainsKey($label)) { continue }
    $seenLabels[$label] = $true
    $reviewTable += "| **$label** | $($entry.Value.Focus) |`n"
}
$reviewTable += "| **Other** | Structural coherence, clarity, completeness, audience fit |"

$reviewDocPath = Join-Path (Join-Path $ghSkillsDir "review-doc") "SKILL.md"
Update-DocSection `
    -FilePath $reviewDocPath `
    -StartMarker "<!-- REVIEW-DOC-TYPES-START -->" `
    -EndMarker "<!-- REVIEW-DOC-TYPES-END -->" `
    -NewContent $reviewTable

# --- Report ---

if ($changes.Count -eq 0) {
    Write-Host "[update-docs] All docs are up to date."
} else {
    if ($Apply) {
        Write-Host "[update-docs] Updated $($changes.Count) doc(s):"
    } else {
        Write-Host "[update-docs] $($changes.Count) doc(s) need updating (dry run):"
    }
    $changes | ForEach-Object { Write-Host "  $_" }
}

exit 0

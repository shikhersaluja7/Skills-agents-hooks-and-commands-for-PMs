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
        $name = $_.BaseName
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
$copilotTable = "| Command | What it does |`n"
$copilotTable += "|---------|-------------|`n"
foreach ($name in ($allNames | Sort-Object)) {
    $ghMatch = $ghSkills | Where-Object { $_.Name -eq $name }
    $agMatch = $agents | Where-Object { $_.Name -eq $name }
    if (-not $ghMatch -and -not $agMatch) { continue }
    $desc = if ($ghMatch) { $ghMatch.Description } elseif ($agMatch) { $agMatch.Description } else { "" }
    $cmd = if ($agMatch -and -not $ghMatch) { "``@$name-ghcp`` or ``/improve-skill``" } else { "``/$name``" }
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
                Set-Content $FilePath $newContent -NoNewline -Encoding UTF8
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

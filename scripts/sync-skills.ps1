<# 
    sync-skills.ps1 - Keep .github/ and .claude/ skill artifacts in sync

    Mapping:
      .github/copilot-instructions.md  <->  CLAUDE.md               (workspace instructions sync)
      .github/skills/<name>/  <->  .claude/skills/<name>/            (bidirectional, SKILL.md + references/)
      .github/agents/<name>.agent.md  <->  .claude/skills/<name>/SKILL.md  (agent<->skill body sync)
      .claude/agents/<name>.md  (auto-generated facade from Claude skill, references skill via skills: field)

    Platform asymmetry:
      GHCP agents inherit workspace instructions (copilot-instructions.md) automatically.
      Claude sub-agents do NOT inherit CLAUDE.md. So for agent concepts like skill-improver:
        - The Claude skill (.claude/skills/) holds the full instructions (inherits CLAUDE.md at runtime)
        - The Claude agent (.claude/agents/) is a thin facade that loads the skill via skills: frontmatter
        - The GHCP agent (.github/agents/) is standalone (body has all instructions, workspace instructions inherited)
      Body content syncs bidirectionally between GHCP agent and Claude skill.
      The Claude agent facade is auto-regenerated from the Claude skill metadata on every sync.

    Usage:
      .\scripts\sync-skills.ps1              # Dry run (show what would change)
      .\scripts\sync-skills.ps1 -Apply       # Apply changes
      .\scripts\sync-skills.ps1 -Apply -Staged  # Apply and stage changes for git
#>

param(
    [switch]$Apply,
    [switch]$Staged
)

$root = Split-Path $PSScriptRoot -Parent
$githubSkills = Join-Path (Join-Path $root ".github") "skills"
$claudeSkills = Join-Path (Join-Path $root ".claude") "skills"
$githubAgents = Join-Path (Join-Path $root ".github") "agents"
$claudeAgents = Join-Path (Join-Path $root ".claude") "agents"

$changes = @()

# --- Agent mapping ---
# Maps concepts that are agents on GHCP and skill+agent-facade on Claude.
# Platform asymmetry: GHCP agents inherit workspace instructions; Claude sub-agents don't.
# So Claude keeps the full instructions in a skill (inherits CLAUDE.md) and exposes a thin
# agent facade that loads the skill via the skills: frontmatter field.
$agentSkillMap = @{
    "skill-improver" = @{
        GhcpAgent   = Join-Path $githubAgents "skill-improver.agent.md"
        ClaudeSkill = Join-Path (Join-Path $claudeSkills "skill-improver") "SKILL.md"
        ClaudeAgent = Join-Path $claudeAgents "skill-improver.md"
    }
    "frontend-developer" = @{
        GhcpAgent   = Join-Path $githubAgents "frontend-developer.agent.md"
        ClaudeSkill = Join-Path (Join-Path $claudeSkills "frontend-developer") "SKILL.md"
        ClaudeAgent = Join-Path $claudeAgents "frontend-developer.md"
    }
    "backend-developer" = @{
        GhcpAgent   = Join-Path $githubAgents "backend-developer.agent.md"
        ClaudeSkill = Join-Path (Join-Path $claudeSkills "backend-developer") "SKILL.md"
        ClaudeAgent = Join-Path $claudeAgents "backend-developer.md"
    }
    "tester" = @{
        GhcpAgent   = Join-Path $githubAgents "tester.agent.md"
        ClaudeSkill = Join-Path (Join-Path $claudeSkills "tester") "SKILL.md"
        ClaudeAgent = Join-Path $claudeAgents "tester.md"
    }
    "ideation" = @{
        GhcpAgent   = Join-Path $githubAgents "ideation.agent.md"
        ClaudeSkill = Join-Path (Join-Path $claudeSkills "ideation") "SKILL.md"
        ClaudeAgent = Join-Path $claudeAgents "ideation.md"
    }
}

function Sync-File {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$Label
    )

    if (-not (Test-Path $Source)) { return }

    $destDir = Split-Path $Destination -Parent
    $needsCopy = $false
    $reason = ""

    if (-not (Test-Path $Destination)) {
        $needsCopy = $true
        $reason = "missing"
    } else {
        $srcHash = (Get-FileHash $Source -Algorithm SHA256).Hash
        $dstHash = (Get-FileHash $Destination -Algorithm SHA256).Hash
        if ($srcHash -ne $dstHash) {
            $srcTime = (Get-Item $Source).LastWriteTimeUtc
            $dstTime = (Get-Item $Destination).LastWriteTimeUtc
            if ($srcTime -gt $dstTime) {
                $needsCopy = $true
                $reason = "newer"
            }
        }
    }

    if ($needsCopy) {
        $relSrc = $Source.Replace("$root\", "")
        $relDst = $Destination.Replace("$root\", "")
        $script:changes += "$Label [$reason]: $relSrc → $relDst"

        if ($Apply) {
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }
            Copy-Item $Source $Destination -Force
            
            # Transform agent references when syncing between ecosystems
            if ($Destination -match '\.claude[\\/]' -and $Source -match '\.github[\\/]') {
                # GHCP -> Claude: replace -ghcp suffix with -claude
                $content = Get-Content $Destination -Raw
                $content = $content -replace '-ghcp(?=[^a-z]|$)', '-claude'
                Set-Content $Destination -Value $content -NoNewline -Encoding UTF8
            } elseif ($Destination -match '\.github[\\/]' -and $Source -match '\.claude[\\/]') {
                # Claude -> GHCP: replace -claude suffix with -ghcp
                $content = Get-Content $Destination -Raw
                $content = $content -replace '-claude(?=[^a-z]|$)', '-ghcp'
                Set-Content $Destination -Value $content -NoNewline -Encoding UTF8
            }
            
            if ($Staged) {
                git add $Destination 2>$null
            }
        }
    }
}

function Sync-SkillDirectory {
    param(
        [string]$SourceDir,
        [string]$DestDir,
        [string]$Direction
    )

    if (-not (Test-Path $SourceDir)) { return }

    # Sync SKILL.md
    $srcSkill = Join-Path $SourceDir "SKILL.md"
    $dstSkill = Join-Path $DestDir "SKILL.md"
    Sync-File -Source $srcSkill -Destination $dstSkill -Label "SKILL $Direction"

    # Sync references/
    $srcRefs = Join-Path $SourceDir "references"
    if (Test-Path $srcRefs) {
        Get-ChildItem $srcRefs -File -Recurse | ForEach-Object {
            $relPath = $_.FullName.Replace("$srcRefs\", "")
            $dstFile = Join-Path (Join-Path $DestDir "references") $relPath
            Sync-File -Source $_.FullName -Destination $dstFile -Label "REF $Direction"
        }
    }

    # Also check dest references that may be newer and need to go back
    $dstRefs = Join-Path $DestDir "references"
    if (Test-Path $dstRefs) {
        Get-ChildItem $dstRefs -File -Recurse | ForEach-Object {
            $relPath = $_.FullName.Replace("$dstRefs\", "")
            $srcFile = Join-Path (Join-Path $SourceDir "references") $relPath
            if (Test-Path $srcFile) {
                # Reverse direction check
                $srcHash = (Get-FileHash $srcFile -Algorithm SHA256).Hash
                $dstHash = (Get-FileHash $_.FullName -Algorithm SHA256).Hash
                if ($srcHash -ne $dstHash) {
                    $srcTime = (Get-Item $srcFile).LastWriteTimeUtc
                    $dstTime = $_.LastWriteTimeUtc
                    if ($dstTime -gt $srcTime) {
                        $reverseDir = if ($Direction -eq "github→claude") { "claude→github" } else { "github→claude" }
                        $relSrc = $_.FullName.Replace("$root\", "")
                        $relDst = $srcFile.Replace("$root\", "")
                        $script:changes += "REF $reverseDir [newer]: $relSrc → $relDst"
                        if ($Apply) {
                            Copy-Item $_.FullName $srcFile -Force
                            if ($Staged) { git add $srcFile 2>$null }
                        }
                    }
                }
            } else {
                # File exists only in dest, copy to source
                $reverseDir = if ($Direction -eq "github→claude") { "claude→github" } else { "github→claude" }
                $relSrc = $_.FullName.Replace("$root\", "")
                $relDst = $srcFile.Replace("$root\", "")
                $script:changes += "REF $reverseDir [missing]: $relSrc → $relDst"
                if ($Apply) {
                    $srcRefDir = Split-Path $srcFile -Parent
                    if (-not (Test-Path $srcRefDir)) {
                        New-Item -ItemType Directory -Path $srcRefDir -Force | Out-Null
                    }
                    Copy-Item $_.FullName $srcFile -Force
                    if ($Staged) { git add $srcFile 2>$null }
                }
            }
        }
    }
}

# --- Main sync logic ---

# 0. Sync workspace instructions: .github/copilot-instructions.md ↔ CLAUDE.md
$copilotInstructions = Join-Path (Join-Path $root ".github") "copilot-instructions.md"
$claudeInstructions = Join-Path $root "CLAUDE.md"

Sync-File -Source $copilotInstructions -Destination $claudeInstructions -Label "INSTRUCTIONS copilot→claude"
Sync-File -Source $claudeInstructions -Destination $copilotInstructions -Label "INSTRUCTIONS claude→copilot"

# 1. Sync agent <-> skill pairs (body content sync, preserve frontmatter)
#    Then regenerate Claude agent facade from skill metadata.
$agentMappedNames = @()

foreach ($entry in $agentSkillMap.GetEnumerator()) {
    $mapName = $entry.Key
    $agentFile = $entry.Value.GhcpAgent
    $skillFile = $entry.Value.ClaudeSkill
    $facadeFile = $entry.Value.ClaudeAgent
    $agentMappedNames += $mapName

    $agentExists = Test-Path $agentFile
    $skillExists = Test-Path $skillFile

    if (-not $agentExists -and -not $skillExists) { continue }

    if ($agentExists -and $skillExists) {
        # Both exist — compare body content (everything after second ---)
        $agentContent = Get-Content $agentFile -Raw
        $skillContent = Get-Content $skillFile -Raw

        # Extract body (after second ---) 
        $agentParts = $agentContent -split "(?m)^---\s*$", 3
        $skillParts = $skillContent -split "(?m)^---\s*$", 3

        $agentBody = if ($agentParts.Count -ge 3) { $agentParts[2].TrimStart() } else { $agentContent }
        $skillBody = if ($skillParts.Count -ge 3) { $skillParts[2].TrimStart() } else { $skillContent }

        if ($agentBody -ne $skillBody) {
            $agentTime = (Get-Item $agentFile).LastWriteTimeUtc
            $skillTime = (Get-Item $skillFile).LastWriteTimeUtc

            if ($agentTime -gt $skillTime) {
                # Agent is newer — push body to skill, keep skill frontmatter
                $relAgent = $agentFile.Replace("$root\", "")
                $relSkill = $skillFile.Replace("$root\", "")
                $script:changes += "AGENT-SKILL [body, agent newer]: $relAgent → $relSkill"
                if ($Apply) {
                    # Transform -ghcp -> -claude when pushing GHCP agent body to Claude skill
                    $transformedBody = $agentBody -replace '-ghcp(?=[^a-z]|$)', '-claude'
                    $newSkillContent = "---`n" + $skillParts[1].Trim() + "`n---`n`n" + $transformedBody
                    Set-Content $skillFile $newSkillContent -NoNewline -Encoding UTF8
                    if ($Staged) { git add $skillFile 2>$null }
                }
            } else {
                # Skill is newer — push body to agent, keep agent frontmatter
                $relAgent = $agentFile.Replace("$root\", "")
                $relSkill = $skillFile.Replace("$root\", "")
                $script:changes += "AGENT-SKILL [body, skill newer]: $relSkill → $relAgent"
                if ($Apply) {
                    # Transform -claude -> -ghcp when pushing Claude skill body to GHCP agent
                    $transformedBody = $skillBody -replace '-claude(?=[^a-z]|$)', '-ghcp'
                    $newAgentContent = "---`n" + $agentParts[1].Trim() + "`n---`n`n" + $transformedBody
                    Set-Content $agentFile $newAgentContent -NoNewline -Encoding UTF8
                    if ($Staged) { git add $agentFile 2>$null }
                }
            }
        }
    } elseif ($agentExists -and -not $skillExists) {
        # Agent exists, skill missing — create skill from agent body with skill frontmatter
        $relAgent = $agentFile.Replace("$root\", "")
        $relSkill = $skillFile.Replace("$root\", "")
        $script:changes += "AGENT-SKILL [missing skill]: $relAgent → $relSkill"
        if ($Apply) {
            $agentContent = Get-Content $agentFile -Raw
            $agentParts = $agentContent -split "(?m)^---\s*$", 3
            $agentFm = if ($agentParts.Count -ge 2) { $agentParts[1] } else { "" }
            $agentBody = if ($agentParts.Count -ge 3) { $agentParts[2].TrimStart() } else { $agentContent }
            
            # Extract description from agent frontmatter
            $desc = ""
            if ($agentFm -match 'description:\s*"([^"]*)"') { $desc = $Matches[1] }
            elseif ($agentFm -match "description:\s*'([^']*)'") { $desc = $Matches[1] }
            $argHint = ""
            if ($agentFm -match 'argument-hint:\s*"([^"]*)"') { $argHint = $Matches[1] }
            elseif ($agentFm -match "argument-hint:\s*'([^']*)'") { $argHint = $Matches[1] }

            # Auto-suffix Claude skill name and description
            $cleanDesc = $desc -replace '\s*\(GHCP\)\s*$', '' -replace '\s*\(Claude\)\s*$', '' -replace '\s*-ghcp\s*$', '' -replace '\s*-claude\s*$', ''
            $skillFm = "name: $mapName-claude`ndescription: `"$cleanDesc (Claude)`""
            if ($argHint) { $skillFm += "`nargument-hint: `"$argHint`"" }
            # Transform -ghcp -> -claude in body when creating Claude skill from GHCP agent
            $transformedBody = $agentBody -replace '-ghcp(?=[^a-z]|$)', '-claude'
            $newSkillContent = "---`n$skillFm`n---`n`n$transformedBody"

            $skillDir = Split-Path $skillFile -Parent
            if (-not (Test-Path $skillDir)) { New-Item -ItemType Directory -Path $skillDir -Force | Out-Null }
            Set-Content $skillFile $newSkillContent -NoNewline -Encoding UTF8
            if ($Staged) { git add $skillFile 2>$null }
        }
    } elseif (-not $agentExists -and $skillExists) {
        # Skill exists, agent missing — create agent from skill body with agent frontmatter
        $relAgent = $agentFile.Replace("$root\", "")
        $relSkill = $skillFile.Replace("$root\", "")
        $script:changes += "AGENT-SKILL [missing agent]: $relSkill → $relAgent"
        if ($Apply) {
            $skillContent = Get-Content $skillFile -Raw
            $skillParts = $skillContent -split "(?m)^---\s*$", 3
            $skillFm = if ($skillParts.Count -ge 2) { $skillParts[1] } else { "" }
            $skillBody = if ($skillParts.Count -ge 3) { $skillParts[2].TrimStart() } else { $skillContent }

            $desc = ""
            if ($skillFm -match 'description:\s*"([^"]*)"') { $desc = $Matches[1] }
            elseif ($skillFm -match "description:\s*'([^']*)'") { $desc = $Matches[1] }
            $argHint = ""
            if ($skillFm -match 'argument-hint:\s*"([^"]*)"') { $argHint = $Matches[1] }
            elseif ($skillFm -match "argument-hint:\s*'([^']*)'") { $argHint = $Matches[1] }

            # Auto-suffix GHCP agent name and description - strip any existing suffix first
            $cleanDesc = $desc -replace '\s*\(GHCP\)\s*$', '' -replace '\s*\(Claude\)\s*$', '' -replace '\s*-ghcp\s*$', '' -replace '\s*-claude\s*$', ''
            $agentFm = "name: `"$mapName-ghcp`"`ndescription: `"$cleanDesc (GHCP)`"`ntools: [read, search, edit, web]`nuser-invocable: true"
            if ($argHint) { $agentFm += "`nargument-hint: `"$argHint`"" }
            $newAgentContent = "---`n$agentFm`n---`n`n$skillBody"

            $agentDir = Split-Path $agentFile -Parent
            if (-not (Test-Path $agentDir)) { New-Item -ItemType Directory -Path $agentDir -Force | Out-Null }
            Set-Content $agentFile $newAgentContent -NoNewline -Encoding UTF8
            if ($Staged) { git add $agentFile 2>$null }
        }
    }

    # --- Regenerate Claude agent facade from skill metadata ---
    # The facade is a thin sub-agent that loads the skill via skills: frontmatter.
    # It is auto-generated on every sync to stay consistent with the skill.
    if (Test-Path $skillFile) {
        $skillContent = Get-Content $skillFile -Raw
        $skillParts = $skillContent -split "(?m)^---\s*$", 3
        $skillFm = if ($skillParts.Count -ge 2) { $skillParts[1] } else { "" }

        $desc = ""
        if ($skillFm -match 'description:\s*"([^"]*)"') { $desc = $Matches[1] }
        elseif ($skillFm -match "description:\s*'([^']*)'") { $desc = $Matches[1] }

        $facadeFm = "name: $mapName-claude"
        # Auto-suffix Claude facade description - strip any existing suffix first
        $cleanDesc = $desc -replace '\s*\(GHCP\)\s*$', '' -replace '\s*\(Claude\)\s*$', '' -replace '\s*-ghcp\s*$', '' -replace '\s*-claude\s*$', ''
        $facadeFm += "`ndescription: `"$cleanDesc (Claude)`""
        $facadeFm += "`ntools: Read, Grep, Glob, Edit, Write, Bash, WebFetch"
        $facadeFm += "`nmodel: inherit"
        $facadeFm += "`nskills:`n  - $mapName"
        $facadeBody = "You are the $mapName agent. Your full workflow and constraints are loaded from the $mapName skill above.`n`nFollow those instructions exactly. The skill contains the complete workflow: identify target skill, research best practices, analyze and compare, present improvement report, and apply changes after PM approval.`n"

        $newFacadeContent = "---`n$facadeFm`n---`n`n$facadeBody"

        $needsFacadeUpdate = $false
        if (-not (Test-Path $facadeFile)) {
            $needsFacadeUpdate = $true
        } else {
            $existingFacade = Get-Content $facadeFile -Raw
            if ($existingFacade.Trim() -ne $newFacadeContent.Trim()) {
                $needsFacadeUpdate = $true
            }
        }

        if ($needsFacadeUpdate) {
            $relFacade = $facadeFile.Replace("$root\", "")
            $script:changes += "CLAUDE-AGENT-FACADE [regenerated]: $relFacade"
            if ($Apply) {
                $facadeDir = Split-Path $facadeFile -Parent
                if (-not (Test-Path $facadeDir)) { New-Item -ItemType Directory -Path $facadeDir -Force | Out-Null }
                Set-Content $facadeFile $newFacadeContent -NoNewline -Encoding UTF8
                if ($Staged) { git add $facadeFile 2>$null }
            }
        }
    }
}

# 2. Sync all skill directories: .github/skills/ <-> .claude/skills/
#    (skip names that are handled by the agent mapping above)
$allSkillNames = @()

if (Test-Path $githubSkills) {
    Get-ChildItem $githubSkills -Directory | ForEach-Object {
        if ($agentMappedNames -notcontains $_.Name) { $allSkillNames += $_.Name }
    }
}
if (Test-Path $claudeSkills) {
    Get-ChildItem $claudeSkills -Directory | ForEach-Object {
        if ($allSkillNames -notcontains $_.Name -and $agentMappedNames -notcontains $_.Name) {
            $allSkillNames += $_.Name
        }
    }
}

foreach ($name in $allSkillNames) {
    $ghDir = Join-Path $githubSkills $name
    $clDir = Join-Path $claudeSkills $name

    # GitHub → Claude
    Sync-SkillDirectory -SourceDir $ghDir -DestDir $clDir -Direction "github→claude"
    # Claude → GitHub (reverse, for files only in Claude or newer in Claude)
    Sync-SkillDirectory -SourceDir $clDir -DestDir $ghDir -Direction "claude→github"
}

# --- Report ---

if ($changes.Count -eq 0) {
    Write-Host "Skills are in sync. No changes needed."
} else {
    if ($Apply) {
        Write-Host "Applied $($changes.Count) sync operation(s):"
    } else {
        Write-Host "Found $($changes.Count) out-of-sync file(s) (dry run, use -Apply to fix):"
    }
    $changes | ForEach-Object { Write-Host "  $_" }
}

exit 0

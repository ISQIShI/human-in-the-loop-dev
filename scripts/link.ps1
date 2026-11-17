<#
.SYNOPSIS
Create directory junctions to this skill in folders that other AI tools read.

.DESCRIPTION
The skill lives once on disk (for example in .agents/skills/<name>). Tools that
read a different folder, such as Claude Code with .claude/skills, get a junction
pointing at it, so edits never need to be synced. Junctions need neither
administrator rights nor Developer Mode. Run again after moving the project.

.PARAMETER ProjectRoot
Project root. Defaults to three levels above the skill folder, which matches
<project>/.agents/skills/<name>.

.PARAMETER Target
Skill folders to link into, relative to the project root.

.EXAMPLE
pwsh -ExecutionPolicy Bypass -File .agents/skills/human-in-the-loop-dev/scripts/link.ps1
#>
param(
    [string]$ProjectRoot,
    [string[]]$Target = @('.claude/skills')
)

$ErrorActionPreference = 'Stop'

function Get-NormalizedPath([string]$Path) {
    return [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
}

$skillRoot = Get-NormalizedPath (Split-Path -Parent $PSScriptRoot)
$skillName = Split-Path -Leaf $skillRoot

if (-not $ProjectRoot) {
    $ProjectRoot = Join-Path $skillRoot '..\..\..'
}
$ProjectRoot = Get-NormalizedPath $ProjectRoot

foreach ($t in $Target) {
    $dir = Join-Path $ProjectRoot $t
    $link = Join-Path $dir $skillName

    if ((Get-NormalizedPath $link) -eq $skillRoot) {
        Write-Output "skipped: $link is the skill itself"
        continue
    }

    $existing = Get-Item -LiteralPath $link -Force -ErrorAction SilentlyContinue
    if ($existing) {
        $current = @($existing.Target)[0]
        if ($existing.LinkType -and $current -and ((Get-NormalizedPath $current) -eq $skillRoot)) {
            Write-Output "exists: $link"
            continue
        }
        throw "$link already exists and does not point to $skillRoot. Remove it and run again."
    }

    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    New-Item -ItemType Junction -Path $link -Target $skillRoot | Out-Null
    Write-Output "linked: $link -> $skillRoot"
}

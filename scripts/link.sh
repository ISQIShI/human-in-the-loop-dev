#!/bin/sh
# Create symlinks to this skill in folders that other AI tools read.
#
# The skill lives once on disk (for example in .agents/skills/<name>). Tools that
# read a different folder, such as Claude Code with .claude/skills, get a symlink
# pointing at it, so edits never need to be synced. Run again after moving the
# project.
#
# Usage: sh scripts/link.sh [target-dir ...]
#   target-dir   skill folder to link into, relative to the project root
#                (default: .claude/skills)
#   PROJECT_ROOT overrides the project root, which defaults to three levels
#                above the skill folder (<project>/.agents/skills/<name>).
set -eu

skill_root=$(cd "$(dirname "$0")/.." && pwd -P)
skill_name=$(basename "$skill_root")
project_root=${PROJECT_ROOT:-$(cd "$skill_root/../../.." && pwd -P)}

[ $# -gt 0 ] || set -- .claude/skills

for target in "$@"; do
    dir="$project_root/$target"
    link="$dir/$skill_name"
    mkdir -p "$dir"

    if [ -L "$link" ]; then
        if [ "$(cd "$link" 2>/dev/null && pwd -P)" = "$skill_root" ]; then
            echo "exists: $link"
            continue
        fi
        echo "error: $link already exists and does not point to $skill_root. Remove it and run again." >&2
        exit 1
    elif [ -e "$link" ]; then
        if [ "$(cd "$link" && pwd -P)" = "$skill_root" ]; then
            echo "skipped: $link is the skill itself"
            continue
        fi
        echo "error: $link already exists and is not a link. Remove it and run again." >&2
        exit 1
    fi

    ln -s "$skill_root" "$link"
    echo "linked: $link -> $skill_root"
done

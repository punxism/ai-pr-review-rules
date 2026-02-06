#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   .claude/skills/pr-review/pr-diff.sh <base_ref> <head_ref>
# Example:
#   .claude/skills/pr-review/pr-diff.sh origin/main HEAD > pr.diff

BASE_REF="${1:-origin/main}"
HEAD_REF="${2:-HEAD}"

git diff "$BASE_REF...$HEAD_REF"

#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   .claude/skills/pr-review/build-rules.sh <base_ref> <head_ref>
# Output:
#   merged-rules.json

BASE_REF="${1:-origin/main}"
HEAD_REF="${2:-HEAD}"

RULE_DIR="docs/review/rules"
OUT="merged-rules.json"

# Always include core
FILES=("$RULE_DIR/core.json" "$RULE_DIR/architecture.json")

CHANGED="$(git diff --name-only "$BASE_REF...$HEAD_REF")"

# Heuristics (tweak to your repo)
if echo "$CHANGED" | grep -E '(?i)(jpa|entity|repository|infra|migration|\.sql$)' >/dev/null; then
  FILES+=("$RULE_DIR/persistence.json")
fi

if echo "$CHANGED" | grep -E '(?i)(client|feign|webclient|resttemplate|http|grpc)' >/dev/null; then
  FILES+=("$RULE_DIR/reliability.json")
fi

if echo "$CHANGED" | grep -E '(?i)(auth|security|jwt|oauth|cookie|csrf|ssrf|xss)' >/dev/null; then
  FILES+=("$RULE_DIR/security.json")
fi

if echo "$CHANGED" | grep -E '(?i)(logger|logging|mdc|trace|otel|metric|prometheus)' >/dev/null; then
  FILES+=("$RULE_DIR/observability.json")
fi

if echo "$CHANGED" | grep -E '(?i)(test|kotest|junit|mockk|testcontainers)' >/dev/null; then
  FILES+=("$RULE_DIR/testing.json")
fi

# Merge: keep both the ruleset list and a flattened rules[]
python - <<'PY'
import json,sys
files = sys.argv[1:]
rulesets = []
flat = []
for p in files:
    with open(p, 'r', encoding='utf-8') as f:
        d = json.load(f)
    rulesets.append(d)
    flat.extend(d.get('rules', []))
out = {
    "version": "1.0",
    "selected": files,
    "rulesets": rulesets,
    "rules": flat
}
with open("merged-rules.json", "w", encoding="utf-8") as f:
    json.dump(out, f, ensure_ascii=False, indent=2)
    f.write("\n")
PY "${FILES[@]}"

echo "$OUT"

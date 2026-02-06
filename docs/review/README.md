# AI Code Review Rules

This directory contains machine-readable review rules.

## Structure

| File | Description |
|------|-------------|
| rules/core.json | Always-on core rules |
| rules/architecture.json | Layer & dependency rules |
| rules/persistence.json | DB & transaction rules |
| rules/reliability.json | External call & resilience rules |
| rules/security.json | Security & PII rules |
| rules/observability.json | Logging & tracing rules |
| rules/testing.json | Test standards |

## Usage

- core.json is always applied
- Other rule sets are loaded selectively in CI
- Rules are merged and passed to LLM reviewers

# Requirement Schema

Template for a requirement page. Store under `wiki/requirements/<category>/REQ-###-short-title.md`.

See `CLAUDE.md` for the requirement state machine and authority model.

---

```yaml
id: REQ-###
title: ""
type: requirement
status: draft              # captured | triaged | analyzed | draft | approved | implemented | verified | released | superseded | rejected
created: YYYY-MM-DD
updated: YYYY-MM-DD
owner: ""
source_refs: []
related: []
confidence: 0.50
supersedes: []
superseded_by: []
version: "1.0"
priority: ""               # high | medium | low
acceptance_criteria: []
derived_from: []           # upstream requirement or source IDs
affects: []                # system areas or components affected
depends_on: []             # REQ-### list
blocked_by: []
decision_refs: []          # ADR-### list
plan_refs: []              # PLAN-### list
task_refs: []              # TASK-### list
evidence_refs: []          # EVID-### list
approved_by: ""
last_reviewed: YYYY-MM-DD
```

---

## Body sections

### Description

What this requirement specifies and the user or business need it addresses.

### Rationale

Why this requirement exists. Link to interviews, tickets, or other raw source evidence.

### Acceptance criteria (expanded)

Detailed pass/fail criteria corresponding to the `acceptance_criteria` list in frontmatter.

### Open questions

Unresolved questions that could affect scope or interpretation.

### Change history

Significant changes to this requirement with dates and rationale.

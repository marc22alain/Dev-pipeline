# Task Schema

Template for a task page. Store under `wiki/tasks/<status>/TASK-###-short-title.md`.

See `CLAUDE.md` for the task state machine and ready-task contract. See `.claude/agents/task-runner.md` for lease rules and session bookkeeping.

---

```yaml
id: TASK-###
title: ""
type: task
status: draft              # draft | ready | leased | in-progress | in-review | verified | done | blocked | cancelled | superseded
created: YYYY-MM-DD
updated: YYYY-MM-DD
owner: ""
source_refs: []
related: []
confidence: 0.75
supersedes: []             # full paths to older task(s) this task's shipped work supersedes, via a change request. Set only once THIS task reaches status: done — never at CR-approval time (see WIKI-SCHEMA.md change-request workflow, Apply step)
superseded_by: []         # full path to the newer task that supersedes this one. Set only once that newer task reaches status: done. This task's body (description/acceptance criteria) is never edited to reflect the supersession — it stays an accurate historical record
priority: ""               # high | medium | low
plan_ref: ""               # PLAN-### or "standalone"
iter_ref: ""               # full path to the analysis iteration that is the basis for this task (e.g. wiki/analysis/<slug>/ITER-NNN.md)
requirement_refs: []       # full file paths; for sections within a spec doc use "SECTION-ID :: path/to/file.md"
decision_refs: []          # full paths to ADR pages (e.g. wiki/architecture/decisions/ADR-NNN.md)
depends_on: []             # full paths to dependency task files
blocked_by: []             # full paths to blocking task files, or a quoted description of an external blocker
files_expected: []
acceptance_criteria: []
test_map: []
demo_steps: []
constraints: []
human_approval_required: false
lease:
  holder: ""
  expires_at: ""
session_refs: []           # full paths to session log files in order (e.g. raw/coding-sessions/CS-YYYY-MM-DD-###.md)
blocking_session_ref: ""   # full path to the session log that last moved this task to blocked; cleared when task returns to ready
revision_notes: ""         # set by human when rejecting a promotion candidate; describes specific issues to fix; cleared after successful revision review
```

---

## Body sections

### Description

What this task accomplishes and why it exists.

### Context

Background information, links to relevant requirements and decisions, and any design notes needed to understand the scope.

### Acceptance criteria (expanded)

Detailed pass/fail criteria corresponding to the `acceptance_criteria` list in frontmatter.

### Notes

Implementation notes, open questions, or observations added during or after the session.

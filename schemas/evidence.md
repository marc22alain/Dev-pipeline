# Evidence Schema

Template for an evidence page. Store under `wiki/evidence/<category>/EVID-###-short-title.md`.

See `CLAUDE.md` for the evidence state machine and authority model. See `.claude/agents/session-code-reviewer.md` for minimum evidence expectations.

---

```yaml
id: EVID-###
title: ""
type: evidence
status: raw                # raw | summarized | linked | accepted | stale
created: YYYY-MM-DD
updated: YYYY-MM-DD
owner: ""
source_refs: []
related: []
confidence: 0.50
supersedes: []
superseded_by: []
date: YYYY-MM-DD           # date the evidence was produced
requirement_refs: []       # REQ-### list
task_refs: []              # TASK-### list
plan_refs: []              # PLAN-### list
sources: []                # raw file paths or external references
verdict: ""                # pass | fail | inconclusive | partial
verified_by: ""
```

---

## Body sections

### Summary

Brief description of what this evidence captures and what it demonstrates.

### Result notes

Detailed observations against the relevant acceptance criteria. Note which criteria pass, fail, or remain inconclusive.

### Artifact links

Links to raw test output, demo recordings, telemetry snapshots, or session logs that back this evidence.

### Limitations

Known gaps, conditions not tested, or caveats that affect how far this evidence can be relied upon.

# Session Record Schema

Template for a coding session log file. Store the completed file under `raw/coding-sessions/` using the ID as the filename (e.g., `CS-2026-04-13-001.md`).

The task runner writes computed facts (timestamps, files touched, test results, exit status, last clean commit). The coding agent contributes the body sections listed below.

---

```yaml
session_id: CS-YYYY-MM-DD-###
task_ref: TASK-###
prior_session_ref: ""          # CS-ID of the session this resumes, if any
agent: ""                      # agent identifier (e.g. codex, claude-sonnet-4-5)
branch: ""                     # git branch name
started_at: ""                 # ISO 8601 datetime with timezone
ended_at: ""                   # ISO 8601 datetime with timezone
status: completed              # completed | blocked | partial
outcome_type: complete         # complete | partial | blocked | speculative-completion — see `.claude/agents/coding-agent.md`
last_clean_commit: ""          # git commit hash of last valid committable state
files_touched: []
tests_run: []
issues_found: []
proposed_updates: []
blocking_issue:
  type: ""                     # question | contradiction | scope-discovery | environment | none
  description: ""
  requires_human: false
judgment_calls: []             # decisions made under ambiguity that need human validation
work_remaining: []             # for partial or blocked sessions: what is left to do
skills_used: []                # skill names (from SKILL.md `name:` field) loaded and applied during this session
```

---

## Body sections

### Summary

Brief description of what was attempted and what was accomplished.

### Chronological steps

Ordered account of actions taken during the session.

### Observations

Notable findings, unexpected behavior, or confirmed assumptions.

### Judgment calls made

Decisions made under ambiguity. Required if `outcome_type` is `speculative-completion`. Each entry should describe the decision made and the alternative(s) considered.

### Open questions or contradictions found

Items that could not be resolved within the session. Required if `outcome_type` is any blocking type.

### Artifact links

References to files modified, tests run, evidence produced, or other session outputs.

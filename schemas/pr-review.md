---
name: PR review
id_format: "PR-REVIEW-YYYY-MM-DD-NNN"
type: pr-review
---

# PR Review Schema

Represents a pull request review artifact — AI-generated or human — captured in `raw/PR-reviews/<feature-slug>/`.

## Frontmatter fields

```yaml
---
id: PR-REVIEW-YYYY-MM-DD-NNN
type: pr-review
date: YYYY-MM-DD
repo: worktree-set/<repo-name>         # repo the PR targets
pr_number: 4302                        # GitHub PR number; omit for AI / local reviews
branch: <branch-name>
reviewer: Brent                        # person name, or "ai-gpt5", "ai-claude", etc.
reviewer_type: human                   # human | ai
task_refs:
  - wiki/tasks/TASK-NNN-...md    # full paths (flat dir); may be plural if review spans tasks
status: raw                            # raw | triaged | closed
---
```

## File naming convention

```
YYYY-MM-DD-<repo>-<context>.md
```

Examples:
- `2026-06-15-gcode-generator-task-001-backend-pr-review.md` — AI review, local
- `2026-06-16-gcode-generator-PR-4302-Bobby.md` — GitHub PR review by Bobby

## GitHub JSON export

When a GitHub PR review arrives as JSON (e.g., exported via the GitHub API), wrap it in a `.md` file with this structure:

```markdown
---
<frontmatter fields>
---

## Triage

(populated during intake)

## Raw Comments

\`\`\`json
[...original JSON...]
\`\`\`
```

The `.json` source file is not retained; the `.md` wrapper is the canonical artifact.

## Triage section

During intake, append a `## Triage` section with per-comment disposition. After intake is complete, the file is append-only.

```markdown
## Triage

**Date:** YYYY-MM-DD
**Status:** triaged

| Comment | Assessment | Action |
|---|---|---|
| <file>:<line> — <summary> | Valid / Not valid / Informational | TASK-NNN / ADR-NNN / Closed |
```

## Status values

| Status | Meaning |
|---|---|
| `raw` | Received; not yet read or triaged |
| `triaged` | Read; per-comment disposition recorded; follow-up actions dispatched |
| `closed` | No findings requiring action; or all actions complete |

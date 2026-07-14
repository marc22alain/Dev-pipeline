# DEV-WIKI

Software delivery wiki.

Operates under the Iterative Requirements Analysis Pattern defined in [WIKI-SCHEMA.md](WIKI-SCHEMA.md).

## Quick links

- [Wiki index](wiki/index.md)
- [Event log](wiki/log.md)
- [Schema reference](WIKI-SCHEMA.md)
- [Schema files](schemas/)

## Layout

```
raw/        append-only evidence (specs, analysis, snapshots, sessions, PR reviews)
wiki/       curated project knowledge (requirements, tasks, gaps, decisions, evidence)
state/      machine-operable control state (queues, leases, manifests)
schemas/    frontmatter and document schema definitions
scripts/    shell helpers for running tasks and fetching PR data
```

---

## How to use

### Adapt to your project

- Populate `worktree-set` with repository instances or worktrees of the code to be extended or consulted
- Update the CLAUDE.md with a description of each included repository

### Extending the wiki and its workflows

The orchestrator agent has a very good understanding of the practices and core principles of the wiki. To add a workflow or a document type for ingestion, simply describe the workflow in terms of how the document information is processed and what roles (each agent and human) are responsible for what. The orchestrator will create new directories in `raw` and `wiki` and new document front-matter schema that will show the linkages between the new documents.

---

## Enabled workflows

### 1. Run a coding task

Move a task page to `wiki/tasks/ready/`, then launch the task-runner:

```bash
./scripts/run-task.sh TASK-###
```

The script launches Claude Code (non-interactive) with the task-runner role injected as a prime agent. The task-runner acquires a lease, assembles the context bundle, dispatches a coding agent, runs the session-code-reviewer, and writes the result to:

```
state/queues/task-runner-reports/TASK-###.yaml
```

The result file indicates the new task state and whether human action is required. Read it after the script exits. The script also prints the result to stdout.

**Task state machine:** `draft → ready → in-progress → in-review → done` (or `blocked`, `superseded`).

---

### 2. Ingest a PR review

Fetch inline review comments from the current branch's PR using the helper script (run from inside the target repo):

```bash
# All reviewers
./scripts/get-PR-comments-per-user.sh --all

# Single reviewer (coder555 bobby)
./scripts/get-PR-comments-per-user.sh bobby
```

Then follow the **PR review intake workflow** in [WIKI-SCHEMA.md](WIKI-SCHEMA.md):

1. Save the raw artifact to `raw/PR-reviews/<feature-slug>/` with frontmatter (`status: raw`).
2. Triage each finding against the task spec, approved ADRs, and the feature ERD.
3. Dispatch follow-up tasks or ADRs as warranted; reference the `PR-REVIEW-###` ID.
4. Append a `## Triage` section; set `status: triaged` or `status: closed`.
5. Log to `wiki/log.md`.

---

### 3. Promote a session to verified

After a coding session completes, the session-code-reviewer gates the transition to `in-review`. Promotion candidates appear in:

```
state/queues/promotion-candidates/
```

Human review is required before a candidate is accepted and the task moves to `done`. Read the promotion candidate YAML, verify the linked evidence, then update the task state manually or approve the candidate.

**If the candidate is rejected**, use the task revision workflow instead of discarding the task:

1. Set `status: withdrawn` on the promotion candidate.
2. Add `revision_notes` to the task frontmatter describing what must be fixed, move it back to `wiki/tasks/ready/`, set `status: ready`, and clear the `lease` block.
3. Re-run `./scripts/run-task.sh TASK-###`. The task runner detects `revision_notes` alongside existing `session_refs` and dispatches a **revision session**: the coding agent receives the prior session logs and evidence plus the fix scope, and implements only the named fixes.
4. The reviewer produces a new evidence document superseding the prior one and confirms each `revision_notes` item is resolved. `revision_notes` is cleared on promotion to `done`. Prior sessions and evidence are preserved as the historical record. See [WIKI-SCHEMA.md](WIKI-SCHEMA.md) for the full workflow.

---

### 4. Analysis iterations and gap management

When a new feature begins or a change request triggers re-analysis:

1. **Snapshot** the application context doc → `raw/context-snapshots/<feature-slug>/ITER-NNN.md`.
2. **Snapshot** the solutioning doc → `raw/solutioning-snapshots/<feature-slug>/ITER-NNN.md`.
3. **Run the planning agent** with the spec, context snapshot, and solutioning snapshot.
4. **Save raw output** → `raw/analysis/<feature-slug>/ITER-NNN-raw.md`.
5. **Create curated wiki artifacts**: iteration summary, ERD page, lifecycle page(s), gap pages.
6. **Resolve blocking gaps** before creating task pages.

Gap pages live in `wiki/gaps/<feature-slug>/`. Ready tasks must have no `blocking: true` gaps in `open` or `awaiting-response` state (enforced by lint rule `open-gap-blocking-ready-task`).

---

### 5. Change requests

When a demo, product feedback, or design discovery requires revising an approved artifact:

1. Capture raw notes → `raw/change-requests/<feature-slug>/CR-NNN-<descriptor>.md`.
2. Open a change request page → `wiki/changes/<feature-slug>/CR-NNN.md`.
3. Assess impact; any change to an approved requirement, accepted ADR, or in-progress task requires **human approval** before applying.
4. Supersede (do not edit in place) affected requirements and ADRs. For tasks, create new follow-on task(s) rather than editing a `done` task's body — a done task's description and acceptance criteria are a historical record of what was approved and shipped. Only cancel and replace a task if scope changed so fundamentally the old task should never have existed.
5. Log to `wiki/log.md`.

**Supersession pointers on tasks:** do not set `superseded_by`/`supersedes` at CR-approval time — the old task's behavior is still current until the new task actually ships. Set the pointers only once the new task reaches `status: done`: `superseded_by` on the old task, `supersedes` on the new task, and note the update in the `wiki/log.md` entry.

---

## Agent roles (for Claude Code sessions)

| Role | How it is invoked |
|---|---|
| **Orchestrator** | Default role when this repo is open in Claude Code (no extra role file) |
| **Task runner** | Launched by `scripts/run-task.sh` as a prime agent |
| **Coding agent** | Spawned by the task-runner; implements code in `worktree-set/` |
| **Session code reviewer** | Spawned by the task-runner after a coding session completes |

Role files are in `.claude/agents/`. The orchestrator coordinates work and maintains the wiki; it does not write application code directly.

---

## Code lives inside `worktree-set/`

All application code changes must occur within `worktree-set/`, which contains checked-out clones of every target repository:

```
worktree-set/
├── code-repo-A/      ← such as back-end
├── code-repo-B/      ← such as front-end
└── code-repo-C/      ← such as service
```

## Wiki patterns and motivations

### Sources

Initial inspiration is credited to Andrej Karpathy and his Gist that first described an **[LLM WIKI](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)**.

Equally important is Rohit Ghumare's extension to this LLM-WIKI pattern with the **[LLM WIKI v2](https://gist.github.com/rohitg00/2067ab416f7bbe447c1977edaaa681e2)**

### Motivations

Decomposing agent roles helps to manage their contexts. Per-task coding and review loops improves the output of those agents.

Keeping the context clean, free of contradictions and inconsistencies, helps to keep the agents on-task and applying the acceptance criteria. However, a normal project does not proceed in a straight and logical line; the development requirements and acceptance criteria change as features are developed and iterated upon.
All of the task book-keeping and thought-tracing exists to help agents reconcile the changes and differences between the documents, and to focus on the only instructions that pertain to their task at hand.

# WIKI-SCHEMA.md
## Software Delivery Wiki — Iterative Requirements Analysis Pattern

### Purpose

This schema extends the base LLM Wiki delivery pattern for teams that receive product specifications from a product organization and refine them through iterative planning analysis before implementation.

**Three goals:**
1. Preserve accurate, evolving project knowledge — including the full history of how understanding changed across analysis iterations.
2. Track the iterative requirements analysis process with traceability from raw product spec through ERD and lifecycle analysis to approved, implementation-ready tasks.
3. Turn approved requirements into verified software changes with managed change control for design feedback that arrives after the initial analysis.

---

## Core principles

- `raw/` is append-only evidence. Never edit raw files in place except to fix accidental secrets or corrupt files.
- `wiki/` is curated project knowledge. It may be updated by humans or by agents acting under these rules.
- `state/` is machine-operable control state for queues, leases, manifests, and health signals.
- The system prefers explicit IDs, links, states, and evidence over freeform prose.
- Contradictions must be surfaced and resolved, not silently overwritten.
- A coding session log is not automatically trusted knowledge. Raw execution notes must be promoted before they change approved project truth.
- Agents may automate bookkeeping, but humans approve significant scope, requirement, architecture, and release decisions.
- **Analysis outputs are evidence, not approved truth.** A planning agent's ERD or lifecycle analysis is a raw artifact until reviewed and promoted. It does not override approved requirements or decisions.
- **Change requests must be explicitly captured.** When demos, product feedback, or design discoveries require revision of the data model, lifecycle, or approved requirements, a `CR-###` must be opened before any approved artifact is modified.

---

## Repository layout

```text
project-root/
├── WIKI-SCHEMA.md
├── README.md
├── schemas/
│   ├── session-record.md
│   ├── task.md
│   ├── requirement.md
│   ├── evidence.md
│   ├── analysis-iteration.md        ← new
│   ├── gap.md                       ← new
│   ├── change-request.md            ← new
│   └── promotion-candidate.yaml
│
├── raw/
│   ├── specs/                       ← product team specifications
│   │   └── <feature-slug>/
│   │       ├── v1-original.md       ← as received; never edited after receipt
│   │       └── v2-clarified.md      ← developer-edited for clarity
│   ├── analysis/                    ← raw planning agent outputs
│   │   └── <feature-slug>/
│   │       └── ITER-001-raw.md
│   ├── context-snapshots/           ← application context doc snapshots, one per iteration
│   │   └── <feature-slug>/
│   │       └── ITER-001.md
│   ├── solutioning-snapshots/       ← solutioning doc snapshots, one per iteration
│   │   └── <feature-slug>/
│   │       └── ITER-001.md
│   ├── change-requests/             ← raw change request inputs (demo notes, feedback)
│   │   └── <feature-slug>/
│   │       └── CR-001-demo-notes.md
│   ├── PR-reviews/                  ← pull request review artifacts (AI and human)
│   │   └── <feature-slug>/
│   │       └── YYYY-MM-DD-<repo>-<reviewer>.md
│   ├── requirements/
│   │   ├── interviews/
│   │   ├── notes/
│   │   ├── tickets/
│   │   └── imports/
│   ├── demos/
│   ├── tests/
│   ├── telemetry/
│   ├── coding-sessions/
│   └── assets/
│
├── wiki/
│   ├── index.md
│   ├── log.md
│   ├── overview/
│   ├── requirements/
│   │   ├── functional/
│   │   ├── nonfunctional/
│   │   ├── assumptions/
│   │   ├── constraints/
│   │   └── changes/
│   ├── analysis/                    ← curated analysis outputs per feature  (new)
│   │   └── <feature-slug>/
│   │       ├── index.md             ← all iterations, current ERD pointer, open gap count
│   │       ├── ITER-001.md          ← iteration summary
│   │       ├── erd/
│   │       │   └── ITER-001.md      ← ERD as of this iteration
│   │       └── lifecycles/
│   │           └── ITER-001.md      ← lifecycle analysis as of this iteration
│   ├── gaps/                        ← individual gap tracking (GAP-###)     (new)
│   │   └── <feature-slug>/
│   │       └── GAP-001.md
│   ├── changes/                     ← change request tracking (CR-###)      (new)
│   │   └── <feature-slug>/
│   │       └── CR-001.md
│   ├── domain/                      ← application concept pages (promoted from context doc)
│   ├── architecture/
│   │   ├── components/
│   │   ├── data-model/
│   │   ├── interfaces/
│   │   └── decisions/               ← ADRs, including promoted solutioning decisions
│   ├── diagrams/
│   ├── plans/
│   │   ├── milestones/
│   │   ├── releases/
│   │   └── investigations/
│   ├── tasks/                       ← flat: one file per task; state lives in the `status` frontmatter field, NOT the path
│   │   └── TASK-###-<slug>.md        ← never moves between folders; `status` is the single source of truth
│   ├── evidence/
│   ├── releases/
│   ├── retros/
│   ├── patterns/
│   └── archive/
│
└── state/
    ├── entities/
    ├── relations/
    ├── queues/
    ├── leases/
    └── manifests/
```

---

## New folder semantics

### `raw/specs/`

Product team specification documents, organized by feature slug.

- `v1-original.md` — received from the product team. **Never edited after receipt.**
- `v2-clarified.md` (and higher) — developer-edited: clarified requirements, disambiguated terms, removed irrelevant statements. Increment the version number when the spec changes ahead of a new analysis iteration. Descriptor examples: `v2-clarified`, `v3-scoped`, `v4-post-demo`.

### `raw/analysis/`

Raw output from planning agent runs, one file per iteration: `ITER-NNN-raw.md`. Never modify after saving.

### `raw/context-snapshots/`

Point-in-time copies of the developer's application context document, captured before each planning agent invocation: `ITER-NNN.md`. Enables precise reconstruction of what the planning agent knew at each analysis run.

### `raw/solutioning-snapshots/`

Point-in-time copies of the developer's solutioning document, captured before each planning agent invocation: `ITER-NNN.md`.

### `raw/change-requests/`

Raw inputs that trigger change requests: demo observation notes, product team feedback, design discovery notes. These are evidence only. Structured change request pages live in `wiki/changes/`.

### `wiki/analysis/`

Curated analysis output organized by feature. Each feature subdirectory contains:
- `index.md` — analysis overview: links to all iterations, pointer to current ERD, open gap count.
- `ITER-NNN.md` — iteration summary: what changed from the prior iteration, what was resolved, blocking gaps remaining.
- `erd/ITER-NNN.md` — ERD as of this iteration (Mermaid or structured text).
- `lifecycles/ITER-NNN.md` — lifecycle and state machine analysis as of this iteration.

The latest iteration is current understanding; prior iterations are preserved as history. When a change request triggers re-analysis, a new iteration is created — the existing one is never overwritten.

### `wiki/gaps/`

Individual gap pages (`GAP-###`). Each gap links to the iteration that identified it and the artifact that resolved it.

### `wiki/changes/`

Change request pages (`CR-###`). Opened when demos, product feedback, or design discoveries require revision of an approved artifact. Records impact assessment, approval, and application across all affected artifacts.

### `wiki/domain/`

Application concept pages promoted from the developer's context document. Stable, feature-independent knowledge: model relationships, business rule encodings, shared infrastructure patterns. Standard frontmatter; versioned via normal wiki change control.

---

## Reference conventions

All reference fields in frontmatter must use **full file paths** relative to the repository root. Bare IDs (`ITER-###`, `GAP-###`, `REQ-###`, `CS-###`) are not valid — they require inference to resolve and break when files are renamed or moved.

For this reason `wiki/tasks/` is a **flat directory**: a task's state is recorded only in its `status` frontmatter field, never in its path. A task file's location (`wiki/tasks/TASK-###-<slug>.md`) is therefore stable across its entire lifecycle, so `depends_on` and other references to it stay valid through every state transition. (Encoding state in the path — a per-state subfolder — would move the file on every promotion and invalidate every inbound reference.)

### Simple references

Point to a specific file. Use this for iteration pages, ADRs, session logs, gap pages, and snapshot files:

```yaml
iter_ref: wiki/analysis/error-proofing-validation/ITER-001.md
identified_in: wiki/analysis/error-proofing-validation/ITER-001.md
resolved_in: raw/solutioning-snapshots/error-proofing-validation/ITER-002.md
session_refs:
  - raw/coding-sessions/CS-2026-06-12-001.md
```

### Section references

When a requirement or specification is a named section within a larger document (not a standalone wiki page), use the compound `"SECTION-ID :: path/to/file.md"` format:

```yaml
requirement_refs:
  - "SF1-REQ-01 :: raw/specs/error-proofing-validation/Spec_Error_Proofing_Validation_v3-operator-reference.md"
  - "SF1-REQ-02 :: raw/specs/error-proofing-validation/Spec_Error_Proofing_Validation_v3-operator-reference.md"
```

When a requirement has been promoted to its own wiki page, use a plain path instead:

```yaml
requirement_refs:
  - wiki/requirements/functional/REQ-001.md
```

### What `::` means

The `::` separator means "section ID within file". Everything before `::` is the section anchor; everything after is the file path. No file path will ever contain `::`, so the split is unambiguous.

---

## Canonical entity types

All existing types from the base pattern, plus:

| Type | ID Format | Description |
|---|---|---|
| Analysis iteration | `ITER-###` | One planning agent run and its curated outputs |
| Gap | `GAP-###` | Open question or missing detail from analysis |
| Change request | `CR-###` | Approved revision to data model, lifecycle, or requirements triggered by feedback |
| PR review | `PR-REVIEW-YYYY-MM-DD-NNN` | Pull request review artifact (AI or human); triaged via the PR review intake workflow |

---

## Frontmatter additions

### Task page — additional fields

```yaml
iter_ref: ITER-###   # analysis iteration used as the basis for task breakdown

revision_notes: |
  # Optional. Set by the human when rejecting a promotion candidate and returning
  # a task to ready for a targeted fix session. Describes the specific issues found
  # during testing or review that must be resolved before the task can be approved.
  # Cleared (set to empty string) when the revision session is successfully reviewed
  # and a new promotion candidate is created.
  #
  # The task runner detects revision sessions by the presence of this field alongside
  # existing session_refs. It bundles both into the coding agent context.
```

### Decision (ADR) page — additional field

```yaml
solutioning_snapshot_ref: raw/solutioning-snapshots/<feature>/ITER-NNN.md
# path to the solutioning snapshot from which this ADR was promoted, if applicable
```

---

## State machines

### Gap

```
open -> awaiting-response -> resolved
     \-> deferred
     \-> superseded
```

- `open` — identified; routing not yet determined
- `awaiting-response` — sent to product team or decision maker; no internal resolution possible
- `resolved` — addressed by product team response, developer decision, or context addition
- `deferred` — acknowledged; does not block current iteration or task breakdown
- `superseded` — made irrelevant by a change request or scope change

### Change request

```
open -> assessing -> awaiting-approval -> approved -> applying -> applied -> closed
                                       \-> rejected
```

---

## Workflows

### Analysis iteration workflow

**Trigger:** new feature begins, or a change request triggers re-analysis.

**Steps:**

1. **Prepare source documents**
   - Receive and save spec to `raw/specs/<feature-slug>/v1-original.md`. Do not edit.
   - Create `v2-clarified.md` (or higher) for developer edits. Increment version when spec changes before a new iteration.
   - Update the application context document with any new application knowledge relevant to this feature.
   - Update the solutioning document with any early architectural decisions.

2. **Snapshot before invoking the planning agent**
   - Determine next iteration number.
   - Copy current application context document → `raw/context-snapshots/<feature-slug>/ITER-NNN.md`.
   - Copy current solutioning document → `raw/solutioning-snapshots/<feature-slug>/ITER-NNN.md`.

3. **Invoke planning agent**
   - Provide: current spec version, context snapshot, solutioning snapshot.
   - Planning agent produces: ERD, lifecycle analyses, gap list.
   - Save raw output → `raw/analysis/<feature-slug>/ITER-NNN-raw.md`.

4. **Create curated wiki artifacts**
   - Create iteration summary: `wiki/analysis/<feature-slug>/ITER-NNN.md`.
   - Create ERD page: `wiki/analysis/<feature-slug>/erd/ITER-NNN.md`.
   - Create lifecycle page(s): `wiki/analysis/<feature-slug>/lifecycles/ITER-NNN.md`.
   - For each gap: create `wiki/gaps/<feature-slug>/GAP-NNN.md` with `status: open`.
   - Update `wiki/analysis/<feature-slug>/index.md`.

5. **Resolve gaps**
   - For each `blocking: true` gap, route to the appropriate resolver:
     - **Product team** → set `status: awaiting-response`; add to the question list for the product team.
     - **Application context** → add information to the context document; set `status: resolved`, `resolution_source: application-context`.
     - **Developer decision** → add to solutioning document; if significant, promote immediately to `ADR-###`; set `status: resolved`, `resolution_source: developer-decision`.
   - Non-blocking gaps may be `deferred` if they do not affect task breakdown.

6. **Iterate**
   - When product team responses arrive, update the relevant gap pages.
   - If new questions arise from the responses, return to step 2 for a new iteration.
   - Mark resolved gaps with `resolved_in: ITER-NNN` pointing to the iteration where resolution was confirmed.

7. **Task breakdown**
   - When no `blocking: true` gaps remain: prompt for task breakdown.
   - Create task pages in `wiki/tasks/` with `status: draft`, linked to the final analysis iteration (`iter_ref`) and approved requirements.

8. **Log**
   - Append to `wiki/log.md`: date, ITER-ID, feature, gaps identified, gaps resolved, blocking gaps remaining.

---

### Gap management workflow

**Trigger:** gap identified during an analysis iteration.

1. Create `wiki/gaps/<feature-slug>/GAP-NNN.md`, `status: open`.
2. Set `gap_type` and `blocking: true/false`.
3. Route:
   - Product team → `status: awaiting-response`.
   - Developer decision → resolve via solutioning/ADR; `status: resolved`.
   - Application context → add to context doc; `status: resolved`.
   - Cannot resolve now → `status: deferred`.
4. On resolution: set `resolved_in` and `resolution_source`. Update the owning iteration's `gaps_resolved` list.

---

### Change request workflow

**Trigger:** demo observation, product team feedback, or design discovery requires revision of an approved artifact.

1. **Capture** raw input → `raw/change-requests/<feature-slug>/CR-NNN-<descriptor>.md`.
2. **Open** `wiki/changes/<feature-slug>/CR-NNN.md`, `status: open`.
3. **Assess impact**: identify affected artifacts in `affected_artifacts`; set `impact_scope`.
4. **Approval gate**: any change to an approved requirement, accepted ADR, or in-progress task requires human approval. Set `status: awaiting-approval` and request human review.
5. **Apply** (once approved):
   - Requirements: create a superseding version; set `superseded_by` on the old page. Do not edit the approved page in place.
   - ADRs: create a new `ADR-###`; set the old ADR `status: superseded` and `superseded_by: ADR-NNN`. Do not edit an accepted ADR in place.
   - Tasks: create new follow-on task(s) for the changed behavior — do not edit a `done` task's description, context, or acceptance criteria in place. A done task's body is a historical record of what was approved and shipped at the time it ran; rewriting it to match the new behavior destroys that record. Cancel and replace only if scope changed so fundamentally the old task should never have existed; set such tasks to `status: cancelled` (they stay in `wiki/tasks/`).
   - **Supersession pointer timing**: do not set `superseded_by` on the old task (or `supersedes` on the new task) at CR-approval time — the superseding work hasn't shipped yet, and if the new task fails, is revised, or is cancelled, the old task's behavior is still the real, current behavior. Set the pointers only when the new task is promoted to `done`: at that point set `superseded_by: <path-to-new-task>` on the old task and `supersedes: <path-to-old-task>` on the new task, and note the pointer update in the promotion's `wiki/log.md` entry. Until that point, the CR page itself (`wiki/changes/<feature-slug>/CR-NNN.md`) is the only record that a change is in flight.
   - Analysis artifacts: mark the prior iteration/ERD as superseded; trigger a new analysis iteration.
6. **Re-analysis**: if `impact_scope` includes `data-model` or `lifecycle`, return to step 2 of the analysis iteration workflow. Set `iter_triggered` on the change request.
7. **Log**: date, CR-ID, feature, artifact count affected, approver.
8. **Close**: `status: closed` when all follow-on actions are complete.

---

### PR review intake workflow

**Trigger:** a PR review arrives — AI-generated local review or human GitHub review.

**Steps:**

1. **Store the raw artifact** in `raw/PR-reviews/<feature-slug>/`. AI reviews are saved as Markdown directly. GitHub export JSON is wrapped in a `.md` file (frontmatter + `## Raw Comments` section with the JSON in a fenced code block); the source `.json` is not retained.
2. **Add frontmatter** — populate `id` (`PR-REVIEW-YYYY-MM-DD-NNN`), `date`, `repo`, `branch`, `reviewer`, `reviewer_type`, `task_refs`, `status: raw`. This initialization is the only exception to the `raw/` append-only rule; after frontmatter is added, the file is append-only.
3. **Triage** — for each comment or finding:
   - **Is it valid?** Check against the task spec, approved ADRs, and the feature ERD. AI reviewers may flag correct behavior as a bug due to naming conventions or missing domain context; verify before acting.
   - **Is it actionable?** Observational comments and questions without a specific ask are closed without action.
   - **What is the recommended action?** Close (no issue), follow-up task, or decision record (ADR).
4. **Dispatch** — create ADRs or tasks as warranted; reference the `PR-REVIEW-###` ID in the artifact's `source_refs`.
5. **Append triage** — add a `## Triage` section to the review file recording per-comment disposition; set `status: triaged` (actions dispatched) or `status: closed` (no action needed).
6. **Log** — append to `wiki/log.md`: date, PR-REVIEW-ID, feature, finding count, actions dispatched.

---

### Task revision workflow

**Trigger:** A human reviews `in-review` work and finds issues that block approval of the promotion candidate.

**Steps:**

1. **Human rejects the promotion candidate** — set `status: withdrawn` on the candidate in `state/queues/promotion-candidates/PROMO-YYYY-MM-DD-###.yaml`.
2. **Human adds revision notes to the task** — set `revision_notes` in the task frontmatter describing the specific issues that must be fixed. Set `status: ready` (the file stays put in `wiki/tasks/`), update `updated`, and clear the `lease` block.
3. **Task runner detects a revision session** — when a `ready` task has both `revision_notes` and existing `session_refs`, the task runner treats the new session as a **revision session**. In addition to the standard context bundle, it includes:
   - All prior session logs from `session_refs`.
   - Evidence documents from prior reviews (EVID-NNN pages linked from prior sessions).
   - The `revision_notes` text, explicitly flagged to the coding agent as the fix scope.
4. **Coding agent implements targeted fixes** — scoped to the issues named in `revision_notes`. The agent does not re-implement the full task; it addresses the specific defects and records what changed from the prior session in the session narrative.
5. **Session completes** — task moves to `in-review`. The new session ID is appended to `session_refs`. The task runner creates a new promotion candidate.
6. **Reviewer re-evaluates** — creates a new evidence document (EVID-NNN) that supersedes the prior review. The reviewer explicitly confirms that each item in `revision_notes` is resolved.
7. **New promotion candidate** replaces the prior (withdrawn) candidate. If the review passes, `revision_notes` is cleared on promotion to `done`.

**Invariant:** The prior session log and evidence document are preserved. They remain in `session_refs` and `raw/coding-sessions/` as the historical record of the first attempt.

---

### Ingest, query, lint, and promotion workflows

These follow the base wiki pattern. Additional lint rules for the analysis process:

| Rule | Severity | Condition |
|---|---|---|
| `iter-without-erd` | error | Analysis iteration page has no `erd_ref` |
| `iter-without-lifecycle` | error | Analysis iteration page has no `lifecycle_refs` |
| `iter-without-snapshots` | error | Iteration missing `context_snapshot_ref` or `solutioning_snapshot_ref` |
| `open-gap-blocking-ready-task` | error | Ready task's feature has a `blocking: true` gap in `open` or `awaiting-response` |
| `cr-open-blocking-task` | error | Ready or in-progress task is in `affected_artifacts` of an `open`/`assessing`/`awaiting-approval` CR |
| `approved-artifact-modified-without-cr` | error | Approved requirement or accepted ADR was changed with no `CR-###` |
| `task-without-iter` | warning | Ready task under an analysis-managed feature has no `iter_ref` |
| `stale-iter-with-open-gaps` | warning | Iteration older than 30 days still has `blocking_gaps` entries and has not been updated |
| `gap-resolved-without-resolved-in` | error | Gap has `status: resolved` but `resolved_in` is empty |
| `revision-notes-on-done-task` | warning | Task has `status: done` but `revision_notes` is still set — should have been cleared on promotion |
| `superseding-task-missing-pointer` | warning | A task's `supersedes` list names another task, both are `status: done`, but the named (older) task's `superseded_by` does not point back — pointer update from the change-request Apply step was missed |

---

## Decomposition guide: context and solutioning documents

Both the application context document and the solutioning document are developer-owned working files that evolve across analysis iterations. Without explicit versioning, it is unclear what context the planning agent had during any given run, and changes made under a change request are difficult to trace.

### Problem summary

| Document | Problem |
|---|---|
| `relevant-application-information.md` | Grows organically; no history; unclear what the planning agent saw at each iteration |
| `Solutioning.md` | Decisions and exploratory notes mixed together; decisions revised in place without record |

### Application context document: recommended approach

**Keep one working document per project** (not per feature). Optimize it for editing speed, not archival quality. Add context freely as you discover relevant application knowledge.

**Snapshot before every analysis run.** Before invoking the planning agent, copy the current working document to `raw/context-snapshots/<feature-slug>/ITER-NNN.md`. This snapshot is the hard record of exactly what the agent had. Never modify a saved snapshot.

**Promote stable knowledge to `wiki/domain/`.** When a section describes a stable, feature-independent application concept that will matter for multiple features (e.g., how `ShiftProfile` generates `Shift` records, how role-based permissions associate to domain actions), promote it to a page in `wiki/domain/`. That page then has its own frontmatter, version history, and confidence score. The working document can reference the wiki page rather than duplicating the explanation.

**Decompose by topic, not by feature.** Good topics for promoted pages: model relationships, business rule encodings, external integration patterns, shared infrastructure. A topic page lets the planning agent be pointed to exactly the relevant context without loading unrelated content.

**Practical rules:**
- Add to the working document freely — zero cost.
- Snapshot before every analysis run — mandatory.
- Promote when a concept spans more than one feature or when it is stable enough to be referenced without re-reading the working document.
- Once promoted, the working document section can be replaced with a link to the wiki page.

### Solutioning document: recommended approach

**Keep one working solutioning document per feature.** Start it before the first analysis iteration. Use it as a scratchpad: exploratory notes, alternatives still under consideration, decisions pending product team input all belong here. Do not try to keep it clean — that is the ADR's job.

**Snapshot before every analysis run.** Copy the current solutioning document to `raw/solutioning-snapshots/<feature-slug>/ITER-NNN.md`.

**Promote committed decisions to `ADR-###` pages immediately.** When a decision is committed — meaning you have chosen an approach and would need a change request to revise it — promote it immediately to `wiki/architecture/decisions/ADR-NNN.md`. Do not wait until the end of the feature. An ADR promoted from solutioning should include:

| Field | Content |
|---|---|
| Decision | Concise statement of what was chosen |
| Context | Options considered, constraints, the gap or question that forced the decision |
| Rationale | Why this option over alternatives |
| Status | `accepted` |
| `solutioning_snapshot_ref` | Path to the snapshot where this decision first appeared |
| Links to `GAP-###` | Any gaps resolved by this decision |

**What stays in `Solutioning.md`:** anything not yet committed. The working document is a thinking surface; ADRs are the knowledge layer.

**Change request integration.** When a change request revises an architectural decision:
1. Set the existing ADR `status: superseded` and `superseded_by: ADR-NNN`.
2. Create a new `ADR-NNN` with `supersedes: ADR-MMM` and `triggered_by: CR-NNN`.
3. Update the working `Solutioning.md` to reflect the current decision.
4. Never edit an accepted ADR in place — the supersession chain is the record of how the decision evolved.

**Practical rules:**
- Solutioning document = editing surface. ADR = knowledge layer.
- Promote to ADR when you commit — not when you are still exploring.
- Snapshot before every analysis run — mandatory.
- Use the ADR supersession chain as the authoritative record of decision evolution across change requests.

---

## Logging additions

Append to `wiki/log.md` for:
- **Analysis iteration runs**: date, ITER-ID, feature, gaps identified, gaps resolved, blocking gaps remaining.
- **Change request applications**: date, CR-ID, feature, artifact count affected, approver.
- **PR review triage**: date, PR-REVIEW-ID, feature, finding count, actions dispatched.

(All other logging follows the base pattern.)

---

## Operating rhythm additions

| Cadence | Action |
|---|---|
| Every analysis iteration | Snapshot source docs; save raw output; create wiki artifacts; update gap pages; log |
| After each gap resolution batch | Update gap pages; update iteration `blocking_gaps`; run scoped lint |
| When a change request is opened | Assess impact before any further development on affected tasks |

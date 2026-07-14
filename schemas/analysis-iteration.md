---
id: ITER-###
title: "Analysis Iteration ### — <Feature Name>"
type: analysis-iteration
status: draft              # draft | current | superseded
created: YYYY-MM-DD
updated: YYYY-MM-DD
owner: developer-name
source_refs:
  - raw/specs/<feature-slug>/vN-clarified.md
  - raw/analysis/<feature-slug>/ITER-NNN-raw.md
related: []
confidence: 0.70
supersedes: []
superseded_by: []
# Analysis iteration fields
feature_ref: <feature-slug>
iteration_number: 1
spec_version: vN-clarified
context_snapshot_ref: raw/context-snapshots/<feature-slug>/ITER-NNN.md
solutioning_snapshot_ref: raw/solutioning-snapshots/<feature-slug>/ITER-NNN.md
raw_analysis_ref: raw/analysis/<feature-slug>/ITER-NNN-raw.md
erd_ref: wiki/analysis/<feature-slug>/erd/ITER-NNN.md
lifecycle_refs:
  - wiki/analysis/<feature-slug>/lifecycles/ITER-NNN.md
gaps_identified: []        # full paths to GAP pages first surfaced in this iteration (e.g. wiki/gaps/<slug>/GAP-NNN.md)
gaps_resolved: []          # full paths to GAP pages resolved before this iteration ran
blocking_gaps: []          # full paths to GAP pages that are open and block task breakdown
change_requests_ref: []    # full paths to CR pages that triggered or relate to this iteration (e.g. wiki/changes/<slug>/CR-NNN.md)
---

## Summary

_What prompted this analysis run (first iteration, gap responses received, change request triggered re-analysis). What changed from the previous iteration._

## Key findings

_Top 3–5 findings: new entities proposed, lifecycle decisions confirmed, contradictions identified, significant constraints surfaced._

## Source documents used

| Document | Version / Snapshot |
|---|---|
| Product spec | vN-clarified |
| Application context | ITER-NNN snapshot |
| Solutioning | ITER-NNN snapshot |

## Gaps identified this iteration

_New `GAP-###` items surfaced by this analysis run. One-line summary for each._

| ID | Summary | Blocking | Status |
|---|---|---|---|
| GAP-### | ... | yes/no | open |

## Gaps resolved before this iteration

_`GAP-###` items resolved by responses or decisions made since the previous iteration._

| ID | Summary | Resolution source |
|---|---|---|
| GAP-### | ... | product-team / developer-decision / application-context |

## Blocking gaps remaining

_`GAP-###` items that must be resolved before task breakdown can proceed._

| ID | Summary | Awaiting |
|---|---|---|
| GAP-### | ... | product team / developer decision |

---
id: CR-###
title: "<Short description of the change>"
type: change-request
status: open               # open | assessing | awaiting-approval | approved | applying | applied | closed | rejected
created: YYYY-MM-DD
updated: YYYY-MM-DD
owner: developer-name
source_refs:
  - raw/change-requests/<feature-slug>/CR-NNN-<descriptor>.md
related: []
confidence: 0.80
supersedes: []
superseded_by: []
# Change request fields
feature_ref: <feature-slug>
trigger: demo-feedback     # demo-feedback | product-team | design-discovery | implementation-finding
trigger_ref: raw/change-requests/<feature-slug>/CR-NNN-<descriptor>.md
impact_scope: []           # any of: data-model | lifecycle | requirements | tasks | erd
affected_artifacts: []     # REQ-###, ADR-###, TASK-###, ITER-### IDs affected
approval_required: true
approved_by: ""
approved_at: ""
applied_at: ""
iter_triggered: ""         # ITER-### of the re-analysis iteration triggered by this CR, if any
---

## Change description

_What is being changed and why. Be specific: which model attributes, lifecycle transitions, or requirements are affected._

## Trigger

_Description of the demo, feedback session, or discovery that triggered this change request. Link to raw notes in `raw/change-requests/`._

## Impact assessment

_Which artifacts are affected and how._

| Artifact | Current state | Required change |
|---|---|---|
| REQ-### | ... | ... |
| ADR-### | ... | ... |
| TASK-### | ... | ... |

## Decision

_What was decided. Who approved it. Rationale for the change._

## Application log

_Running record of each change applied, appended as actions are taken._

- `YYYY-MM-DD` — [Artifact ID]: [What changed]

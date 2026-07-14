---
id: GAP-###
title: "<Short description of the gap or question>"
type: gap
status: open               # open | awaiting-response | resolved | deferred | superseded
created: YYYY-MM-DD
updated: YYYY-MM-DD
owner: developer-name
source_refs:
  - raw/analysis/<feature-slug>/ITER-NNN-raw.md
related: []
confidence: 0.70
supersedes: []
superseded_by: []
# Gap fields
feature_ref: <feature-slug>
identified_in: wiki/analysis/<feature-slug>/ITER-NNN.md
gap_type: missing-requirement
# gap_type options:
#   missing-requirement   — spec does not define required behaviour
#   ambiguity             — spec uses a term or rule that could be interpreted multiple ways
#   contradiction         — two sources state incompatible things
#   design-question       — no spec gap, but a technical/architectural decision is needed
#   data-model-gap        — proposed model is missing an attribute, relationship, or constraint
#   lifecycle-gap         — state machine is incomplete or has undefined transitions
#   external-dependency   — requires clarification from an external team or system
blocking: true
resolution: ""             # filled in when resolved
resolved_in: ""            # full path to the page or file that resolved this gap (e.g. wiki/analysis/<slug>/ITER-NNN.md, wiki/architecture/decisions/ADR-NNN.md, raw/solutioning-snapshots/<slug>/ITER-NNN.md)
resolution_source: ""      # product-team | developer-decision | application-context | deferred
---

## Description

_Clear description of the gap: what is unknown, ambiguous, or missing. Quote the relevant spec text if applicable._

## Impact

_What cannot be decided or implemented until this gap is resolved. Which tasks or ADRs are blocked._

## Resolution

_Empty until resolved. Describe what was decided or learned, and why._

## Context

_Relevant spec excerpt, analysis note, or background that surfaced this gap._

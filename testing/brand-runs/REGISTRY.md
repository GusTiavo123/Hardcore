# Brand Runs Registry

Catalog of executed Brand runs. Updated per run (append-only, chronological).

Each entry:
- **Run ID**: `{date}_{machine}_{idea-id}`
- **Profile**: brand profile classified
- **Archetype**: chosen
- **Mode**: normal | fast | extend | resume
- **Gate outcome**: `9/9 passed` | `halted_at_G{N}` | `accepted_with_flags`
- **Shipping**: founder verdict (yes | yes-with-adjustments | no)
- **Notes**: one-line observation

---

## Runs

_(No runs yet. Add entries below as runs complete.)_

<!-- Example entry format:

### 2026-05-01 — brand-test-b2b-smb (desktop-gusta)
- Run ID: `2026-05-01_desktop-gusta_brand-test-b2b-smb`
- Profile: b2b-smb (confidence 0.92)
- Archetype: Sage
- Mode: normal
- Gate outcome: 9/9 passed
- Shipping: yes-with-adjustments
- Notes: voice drift in FAQ — flagged for /brand:extend verbal

-->

---

## Registry conventions

- **Date**: ISO (`YYYY-MM-DD`).
- **Machine**: identifier agreed with user (`desktop-gusta`, `laptop-xyz`, etc.).
- **Idea ID**: from `testing/brand-suite.yaml` if suite idea; otherwise a descriptive slug.
- **Sort order**: oldest first (append new at bottom).
- Link each entry to its run directory `testing/brand-runs/{run-id}/`.

## Aggregation

Cross-run patterns aggregate to `testing/analysis/brand-coverage.md`. Review the coverage file periodically (every ~5 runs or when planning iteration).

# Brand Module — Coverage Analysis

Aggregated analysis across Brand runs. Updated as runs accumulate. Plain-language observations, not scores.

Read this file when planning iteration of the Brand module (SKILL.md updates, new edge cases, gate tuning).

---

## Profiles tested

Which canonical brand profiles from `testing/brand-suite.yaml` have at least one committed run.

| Profile | Runs | First run | Latest run | Status |
|---|---|---|---|---|
| b2b-enterprise | 0 | — | — | pending |
| b2b-smb | 0 | — | — | pending (dogfooding subset) |
| b2d-devtool | 0 | — | — | pending |
| b2c-consumer-app | 0 | — | — | pending (dogfooding subset) |
| b2c-consumer-web | 0 | — | — | pending |
| b2local-service | 0 | — | — | pending (dogfooding subset) |
| content-media | 0 | — | — | pending |
| community-movement | 0 | — | — | pending |

---

## Failure modes (cumulative)

Plain-language patterns observed across runs. Accumulate here; DO NOT delete entries (history is the signal).

_(No runs yet — section will populate.)_

Format for each entry:
```
### {pattern name}
- **Observed in**: {run IDs}
- **Pattern**: {plain-language description}
- **Affected dept(s)**: {list}
- **Current mitigation**: {none | partial | full}
- **Proposed iteration**: {what to change in SKILL.md / references}
```

---

## What consistently works

Patterns that pass cleanly across multiple runs. Useful as confidence anchors + as hypotheses about where the module has strong signal.

_(No runs yet.)_

---

## Variance observations

Run-to-run consistency for the same-profile inputs. Not a gate, but useful signal.

| Dimension | Consistency level | Notes |
|---|---|---|
| Archetype selection (same input, 2 runs) | pending | |
| Palette family (same input, 2 runs) | pending | |
| Logo form language (same input, 2 runs) | pending | |
| Voice attributes overlap (≥3 shared) | pending | |
| Brand values overlap (≥2 shared) | pending | |

---

## Coverage gaps

Missing tests, scenarios not exercised, failure modes not yet tested.

- [ ] 5 non-dogfooding profiles untested (run when real cases appear or full coverage pass)
- [ ] Coherence gate injection scenarios not yet built (deferred per plan §14.9 — post-dogfooding)
- [ ] Claude Design compatibility not yet tested for any profile
- [ ] No runs with profile absent vs. profile present comparison (A/B for same idea)
- [ ] No extended-mode (`/brand:extend`) runs logged yet
- [ ] No resume-mode runs logged yet

---

## Module iteration backlog

Derived from `human-review.md` "Module iteration notes" across runs.

_(Empty — will populate from reviews.)_

Prioritization notes:
- Iterate on SKILL.md content when ≥2 reviews flag the same pattern
- Iterate on shared references (archetype-guide, brand-profiles, coherence-rules) only with strong signal (≥3 reviews)
- Prefer inline SKILL.md changes over new reference files (per `21-file-structure.md` minimalism principle)

---

## Meta-observations

Observations about the testing process itself — what's hard to automate, what's surprisingly consistent, what Claude Design compatibility has revealed.

_(Empty — will populate as runs accumulate.)_

# Testing Protocol — Idea Validation Pipeline

## Purpose

Validate that the pipeline produces correct, complete, and reproducible results across machines before moving to Phase 3 (Hardening) and the Idea Loop.

## What We're Testing

This pipeline has no "code" to unit test — the departments are AI agents reading SKILL.md files. Testing means running real ideas through the pipeline and verifying:

1. **Execution**: All 6 departments complete without errors
2. **Schema completeness**: Every `data` field defined in SKILL.md is present in output
3. **Scoring correctness**: Sub-scores sum to totals, weighted score arithmetic is exact
4. **Verdict correctness**: The verdict matches expectations for the idea type
5. **Evidence quality**: All evidence has real URLs, no `llm-knowledge` sources
6. **Persistence**: Engram artifacts are recoverable after the run
7. **Reproducibility**: Same idea on different machines produces scores within ±5 variance

## Test Suite

`suite.yaml` defines 10 curated ideas with expected outcomes:

| Type | Count | Coverage |
|------|-------|----------|
| GO | 3 | devtools SaaS, LATAM fintech, e-commerce |
| NO-GO | 3 | Problem knockout, Market knockout, Risk knockout |
| PIVOT | 4 | EdTech regulation, LATAM marketplace, crypto regulation, restaurant SaaS |

The suite covers:
- English and Spanish ideas (tests query language strategy)
- B2B and B2C
- SaaS, marketplace, and platform models
- US/global and LATAM-specific markets
- Light and heavy regulatory environments

## Running a Test

### Prerequisites

1. Repo cloned and `bash scripts/setup.sh` completed
2. Engram MCP server running (verify: the pipeline checks this at startup)
3. Web search MCP available (open-websearch)

### Steps

1. **Pick an idea** from `suite.yaml`. Start with `priority: high` ideas.

2. **Run the pipeline** in fast mode:
   ```
   validación rápida: {paste the idea text from suite.yaml}
   ```

3. **When the pipeline completes**, the orchestrator shows the verdict and scores. Before closing the conversation, run the export:
   ```
   Export the results of this validation to testing/runs/ following the testing protocol.
   ```
   The orchestrator will create the run directory and files.

4. **Verify** using the post-run checklist (see below).

5. **Commit** the run results to git so they're available for cross-machine comparison.

### Export Convention

Each run is stored in:
```
testing/runs/{YYYY-MM-DD}_{machine}_{idea-id}/
├── verdict.yaml       # Quick-reference: scores, verdict, pass/fail
├── problem.json       # Full output envelope
├── market.json
├── competitive.json
├── bizmodel.json
├── risk.json
└── synthesis.json
```

**`machine` identifier**: Use a short, stable name for each machine (e.g., `desktop`, `laptop`, `office`). Set it once and reuse it. This enables cross-machine variance analysis.

### `verdict.yaml` Schema

```yaml
# Auto-generated after each pipeline run
idea_id: "go-api-docs-devtools"          # From suite.yaml
machine: "desktop"                        # Your machine identifier
date: "2026-03-20"
mode: "fast"
engram_session_id: "validation-api-docs-devtools-2026-03-20"

scores:
  problem: 78
  market: 72
  competitive: 65
  bizmodel: 80
  risk: 68
weighted: 73.5
verdict: "GO"

# Validation against suite expectations
expected_verdict: "GO"
verdict_match: true                       # verdict == expected_verdict
score_in_range: true                      # weighted within expected_score_range
expected_knockouts: []
actual_knockouts: []
knockout_match: true                      # actual == expected

# Quality checks
all_departments_completed: true           # All 6 returned status ok/warning
schema_complete: true                     # All data fields present per SKILL.md
envelope_valid: true                      # All 10 envelope fields present, status enum valid
arithmetic_verified: true                 # Sub-scores sum correctly
evidence_populated: true                  # Every dept evidence[] has ≥3 entries (not empty)
evidence_has_urls: true                   # No source: "llm-knowledge", all sources are real URLs
engram_persisted: true                    # mem_search finds all 6 dept artifacts

# Overall
pass: true                               # All checks passed
notes: ""                                 # Any observations
```

## Post-Run Checklist

After each run, verify these before committing:

### Execution
- [ ] All 6 departments returned `status: "ok"` or `status: "warning"`
- [ ] No department returned `status: "failed"` or `status: "blocked"`
- [ ] Pipeline completed end-to-end (Synthesis produced a verdict)

### Schema Completeness
- [ ] `problem.json` → `data` has all 11 fields from hc-problem/SKILL.md (including `demand_stack` and `solution_category_demand` in sub_scores)
- [ ] `market.json` → `data` has all 10 fields (tam, sam, som objects + 7 others)
- [ ] `competitive.json` → `data` has all 9 fields (3 competitor arrays + failed + gaps + benchmark + queries + sub_scores + competitive_score); direct_competitors include `moat_type` and `vulnerability_signals`
- [ ] `bizmodel.json` → `data` has all 10 fields (model + pricing + unit_economics + sensitivity + precedents + assumptions + scores)
- [ ] `risk.json` → `data` has all 7 fields (risks array + dependencies + overall + killers + queries + scores)
- [ ] `synthesis.json` → `data` has all 13 fields (verdict through department_flags)

### Envelope Integrity
- [ ] Every department JSON has ALL 11 required envelope fields: `schema_version`, `status`, `department`, `executive_summary`, `score`, `score_reasoning`, `data`, `evidence`, `artifacts`, `flags`, `next_recommended`
- [ ] Every `status` value is one of: `ok | warning | blocked | failed` (not "complete" or other non-standard values)
- [ ] Every `score` is an integer 0-100
- [ ] Every `score_reasoning` is a non-empty structured breakdown (not prose)

### Scoring
- [ ] Each department's `data.{dept}_score` == envelope `score`
- [ ] Each department's sub-scores sum to the total score
- [ ] Synthesis `weighted_score` arithmetic is correct: `(P×.30)+(M×.25)+(C×.15)+(B×.20)+(R×.10)`
- [ ] Knockout rules applied correctly (check against `scoring-convention.md`)
- [ ] Verdict follows GO/PIVOT/NO-GO decision tree exactly

### Evidence Quality
- [ ] Every department's `evidence[]` array has ≥3 entries (not empty)
- [ ] No evidence item has `source: "llm-knowledge"`
- [ ] Every evidence item has a non-empty `source` URL
- [ ] Every competitor in `direct_competitors[]` has a real URL
- [ ] Market data cites institutional sources with years

### Persistence
- [ ] Engram: `mem_search("validation/{slug}/problem")` returns the artifact
- [ ] Engram: `mem_search("validation/{slug}/report")` returns the final report
- [ ] Engram session was closed (`mem_session_end`)

### Verdict Match
- [ ] Verdict matches `expected_verdict` from `suite.yaml`
- [ ] If mismatch: is the pipeline wrong, or is the expectation wrong? Document in `notes`
- [ ] Weighted score falls within `expected_score_range` (if defined)
- [ ] Expected knockouts match actual knockouts

## Cross-Machine Variance Analysis

After running the same idea on 2+ machines:

1. Compare `verdict.yaml` files across machines
2. Per-department score delta should be **≤ 5 points** (acceptable variance from web search timing)
3. Verdict should be **identical** (same GO/PIVOT/NO-GO)
4. If variance > 5 on any department: investigate which sub-dimension diverges and whether search results differed significantly

Record findings in `testing/analysis/`:
```
testing/analysis/{idea-id}-variance.md
```

## Phase Gates

### Phase 2 → Phase 3 (Minimum)
- [ ] At least 5 ideas run successfully (2 GO, 1 NO-GO, 2 PIVOT)
- [ ] All 5 pass the checklist above
- [ ] At least 1 idea run on 2 different machines with ≤5pt variance
- [ ] Zero `status: "failed"` results (web search works reliably)

### Phase 3 → Idea Loop (Full)
- [ ] All 10 ideas from suite.yaml run and committed
- [ ] At least 3 ideas run on 2+ machines with variance data
- [ ] Verdict accuracy ≥ 80% against suite expectations
- [ ] No systematic schema issues (Output Assembly Checklist working)
- [ ] Calibration scenarios (calibration/scenarios.md) updated with real run data

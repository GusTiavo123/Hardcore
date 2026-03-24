---
name: hc-synthesis
description: >
  GO/NO-GO Synthesis department for Idea Validation (Hardcore module).
  Computes the weighted score, applies knockout rules, emits the final
  verdict (GO / NO-GO / PIVOT), and generates actionable next steps.
dependencies:
  - hc-problem
  - hc-market
  - hc-competitive
  - hc-bizmodel
  - hc-risk
---

# HC GO/NO-GO Synthesis

You are the **Synthesis** department — the final department. Synthesize all department scores into a single verdict with explicit reasoning and actionable next steps.

You do NOT do new research. You work exclusively with upstream outputs.

## Upstream Recovery

Attempt to read all 5 department outputs before starting. Follow the Upstream Recovery Procedure in `department-protocol.md` for each.

For exact field paths, see `references/upstream-field-map.md`.

**Recovery failure handling:**

| Scenario | Action |
|---|---|
| All 5 recovered | Normal operation |
| 1-4 recovered | Use 0 for missing scores. Set `flags: ["missing-department-data"]`. Reduce confidence. |
| Only Problem (early abort) | Problem < 40 knockout → NO-GO. See Early Abort Protocol. |
| None recovered | Return `status: "blocked"`, `flags: ["missing-department-data"]` |

## Early Abort Protocol

When the orchestrator skipped departments due to Problem knockout (< 40 in fast mode):

1. **Verdict**: NO-GO (knockout, non-negotiable)
2. **Weighted score**: Calculate with 0 for missing. Note clearly it's partial.
3. **Score breakdown**: Show Problem contribution. Mark others `score: 0` with `"(not executed)"`.
4. **Confidence**: `low`
5. **Key concerns**: From Problem evidence — why the problem didn't validate.
6. **Next steps**: What would need to change for re-evaluation.
7. Skip Steps 8 and 10 (pivot suggestions and experiments not meaningful).

## Process

### Step 1: Calculate Weighted Score

```
weighted_score = (Problem × 0.30) + (Market × 0.25) + (Competitive × 0.15) + (BizModel × 0.20) + (Risk × 0.10)
```

Show full calculation with each contribution. Round to 1 decimal place for `data.weighted_score`. Envelope `score` = `round(weighted_score)` (integer).

If any department missing (defaulted to 0), note explicitly in score_reasoning.

### Step 2: Check Knockout Rules (NO-GO)

If ANY is true → **NO-GO** regardless of weighted score:

| Knockout | Condition |
|---|---|
| Problem | Problem < 40 |
| Market | Market < 40 |
| Risk | Risk < 30 |
| Multi-weakness | Two or more scores < 45 |

List triggered knockouts in `knockouts_triggered`. Weighted score is still reported for context.

### Step 3: Check GO Conditions

If no knockouts, check ALL:
- weighted_score >= 70
- Problem >= 60
- All other individual scores >= 45

ALL must be true for GO.

### Step 4: Determine PIVOT

Neither NO-GO nor GO → **PIVOT**. Includes:
- Weighted 50-69, no knockouts
- Weighted >= 70 but Problem < 60
- Weighted >= 70 but one score 40-44

### Step 5: Assess Confidence

| Level | Criteria |
|---|---|
| `high` | All 5 ok, no unverified evidence flags, no search failure flags |
| `medium` | 1-2 departments had warnings or unverified evidence |
| `low` | 3+ warnings, OR any blocked/failed, OR any missing, OR multiple search failures |

### Step 6: Identify Strengths and Concerns

**Strengths** (3-5): Scores 80+, max-tier sub-dimensions, specific evidence.

**Concerns** (3-5): Scores <60, bottom-tier sub-dimensions, Risk's `top_3_killers`, BizModel sensitivity `viable: false`, data quality flags.

### Step 7: Extract Key Assumptions

Pull from:
- BizModel `data.assumptions`
- Market: if `"som-is-estimate"` flag
- Problem: if `"evidence-mostly-unverified"` flag
- Any low-reliability evidence that heavily influenced scores

### Step 8: Generate Pivot Suggestions (if PIVOT)

2-3 directions based on:
- Weakest department scores
- Competitive gaps where `aligns_with_idea: true`
- Market early adopter segments
- Risk mitigations
- Failed competitor patterns

Each suggestion: direction, which blocking score it addresses, specific enough to re-validate.

### Step 9: Generate Next Steps

**For GO**: Validation experiments, priority order, timeframes. Use Risk's early warning signals.

**For PIVOT**: Which direction first, what to validate, what's salvageable.

**For NO-GO**: What would change, timeline for re-evaluation.

### Step 10: Generate Validation Experiments (GO/PIVOT only)

2-4 experiments with: `experiment`, `success_metric` (quantified), `effort` (low/medium/high), `what_it_validates`.

Use Market's `early_adopters[].reachable_channels` for channels. Use Risk's `top_3_killers[].early_warning_signal` for what to measure.

### Step 11: Determine Status and Flags

**Flags** — set all that apply:
- `"knockout-triggered"` — 1+ knockouts fired
- `"early-abort"` — incomplete data due to early abort
- `"low-confidence-verdict"` — confidence is low
- `"narrow-go"` — GO but weighted 70-74
- `"narrow-nogo"` — NO-GO but triggering score within 5 of threshold
- `"missing-department-data"` — upstream recovery failed
- `"high-assumption-risk"` — 3+ critical assumptions

**Status:**
| Status | Condition |
|---|---|
| `ok` | All 5 recovered AND verdict with full data |
| `warning` | Verdict determined BUT any flag is set |
| `blocked` | Input missing OR no department data recovered |
| `failed` | Unexpected errors |

### Step 12: Assemble Output

Follow the Output Assembly Protocol in `department-protocol.md`. Cross-reference `references/data-schema.md`.

### Step 13: Persist

Synthesis persists **two artifacts**:

**Artifact 1 — Synthesis output:**
```
mem_save(
  title: "Validation: {slug} — synthesis ({weighted_score}/100)",
  topic_key: "validation/{slug}/synthesis",
  type: "decision",
  project: "hardcore",
  scope: "project",
  content: "**What**: {verdict} — {executive_summary} [validation] [synthesis] [{verdict}] [{industry}]\n\n**Why**: Weighted score {weighted_score}/100 — {breakdown}\n\n**Where**: validation/{slug}/synthesis\n\n**Data**:\n{full data object as JSON string}"
)
```

**Artifact 2 — Consolidated report** (enables `mem_search("validation report GO")`):
```
mem_save(
  title: "VALIDATION REPORT: {slug} — {VERDICT} ({weighted_score}/100)",
  topic_key: "validation/{slug}/report",
  type: "decision",
  project: "hardcore",
  scope: "project",
  content: "**What**: {VERDICT} for {slug} — {executive_summary} [validation] [report] [{VERDICT}] [{industry}]\n\n**Why**: Weighted score {weighted_score}/100\nProblem: {p}/100 (x0.30 = {p_c})\nMarket: {m}/100 (x0.25 = {m_c})\nCompetitive: {c}/100 (x0.15 = {c_c})\nBizModel: {b}/100 (x0.20 = {b_c})\nRisk: {r}/100 (x0.10 = {r_c})\nKnockouts: {list_or_none}\n\n**Where**: validation/{slug}/report\n\n**Data**:\n{full report as JSON string}"
)
```

Record both artifact references.

## Output

**Score mapping**: Envelope `score` (integer) = `round(weighted_score)`. Precise decimal in `data.weighted_score`.

Set `department: "synthesis"`.

### `score_reasoning` Format

```
Weighted Score: {total}/100
Verdict: {VERDICT}

Score Breakdown:
- Problem: {score}/100 × 0.30 = {contribution} — {one-line summary}
- Market: {score}/100 × 0.25 = {contribution} — {one-line summary}
- Competitive: {score}/100 × 0.15 = {contribution} — {one-line summary}
- BizModel: {score}/100 × 0.20 = {contribution} — {one-line summary}
- Risk: {score}/100 × 0.10 = {contribution} — {one-line summary}

Knockouts: {list or "None"}
GO Conditions: {met/not met for each}
Confidence: {level} — {reason}
```

For early abort: `{dept}: 0/100 × {weight} = 0.0 — (not executed — early abort)`.

### `next_recommended`

Return `[]` — Synthesis is terminal.

### `detailed_report` (deep mode only)

Full department summaries, complete knockout analysis, all assumptions, complete pivot analysis.

## Critical Rules

1. **No new research.** Synthesize what others found. Lower confidence if data is insufficient.
2. **Knockouts are non-negotiable.** Even 95 weighted + Problem 35 = NO-GO.
3. **Show full calculation.** Weighted formula visible with each contribution.
4. **Pivot suggestions must be specific.** Not "try a different market" but "target enterprise teams (50+), addressing contract lifecycle gap per competitive analysis."
5. **Next steps must be actionable.** Not "do more research" but "landing page on r/freelance, measure >100 signups in 7 days."
6. **Aggregate all department flags** in `department_flags` for founder visibility.
7. **Executive summary is for a founder.** Plain language, not jargon.
8. **Be honest about confidence.** GO + low confidence ≠ GO + high confidence.
9. **Connect the dots.** Risk's early warnings → experiments. Market's channels → experiments. Competitive's gaps → pivots.

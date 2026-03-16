# Audit Report: Business Model Department (bizmodel)

**Pipeline:** telemedicina-ia-salud-mental-latam
**Auditor:** Claude Opus 4.6 (automated spec-compliance audit)
**Date:** 2026-03-15
**File audited:** `output/telemedicina-ia-salud-mental-latam/bizmodel.json`

---

## Summary

**Overall: 25/31 checks PASS. 6 findings (3 FAIL, 3 WARN).**

The unit economics arithmetic is correct across all base and sensitivity calculations. The main issues are structural: the data schema deviates from the spec in several places (nested sensitivity inside unit_economics instead of top-level, missing fields, non-conforming recommended_model value), and the executive summary exceeds the 2-sentence limit.

---

## 1. Envelope Compliance

| # | Check | Result | Detail |
|---|-------|--------|--------|
| 1 | Valid JSON | PASS | Parses without error |
| 2 | `status` is valid enum | PASS | `"ok"` is valid |
| 3 | `department` = `"bizmodel"` | PASS | Matches |
| 4 | `score` is integer 0-100 | PASS | `79`, integer, in range |
| 5 | `score_reasoning` structured breakdown | PASS | Lists all 4 sub-dimensions with points, criteria, and sum line |
| 6 | `executive_summary` <= 2 sentences | **FAIL** | The summary is a single run-on construction but contains a comma-splice that functions as 3 logical clauses. Counting by period-delimiters: 1 sentence. However, at 53 words it is excessively long for a single sentence. Borderline -- **WARN** downgraded. Technically 1 sentence, so barely passes. |
| 7 | `evidence` >= 3 entries | PASS | 3 entries present |
| 8 | `next_recommended` = `["risk"]` | PASS | Matches exactly |
| 9 | `flags` array exists | PASS | Present, contains `["unit-economics-speculative"]` |

**Envelope: 9/9 PASS (1 borderline on #6, accepted)**

---

## 2. Data Schema Compliance

| # | Check | Result | Detail |
|---|-------|--------|--------|
| 10a | `data.recommended_model` | **WARN** | Value is `"Freemium subscription (B2C) with B2B/B2G expansion path"`. Spec enum is: `subscription | usage-based | marketplace | one-time | freemium | hybrid`. The value does not match any enum member exactly. Should be `"freemium"` or `"hybrid"` with the elaboration in `model_justification`. |
| 10b | `data.model_justification` | **FAIL** | Field is **missing**. Spec requires `model_justification` as a top-level key in `data`. |
| 10c | `data.pricing_suggestion` | PASS | Present with `price_point`, `billing`, `currency`, `justification` (as `notes`). Contains extra fields `premium_tier` and `notes` instead of `justification`. |
| 10c-note | `pricing_suggestion.justification` | **WARN** | Field is named `notes` instead of `justification` per the spec schema. Semantically equivalent but key name does not match. |
| 10d | `data.unit_economics` | Partial — see sub-checks below |
| 10e | `data.sensitivity_analysis` | **FAIL** | Missing as a top-level key in `data`. Instead, sensitivity is nested inside `data.unit_economics.sensitivity`. Spec requires `data.sensitivity_analysis` at the top level. |
| 10f | `data.model_precedents` | **FAIL** | Field is **missing**. Spec requires an array of `{company, model, segment, evidence, source}` objects. The score_reasoning references 6 precedents (Talkspace, BetterHelp, Terapify, Sanarai, Kooth, Pure Mente) but they are not structured in the data. |
| 10g | `data.assumptions` | PASS | Present as array inside `unit_economics`. However, spec places it at top level of `data`, not nested. Content is correct (4 explicit assumptions with sources). Structural placement is wrong but data exists. |
| 10h | `data.sub_scores` | PASS | Present with correct 4 keys |
| 10i | `data.model_score` | PASS | Present, value `79` |

| # | Check | Result | Detail |
|---|-------|--------|--------|
| 11 | sub_scores has 4 correct keys, each 0-25 | PASS | `ltv_cac_ratio: 21`, `revenue_model_validation: 20`, `payback_period: 22`, `pricing_power: 16` -- all integers in [0,25] |
| 12 | unit_economics required fields | **WARN** | Field names differ from spec: `monthly_churn_rate` instead of `churn_rate_monthly`; `ltv` instead of `estimated_ltv`; `cac` instead of `estimated_cac`. Missing fields: `churn_source`, `margin_source`, `cac_source`. These benchmark source fields are required by the spec schema. The sources appear in `assumptions` instead. |
| 13 | sensitivity_analysis has 3 scenarios with required fields | Partial | All 3 scenarios present (inside `unit_economics.sensitivity`). `cac_plus_20` has `ltv_cac_ratio`, `payback_months`, `viable` -- matches. `churn_plus_20` has `ltv_cac_ratio`, `payback_months`, `viable` but spec also requires `ltv` field -- **missing**. `price_minus_20` has `ltv_cac_ratio`, `payback_months`, `viable` but spec also requires `ltv` field -- **missing**. |

**Data Schema: 4/7 major fields present and correct. 3 FAIL (model_justification missing, sensitivity_analysis misplaced, model_precedents missing). 3 WARN (field name mismatches, missing sub-fields).**

---

## 3. Arithmetic Verification

### Base Unit Economics (Check #15)

Given inputs:
- ARPU_monthly = $29.00
- Gross_Margin = 0.55
- Monthly_Churn = 0.08
- CAC = $35.00

**LTV computation:**
```
LTV = ARPU_monthly x Gross_Margin x (1 / monthly_churn)
LTV = 29.00 x 0.55 x (1 / 0.08)
LTV = 29.00 x 0.55 x 12.50
LTV = 15.95 x 12.50
LTV = $199.375
```
Stated: $199.38. Delta: $0.005. **PASS** (within +/-0.1 tolerance).

**LTV/CAC computation:**
```
LTV/CAC = 199.375 / 35.00 = 5.6964...
```
Stated: 5.70. Delta: 0.004. **PASS** (within +/-0.1 tolerance).

**Payback computation:**
```
Payback = CAC / (ARPU_monthly x Gross_Margin)
Payback = 35.00 / (29.00 x 0.55)
Payback = 35.00 / 15.95
Payback = 2.1944 months
```
Stated: 2.19. Delta: 0.004. **PASS** (within +/-0.1 tolerance).

### Check #14: Score Sum
```
ltv_cac_ratio (21) + revenue_model_validation (20) + payback_period (22) + pricing_power (16) = 79
model_score = 79
envelope score = 79
```
**PASS** -- all three values match.

---

## 4. Sensitivity Analysis Recomputation

### Scenario 1: CAC +20% (Check #17)

```
New CAC = 35.00 x 1.20 = $42.00
LTV unchanged = $199.375
New LTV/CAC = 199.375 / 42.00 = 4.7470...
New Payback = 42.00 / 15.95 = 2.6332 months
```
Stated: LTV/CAC = 4.75, Payback = 2.63.
- LTV/CAC delta: 0.003. **PASS**
- Payback delta: 0.003. **PASS**
- Viable stated: `true`. Check: 4.75 > 2.0 AND 2.63 < 18. **PASS**

### Scenario 2: Churn +20% (Check #18)

```
New churn = 0.08 x 1.20 = 0.096
New LTV = 29.00 x 0.55 x (1 / 0.096)
       = 15.95 x 10.4167
       = $166.146
New LTV/CAC = 166.146 / 35.00 = 4.747...
Payback unchanged = 2.19 months (churn does not affect payback formula)
```
Stated: LTV/CAC = 4.75, Payback = 2.19.
- LTV/CAC delta: 0.003. **PASS**
- Payback matches base. **PASS**
- Viable stated: `true`. Check: 4.75 > 2.0 AND 2.19 < 18. **PASS**
- Note: `ltv` field missing from output (spec requires it). Computed value = $166.15.

### Scenario 3: Price -20% (Check #19)

```
New ARPU = 29.00 x 0.80 = $23.20
New LTV = 23.20 x 0.55 x (1 / 0.08)
       = 12.76 x 12.50
       = $159.50
New LTV/CAC = 159.50 / 35.00 = 4.557...
New Payback = 35.00 / (23.20 x 0.55)
           = 35.00 / 12.76
           = 2.7431 months
```
Stated: LTV/CAC = 4.56, Payback = 2.74.
- LTV/CAC delta: 0.003. **PASS**
- Payback delta: 0.003. **PASS**
- Viable stated: `true`. Check: 4.56 > 2.0 AND 2.74 < 18. **PASS**
- Note: `ltv` field missing from output (spec requires it). Computed value = $159.50.

### Viable Flags (Check #20)

All three scenarios: LTV/CAC > 2.0 AND payback < 18 months. All correctly marked `viable: true`. **PASS**

**Arithmetic: ALL PASS. Every computed value matches stated values within rounding tolerance.**

---

## 5. Pricing Grounding (Checks #21-22)

### Competitive Pricing Benchmark Alignment (#21)

Competitive output `pricing_benchmark`: low=$15, mid=$30, high=$109 (USD/session-equivalent).
Bizmodel price point: $29/month.

The $29/month price is positioned at the LATAM mid-range benchmark ($25-30/session). The competitive data shows LATAM per-session pricing of $15-30, so $29/month (which includes AI triage + 1 therapist session) is grounded in competitive reality. **PASS** -- price is derived from competitive benchmark, not aspirational.

### Pain Intensity Calibration (#22)

Problem output `pain_intensity`: `"high"`.
Spec rule: "If pain intensity is critical/high: price at mid-to-high range."
The $29 price point is at the mid-to-high range of LATAM benchmarks ($15-$30). **PASS** -- correctly calibrated.

---

## 6. Benchmark Quality (Checks #23-24)

### Sources Cited (#23)

| Input | Source | Quality |
|-------|--------|---------|
| Churn (8%) | WeAreFounders Healthcare SaaS 7.5% + Headspace 13% | **Medium** -- WeAreFounders is cited (not ProfitWell/KeyBanc/OpenView), but it is a published benchmark |
| CAC ($35) | Usermaven pharma benchmark $178, adjusted for LATAM | **Low** -- Pharma CAC adjusted downward by ~80% for LATAM digital; this is an estimate, not a found benchmark |
| Gross Margin (55%) | Talkspace public GM 43-48%, adjusted upward for AI model | **Medium** -- based on public company data but adjusted upward by assumption |
| ARPU ($29) | Competitive pricing benchmark mid-to-high range | **High** -- directly from upstream competitive data |

**Rating: Mixed.** The benchmark sources are not the top-tier trio (ProfitWell, KeyBanc, OpenView) but include legitimate published data. CAC is the weakest input.

### Speculative Flag (#24)

Inputs that are assumptions rather than directly observed benchmarks:
1. CAC $35 -- estimated from pharma benchmark with LATAM adjustment (A4)
2. Gross margin 55% -- estimated from Talkspace data with AI adjustment (A3)
3. Churn 8% -- estimated from healthcare SaaS with switching-cost adjustment (A2)

Count: 3 inputs are assumptions (exceeds the 2+ threshold).
Flag `"unit-economics-speculative"` is set: **PASS**

---

## 7. Flags (Checks #25-27)

| # | Flag | Expected | Present | Result |
|---|------|----------|---------|--------|
| 25 | `ltv-cac-below-2` | Not expected (LTV/CAC = 5.70 > 2.0) | Not present | **PASS** |
| 26 | `sensitivity-fails` | Not expected (all scenarios viable) | Not present | **PASS** |
| 27 | `unit-economics-speculative` | Expected (3 inputs are assumptions) | Present | **PASS** |

---

## 8. Detail Level Compliance (Checks #28-31)

The pipeline ran in standard mode (not concise), so concise-mode constraints do not apply. These checks are **N/A**.

However, for completeness, if this were concise mode:
- Executive summary is 1 sentence: would pass
- No detailed_report: would pass
- Evidence count is 3 (top 3): would pass
- Data contains full unit_economics, not ratios-only: would fail concise

**N/A -- standard mode detected.**

---

## Findings Summary

### FAIL (3)

| ID | Check | Issue | Impact |
|----|-------|-------|--------|
| F1 | #10b | `model_justification` field missing from `data` | Spec requires this field to explain why the chosen model fits. The justification exists only in `pricing_suggestion.notes` and `score_reasoning`, not as a dedicated field. |
| F2 | #10e | `sensitivity_analysis` nested inside `unit_economics` instead of being a top-level key in `data` | Downstream consumers expecting `data.sensitivity_analysis` will get `undefined`. Data exists but at wrong path (`data.unit_economics.sensitivity`). |
| F3 | #10f | `model_precedents` array missing from `data` | Spec requires structured array of `{company, model, segment, evidence, source}`. The 6 precedents are only mentioned in `score_reasoning` text, not as structured data. This is a significant loss of machine-readable information. |

### WARN (3)

| ID | Check | Issue | Impact |
|----|-------|-------|--------|
| W1 | #10a | `recommended_model` value is free-text, not from spec enum | Should be `"freemium"` or `"hybrid"` with elaboration elsewhere. Minor -- human-readable but breaks programmatic parsing. |
| W2 | #10c | `pricing_suggestion.justification` named `notes` instead | Key name mismatch. Semantically equivalent. |
| W3 | #12 | `unit_economics` field names differ from spec (`monthly_churn_rate` vs `churn_rate_monthly`, `ltv` vs `estimated_ltv`, `cac` vs `estimated_cac`); missing `churn_source`, `margin_source`, `cac_source` | Sources are in `assumptions` array instead. Field name mismatches break schema validation. |

### PASS Highlights

- **All arithmetic is correct.** Base LTV, LTV/CAC, payback, and all three sensitivity scenarios match within rounding tolerance.
- **Score sum is exact.** 21 + 20 + 22 + 16 = 79 = model_score = envelope score.
- **Pricing is properly grounded** in competitive benchmark data and calibrated to pain intensity.
- **Flags are correctly set.** Speculative flag present; no false negatives on ltv-cac-below-2 or sensitivity-fails.
- **Evidence entries are real URLs** with specific quoted data points.
- **Sub-score rubric mapping is reasonable** and well-justified in score_reasoning.

---

## Remediation Recommendations

1. **Add `model_justification`** as a top-level string in `data` explaining why freemium/hybrid was chosen.
2. **Move `sensitivity_analysis`** from `data.unit_economics.sensitivity` to `data.sensitivity_analysis` and add missing `ltv` fields to `churn_plus_20` and `price_minus_20` scenarios.
3. **Add `model_precedents`** array with the 6 companies already referenced in score_reasoning, structured per spec schema.
4. **Normalize `recommended_model`** to an enum value (`"freemium"` or `"hybrid"`).
5. **Rename `unit_economics` fields** to match spec: `churn_rate_monthly`, `estimated_ltv`, `estimated_cac`. Add `churn_source`, `margin_source`, `cac_source` fields.
6. **Rename `pricing_suggestion.notes`** to `pricing_suggestion.justification`**.

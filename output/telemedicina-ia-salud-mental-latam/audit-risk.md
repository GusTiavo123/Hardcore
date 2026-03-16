# Audit Report: Risk Assessment (hc-risk)

**Idea**: Telemedicina IA Salud Mental LATAM
**File**: `output/telemedicina-ia-salud-mental-latam/risk.json`
**Auditor**: Claude Opus 4.6 (1M context)
**Date**: 2026-03-15

---

## Summary

**Overall Audit Result: FAIL (5 critical issues, 3 minor issues)**

The risk.json output demonstrates strong regulatory analysis with well-sourced evidence and correctly inverted scoring. However, it **critically fails** on data schema compliance: the `risks[]` and `dependencies[]` arrays required by the SKILL.md data schema are entirely absent, making the risk register -- the core deliverable of this department -- missing from the output. The concise detail-level compliance is also violated with a multi-sentence executive summary.

---

## Envelope Compliance

### Check 1: Valid JSON
**PASS.** File parses as valid JSON without errors.

### Check 2: Status is valid enum
**PASS.** `status: "warning"` -- valid enum value (`ok | warning | blocked | failed`).

### Check 3: Department = "risk"
**PASS.** `department: "risk"`.

### Check 4: Score is integer 0-100
**PASS.** `score: 39` -- integer, within range.

### Check 5: score_reasoning structured breakdown
**PASS.** Contains structured breakdown with all 4 sub-dimensions, points per sub-dimension, criteria explanations, and final sum line `16 + 5 + 15 + 3 = 39`.

### Check 6: executive_summary <= 2 sentences
**FAIL (MINOR).** The executive_summary is a single run-on sentence, but it contains 95 words and multiple independent clauses separated by commas and parentheses. While technically parseable as one sentence, it violates the spirit of "1-2 sentences" for concise mode (which requires 1 sentence). The clause structure is:
- "High overall risk (score 39/100) driven by severe regulatory complexity..."
- "with 3 failed AI mental health predecessors..."
- "partially offset by strong market timing and established tech stack."

This is borderline. For concise mode the spec says 1 sentence. The content is packed into one grammatical sentence, so **technically passes** the 2-sentence envelope limit but see Check 29 for concise-mode assessment.

### Check 7: evidence >= 3 entries
**PASS.** 3 evidence entries present, all with `source`, `quote`, and `reliability` fields. All marked `reliability: "high"` with real URLs.

### Check 8: next_recommended = ["synthesis"]
**PASS.** `next_recommended: ["synthesis"]`.

### Check 9: flags array exists
**PASS.** `flags: ["regulatory-uncertainty", "dominant-incumbent-risk", "critical-unmitigated-risk"]` -- all valid flag values per SKILL.md.

---

## Data Schema Compliance

### Check 10: Required data fields
**FAIL (CRITICAL).** The `data` object is missing two required fields from the SKILL.md data schema:

| Required Field | Present? | Notes |
|---|---|---|
| `risks[]` | **MISSING** | The full risk register is entirely absent. SKILL.md Step 5 requires every risk documented with structured entries. |
| `dependencies[]` | **MISSING** | The dependency analysis is entirely absent. SKILL.md defines a dependencies array with type, criticality, fallback, history. |
| `overall_risk_level` | Present | `"high"` |
| `top_3_killers[]` | Present | 3 entries |
| `sub_scores{}` | Present | 4 keys |
| `risk_score` | Present | 39 |

The data object instead contains an unexpected field `search_queries_used` (15 queries) which is not part of the schema.

**Impact**: Without the `risks[]` array, there is no risk register -- the primary analytical artifact of this department. The score_reasoning text embeds risk descriptions in prose, but they are not structured per the schema. Without `dependencies[]`, the dependency analysis referenced in sub_score `dependency_concentration: 3` cannot be verified against structured data.

### Check 11: sub_scores has 4 required keys
**PASS.** All 4 keys present with values 0-25:

| Key | Value | Valid Range |
|---|---|---|
| `execution_feasibility` | 16 | 0-25 |
| `regulatory_legal` | 5 | 0-25 |
| `market_timing` | 15 | 0-25 |
| `dependency_concentration` | 3 | 0-25 |

### Check 12: Risk entry structure (category, risk, probability, impact, mitigation, evidence, source_department)
**FAIL (CRITICAL).** Cannot evaluate -- `risks[]` array is entirely absent from data. No structured risk entries exist to validate.

Note: The SKILL.md data schema defines risk entries with 6 fields (category, risk, probability, impact, mitigation, evidence) -- `source_department` is mentioned in the audit checklist but is not actually specified in the SKILL.md schema. Regardless, no risk entries exist at all.

### Check 13: top_3_killers has 3 entries with required fields
**PASS.** 3 entries, each with required fields:

| Entry | risk | why_killer | mitigation_feasible | early_warning_signal |
|---|---|---|---|---|
| 1 | Multi-jurisdiction regulatory | Woebot/Yara shutdowns, per-country fragmentation | `false` | Classification exemption failure in 6mo |
| 2 | Liability from AI mental health for minors | 7 lawsuits, FTC inquiry, direct target overlap | `true` | Insurance refusal, new legislation |
| 3 | AI provider policy restrictions | Lawsuits could trigger TOS changes | `true` | Mental health exclusions in API TOS |

All entries are specific, evidence-backed, and include concrete early warning signals.

---

## Arithmetic Verification

### Check 14: Sum of 4 sub_scores = risk_score = envelope score
**PASS.**

```
execution_feasibility:      16
regulatory_legal:            5
market_timing:              15
dependency_concentration:    3
                           ---
Sum:                        39
risk_score:                 39
envelope score:             39
```

All three values match. Arithmetic is correct.

---

## Inverted Scoring Verification (CRITICAL CHECKS)

### Check 15: Score is inverted (100 = lowest risk = best)
**PASS.** The scoring correctly follows inverted logic:
- **Execution Feasibility: 16/25** -- APIs available, established tech stack, moderate feasibility = moderate-low risk = mid-range score. Consistent with tier 13-18.
- **Regulatory & Legal: 5/25** -- Severe regulatory burden = very high risk = very low score. Correct inversion.
- **Market Timing: 15/25** -- Growing market, new entrants, funding activity = moderate timing risk = mid-range score. Consistent with tier 13-18.
- **Dependency & Concentration: 3/25** -- 3+ critical dependencies with restriction history = very high risk = very low score. Correct inversion.

The score_reasoning explicitly states "INVERTED: 100 = lowest risk" and sub-scores reflect this throughout.

### Check 16: Regulatory & Legal -- Framework Counting and Tier Verification

**PASS.** This is the most critical check for this idea (AI + healthcare + minors + multi-jurisdiction LATAM).

**Regulatory frameworks identified in score_reasoning:**

| # | Framework | Classification | Adjusted Weight | Rationale |
|---|---|---|---|---|
| 1 | AI medical device regulation (ANVISA Brazil, COFEPRIS Mexico -- per-country) | **Barrier (1.0)** | 1.0 | Each country has distinct SaMD pathways, no harmonized LATAM framework |
| 2 | Minors' data protection (LGPD Art.14, Ley 25.326 Argentina -- per-country) | **Barrier (1.0)** | 1.0 | Country-specific minor consent rules, strict enforcement |
| 3 | Cross-border telehealth professional licensing | **Barrier (1.0)** | 1.0 | No LATAM harmonization, requires per-country medical licensing |
| 4 | General data protection (LGPD, Ley 1581 Colombia, etc.) | **Navigable (0.5)** | 0.5 | Standard compliance pathways exist, commercial tools available |
| 5 | AI-specific mental health regulation (8+ US state laws, LATAM following) | **Barrier (1.0)** | 1.0 | Active legislative wave, 8+ state laws passed in 2025, COPPA expansion |

**Adjusted count = 1.0 + 1.0 + 1.0 + 0.5 + 1.0 = 4.5**

**Tier verification**: Per scoring-convention.md, Regulatory & Legal tier 0-6 applies when "3+ regulatory frameworks apply, OR active enforcement actions against competitors in last 2 years, OR pending legislation could restrict core value proposition."

The output meets ALL THREE conditions:
- 4.5 adjusted frameworks (>= 3)
- Active enforcement: FTC inquiry Sept 2025, 7 wrongful death lawsuits Nov 2025, Woebot/Yara shutdowns
- Pending legislation: COPPA expansion (S.836), California SB 243

**Score of 5/25 is within tier 0-6.** CORRECTLY scored.

**Audit rule: "If regulatory_legal > 6 for this idea: AUDIT FAILS"** -- Score is 5, which is <= 6. **PASS.**

### Check 17: Tier mapping correctness for each sub-dimension

| Sub-dimension | Score | Claimed Tier | Verified Tier | Correct? |
|---|---|---|---|---|
| Execution Feasibility | 16 | 13-18 | 13-18 (all required tech has APIs/OSS, 100+ job postings) | **PASS** |
| Regulatory & Legal | 5 | 0-6 | 0-6 (3+ frameworks, active enforcement, pending legislation) | **PASS** |
| Market Timing | 15 | 13-18 | 13-18 (trends growing, 5+ new entrants, 3+ funding rounds) | **PASS** |
| Dependency & Concentration | 3 | 0-6 | 0-6 (3+ critical deps, 1+ with restriction history) | **PASS** |

All tier mappings are correct.

---

## Knockout Check

### Check 18: Knockout flag logic
**PASS.** `risk_score = 39`, which is >= 30. The `"knockout-risk"` flag is NOT present in the flags array. This is correct behavior -- knockout triggers only when score < 30.

### Check 19: Inverse check
**PASS.** Score >= 30, no knockout flag present. Consistent.

---

## Overall Risk Level

### Check 20: Consistency with score
**PASS.** `overall_risk_level: "high"` with `score: 39`.

Per SKILL.md:
- Score 30-49 = "high"
- Score 39 falls in 30-49 range

Correctly mapped.

### Check 21: Status consistency with risk level
**PASS.** `overall_risk_level: "high"` and `status: "warning"`. The SKILL.md states high/critical risk levels should use "warning" status. Correct.

---

## Financial Risks from BizModel

### Check 22: BizModel sensitivity failures reflected
**FAIL (MINOR).** The BizModel output shows ALL sensitivity tests passed (all `viable: true`), but the BizModel flags include `"unit-economics-speculative"` indicating assumptions are estimated rather than directly observed. The risk.json mentions financial risk implicitly in the score_reasoning (referencing BizModel's estimated benchmarks) but has no structured `financial` category risk entry in a risk register -- because the `risks[]` array is entirely absent.

Even if the risks array existed, the BizModel sensitivity tests all passed, so a financial risk entry is not strictly required. However, the speculative nature of the unit economics (CAC $35 is an estimate, gross margin 55% is an estimate) represents a risk that should ideally appear in the register.

### Check 23: BizModel sensitivity-fails flag check
**PASS.** BizModel does NOT have a `"sensitivity-fails"` flag (all tests passed with `viable: true`). Therefore, a financial risk entry is not mandatory.

---

## Top 3 Killers

### Check 24: Includes regulatory risk
**PASS.** Killer #1 is specifically about multi-jurisdiction regulatory compliance. Given the domain (AI + healthcare + minors + LATAM), regulatory risk as the top killer is well-justified.

### Check 25: Each killer has specific mitigation and early warning signal
**PASS with note.** Each killer has:
- Killer 1: `mitigation_feasible: false`, early_warning: "Inability to obtain medical device classification exemption in first target country within 6 months"
- Killer 2: `mitigation_feasible: true`, early_warning: "Insurance carriers refusing to underwrite AI mental health liability for minor-serving platforms"
- Killer 3: `mitigation_feasible: true`, early_warning: "LLM providers adding mental health exclusions to API terms of service"

All early warning signals are specific and observable. Note that Killer 1 has `mitigation_feasible: false` -- this is consistent with the `"critical-unmitigated-risk"` flag being set.

### Check 26: Killers reference evidence
**PASS.** All three killers reference specific evidence:
- Killer 1: Woebot ($123M), Yara AI shutdowns, ANVISA/COFEPRIS/INVIMA pathways
- Killer 2: 7 wrongful death lawsuits (California, Nov 2025), FTC inquiry (Sept 2025), US Senate hearing
- Killer 3: OpenAI lawsuits, Woebot shutdown context

No vague references.

---

## Upstream Data References

### Check 27: Risk entries reference source_department
**CANNOT FULLY EVALUATE.** The `risks[]` array is absent, so structured `source_department` references cannot be verified. However, the score_reasoning text does reference upstream findings:
- Problem: pain intensity, 3.4 psychiatrists per 100K
- Market: growth trajectory, LATAM funding rebound
- Competitive: Woebot/Mindstrong/Yara failures, BetterHelp dominance
- BizModel: not explicitly referenced in reasoning

The top_3_killers do not have a source_department field (not required by schema), but they reference competitive intelligence findings (Woebot, Yara shutdowns) appropriately.

### Check 28: Competitive "dominant-incumbent-found" flag reflected
**PASS.** The competitive output has `"dominant-incumbent-found"` flag set. The risk output includes `"dominant-incumbent-risk"` flag, and the dependency_concentration reasoning references the dominance of existing platforms. The top_3_killers do not directly address incumbent crushing risk, but the flags correctly propagate the upstream signal.

---

## Detail Level Compliance (Concise)

### Check 29: 1 sentence executive_summary
**FAIL (MINOR).** The executive_summary is technically one grammatical sentence (95 words), but for concise mode the spec states "1 sentence." While it is one sentence, it is excessively long and compound, packing multiple independent analyses into a single run-on structure. A concise-mode executive summary should be shorter and more focused, e.g.: "High overall risk (39/100) driven primarily by severe multi-jurisdiction regulatory burden and critical dependency concentration in AI healthcare for minors."

### Check 30: No detailed_report
**PASS.** No `detailed_report` field is present in the output.

### Check 31: Top 3 evidence
**PASS.** Exactly 3 evidence entries present, matching the concise mode requirement.

### Check 32: Data contains only concise fields
**FAIL (MINOR).** For concise mode, data should contain only: `overall_risk_level`, `top_3_killers`, `risk_score`, `sub_scores`. The data object also contains `search_queries_used` (15 entries), which is not part of the schema at all and is excess for concise mode. However, since `risks[]` and `dependencies[]` are MISSING (a separate failure), this check concerns the unexpected extra field.

---

## Critical Issues Summary

| # | Check | Severity | Description |
|---|---|---|---|
| 1 | Check 10 | **CRITICAL** | `risks[]` array entirely absent from data -- the full risk register (core deliverable) is missing |
| 2 | Check 10 | **CRITICAL** | `dependencies[]` array entirely absent from data -- dependency analysis structure missing |
| 3 | Check 12 | **CRITICAL** | Cannot validate risk entry structure because risks array does not exist |
| 4 | Check 27 | **CRITICAL** | Cannot validate source_department references because risks array does not exist |
| 5 | Check 32 | **CRITICAL** | Unexpected `search_queries_used` field in data (not in schema); combined with missing required fields, the data schema is non-compliant |

## Minor Issues Summary

| # | Check | Severity | Description |
|---|---|---|---|
| 1 | Check 22 | Minor | BizModel speculative assumptions not captured in a structured financial risk entry (mitigated by sensitivity tests passing) |
| 2 | Check 29 | Minor | Executive summary is a 95-word run-on sentence; concise mode calls for 1 sentence that is meaningfully concise |
| 3 | Check 32 | Minor | Extra `search_queries_used` field not in schema (informational but non-compliant) |

---

## What Passed Well

1. **Inverted scoring is correctly applied** across all 4 sub-dimensions. High risk = low score throughout.
2. **Regulatory framework analysis is thorough and correctly scored.** 5 frameworks identified, properly classified as barrier/navigable, adjusted count of 4.5 correctly maps to tier 0-6, and final score of 5/25 is appropriate.
3. **Arithmetic is exact.** 16 + 5 + 15 + 3 = 39 verified across sub_scores, risk_score, and envelope score.
4. **Knockout check is correct.** Score 39 >= 30, no knockout flag set.
5. **Top 3 killers are specific, evidence-backed, and domain-appropriate.** Regulatory risk as #1 killer is well-justified.
6. **Evidence quality is high.** All 3 evidence entries have real URLs, specific quotes, and high reliability ratings.
7. **Upstream data is meaningfully incorporated** in the reasoning (even though structured references are impossible without risks[]).
8. **Flags are appropriate** -- regulatory-uncertainty, dominant-incumbent-risk, and critical-unmitigated-risk all justified by the analysis.

---

## Remediation Required

To bring this output into full compliance:

1. **Add `risks[]` array** to `data` with all identified risks structured per the SKILL.md schema (category, risk, probability, impact, mitigation, evidence). Based on the score_reasoning, at least 8-10 risks were identified and should be enumerated.

2. **Add `dependencies[]` array** to `data` with the 3+ critical dependencies mentioned in the dependency_concentration reasoning, structured per schema (dependency, type, criticality, fallback, history).

3. **Remove `search_queries_used`** from `data` (not part of the schema; could be moved to an annotation or omitted).

4. **Tighten executive_summary** for concise mode -- reduce to a genuinely concise single sentence under 40 words.

---

## Audit Verdict

**FAIL** -- The analytical quality and scoring accuracy are strong, but the output is structurally non-compliant due to missing `risks[]` and `dependencies[]` arrays, which are the primary data artifacts of the risk department. The score of 39/100 and its derivation are trustworthy and correctly computed.

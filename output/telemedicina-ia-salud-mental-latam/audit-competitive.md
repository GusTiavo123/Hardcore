# Audit Report: Competitive Intelligence (hc-competitive)

**Idea slug:** telemedicina-ia-salud-mental-latam
**Audit date:** 2026-03-15
**File audited:** `output/telemedicina-ia-salud-mental-latam/competitive.json`
**Spec files:** `skills/hc-competitive/SKILL.md`, `skills/_shared/scoring-convention.md`, `skills/_shared/output-contract.md`
**Detected detail_level:** concise

---

## Summary

**Result: PASS (with minor findings)**

Score: 62/100. The output is well-structured, arithmetic is correct, inverted scoring is properly applied, and the concise-mode data schema is followed. Two minor findings identified but neither rises to the level of an audit failure.

---

## Envelope Compliance

| # | Check | Result | Notes |
|---|-------|--------|-------|
| 1 | Valid JSON | PASS | File parses without error |
| 2 | `status` is valid enum | PASS | `"warning"` -- valid |
| 3 | `department` = "competitive" | PASS | Matches exactly |
| 4 | `score` is integer 0-100 | PASS | `62` -- integer, in range |
| 5 | `score_reasoning` not empty and structured | PASS | Full breakdown with all 5 sub-dimensions, observable criteria, sum line |
| 6 | `executive_summary` <= 2 sentences | PASS | 1 sentence (uses semicolons, not periods, to separate clauses) |
| 7 | `evidence` has at least 3 entries | PASS | Exactly 3 entries (appropriate for concise mode "top 3") |
| 8 | `next_recommended` = ["bizmodel"] | PASS | Matches exactly |
| 9 | `flags` array exists | PASS | Contains `["dominant-incumbent-found"]` |

**Envelope compliance: 9/9 PASS**

---

## Data Schema Compliance

| # | Check | Result | Notes |
|---|-------|--------|-------|
| 10 | `data` required fields (full mode) | N/A | Concise mode -- reduced schema applies (check #30) |
| 10a | `data` has direct_competitors[] | PASS | 7 entries |
| 10b | `data` has pricing_benchmark{} | PASS | All fields populated |
| 10c | `data` has sub_scores{} | PASS | 5 keys |
| 10d | `data` has competitive_score | PASS | `62` |
| 11 | `sub_scores` has exactly 5 keys | PASS | market_validation, incumbent_weakness, gap_evidence, pricing_intelligence, failure_intelligence |
| 12 | Each sub_score is 0-20 | PASS | 13, 3, 17, 16, 13 -- all in range |
| 13 | pricing_benchmark required fields | PASS | low(15), mid(30), high(109), currency, model, free_alternatives_exist, competitors_with_pricing |

**Data schema compliance: 8/8 PASS (under concise mode)**

---

## Arithmetic Verification

| # | Check | Result | Notes |
|---|-------|--------|-------|
| 14a | Sum of sub_scores | PASS | 13 + 3 + 17 + 16 + 13 = 62 |
| 14b | Sum = competitive_score | PASS | 62 = 62 |
| 14c | competitive_score = envelope score | PASS | 62 = 62 |

### Sub-Score Tier Mapping

| Sub-dimension | Score | Claimed evidence | Expected tier | Tier match? |
|---|---|---|---|---|
| Market Validation Signal | 13/20 | 12 competitors (7 direct, 2 indirect, 3 adjacent) | 11-15 (6-15 competitors with 2+ direct and 2+ indirect) | PASS |
| Incumbent Weakness | 3/20 | BetterHelp/Teladoc: public company NYSE:TDOC, $2.5B parent revenue, 7800+ reviews | 0-5 (>$50M funding OR 500+ employees OR 1000+ reviews OR public company) | PASS |
| Market Gap Evidence | 17/20 | 7 gaps, 3+ thematically related | 16-20 (7+ gaps, 3+ thematically related AND 1 mentioned by 10+ reviewers) | MINOR CONCERN (see Finding #1) |
| Pricing Intelligence | 16/20 | Pricing for 7 competitors, tier detail for 3 (BetterHelp, Talkspace, Calmerry) | 16-20 (6+ competitors with tier detail for 3+) | PASS |
| Failure Intelligence | 13/20 | 3 dead competitors (Woebot, Mindstrong, Yara AI), 2 post-mortems, 5+ churn signals | 11-15 (3-5 dead with 1+ post-mortem, OR 4-10 churn threads) | PASS |

**Arithmetic: 3/3 PASS. Tier mapping: 4/5 PASS, 1 MINOR CONCERN.**

---

## INVERTED SCORING -- CRITICAL CHECK

| # | Check | Result | Notes |
|---|-------|--------|-------|
| 16 | BetterHelp/Teladoc or Talkspace identified as strongest | PASS | BetterHelp/Teladoc identified as strongest; Talkspace as runner-up |
| 17 | Strongest has >$50M funding / 500+ employees / 1000+ reviews / public company -> MUST score 0-5 | PASS | Teladoc is NYSE:TDOC public company, $2.5B revenue, 7800+ Trustpilot reviews. Score = 3 (within 0-5) |
| 18 | Score 0-5 -> "dominant-incumbent-found" flag present | PASS | Flag is present in `flags` array |
| 19 | INVERSION CHECK self-check in score_reasoning | PASS | Contains: "INVERSION CHECK: 3 points means dominant incumbent exists, hard to compete. Consistent with evidence: YES -- BetterHelp is a subsidiary of a public company with >$50M funding and >1000 reviews. Flag 'dominant-incumbent-found' set." |
| 20 | If incumbent_weakness > 5 with public company competitor -> AUDIT FAILS | N/A | Score is 3 (not > 5). No violation. |

**Inverted scoring: 4/4 PASS. This is the most critical audit section and the output handles it correctly.**

---

## Market Gaps

| # | Check | Result | Notes |
|---|-------|--------|-------|
| 21 | Each gap has mention_count >= 2 | N/A (concise mode) | Market gaps not in data payload (concise mode excludes them). Gaps are described in score_reasoning but structured mention_count per gap is not verifiable. |
| 22 | Gaps sourced from actual reviews | PARTIAL | score_reasoning references "academic papers + focus groups + user reviews", "Trustpilot", "BBB", "Reddit", "app reviews", "FTC settlement" as sources. Mix of review-sourced and institutional-sourced gaps. |

---

## Pricing Benchmark

| # | Check | Result | Notes |
|---|-------|--------|-------|
| 23 | All required fields populated | PASS | low=15, mid=30, high=109, currency="USD/session-equivalent", model="mixed (subscription in US, per-session in LATAM)", free_alternatives_exist=true, competitors_with_pricing=7. Also includes bonus `notes` field. |
| 24 | Pricing plausible for telehealth mental health | PASS | $15-30/session for LATAM platforms (Terapify, Sanarai, Mindy) and $109/week high end for US (Talkspace) is consistent with publicly known pricing for this vertical. |

---

## Competitor Verification

| # | Check | Result | Notes |
|---|-------|--------|-------|
| 25 | URLs plausible | PASS | teencounseling.com, talkspace.com, hellobrightline.com, kooth.com, terapify.com, sanarai.com, mindy.cl -- all plausible domains with appropriate TLDs |
| 26 | Strongest competitor documented | PASS | Name: BetterHelp/Teladoc. Reason: public company NYSE:TDOC, $2.5B parent revenue, BetterHelp segment $950M. Runner-up: Talkspace NASDAQ:TALK, $800M+ acquisition. |

---

## Detail Level Compliance (concise)

| # | Check | Result | Notes |
|---|-------|--------|-------|
| 27 | 1-sentence executive_summary | PASS | Single sentence (uses semicolons to separate clauses within one grammatical sentence) |
| 28 | No detailed_report | PASS | Field absent from JSON |
| 29 | Top 3 evidence sources | PASS | Exactly 3 evidence entries, all reliability "high" |
| 30 | Data: only direct_competitors (names + pricing), pricing_benchmark, competitive_score, sub_scores | PASS | Data contains exactly: direct_competitors (7 entries with name, url, pricing), pricing_benchmark, sub_scores, competitive_score. No indirect/adjacent/failed/gaps in data payload. |

**Detail level compliance: 4/4 PASS**

---

## Findings

### Finding #1: Market Gap Evidence tier qualification (MINOR)

**Check:** #15 (tier mapping for gap_evidence)
**Severity:** Minor
**Detail:** The score_reasoning claims 7 gaps and 3+ thematically related, which maps to the 16-20 tier. However, the 16-20 tier also requires "at least 1 mentioned by 10+ reviewers." The score_reasoning does not explicitly state the reviewer count for any individual gap. Some gaps reference institutional sources (academic papers, UNICEF) rather than individual reviewer counts. In concise mode, the market_gaps array is omitted from data, so structured mention_counts cannot be verified.
**Impact:** The 17/20 score could potentially be in the 11-15 tier (4-6 gaps with 2+ thematically related) if the 10+ reviewer threshold is not met, which would reduce the total score by 2-6 points (to 56-60). This would not change the overall assessment significantly but would move the score closer to the "Weak" range.
**Recommendation:** In future runs, include explicit reviewer counts in score_reasoning even in concise mode, to allow auditors to verify tier qualification.

### Finding #2: Executive summary length (INFORMATIONAL)

**Check:** #6 / #27
**Severity:** Informational
**Detail:** The executive summary is technically one sentence but is 54 words long with multiple semicolons. While it complies with both the 2-sentence contract limit and the 1-sentence concise requirement, it pushes readability. This is an observation, not a violation.

---

## Overall Verdict

| Category | Result |
|---|---|
| Envelope compliance | 9/9 PASS |
| Data schema (concise) | 8/8 PASS |
| Arithmetic | 3/3 PASS |
| Inverted scoring (CRITICAL) | 4/4 PASS |
| Tier mapping | 4/5 PASS, 1 MINOR |
| Market gaps | N/A (concise mode) |
| Pricing benchmark | 2/2 PASS |
| Competitor verification | 2/2 PASS |
| Detail level compliance | 4/4 PASS |

**AUDIT RESULT: PASS**

The Competitive Intelligence output is spec-compliant. The inverted scoring for incumbent_weakness is correctly applied: BetterHelp/Teladoc (public company, $2.5B revenue, 7800+ reviews) is scored at 3/20, and the "dominant-incumbent-found" flag is properly set. The INVERSION CHECK self-statement is present and logically consistent. Arithmetic is exact. One minor finding on gap_evidence tier qualification does not warrant a failure.

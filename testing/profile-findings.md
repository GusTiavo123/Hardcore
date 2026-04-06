# Profile Module — Test Findings & Next Steps

**Last updated**: 2026-04-06
**Branch**: feat/hc-profile
**Status**: Gate 1 mostly complete, Gates 2-4 pending

---

## Issues Found (Gate 1)

### Issue 1: Diego status "blocked" vs protocol expectation "partial"

**What**: `diego-minimo.yaml` and `PROTOCOL.md` Gate 1 expect status "partial" for Diego. Actual result is "blocked" (core 0.22, below 0.3 threshold).

**Why it happens**: With only 4 words of input ("Diego, Lima, developer, 5 años"), there aren't enough data points to fill 30% of core fields. Core has ~41 leaf fields. 4 words populate ~9 fields = 0.22.

**Fix**: Update `testing/personas/diego-minimo.yaml` description and `PROTOCOL.md` Gate 1 checklist to expect "blocked" instead of "partial". The profiler is behaving correctly — the expectation was wrong.

**Files to change**:
- `testing/personas/diego-minimo.yaml` — line "Que el status es 'partial'" → "Que el status es 'blocked'"
- `testing/PROTOCOL.md` — Gate 1 checklist item about diego-minimo

---

### Issue 2: Absent skills listed as "familiar" (P3 Nico)

**What**: Nico said "No tengo ni idea de ventas ni marketing." The profiler listed Sales and Marketing as business skills with level "familiar" and evidence "Self-declared zero knowledge."

**Why it matters**: Downstream modules seeing a "familiar" skill may assume there's some capability. The ground truth has `business: []` — the correct approach is to not list skills the user explicitly says they don't have.

**Fix**: Add rule to `skills/hc-profile/SKILL.md` Step 2 (quick mode extraction):
> "If the user explicitly declares they do NOT have a skill (e.g., 'no sé nada de X'), do NOT include it in the skills arrays. The absence of a skill is the data — do not list it at any level. The schema has no 'none' level; omission is the correct representation."

**Files to change**:
- `skills/hc-profile/SKILL.md` — add rule under quick mode extraction

---

### Issue 3: Ambiguous helper classified as cofounder (P2 Carla)

**What**: Carla said "Mi marido es programador y me puede ayudar." The profiler set `solo: false` and added the husband as a cofounder with commitment "part-time." Ground truth has `solo: true`.

**Why it matters**: "Me puede ayudar" is deliberately ambiguous. Classifying someone as cofounder has downstream implications (team capability assessment, execution risk).

**Fix**: Add rule to `skills/hc-profile/SKILL.md` Step 2:
> "When a person's role is ambiguous (e.g., 'can help', 'sometimes assists'), do NOT classify them as a cofounder. Keep `solo: true` and note the available resource in a less committed way — e.g., add them to `resources.infrastructure` or `resources.team.contractors_available: true` with context. Only classify someone as a cofounder when their commitment and role are explicit."

**Files to change**:
- `skills/hc-profile/SKILL.md` — add rule under team classification

---

### Issue 4: market_proximity overestimation pattern

**What**: Profiler consistently overestimates market proximity by +1:
- P1 Tomás: extracted 1, GT 0 (he IS a freelancer, target = freelancers)
- P4 Vale: extracted 2, GT 1 (she knows 100+ business owners personally)

**Why it matters**: market_proximity is the single most impactful meta signal for founder-idea fit. Off by 1 means the difference between "strong domain match" and "moderate."

**Fix**: Sharpen the inference rules in `skills/hc-profile/SKILL.md` Step 3 (Infer Meta Signals):
> "When evaluating market_proximity, ask: if this founder built a product for the domain they work in, would they themselves be a user? If YES → 0. Do they have direct, personal relationships with potential customers (not just 'knows the industry')? If YES → 1. The default should be to give the LOWEST applicable number, not the highest."

**Files to change**:
- `skills/hc-profile/SKILL.md` — update market_proximity inference table

---

### Issue 5: SaaS missing from Vale's domain_expertise (P4)

**What**: Vale described building and shutting down a SaaS. The profiler captured e-commerce (operator) and marketing digital (operator) but missed SaaS as a domain (observer, ~8 months).

**Why it matters**: Domain expertise classification is the "most impactful" field per the schema. Missing a domain means downstream modules can't see this knowledge.

**Fix**: No SKILL.md change needed — this is extraction quality, not a rule issue. The profiler should infer domain_expertise from any venture the user describes, even failed ones. An 8-month SaaS = at least observer-level knowledge. This may improve with the absent-skills fix (Issue 2) since the profiler will pay more attention to what to include vs exclude.

---

### Issue 6: null vs [] inconsistency across profiles

**What**: P4 Vale uses `null` for some arrays (communities, values, proprietary_insights). P1-P3 use `[]` for the same scenario.

**Why it matters**: Downstream modules must handle both `null` and `[]`. The semantic difference (null = "not asked", [] = "asked, none declared") is meaningful but the inconsistency across profiles created in the same mode (quick) is a bug.

**Fix**: Add convention to `skills/hc-profile/SKILL.md`:
> "In quick mode, use `null` for scalar fields not mentioned in the input. For array fields, use `[]` (empty array) — even if the user didn't mention them. Reserve `null` for arrays only in update mode when a specific array was never addressed. This ensures downstream modules can always iterate over arrays without null checks."

**Files to change**:
- `skills/hc-profile/SKILL.md` — add null vs [] convention
- `skills/hc-profile/references/data-schema.md` — clarify in Null Handling section

---

### Issue 7: domain_expertise for generic "Software Development" (P5 Diego)

**What**: Diego's profile has `domain_expertise: [{domain: "Software Development"}]`. The ground truth has `[]`. Domain expertise refers to industry/vertical knowledge (fintech, logistics, e-commerce), not generic technical categories.

**Fix**: Add clarification to `skills/hc-profile/references/data-schema.md` under the domain_expertise section:
> "domain_expertise refers to industry or vertical knowledge, not technical skill categories. 'Software Development' is not a domain — it belongs in `skills.technical`. Domains are industries where the founder has insider knowledge: fintech, logistics, healthcare, e-commerce, etc."

**Files to change**:
- `skills/hc-profile/references/data-schema.md` — clarify domain_expertise definition

---

### Issue 8: Extended artifact persisted when empty (P5 Diego)

**What**: SKILL.md says "Artifact 2 — Extended Profile (only if extended dimensions are populated)." Diego's extended is 100% empty but was persisted anyway.

**Fix**: This is a minor protocol violation. The SKILL.md rule is clear. No spec change needed — the sub-agent just didn't follow it. Noting for awareness.

---

## Gate Status

### Gate 1: Profile Standalone

| Check | Status | Notes |
|---|---|---|
| 5 personas created via quick mode | DONE | All 5 completed, 15 Engram artifacts |
| Schema valid | DONE | All fields present in all 5 profiles |
| Persisted in Engram | DONE | All recoverable via mem_search + mem_get_observation |
| At least 1 profile update tested | **PENDING** | Need to update a field and verify revision_count increments |
| diego-minimo status correct | **FAIL→FIX** | Fix protocol expectation from "partial" to "blocked" |
| /profile:show displays correctly | **PENDING** | Quick test, can do anytime |

### Gate 2: Backward Compatibility

| Check | Status | Notes |
|---|---|---|
| 2+ ideas run with NO profile | **AVAILABLE** | 5 existing runs in testing/runs/ (2026-03-23) serve as baselines |
| Baseline department scores established | **AVAILABLE** | Scores recorded in verdict.yaml files |

**Note**: The existing validation test runs from 2026-03-23 ARE the P0 (no-profile) baselines. We don't need to re-run them — we just need to run the same ideas WITH a profile and compare scores.

### Gate 3: Integration (CRITICAL — NOT STARTED)

| Check | Status | Notes |
|---|---|---|
| 2+ personas × 2+ ideas | **PENDING** | Suggested pairs below |
| Scores within ±5 of baseline | **PENDING** | Compare against 2026-03-23 runs |
| Verdict identical with/without profile | **PENDING** | Most important check |
| Fit assessment produced | **PENDING** | |
| At least 1 BLOCK scenario | **PENDING** | Tomás × education idea |
| Human evaluation of fit narratives | **PENDING** | |

**Suggested persona × idea pairs**:

| Persona | Idea | Expected Result |
|---|---|---|
| Tomás (UX freelancer) | `go-invoice-freelancers` | HIGH fit — he IS the market (freelancer LATAM) |
| Carla (logistics ops) | `pivot-restaurant-waste` | MODERATE fit — supply chain adjacent, part-time constraint |
| Vale (serial entrepreneur) | `go-api-docs-devtools` | LOW fit — no tech skills, wrong domain |
| Diego (minimal) | `go-api-docs-devtools` | PARTIAL fit — flag `partial-fit-assessment`, midpoints |
| Tomás | `pivot-ai-tutoring-kids` | **BLOCK** — hard_nos includes "educación" |

### Gate 4: Fit Calibration

| Check | Status | Notes |
|---|---|---|
| 6 fit scenarios arithmetic verified | **VERIFIED** | All 6 in calibration/fit-scenarios.md are arithmetically correct |
| Fit labels correct | **VERIFIED** | FC01=strong, FC02=weak, FC03=misaligned, FC04=weak, FC05=strong, FC06=moderate |

**Gate 4 is DONE** — the scenarios are pure arithmetic and all check out.

---

## Recommended Order of Next Steps

1. **Apply spec fixes** (Issues 1-4, 6-7) — small changes, prevent the same problems in Gate 3
2. **Gate 1 remaining**: profile update test + /profile:show
3. **Gate 3**: Run the 5 persona × idea pairs — this is the real integration test
4. **Final review** before merge to main

---

## Files Modified During Testing

No spec/skill files were modified. Only test result files were created:

```
testing/runs/profile/2026-04-06_desktop_gate1/
├── gate1-report.md
├── tomas-freelancer.yaml
├── carla-corporate.yaml
├── nico-tecnico.yaml
├── vale-serial.yaml
└── diego-minimo.yaml
testing/profile-findings.md   (this file)
```

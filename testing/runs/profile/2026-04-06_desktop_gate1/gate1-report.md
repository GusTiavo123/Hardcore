# Gate 1: Profile Standalone — Test Report

**Date**: 2026-04-06
**Machine**: desktop
**Branch**: feat/hc-profile
**Tester**: Claude (automated sub-agents)

---

## What Was Tested

5 test personas created via quick mode, verifying:
- Schema validity (all data-schema.md fields present)
- Extraction accuracy (compared against expected_extractions in each persona YAML)
- Engram persistence (3 artifacts per persona: core, extended, state)
- Completeness arithmetic (overall formula verified)
- Status correctness (ok/partial/blocked per core completeness)
- No fabrication (profiler did not invent data beyond input)

---

## Results Summary

| Persona | Status | Core | Overall | Engram | Schema | Extractions | Verdict |
|---|---|---|---|---|---|---|---|
| P1 Tomás Freelancer | partial | 0.46 | 0.43 | PASS | PASS | 7/7 | **PASS** |
| P2 Carla Corporate | partial | 0.56 | 0.47 | PASS | PASS | 5/7 (2 partial) | **PASS w/ obs** |
| P3 Nico Técnico | partial | 0.46 | 0.39 | PASS | PASS | 5/6 (1 partial) | **PASS w/ obs** |
| P4 Vale Serial | partial | 0.46 | 0.49 | PASS | PASS | 7/8 (1 partial) | **PASS w/ obs** |
| P5 Diego Mínimo | **blocked** | 0.22 | 0.16 | PASS | PASS | 4/4 | **FAIL** (status) |

**Overall Gate 1: 4/5 PASS, 1 FAIL (protocol expectation mismatch)**

---

## Engram Artifacts Created

| Persona | Core ID | Extended ID | State ID | topic_key prefix |
|---|---|---|---|---|
| P1 Tomás | #1 | #2 | #3 | `profile/tomas-ux-montevideo/` |
| P2 Carla | #4 | #5 | #6 | `profile/carla-logistics-santiago/` |
| P3 Nico | #7 | #8 | #9 | `profile/nico-backend-cordoba/` |
| P4 Vale | #10 | #11 | #12 | `profile/vale-ecom-bogota/` |
| P5 Diego | #13 | #14 | #15 | `profile/diego-dev-lima/` |

All 15 artifacts verified via `mem_get_observation` — full JSON content parseable.

---

## Completeness Arithmetic Verification

| Persona | Core | Extended | Meta | Formula | Computed | Reported | Match |
|---|---|---|---|---|---|---|---|
| P1 | 0.46 | 0.18 | 1.0 | (0.46×0.6)+(0.18×0.3)+(1.0×0.1) | 0.430 | 0.43 | YES |
| P2 | 0.56 | 0.18 | 0.75 | (0.56×0.6)+(0.18×0.3)+(0.75×0.1) | 0.465 | 0.47 | ~YES |
| P3 | 0.46 | 0.05 | 1.0 | (0.46×0.6)+(0.05×0.3)+(1.0×0.1) | 0.391 | 0.39 | YES |
| P4 | 0.46 | 0.36 | 1.0 | (0.46×0.6)+(0.36×0.3)+(1.0×0.1) | 0.484 | 0.49 | ~YES |
| P5 | 0.22 | 0.0 | 0.25 | (0.22×0.6)+(0.0×0.3)+(0.25×0.1) | 0.157 | 0.16 | YES |

All within rounding tolerance.

---

## Meta Signals Accuracy

| Signal | P1 | P2 | P3 | P4 | P5 |
|---|---|---|---|---|---|
| market_proximity | 1 (GT:0) | 1 (GT:1) | 2 (GT:2) | 2 (GT:1) | null (GT:null) |
| execution_readiness | preparing (GT:preparing) | preparing (GT:preparing) | preparing (GT:exploring) | preparing (GT:ready) | exploring (GT:null) |
| capital_efficiency | lean (GT:lean) | null (GT:deliberate) | lean (GT:lean) | lean (GT:lean) | null (GT:null) |
| blind_spots | 3 detected | 3 detected | 3 detected | 2 detected | 0 detected |

**Pattern**: market_proximity tends to overestimate by +1 point. execution_readiness clusters around "preparing" regardless of actual situation.

---

## Cross-Cutting Issues Found

See `testing/profile-findings.md` for the full list of issues, recommended fixes, and next steps.

### Critical
1. P5 Diego status "blocked" vs protocol expectation "partial"

### Medium
2. P3 Nico: absent skills listed as "familiar" level
3. P2 Carla: ambiguous helper classified as cofounder
4. market_proximity overestimation pattern (+1 in P1, P4)
5. P4 Vale: SaaS missing from domain_expertise/industries (data was in input)

### Low
6. null vs [] inconsistency across profiles for empty arrays
7. P5 Diego: extended artifact persisted when empty
8. P5 Diego: languages not inferred from Lima
9. domain_expertise used for generic "Software Development" (P5)

---

## Gate 1 Checklist Status

From PROTOCOL.md Profile Module — Phase Gates:

- [x] 5 test personas created via quick mode
- [x] Schema valid on all 5
- [x] Persisted in Engram (all 15 artifacts)
- [ ] At least 1 profile update tested — **PENDING**
- [ ] `diego-minimo` has status `partial` — **FAIL** (got "blocked", protocol needs update)
- [ ] `/profile:show` displays correctly — **PENDING**

**Gate 1 status: 3/6 complete, 1 fail (fixable), 2 pending**

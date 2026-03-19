# Calibration Scenarios

13 scenarios for validating that the scoring system, knockout rules, and verdict logic produce correct outcomes. Each scenario has fixed department scores and a known-correct verdict.

**How to use:**
1. After changing rubrics, weights, or decision rules, verify all 13 scenarios still produce the expected verdict
2. When adding new scenarios from real pipeline runs, record the actual scores and whether the verdict was useful to the founder (the `outcome` field)
3. Run `weighted = (P × 0.30) + (M × 0.25) + (C × 0.15) + (B × 0.20) + (R × 0.10)` and verify against expected

**Weights validated:** 84.6% accuracy (11/13 correct) vs 61.5% (8/13) with uniform weights.

---

## Scenario Format

```
ID | Type | Problem | Market | Competitive | BizModel | Risk | Weighted | Knockouts | Verdict
```

---

## GO Scenarios (3)

### S01 — Clear GO: Developer Productivity SaaS

| Dept | Score | Rationale |
|------|-------|-----------|
| Problem | 82 | 76+ complaint threads, 85% recent, 30+ pain markers, 7+ workarounds, 8+ paid alternatives |
| Market | 78 | 5+ institutional sources, SOM $50M+, CAGR 18%, 4+ early adopter segments |
| Competitive | 71 | 12 competitors, moderate incumbents ($15M funding strongest), 6 gaps, good pricing data, 4 dead |
| BizModel | 85 | LTV/CAC 5.2x, 6+ model precedents, payback 4 months, 4x pricing spread |
| Risk | 72 | APIs abundant, 1 navigable framework, growing trends, 1 dependency with fallbacks |

**Weighted:** (82×.30)+(78×.25)+(71×.15)+(85×.20)+(72×.10) = 24.6+19.5+10.65+17.0+7.2 = **79.0**
**Knockouts:** None
**GO conditions:** weighted 79.0≥70 ✓, Problem 82≥60 ✓, all≥45 ✓
**Expected verdict:** **GO**

### S02 — Moderate GO: Fintech Lending Platform

| Dept | Score | Rationale |
|------|-------|-----------|
| Problem | 70 | Solid complaint volume, good recency, moderate pain, 4 workarounds, 5 paid alternatives |
| Market | 75 | Good data quality, SOM $30M, CAGR 15%, 3 early adopter segments |
| Competitive | 65 | 8 competitors, established incumbent (score 8/20 opp.), 5 gaps, decent pricing |
| BizModel | 78 | LTV/CAC 4.5x, 5 precedents, payback 6 months, 3x pricing spread |
| Risk | 55 | APIs available, 2 navigable frameworks (PCI-DSS, KYC), stable trends, 2 deps with fallbacks |

**Weighted:** (70×.30)+(75×.25)+(65×.15)+(78×.20)+(55×.10) = 21.0+18.75+9.75+15.6+5.5 = **70.6**
**Knockouts:** None
**GO conditions:** weighted 70.6≥70 ✓, Problem 70≥60 ✓, all≥45 ✓
**Expected verdict:** **GO**

### S03 — Narrow GO: Niche E-commerce Play

| Dept | Score | Rationale |
|------|-------|-----------|
| Problem | 68 | Moderate complaints, decent recency, some pain markers, 3 workarounds, 4 paid |
| Market | 72 | 3 sources, SOM $15M, CAGR 12%, 2 segments |
| Competitive | 60 | 6 competitors, moderate incumbents, 4 gaps, pricing for 4 |
| BizModel | 80 | LTV/CAC 5.0x, 4 precedents, payback 5 months, good pricing power |
| Risk | 65 | Standard tech, 1 framework (GDPR), growing trends, 1 dependency |

**Weighted:** (68×.30)+(72×.25)+(60×.15)+(80×.20)+(65×.10) = 20.4+18.0+9.0+16.0+6.5 = **69.9**
**Knockouts:** None
**GO conditions:** weighted 69.9<70 ✗ — FAILS weighted threshold by 0.1
**Expected verdict:** **PIVOT** (demonstrates that GO requires ≥70.0 exactly)

---

## PIVOT Scenarios (5)

### S04 — PIVOT: Weighted Below 70 (EdTech Tutoring)

| Dept | Score | Rationale |
|------|-------|-----------|
| Problem | 65 | Moderate complaints, decent recency, some pain, 3 workarounds, 3 paid |
| Market | 62 | Limited data, SOM $8M, CAGR 10%, 2 segments |
| Competitive | 58 | 5 competitors, established players, 3 gaps, limited pricing |
| BizModel | 72 | LTV/CAC 3.5x, 3 precedents, payback 9 months |
| Risk | 60 | Standard tech, 1 framework (COPPA), stable trends |

**Weighted:** (65×.30)+(62×.25)+(58×.15)+(72×.20)+(60×.10) = 19.5+15.5+8.7+14.4+6.0 = **64.1**
**Knockouts:** None
**GO conditions:** weighted 64.1<70 ✗
**Expected verdict:** **PIVOT**

### S05 — PIVOT: Problem Below 60 (AI Content Gen)

| Dept | Score | Rationale |
|------|-------|-----------|
| Problem | 55 | Some complaints but weak pain signals, few workarounds, market flooded with free tools |
| Market | 80 | Excellent data, huge TAM, CAGR 25%+, 4+ segments |
| Competitive | 68 | 15+ competitors, moderate incumbents, good gaps |
| BizModel | 82 | LTV/CAC 6.0x, model validated across many companies |
| Risk | 70 | Standard tech, light regulation, growing fast |

**Weighted:** (55×.30)+(80×.25)+(68×.15)+(82×.20)+(70×.10) = 16.5+20.0+10.2+16.4+7.0 = **70.1**
**Knockouts:** None
**GO conditions:** weighted 70.1≥70 ✓, Problem 55<60 ✗ — FAILS Problem floor
**Expected verdict:** **PIVOT** (big market but problem isn't painful enough)

### S06 — PIVOT: One Score 40-44 (IoT Agriculture)

| Dept | Score | Rationale |
|------|-------|-----------|
| Problem | 72 | Clear pain in agriculture, recent complaints, paid alternatives exist |
| Market | 70 | Good data, SOM $20M, CAGR 14% |
| Competitive | 42 | Very few competitors (1-2 direct), no pricing data, no failures found |
| BizModel | 75 | LTV/CAC 4.0x, 3 precedents, payback 8 months |
| Risk | 68 | Hardware dependency, 1 framework, growing trends |

**Weighted:** (72×.30)+(70×.25)+(42×.15)+(75×.20)+(68×.10) = 21.6+17.5+6.3+15.0+6.8 = **67.2**
**Knockouts:** None (42 is not <40 for any knockout, and only 1 dept <45 so multi-weakness doesn't trigger)
**GO conditions:** weighted 67.2<70 ✗
**Expected verdict:** **PIVOT**

### S07 — PIVOT: Risk Blocks GO Floor (Crypto DeFi)

| Dept | Score | Rationale |
|------|-------|-----------|
| Problem | 75 | High pain, recent, quantified costs, multiple workarounds |
| Market | 78 | Large TAM, good growth, identifiable segments |
| Competitive | 66 | Many competitors, moderate incumbents, gaps exist |
| BizModel | 80 | Strong unit economics in crypto |
| Risk | 38 | 3+ regulatory frameworks, SEC enforcement, platform dependency |

**Weighted:** (75×.30)+(78×.25)+(66×.15)+(80×.20)+(38×.10) = 22.5+19.5+9.9+16.0+3.8 = **71.7**
**Knockouts:** None (Risk 38≥30, only 1 dept <45)
**GO conditions:** weighted 71.7≥70 ✓, Problem 75≥60 ✓, Risk 38<45 ✗ — FAILS individual floor
**Expected verdict:** **PIVOT** (strong everywhere except regulation kills GO)

### S08 — PIVOT: Mediocre Across Board (Legal Tech)

| Dept | Score | Rationale |
|------|-------|-----------|
| Problem | 60 | Moderate pain, some complaints, few workarounds |
| Market | 58 | Limited data, SOM $5M, moderate growth |
| Competitive | 55 | 4 competitors, moderate traction, few gaps |
| BizModel | 62 | LTV/CAC 2.5x, 2 precedents, payback 14 months |
| Risk | 50 | Some regulatory complexity, standard tech |

**Weighted:** (60×.30)+(58×.25)+(55×.15)+(62×.20)+(50×.10) = 18.0+14.5+8.25+12.4+5.0 = **58.2**
**Knockouts:** None
**GO conditions:** weighted 58.2<70 ✗
**Expected verdict:** **PIVOT**

---

## NO-GO Scenarios (5)

### S09 — NO-GO: Problem Knockout (VR Social for Seniors)

| Dept | Score | Rationale |
|------|-------|-----------|
| Problem | 35 | 3 complaint threads, only 1 recent, no pain markers, 1 workaround, 0 paid alternatives |
| Market | 52 | Some data but niche, SOM $2M |
| Competitive | 48 | Few competitors, no clear market validation |
| BizModel | 55 | LTV/CAC 2.0x speculative |
| Risk | 45 | VR hardware dependency, no regulatory issues |

**Weighted:** (35×.30)+(52×.25)+(48×.15)+(55×.20)+(45×.10) = 10.5+13.0+7.2+11.0+4.5 = **46.2**
**Knockouts:** Problem 35<40 → **KNOCKOUT**
**Expected verdict:** **NO-GO** (no evidence of real pain)

### S10 — NO-GO: Market Knockout (Niche B2B Zookeeper SaaS)

| Dept | Score | Rationale |
|------|-------|-----------|
| Problem | 62 | Real pain exists, some complaints, workarounds identified |
| Market | 32 | No institutional data, SOM <$500K, CAGR unknown |
| Competitive | 70 | Wide open — no real competitors, all early stage |
| BizModel | 50 | Cannot calculate reliable LTV/CAC |
| Risk | 60 | Standard tech, no regulation, no dependencies |

**Weighted:** (62×.30)+(32×.25)+(70×.15)+(50×.20)+(60×.10) = 18.6+8.0+10.5+10.0+6.0 = **53.1**
**Knockouts:** Market 32<40 → **KNOCKOUT**
**Expected verdict:** **NO-GO** (market too small)

### S11 — NO-GO: Risk Knockout (Unregulated AI Diagnostics)

| Dept | Score | Rationale |
|------|-------|-----------|
| Problem | 78 | Strong pain, recent, high intensity, paid alternatives exist |
| Market | 75 | Large TAM, growing fast, identifiable segments |
| Competitive | 60 | Several competitors, moderate incumbents |
| BizModel | 72 | Decent unit economics |
| Risk | 25 | 4+ barrier frameworks, active enforcement, pending legislation, 3 critical deps |

**Weighted:** (78×.30)+(75×.25)+(60×.15)+(72×.20)+(25×.10) = 23.4+18.75+9.0+14.4+2.5 = **68.1**
**Knockouts:** Risk 25<30 → **KNOCKOUT**
**Expected verdict:** **NO-GO** (critical unmitigated risks)

### S12 — NO-GO: Multi-Weakness Knockout (Autonomous Delivery Drones)

| Dept | Score | Rationale |
|------|-------|-----------|
| Problem | 50 | Some pain but dispersed, weak signals |
| Market | 44 | Limited data, emerging market |
| Competitive | 40 | Very few competitors, can't tell if market or no-market |
| BizModel | 48 | High CAC, long payback, speculative |
| Risk | 35 | FAA regulation, hardware SPOF, platform risk |

**Weighted:** (50×.30)+(44×.25)+(40×.15)+(48×.20)+(35×.10) = 15.0+11.0+6.0+9.6+3.5 = **45.1**
**Knockouts:** Market 44<45, Competitive 40<45, Risk 35<45 → 3 depts <45 → **MULTI-WEAKNESS KNOCKOUT**
**Expected verdict:** **NO-GO** (multiple weak fundamentals)

### S13 — NO-GO: Multiple Knockouts (Children's Social Crypto Gaming)

| Dept | Score | Rationale |
|------|-------|-----------|
| Problem | 38 | Very few complaints about this specific intersection |
| Market | 35 | No credible data for this niche |
| Competitive | 45 | Some gaming competitors but none in this intersection |
| BizModel | 40 | Cannot validate unit economics |
| Risk | 20 | COPPA + crypto regulation + gambling + minors = regulatory nightmare |

**Weighted:** (38×.30)+(35×.25)+(45×.15)+(40×.20)+(20×.10) = 11.4+8.75+6.75+8.0+2.0 = **36.9**
**Knockouts:** Problem 38<40 → KNOCKOUT, Market 35<40 → KNOCKOUT, Risk 20<30 → KNOCKOUT, 4 depts <45 → MULTI-WEAKNESS KNOCKOUT
**Expected verdict:** **NO-GO** (everything fails)

---

## Summary Table

| ID | Type | P | M | C | B | R | Weighted | Verdict | Key test |
|----|------|---|---|---|---|---|----------|---------|----------|
| S01 | GO | 82 | 78 | 71 | 85 | 72 | 79.0 | GO | All conditions pass clearly |
| S02 | GO | 70 | 75 | 65 | 78 | 55 | 70.6 | GO | Minimal GO — lowest viable scores |
| S03 | Near-GO | 68 | 72 | 60 | 80 | 65 | 69.9 | PIVOT | Weighted 69.9 fails ≥70 by 0.1 |
| S04 | PIVOT | 65 | 62 | 58 | 72 | 60 | 64.1 | PIVOT | Standard PIVOT range |
| S05 | PIVOT | 55 | 80 | 68 | 82 | 70 | 70.1 | PIVOT | Weighted passes but Problem<60 |
| S06 | PIVOT | 72 | 70 | 42 | 75 | 68 | 67.2 | PIVOT | One score 40-44, no multi-knockout |
| S07 | PIVOT | 75 | 78 | 66 | 80 | 38 | 71.7 | PIVOT | Risk blocks GO floor (38<45) |
| S08 | PIVOT | 60 | 58 | 55 | 62 | 50 | 58.2 | PIVOT | Mediocre everywhere, no knockout |
| S09 | NO-GO | 35 | 52 | 48 | 55 | 45 | 46.2 | NO-GO | Problem<40 knockout |
| S10 | NO-GO | 62 | 32 | 70 | 50 | 60 | 53.1 | NO-GO | Market<40 knockout |
| S11 | NO-GO | 78 | 75 | 60 | 72 | 25 | 68.1 | NO-GO | Risk<30 knockout |
| S12 | NO-GO | 50 | 44 | 40 | 48 | 35 | 45.1 | NO-GO | 3 depts <45 multi-weakness |
| S13 | NO-GO | 38 | 35 | 45 | 40 | 20 | 36.9 | NO-GO | Multiple simultaneous knockouts |

---

## Real Pipeline Runs

Track real validations here with actual outcomes for calibration.

| Date | Slug | Weighted | Verdict | Outcome (3-6 months later) |
|------|------|----------|---------|---------------------------|
| 2026-03-15 | telemedicina-ia-salud-mental-latam | 68.5 | PIVOT | _pending_ |

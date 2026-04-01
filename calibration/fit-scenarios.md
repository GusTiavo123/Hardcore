# Founder-Idea Fit — Calibration Scenarios

These scenarios validate the **arithmetic** of the fit scoring formula. They use fixed dimension scores — no personas, no departments, no web search. If the math is right, these pass. If not, the rubric or formula has a bug.

## Formula

```
fit_score = round((sum of 6 dimensions / 120) * 100)
```

Each dimension: 0-20. Total raw: 0-120. Normalized: 0-100.

## Fit Labels

| Range | Label |
|---|---|
| 80-100 | `strong` |
| 60-79 | `moderate` |
| 40-59 | `weak` |
| 0-39 | `misaligned` |

---

## Scenarios

### FC01 — Realistic Ceiling

A founder who's very well-positioned but not perfect at anything.

| Dimension | Score | Rationale |
|---|---|---|
| Domain Expertise Match | 19 | Operator in exact industry, not quite max |
| Resource Sufficiency | 16 | 14-month runway, full-time, team covers gaps |
| Risk Tolerance Alignment | 17 | Well-aligned (moderate founder + low-risk idea) |
| Network & Distribution | 15 | 5K audience in niche + 1 owned channel |
| Execution Capability | 16 | Strong team, previous venture experience |
| Asymmetric Advantage | 14 | Proprietary insights + network, no unique IP |

**Raw**: 97/120. **Fit score**: round((97/120) × 100) = **81**. **Label**: `strong`.

---

### FC02 — Middle of the Road

Decent founder for this idea but nothing exceptional.

| Dimension | Score | Rationale |
|---|---|---|
| Domain Expertise Match | 11 | Practitioner, 4 years, some insider knowledge |
| Resource Sufficiency | 12 | 8-month runway, part-time but committed |
| Risk Tolerance Alignment | 14 | Moderate ↔ medium risk, aligned |
| Network & Distribution | 9 | Some activatable contacts, 1 community, no audience |
| Execution Capability | 13 | Can build MVP, minor fillable gaps |
| Asymmetric Advantage | 8 | Domain knowledge but nothing proprietary |

**Raw**: 67/120. **Fit score**: round((67/120) × 100) = **56**. **Label**: `weak`.

---

### FC03 — Realistic Floor

A founder with almost nothing going for them.

| Dimension | Score | Rationale |
|---|---|---|
| Domain Expertise Match | 0 | No domain expertise at all |
| Resource Sufficiency | 3 | $500, 1-month runway, exploring |
| Risk Tolerance Alignment | 14 | Aggressive + medium risk = aligned |
| Network & Distribution | 2 | No network, no audience, cold outreach |
| Execution Capability | 5 | Familiar-level skills, solo, basic prototype possible |
| Asymmetric Advantage | 3 | No identifiable advantages |

**Raw**: 27/120. **Fit score**: round((27/120) × 100) = **23**. **Label**: `misaligned`.

---

### FC04 — All Midpoints (Partial Profile)

What happens when every dimension scores 10 — the default for unknown data.

| Dimension | Score | Rationale |
|---|---|---|
| Domain Expertise Match | 10 | Unknown — midpoint default |
| Resource Sufficiency | 10 | Unknown — midpoint default |
| Risk Tolerance Alignment | 10 | Unknown — midpoint default |
| Network & Distribution | 10 | Unknown — midpoint default |
| Execution Capability | 10 | Unknown — midpoint default |
| Asymmetric Advantage | 10 | Unknown — midpoint default |

**Raw**: 60/120. **Fit score**: round((60/120) × 100) = **50**. **Label**: `weak`.

---

### FC05 — Theoretical Maximum

Perfect score across all dimensions. Unlikely in practice but validates the ceiling.

| Dimension | Score | Rationale |
|---|---|---|
| Domain Expertise Match | 20 | Max |
| Resource Sufficiency | 20 | Max |
| Risk Tolerance Alignment | 20 | Max |
| Network & Distribution | 20 | Max |
| Execution Capability | 20 | Max |
| Asymmetric Advantage | 20 | Max |

**Raw**: 120/120. **Fit score**: round((120/120) × 100) = **100**. **Label**: `strong`.

---

### FC06 — Extreme Variance

Very strong in some dimensions, very weak in others. Tests that the formula averages correctly and doesn't bias toward extremes.

| Dimension | Score | Rationale |
|---|---|---|
| Domain Expertise Match | 18 | Operator-level, strong |
| Resource Sufficiency | 4 | Very limited resources |
| Risk Tolerance Alignment | 2 | Major mismatch (conservative + critical risk) |
| Network & Distribution | 17 | Large relevant audience |
| Execution Capability | 15 | Strong team |
| Asymmetric Advantage | 16 | Proprietary data + exclusive access |

**Raw**: 72/120. **Fit score**: round((72/120) × 100) = **60**. **Label**: `moderate`.

---

## Summary Table

| ID | DE | RS | RT | ND | EC | AA | Raw | Score | Label |
|---|---|---|---|---|---|---|---|---|---|
| FC01 | 19 | 16 | 17 | 15 | 16 | 14 | 97 | 81 | strong |
| FC02 | 11 | 12 | 14 | 9 | 13 | 8 | 67 | 56 | weak |
| FC03 | 0 | 3 | 14 | 2 | 5 | 3 | 27 | 23 | misaligned |
| FC04 | 10 | 10 | 10 | 10 | 10 | 10 | 60 | 50 | weak |
| FC05 | 20 | 20 | 20 | 20 | 20 | 20 | 120 | 100 | strong |
| FC06 | 18 | 4 | 2 | 17 | 15 | 16 | 72 | 60 | moderate |

## How to Verify

For each scenario, manually compute:
1. Sum the 6 dimension scores
2. Divide by 120
3. Multiply by 100
4. Round to nearest integer
5. Check label against range table

If Synthesis produces a different fit_score for these exact dimension inputs, the formula implementation is wrong.

# Coherence Rules — 9 Gates (G0–G8)

Reference consumed primarily by Handoff Compiler as the fail-fast gate runner. Contains the full spec of each gate: check algorithm, compatibility matrices, feedback templates, and per-profile criticality.

**Principle**: fail-fast. Each gate runs once. If it fails, the pipeline halts and the user decides the next step (re-run responsible dept, accept with permanent flag, or abort to fix upstream). No automatic retry.

See `skills/_shared/glossary.md` for term definitions.

---

## 1. Gate Runner Flow

```
for gate in [G0, G1, G2, G3, G4, G5, G6, G7, G8]:
    result = gate.check(brand_outputs, validation_refs, profile_ref)
    record_in_trace(result)
    if not result.passed:
        return FailFastResult(
            failed_gate=gate,
            responsible_dept=result.responsible_dept,
            feedback=result.feedback,
            criticality=criticality_for_profile(gate, brand_profile),
            options=build_user_options(result),
            trace=trace
        )
return AllPassedResult(trace=trace)
```

Output state goes to `brand/{slug}/handoff.coherence_trace` and into the AUDIT section of the delivered package.

---

## 2. Gate 0 — Archetype ↔ Market Reality (cross-module)

**Verifies**: the archetype chosen by Strategy is compatible with the market reality derived from Validation.

**Inputs**
- `strategy.archetype`
- `validation/{slug}/market.market_stage`
- `validation/{slug}/competitive.direct_competitors[].weaknesses[]`
- `validation/{slug}/competitive.market_gaps[]`
- `validation/{slug}/competitive.failed_competitors[].reason_failed`
- `strategy.sentiment_landscape` (derived by Strategy from inputs above)

**Sentiment landscape derivation** (Strategy emits this value; Gate 0 consumes it)

| Signal combination | sentiment_landscape |
|---|---|
| `market_stage = mature` AND (weaknesses mention trust/reliability/compliance OR failed_competitors.reason_failed = regulatory/trust_breach) | `trust_heavy` |
| weaknesses include outdated/slow/legacy/bureaucratic AND market_gaps contain "no alternatives" / "underserved" | `disruption_ready` |
| `market_stage = growing` AND no extreme signals | `saturation_neutral` |
| Mostly negative competitive sentiment (3+ direct competitors with critical weaknesses) AND failed_competitors > 3 | `low_trust_context` |
| Other | `mixed` |
| <2 direct_competitors available | `insufficient_data` |

**Compatibility matrix**

| Sentiment | Compatible | Blocked | Friction |
|---|---|---|---|
| `trust_heavy` | Sage, Ruler, Caregiver, Everyman | Outlaw, Rebel | Hero (arrogance), Jester (frivolity) |
| `disruption_ready` | Outlaw, Hero, Magician, Explorer, Creator | — | Ruler (conservative), Everyman (undifferentiated) |
| `saturation_neutral` | All | — | — |
| `low_trust_context` | Sage, Caregiver, Everyman | Outlaw, Jester | Ruler (if trust issue is gatekeeping) |
| `insufficient_data` | N/A — skip gate or escalate | — | — |

**Failure feedback template**
```
⚠ Gate 0 — Archetype does not match market reality

Strategy chose: {archetype}
Market per Validation: {sentiment_landscape} ({concrete evidence: e.g. "compliance-heavy fintech, 3 failed competitors for regulatory reasons, sentiment score low"})
Conflict: {archetype} tends to {impact} in {sentiment_landscape} markets. {Concrete consequence}.

Options:
  1. Re-run Strategy with explicit constraint ("market is {sentiment_landscape}, avoid {blocked archetypes}")
  2. Accept with permanent flag (NOT recommended — strategic risk)
  3. Abort and re-validate whether the market framing is correct
```

**Insufficient data handling**: Gate 0 marks `insufficient_data`. User decides: continue skipping this check, or return to Validation to enrich competitive data.

---

## 3. Gate 1 — Archetype ↔ Founder Profile

**Verifies**: the archetype is compatible with the founder profile when one exists.

**Inputs**: `strategy.archetype`, `founder_brand_context` (from profile-contract.md projection).

**Checks**

| Profile attribute | Archetype incompatible |
|---|---|
| `constraints.risk_tolerance: conservative` | Outlaw, Hero (primary), Magician |
| `motivation.primary_goal: financial-freedom` + working_style `solo` | Hero, Ruler (pretended scale unattainable solo) |
| `motivation.working_style.orientation: technical` only | Lover, Caregiver (if idea is B2C emotional) |
| `constraints.hard_nos` contains values the archetype embodies | Contextual block |

**No profile**: gate marked `skipped_no_profile`, passes.

**Failure feedback template**
```
⚠ Gate 1 — Archetype doesn't fit founder profile

Strategy chose: {archetype}
Profile signal: {specific attribute} = {value}
Conflict: {why}

Options:
  1. Re-run Strategy with founder constraint
  2. Accept with flag (founder-archetype tension)
  3. Update profile (if attribute is outdated)
```

---

## 4. Gate 2 — Voice ↔ Archetype

**Verifies**: voice attributes exhibit the chosen archetype's personality.

**Inputs**: `strategy.archetype`, `strategy.voice_attributes[]`.

**Compatibility matrix** (subset — full list in `archetype-guide.md` §2)

| Archetype | Compatible | Incompatible |
|---|---|---|
| Sage | claro, autorizante, preciso, pedagógico, medido | playful, visceral, raw, strong irony |
| Ruler | confiado, premium, exclusivo, autorizante, formal | casual, humble, playful |
| Jester | juguetón, irónico, ligero, irreverente, inesperado | formal, medido, grave |
| Outlaw | contundente, desafiante, visceral, provocador | medido, suave, amigable |
| Caregiver | empático, cálido, protector, reconfortante | desafiante, distante, frío |
| Hero | confiado, motivacional, determinado, directo | humilde, vacilante, ambiguo |
| Explorer | curioso, expansivo, libre, aventurero | rígido, pesimista, burocrático |
| Creator | expresivo, visual, experimental, original | genérico, previsible, templado |
| Innocent | optimista, claro, honesto, amable | cínico, sarcástico, amenazante |
| Lover | sensual, emocional, íntimo, evocador | analítico clínico |
| Magician | misterioso, transformativo, visionario | mundano, literal |
| Everyman | accesible, directo, honesto, genuino | elitista, pretencioso, enigmático |

**Check**: count how many voice attributes from `strategy.voice_attributes[]` match the compatible list and how many match the incompatible list. Fail if any incompatible match.

**Failure feedback template**
```
⚠ Gate 2 — Voice incompatible with archetype

Archetype: {archetype}
Voice attributes: {list}
Conflict: "{incompatible_attribute}" is incompatible with {archetype}.

Options:
  1. Re-run Verbal with voice reminder
  2. Re-run Strategy (if voice was derived incorrectly from archetype)
  3. Accept with flag
```

---

## 5. Gate 3 — Palette ↔ Archetype

**Verifies**: the palette respects the archetype's color tendencies.

**Inputs**: `strategy.archetype`, `visual.palette.primary[]` (HEX colors).

**Checks**

| Archetype family | Expected HSL range |
|---|---|
| Cool deep (Sage, Ruler, Magician) | hue 200–260, sat 40–60, light 25–55 |
| Warm soft (Caregiver, Innocent) | hue 20–50, sat 30–50, light 60–80 |
| High contrast (Outlaw, Hero) | sat 70+, light extremes |
| Vibrant multi (Jester, Creator) | 3+ accents, sat 60–85 |
| Neutral sophisticated (Everyman, Explorer) | sat 15–40, light varied |

**Algorithm**: convert each palette HEX to HSL. Count how many fall within the archetype's expected range. Fail if >50% are outside.

**Failure feedback template**
```
⚠ Gate 3 — Palette doesn't fit archetype

Archetype: {archetype}
Generated palette: {HEX list with measured HSL}
Expected for {archetype}: {expected range}
Mismatch: {N}/{total} colors outside range.

Options:
  1. Re-run Visual with seed color adjusted (recommended)
  2. Accept with flag (NOT recommended if criticality CRITICAL)
  3. Reconsider archetype (if user suspects wrong archetype)
```

---

## 6. Gate 4 — Palette ↔ Scope (visual_formality)

**Verifies**: palette respects `scope.intensity_modifiers.visual_formality`.

**Inputs**: `scope.intensity_modifiers.visual_formality`, `visual.palette.primary[]`.

**Checks**

| Formality | Requirement |
|---|---|
| `high` | Average saturation < 60, max 1 accent > sat 70, no pure neon colors |
| `medium` | Average saturation ≤ 80, 1-2 accents OK |
| `low` | Permissive (fails only if palette is monotone vs. expressive scope) |

**Failure feedback template**
```
⚠ Gate 4 — Palette formality mismatch

Scope formality: {level}
Generated palette: avg sat {N}, max sat {N}, {N} pure colors
Mismatch: {specific issue}

Options:
  1. Re-run Visual with formality constraint
  2. Accept with flag
```

---

## 7. Gate 5 — Typography ↔ Archetype/Era

**Verifies**: typography pairing matches archetype + `scope.intensity_modifiers.typography_era`.

**Inputs**: `strategy.archetype`, `scope.intensity_modifiers.typography_era`, `visual.typography.heading`, `visual.typography.body`.

**Checks** (examples — full matrix in `archetype-guide.md` §8)

- Sage + `neutral-modern` → Fraunces + Inter ✓
- Sage + display script → ✗
- Jester + `experimental` → display expressive ✓
- Jester + classic serif → ✗
- Ruler + `editorial-classic` → Didone ✓
- Outlaw + `retro-rebel` → condensed industrial sans ✓

**Failure feedback template**
```
⚠ Gate 5 — Typography pairing inconsistent

Archetype: {archetype} + era: {era}
Chosen: {heading} + {body}
Issue: {specific mismatch}

Options:
  1. Re-run Visual with pairing constraint
  2. Accept with flag
```

---

## 8. Gate 6 — Logo ↔ Palette Legibility

**Verifies**: logo renders legibly on all palette variants.

**Inputs**: `logo.primary_svg`, `visual.palette.primary[]`, `visual.palette.neutral[]`.

**Checks** (WCAG contrast)

- Primary logo on light bg: contrast ≥ 4.5:1
- Primary logo on primary color: contrast ≥ 4.5:1
- Mono variant on any bg: ≥ 4.5:1
- Inverse variant on dark bg: ≥ 4.5:1

**Algorithm**: compute luminance via WCAG formula on the rendered SVG color vs. each background. See `skills/brand/visual/references/wcag-utility.md` for exact formulas.

**Failure feedback template**
```
⚠ Gate 6 — Logo illegible on palette

Logo variant: {primary | mono | inverse}
Background: {HEX}
Contrast: {ratio}:1 (needed ≥ 4.5:1)

Options:
  1. Re-run Logo with color adjustments
  2. Adjust palette (re-run Visual)
  3. Accept with flag (NOT recommended — accessibility)
```

---

## 9. Gate 7 — Copy ↔ Voice

**Verifies**: sample copy chunks detectably exhibit the voice attributes.

**Inputs**: `strategy.voice_attributes[]`, `verbal.core_copy.*` (5 random chunks: hero, about, pricing, CTA, manifesto if applicable).

**Algorithm**
1. Select 5 random copy chunks from Verbal output.
2. For each chunk × each voice attribute, self-assess: *"Does this copy exhibit {attribute}?"* (binary).
3. Compute pass rate = correct / (chunks × attributes).
4. Pass if ≥ 80%.

**Failure feedback template**
```
⚠ Gate 7 — Copy doesn't exhibit voice

Voice attributes declared: {list}
Pass rate: {N}% (threshold 80%)
Failing chunks:
  - {chunk 1}: missing {attribute}
  - {chunk 2}: conflict with {attribute}

Options:
  1. Re-run Verbal with voice reminder for these chunks
  2. Accept with flag (copy_voice_compliance_partial)
```

---

## 10. Gate 8 — Logo Form ↔ Scope

**Verifies**: chosen logo respects `scope.intensity_modifiers.logo_primary_form`.

**Inputs**: `scope.intensity_modifiers.logo_primary_form`, `logo.chosen.form_language`.

**Checks**

| Scope form | Chosen logo must be |
|---|---|
| `icon-first` | Symbolic-dominant or combination with prominent symbol |
| `wordmark-preferred` | Include legible and prominent wordmark |
| `symbolic-first` | Predominantly symbolic (text secondary or absent) |
| `combination` | Balanced symbol + wordmark |

**Failure feedback template**
```
⚠ Gate 8 — Logo form mismatch with scope

Scope required: {logo_primary_form}
Chosen logo: {form_language}
Mismatch: {explanation}

Options:
  1. Re-run Logo with form constraint
  2. Override scope (user changed mind — requires explicit re-run of scope_analysis)
  3. Accept with flag
```

---

## 11. Completeness Check (not a gate)

Handoff Compiler verifies that every prompt/section in `scope.output_manifest.*.required` exists in the compiled package. This is manifest validation, not coherence. If something is missing, Handoff regenerates it internally (no user interaction).

---

## 12. Criticality per Brand Profile

Per-profile criticality determines the escalation UI tone and the default recommendation in failure cases.

Legend:
- 🔴 **CRITICAL** — failure is brand-breaking. Default: fix upstream.
- 🟡 **STANDARD** — enforce normally. Default: re-run responsible dept.
- 🟢 **FLEXIBLE** — enforce but accept-with-flag is reasonable for this profile.

| Gate | ent | smb | dev | c-app | c-web | local | media | comm |
|---|---|---|---|---|---|---|---|---|
| G0 — Archetype ↔ Market | 🔴 | 🔴 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🔴 |
| G1 — Archetype ↔ Founder | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🔴 | 🟡 |
| G2 — Voice ↔ Archetype | 🔴 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🔴 | 🔴 |
| G3 — Palette ↔ Archetype | 🔴 | 🟡 | 🟢 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 |
| G4 — Palette ↔ Scope formality | 🔴 | 🟡 | 🟢 | 🟢 | 🟡 | 🟡 | 🟢 | 🟢 |
| G5 — Typography ↔ Archetype/Era | 🔴 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 |
| G6 — Logo ↔ Palette legibility | 🟡 | 🟡 | 🟡 | 🔴 | 🟡 | 🟡 | 🟡 | 🔴 |
| G7 — Copy ↔ Voice | 🔴 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🔴 | 🔴 |
| G8 — Logo form ↔ Scope | 🟡 | 🟡 | 🟡 | 🔴 | 🟡 | 🟡 | 🟡 | 🔴 |

---

## 13. Escalation UI Templates per Criticality

🔴 CRITICAL — fix upstream:
```
⚠ Gate {N} — {failure summary}

🔴 CRITICAL for {brand_profile}. {Specific impact: e.g., "enterprise buyers dismiss brands with any unprofessionalism signal; a single failing signal can kill a $50K deal"}.

Recommended: re-run {responsible_dept}.

Options:
  1. Re-run {dept} with constraint (recommended)
  2. Accept with permanent flag (would compromise {specific consequence})
  3. Abort and fix upstream
```

🟡 STANDARD — re-run clean:
```
⚠ Gate {N} — {failure summary}

Re-running {responsible_dept} is cleanest. Accept-with-flag is viable if tradeoffs convince you.

Options:
  1. Re-run {dept}
  2. Accept with flag
  3. Abort
```

🟢 FLEXIBLE — reasonable to accept:
```
⚠ Gate {N} — {failure summary}

For {brand_profile}, this mismatch is tolerable. Accept-with-flag is reasonable if current direction convinces you.

Options:
  1. Accept with flag (default)
  2. Re-run {dept}
  3. Abort
```

---

## 14. Worked Failure Examples

**Example 1 — Gate 3 fails for `b2b-enterprise`**
Archetype: Sage. Generated palette: sat avg 85, 3 neon colors.
Criticality: 🔴 CRITICAL.
Escalation: recommends re-run with "cool deep tones, navy/slate/amber palette". Explains: "neon palette in enterprise breaks corporate credibility. Enterprise buyers discard brands with unprofessionalism signals."

**Example 2 — Gate 7 fails for `content-media`**
Creator brand. Voice declared: "pedagogical, measured". Copy chunk: "LET'S GOOOO 🔥 THIS WILL CHANGE YOUR LIFE".
Criticality: 🔴 CRITICAL (creator = brand; voice inconsistency = authenticity loss).
Escalation: recommends re-run Verbal with exact voice attributes re-surfaced; or re-run Strategy if voice attributes were mis-derived.

**Example 3 — Gate 4 fails for `b2d-devtool`**
Scope formality: medium. Generated palette: avg sat 88.
Criticality: 🟢 FLEXIBLE.
Escalation: "Developers tolerate vibrant palettes (see Linear, Railway). Accept-with-flag is reasonable if vibrancy is intentional."

**Example 4 — Gate 0 insufficient_data**
competitive.data has 1 direct_competitor. Sentiment landscape cannot be derived reliably.
Options: continue skipping (flag `sentiment_landscape: insufficient_data`) or return to Validation to enrich competitive research.

---

## 15. Coherence Trace Schema

```json
{
  "gates_executed": [
    {
      "gate_id": 0,
      "name": "Archetype ↔ Market reality",
      "result": "passed | failed | skipped",
      "sentiment_landscape_derived": "trust_heavy | ...",
      "feedback": "string | null",
      "criticality_for_profile": "critical | standard | flexible",
      "user_decision": "re_run_{dept} | accept_with_flag | abort | null",
      "re_run_outcome": "passed_on_second_pass | failed_again | null"
    }
  ],
  "final_state": "all_gates_passed | halted_by_user | accepted_with_flags | failed_after_user_decision",
  "halt_reason": "string | null",
  "flags_raised": ["string"]
}
```

This trace is persisted to Engram under `brand/{slug}/handoff.coherence_trace` and also written to `AUDIT.md` in the delivered package.

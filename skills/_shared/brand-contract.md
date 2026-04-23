# Brand Contract (shared across all HC modules)

This document defines how the Brand module consumes upstream artifacts produced by Validation and Profile. Read this before designing anything that feeds Brand or reads Brand output.

---

## Upstream Dependencies

| Source | Requirement | Behavior when missing |
|---|---|---|
| `validation/{idea-slug}/*` (all 6 depts) | **Mandatory** | Brand halts with error: "No validation artifacts found for {slug}. Run /validate first." |
| `validation/{idea-slug}/synthesis` verdict | `GO` or `PIVOT` required | `NO-GO` blocks by default. Override via explicit user confirmation ("brandea igual"). A permanent warning is persisted in Brand outputs. |
| `profile/{user-slug}/core` | Optional | Brand runs in "partial personalization" mode. `decided_without_profile: true` flag in all outputs. |
| `profile/{user-slug}/extended` | Optional | If missing but `core` exists, Brand uses `core` only. Flag: `decided_without_extended_profile: true`. |
| Claude Pro (end user's subscription) | **Mandatory** | Brand halts with error: "Brand requires Claude Design access via Claude Pro, Max, Team, or Enterprise subscription." |

---

## Engram Retrieval Protocol

### Validation artifacts

```
1. mem_search(query: "Validation {dept} {idea-slug}", project: "hardcore")
   → for each dept in [problem, market, competitive, bizmodel, risk, synthesis]

2. mem_get_observation(id: {id from step 1})
   → Full content including **Data** section

3. Parse **Data** as JSON
   → Matches schema in skills/validation/{dept}/references/data-schema.md
```

### Profile artifacts

Follow `profile-contract.md` retrieval protocol. Brand reads `core` always and `extended` when available.

---

## Validation → Brand Field Map

Every field Brand consumes from Validation is listed here with its source path and consumer department. Fields not listed are not consumed by Brand.

### From `validation/{slug}/problem.data`

| Field | Consumer | Usage |
|---|---|---|
| `problem_statement` | Strategy, Verbal | Anchors positioning, informs core copy |
| `target_user` | Strategy, Verbal, Visual | Target ICP for voice calibration, imagery mood |
| `industry` | Strategy, Scope | Archetype fit check, scope classification |
| `pain_intensity` | Strategy, Verbal | Modulates voice urgency and emotional register |
| `current_solutions[]` | Strategy | Differentiation angle from existing workarounds |
| `demand_stack.abstract_need` | Strategy | Higher-order reframe for brand promise |
| `demand_stack.specific_context` | Verbal | Specific pain context for copy |
| `demand_stack.solution_category` | Scope, Strategy | Drives brand_profile classification |

### From `validation/{slug}/market.data`

| Field | Consumer | Usage |
|---|---|---|
| `som.value`, `sam.value` | Scope, Strategy | Ambition sizing; small SOM → niche positioning, large SOM → category positioning |
| `market_stage` | Strategy, Gate 0 | `emerging` allows disruption archetypes, `mature` favors caregiver/ruler/sage |
| `early_adopters[]` | Strategy, Verbal, Visual | Primary audience for voice tone, channel-specific copy, imagery refs |
| `early_adopters[].reachable_channels[]` | Handoff | Channels inform which prompts to include in Prompts Library |
| `growth_rate` | Strategy | Narrative of timing and opportunity |

### From `validation/{slug}/competitive.data`

| Field | Consumer | Usage |
|---|---|---|
| `direct_competitors[]` | Strategy, Visual | Positioning whitespace; palette/typography avoidance (don't look like incumbents) |
| `direct_competitors[].weaknesses[]` | Strategy, Verbal | Differentiation messaging |
| `market_gaps[]` | Strategy | Positioning statement anchors |
| `pricing_benchmark` | Verbal | Pricing copy tone (premium vs accessible) |
| `vulnerability_signals[]` | Strategy | Timing narrative for challenger/outlaw archetypes |
| **`sentiment_landscape`** *(derived)* | Gate 0 | Archetype-market-fit check (trust-heavy markets block rebel/outlaw) |

> Note: `sentiment_landscape` is not a top-level field in `competitive.data`. It is derived by Strategy from `direct_competitors[].weaknesses[]` + `market_gaps[]` + `failed_competitors[].reason_failed`. See Gate 0 derivation in `skills/brand/references/coherence-rules.md`.

### From `validation/{slug}/bizmodel.data`

| Field | Consumer | Usage |
|---|---|---|
| `recommended_model` | Scope, Verbal | Influences brand_profile (b2b-enterprise, consumer-app, marketplace, etc.) |
| `pricing_suggestion.price_point` | Verbal | Pricing copy tone and positioning |
| `pricing_suggestion.billing` | Verbal | Billing terms copy |

### From `validation/{slug}/risk.data`

| Field | Consumer | Usage |
|---|---|---|
| `overall_risk_level` | Strategy | Modulates voice confidence (critical risk → humble/pragmatic; low risk → bold) |
| `top_3_killers[]` | Strategy | What NOT to emphasize in messaging (avoid exposing unresolved risks) |

### From `validation/{slug}/synthesis.data`

| Field | Consumer | Usage |
|---|---|---|
| `verdict` | Orchestrator (pre-flight) | GO/PIVOT required to run; NO-GO blocks without override |
| `confidence` | Strategy | Voice confidence calibration |
| `key_strengths[]` | Strategy, Verbal | What to lean into in messaging |
| `key_concerns[]` | Strategy | What to frame carefully in messaging |
| `founder_fit.fit_score` | Strategy | Signal for personalization depth; weak fit → more founder-domain references in copy |
| `founder_fit.fit_boosters[]` | Strategy, Verbal | Founder credibility angles for brand story |

---

## Profile → Brand Field Map

Brand consumes a curated projection called `founder_brand_context`. Fields not listed here are ignored.

### From `profile/{user-slug}/core.data`

| Field | Consumer | Usage |
|---|---|---|
| `identity.name` | Verbal | Founder voice attribution (if founder-led brand) |
| `identity.languages[]` | Scope, Handoff | Output language selection; multi-lingual brand treatment |
| `skills.domain_expertise[]` | Strategy | Credibility angle; `operator` depth → authority positioning |
| `constraints.hard_nos[]` | Orchestrator (pre-filter) | Abort if idea violates hard no; impacts archetype/value exclusions |
| `constraints.risk_tolerance` | Strategy (voice) | Modulates voice boldness (conservative → measured; aggressive → punchy) |

### From `profile/{user-slug}/extended.data`

| Field | Consumer | Usage |
|---|---|---|
| `motivation.values[]` | Strategy, Verbal | Brand values alignment; informs tone authenticity |
| `motivation.working_style.preference` | Strategy | Team size signal for brand scale claims |
| `motivation.working_style.orientation` | Visual, Verbal | Technical vs business orientation influences aesthetic register |
| `advantages.credibility_capital[]` | Strategy, Verbal | Social proof for founder story in About copy |
| `advantages.proprietary_insights[]` | Strategy | Differentiation angles |
| `previous_ventures[]` | Verbal | Founder narrative material for About/story copy |

---

## `founder_brand_context` Object

The orchestrator assembles this projection from the profile artifacts and passes it to every Brand department as part of the sub-agent input:

```json
{
  "founder_brand_context": {
    "available": true,
    "completeness_level": "full | partial | minimal",
    "name": "string",
    "languages": [{"language": "string", "level": "native | fluent | conversational | basic"}],
    "domain_expertise": [
      {
        "domain": "string",
        "depth": "operator | practitioner | observer",
        "years": "number"
      }
    ],
    "values": ["string"],
    "working_style": {
      "preference": "solo | small-team | team-builder | null",
      "orientation": "technical | business | balanced | null"
    },
    "risk_tolerance": "conservative | moderate | aggressive | null",
    "credibility_capital": ["string"],
    "proprietary_insights": ["string"],
    "previous_ventures_summary": [
      {
        "outcome": "active | sold | shut-down | pivoted | side-project",
        "domain": "string — inferred from profile.skills.domain_expertise",
        "key_lesson": "string"
      }
    ],
    "hard_nos": ["string"]
  }
}
```

When no profile exists: `"founder_brand_context": null`.

---

## Completeness Threshold

Brand reads `profile/{user-slug}/state.completeness.overall`:

| Value | Mode | Effect |
|---|---|---|
| `>= 0.4` | **Full personalization** | `completeness_level: "full"`. All Brand depts consume founder_brand_context normally. |
| `0.2 – 0.4` | **Partial personalization** | `completeness_level: "partial"`. Depts use only non-null fields; flag `decided_with_partial_profile: true` in outputs. |
| `< 0.2` or no profile | **Generic mode** | `founder_brand_context: null`. Flag `decided_without_profile: true`. Brand runs as if no profile existed. |

Rationale: below 0.4, personalization signals become noise rather than signal. Strategy still runs — it just anchors to market data alone.

---

## Voice Precedence

Voice attributes (tone, register, formality, confidence) have three potential sources. Conflict resolution order:

1. **Strategy archetype** (primary) — derived from Jung archetype + positioning
2. **Scope.verbal_register** (constraint) — derived from brand_profile and target audience
3. **Profile motivation.working_style** (modifier) — founder preference

**Rule**: Strategy archetype sets the voice baseline. Scope can *constrain* the register within archetype-compatible options (e.g., Sage archetype allows both "academic formal" and "approachable explainer" — Scope picks based on target audience). Profile preference is recorded as an **annotation** in the Brand Document but does not override archetype/scope when they conflict.

**Example conflict**:
- Market is compliance-heavy fintech → Scope forces `verbal_register: formal`
- Strategy archetype = Sage → baseline voice is pedagogical
- Profile founder prefers "casual, irreverent" tone
- **Resolution**: voice is formal-pedagogical (market requirement wins). Brand Document notes: "Founder preferred casual tone; suppressed due to market formality requirement. Revisit if founder persona takes precedence over brand persona."

---

## Pre-Flight Checks (Orchestrator)

Before launching the Brand pipeline, the orchestrator runs these checks in order:

| # | Check | Failure action |
|---|---|---|
| 1 | Claude Pro subscription available | HALT. Display: "Brand requires Claude Design access via Claude Pro, Max, Team, or Enterprise." |
| 2 | `validation/{slug}/synthesis` exists in Engram | HALT. Display: "No validation found for '{slug}'. Run /validate first." |
| 3 | Verdict is `GO` or `PIVOT` (or user provided explicit override) | HALT with override prompt if NO-GO. |
| 4 | Profile hard-no violation check (if profile exists) | HALT. Display the conflicting hard-no and the idea element that violates it. |
| 5 | All 6 validation dept artifacts retrievable | HALT. Display which dept artifact is missing. |

Pre-flight failures are blocking. The pipeline does not launch any department until all pre-flight checks pass.

---

## Rules for Brand Departments Consuming Context

### 1. Validation data is factual, not advisory

Brand depts do not "re-validate". They treat validation outputs as ground truth for market/competitive/problem reality. A brand dept may say "the positioning we propose is differentiated from {competitor} on {axis}" but may not say "actually {competitor} is stronger than Validation thought."

### 2. Profile context affects qualitative choices, not structural ones

Structural outputs (brand profile classification, number of logo variants, token structure) are determined by Scope Analysis and do not vary with profile. Profile modulates:

- Voice tone (within archetype bounds)
- Copy register
- Narrative framing (founder-led vs product-led story)
- Cultural/linguistic choices in naming

Profile does NOT modulate:
- Archetype (anchored to Strategy logic + market reality)
- Palette (anchored to archetype + accessibility)
- Typography pairs (anchored to brand profile + archetype)
- Brand Document structure

### 3. Null handling

Every Brand dept MUST handle three states of `founder_brand_context`:
- `null` → generic mode, no founder references in outputs
- `{available: true, completeness_level: "partial", ...}` → use only non-null fields, flag partial
- `{available: true, completeness_level: "full", ...}` → full personalization

### 4. Flag propagation

Brand depts surface profile-derived decisions through flags in their output envelope:

| Flag | Dept | When |
|---|---|---|
| `founder-voice-override-suppressed` | Strategy | Profile voice preference conflicted with archetype/scope and was not applied |
| `founder-credibility-anchor` | Strategy, Verbal | Founder credibility_capital used in brand story |
| `founder-language-targeting` | Scope, Handoff | Output language selected based on profile.identity.languages |
| `founder-domain-authority` | Strategy | Operator-level domain expertise leveraged in positioning |
| `decided_without_profile` | All | No profile available; generic mode |
| `decided_with_partial_profile` | All | Profile completeness < 0.4; partial personalization |

---

## Snapshot Protocol

When a Brand pipeline starts, the orchestrator creates snapshots of both upstream artifacts so future re-examination is possible:

```
mem_save(
  title: "Brand Snapshot: Validation @ {idea-slug}",
  topic_key: "brand/{idea-slug}/snapshot/validation",
  type: "discovery",
  project: "hardcore",
  scope: "project",
  content: "**What**: Frozen validation at brand time [brand] [snapshot] [{idea-slug}]

**Where**: brand/{idea-slug}/snapshot/validation

**Data**:
{summary of validation scores, verdict, key fields consumed}"
)
```

If profile exists, a second snapshot is saved at `brand/{idea-slug}/snapshot/profile` with the `founder_brand_context` JSON.

These snapshots enable: (a) re-running Brand deterministically against frozen upstream state, (b) post-hoc analysis of "what context produced this brand?".

---

## Module Manifest (Profile Extensibility)

Brand declares its profile needs at `skills/brand/references/profile-needs.md`. This file tells the profiler which dimensions Brand relies on, so the profiler prioritizes them during guided interviews.

```yaml
module: hc-brand
profile_dimensions:
  required:
    - motivation.values
    - motivation.working_style
    - identity.languages
  optional:
    - advantages.credibility_capital
    - advantages.proprietary_insights
    - previous_ventures
    - skills.domain_expertise
  usage: |
    Values and working style drive brand voice and archetype calibration.
    Languages determine which markets the brand materials target.
    Credibility capital and previous ventures inform the founder story in About copy.
    Domain expertise depth (operator > practitioner > observer) modulates authority positioning.
```

---

## Downstream Contract: Brand → Claude Design

Brand outputs are consumed by Claude Design (claude.ai/design) in the user's browser. The user manually uploads the Brand Design Document PDF to Claude Design's "Set up your design system" flow.

**Claude Design accepted formats** (as of 2026-04):
- PDF (primary — Brand Design Document)
- PowerPoint (.pptx) — not emitted by v1
- Images (logos, palette specimens, typography samples) — Reference Assets folder
- Codebases (for token linking) — Brand Tokens folder
- Markdown — not officially listed; avoid as primary format

**Format decisions for v1**:
- Brand Design Document: **PDF only**
- Reference Assets: **SVG + PNG** (logos), **PNG** (mood imagery)
- Brand Tokens: **CSS custom properties + JSON (DTCG format) + tailwind.config.js**
- Prompts Library: **Markdown** (consumed by the user directly in Claude Design chat, not uploaded to design system setup)

Subscription requirement: Claude Pro, Max, Team, or Enterprise. Not available on Free tier. Brand surfaces this in the reveal message explicitly.

No Claude Design MCP/API exists as of v1. All handoff is manual (user-mediated upload). When Anthropic ships an API/MCP, the Handoff Compiler will add an `--auto-upload` path without changing its output artifacts.

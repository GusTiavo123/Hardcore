---
name: hc-brand-logo
description: >
  Sub-agent that generates logo SVG concepts (Claude native) + derives
  variants (mono, inverse, icon-only) + optional derived assets (favicons,
  OG cards, app icons, covers, merch direction). v1 is geometric-mark
  biased — organic illustrations are out of scope.
dependencies:
  - skills/_shared/brand-contract.md
  - skills/brand/references/archetype-guide.md
---

# Brand — Logo & Key Visuals

You are a sub-agent invoked by the Brand orchestrator. Generate the logo + derived visual assets using Claude native SVG generation. Zero external cost.

## Core Constraint — Geometric Only in v1

All symbolic marks in v1 are **geometric** (mathematical shapes, intersections, lines, simple gradients). Organic mascots, detailed illustrations, and scenic marks are OUT of scope v1 — Claude-native SVG does not reach consistent quality for those. If scope demands an organic mark, emit flag `organic_mark_requested_geometric_delivered: true` with a note suggesting the user take the geometric mark to Claude Design for organic refinement.

## Inputs

From orchestrator:
- `idea`, `slug`, `founder_brand_context`, `user_overrides`

Retrieved from Engram:
- `brand/{slug}/scope` — manifest (drives primary_form + derived assets)
- `brand/{slug}/strategy` — archetype + voice for form-language vocabulary
- `brand/{slug}/visual` — palette to apply + typography for wordmarks
- `brand/{slug}/verbal` — chosen name + tagline for OG card

---

## Process — 7 Steps

### Step 1 — Determine Directions

Per `scope.intensity_modifiers.logo_primary_form`:

| Primary form | Concepts generated | Form language |
|---|---|---|
| `wordmark-preferred` | 3 wordmark + 1 combination | Typographic pure with custom adjustments (letter-spacing, weight, custom-cut of 1 glyph) |
| `combination` | 1 symbolic-geometric + 2 combination + 1 wordmark | Wordmark + geometric symbol (circle, modular square, shape intersection) |
| `symbolic-first` | 3 symbolic-geometric + 1 combination | Geometric mark primary; wordmark secondary |
| `icon-first` (consumer app) | 4 symbolic-geometric optimized for 16×16/app stores + 1 combination | Geometric marks that survive scale-down; 1024px grid with safe area |

For `b2c-consumer-app` with `app_asset_criticality: primary`, prioritize high-legibility-at-16×16 geometric marks (shrink test during generation).

### Step 2 — SVG Generation Strategy

Claude writes SVG markup directly. See `references/svg-templates.md` for complete per-archetype × form-language templates.

**Baseline wordmark structure**:
```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 100" width="400" height="100">
  <text x="20" y="70" font-family="Fraunces, serif" font-size="60" font-weight="600"
        fill="#0B1F3A" letter-spacing="-0.02em">
    {Brand Name}
  </text>
</svg>
```

**Baseline symbolic-geometric structure**:
```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200" width="200" height="200">
  <circle cx="100" cy="100" r="80" fill="#0B1F3A"/>
  <path d="M60 100 L100 60 L140 100 L100 140 Z" fill="#F4EFE6"/>
</svg>
```

**Archetype × form-language tendencies**:

| Archetype | Wordmark adjustments | Symbolic adjustments |
|---|---|---|
| Sage | Classical serif, weight 600-700, slight letter-spacing (-0.02em), stable proportion | Circular + square geometry; symmetric; thin-medium lines |
| Jester | Rounded sans, weight 700+, playful sizing mix | Curved shapes, overlap with vivid color, asymmetric composition |
| Ruler | Modern serif (Didone) or geometric sans, weight 500-600, generous letter-spacing | Angular symmetric geometry, golden ratios, minimal heraldry |
| Outlaw | Condensed sans, weight 800+, tight tracking, 1 distorted glyph | Slash/cut marks, aggressive asymmetry, strong contrast |
| Caregiver | Humanist serif or rounded sans, weight 400-500, warmth | Organic geometrics (heart, leaf via polygons), protagonist circle |
| Hero | Geometric sans weight 700-800, tight tracking, all-caps optional | Triangle-based, scaling, diagonal momentum |
| Explorer | Refined sans weight 500-600, wide tracking | Map lines, compass-like geometry, horizons |
| Creator | Display sans with 1 custom cut, mixed weight | Modular composition, visible grid, stroke + fill contrast |
| Innocent | Rounded sans weight 400-500, generous letter-spacing | Simple shapes (circle, star), clear palette |
| Lover | Romantic serif weight 400, optional italic, thin hairlines | Organic sensual (sinuous shapes via bezier), saturated palette |
| Magician | Geometric sans with 1 transformation, weight 600 | Magical symmetry, sacred geometry, subtle gradients |
| Everyman | Neutral sans weight 500, no frills | Simple universal shapes, rectangle/circle base |

### Step 3 — Generate

Emit SVG markup for each concept. Save to filesystem:
```
output/{slug}/brand/logo/concepts/
├── concept-b1.svg
├── concept-b2.svg
├── concept-b3.svg
└── concept-c1.svg
```

### Step 4 — Quality Validation (Pre-User)

Automatic checks per concept:

| Check | Pass criteria |
|---|---|
| Valid XML | Parse without errors |
| Not empty | Minimum 2 elements (wordmarks: 1 text + optional accent; symbolic: 2+ paths/shapes) |
| Not all-same-color | Uses ≥2 palette colors (except mono/inverse variants) |
| Palette compliance | All colors in Visual's palette (tolerance ±5 in RGB) |
| Reasonable complexity | Element count between 2 and 40 |
| 16px legibility (if `app_asset_criticality: primary`) | Render at 16×16 internally; key features survive (Claude visual-inspection check) |

If a concept fails: regenerate with explicit feedback. Max 2 retries per concept. Skip concept if persistent (require minimum 3 valid concepts to avoid halting).

### Step 5 — User Selection

Present concepts as grid to orchestrator. Each concept includes:
- SVG content (rendered)
- Rationale (1-2 sentences: how it expresses archetype + scope)
- Form language classification

User (via orchestrator) options:
- Pick one
- Pick a direction + regenerate 2-3 variants in that direction
- "None" + feedback → full regen (max 2 full regens before offering manual)
- "Manual" → user uploads own SVG; dept validates (parse + palette check) + propagates downstream

**Fast mode**: auto-pick highest-ranked concept by quality validation + archetype fit.

### Step 6 — Variants of the Chosen Logo

Generated programmatically via SVG XML manipulation — no regeneration needed:

| Variant | How to generate |
|---|---|
| **Primary** (full color) | The chosen concept SVG as-is |
| **Mono** (black on white) | Replace all `fill` with `#000000`, `stroke` with `#000000` |
| **Inverse** (white on dark bg) | Replace all `fill` with `#FFFFFF`, add background rect dark |
| **Icon-only** | If combination: extract only the symbol (drop text elements). If wordmark pure: skip (no icon-only available) |

Claude emits the modified SVG directly for each variant.

### Step 7 — Derived Assets

Conditional per scope manifest and `app_asset_criticality`.

**Always** (programmatic from primary SVG):
- Favicon set: 16×16, 32×32, 48×48 (Claude emits SVGs simplified per size)
- Apple touch icon: 180×180
- Favicon.ico: multi-size combined (Sprint 1 — requires rasterization tool)

**If `app_asset_criticality: primary`** (consumer-app):
- iOS icons: full set (20/29/40/58/60/80/87/120/180/1024 as SVG; raster in Sprint 1)
- Android: foreground + background layers (adaptive icon format)
- Mask variants: circle, rounded, squircle (via clip-path SVG)

**If landing in prompts library**:
- OG card (1200×630): SVG composition (logo + tagline + palette bg). Rasterization in Sprint 1.

**If social presence in scope**:
- Profile pictures (400×400): square crop of logo/icon
- Cover banners: X 1500×500, LinkedIn 1584×396 (composition with logo + palette)

**If `community-movement` or `content-media`**:
- Merch direction (templates, not production-ready):
  - T-shirt layout (hero print + placement in SVG mockup)
  - Sticker designs (circle, square)
  - Mug direction (wrap-around spec in SVG + description)

All derived assets initially SVG. PNG/ICO conversion requires rasterization tool (Sprint 1 — headless chromium or rsvg-convert). If tool unavailable, deliver SVGs + README with manual conversion instructions. Flag `rasterization_deferred_to_user: true`.

---

## Filesystem Output Structure

```
output/{slug}/brand/logo/
├── concepts/
│   └── concept-*.svg
├── source/
│   ├── primary.svg
│   ├── primary-mono.svg
│   ├── primary-inverse.svg
│   └── icon-only.svg (if applicable)
├── derivations/
│   ├── favicon-16.svg (+png if tool available)
│   ├── favicon-32.svg (+png)
│   ├── favicon-48.svg (+png)
│   ├── favicon.ico (if tool)
│   ├── apple-touch-180.svg (+png)
│   ├── og-card-1200x630.svg (+png)
│   ├── profile-pic-400.svg (+png)
│   └── cover-*.svg (+png)
├── app-icons/ (if scope requires)
│   ├── ios/
│   └── android/
├── merch/ (if scope requires)
├── rationale.md
└── usage-guidelines.md
```

---

## Tools

- **Claude native** — SVG generation, palette reasoning, archetype interpretation
- **SVG XML manipulation** — variants (mono/inverse/icon-only) via programmatic transformation
- **Headless rasterization tool** — Sprint 1 (rsvg-convert or similar) for PNG/ICO

---

## Output Assembly

Cross-reference `references/data-schema.md` before returning.

---

## Persist

Save to `brand/{slug}/logo`:

```
mem_save(
  title: "Brand: {slug} — logo ({form_chosen})",
  topic_key: "brand/{slug}/logo",
  type: "discovery",
  project: "hardcore",
  scope: "project",
  content: "**What**: Logo concepts + chosen + variants + derivations [brand] [logo] [{slug}]\n\n**Where**: brand/{slug}/logo + output/{slug}/brand/logo/\n\n**Data**:\n{metadata as JSON string — actual SVGs are on filesystem}"
)
```

---

## Failure Modes

- **Invalid SVG (Claude malformed output)**: retry with explicit prompt; max 2 retries per concept. Skip if persistent (need min 3 valid).
- **Quality validation fails 2+ consecutive concepts**: flag `quality_degraded: true`, warn user.
- **16px legibility fail (consumer-app)**: regenerate with simplification prompt, max 3 retries. Offer manual upload if persistent.
- **User rejects 3+ rounds**: offer manual upload mode.
- **Rasterization tool down**: SVG-only delivery + manual conversion instructions. Flag `rasterization_deferred_to_user: true`.
- **Manual upload by user**: validate (parse + palette check within tolerance), propagate to Handoff.

---

## Critical Rules

1. **Geometric only in v1.** No organic illustrations. Flag if requested.
2. **Palette compliance enforced.** All colors must be from Visual's palette (tolerance ±5 RGB).
3. **Minimum 3 valid concepts.** Do not deliver fewer — retry or halt.
4. **Variants are programmatic.** Do not re-generate mono/inverse/icon-only — transform the primary.
5. **Scope drives derived assets.** Do not generate app icons for non-consumer-app scopes.
6. **Usage guidelines mandatory.** Emit clearspace rule, min size per variant, don'ts.

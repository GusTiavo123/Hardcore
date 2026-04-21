# 06 — Department 3: Visual System

## 6.1 Propósito

Diseñar las **reglas visuales** de la marca — paleta, tipografía, mood direction (tier-dependent), visual principles. **NO genera el logo** (siguiente dept).

Notas específicas:
1. Mood imagery es **tier-dependent** (Tier 0 sin generación, Tier 1+ con Recraft o Unsplash)
2. Palette puede usar Huemint (Tier 1+) o Claude-generated (Tier 0 default)
3. Output alimenta el Brand Document PDF

## 6.2 Inputs

### Obligatorios
- `brand/{slug}/scope` (manifest — determina formality, typography era, tier)
- `brand/{slug}/strategy` (archetype, voice — seed para palette + typography)

### Opcionales
- Profile (constraints culturales)
- Validation Competitive (visual landscape — white space visual, patterns dominantes)

## 6.3 Proceso — 6 pasos

### Paso 1 — Seed colors del archetype

Base mapping por archetype (tabla completa en `skills/brand/visual/references/archetype-palette-seeds.md`):

| Archetype | Color family | Seed suggestions |
|---|---|---|
| Innocent | Soft light | Whites, soft blues, mint, pale pink |
| Sage | Cool deep + warm accent | Navy, charcoal, off-white + amber/gold |
| Explorer | Earthy + vibrant pop | Forest green, terracotta + saffron |
| Outlaw | High contrast | Black, blood red, electric yellow |
| Magician | Deep + metallic | Deep purple, midnight blue + gold/silver |
| Hero | Bold + dynamic | Crimson, navy, bright yellow |
| Lover | Warm romantic | Burgundy, dusty pink, cream |
| Jester | Playful multi | Bright primary mix, high saturation |
| Everyman | Warm neutral | Warm grays, soft earth, friendly orange |
| Caregiver | Warm soft | Terracotta, sage green, cream |
| Ruler | Premium cool | Black, gold, deep green, navy |
| Creator | Vibrant unexpected | Teal + coral + mustard |

**Modulación por `visual_formality`**:
- `high` → saturación reducida, max 1 accent, no neons
- `medium` → balance, 1-2 accents
- `low` → permisivo, hasta 3 accents, saturation alta OK

### Paso 2 — Palette generation (tier-dependent)

**Tier 0 (default) — Claude-generated palette**:
- Claude razona sobre color theory + archetype seeds + visual_formality
- Produce palette de 5 colors con HEX + usage + contrast
- Calidad razonable (GPT-style color reasoning) — suficiente para dogfooding

**Tier 1+ — Huemint API**:
- Endpoint: `POST https://api.huemint.com/color`
- Mode: "transformer" o "diffusion"
- "brand-intersection" config
- Seed: 2-3 colors derived from archetype
- Output: 5 palettes, select la que mejor matcheaa narrativa

**Decision runtime**: si `scope.intensity_modifiers.image_gen_tier == 0`, skip Huemint. Si `>= 1`, use Huemint.

### Paso 3 — WCAG contrast validation

Para cada par text-background:
- Calcular contrast ratio
- Verificar Level AA (4.5:1 body, 3:1 large)
- Ajustar si falla

Herramienta: utility function WCAG inline (pseudocode en `skills/brand/visual/references/wcag-utility.md`).

### Paso 4 — Typography pairing

Claude reasoning basado en archetype + `typography_era`:

| Archetype | Heading tendency | Body tendency | Mood |
|---|---|---|---|
| Sage | Classical serif (Fraunces, Crimson) | Neutral sans (Inter, IBM Plex) | Authority + clarity |
| Ruler | Serif elegante (Playfair, Marcellus) | Sans refined (Söhne) | Premium, editorial |
| Hero | Display bold (Syne, Boldonse) | Sans geometric (Manrope) | Dynamic |
| Creator | Display expresivo (Recoleta, Clash) | Sans friendly (Work Sans) | Crafted |
| Jester | Display playful (Mona Sans, Rubik) | Sans friendly | Fun, unexpected |
| Everyman | Sans humanist (Inter) | Sans humanist | Relatable |
| Caregiver | Serif soft (Lora, Source Serif) | Sans warm (Quicksand) | Warm |
| Innocent | Sans rounded (Quicksand, Nunito) | Sans rounded | Soft, simple |
| Explorer | Serif rugged (Bitter, Merriweather) | Sans utilitarian (IBM Plex) | Rugged |
| Outlaw | Display contundente (Anton, Bebas) | Sans condensed | Disruption |
| Magician | Serif ornate (Cormorant) | Sans clean | Mystical |
| Lover | Serif romantic (Cormorant) | Sans soft | Sensual |

**Todas Google Fonts** (free, commercial OK, widely supported).

**Modulación por `typography_era`**:
- `editorial-classic` → Serif + sans clean (Fraunces + Inter)
- `neutral-modern` → Sans + sans (Inter + Söhne)
- `expressive-contemporary` → Display + sans friendly
- `experimental` → Variable fonts, unconventional pairings

### Paso 5 — Mood imagery (tier-dependent)

**Solo si `scope.output_manifest.reference_assets.conditional_on_tier` incluye `mood_imagery`**.

**Tier 0 (default) — Skip mood imagery generada**:
- No se genera mood imagery propia
- Brand Document usa descripción textual del mood + visual principles
- Si el user quiere mood references para Claude Design projects, usa el campo "mood references" del Brand Document directamente como prompt guide

**Tier 1 — Unsplash curated references**:
- Unsplash API (free, 50 req/h demo)
- Search queries basados en archetype + mood axes
- Pull 6-8 imágenes curated
- Output en Reference Assets folder como `mood-*.jpg`
- Attribution file auto-generated

**Tier 2 — Recraft V4 generated**:
- Prompts estructurados por eje de mood (energy, texture, composition, light)
- 6-8 imágenes generadas, coherent entre sí
- Stylized (no photoreal) — direction de marca única
- Output en Reference Assets folder como `mood-*.png`

### Paso 6 — Visual principles

Documentar en lenguaje natural:
- Whitespace philosophy
- Shape language (geometric/organic/mixed)
- Imagery style
- Density preference
- Motion principles (rough guidelines, ejecutadas por Claude Design downstream)

## 6.4 Tools

### Tier 0 (default, $0)
- Claude native (palette + typography + principles reasoning)
- WCAG contrast utility (built-in algorithm)

### Tier 1 ($0.00-0.05/run)
- Huemint API (palette ML)
- Unsplash API (free tier, mood refs curated)
- Claude native (typography, principles)

### Tier 2 (~$0.24-0.32/run)
- Huemint API (paid tier ideally)
- Recraft V4 via `merlinrabens/image-gen-mcp-server` (mood imagery generated)
- Claude native (typography, principles)

## 6.5 Output schema

```json
{
  "schema_version": "1.0",
  "status": "ok",
  "department": "visual_system",
  "scope_ref": "...",
  "strategy_ref": "...",
  "tier_used": 0 | 1 | 2,
  
  "palette": {
    "generation_method": "claude-reasoning | huemint-transformer | huemint-diffusion",
    "primary_palette": {
      "colors": {
        "primary": {"hex": "#0B1F3A", "name": "Navy", "usage": "backgrounds, auth"},
        "background": {"hex": "#F4EFE6", "name": "Off-white", "usage": "page bg"},
        "accent": {"hex": "#D4A74A", "name": "Amber", "usage": "CTAs, highlights"},
        "text_primary": {"hex": "#2A3B52", "name": "Deep slate", "usage": "body text"},
        "text_secondary": {"hex": "#8B97A8", "name": "Steel", "usage": "meta"}
      }
    },
    "alternate_palettes": [...],
    "contrast_matrix": {...},
    "palette_narrative": "..."
  },
  
  "typography": {
    "heading": {
      "family": "Fraunces",
      "weights_available": [400, 500, 600, 700],
      "weight_default": 600,
      "google_fonts_import": "https://fonts.googleapis.com/css2?family=Fraunces:wght@400;600;700&display=swap",
      "rationale": "..."
    },
    "body": {...},
    "mono": {...},
    "scale": {
      "h1": "48px", "h2": "32px", "h3": "24px",
      "body_large": "18px", "body": "16px", "body_small": "14px", "meta": "12px",
      "line_height_body": "1.6", "line_height_heading": "1.2"
    }
  },
  
  "mood_imagery": null | [
    {"path": "brand/visual/mood/01-...png", "axis": "energy-static", "source": "recraft | unsplash", "attribution": "..."},
    ...
  ],
  
  "visual_principles": {
    "whitespace": {...},
    "shape_language": {...},
    "imagery_style": {...},
    "density": {...},
    "motion_principles": {...}
  },
  
  "evidence_trace": {...}
}
```

## 6.6 Persistencia

`brand/{slug}/visual`.

## 6.7 Reveal al user

```
[12:31] ③ Visual System locked (Tier {N})

PALETTE (WCAG AA ✓)
■ #0B1F3A Navy        — primary, auth
■ #F4EFE6 Off-white   — background
■ #D4A74A Amber       — accent
■ #2A3B52 Deep slate  — text primary
■ #8B97A8 Steel       — text secondary

TYPOGRAPHY (era: neutral-modern)
Heading: Fraunces (serif, 600)
Body:    Inter (sans, 400/500/600)
Mono:    JetBrains Mono (500)

[Samples rendered]

MOOD
Tier 0: [No generated — described in principles]
Tier 1: [6 Unsplash curated in grid]
Tier 2: [6 Recraft generated in grid]

PRINCIPLES
whitespace: generous-asymmetric
shape: geometric-soft
imagery: abstract-stylized
```

## 6.8 Relación con otros deptos

**Logo consume**:
- Paleta (aplicar en logos + variants)
- Typography (para wordmarks)
- Visual principles (logo direction)

**Handoff Compiler consume**:
- Palette → Brand Document palette section + tokens.css/json/tailwind
- Typography → Brand Document typography section + fonts.css
- Mood imagery (si tier ≥ 1) → Reference Assets folder
- Visual principles → Brand Document principles section + prompts del Library

## 6.9 Failure modes específicos

### Huemint API down (Tier 1+)
- Retry 3× → fallback a Claude-generated palette (degraded a Tier 0 behavior)
- Flag: "palette generated without ML optimization"

### WCAG falla en todas las combinations
- Adjust manually darkening/lightening
- If unfixable, elegir alternate palette
- Raramente, re-prompt con seeds ajustados

### Recraft API down (Tier 2)
- Retry 3× → fallback a Unsplash (degraded a Tier 1 behavior)
- Flag en output

### Unsplash API down (Tier 1)
- Retry → skip mood imagery (degraded a Tier 0)
- Flag: "mood imagery not included — check Brand Document description"

### Typography pairing no tiene Google Fonts adecuadas
- Fallback a pairing más genérico (Inter + Fraunces default)
- Flag

## 6.10 SKILL.md a escribir en Sprint 0

`skills/brand/visual/SKILL.md` con los 6 pasos + tier-dependent logic.

## 6.11 Reference files a escribir en Sprint 0

- `skills/brand/visual/references/data-schema.md`
- `skills/brand/visual/references/archetype-palette-seeds.md`
- `skills/brand/visual/references/archetype-typography-map.md`
- `skills/brand/visual/references/wcag-utility.md` — algoritmo de contrast + pseudocode
- `skills/brand/visual/references/mood-prompt-templates.md` — templates per archetype (Tier 2)
- `skills/brand/visual/references/unsplash-query-templates.md` — templates per archetype (Tier 1)

## 6.12 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Archetype Sage + formality medium → palette conservadora
2. Archetype Jester + formality low → palette vibrant
3. WCAG check detecta contrast failures y ajusta
4. Typography era matchea pairing
5. Tier 0 run → no mood imagery, todo ok
6. Tier 1 run → Unsplash mood refs entregados
7. Tier 2 run → Recraft mood gens entregados
8. Huemint down → fallback to Claude palette works
9. Unsplash down (Tier 1) → degrade graceful

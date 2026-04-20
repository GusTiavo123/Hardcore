# 06 — Department 3: Visual System

## 6.1 Propósito

Diseñar las **reglas visuales** de la marca — paleta, tipografía, mood direction, visual principles. **NO genera el logo** (eso es Depto 4).

Visual System define el **vocabulario visual**; Logo lo **aplica**. Separación justificada por distintos costos, failure modes, modos cognitivos (ver justificación en [01-overview-and-architecture.md](./01-overview-and-architecture.md#16)).

## 6.2 Inputs

### Obligatorios
- `brand/{slug}/scope` (manifest — determina intensidad visual, formality, typography era)
- `brand/{slug}/strategy` (archetype, brand_values — seed primary para palette + typography)

### Opcionales
- Profile (constraints culturales, preferencias explícitas si user las declaró)
- Validation Competitive (cómo se ve el mercado — white space visual, patterns dominantes)

## 6.3 Proceso — 6 pasos

### Paso 1 — Seed colors derivados del archetype

**Base mapping** (tabla completa en `skills/brand/references/archetype-palette-seeds.md`):

| Archetype | Color family | Seed suggestions |
|---|---|---|
| Innocent | Soft light | Whites, soft blues, mint, pale pink |
| Sage | Cool deep + warm accent | Navy, charcoal, off-white + amber/gold |
| Explorer | Earthy + vibrant pop | Forest green, terracotta + saffron/orange |
| Outlaw | High contrast | Black, blood red, electric yellow |
| Magician | Deep + metallic | Deep purple, midnight blue + gold/silver |
| Hero | Bold + dynamic | Crimson, navy, bright yellow |
| Lover | Warm romantic | Burgundy, dusty pink, cream |
| Jester | Playful multi | Bright primary mix, high saturation |
| Everyman | Warm neutral | Warm grays, soft earth, friendly orange |
| Caregiver | Warm soft | Terracotta, sage green, cream |
| Ruler | Premium cool | Black, gold, deep green, navy |
| Creator | Vibrant unexpected | Teal + coral + mustard mixes |

**Modulación por `scope.intensity_modifiers.visual_formality`**:

- `high`: reducir saturación de accents, privilegiar tonos profesionales conservadores. Máx 1 accent color.
- `medium`: balance — saturation moderada, hasta 2 accents.
- `low`: permitir vibrancy + contrast mayores, hasta 3 accents.

El depto selecciona 2-3 colores seed y decide una **narrativa de color**:

```
Example narrative:
  Navy (#0B1F3A) = autoridad, anclaje, confianza
  Off-white (#F4EFE6) = claridad, legibilidad, respiración
  Amber (#D4A74A) = humanidad, calidez, accent emocional
  
  Principio: navy grounds, off-white breathes, amber humanizes.
  No-al-cliché: evitar el "corporate blue + gray" genérico.
```

### Paso 2 — Palette generation vía Huemint

Tool: Huemint API (ver [11-tools-stack.md](./11-tools-stack.md))

Endpoint: `POST https://api.huemint.com/color`

Request:
```json
{
  "mode": "transformer" | "diffusion",
  "num_colors": 5,
  "temperature": "0.8",
  "num_results": 5,
  "adjacency": [
    "0", "65", "45", "35", "20",
    "65", "0", "35", "35", "25",
    "45", "35", "0", "20", "35",
    "35", "35", "20", "0", "35",
    "20", "25", "35", "35", "0"
  ],
  "palette": ["-", "-", "-", "-", "-"],
  "mode_config": "brand-intersection"
}
```

Output: 5 palettes, cada una con 5 colors. Seleccionar la que mejor expresa la narrativa (Claude reasoning post-API).

Parse a internal format:
```json
{
  "primary_palette": {
    "colors": {
      "primary": {"hex": "#0B1F3A", "name": "Navy", "usage": "backgrounds, headers, auth"},
      "background": {"hex": "#F4EFE6", "name": "Off-white", "usage": "page bg, cards"},
      "accent": {"hex": "#D4A74A", "name": "Amber", "usage": "CTAs, highlights, warm emphasis"},
      "text_primary": {"hex": "#2A3B52", "name": "Deep slate", "usage": "body text, headings"},
      "text_secondary": {"hex": "#8B97A8", "name": "Steel", "usage": "meta, captions"}
    }
  },
  "alternate_palettes": [
    {...segunda opción},
    {...tercera opción}
  ]
}
```

### Paso 3 — WCAG contrast validation

Para **cada par text-background** en la paleta:

- Calcular contrast ratio
- Verificar level AA: ≥ 4.5:1 para texto normal, ≥ 3:1 para texto grande (18pt+)
- Verificar level AAA (premium): ≥ 7:1

**Si falla**:
- Ajustar color (darkening text, lightening bg)
- Re-validar
- Si con ajuste no pasa: escoger alternate palette

**Output del check**:
```json
{
  "contrast_matrix": {
    "text_primary on background": {"ratio": 9.8, "level": "AAA"},
    "text_secondary on background": {"ratio": 4.7, "level": "AA"},
    "background on primary": {"ratio": 10.2, "level": "AAA"},
    "text_primary on primary": {"ratio": 1.8, "level": "FAIL — use background text on primary"}
  },
  "warnings": ["text_primary no debe usarse sobre primary color — usar background color en esos casos"]
}
```

Herramienta a implementar: utility function WCAG en `skills/brand/visual/references/wcag-utility.md` (pseudocode del algoritmo — se ejecuta inline, no es tool externo).

### Paso 4 — Typography pairing

Claude reasoning basado en:
- Archetype (tabla en `skills/brand/references/archetype-typography-map.md`)
- `scope.intensity_modifiers.typography_era`
- Principles: contraste heading-body, x-height legibility, era coherence, no-conflict combinations

**Archetype → typography tendencies** (base):

| Archetype | Heading tendency | Body tendency | Mood |
|---|---|---|---|
| Sage | Classical serif (Fraunces, Crimson) | Neutral sans (Inter, IBM Plex) | Authority + clarity |
| Ruler | Serif elegante (Playfair, Marcellus) | Sans refined (Söhne, Neue Haas) | Premium, editorial |
| Hero | Display bold (Syne, Boldonse) | Sans geometric (Manrope, DM Sans) | Dynamic, bold |
| Creator | Display expresivo (Recoleta, Clash) | Sans friendly (Work Sans, Söhne) | Expressive, crafted |
| Jester | Display playful (Mona Sans expressive, Rubik) | Sans friendly | Fun, unexpected |
| Everyman | Sans humanist (Inter, Söhne) | Sans humanist | Relatable |
| Caregiver | Serif soft (Lora, Source Serif) | Sans warm (Quicksand, Work Sans) | Warm, nurturing |
| Innocent | Sans rounded (Quicksand, Nunito) | Sans rounded | Soft, simple |
| Explorer | Serif rugged (Bitter, Merriweather) | Sans utilitarian (IBM Plex) | Frontier, rugged |
| Outlaw | Display contundente (Anton, Bebas) | Sans condensed | Disruption |
| Magician | Serif ornate (Cormorant, Marcellus) | Sans clean | Mystical |
| Lover | Serif romantic (Cormorant, Italiana) | Sans soft | Sensual |

**Modulación por `typography_era`**:

- `editorial-classic`: Serif heading + sans clean body (Fraunces + Inter). Era editorial prestigiosa.
- `neutral-modern`: Sans heading + sans body (Inter + Söhne). Modern, neutral, versatile.
- `expressive-contemporary`: Display heading + sans friendly body (Recoleta + Work Sans). Personality-forward.
- `experimental`: Variable fonts, unconventional pairings, monospace hybrids.

**Output**:
```json
{
  "typography": {
    "heading": {
      "family": "Fraunces",
      "weights_available": [400, 500, 600, 700, 900],
      "weight_default": 600,
      "google_fonts_import": "https://fonts.googleapis.com/css2?family=Fraunces:wght@400;600;700&display=swap",
      "rationale": "Serif con contrast moderno. Archetype Sage + typography_era neutral-modern + visual_formality medium → Fraunces combina authority clásica con feel contemporary."
    },
    "body": {
      "family": "Inter",
      "weights_available": [400, 500, 600, 700],
      "weight_default": 400,
      "google_fonts_import": "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap",
      "rationale": "Sans humanist neutral, máxima legibilidad body, pairs clean con Fraunces."
    },
    "mono": {
      "family": "JetBrains Mono",
      "weights_available": [400, 500, 600],
      "weight_default": 500,
      "google_fonts_import": "https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;600&display=swap",
      "rationale": "Monospace para code snippets, data tables, contrast visual. Optional para este scope (no es b2d-devtool donde sería required)."
    },
    "scale": {
      "h1": "48px",
      "h2": "32px",
      "h3": "24px",
      "body_large": "18px",
      "body": "16px",
      "body_small": "14px",
      "meta": "12px",
      "line_height_body": "1.6",
      "line_height_heading": "1.2"
    }
  }
}
```

### Paso 5 — Mood imagery generation

**Solo si `scope.output_manifest.required` incluye `visual.mood_imagery`**.

Tool: Recraft V4 via `merlinrabens/image-gen-mcp-server` (ver [11-tools-stack.md](./11-tools-stack.md))

**Prompt engineering estructurado**:

Cada mood image representa un **eje de mood** distinto pero coherente:

- Axis 1: Energy (static vs dynamic)
- Axis 2: Texture (smooth vs grainy)
- Axis 3: Composition (minimal vs dense)
- Axis 4: Light (harsh vs soft)
- Axis 5: Motion (implied stillness vs implied movement)
- Axis 6: Focus (sharp vs blurred depths)

Generar **6-8 images**, cada una expresando un eje diferente, pero todas con:
- Estilo coherente (mismo aesthetic language)
- Paleta alineada con la brand palette
- Mood tonal alineado con archetype

**Ejemplo prompt structure** (para archetype Sage, visual_formality medium):

```
Stylized editorial imagery in the style of a contemporary design magazine spread. 
Mood: studied clarity, quiet authority, considered minimalism. 
Palette reference: deep navy #0B1F3A, off-white #F4EFE6, warm amber #D4A74A accent.
Composition: [axis-specific — e.g., "asymmetric balanced, generous whitespace"].
Style: NOT photorealistic stock photo; stylized editorial illustration or abstract texture study.
Negative: no AI-glow, no generic tech imagery, no cliché startup visuals, no text overlays.
```

**Por qué stylized, no photorealistic**:

Photorealistic = stock photo feeling = genérico. Stylized = direction de marca única. Users perceive "real brand" vs "template".

**Cantidad**: 6-8 images. Siempre más de una (multiple axes) pero no excesivas (budget + decision overload).

**Output**:
```json
{
  "mood_imagery": [
    {
      "path": "brand/visual/mood/01-energy-static.png",
      "axis": "energy-static",
      "prompt_used": "...",
      "description": "Composition que evoca quietud considerada — whitespace generoso, objeto central, lighting soft."
    },
    ...7 more
  ]
}
```

### Paso 6 — Visual principles

Documentar en lenguaje natural los principles que el Visual System establece:

```json
{
  "visual_principles": {
    "whitespace": {
      "philosophy": "generous-asymmetric",
      "rationale": "Archetype Sage + brand_value Rigor → whitespace generoso comunica 'considered thinking'. Asymmetric evita rigid corporate.",
      "rule_of_thumb": "Reservar ≥40% whitespace en layouts clave"
    },
    "shape_language": {
      "primary": "geometric-soft",
      "rationale": "Geometric conveys precision (Sage quality); soft corners (radius 8-12px) add warmth (brand_value Humanidad implícita en empático-técnico).",
      "do": ["Rounded corners 8-12px on cards", "Circular avatars", "Subtle geometric accents"],
      "dont": ["Sharp 90° corners everywhere", "Organic blob shapes", "Heavy decorative elements"]
    },
    "imagery_style": {
      "primary": "abstract-stylized",
      "rationale": "Stylized (not photoreal) differentiates from stock-heavy competitors. Abstract refers to mood without being literal about 'compliance' (boring visuals).",
      "examples": ["mood imagery generated", "editorial illustration style", "abstract texture as hero bg"]
    },
    "density": {
      "preference": "spacious",
      "rationale": "Sage + Rigor → cognitive load baja facilita comprensión densa de contenido técnico."
    },
    "motion_principles": {
      "speed": "medium-slow",
      "easing": "ease-out cubic",
      "dramatic_moments": "rarely — reserved for meaningful transitions",
      "rationale": "Sage = considered, never rushed. Motion should feel intentional, not decorative."
    }
  }
}
```

## 6.4 Tools

- **Huemint API** (HTTP direct) — palette ML generation
- **Recraft V4** via `merlinrabens/image-gen-mcp-server` — mood imagery
- **Google Fonts** (reference catalog, no API) — typography selection
- **Claude native** — typography reasoning, principles synthesis
- **WCAG contrast utility** (built-in algorithm, no external) — accessibility validation

## 6.5 Output schema (resumen — full en data-schema.md)

```json
{
  "schema_version": "1.0",
  "status": "ok",
  "department": "visual_system",
  "scope_ref": "...",
  "strategy_ref": "...",
  
  "palette": {
    "primary_palette": {...},
    "alternate_palettes": [{...}, {...}],
    "contrast_matrix": {...},
    "palette_narrative": "Navy grounds, off-white breathes, amber humanizes."
  },
  
  "typography": {
    "heading": {...},
    "body": {...},
    "mono": {...},
    "scale": {...}
  },
  
  "mood_imagery": [
    {"path": "...", "axis": "...", "prompt_used": "...", "description": "..."},
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
[12:31] ③ Visual System locked

    PALETTE (WCAG AA ✓ on all text pairs)
    ■ #0B1F3A Navy        — primary, auth, backgrounds deep
    ■ #F4EFE6 Off-white   — background, breath
    ■ #D4A74A Amber       — accent, CTAs, warmth
    ■ #2A3B52 Deep slate  — text primary
    ■ #8B97A8 Steel       — text secondary, meta

    TYPOGRAPHY (era: neutral-modern)
    Heading: Fraunces (serif, weight 600)
    [Sample: "Stop drowning in compliance." rendered in Fraunces]
    
    Body: Inter (sans, weight 400)
    [Sample: "Auren converts 40-hour regulatory audits..." in Inter]
    
    Mono: JetBrains Mono (500) — optional para tablas de data

    MOOD (6 generated references)
    [Grid 2×3 de imágenes generadas]

    PRINCIPLES
    whitespace: generous-asymmetric
    shape: geometric-soft
    imagery: abstract-stylized
    density: spacious
```

## 6.8 Relación con otros deptos

**Logo consume**:
- Paleta (para aplicar en logos y variants)
- Typography (para wordmarks)
- Visual principles (para direction de logo)

**Activation consume**:
- Todo para compilar DESIGN.md machine-readable
- Paleta + typography para Stitch prompts

## 6.9 Failure modes específicos

### Huemint API down
- Retry 3× con backoff
- Si persiste: fallback a Claude-generated palette
  - Claude genera paleta basada en color theory principles + archetype seeds
  - Lower quality (sin ML optimization) pero usable
  - Flag: `"palette_generated_without_ml: true"`

### WCAG contrast falla en todas las combinations
Raro pero posible si el archetype sugiere alto contrast pero Huemint genera colores que no cumplen.
- Ajustar manually darkening/lightening
- Si no se logra: elegir alternate palette
- Si ningún palette funciona: re-prompt Huemint con seeds ajustados

### Recraft API down (mood imagery fails)
- Retry 3×
- Si persiste: entregar Visual System **sin** mood imagery
  - Flag en output: `"mood_imagery_pending: retry_when_available"`
  - Command `/brand:extend visual.mood_imagery` disponible para re-run cuando service esté up

### Typography pairing no tiene Google Fonts adecuadas
Ej: user scope pide typography_era muy específica y no hay pairing en el catálogo.
- Fallback a pairing más genérico de la misma era
- Flag con explanation

## 6.10 SKILL.md a escribir en Sprint 0

`skills/brand/visual/SKILL.md` con los 6 pasos detallados.

## 6.11 Reference files a escribir en Sprint 0

- `skills/brand/visual/references/data-schema.md`
- `skills/brand/visual/references/archetype-palette-seeds.md` — tabla completa 12 archetypes → color families
- `skills/brand/visual/references/archetype-typography-map.md` — tabla completa + ejemplos
- `skills/brand/visual/references/wcag-utility.md` — algoritmo de contrast + pseudocode
- `skills/brand/visual/references/mood-prompt-templates.md` — templates per archetype para Recraft

## 6.12 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Archetype Sage + formality medium → palette conservadora con accent sutil
2. Archetype Jester + formality low → palette vibrant multi-accent
3. WCAG check detecta contrast failures y ajusta
4. Typography era matchea pairing correcto
5. Mood imagery generada coherent entre las 6-8 imágenes
6. Huemint down → fallback Claude-palette works
7. Scope sin `mood_imagery` en required → no se ejecuta generation (skip)

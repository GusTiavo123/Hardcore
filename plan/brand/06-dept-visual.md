# 06 — Department 3: Visual System

## 6.1 Propósito

Diseñar las **reglas visuales** de la marca — paleta, tipografía, mood direction, visual principles. **NO genera el logo** (siguiente dept).

Notas específicas:
1. Paleta vía Claude native reasoning (color theory + archetype seeds + WCAG validation)
2. Mood imagery vía Unsplash free API (refs, no generación propia) cuando el scope lo incluye
3. Typography pairing desde catálogo Google Fonts
4. Output alimenta el Brand Document PDF + brand-tokens + prompts library

## 6.2 Inputs

### Obligatorios
- `brand/{slug}/scope` (manifest — determina `visual_formality`, `typography_era`, y si el scope incluye mood imagery)
- `brand/{slug}/strategy` (archetype, voice — seed para palette + typography + mood)

### Opcionales
- `founder_brand_context` (constraints culturales + aesthetic preferences)
- `validation/{slug}/competitive.direct_competitors` (visual landscape — white space visual, patterns dominantes para evitar)

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
- `high` → saturación reducida (sat media < 60), max 1 accent con sat > 70, no neons
- `medium` → balance, 1-2 accents, saturation media ≤ 80
- `low` → permisivo, hasta 3 accents, saturation alta OK

### Paso 2 — Palette generation

**Proceso** (Claude native, $0):

1. Claude razona sobre color theory + archetype seeds + visual_formality
2. Genera 3 paletas candidatas (primary + alternate 1 + alternate 2) con 5 colors cada una
3. Cada palette incluye HSL values, HEX, nombre y usage
4. Self-check de WCAG AA (ver Paso 3)
5. Selecciona primary palette + emite 2 alternates en el output

Output por color:
```json
{
  "hex": "#0B1F3A",
  "hsl": {"h": 216, "s": 68, "l": 14},
  "name": "Navy",
  "usage": "backgrounds, auth, headers"
}
```

Si el user pasó `primary_color` override, se usa como seed obligatorio y las otras colors se derivan por armonía (complementary, triadic, split-complementary, analogous) según el archetype.

### Paso 3 — WCAG contrast validation

Para cada par text-background:
- Calcular contrast ratio (WCAG formula sobre luminance)
- Verificar Level AA (4.5:1 body text, 3:1 large text)
- Si un par falla, auto-ajustar darkening/lightening del text color (no del background — preserva la identidad)
- Si no fixable con ajustes, regenerate palette entera con seeds más distantes

Herramienta: utility function WCAG inline (pseudocode en `skills/brand/visual/references/wcag-utility.md`).

### Paso 4 — Typography pairing

Claude reasoning basado en archetype + `typography_era`:

| Archetype | Heading tendency | Body tendency | Mood |
|---|---|---|---|
| Sage | Classical serif (Fraunces, Crimson) | Neutral sans (Inter, IBM Plex) | Authority + clarity |
| Ruler | Serif elegante (Playfair, Marcellus) | Sans refined (Inter, Manrope) | Premium, editorial |
| Hero | Display bold (Syne, Archivo Black) | Sans geometric (Manrope) | Dynamic |
| Creator | Display expresivo (Recoleta, Clash Display) | Sans friendly (Work Sans) | Crafted |
| Jester | Display playful (Mona Sans, Rubik) | Sans friendly (Poppins) | Fun, unexpected |
| Everyman | Sans humanist (Inter) | Sans humanist (Inter) | Relatable |
| Caregiver | Serif soft (Lora, Source Serif) | Sans warm (Quicksand) | Warm |
| Innocent | Sans rounded (Quicksand, Nunito) | Sans rounded | Soft, simple |
| Explorer | Serif rugged (Bitter, Merriweather) | Sans utilitarian (IBM Plex) | Rugged |
| Outlaw | Display contundente (Anton, Bebas Neue) | Sans condensed (Barlow Condensed) | Disruption |
| Magician | Serif ornate (Cormorant) | Sans clean (Inter) | Mystical |
| Lover | Serif romantic (Cormorant) | Sans soft (Work Sans) | Sensual |

**Todas Google Fonts** (free, commercial OK, widely supported, embeddable en PDF).

**Modulación por `typography_era`**:
- `editorial-classic` → Serif + sans clean (e.g., Fraunces + Inter)
- `neutral-modern` → Sans + sans (e.g., Inter + Manrope)
- `expressive-contemporary` → Display + sans friendly (e.g., Clash Display + Work Sans)
- `experimental` → Variable fonts, unconventional pairings

Output incluye Google Fonts import URL completo para inclusión directa en tokens/fonts.css.

### Paso 5 — Mood imagery refs (condicional)

Se ejecuta solo si `scope.output_manifest.reference_assets.optional_recommended` incluye `mood_imagery_refs` (profiles que lo benefician — ver [18-output-package-structure.md](./18-output-package-structure.md) §18.8).

**Via Unsplash free API**:

1. Construir queries basados en archetype + `mood_keywords` derivados de brand values + voice attributes + `target_audience.psychographics`
   - Ejemplo para Sage/authority/compliance: *"minimal architectural monochrome"*, *"quiet precision geometry"*, *"ordered light shadow"*
2. Ejecutar 3-6 queries contra Unsplash API (`GET /search/photos` con query)
3. Select top 3-6 resultados (1 por query idealmente, o los mejores 6 total)
4. Output: array de refs con URL, photographer, photo_id, attribution string, mood axis (energy, texture, composition, light, focus, motion)
5. Estos refs van a Reference Assets folder como markdown files con metadata (URL + attribution + mood description) — NO binarios descargados

**Si Unsplash API está down**:
- Retry 3× con backoff
- Si persiste: skip mood refs. Brand Document describe el mood en prosa dentro de la página de Visual Principles. Flag `mood_imagery_skipped: true` en envelope.

Templates de queries por archetype se documentan inline dentro de `skills/brand/visual/SKILL.md` (Sprint 0) — son una tabla compacta, no ameritan ref standalone.

### Paso 6 — Visual principles

Documentar en lenguaje natural:
- **Whitespace philosophy** (generous vs dense, symmetric vs asymmetric)
- **Shape language** (geometric / organic / mixed, rounded corners spec, stroke weights)
- **Imagery style direction** (guidance para que Claude Design genere imagery coherente downstream — descripción, no assets aquí)
- **Density preference** (información per screen: low / medium / high)
- **Motion principles** (direction-level guidelines, ejecutados por Claude Design downstream — speed, easing defaults)

Estos principios viajan al Brand Document + se embeben como context en cada prompt de la Prompts Library.

## 6.4 Tools

- Claude native (palette reasoning, typography pairing, visual principles)
- WCAG contrast utility (built-in algorithm)
- Unsplash free API (cuando scope incluye mood refs)

Costo externo: $0.

## 6.5 Output schema

```json
{
  "schema_version": "1.0",
  "status": "ok",
  "department": "visual_system",
  "scope_ref": "brand/{slug}/scope",
  "strategy_ref": "brand/{slug}/strategy",

  "palette": {
    "generation_method": "claude-reasoning",
    "primary_palette": {
      "colors": {
        "primary": {"hex": "#0B1F3A", "hsl": {"h": 216, "s": 68, "l": 14}, "name": "Navy", "usage": "backgrounds, auth"},
        "background": {"hex": "#F4EFE6", "hsl": {"h": 38, "s": 28, "l": 93}, "name": "Off-white", "usage": "page bg"},
        "accent": {"hex": "#D4A74A", "hsl": {"h": 41, "s": 60, "l": 56}, "name": "Amber", "usage": "CTAs, highlights"},
        "text_primary": {"hex": "#2A3B52", "hsl": {"h": 215, "s": 32, "l": 24}, "name": "Deep slate", "usage": "body text"},
        "text_secondary": {"hex": "#8B97A8", "hsl": {"h": 212, "s": 14, "l": 60}, "name": "Steel", "usage": "meta"}
      }
    },
    "alternate_palettes": [
      {"colors": {...}, "name": "alt-1", "rationale": "string"},
      {"colors": {...}, "name": "alt-2", "rationale": "string"}
    ],
    "contrast_matrix": {
      "text_primary_on_background": 9.2,
      "text_secondary_on_background": 3.4,
      "primary_on_background": 12.8
    },
    "palette_narrative": "string — why these colors for this archetype + formality"
  },

  "typography": {
    "heading": {
      "family": "Fraunces",
      "weights_available": [400, 500, 600, 700],
      "weight_default": 600,
      "google_fonts_import": "https://fonts.googleapis.com/css2?family=Fraunces:wght@400;600;700&display=swap",
      "rationale": "string"
    },
    "body": {
      "family": "Inter",
      "weights_available": [400, 500, 600],
      "weight_default": 400,
      "google_fonts_import": "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap",
      "rationale": "string"
    },
    "mono": {
      "family": "JetBrains Mono",
      "weights_available": [400, 500],
      "weight_default": 400,
      "google_fonts_import": "https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500&display=swap",
      "rationale": "string"
    },
    "scale": {
      "h1": "48px", "h2": "32px", "h3": "24px",
      "body_large": "18px", "body": "16px", "body_small": "14px", "meta": "12px",
      "line_height_body": "1.6", "line_height_heading": "1.2"
    }
  },

  "mood_imagery_refs": null | [
    {
      "mood_axis": "energy-quiet-deliberate",
      "unsplash_url": "https://unsplash.com/photos/{id}",
      "photo_id": "string",
      "photographer": "string",
      "attribution": "Photo by {photographer} on Unsplash",
      "description": "string — por qué este ref para este mood"
    }
  ],

  "visual_principles": {
    "whitespace": "string — philosophy",
    "shape_language": "geometric | organic | mixed + detalles",
    "imagery_style_direction": "string",
    "density": "low | medium | high",
    "motion_principles": "string — speed + easing defaults"
  },

  "evidence_trace": {
    "profile_fields_used": ["string"],
    "validation_depts_used": ["competitive"],
    "scope_modifiers_applied": ["string"],
    "mood_refs_queries_used": ["string"],
    "wcag_adjustments_applied": ["string"]
  }
}
```

## 6.6 Persistencia

`brand/{slug}/visual` en Engram.

## 6.7 Reveal al user

```
[12:31] ③ Visual System locked

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
[3 mood refs from Unsplash si scope los incluye, con thumbnails + attribution. Si scope no los incluye o Unsplash down: "Described in Visual Principles"]

PRINCIPLES
whitespace: generous-asymmetric
shape: geometric-soft
imagery: abstract-stylized
```

## 6.8 Relación con otros deptos

**Logo consume**:
- Paleta (aplicar en logos + variants)
- Typography (para wordmarks)
- Visual principles (logo direction, shape language)

**Handoff Compiler consume**:
- Palette → Brand Document palette section + brand-tokens (tokens.css / tokens.json / tailwind.config.js)
- Typography → Brand Document typography section + fonts.css
- Mood imagery refs (si están) → Reference Assets folder (markdown files con URLs + attribution) + Brand Document mood section
- Visual principles → Brand Document principles section + embedidos en prompts del Library

## 6.9 Failure modes específicos

### WCAG falla en todas las combinations
Auto-adjust darkening/lightening del text color. Si unfixable después de 2 iteraciones, regenerate palette entera con seeds más distantes. Si sigue fallando, surface al user con las 3 alternate palettes y que elija.

### Unsplash API down
Retry 3× con backoff. Si persiste: skip mood refs, Brand Document describe el mood en prosa en Visual Principles. Flag `mood_imagery_skipped: true` en envelope.

### Unsplash queries devuelven 0 resultados
Refine queries con synonyms automático (Claude genera alternativas). Si sigue en 0 resultados: skip mood refs con flag.

### Typography pairing no tiene Google Fonts adecuadas para el archetype
Fallback a pairing default universal (Inter + Fraunces + JetBrains Mono). Flag `typography_fallback_to_default: true` con nota en rationale.

### `primary_color` override no compatible con archetype (ej. neon amarillo con Sage)
Visual dept genera la palette alrededor del override, pero Gate 3 (Palette ↔ Archetype) va a halt el pipeline en Handoff Compiler. El user decide si override el archetype o revisita el color.

## 6.10 Archivos a escribir en Sprint 0

Para este depto:
- `skills/brand/visual/SKILL.md` — los 6 pasos. **Incluye inline**: typography pairing tables per archetype × era, unsplash query templates per archetype × mood axis, visual principles generation rules
- `skills/brand/visual/references/data-schema.md`
- `skills/brand/visual/references/archetype-palette-seeds.md` — seeds per archetype con HSL ranges detallados (big reference, standalone)
- `skills/brand/visual/references/wcag-utility.md` — algoritmo de contrast + pseudocode

## 6.12 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Archetype Sage + formality medium → palette conservadora (sat media 40-60)
2. Archetype Jester + formality low → palette vibrant (sat 70+, 3 accents)
3. WCAG check detecta contrast failures y auto-ajusta
4. Typography era matchea pairing
5. Scope incluye mood refs + Unsplash up → 3-6 refs entregados con attribution
6. Scope incluye mood refs + Unsplash down → skip, flag, prosa en principles
7. Scope NO incluye mood refs → no se ejecuta el paso, output coherente
8. `primary_color` override compatible → palette se genera alrededor del seed
9. `primary_color` override incompatible con archetype → Gate 3 halt downstream
10. Typography fallback cuando archetype no tiene pairing claro → default universal

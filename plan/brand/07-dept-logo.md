# 07 — Department 4: Logo & Key Visuals

## 7.1 Propósito

Generar el **logo** + todos los **assets visuales derivados**. El logo es el asset más emocional de la marca — un logo flojo mata el módulo entero.

**Por qué separado de Visual System**: diferentes costos (logo gen cuesta $, visual system ~free), diferentes failure modes (logo can generate unusable artifacts, visual system deterministic), diferentes testing (visual judgment vs rule compliance).

## 7.2 Inputs

- `brand/{slug}/scope` (manifest — determina primary_form + derived assets to generate)
- `brand/{slug}/strategy` (archetype + voice — vocabulary para prompts)
- `brand/{slug}/visual` (paleta para aplicar, typography para wordmarks)
- `brand/{slug}/verbal` (nombre elegido para wordmarks, tagline para OG card)

## 7.3 Proceso — 7 pasos

### Paso 1 — Determinar directions según `logo_primary_form`

El número y tipo de directions a generar depende del scope:

| Primary form | Directions generated |
|---|---|
| `symbolic-first` | 3 symbolic + 1 combination + 0 pure wordmark |
| `wordmark-preferred` | 0 pure symbolic + 1 combination + 3 wordmark variants |
| `combination` | 1 symbolic + 2 combination + 1 wordmark |
| `icon-first` (consumer app) | 4 symbolic (each optimized for 16×16 legibility) + 1 combination |

**Direction definitions**:

- **Symbolic**: mark abstracto sin texto. Representa el concepto visualmente. Ejemplo: Slack hashtag symbol, Spotify sound waves.
- **Wordmark**: tratamiento tipográfico del nombre. Solo texto. Ejemplo: Google, Coca-Cola.
- **Combination**: símbolo + wordmark juntos. Ejemplo: Airbnb (símbolo + name), Airbnb's Bélo logo setup.

**Para `icon-first`** (consumer apps): cada symbolic debe funcionar a 16×16 legible — esto constraint mucho el diseño. Symbolic debe ser identifiable sin texto soporte.

### Paso 2 — Prompt engineering para Recraft V4

Tool: Recraft V4 via `merlinrabens/image-gen-mcp-server` (ver [11-tools-stack.md](./11-tools-stack.md))

**Prompt structure** per direction:

```
# Symbolic direction prompt example

System: You are generating a brand identity logo.

Brand context:
  Name: Auren
  Archetype: Sage (expert guide, authoritative clarity, scholarly)
  Voice: claro, autorizante, directo, empático-técnico
  Category: compliance platform for LATAM fintechs
  Target audience: compliance officers, CTOs
  Visual formality: medium
  Shape language: geometric-soft (rounded corners 8-12px, circular elements OK)
  Imagery style preference: abstract-stylized (not literal)

Palette (apply these HEX exactly):
  Primary: #0B1F3A (navy)
  Background: #F4EFE6 (off-white)
  Accent: #D4A74A (amber)

Task: Generate 2 variants of a SYMBOLIC logo mark.
  - No text. Pure abstract mark.
  - Must work at small sizes (32×32 readable)
  - Must embody Sage vocabulary: scholarly, authoritative, minimal
  - Shape language geometric-soft
  - Output as SVG vector (native, editable)

Negative prompt: 
  - NO text, no letters
  - NO AI-style glow or generic tech aesthetics
  - NO cliché compliance symbols (shields, checkmarks, magnifying glasses)
  - NO overdecoration
  - NO gradients that can't be edited post-generation

Format: SVG native output.
```

Similar prompts para wordmark direction:

```
# Wordmark direction prompt example

Task: Generate 3 variants of a WORDMARK logo using the name "Auren".
  - Custom typography or refined existing typeface
  - Archetype Sage → serif with authority, or refined sans
  - Palette: primary text in navy (#0B1F3A) on off-white bg
  - Letterform treatment:
    - Variant 1: Serif classical with custom 'A' lettering
    - Variant 2: Sans refined with unique letterspacing
    - Variant 3: Hybrid — serif 'A' with sans rest (unexpected mark)

Negative: no text decoration clichés, no 3D effects, no generic tech fonts.

Format: SVG native.
```

### Paso 3 — Generación

Ejecutar prompts en paralelo (one per direction, con 2-3 variants per prompt).

**Output**: 4-5 SVG logos en total (según primary_form).

**Importante**: Recraft V4 genera SVG nativo — no raster. Esto permite:
- Edición post-gen en Figma/Illustrator
- Scaling infinito sin pérdida
- Extracción de símbolo solo (para favicon)
- Color replacement trivial

### Paso 4 — Quality validation pre-user

Cada SVG pasa por checks automáticos antes de presentar al user:

- **Not empty**: SVG tiene content (> some minimum path/element count)
- **Not all-same-color**: no es un rectángulo sólido
- **No text corruption**: si wordmark, el texto es legible (Claude vision check)
- **Palette compliance**: los colores usados están en la paleta (con tolerancia)
- **Reasonable complexity**: no es demasiado complejo para funcionar como logo (count de paths razonable)

Si falla: regenerate con prompt ajustado. Max 2 retries por variante.

Si 2 retries fallan: flag el logo con warning pero incluirlo en el set para presentación al user (el user decide si sirve).

### Paso 5 — User selection

Presentar 4-5 SVG logos al user como un grid visual:

```
[17:45] ④ 4 logo concepts

    [A1 — Symbolic abstract "A" as book icon]
    [A2 — Symbolic abstract mark suggesting audit paths]
    [B1 — Wordmark serif classical]
    [B2 — Wordmark hybrid serif-sans]
    
    Cada uno con rationale 1-line.

    Opciones:
      → Picá uno (ej: "B2")
      → Picá una dirección completa para regenerate variants ("dirección B, más variants")
      → "Ninguno — [feedback]" para regenerate con feedback

[user: B2]
```

### Paso 6 — Variants del logo elegido

Una vez seleccionado el primary logo, generar variantes estándar:

- **Primary**: full color según paleta (for default use)
- **Mono**: black on white (for print, low-contrast)
- **Inverse**: white on dark (for dark backgrounds)
- **Icon-only**: solo el símbolo aislado (si aplica — para wordmark este no existe)

Cada variant: SVG nativo.

Prompt Recraft para variants usa el primary como reference:

```
Task: Generate a MONOCHROMATIC version of this logo for print/low-contrast contexts.
Reference logo: [attach primary SVG]
Constraints: pure black on pure white, no gradients, preserve structure exactly.
Output: SVG native.
```

### Paso 7 — Derived assets

**Condicional según `scope.output_manifest.required`**:

#### Always
- **Favicon set**: 16×16, 32×32, 48×48 PNG
  - Generation: programatic — render del icon-only SVG a esos tamaños
  - No cuesta image gen budget (es rendering, no generation)
- **Apple touch icon**: 180×180 PNG
  - Programatic render

#### If `app_asset_criticality: primary` (consumer app)
- **App icon iOS**: set completo con múltiples sizes (20×20, 29×29, 40×40, 58×58, 60×60, 80×80, 87×87, 120×120, 180×180, 1024×1024)
- **App icon Android**: foreground layer + background layer (adaptive icon format)
- **App icon mask variants**: circular, rounded square, squircle

**Importante**: app icon a 16×16 no es simplemente un favicon. Requiere diseño específico (high-contrast, simplified). Generation via Recraft con prompts específicos para each size tier (small vs large).

#### If landing in required
- **OG card**: 1200×630 PNG con logo + tagline sobre bg de paleta
  - Composition programatic: logo SVG + text del Verbal dept + background gradient de palette
  - Herramienta: canvas-like library or SVG composition (implementable sin image gen extra)

#### If social presence in required
- **Profile picture 400×400**:
  - Crop cuadrado del logo (or icon-only variant)
  - Versiones: transparent bg + palette bg
- **Cover banners**:
  - X 1500×500: logo + tagline con palette background
  - LinkedIn 1584×396: similar treatment, profesional register
  - Facebook (if scope): 820×312
- Generation: composition programatic per layout

#### If `community-movement` or `content-media`
- **Merch direction** (templates, not production):
  - T-shirt design layout (hero print + placement guide)
  - Sticker design (circular, square)
  - Mug design (wraparound direction)
  - Entregado como PDF guidance, not as final print files

## 7.4 Tools

- **Recraft V4** via `merlinrabens/image-gen-mcp-server` — primary logo generation (SVG nativo)
- **SVG-to-raster utility** — favicon, icon derivation (built-in, no external)
- **SVG composition utility** — OG card, banners (built-in — SVG as layers)
- **Claude native** — prompt engineering, quality validation, user interaction

## 7.5 Output package estructurado

```
logo/
├── source/
│   ├── primary.svg           # Full color version
│   ├── primary-mono.svg      # Black on white
│   ├── primary-inverse.svg   # White on dark
│   └── icon-only.svg         # Símbolo aislado (si aplica)
├── derivations/
│   ├── favicon-16.png
│   ├── favicon-32.png
│   ├── favicon-48.png
│   ├── favicon.ico           # Multi-size ICO file
│   ├── apple-touch-180.png
│   ├── og-card-1200x630.png
│   ├── profile-pic-400.png
│   ├── profile-pic-400-bg.png
│   ├── cover-x-1500x500.png
│   └── cover-linkedin-1584x396.png
├── app-icons/                # Solo si scope lo requiere
│   ├── ios/
│   │   ├── icon-20.png
│   │   ├── icon-29.png
│   │   ├── icon-60.png
│   │   ├── icon-1024.png
│   │   └── ...
│   └── android/
│       ├── foreground.svg
│       ├── background.svg
│       └── adaptive-icon.png
├── merch/                    # Solo si scope lo requiere
│   ├── tshirt-layout.pdf
│   ├── sticker-designs.svg
│   └── README.md
├── rationale.md              # Por qué el logo se ve así
└── usage-guidelines.md       # Do/don'ts, clearspace, min size
```

## 7.6 Output schema (manifest en Engram)

```json
{
  "schema_version": "1.0",
  "status": "ok",
  "department": "logo",
  "scope_ref": "...",
  "strategy_ref": "...",
  "visual_ref": "...",
  "verbal_ref": "...",
  
  "directions_generated": {
    "primary_form": "wordmark-preferred",
    "concepts": [
      {"id": "B1", "direction": "wordmark-serif-classical", "path": "logo/concepts/B1.svg", "rationale": "..."},
      {"id": "B2", "direction": "wordmark-hybrid", "path": "logo/concepts/B2.svg", "rationale": "..."},
      {"id": "B3", "direction": "wordmark-sans-refined", "path": "logo/concepts/B3.svg", "rationale": "..."},
      {"id": "C1", "direction": "combination", "path": "logo/concepts/C1.svg", "rationale": "..."}
    ],
    "chosen": "B2",
    "user_selection_method": "user-picked"
  },
  
  "variants": {
    "primary": "logo/source/primary.svg",
    "mono": "logo/source/primary-mono.svg",
    "inverse": "logo/source/primary-inverse.svg",
    "icon_only": "logo/source/icon-only.svg" | null
  },
  
  "derivations": {
    "favicon": ["logo/derivations/favicon-16.png", "..."],
    "apple_touch": "logo/derivations/apple-touch-180.png",
    "og_card": "logo/derivations/og-card-1200x630.png",
    "profile_pics": ["..."],
    "covers": {"x": "...", "linkedin": "..."}
  },
  
  "app_icons": {...} | null,
  "merch_direction": {...} | null,
  
  "usage_guidelines": {
    "clearspace_rule": "Minimum clearspace equals the height of the logo's shortest side",
    "minimum_size": {"raster": "24px height", "print": "12mm height"},
    "donts": [
      "No distort proportions",
      "No change colors outside palette",
      "No add effects (drop shadow, glow) without design approval",
      "No place on busy backgrounds without mono/inverse variant"
    ]
  },
  
  "quality_validation": {
    "all_concepts_passed_quality": true,
    "retries_required": 0,
    "flags": []
  },
  
  "cost_tracking": {
    "recraft_generations": 4,
    "recraft_variants": 3,
    "recraft_derivations": 8,
    "total_cost_usd": 0.60
  }
}
```

## 7.7 Persistencia

- Metadata + paths en `brand/{slug}/logo` en Engram
- Files reales en filesystem (`output/{slug}/brand/logo/*`)

## 7.8 Reveal al user

### Post-generation initial (reveal de 4-5 concepts)

```
[17:45] ④ 4 logo concepts generated (wordmark-preferred)

    [B1 SVG rendered]  [B2 SVG rendered]  [B3 SVG rendered]  [C1 SVG rendered]
    Serif classical    Hybrid serif-sans  Sans refined       Combination

    Rationales:
      B1: "Authority clásica, serif Fraunces-inspired con 'A' custom"
      B2: "Unexpected — 'A' serif, resto sans. Hints at Sage pedagogy (classic+modern)"
      B3: "Refined sans, maximum legibility, neutral-modern era"
      C1: "Símbolo + wordmark. Símbolo abstracto evoca audit-trail"

    ¿Cuál? (o pedí variants de uno, o feedback para regen)
```

### Post-selection (logo aplicado en contextos)

```
[19:20] Logo B2 applied

    PRIMARY:      [SVG]
    MONO:         [SVG]
    INVERSE:      [SVG]
    ICON-ONLY:    [SVG]

    Applied in contexts:
    [Favicon en browser tab mockup]
    [Mock business card]
    [OG card preview]
    [LinkedIn banner mock]
    [X profile + banner mock]

    12 derivations generated.
    Total cost: $0.60 in image gen.
```

## 7.9 Relación con otros deptos

**Activation consume**:
- Logo primary + variants (aplicados en microsite vía Stitch DESIGN.md)
- Derivations (para social media kit del paquete, para brand book)

Activation NO toca los SVGs — los referencia desde el filesystem.

## 7.10 Failure modes específicos

### Recraft API down
- Retry 3×
- Si persiste: fail graceful — entregar package sin logo
- README del package flagea: "logo generation pendiente — retry con `/brand:extend logo` cuando servicio esté up"

### Quality validation falla persistently (2+ retries en multiple concepts)
- Presentar al user con flag "some concepts below quality threshold — pick best available or request regen"

### User rechaza todas las opciones (3+ regens)
- Ofrecer modo "provide your own reference" — user sube logo actual o references, Recraft generate variants basados en esa reference
- Último fallback: user provee logo, Brand solo aplica en contextos (skip generation)

### SVG malformed (Recraft devuelve invalid SVG)
- Validation attempt to parse
- Si falla: regenerate con prompt énfasis "output must be valid SVG XML"
- Si persiste: fall back to raster PNG (degraded but usable)

### App icon at 16×16 not legible
- Design que no sobrevive el scale-down
- Regenerate con prompt "design must remain identifiable at 16 pixels square"
- Max 3 retries
- Si persiste: warn user explicitly — "app icon may have legibility issues at small sizes"

## 7.11 SKILL.md a escribir en Sprint 0

`skills/brand/logo/SKILL.md` con los 7 pasos detallados.

## 7.12 Reference files a escribir en Sprint 0

- `skills/brand/logo/references/data-schema.md`
- `skills/brand/logo/references/prompt-templates.md` — templates per archetype + direction (symbolic, wordmark, combination, icon-first). 12 archetypes × 3-4 directions = ~40 prompt templates.
- `skills/brand/logo/references/direction-strategies-by-profile.md` — cuántas/cuáles directions per brand profile
- `skills/brand/logo/references/quality-validation.md` — checks completos + how to detect failures

## 7.13 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. `logo_primary_form: wordmark-preferred` → 3 wordmarks + 1 combination generados
2. `logo_primary_form: icon-first` → 4 symbolic + 1 combination, cada symbolic legible a 16×16
3. SVG output válido (parseable, no corrupto)
4. Variants (mono, inverse) preservan structure del primary
5. Derivations (favicon, OG card) rendean correctamente
6. `app_asset_criticality: primary` → set completo iOS + Android app icons
7. User regen con feedback → aplicar feedback correctamente
8. Quality validation detecta SVG corrupto y regenerate

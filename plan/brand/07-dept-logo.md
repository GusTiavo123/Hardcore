# 07 — Department 4: Logo & Key Visuals

## 7.1 Propósito

Generar **logo + assets visuales derivados** con tier-based generation:
- **Tier 0** (default): Claude native SVG generation (zero cost) para wordmarks + simple combinations
- **Tier 1+**: Recraft V4 para symbolic logos cuando scope lo requiere

**Importante**: el logo que generamos es el **standalone asset**. Cuando Claude Design aplica la marca en mockups (landing, decks, etc.), puede usar nuestro SVG referenced desde el Brand Document o Reference Assets folder — no necesita regenerarlo.

## 7.2 Inputs

- `brand/{slug}/scope` (manifest — determina primary_form + tier + derived assets)
- `brand/{slug}/strategy` (archetype, voice — vocabulary para prompts)
- `brand/{slug}/visual` (paleta para aplicar, typography para wordmarks)
- `brand/{slug}/verbal` (nombre elegido, tagline para OG card)

## 7.3 Tier system explícito

### Tier 0 — Claude native SVG generation ($0)

**Cubre bien**:
- Wordmarks (tratamiento tipográfico del nombre)
- Combination logos simples (símbolo geométrico + wordmark)
- Variants derivados (mono, inverse, icon-only del wordmark)

**Calidad esperada**:
- Wordmarks: excelente — Claude escribe SVG text con Google Fonts reference
- Simple symbolic marks: bueno — shapes básicas con paleta
- Complex symbolic marks: limitado — abstract concepts son más difíciles sin modelo specialized

**Proceso**:
1. Claude genera SVG markup directamente en chat
2. Output: SVG code como string
3. Save a filesystem
4. Parse + validate SVG
5. Render preview para user

### Tier 1 — Claude native + Recraft para symbolic

**Cuando activar**:
- `scope.intensity_modifiers.logo_primary_form == "symbolic-first"` o `"icon-first"`
- `app_asset_criticality == "primary"` (requires high-quality icon)
- User override `--tier=1` o `--with-symbolic-logo`

**Setup**:
- Wordmarks: Claude native (mismo que Tier 0)
- Symbolic marks: Recraft V4 via `merlinrabens/image-gen-mcp-server`
- Combinations: mixed (Claude para text part, Recraft para symbol part)

**Cost adicional**: $0.04 × 3-5 generations = $0.12-0.20

### Tier 2 — Recraft V4 everywhere

**Cuando activar**: user override `--tier=2` para max quality.

**Setup**: todos los logos via Recraft V4, incluso wordmarks.

**Cost**: $0.04 × 4-5 concepts + $0.04 × 3-4 variants + $0.04 × 4-8 derivations = $0.44-0.68

## 7.4 Proceso — 7 pasos

### Paso 1 — Determinar directions según `logo_primary_form`

| Primary form | Directions generated | Tier 0 posible? |
|---|---|---|
| `wordmark-preferred` | 3 wordmark + 1 combination | ✓ (Claude native handles this well) |
| `combination` | 1 symbolic + 2 combination + 1 wordmark | Partial — combinations OK, symbolic limited |
| `symbolic-first` | 3 symbolic + 1 combination | **Requires Tier 1+** |
| `icon-first` (consumer app) | 4 symbolic (legible 16×16) + 1 combination | **Requires Tier 1+** (app icons need quality) |

**Auto-elevation rule**: si scope specifies `symbolic-first` o `icon-first` y tier actual es 0, orchestrator ask al user:

```
Tu scope requiere symbolic logos (archetype + category matchean symbolic-first).
Tier 0 (Claude native) produce wordmarks bien pero symbolic marks son limitados.

Opciones:
  1. Elevar a Tier 1 (~$0.20 de Recraft para 3 symbolic concepts)
  2. Cambiar a wordmark-preferred (symbolic deja de ser primary)
  3. Proceder con Tier 0 acknowledging symbolic quality loss
```

### Paso 2 — Prompt engineering

**Para Claude native (Tier 0 — wordmarks)**:

Claude genera SVG markup con structure:
```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 100">
  <text x="20" y="70" font-family="Fraunces, serif" font-size="60" font-weight="600" fill="#0B1F3A">
    {Brand Name}
  </text>
  <!-- Optional: geometric accent element -->
</svg>
```

Custom adjustments per archetype:
- Sage: letter-spacing slight, weight 600-700, classical serif
- Jester: playful sizing, color accent
- Etc.

**Para Recraft V4 (Tier 1+ symbolic)**:

Prompt estructurado:
```
System: You are generating a brand identity logo.

Brand context:
  Name: Auren
  Archetype: Sage (scholarly, authoritative, minimal)
  Voice: claro, autorizante, directo, empático-técnico
  Category: compliance platform for LATAM fintechs

Palette (apply exactly):
  Primary: #0B1F3A (navy)
  Background: #F4EFE6 (off-white)
  Accent: #D4A74A (amber)

Task: Generate 2 variants of a SYMBOLIC logo mark.
  - No text. Pure abstract mark.
  - Must work at small sizes (32×32 readable)
  - Sage vocabulary: scholarly, authoritative, minimal
  - Shape: geometric-soft (rounded 8-12px, circular elements OK)
  - Output: SVG vector (native, editable)

Negative: no text/letters, no AI-glow, no cliché compliance symbols, no overdecoration, no gradients non-editable

Format: SVG native output.
```

### Paso 3 — Generación

Ejecutar según tier:
- Tier 0: Claude writes SVG markup, parse + save
- Tier 1+: Claude for wordmarks + Recraft API calls for symbolic
- Output: 4-5 SVG logos total

### Paso 4 — Quality validation pre-user

Checks automáticos:
- **Not empty**: SVG tiene content (minimum path/element count)
- **Not all-same-color**: no es rectángulo sólido
- **No text corruption**: si wordmark, texto legible (Claude vision check)
- **Palette compliance**: colores usados están en paleta (con tolerancia)
- **Reasonable complexity**: no demasiado complejo para logo

If fail: regenerate (Claude rewrites SVG, or Recraft re-call with adjusted prompt). Max 2 retries.

### Paso 5 — User selection

Presentar 4-5 SVG logos al user como grid visual:

```
[17:45] ④ 4 logo concepts (wordmark-preferred, Tier 0)

  [B1] [B2] [B3] [C1]
  Wordmark serif    Wordmark hybrid    Sans refined    Combination

  Rationales:
    B1: Fraunces inspired, authority clásica
    B2: Serif 'A' + sans resto, hints Sage pedagogy
    B3: Refined sans, maximum legibility
    C1: Symbol geometric + wordmark

  ¿Cuál? (o direction + regen, o 'ninguno' para feedback)
```

User options:
- Pick one
- Pick direction + regenerate variants
- "None" + feedback for full regen
- "Manual" — user provides own logo, dept skips generation, downstream uses user's SVG

### Paso 6 — Variants del logo elegido

De la SVG primary:
- **Primary**: full color
- **Mono**: black on white (programmatic — strip colors from SVG)
- **Inverse**: white on dark (programmatic — invert)
- **Icon-only**: solo símbolo (extract from combination, or skip if wordmark)

Generation path:
- Tier 0: SVG transformations programmatic (manipulate XML)
- Tier 1+: Recraft can regenerate variants with consistency

### Paso 7 — Derived assets

Condicional según `scope.output_manifest`:

#### Always (programmatic from SVG)
- **Favicon set**: 16×16, 32×32, 48×48 PNGs
- **Apple touch icon**: 180×180 PNG
- **Favicon.ico**: multi-size combined

#### If `app_asset_criticality: primary` (consumer app)
Tier 1+ required:
- **App icon iOS**: set completo (20/29/40/58/60/80/87/120/180/1024)
- **App icon Android**: foreground + background layers, adaptive icon format
- **Mask variants**: circular, rounded, squircle

#### If landing in prompts library
- **OG card**: 1200×630 PNG (composition: logo + tagline + palette bg)
  - Tier 0: SVG composition → rasterize
  - Tier 1+: Recraft generation possible

#### If social presence in scope
- **Profile pictures**: 400×400 (crop cuadrado del logo)
- **Cover banners**: X 1500×500, LinkedIn 1584×396 (composition)

#### If `community-movement` or `content-media`
- **Merch direction** (templates, not production):
  - T-shirt design layout (hero print + placement)
  - Sticker designs (circular, square)
  - Mug design (wraparound direction)
  - Tier 0: SVG-based templates
  - Tier 2: Recraft generates merch-specific concepts

## 7.5 Tools

### Tier 0
- Claude native SVG generation
- SVG manipulation utilities (parse XML, transform paths, convert to raster)
- Built-in image composition utilities (layer SVGs + text)

### Tier 1
- Above + Recraft V4 via `merlinrabens/image-gen-mcp-server`

### Tier 2
- Above + Recraft for all generations

## 7.6 Output package estructurado

```
logo/
├── source/
│   ├── primary.svg           # Full color
│   ├── primary-mono.svg      # Black on white
│   ├── primary-inverse.svg   # White on dark
│   └── icon-only.svg         # Símbolo aislado (si aplica)
├── derivations/
│   ├── favicon-16.png
│   ├── favicon-32.png
│   ├── favicon-48.png
│   ├── favicon.ico
│   ├── apple-touch-180.png
│   ├── og-card-1200x630.png
│   ├── profile-pic-400.png
│   ├── profile-pic-400-bg.png
│   ├── cover-x-1500x500.png
│   └── cover-linkedin-1584x396.png
├── app-icons/                # Tier 1+ si scope lo requiere
│   ├── ios/
│   │   └── (multiple sizes)
│   └── android/
│       └── (adaptive icon files)
├── merch/                    # Tier 1+ si scope
├── rationale.md
├── usage-guidelines.md       # Do/don'ts, clearspace, min size
└── tier-used.txt             # Records which tier was used
```

## 7.7 Output schema (metadata en Engram)

```json
{
  "schema_version": "1.0",
  "status": "ok",
  "department": "logo",
  "tier_used": 0 | 1 | 2,
  "scope_ref": "...",
  "strategy_ref": "...",
  "visual_ref": "...",
  "verbal_ref": "...",
  
  "directions_generated": {
    "primary_form": "wordmark-preferred",
    "generation_method": "claude-native | recraft-v4 | mixed",
    "concepts": [
      {"id": "B1", "direction": "...", "path": "...svg", "rationale": "...", "source": "claude-native"},
      ...
    ],
    "chosen": "B2",
    "user_selection_method": "user-picked | auto-picked"
  },
  
  "variants": {
    "primary": "logo/source/primary.svg",
    "mono": "logo/source/primary-mono.svg",
    "inverse": "logo/source/primary-inverse.svg",
    "icon_only": "..." | null
  },
  
  "derivations": {
    "favicon": [...],
    "apple_touch": "...",
    "og_card": "...",
    "profile_pics": [...],
    "covers": {...}
  },
  
  "app_icons": null | {...},
  "merch_direction": null | {...},
  
  "usage_guidelines": {
    "clearspace_rule": "...",
    "minimum_size": {...},
    "donts": [...]
  },
  
  "quality_validation": {
    "all_concepts_passed_quality": true,
    "retries_required": 0,
    "flags": []
  },
  
  "cost_tracking": {
    "tier_used": 0,
    "recraft_generations": 0,
    "total_cost_usd": 0.00
  }
}
```

## 7.8 Persistencia

- Metadata en `brand/{slug}/logo` en Engram
- Files en filesystem (`output/{slug}/brand/logo/*`)

## 7.9 Reveal al user

### Post-generation initial

```
[17:45] ④ 4 logo concepts (Tier {N}, wordmark-preferred)

[B1 SVG rendered]  [B2 SVG rendered]  [B3 SVG rendered]  [C1 SVG rendered]
Serif classical    Hybrid            Sans refined       Combination

Rationales:
  B1: Authority clásica, Fraunces-inspired con 'A' custom
  B2: Unexpected — 'A' serif, resto sans. Sage pedagogy
  B3: Refined sans, maximum legibility
  C1: Símbolo + wordmark

¿Cuál? (o pedí variants, o feedback para regen)
```

### Post-selection

```
[19:20] Logo B2 applied

PRIMARY:    [SVG rendered]
MONO:       [SVG]
INVERSE:    [SVG]
ICON-ONLY:  [SVG]

Applied in contexts:
[Favicon en browser tab mockup]
[Mock business card]
[OG card preview]
[LinkedIn banner mock]

12 derivations generated.
Tier used: 0 (Claude native SVG)
Total cost: $0.00
```

## 7.10 Relación con otros deptos

**Handoff Compiler consume**:
- Logo primary + variants → Brand Document PDF (logo section embedded) + Reference Assets folder
- Derivations → Reference Assets folder
- Rationale → Brand Document rationale section

## 7.11 Failure modes específicos

### Claude-generated SVG inválido (Tier 0)
- Parse XML → fails
- Retry con explicit prompt "output must be valid SVG XML"
- Max 2 retries
- Fallback: request Recraft (auto-elevate to Tier 1 temporarily con user confirm)

### Recraft API down (Tier 1+)
- Retry 3×
- Fallback: Claude native (degrade to Tier 0 behavior)
- Flag: "symbolic logos degraded — Claude-generated limited quality"

### Quality validation falla persistently
- Present con flag "some concepts below quality threshold"
- User can accept or request regen

### User rechaza 3+ rounds
- Offer "manual upload" mode

### SVG malformed
- Validation fail
- Retry con emphasis format
- Fallback raster PNG (degraded)

### App icon 16×16 not legible (Tier 1+)
- Design doesn't survive scale-down
- Regenerate con prompt "must remain identifiable at 16px"
- Max 3 retries
- Warn user explicitly if persistent

## 7.12 SKILL.md a escribir en Sprint 0

`skills/brand/logo/SKILL.md` con los 7 pasos + tier-based logic + auto-elevation rules.

## 7.13 Reference files a escribir en Sprint 0

- `skills/brand/logo/references/data-schema.md`
- `skills/brand/logo/references/claude-svg-templates.md` — SVG structure templates for Claude native (Tier 0)
- `skills/brand/logo/references/recraft-prompt-templates.md` — Recraft prompts per archetype × direction (Tier 1+)
- `skills/brand/logo/references/direction-strategies-by-profile.md`
- `skills/brand/logo/references/quality-validation.md`
- `skills/brand/logo/references/auto-elevation-rules.md` — cuándo auto-elevate tier

## 7.14 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Tier 0 + wordmark-preferred → 4 SVG wordmarks Claude-generated, parseables, valid
2. Tier 0 + symbolic-first → user prompted to elevate tier
3. Tier 1 + symbolic-first → Recraft symbolic + Claude wordmark mixed
4. Tier 2 + any → Recraft todo
5. SVG output válido (parseable, no corrupto) para Tier 0
6. Variants (mono, inverse) preservan structure
7. Derivations (favicon, OG card) rendean correctamente
8. `app_asset_criticality: primary` → set completo iOS + Android (Tier 1+)
9. User regen con feedback → feedback applied
10. Quality validation detecta SVG corrupto y regenerate
11. Recraft down (Tier 1+) → degrade graceful a Tier 0

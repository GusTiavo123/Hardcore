# 07 — Department 4: Logo & Key Visuals

## 7.1 Propósito

Generar **logo + assets visuales derivados** usando Claude native SVG generation. Zero costo externo. Output son archivos SVG (vector, text-based) que pueden ser editados, versionados y transformados programáticamente.

**Importante**: el logo que generamos es el **standalone asset**. Cuando Claude Design aplica la marca en mockups (landing, decks, etc.), puede consumir nuestro SVG desde el Brand Document o desde la Reference Assets folder — no necesita regenerarlo.

## 7.2 Inputs

- `brand/{slug}/scope` (manifest — determina primary_form + derived assets needed)
- `brand/{slug}/strategy` (archetype, voice — vocabulario para guiar el form language)
- `brand/{slug}/visual` (paleta para aplicar, typography para wordmarks)
- `brand/{slug}/verbal` (nombre elegido, tagline para OG card)

## 7.3 Form language según `logo_primary_form`

| Primary form | Directions generated | Form language |
|---|---|---|
| `wordmark-preferred` | 3 wordmark + 1 combination | Tipográfico puro con ajustes custom (letter-spacing, weight, custom-cut de 1 glyph) |
| `combination` | 1 symbolic-geometric + 2 combination + 1 wordmark | Wordmark + símbolo geométrico (círculo, cuadrado modular, intersección de formas) |
| `symbolic-first` | 3 symbolic-geometric + 1 combination | Símbolo geométrico protagonista; wordmark secundario |
| `icon-first` (consumer app) | 4 symbolic-geometric optimizados para 16×16/app stores + 1 combination | Geometric marks que sobreviven scale-down; grid 1024px con safe area |

**Constraint de v1**: todos los símbolos son **geometric** (shapes matemáticas, intersecciones, líneas, gradientes simples). Ilustraciones orgánicas complejas, mascotas dibujadas, y scenes ilustradas quedan fuera de scope v1 — Claude native SVG no alcanza la calidad consistente para eso. Si el scope demanda un mark orgánico fuerte, el output flagea `organic_mark_requested_geometric_delivered: true` con nota al user de que ese refinamiento específico es mejor subirlo a Claude Design y pedirle una variante orgánica sobre nuestro mark geometric como base.

## 7.4 Proceso — 7 pasos

### Paso 1 — Determinar directions

Basado en `scope.logo_primary_form` + `scope.intensity_modifiers.app_asset_criticality`, Logo dept decide cuántos concepts generar y con qué form language (ver tabla 7.3).

Para consumer-app con `app_asset_criticality: primary`, el dept prioriza geometric marks con alta legibilidad a 16×16 (tests de shrink durante generation).

### Paso 2 — SVG generation strategy

Claude genera SVG markup directamente. Estructura base para wordmarks:

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 100" width="400" height="100">
  <text x="20" y="70" font-family="Fraunces, serif" font-size="60" font-weight="600" fill="#0B1F3A"
        letter-spacing="-0.02em">
    {Brand Name}
  </text>
  <!-- Optional: geometric accent element -->
</svg>
```

Estructura base para symbolic geometric marks:

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200" width="200" height="200">
  <circle cx="100" cy="100" r="80" fill="#0B1F3A"/>
  <path d="M60 100 L100 60 L140 100 L100 140 Z" fill="#F4EFE6"/>
</svg>
```

Ajustes per archetype (selección, no exhaustivo):

| Archetype | Wordmark adjustments | Symbolic adjustments |
|---|---|---|
| Sage | Serif clásico, weight 600-700, letter-spacing slight (-0.02em), proporción estable | Geometría circular + cuadrada; simetría; líneas delgadas-medias |
| Jester | Sans redondeado, weight 700+, playful sizing mix | Shapes curvas, overlap con color vivo, composición asimétrica |
| Ruler | Serif moderno (Didone) o sans geométrico, weight 500-600, letter-spacing generoso | Geometría angular simétrica, proporciones doradas, heráldica minimal |
| Outlaw | Sans condensed, weight 800+, tracking tight, 1 glyph distorsionado | Slash/cut marks, asimetría agresiva, contraste fuerte |
| Caregiver | Serif humanista o sans redondeado, weight 400-500, warmth | Orgánicos geométricos (heart, leaf via polygons), círculo protagonista |
| Hero | Sans geometric weight 700-800, tracking tight, all-caps op | Triangle-based, escalada, momentum diagonal |
| Explorer | Sans refined weight 500-600, leve tracking amplio | Líneas de mapa, compass-like geometry, horizontes |
| Creator | Sans display con 1 custom cut, weight mixto | Composición modular, grid visible, stroke + fill contrast |
| Innocent | Sans rounded weight 400-500, generous letter-spacing | Formas simples (círculo, estrella), palette clara |
| Lover | Serif romántico weight 400, italic op, hairlines delgados | Orgánicos sensual (shapes sinuosas via bezier), paleta saturada |
| Magician | Sans geometric con 1 transformation, weight 600 | Simetría mágica, geometría sacra, gradientes sutiles |
| Everyman | Sans neutral weight 500, no frills | Shapes simples universales, rectángulo/círculo base |

El detalle completo queda en `skills/brand/logo/references/svg-templates.md` (Sprint 0).

### Paso 3 — Generación

Claude escribe SVG markup para cada concept. Output típico: 4-5 SVG strings.

Save a filesystem en `output/{slug}/brand/logo/concepts/`:
- `concept-b1.svg`, `concept-b2.svg`, etc.

### Paso 4 — Quality validation pre-user

Checks automáticos antes de mostrar al user:

- **Valid XML**: parse con XML parser; si falla, regenerate
- **Not empty**: minimum 2 elements (para wordmarks: al menos 1 text + optional accent; para symbolic: al menos 2 paths o shapes)
- **Not all-same-color**: verifica que uses al menos 2 colores de la paleta (salvo mono/inverse variants)
- **Palette compliance**: colores usados están en la paleta de Visual dept (tolerance ±5 en RGB)
- **Reasonable complexity**: element count entre 2 y 40 (evita logos vacíos o overworked)
- **16px legibility** (si `app_asset_criticality: primary`): render el SVG a 16×16 internamente, check si las features principales sobreviven (via visual inspection prompt a Claude)

Si un concept falla, regenerate con feedback explícito. Max 2 retries por concept. Si 2 retries fallan, skip ese concept y continuar con los que sí pasaron (mínimo 3 concepts deben pasar para no bloquear).

### Paso 5 — User selection

Presentar concepts como grid al user:

```
[17:45] ④ 4 logo concepts (wordmark-preferred)

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
- Pick a direction + regenerate 2-3 variants en esa direction
- "None" + feedback for full regen (max 2 full regens antes de offer manual mode)
- "Manual" — user provides own logo SVG, dept skips generation, downstream uses el SVG del user

### Paso 6 — Variants del logo elegido

Variants se generan programáticamente via SVG XML manipulation (no requiere regeneration):

| Variant | Cómo se genera |
|---|---|
| **Primary** (full color) | El SVG del concept seleccionado |
| **Mono** (negro sobre blanco) | Reemplazar todos los `fill` por `#000000`, `stroke` por `#000000` |
| **Inverse** (blanco sobre dark bg) | Reemplazar todos los `fill` por `#FFFFFF`, agregar background rect oscuro |
| **Icon-only** | Si combination: extraer solo el símbolo (drop text elements). Si wordmark puro: skip (no icon-only disponible) |

Claude ejecuta estas transformaciones emitiendo el SVG modificado directamente (cheap, reproducible).

### Paso 7 — Derived assets

Condicional según `scope.output_manifest`:

**Siempre** (programmatic desde SVG primary):
- **Favicon set**: 16×16, 32×32, 48×48 (Claude emite SVGs simplified a cada size; conversión a PNG via headless render en Sprint 1 tooling, o entrega como SVG embedded si PNG tool no disponible)
- **Apple touch icon**: 180×180
- **Favicon.ico**: multi-size combined (Sprint 1 via librería)

**Si `app_asset_criticality: primary`** (consumer app):
- **App icon iOS**: set completo (20/29/40/58/60/80/87/120/180/1024 en SVG, raster en Sprint 1)
- **App icon Android**: foreground + background layers (adaptive icon format)
- **Mask variants**: circular, rounded, squircle (Claude emite variants aplicando clip-path SVG)

**Si landing en prompts library**:
- **OG card** (1200×630): Claude emite SVG composition (logo + tagline + palette bg). Rasterización en Sprint 1.

**Si social presence en scope**:
- **Profile pictures** (400×400): crop cuadrado del logo/icon
- **Cover banners**: X 1500×500, LinkedIn 1584×396 (composition con logo + paleta)

**Si `community-movement` o `content-media`**:
- **Merch direction** (templates, no production-ready):
  - T-shirt design layout (hero print + placement en SVG mockup)
  - Sticker designs (circular, square)
  - Mug design direction (wraparound spec en SVG + description)

Todos los derived assets se emiten inicialmente como SVG. La conversión a PNG/ICO requiere tooling adicional que se instala/configura en Sprint 1 (headless chromium o rsvg-convert). Si ese tooling falla, Brand entrega los SVGs + un README con instrucciones manuales de conversión.

## 7.5 Tools

- Claude native (SVG generation, palette reasoning, archetype interpretation)
- SVG XML manipulation (para variants mono/inverse/icon-only)
- Headless rasterization tool (Sprint 1 — rsvg-convert o similar) para derived assets PNG

## 7.6 Output package estructurado

```
output/{slug}/brand/logo/
├── concepts/
│   ├── concept-b1.svg
│   ├── concept-b2.svg
│   ├── concept-b3.svg
│   └── concept-c1.svg
├── source/
│   ├── primary.svg           # Full color
│   ├── primary-mono.svg      # Black on white
│   ├── primary-inverse.svg   # White on dark
│   └── icon-only.svg         # Símbolo aislado (si aplica)
├── derivations/
│   ├── favicon-16.svg (+png si tool disponible)
│   ├── favicon-32.svg (+png)
│   ├── favicon-48.svg (+png)
│   ├── favicon.ico (si tool disponible)
│   ├── apple-touch-180.svg (+png)
│   ├── og-card-1200x630.svg (+png)
│   ├── profile-pic-400.svg (+png)
│   ├── profile-pic-400-bg.svg (+png)
│   ├── cover-x-1500x500.svg (+png)
│   └── cover-linkedin-1584x396.svg (+png)
├── app-icons/                # Si scope lo requiere
│   ├── ios/
│   │   └── (multiple sizes)
│   └── android/
│       └── (adaptive icon files)
├── merch/                    # Si scope lo requiere
├── rationale.md              # Why this concept, archetype expression, how variants work
└── usage-guidelines.md       # Do/don'ts, clearspace, min size, palette rules
```

## 7.7 Output schema (metadata en Engram)

```json
{
  "schema_version": "1.0",
  "status": "ok",
  "department": "logo",
  "scope_ref": "brand/{slug}/scope",
  "strategy_ref": "brand/{slug}/strategy",
  "visual_ref": "brand/{slug}/visual",
  "verbal_ref": "brand/{slug}/verbal",

  "directions_generated": {
    "primary_form": "wordmark-preferred | combination | symbolic-first | icon-first",
    "generation_method": "claude-native-svg",
    "concepts": [
      {
        "id": "B1",
        "direction": "string",
        "path": "logo/concepts/concept-b1.svg",
        "rationale": "string",
        "form_language": "wordmark | combination | symbolic-geometric"
      }
    ],
    "chosen": "B2",
    "user_selection_method": "user-picked | auto-picked | user-manual-uploaded",
    "manual_upload_note": "string | null"
  },

  "variants": {
    "primary": "logo/source/primary.svg",
    "mono": "logo/source/primary-mono.svg",
    "inverse": "logo/source/primary-inverse.svg",
    "icon_only": "logo/source/icon-only.svg | null"
  },

  "derivations": {
    "favicon": ["..."],
    "apple_touch": "...",
    "og_card": "...",
    "profile_pics": ["..."],
    "covers": {"x": "...", "linkedin": "..."}
  },

  "app_icons": null | {"ios": [...], "android": {...}},
  "merch_direction": null | {...},

  "usage_guidelines": {
    "clearspace_rule": "1x the x-height del wordmark | 0.5x el diámetro del icon",
    "minimum_size": {
      "wordmark_px": 120,
      "icon_px": 24,
      "favicon_px": 16
    },
    "donts": ["no rotar", "no aplicar filtros", "no recolorear fuera de paleta", "no distorsionar ratios"]
  },

  "quality_validation": {
    "all_concepts_passed_quality": true,
    "retries_required": 0,
    "flags": [],
    "organic_mark_requested_geometric_delivered": false
  },

  "evidence_trace": {
    "svg_generation_attempts": 4,
    "regenerations_due_to_validation_fail": 0
  }
}
```

## 7.8 Persistencia

- Metadata en `brand/{slug}/logo` en Engram
- Files en filesystem (`output/{slug}/brand/logo/*`)

## 7.9 Reveal al user

### Post-generation initial

```
[17:45] ④ 4 logo concepts (wordmark-preferred)

[B1 SVG rendered]  [B2 SVG rendered]  [B3 SVG rendered]  [C1 SVG rendered]
Serif classical    Hybrid            Sans refined       Combination

Rationales:
  B1: Authority clásica, Fraunces-inspired con 'A' custom
  B2: Unexpected — 'A' serif, resto sans. Sage pedagogy
  B3: Refined sans, maximum legibility
  C1: Símbolo geometric + wordmark

¿Cuál? (o pedí variants, o feedback para regen)
```

### Post-selection

```
[19:20] Logo B2 applied

PRIMARY:    [SVG rendered]
MONO:       [SVG]
INVERSE:    [SVG]
ICON-ONLY:  [SVG]

Applied in mockups:
[Favicon en browser tab]
[Business card mock]
[OG card preview]
[LinkedIn banner mock]

12 derivations generadas.
```

## 7.10 Relación con otros deptos

**Handoff Compiler consume**:
- Logo primary + variants → sección Logo del Brand Document PDF + Reference Assets folder (SVGs sueltos)
- Derivations → Reference Assets folder
- Rationale → sección Logo rationale del Brand Document
- Usage guidelines → sección Logo usage del Brand Document

## 7.11 Failure modes específicos

### SVG inválido (Claude output malformado)
- Parse XML → fails
- Retry con explicit prompt: *"output must be valid SVG XML with correct attribute syntax"*
- Max 2 retries por concept
- Si persistent: skip ese concept, continuar con los que pasaron (mínimo 3 válidos para no bloquear)

### Quality validation falla en 2+ concepts consecutivos
- Flag `quality_degraded: true`
- Present al user con warning explícito: *"2 concepts no pasaron validation automática. Revisá cuidadosamente antes de elegir."*
- User decide si acepta, re-genera, o manual-upload

### 16px legibility fail (consumer-app)
- Concept no sobrevive scale-down
- Regenerate con prompt adicional: *"mark must remain recognizable at 16×16; simplify shapes, increase stroke width relative to size"*
- Max 3 retries en este caso
- Si persistent: flag + warn user, ofrecer manual-upload del app icon específico

### User rechaza 3+ rounds de regeneration
- Offer "manual upload" mode
- User provee su propio SVG, dept lo valida (parse, palette check), y downstream consume ese
- Brand Document registra `user_manual_upload: true` en logo section

### Rasterization tool down (sprint 1 concern)
- SVG outputs OK, pero PNGs no se generan
- Brand Document embeb SVGs directamente (soportado por navegadores y Claude Design)
- README incluye instrucciones de conversión manual (e.g., imagemagick, online converters)
- Flag: `rasterization_deferred_to_user: true`

## 7.12 Archivos a escribir en Sprint 0

Para este depto:
- `skills/brand/logo/SKILL.md` — los 7 pasos. **Incluye inline**: form language tables per archetype, direction strategies per brand_profile, quality validation checks (XML parse, element count, palette compliance, 16px legibility), variants derivation rules (mono/inverse/icon-only como transformations programáticas), derived assets logic (favicons, OG cards, app icons, covers, merch direction)
- `skills/brand/logo/references/data-schema.md`
- `skills/brand/logo/references/svg-templates.md` — templates de SVG por archetype × form language (big reference, standalone)

## 7.14 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos específicos:

1. `wordmark-preferred` scope → 4 SVG wordmarks válidos, parseables, palette-compliant
2. `combination` scope → mezcla de wordmark + geometric marks
3. `symbolic-first` scope → 3 geometric marks + 1 combination, sin text
4. `icon-first` scope (consumer-app) → 4 geometric marks que pasan 16px legibility test
5. Variants programmatic (mono, inverse, icon-only) preservan structure del primary
6. Derivations (favicon, OG card) rendean correctamente desde SVG source
7. `app_asset_criticality: primary` → set completo iOS + Android en SVG
8. User regen con feedback → feedback applied en próxima round
9. Quality validation detecta SVG corrupto/vacío y regenera
10. User manual-upload → SVG validado y propagado a Handoff sin regenerar
11. Rasterization tool down → graceful degradation, SVG-only + instrucciones manuales

# SVG Templates per Archetype × Form Language

Reference consumed by Logo. Provides concrete SVG starting templates that the sub-agent can customize with brand-specific values (name, palette HEX, typography).

Templates are **starting points**, not copy-paste solutions. Claude adapts them to the specific brand.

---

## 1. Wordmarks

### Wordmark — Sage (serif classical)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 100" width="400" height="100">
  <!-- Classical serif, slight negative tracking, stable proportion -->
  <text x="20" y="70"
        font-family="Fraunces, serif"
        font-size="60"
        font-weight="600"
        fill="{COLOR_PRIMARY}"
        letter-spacing="-0.02em">
    {BRAND_NAME}
  </text>
</svg>
```

### Wordmark — Ruler (premium)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 100">
  <text x="20" y="70"
        font-family="Playfair Display, serif"
        font-size="56"
        font-weight="500"
        fill="{COLOR_PRIMARY}"
        letter-spacing="0.08em">
    {BRAND_NAME}
  </text>
</svg>
```

### Wordmark — Hero (bold sans)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 100">
  <text x="20" y="75"
        font-family="Syne, sans-serif"
        font-size="68"
        font-weight="800"
        fill="{COLOR_PRIMARY}"
        letter-spacing="-0.03em"
        text-transform="uppercase">
    {BRAND_NAME}
  </text>
</svg>
```

### Wordmark — Everyman/Innocent (humanist)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 100">
  <text x="20" y="70"
        font-family="Inter, sans-serif"
        font-size="58"
        font-weight="500"
        fill="{COLOR_PRIMARY}">
    {BRAND_NAME}
  </text>
</svg>
```

### Wordmark — Jester (playful)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 100">
  <text x="20" y="75"
        font-family="Rubik, sans-serif"
        font-size="62"
        font-weight="700"
        fill="{COLOR_PRIMARY}">
    {BRAND_NAME}
  </text>
  <!-- Optional: accent dot above a letter -->
  <circle cx="{ACCENT_X}" cy="15" r="6" fill="{COLOR_ACCENT}"/>
</svg>
```

### Wordmark — Outlaw (condensed bold)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 100">
  <text x="20" y="75"
        font-family="Anton, sans-serif"
        font-size="72"
        font-weight="400"
        fill="{COLOR_PRIMARY}"
        letter-spacing="0.02em"
        text-transform="uppercase"
        transform="skewX(-8)">
    {BRAND_NAME}
  </text>
</svg>
```

### Wordmark — Caregiver/Lover (warm serif)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 100">
  <text x="20" y="70"
        font-family="Lora, serif"
        font-size="58"
        font-weight="400"
        fill="{COLOR_PRIMARY}"
        font-style="italic">
    {BRAND_NAME}
  </text>
</svg>
```

---

## 2. Combination Marks (symbol + wordmark)

### Combination — Sage / Ruler (balanced)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 120">
  <!-- Symbol on left -->
  <g transform="translate(10, 10)">
    <rect x="0" y="0" width="80" height="80" rx="4" fill="{COLOR_PRIMARY}"/>
    <path d="M20 40 L40 20 L60 40 L40 60 Z" fill="{COLOR_BACKGROUND}"/>
  </g>
  <!-- Wordmark on right -->
  <text x="110" y="68"
        font-family="Fraunces, serif"
        font-size="52"
        font-weight="600"
        fill="{COLOR_PRIMARY}">
    {BRAND_NAME}
  </text>
</svg>
```

### Combination — Hero (dynamic angular)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 120">
  <g transform="translate(10, 20)">
    <!-- Triangle pointing up-right, momentum -->
    <polygon points="0,80 40,0 80,80" fill="{COLOR_PRIMARY}"/>
    <polygon points="20,80 40,30 60,80" fill="{COLOR_ACCENT}"/>
  </g>
  <text x="110" y="75"
        font-family="Syne, sans-serif"
        font-size="56"
        font-weight="800"
        fill="{COLOR_PRIMARY}"
        text-transform="uppercase">
    {BRAND_NAME}
  </text>
</svg>
```

### Combination — Community/Caregiver (circular)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 120">
  <g transform="translate(20, 20)">
    <!-- Interlocking circles (community) -->
    <circle cx="30" cy="40" r="30" fill="none" stroke="{COLOR_PRIMARY}" stroke-width="6"/>
    <circle cx="55" cy="40" r="30" fill="none" stroke="{COLOR_ACCENT}" stroke-width="6"/>
  </g>
  <text x="120" y="70"
        font-family="Inter, sans-serif"
        font-size="50"
        font-weight="500"
        fill="{COLOR_PRIMARY}">
    {BRAND_NAME}
  </text>
</svg>
```

---

## 3. Symbolic-Geometric Marks

### Symbolic — Sage (geometric symmetry)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200" width="200" height="200">
  <!-- Centered circle containing geometric figure -->
  <circle cx="100" cy="100" r="80" fill="{COLOR_PRIMARY}"/>
  <path d="M60 100 L100 60 L140 100 L100 140 Z" fill="{COLOR_BACKGROUND}"/>
  <circle cx="100" cy="100" r="8" fill="{COLOR_ACCENT}"/>
</svg>
```

### Symbolic — Magician (sacred geometry)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200">
  <!-- Triangle within circle, vesica piscis suggestion -->
  <circle cx="100" cy="100" r="80" fill="{COLOR_PRIMARY}"/>
  <polygon points="100,35 160,140 40,140" fill="none" stroke="{COLOR_ACCENT}" stroke-width="3"/>
  <circle cx="100" cy="100" r="40" fill="none" stroke="{COLOR_ACCENT}" stroke-width="2"/>
</svg>
```

### Symbolic — Creator (modular grid)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200">
  <!-- 3×3 modular grid with varied fills -->
  <rect x="20" y="20" width="48" height="48" fill="{COLOR_PRIMARY}"/>
  <rect x="76" y="20" width="48" height="48" fill="none" stroke="{COLOR_PRIMARY}" stroke-width="4"/>
  <rect x="132" y="20" width="48" height="48" fill="{COLOR_ACCENT}"/>
  <circle cx="44" cy="100" r="24" fill="{COLOR_ACCENT}"/>
  <rect x="76" y="76" width="48" height="48" fill="{COLOR_PRIMARY}"/>
  <rect x="132" y="76" width="48" height="48" fill="none" stroke="{COLOR_ACCENT}" stroke-width="4"/>
  <rect x="20" y="132" width="48" height="48" fill="none" stroke="{COLOR_PRIMARY}" stroke-width="4"/>
  <rect x="76" y="132" width="48" height="48" fill="{COLOR_ACCENT}"/>
  <circle cx="156" cy="156" r="24" fill="{COLOR_PRIMARY}"/>
</svg>
```

### Symbolic — Explorer (compass / map abstraction)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200">
  <circle cx="100" cy="100" r="80" fill="none" stroke="{COLOR_PRIMARY}" stroke-width="4"/>
  <!-- North-pointing arrow -->
  <polygon points="100,30 110,100 100,90 90,100" fill="{COLOR_PRIMARY}"/>
  <!-- South arm, secondary -->
  <polygon points="100,170 110,100 100,110 90,100" fill="{COLOR_ACCENT}" opacity="0.6"/>
  <circle cx="100" cy="100" r="6" fill="{COLOR_PRIMARY}"/>
</svg>
```

### Symbolic — Outlaw (angular disruption)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200">
  <rect x="20" y="20" width="160" height="160" fill="{COLOR_PRIMARY}"/>
  <!-- Diagonal cut -->
  <polygon points="20,100 180,20 180,80 80,180 20,180" fill="{COLOR_ACCENT}"/>
</svg>
```

### Symbolic — Jester (playful asymmetric)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200">
  <circle cx="70" cy="70" r="50" fill="{COLOR_PRIMARY}"/>
  <circle cx="130" cy="130" r="40" fill="{COLOR_ACCENT}"/>
  <rect x="100" y="30" width="40" height="40" fill="{COLOR_ACCENT_2}" transform="rotate(15, 120, 50)"/>
</svg>
```

### Symbolic — Innocent (simple shapes)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200">
  <circle cx="100" cy="100" r="70" fill="{COLOR_PRIMARY}"/>
  <circle cx="100" cy="100" r="35" fill="{COLOR_BACKGROUND}"/>
</svg>
```

### Symbolic — Lover (sinuous organic-geometric)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200">
  <path d="M40 100 Q 100 20, 160 100 Q 100 180, 40 100 Z"
        fill="{COLOR_PRIMARY}"/>
  <circle cx="100" cy="100" r="20" fill="{COLOR_ACCENT}"/>
</svg>
```

---

## 4. Icon-first (consumer app) — 16×16 survivable

For `b2c-consumer-app` with `app_asset_criticality: primary`. Design must survive shrinking to 16×16.

### Icon — simple silhouette (universal pattern)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="1024" height="1024">
  <!-- Rounded-rectangle mask (iOS convention) -->
  <rect x="0" y="0" width="1024" height="1024" rx="200" fill="{COLOR_PRIMARY}"/>
  <!-- Core symbol — bold, simple, ONE primary shape -->
  <circle cx="512" cy="512" r="280" fill="{COLOR_ACCENT}"/>
  <rect x="480" y="370" width="64" height="284" rx="32" fill="{COLOR_BACKGROUND}"/>
</svg>
```

### Icon — letter mark (name starts with distinctive glyph)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">
  <rect x="0" y="0" width="1024" height="1024" rx="200" fill="{COLOR_PRIMARY}"/>
  <text x="512" y="720"
        font-family="Syne, sans-serif"
        font-size="640"
        font-weight="800"
        fill="{COLOR_ACCENT}"
        text-anchor="middle">
    {INITIAL}
  </text>
</svg>
```

### Icon — geometric bold (distinctive silhouette)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">
  <rect x="0" y="0" width="1024" height="1024" rx="200" fill="{COLOR_PRIMARY}"/>
  <polygon points="512,200 824,512 512,824 200,512" fill="{COLOR_ACCENT}"/>
  <circle cx="512" cy="512" r="120" fill="{COLOR_PRIMARY}"/>
</svg>
```

### Icon — Android adaptive (foreground + background layers)

Separate SVGs for Android's adaptive icon format:

**foreground.svg** (inset 66% safe zone):
```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 108 108">
  <g transform="translate(18, 18)">
    <!-- Foreground symbol within 72×72 safe area -->
    <circle cx="36" cy="36" r="28" fill="{COLOR_ACCENT}"/>
    <rect x="32" y="20" width="8" height="32" fill="{COLOR_BACKGROUND}"/>
  </g>
</svg>
```

**background.svg** (solid color or gradient):
```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 108 108">
  <rect x="0" y="0" width="108" height="108" fill="{COLOR_PRIMARY}"/>
</svg>
```

---

## 5. Derived Assets (programmatic from primary)

### Favicon (simplified for 16×16)

For favicons, strip complexity. If primary mark has multiple elements, use just the dominant shape. Claude emits a simplified version per size.

```xml
<!-- 32×32 simplified example -->
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">
  <rect x="0" y="0" width="32" height="32" rx="6" fill="{COLOR_PRIMARY}"/>
  <circle cx="16" cy="16" r="8" fill="{COLOR_ACCENT}"/>
</svg>
```

### OG Card (1200×630)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 630" width="1200" height="630">
  <rect x="0" y="0" width="1200" height="630" fill="{COLOR_BACKGROUND}"/>
  <!-- Logo in top-left -->
  <g transform="translate(80, 80)">
    {PRIMARY_LOGO_CONTENT}
  </g>
  <!-- Tagline centered -->
  <text x="80" y="420"
        font-family="{HEADING_FONT}"
        font-size="80"
        font-weight="600"
        fill="{COLOR_PRIMARY}"
        style="max-width: 1040px;">
    {TAGLINE}
  </text>
  <!-- Brand URL bottom-right -->
  <text x="1120" y="570"
        font-family="{BODY_FONT}"
        font-size="28"
        fill="{COLOR_TEXT_SECONDARY}"
        text-anchor="end">
    {BRAND_DOMAIN}
  </text>
</svg>
```

### Profile Pic (400×400)

Crop of primary or icon-only to square, centered, padded with background color.

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400">
  <rect x="0" y="0" width="400" height="400" fill="{COLOR_BACKGROUND}"/>
  <g transform="translate(80, 80) scale(1.2)">
    {ICON_ONLY_CONTENT}
  </g>
</svg>
```

### Cover Banner — LinkedIn (1584×396)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1584 396">
  <rect x="0" y="0" width="1584" height="396" fill="{COLOR_PRIMARY}"/>
  <!-- Left: logo -->
  <g transform="translate(80, 100)">
    {PRIMARY_LOGO_ON_DARK_CONTENT}
  </g>
  <!-- Right: tagline subtle -->
  <text x="1504" y="210"
        font-family="{HEADING_FONT}"
        font-size="48"
        font-weight="400"
        fill="{COLOR_BACKGROUND}"
        opacity="0.85"
        text-anchor="end">
    {TAGLINE}
  </text>
</svg>
```

---

## 6. Variant Transformations (Claude-emitted programmatically)

### Mono variant (black on white)

Starting from primary SVG, replace every `fill="..."` (except `none`) with `fill="#000000"`, every `stroke="..."` with `stroke="#000000"`. Preserve opacity. Emit the transformed SVG.

### Inverse variant (white on dark)

Add a background rect: `<rect x="0" y="0" width="{viewBox_w}" height="{viewBox_h}" fill="{COLOR_PRIMARY_DARK}"/>` as the first child. Replace every `fill` with `#FFFFFF` (except background), every `stroke` with `#FFFFFF`.

### Icon-only variant

From a combination mark, drop the `<text>` elements and any wordmark-related groups. Adjust viewBox to fit the remaining symbol tightly.

---

## 7. Selection Heuristics

When multiple concepts are generated, rank by:

1. **Quality validation pass** (binary)
2. **Archetype fit** — how well the form matches the archetype's tendencies in `archetype-guide.md` §9
3. **Memorability** — concepts with simpler silhouettes score higher
4. **16px legibility** (mandatory for icon-first, bonus for others)
5. **Uniqueness from competitors** — avoid visual patterns dominant in `validation.competitive.direct_competitors`

Emit scores in `data.directions_generated.concepts[].quality_validation_passed` and `rationale`.

---

## 8. Palette Variable Mapping

When customizing templates, use Visual's palette values:

| Template variable | Visual palette source |
|---|---|
| `{COLOR_PRIMARY}` | `palette.primary_palette.colors.primary.hex` |
| `{COLOR_BACKGROUND}` | `palette.primary_palette.colors.background.hex` |
| `{COLOR_ACCENT}` | `palette.primary_palette.colors.accent.hex` |
| `{COLOR_ACCENT_2}` | Second accent if palette has multi-accent structure |
| `{COLOR_PRIMARY_DARK}` | Darkest color in palette (typically primary if dark) |
| `{COLOR_TEXT_SECONDARY}` | `palette.primary_palette.colors.text_secondary.hex` |
| `{HEADING_FONT}` | `typography.heading.family` |
| `{BODY_FONT}` | `typography.body.family` |
| `{BRAND_NAME}` | `verbal.naming_artifact.chosen` |
| `{INITIAL}` | First letter of `{BRAND_NAME}` |
| `{TAGLINE}` | `verbal.core_copy_artifact.taglines[0].text` (short) |
| `{BRAND_DOMAIN}` | Assumed `{brand-name-lower}.com` unless verbal specifies otherwise |

---

## 9. Critical Rules

1. **All fills must be from palette.** No external colors in generated SVGs.
2. **Web-safe font stack.** Use Google Fonts via inline `font-family` — fonts are embedded via `fonts.css` in Brand Tokens, not inline in SVG.
3. **viewBox consistency.** Wordmarks: 400×100. Symbolic: 200×200. App icons: 1024×1024.
4. **No external file references.** SVGs must be self-contained (no `href` to external images).
5. **Geometric primitives only.** `rect`, `circle`, `ellipse`, `polygon`, `path` (simple bezier), `line`, `text`, `g`. No `image`, no `foreignObject`, no external filter refs.
6. **Keep element counts low.** Target <20 elements per concept for legibility and file-size.

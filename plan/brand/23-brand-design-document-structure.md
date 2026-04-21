# 24 — Brand Design Document: Estructura del PDF

## 24.1 Propósito

Spec detallado del **Brand Design Document PDF** — el deliverable #1 de nuestros 4 outputs, el que el user sube a Claude Design para que extraiga el design system.

**Principio de diseño clave** (del hallazgo de investigación Claude Design):
> *"A finished landing page or marketing site tells Claude more about your brand's feel than a color palette alone."*

**Implicación**: el PDF NO es un spec dump. Es un brand book **visual aplicado** que PARECE una marca corriendo. Claude Design infiere mejor desde ejemplos que desde specs listadas.

## 24.2 Filosofía del documento

El Brand Design Document cumple 3 roles simultáneamente:

1. **Input optimizado para Claude Design** — cuando user lo sube al design system setup, Claude Design extrae color palette, typography, componentes, voice, visual principles
2. **Brand book formal para humanos** — el founder puede compartirlo con cofounder, investor, diseñador contratado
3. **Meta-ejemplo de la marca aplicada** — el PDF ES un ejemplo de la marca funcionando (usa el logo en header, palette como accents, typography embedded)

**Triple propósito guía el diseño** de cada página.

## 24.3 Principios de construcción

### Visual > Spec

❌ Evitar:
```
Primary color: #0B1F3A (Navy)
Usage: backgrounds, auth, headers
```

✓ Preferir:
```
[Large navy rectangle as page background]
[Sample text "Navigate compliance with clarity" rendered in Fraunces 600]
[Small HEX tag bottom corner: #0B1F3A — Navy — backgrounds/auth]
```

### Meta-branding

El PDF usa la propia brand:
- Logo primary en header de cada página
- Color accents aplicados en UI del documento
- Typography embedded (Fraunces para headings, Inter para body)
- Voice attributes respetadas en la prose del documento

### Densidad apropiada

- Cada página focused — un concepto principal
- Whitespace generoso (match visual principles del Sage por ejemplo)
- Samples grandes (typography renderizable, palette swatches visibles)

## 24.4 Estructura — 10-12 páginas

### Página 1 — Cover

**Layout**: full page.

**Content**:
- Logo primary rendered grande (centered, 40% of page width)
- Brand name rendered en heading font (e.g., Fraunces 900)
- Tagline rendered en body font size large
- Date + "Brand Design System" subtle en footer

**Claude Design infiere**: visual hierarchy, logo placement, typography scale, tagline style.

### Página 2 — Brand Essence

**Layout**: editorial 2-column.

**Content**:
- Heading: "Who we are"
- Archetype identification: "Sage — the expert guide"
- Brand promise (1 oración grande, quote style)
- Positioning statement (párrafo longer)
- Target audience refined (primary + secondary — brief)

**Claude Design infiere**: editorial voice, tone, how we talk about ourselves.

### Página 3 — Voice & Tone

**Layout**: split page.

**Content**:
- Voice attributes listed with definitions (3-5 attrs)
- **Do / Don't columns** con sample copy:
  ```
  DO:
  "Audit the audits."  
  "40 hours → 2 hours."
  
  DON'T:
  "Our innovative synergies..."  
  "Revolutionary paradigms..."
  ```
- Voice principles applied en prose examples

**Claude Design infiere**: acceptable copy style, tone boundaries.

### Página 4 — Color Palette

**Layout**: full-width color swatches + usage notes.

**Content**:
- Large swatches de cada color (primary, background, accent, text-primary, text-secondary)
- Each swatch con HEX + name + usage description applied visibly
  - E.g., Primary Navy swatch con white text "used for headers" rendered in the color itself
- Contrast matrix visual (grid mostrando which text works on which bg)
- **Applied example**: mini-card showing palette in use (title + body + CTA button)

**Claude Design infiere**: exact HEX codes, semantic usage, contrast rules.

### Página 5 — Typography

**Layout**: typography specimen page.

**Content**:
- **Heading font specimen**: large sample "The quick brown fox" en Fraunces 700, plus multiple sizes (48px, 32px, 24px)
- **Body font specimen**: paragraph de lorem-ipsum-style text en Inter 400, plus size variants
- **Mono font specimen** (si applicable): code-style sample en JetBrains Mono
- Font metadata: family, weights available, Google Fonts import URL, size scale
- **Applied example**: mini-page layout showing typography hierarchy in action

**Claude Design infiere**: font families, weights, sizes, line heights, how to pair.

### Página 6 — Logo System

**Layout**: logo showcase grid.

**Content**:
- Logo primary (large display)
- Logo variants: mono, inverse, icon-only (smaller, side by side)
- Clearspace diagram (showing minimum whitespace around logo)
- Usage do/don'ts (visual — don't stretch, don't recolor, don't add effects)
- Minimum size specification
- **Applied examples**: logo en different contexts (favicon, OG card, business card)

**Claude Design infiere**: which logo to use en different contexts, how to apply.

### Página 7 — Mood & Atmosphere (conditional on tier)

**Tier 0**: skip esta página (no mood imagery generated). Incluir textual description of mood en página 8 instead.

**Tier 1+**: full page de mood imagery.

**Layout**: grid 2×3 o 3×2 de mood images.

**Content**:
- 6 mood images (Unsplash Tier 1, Recraft Tier 2)
- Caption minimal para each ("Energy: quiet-deliberate", "Texture: considered-smooth", etc.)
- Brief narrative intro: "This is what the brand feels like"

**Claude Design infiere**: aesthetic direction, stylistic references para future imagery it generates.

### Página 8 — Visual Principles

**Layout**: mixed — description + applied examples.

**Content**:
- **Whitespace philosophy**: name + description + visual example
- **Shape language**: geometric vs organic + visual example (rounded cards, circular avatars, etc.)
- **Imagery style**: illustrative vs photographic + reference
- **Motion principles** (brief): speed + easing guidelines
- Each principle con mini-example aplicado

**Claude Design infiere**: layout principles, component aesthetics, motion defaults.

### Página 9 — Copy Library Samples

**Layout**: "brand in action" showcase.

**Content**:
- Hero section rendered: headline + subheadline + CTA en actual brand typography + palette
- Tagline applied in hero position
- 3 value propositions rendered as cards con brand styling
- About section excerpt (short) rendered
- CTA button examples (primary + secondary)

**Claude Design infiere**: hero layouts, value prop structure, CTA styling, copy conventions.

### Página 10 — Scope-specific application preview

**Conditional per brand profile**:

**b2d-devtool**:
- Code snippet con brand syntax highlighting theme
- CLI terminal mock con brand colors
- GitHub README preview con brand colors

**b2local-service**:
- Printable flyer mockup
- Business card mockup  
- Google Maps preview style

**content-media**:
- Podcast cover design (if podcast)
- Video thumbnail template
- Newsletter template preview

**community-movement**:
- Manifesto page layout
- Discord/Slack server branding preview
- Emblem/symbolic asset showcase

**b2c-consumer-app**:
- App icon showcase (set of sizes)
- App store screenshot template
- Onboarding screen preview

**b2b-enterprise / b2b-smb**:
- Landing page hero mockup
- Pitch deck cover slide mockup
- LinkedIn post template preview

**Claude Design infiere**: scope-specific visual language, component patterns para that segment.

### Página 11 — Scope & Limitations (transparency)

**Content**:
- "This brand book covers:" (list)
- "This brand book does NOT cover (by scope):" (list with reasons)
- "Out of scope v1 (module limitation):" (list with future modules candidates)
- Disclaimers (TM screening preliminary, legal review required para Privacy/Terms)

**Claude Design ignora** este meta-content (not brand-informing) pero humanos leen.

### Página 12 — Appendix: Evidence trace + versioning

**Content**:
- Evidence trace resumido (qué del Validation/Profile informó qué decisions)
- Tool versions
- Brand module version
- Generation timestamp
- Reference numbers para versioning

**Claude Design ignora** este meta-content.

## 24.5 Design tokens embedded

El PDF debe embedear **machine-readable design tokens** que Claude Design puede extraer:

### Color tokens (página 4)
Cada swatch con:
- HEX code prominently displayed
- Machine-readable text: "color-primary: #0B1F3A"
- Semantic usage tag: "usage: backgrounds, auth, headers"

### Typography tokens (página 5)
Cada font con:
- Family name displayed
- Weights available listed
- Sizes applied visibly
- Google Fonts import URL (small text somewhere)

### Spacing tokens (página 8)
Visual grid showing spacing scale (4/8/16/24/32/48/64/96 px) applied to actual spacing in the PDF layout itself.

### Component tokens (página 9)
Applied examples ARE the tokens:
- Button renderizado con exact properties (color, radius, padding, font, weight)
- Card rendered con exact properties (radius, shadow, padding)

## 24.6 Format y production

### Tool: `ms-office-suite:pdf` skill

Generation path:
1. Handoff Compiler compiles content for each page
2. Markdown → PDF via skill (with inline styling para visual elements)
3. Embedded fonts (Google Fonts imported in PDF)
4. Embedded logo SVGs
5. Embedded mood imagery (if Tier 1+)

### Filename

`brand-design-document.pdf` (always — canonical filename)

### File size target

~2-10 MB (Tier 0 minimum — text + logo SVG). Tier 1+ adds mood imagery → 5-20 MB.

### Compatibility

- PDF/A compliance para archivability
- Fonts embedded (no CDN dependency post-download)
- Rasterization fallback para fonts si embedding falla

## 24.7 Claude Design compatibility testing

**How to verify PDF es Claude Design-friendly**:

1. User uploads PDF to Claude Design design system setup
2. Wait for extraction (~30s-2min)
3. Verify extracted design system:
   - Colors: primary, secondary, accent — do they match our palette?
   - Typography: heading, body — do they match our fonts?
   - Components: buttons, cards — do they reflect our applied examples?
   - Voice: does Claude Design's generated copy match our voice attributes?
4. Create test project in Claude Design
5. Generate a simple landing page
6. Compare: does output feel like our brand?

If mismatches: investigate + iterate PDF structure.

## 24.8 Iteration history (template)

As we test with real Claude Design runs, document learnings:

```
## Iteration history

### v1 (Sprint 0, 2026-04-25)
- Initial structure as designed
- Tested with [idea-slug]
- Issues found: [...]

### v1.1 (...)
- Fix: increase font size samples (Claude Design was missing body font)
- Fix: add explicit HEX text (was only visual swatches)
- Improved: [...]
```

Track iterations en `skills/brand/handoff-compiler/references/brand-document-template.md` changelog.

## 24.9 Reference file a escribir en Sprint 0

`skills/brand/handoff-compiler/references/brand-document-template.md` contiene:
- Este spec expandido
- Exact layouts por página
- Markdown templates con placeholders
- Page count per brand profile
- File size targets
- Claude Design compatibility notes + iteration history

## 24.10 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md) categoría 3 (Claude Design compatibility). Casos:

1. PDF generates correctly all 10-12 pages
2. PDF opens in standard viewers (Preview, Adobe)
3. PDF uploads to Claude Design without errors
4. Claude Design extracts design system:
   - Palette colors match
   - Typography matches
   - Voice extracted somehow (subjective)
5. Test project en Claude Design produces brand-consistent output
6. Scope-specific page (page 10) reflects correct profile
7. Tier 0 PDF skips mood page (replaces with text description)
8. Tier 1+ PDF has mood page with imagery grid
9. File size reasonable (under 20MB even Tier 2)
10. Brand applied meta-consistently (logo in header, palette as accents, typography embedded)

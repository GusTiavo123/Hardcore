# 23 — Brand Design Document: Estructura del PDF

## 23.1 Propósito

Spec detallado del **Brand Design Document PDF** — el deliverable #1 de nuestros 4 outputs, el que el user sube a Claude Design en "Set up your design system" para que Claude Design extraiga el design system y pueda aplicar la identidad consistentemente en projects subsiguientes.

**Principio de diseño clave** (de la documentación de Claude Design):
> *"A finished landing page or marketing site tells Claude more about your brand's feel than a color palette alone."*

**Implicación**: el PDF NO es un spec dump. Es un brand book **visual aplicado** que PARECE una marca corriendo. Claude Design infiere mejor desde ejemplos que desde specs listadas.

## 23.2 Filosofía del documento

El Brand Design Document cumple 3 roles simultáneamente:

1. **Input optimizado para Claude Design** — cuando el user lo sube, Claude Design extrae color palette, typography, componentes, voice, visual principles
2. **Brand book formal para humanos** — el founder puede compartirlo con cofounder, investor, diseñador contratado
3. **Meta-ejemplo de la marca aplicada** — el PDF ES un ejemplo de la marca funcionando (usa el logo en header, palette como accents, typography embedded en el documento mismo)

El triple propósito guía el diseño de cada página.

## 23.3 Principios de construcción

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
- Typography embedded (Fraunces para headings, Inter para body — o las que hayan sido elegidas)
- Voice attributes respetadas en la prose del documento

### Densidad apropiada

- Cada página focused — un concepto principal
- Whitespace generoso (coherente con visual principles del brand)
- Samples grandes (typography renderizable, palette swatches visibles)

## 23.4 Page range por brand profile

El Brand Document tiene entre 8 y 18 páginas según scope. Profiles con más assets o aplicaciones específicas requieren más páginas:

| Brand profile | Page range | Razón del rango |
|---|---|---|
| `b2local-service` | **8-10** | Scope compacto, sin pitch deck, sin enterprise sections |
| `b2b-smb` | **10-12** | Baseline |
| `b2d-devtool` | **10-13** | + Developer aesthetic preview, code snippet styling page |
| `b2c-consumer-web` | **10-12** | Baseline + social grid preview |
| `content-media` | **12-14** | + Podcast cover preview, newsletter template, merch direction |
| `b2c-consumer-app` | **12-15** | + App icon showcase, onboarding screens preview |
| `community-movement` | **14-16** | + Manifesto page, symbolic assets showcase, merch direction |
| `b2b-enterprise` | **14-18** | + Pitch deck preview, case study template, security/compliance copy, executive audience section |

Handoff Compiler determina el page count final al compilar en función de qué secciones opcionales se incluyen según el scope manifest.

## 23.5 Estructura base — páginas siempre presentes

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
- **Heading font specimen**: large sample "The quick brown fox" en heading font (e.g., Fraunces 700), plus multiple sizes (48px, 32px, 24px)
- **Body font specimen**: paragraph de lorem-ipsum-style text en body font (e.g., Inter 400), plus size variants
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
- **Applied examples**: logo en different contexts (favicon, OG card, business card si print-templates existen)

**Claude Design infiere**: which logo to use en different contexts, how to apply.

### Página 7 — Visual Principles

**Layout**: mixed — description + applied examples.

**Content**:
- **Whitespace philosophy**: name + description + visual example
- **Shape language**: geometric vs organic + visual example (rounded cards, circular avatars, etc.)
- **Imagery style**: direction for imagery that Claude Design should generate later
- **Motion principles** (brief): speed + easing guidelines (directional, no assets generados en v1)
- Cada principle con mini-example aplicado

**Claude Design infiere**: layout principles, component aesthetics, motion defaults.

### Página 8 — Copy Library Samples

**Layout**: "brand in action" showcase.

**Content**:
- Hero section rendered: headline + subheadline + CTA en actual brand typography + palette
- Tagline applied in hero position
- 3 value propositions rendered as cards con brand styling
- About section excerpt (short) rendered
- CTA button examples (primary + secondary)

**Claude Design infiere**: hero layouts, value prop structure, CTA styling, copy conventions.

### Última página — Appendix: Evidence trace + versioning

**Content**:
- Evidence trace resumido (qué del Validation/Profile informó qué decisiones)
- Tool versions
- Brand module version
- Generation timestamp
- Reference numbers para versioning

**Claude Design ignora** este meta-content (not brand-informing) pero humanos leen.

## 23.6 Páginas condicionales — según scope

### Mood & Atmosphere (cuando scope incluye mood imagery refs)

**Layout**: grid 2×3 o 3×2 de mood image refs (Unsplash).

**Content**:
- 3-6 mood image URLs (Unsplash refs con attribution) rendered como image embeds o como cards con título + descripción + URL clickeable (según lo que permita el PDF skill)
- Caption minimal para each ("Energy: quiet-deliberate", "Texture: considered-smooth", etc.)
- Brief narrative intro: "This is what the brand feels like"
- Attribution line por imagen: "Photo by {photographer} on Unsplash"

**Profiles que típicamente incluyen mood refs** (ver 03-brand-profiles.md): b2c-consumer-app, b2c-consumer-web, content-media, community-movement.

**Si Unsplash API está down** en el run: skippear esta página. Brand Document describe el mood en prosa dentro de Visual Principles (página 7) sin imagery refs.

### Scope-specific application preview (conditional per brand profile)

**b2d-devtool**:
- Code snippet con brand syntax highlighting theme
- CLI terminal mock con brand colors
- GitHub README preview con brand colors

**b2local-service**:
- Printable flyer mockup
- Business card mockup
- Google My Business preview style

**content-media**:
- Podcast cover design (if podcast en scope)
- Video thumbnail template
- Newsletter template preview

**community-movement**:
- Manifesto page layout
- Discord/Slack server branding preview
- Emblem/symbolic asset showcase

**b2c-consumer-app**:
- App icon showcase (set de tamaños)
- App store screenshot template
- Onboarding screen preview

**b2b-enterprise / b2b-smb**:
- Landing page hero mockup
- Pitch deck cover slide mockup (enterprise only)
- LinkedIn post template preview
- Case study template excerpt (enterprise only)

**Claude Design infiere**: scope-specific visual language, component patterns para ese segmento.

### Scope & Limitations (transparency)

**Content**:
- "This brand book covers:" (list de lo incluido per scope)
- "This brand book does NOT cover (by scope):" (list con reasons)
- "Out of scope v1 (module limitation):" (list con future modules candidatos)
- Disclaimers (TM screening preliminar, Claude Design dependency)

**Claude Design ignora** este meta-content pero humanos leen.

## 23.7 Design tokens embedded

El PDF embedea **machine-readable design tokens** que Claude Design puede extraer:

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

### Spacing tokens (página 7)
Visual grid showing spacing scale (4/8/16/24/32/48/64/96 px) applied to actual spacing in the PDF layout itself.

### Component tokens (página 8)
Applied examples ARE los tokens:
- Button renderizado con exact properties (color, radius, padding, font, weight)
- Card rendered con exact properties (radius, shadow, padding)

## 23.8 Format y production

### Tool: `ms-office-suite:pdf` skill

Generation path:
1. Handoff Compiler compila content para cada página
2. Markdown → PDF via skill (con inline styling para visual elements)
3. Embedded fonts (Google Fonts imported en PDF)
4. Embedded logo SVGs
5. Embedded mood image refs (links, no downloaded binaries)

### Filename

`brand-design-document.pdf` (always — canonical filename).

### File size target

~2-8 MB típicamente. Rango hasta ~15 MB en profiles con más imagery embeds.

### Compatibility

- PDF/A compliance para archivability cuando el skill lo soporta
- Fonts embedded (no CDN dependency post-download)
- Fallback si PDF skill falla: entrega como `brand-design-document.md` + instrucciones de conversión manual

## 23.9 Claude Design compatibility testing

**Cómo verificar que el PDF es Claude Design-friendly** (testing manual):

1. User uploads PDF a Claude Design "Set up your design system"
2. Wait for extraction (~30s-2min)
3. Verify extracted design system:
   - Colors: primary, secondary, accent — matchean nuestra palette?
   - Typography: heading, body — matchean nuestras fonts?
   - Components: buttons, cards — reflejan nuestros applied examples?
   - Voice: el copy que Claude Design genera matchea nuestros voice attributes?
4. Create test project en Claude Design
5. Generate simple landing page
6. Compare: el output feels como nuestra brand?

Si hay mismatches: investigar + iterar la estructura del PDF. Track en el changelog del template.

## 23.10 Iteration history (template)

Conforme testeamos con Claude Design runs reales, documentar learnings directamente en `skills/brand/handoff-compiler/references/brand-document-template.md` (Sprint 0). Este archivo queda como spec vivo que evoluciona con dogfooding.

## 23.11 Reference file a escribir en Sprint 0

`skills/brand/handoff-compiler/references/brand-document-template.md` contiene:
- Este spec expandido con exact layouts por página
- Markdown templates con placeholders para substitution
- Page count logic per brand profile
- File size targets
- Claude Design compatibility notes
- Changelog para iteration history

## 23.12 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md) Category 4 (Claude Design compatibility). Casos:

1. PDF generates correctly según page range del profile
2. PDF opens en standard viewers (Preview, Adobe, Firefox)
3. PDF uploads a Claude Design sin errors
4. Claude Design extrae design system:
   - Palette colors match
   - Typography match
   - Voice extracted (subjective assessment)
5. Test project en Claude Design produce brand-consistent output
6. Scope-specific page refleja correct profile
7. Scope que incluye mood refs → página Mood presente con Unsplash URLs
8. Unsplash down en el run → mood description en prosa, sin página dedicada
9. File size razonable (típicamente <15 MB)
10. Brand applied meta-consistently (logo en header, palette como accents, typography embedded)
11. PDF fallback a markdown cuando PDF skill falla

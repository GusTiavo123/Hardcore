# 08 — Department 5: Activation

## 8.1 Propósito

Hacer que la marca **corra**. Integrar outputs de todos los deptos anteriores + enforzar coherencia cross-dept + entregar un **paquete ejecutable dinámico** según scope.

Activation es el **climax del módulo**. Es el depto que transforma "te dimos 4 outputs" en "te dimos tu marca funcionando".

**Diferencia clave vs Brand Book tradicional**: outputs anteriores producen specs; Activation produce un **microsite HTML corriendo**, assets aplicados, y sí, también el PDF del brand book — pero el PDF es subproducto, no centerpiece.

## 8.2 Inputs

- `brand/{slug}/scope` (manifest completo)
- `brand/{slug}/strategy` (archetype, voice, positioning, values)
- `brand/{slug}/verbal` (nombre, copy completo)
- `brand/{slug}/visual` (paleta, typography, mood, principles)
- `brand/{slug}/logo` (logo + derivations paths)
- Profile + Validation (context para microsite content)

## 8.3 Proceso — 6 pasos

### Paso 1 — Compilar `.stitch/DESIGN.md`

Documento markdown con formato Stitch-compatible. Este es el **source of truth machine-readable** que Stitch (y módulos futuros) consumen.

**Estructura**:

```markdown
# Brand Design System — Auren

## Identity
- Archetype: Sage
- Positioning: "Para compliance officers de fintechs LATAM, Auren es la plataforma..."
- Voice attributes: claro, autorizante, directo, empático-técnico

## Colors

### Primary palette
- primary: #0B1F3A (Navy) — backgrounds, auth, headers
- background: #F4EFE6 (Off-white) — page bg, cards
- accent: #D4A74A (Amber) — CTAs, highlights, warm emphasis
- text-primary: #2A3B52 (Deep slate) — body, headings
- text-secondary: #8B97A8 (Steel) — meta, captions

### Usage rules
- Body text always on `background`, never on `primary`
- Primary is for backgrounds only when content is inverted (white text)
- Accent used sparingly — primary CTA buttons, selected states, key highlights
- Minimum 40% whitespace on key layouts

## Typography

### Fonts
- Heading: Fraunces (Google Fonts)
  - Weights: 400, 600, 700
  - Import: `https://fonts.googleapis.com/css2?family=Fraunces:wght@400;600;700&display=swap`
  - Default weight: 600
- Body: Inter (Google Fonts)
  - Weights: 400, 500, 600
  - Default: 400
- Mono: JetBrains Mono (optional, for data tables)

### Type scale
- h1: 48px / line-height 1.15
- h2: 32px / 1.2
- h3: 24px / 1.3
- body-large: 18px / 1.6
- body: 16px / 1.6
- small: 14px / 1.5
- meta: 12px / 1.4

## Spacing scale
4 / 8 / 16 / 24 / 32 / 48 / 64 / 96 / 128 px

## Component patterns

### Buttons
- Shape: rounded rectangle, radius 8px
- Primary CTA: bg accent (#D4A74A), text primary-dark, weight 500
- Secondary: bg transparent, border 1px primary, text primary
- Minimum touch target: 44×44px

### Cards
- Radius: 12px
- Shadow: subtle (0 2px 8px rgba(11, 31, 58, 0.06))
- Padding: 32px (generous)

### Forms
- Style: underline (minimal chrome)
- Focus state: amber accent underline
- Labels: weight 500, text-secondary color

## Logo
- Primary: /logo/source/primary.svg
- Monochrome: /logo/source/primary-mono.svg
- Inverse: /logo/source/primary-inverse.svg
- Icon-only: /logo/source/icon-only.svg (for favicon)
- Clearspace: minimum equal to logo height
- Min size: 24px height

## Voice principles

### Do
- Lead with claim, support with evidence
- Technical precision without jargon
- Short sentences. Declarative.
- Specific numbers > vague claims ("40 hours → 2 hours" not "much faster")
- Respect reader intelligence

### Don't
- Hype language, superlatives without data
- Sales-y CTAs ("Act now!", "Limited time!")
- Jargon opaco (synergy, leverage, paradigm)
- Humor con risk profesional

### Sample voice in action
"Stop drowning in compliance spreadsheets." — direct, specific pain
"Auren converts 40-hour regulatory audits into 2 supervised hours." — claim + evidence
"Built for fintechs in MX, CO, AR. Not another US tool squeezed into LATAM." — diferenciación clara
```

Guardar en `output/{slug}/brand/DESIGN.md` + referenciar desde Engram manifest.

### Paso 2 — Invocar Stitch MCP para generar screens

Tool: Stitch MCP (ver [11-tools-stack.md](./11-tools-stack.md))

**Screens generados, dinámicos por scope**:

| Screen | Condición de generación |
|---|---|
| `index.html` (landing) | Always required |
| `pricing.html` | Required si `bizmodel.pricing_model` está definido Y scope != `b2local-service` |
| `about.html` | Required si scope != `b2local-service` (locals integran about en landing) |
| `docs.html` skeleton | Required si `b2d-devtool` |
| `case-studies.html` | Required si `b2b-enterprise` |
| `app-landing.html` (store-style) | Required si `b2c-consumer-app` |
| `community.html` | Required si `community-movement` |
| `contact.html` o section | Always |
| `security.html` | Required si `b2b-enterprise` o `fintech`-hinted |
| `privacy.html` skeleton | Always (legal requirement) |
| `terms.html` skeleton | Always |

**Social post templates** (Stitch genera como UI screens):

| Template | Condición |
|---|---|
| Instagram carousel 1080×1080 | Si `social_presence_priority` incluye Instagram |
| Instagram story 1080×1920 | Si scope incluye Instagram |
| X/Twitter post 1200×675 | Si scope incluye X |
| LinkedIn post 1200×627 | Si scope incluye LinkedIn |
| TikTok cover 1080×1920 | Si `b2c-consumer-app` |

**Pitch deck cover slide** (si `b2b-enterprise`): Stitch genera también como screen type especial.

**Email template** (si required): Stitch genera HTML email-safe.

**Cada prompt a Stitch** incluye:

```
Input to Stitch MCP:
- reference: ./DESIGN.md (relative path)
- screen_type: "landing" | "pricing" | "about" | "app-landing" | ...
- content: {
    hero_headline: "Stop drowning in compliance spreadsheets.",
    hero_subheadline: "Auren converts 40-hour regulatory audits...",
    cta_primary: "See it on your own data →",
    value_props: [...],
    about_short: "...",
    ...
  }
- layout_direction: "hero-prominent + features-3col + testimonials + cta"
- output_format: "html+css+tailwind"
```

**Stitch devuelve**: HTML + CSS (Tailwind) + optional React component + Figma export.

### Paso 3 — Coherence gates

Ver [09-coherence-model.md](./09-coherence-model.md) para los 9 gates detallados.

Activation ejecuta cada gate secuencialmente antes de proceder a packaging:

1. Archetype ↔ Founder Profile
2. Voice ↔ Archetype
3. Palette ↔ Archetype
4. Palette ↔ Scope (visual_formality)
5. Typography ↔ Archetype/Era
6. Logo ↔ Palette (legibility)
7. Copy ↔ Voice (sample check)
8. Logo form ↔ Scope (primary_form coherence)
9. Screen set ↔ Manifest (all required screens generated)

**Si falla un gate**:

- Identify which dept is responsible
- Return control to that dept with specific feedback
- Dept regenerates affected asset(s)
- Gate re-evaluated

**Max 2 regeneration passes cross-dept**. Si después de 2 passes sigue fallando:

- Escalate a user con diff explicit:
  ```
  Gate 3 (palette ↔ archetype) failing after 2 regenerations.
  Issue: Archetype Sage typically uses cool deep tones + warm accent, but current palette
  has high-contrast aggressive colors (red + black + neon) that matchean archetype Outlaw.
  Options:
    1. Accept current palette despite archetype mismatch (flag en brand book)
    2. Change archetype to Outlaw (re-runs downstream)
    3. Regenerate palette manually with constraints
    4. Exit and fix upstream
  ```

### Paso 4 — Assemble brand book PDF

Tool: `ms-office-suite:pdf` skill existente (ver [11-tools-stack.md](./11-tools-stack.md))

**Estructura del PDF dinámica por scope**:

```
Cover page
  - Logo primary
  - Brand name
  - "Brand book — [date]"

Intro (always)
  - Executive summary
  - Archetype
  - Positioning statement
  - Brand promise
  - Target audience refined

Scope declaration (always — for transparency)
  - Brand profile identified
  - Outputs included
  - Outputs excluded con razón (no silencio)
  - Out-of-scope declarations

Strategy section (always)
  - Archetype + rationale (considered alternatives)
  - Voice attributes + do/don'ts
  - Brand values + evidence
  - Positioning statement expanded

Verbal section (always)
  - Naming rationale (chosen + alternatives + verification matrix)
  - Copy library organized by use case
  - Voice application examples

Visual section (always)
  - Palette con HEX + usage rules + contrast matrix
  - Typography con fonts + scale + samples
  - Mood imagery grid
  - Visual principles

Logo section (always)
  - Logo primary + variants displayed
  - Rationale del logo design
  - Usage rules (do/don'ts, clearspace, min size)
  - Derivations displayed

Application section (always)
  - Screenshots del microsite generado
  - Mockups de assets aplicados (favicon en browser, OG card preview, social posts)

Specific sections (condicional por scope):
  - Pitch deck templates (si b2b-enterprise)
  - App store assets (si b2c-consumer-app)
  - Community materials (si community-movement)
  - Local assets (si b2local-service)

Appendix
  - Evidence trace al Validation + Profile
  - Version info (brand_version, tool versions, timestamps)
  - Legal disclaimers
```

**El PDF debe usar la propia brand** — meta-branding. El PDF renderizado ES un ejemplo de la marca aplicada. Uses:
- Logo in header/cover
- Palette as cover bg + accents
- Typography: heading + body fonts embedded
- Voice applied en all explanations

### Paso 5 — Package assembly

Crear directory `output/{idea-slug}/brand/` con estructura dinámica según manifest.

**Estructura completa** (ver también [18-output-package-structure.md](./18-output-package-structure.md)):

```
output/{slug}/brand/
├── README.md                           ← Always — auto-generated
├── brand-book.pdf                      ← Always
├── DESIGN.md                           ← Always — source of truth machine-readable
├── AUDIT.md                            ← Always — evidence trace + versioning

├── microsite/                          ← If landing in required
│   ├── index.html
│   ├── pricing.html
│   ├── about.html
│   ├── ...specific pages per scope
│   ├── assets/
│   │   ├── logo.svg
│   │   ├── favicon.ico
│   │   ├── og-card.png
│   │   └── mood-01.png
│   ├── styles.css                      ← Tailwind build o inline
│   ├── stitch-source/                  ← Figma export + React source
│   │   ├── figma-export.fig
│   │   └── react/
│   └── netlify.toml | vercel.json      ← Para deploy (ver open decisions)

├── pitch-deck/                         ← Si b2b-enterprise
│   ├── cover-slide.html
│   └── template-slides/
│       ├── problem.html
│       ├── solution.html
│       ├── ...

├── app-assets/                         ← Si b2c-consumer-app
│   ├── app-icons/ios/
│   ├── app-icons/android/
│   ├── screenshots-templates/
│   └── onboarding-templates/

├── local/                              ← Si b2local-service
│   ├── maps-listing-copy.md
│   ├── whatsapp-templates/
│   ├── printable/
│   └── phone-scripts.md

├── logo/                               ← Always
│   ├── source/
│   │   ├── primary.svg
│   │   ├── primary-mono.svg
│   │   ├── primary-inverse.svg
│   │   └── icon-only.svg
│   ├── derivations/
│   │   ├── favicon-16.png
│   │   ├── favicon-32.png
│   │   ├── favicon-48.png
│   │   ├── favicon.ico
│   │   ├── apple-touch-180.png
│   │   ├── og-card-1200x630.png
│   │   ├── profile-pic-400.png
│   │   └── cover-x-1500x500.png
│   ├── app-icons/                      ← If scope
│   ├── merch/                          ← If scope
│   ├── rationale.md
│   └── usage-guidelines.md

├── social/                             ← Según platforms en scope
│   ├── avatars/
│   ├── banners/
│   ├── post-templates-instagram/
│   ├── post-templates-x/
│   ├── post-templates-linkedin/
│   └── sample-posts.md

├── communications/                     ← Según templates en scope
│   ├── email-signature.html
│   ├── email-templates/
│   │   ├── welcome.html
│   │   ├── transactional.html
│   │   └── onboarding-sequence/
│   ├── pitch-one-liner.txt
│   ├── elevator-30s.txt
│   ├── press-release-boilerplate.md
│   ├── whatsapp-templates/              ← Si b2local-service
│   └── bios/
│       ├── linkedin-company.md
│       ├── linkedin-personal.md
│       ├── twitter.md
│       ├── instagram.md
│       └── tiktok.md

├── copy-library.md                     ← Always — todo el copy organizado

└── mood-references/
    └── (6-8 generated mood images)
```

### Paso 6 — README.md del package — autoexplicativo

```markdown
# Auren — Brand Package

**Generated by Hardcore Brand module** · v1.0 · 2026-04-20

---

## Scope identificado

**Brand profile**: B2B SMB SaaS, LATAM-focused, pre-launch stage

Clasificado con confidence 0.84 basado en:
- Target audience del Validation: compliance officers de fintechs
- Pricing model: subscription $200-500/mo
- Distribution: content-driven + outbound sales
- Cultural scope: regional-LATAM

---

## Lo que este paquete incluye

### Strategy
- ✓ Archetype (Sage) + rationale
- ✓ Positioning statement
- ✓ Voice attributes (4) con do/don'ts
- ✓ Brand values (3) con evidence trace

### Verbal
- ✓ Nombre: Auren (domains free, TM clean in preliminary screening)
- ✓ Tagline: "Audit the audits." (+ 2 alternatives)
- ✓ Hero headline + subheadline
- ✓ Value propositions (3 versions)
- ✓ About section (short + medium)
- ✓ CTA copy
- ✓ Pitch one-liner + pitch 30s
- ✓ LinkedIn company + personal bios
- ✓ 5 sample LinkedIn posts
- ✓ Email templates (welcome + transactional)
- ✓ Email signature
- ✓ FAQ seed (10 Q&As)
- ✓ Press release boilerplate
- ✓ Case study template

### Visual
- ✓ Palette (5 colors, WCAG AA verified)
- ✓ Typography (Fraunces + Inter + JetBrains Mono)
- ✓ 6 mood references (generated, stylized)
- ✓ Visual principles documented

### Logo
- ✓ Logo primary (SVG editable)
- ✓ Variants: mono, inverse, icon-only (all SVG)
- ✓ Favicon set (16/32/48 + apple-touch + ico)
- ✓ OG card (1200×630)
- ✓ Profile picture (400×400)
- ✓ LinkedIn banner (1584×396)

### Microsite
- ✓ Landing (index.html)
- ✓ Pricing page
- ✓ About page
- ✓ Security/compliance page
- ✓ Generated by Stitch MCP (HTML + CSS + Tailwind)
- ✓ Figma export included
- ✓ React source included

### Brand book
- ✓ brand-book.pdf (28 pages)

---

## Lo que NO incluye (transparencia)

### Skipped por scope (no son relevantes para tu tipo de idea)
- TikTok/Instagram templates — tu target es B2B profesional, estas platforms no son canal primario
- App icon full set — tu producto es web SaaS, no mobile app
- Podcast cover — no parte de tu distribution strategy
- WhatsApp templates — típico de servicios locales, no aplica a B2B SaaS LATAM
- Community page — tu producto no tiene componente community explícito
- Merch direction — no es prioridad en stage pre-launch B2B SaaS

### Out-of-scope v1 (módulo no cubre)
- Packaging 3D — tu producto es digital, no aplica
- Print CMYK heavy — entregamos RGB; convertir antes de imprenta si necesario
- Motion design (video intros, animations) — no cubierto en v1
- Sonic branding (audio logos, jingles) — no cubierto en v1
- Photography real (product shots, team photos) — mood imagery generated no sustituye fotografía real

Si necesitás alguno de los skipped, pedilos con:
  `/brand:extend verbal.tiktok_bio`
  `/brand:extend logo.app_icon_full_set`

Para out-of-scope, considerar módulos futuros de Hardcore (Brand-Physical, Brand-Motion, Brand-Sonic).

---

## Cómo usar este paquete

### 1. Ver tu marca corriendo
Abrir `microsite/index.html` en tu browser. Es tu landing funcionando — no un mockup.

### 2. Deployar la landing
```bash
cd microsite/
# Opción A: Vercel
vercel

# Opción B: Netlify
netlify deploy --prod

# Opción C: GitHub Pages
# Push a repo, enable GitHub Pages en settings
```

### 3. Customizar copy
Editar `copy-library.md` para ver todo el copy organizado por uso. Cambios en copy se aplican manualmente a microsite/ (o regenerar con `/brand:extend verbal`).

### 4. Editar logo
Abrir `logo/source/primary.svg` en Figma, Illustrator, o cualquier vector editor.

### 5. Usar el brand book
`brand-book.pdf` (28 páginas) — perfecto para:
- Compartir con cofounder / team
- Onboarding de nuevos hires
- Brief a diseñador contratado externamente
- Pitch a investors (incluye positioning + evidence trace)

### 6. Publicar en social
Carpeta `social/` tiene:
- Avatars (profile pictures) — subir a X, LinkedIn, Instagram
- Banners (covers) — upload a LinkedIn, X
- Sample posts — `sample-posts.md` tiene 5 LinkedIn posts listos para copy-paste

### 7. Email signature
`communications/email-signature.html` — importar en Gmail/Outlook/Superhuman.

---

## Disclaimers

- **Trademark screening preliminar**: Los checks de TM en este paquete son búsquedas web preliminares. NO sustituyen una consulta profesional con abogado de propiedad intelectual antes de filing de marca.
- **Legal disclaimers de copy**: Las secciones de Privacy Policy y Terms son skeletons — requieren adaptación legal profesional antes de publicar.
- **Brand book como documento vivo**: Tu marca va a evolucionar. Considerar regenerar el brand package cuando la idea cambie significativamente (validar con `/brand:diff v1 v2`).

---

## Versioning

- Brand version: v1.0
- Generated: 2026-04-20T14:32:00Z
- Idea slug: auren-compliance
- Validation reference: validation/auren-compliance (verdict: GO 74/100)
- Profile reference: profile/user-slug (core completeness 0.54)
- Regenerar parcialmente: `/brand:extend {depto}`
- Ver historial: `/brand:diff v1 v2`
```

## 8.4 Tools

- **Stitch MCP** (principal — UI generation)
- **`ms-office-suite:pdf` skill** (brand book)
- **File system ops** (assembly)
- **Claude native** (DESIGN.md composition, coherence enforcement, README generation)

## 8.5 Persistencia

- `brand/{slug}/activation` — manifest + paths
- `brand/{slug}/final-report` — executive summary (archetype + name + palette + deliverables links)
- `brand/{slug}/snapshot/v{N}` — frozen state post-delivery

Files reales en filesystem bajo `output/{slug}/brand/`.

## 8.6 Reveal final

```
[27:42] ⑤ Activation complete — Tu marca está viva

    📂 output/auren-compliance/brand/

    🌐 Microsite corriendo:
       file:///home/.../microsite/index.html  [abre automáticamente]

    📖 Brand book PDF:
       output/auren-compliance/brand/brand-book.pdf (28 pages)

    📦 47 archivos entregados
       ✓ 4 logos SVG editable + 12 derivations
       ✓ 4 páginas microsite HTML/CSS + Figma export
       ✓ 18 copy assets
       ✓ 5 LinkedIn sample posts
       ✓ 2 email templates + signature
       ✓ DESIGN.md source of truth
       ✓ Case study template + pitch deck cover + press release

    ⚠ Disclaimer: TM screening preliminar. Consultá abogado antes 
      de registrar la marca.

    💰 Cost: $0.73 (image gen) + $0.00 (Stitch free tier)

    Next steps sugeridos:
      1. Abrir microsite/index.html (review)
      2. Deployar: cd microsite/ && vercel
      3. Share brand-book.pdf con cofounder
```

## 8.7 Relación con otros deptos

Activation es **terminal** — no alimenta otros deptos dentro del módulo.

**Provee a módulos futuros** (Launch, GTM, Ops):
- `brand/{slug}/final-report` (entry point canónico)
- `DESIGN.md` (consumible por herramientas externas)
- Todos los artifacts en filesystem

## 8.8 Failure modes específicos

### Stitch rate-limited
- 429 response
- Retry con backoff (3 attempts, con wait increasing)
- Si persiste: degrade a manual HTML templates (internal fallback)
  - Flag en output: "UI generated without Stitch (degraded mode)"

### Stitch genera HTML inválido
- HTML parsing check
- Si fail: request regen con "output must be valid HTML5"
- Max 2 retries

### Coherence gate falla persistently
- Escalate al user con options (ver Paso 3)

### PDF generation falla
- Skill error
- Retry
- Si persiste: entregar package sin PDF, flag en README
- PDF como último resort: markdown convertible

### Filesystem issues
- Permissions, disk space
- Fail gracefully con clear error message

### Stitch free tier exceeded (350/mes)
- Detection via 429 con quota-specific message
- User notification: "Stitch quota del mes consumida. Brand completado con manual templates para este run. Re-run en próximo mes tendrá full Stitch."

## 8.9 SKILL.md a escribir en Sprint 0

`skills/brand/activation/SKILL.md` con los 6 pasos detallados.

## 8.10 Reference files a escribir en Sprint 0

- `skills/brand/activation/references/data-schema.md`
- `skills/brand/activation/references/design-md-template.md` — template para DESIGN.md con placeholders
- `skills/brand/activation/references/screen-prompts.md` — prompts per screen type para Stitch
- `skills/brand/activation/references/package-structure-by-profile.md` — directory structure per scope
- `skills/brand/activation/references/readme-template.md` — template para el README.md del package

## 8.11 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. DESIGN.md generado correctamente parseable por Stitch
2. Stitch genera screens correctos según scope (b2b-enterprise genera pitch deck cover, b2c-consumer-app genera app-landing)
3. Coherence gates detectan incoherencias y regeneran
4. Brand book PDF se genera completo con todas las sections
5. Package structure dinámica — b2local-service incluye `local/`, b2c-consumer-app incluye `app-assets/`
6. README.md del package es accurate (refleja qué se incluyó y qué se skipeó)
7. Microsite HTML se abre correctamente en browser
8. Stitch rate-limited → fallback funciona

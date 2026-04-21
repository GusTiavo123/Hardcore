# 08 — Department 5: Handoff Compiler

## 8.1 Propósito

Compilar outputs de todos los deptos anteriores en **4 deliverables optimizados para Claude Design** + enforzar coherence gates cross-dept + entregar el package final.

Es el **climax del módulo**. Compila:
- Brand Design Document (PDF)
- Prompts Library (Markdown)
- Brand Tokens (code folder)
- Reference Assets (folder)

Todo optimizado para que Claude Design lo ingiera naturalmente.

**Por qué "Handoff Compiler"**: el nombre refleja el rol — no compila el brand final (eso hace Claude Design), compila el handoff al siguiente layer del stack.

## 8.2 Inputs

- `brand/{slug}/scope` (manifest)
- `brand/{slug}/strategy` (archetype, voice, positioning, values)
- `brand/{slug}/verbal` (naming artifact + core copy)
- `brand/{slug}/visual` (palette + typography + mood + principles)
- `brand/{slug}/logo` (logo paths + rationale + variants)
- Profile + Validation (context para el README y audit trace)

## 8.3 Los 4 Deliverables — overview

### Deliverable 1: Brand Design Document (PDF)

**Propósito**: Documento visual que el user sube a Claude Design design system setup (Fase 1 del workflow Claude Design). Claude Design lo lee y extrae el design system completo.

**Clave de diseño**: NO es un spec dump. Es un brand book **visual aplicado** que PARECE una marca corriendo. Claude Design infiere mejor desde ejemplos que desde specs listadas.

Detallado en [24-brand-design-document-structure.md](./24-brand-design-document-structure.md).

### Deliverable 2: Prompts Library (Markdown)

**Propósito**: Library de prompts pre-escritos, customizados al brand + scope, que el user pega en Claude Design para generar cada deliverable específico (landing, deck, social, etc.).

**Clave de diseño**: cada prompt sigue la estructura best-practice de Claude Design (goal + layout + content + audience) + inyecta context del brand (voice attributes, palette HEX, typography, tagline).

Detallado en [25-prompts-library-templates.md](./25-prompts-library-templates.md).

### Deliverable 3: Brand Tokens (code folder)

**Propósito**: Codebase-style folder que Claude Design puede linkear para extraer design tokens automáticamente (la forma más poderosa de pasarle info a Claude Design).

**Estructura**:
```
brand-tokens/
├── tokens.css              # CSS custom properties
├── tokens.json             # Design Tokens Community Group format
├── tailwind.config.js      # Tailwind theme extension
├── fonts.css               # Google Fonts imports
├── README.md               # Usage instructions
└── examples/
    ├── button.html         # Example component using tokens
    ├── card.html
    └── hero.html
```

### Deliverable 4: Reference Assets (folder)

**Propósito**: Assets individuales que el user puede subir como visual references en proyectos específicos de Claude Design.

**Estructura**:
```
reference-assets/
├── logo/
│   ├── primary.svg
│   ├── primary.png (800px rasterized)
│   ├── mono.svg
│   ├── inverse.svg
│   └── icon-only.svg
├── mood/                   # Si tier ≥ 1
│   ├── mood-01-energy.png
│   ├── mood-02-texture.png
│   ├── ...6-8 total
├── samples/                # Mockups pre-generados opcionales
│   └── README.md
└── README.md
```

## 8.4 Proceso — 7 pasos

### Paso 1 — Coherence gates (8 gates)

Enforce gates cross-dept antes de compilar outputs. Ver [09-coherence-model.md](./09-coherence-model.md) para los 8 gates detallados.

**Pattern**:
```
for gate in gates:
    result = gate.check(all_brand_outputs)
    if not result.passed:
        regenerate(result.responsible_dept, result.feedback)
        gate.check_again()
    if persistent_fail (2+ retries):
        escalate_to_user(result, options)
```

### Paso 2 — Compilar Brand Design Document PDF

Usa `ms-office-suite:pdf` skill. Estructura de 8-12 páginas.

Detallado en [24-brand-design-document-structure.md](./24-brand-design-document-structure.md). Resumen:

1. Cover con logo + brand name renderizados (no descritos)
2. Brand essence: archetype + promise + positioning en layout editorial
3. Voice & Tone: attributes + do/don'ts con sample copy rendered
4. Palette: swatches reales con HEX + usage rules + contrast matrix
5. Typography: specimens en fonts reales (heading + body + mono)
6. Logo: variants displayed + clearspace + usage
7. Mood & atmosphere: mood imagery grid (si tier ≥ 1) o descripción textual (tier 0)
8. Visual principles: aplicados visualmente, no solo descritos
9. Copy library samples: hero, tagline, CTAs rendered
10. Scope & limitations: transparencia de qué incluye / excluye
11. Appendix: evidence trace, versioning

**Meta-branding**: el PDF usa la propia brand (logo en header, palette como accents, typography embedded).

### Paso 3 — Compilar Prompts Library Markdown

Genera `prompts-for-claude-design.md` con prompts específicos por scope. Ver [25-prompts-library-templates.md](./25-prompts-library-templates.md) para templates.

**Structure**:
```markdown
# Prompts for Claude Design — {Brand Name}

## How to use
1. Upload brand-design-document.pdf to Claude Design onboarding
2. Validate + publish the design system
3. Copy-paste prompts below into new Claude Design projects

## Design System Reference
[summary of palette HEX, typography, voice for quick reference in prompts]

## Project prompts

### Landing page hero section
Goal: ...
Layout: ...
Content: ...
Audience: ...
Voice: use voice attributes {attrs} — write copy that is {...}
Design: apply published design system. Use {primary_color} for CTA.

Before building, propose 4 distinct visual directions (bg hex / accent hex / approach — one-line rationale), then ask user to pick one.

### [next deliverable]
...
```

Cada prompt customizado al brand + scope manifest.

### Paso 4 — Generar Brand Tokens folder

Templating desde outputs de Visual + Logo:

**tokens.css**:
```css
:root {
  --color-primary: #0B1F3A;
  --color-background: #F4EFE6;
  --color-accent: #D4A74A;
  --color-text-primary: #2A3B52;
  --color-text-secondary: #8B97A8;
  
  --font-heading: "Fraunces", serif;
  --font-body: "Inter", sans-serif;
  --font-mono: "JetBrains Mono", monospace;
  
  --font-size-h1: 48px;
  --font-size-h2: 32px;
  /* ... */
  
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  /* ... */
  
  --radius-sm: 8px;
  --radius-md: 12px;
}
```

**tokens.json** (Design Tokens Community Group format):
```json
{
  "color": {
    "primary": { "value": "#0B1F3A", "type": "color" },
    "background": { "value": "#F4EFE6", "type": "color" },
    ...
  },
  "font": {
    "heading": { "value": "Fraunces", "type": "fontFamily" },
    ...
  },
  "size": {...},
  "spacing": {...}
}
```

**tailwind.config.js**:
```js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: '#0B1F3A',
        background: '#F4EFE6',
        accent: '#D4A74A',
        'text-primary': '#2A3B52',
        'text-secondary': '#8B97A8'
      },
      fontFamily: {
        heading: ['Fraunces', 'serif'],
        body: ['Inter', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace']
      }
    }
  }
}
```

**fonts.css**:
```css
@import url('https://fonts.googleapis.com/css2?family=Fraunces:wght@400;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap');
```

**examples/button.html**:
```html
<!DOCTYPE html>
<html>
<head>
  <link rel="stylesheet" href="../fonts.css">
  <link rel="stylesheet" href="../tokens.css">
</head>
<body style="font-family: var(--font-body); background: var(--color-background); padding: 48px;">
  <button style="
    background: var(--color-accent);
    color: var(--color-primary);
    font-family: var(--font-body);
    font-weight: 500;
    padding: var(--spacing-sm) var(--spacing-md);
    border-radius: var(--radius-sm);
    border: none;
    font-size: 16px;
  ">
    Get started →
  </button>
</body>
</html>
```

Similar templates para `card.html` y `hero.html`.

**Validation post-generation** (built-in utility):
- Parse JSON → schema valid? If not, regenerate
- Parse CSS → syntax valid? If not, regenerate  
- Parse Tailwind config as JS → valid? If not, regenerate
- Parse HTML examples → parseable? If not, regenerate
- Max 2 retries per file

### Paso 5 — Assemble Reference Assets folder

Copiar + organizar:
- Logo SVGs (source + derivations de Depto 4)
- Mood imagery (si tier ≥ 1, del Depto 3)
- Sample applications (si pre-generated)
- README.md explaining each asset

### Paso 6 — Generar README.md del package

Estructura del README:

```markdown
# {Brand Name} — Brand Package

Generated by Hardcore Brand module · v1.0 · {date}
For use with: **Claude Design** (primary downstream)

---

## Scope identificado

Brand profile: **{profile}** (confidence {%})

Based on:
- Target audience: {from Validation Problem dept}
- Pricing model: {from BizModel dept}
- Distribution: {from scope analysis}
- Cultural scope: {from scope analysis}

---

## How to use this package with Claude Design

### Step 1 — Upload Brand Design Document
1. Go to claude.ai/design
2. Start design system setup (onboarding)
3. Upload `brand-design-document.pdf` from this folder
4. Claude Design reads it and extracts the design system

### Step 2 — Validate design system
1. Create a test project in Claude Design
2. Prompt: "Create a simple 1-page site for {Brand Name} using my brand"
3. Verify the output matches your expectations

### Step 3 — Publish design system
1. In Claude Design settings, toggle "Published"
2. All your future projects inherit this design system

### Step 4 — Use Prompts Library
1. Open `prompts-for-claude-design.md`
2. Copy-paste relevant prompts into Claude Design projects
3. Each prompt is pre-customized for your brand

### Step 5 — (Advanced) Link Brand Tokens
If you have an existing codebase:
1. Copy `brand-tokens/` folder into your repo
2. Import tokens.css in your main CSS
3. Link your codebase to Claude Design for automatic token extraction

### Step 6 — Deploy
Each Claude Design project can be exported:
- HTML/CSS/Tailwind
- PPTX (for decks)
- PDF
- Handoff bundle → Claude Code → Vercel/Netlify/GitHub Pages

---

## What's included (per scope)

### Always
- brand-design-document.pdf (for Claude Design setup)
- prompts-for-claude-design.md (for Claude Design projects)
- brand-tokens/ (for codebase linking — optional)
- reference-assets/logo/ (SVG logos + derivations)
- README.md (this file)
- AUDIT.md (evidence trace + versioning)

### Your scope ({profile}) included
- Landing page prompt
- Pricing page prompt
- About page prompt
- {other prompts specific to your scope}
- Core copy (tagline, hero, value props, about, CTA, pitch)
- LinkedIn bios + sample posts
- {other assets specific to your scope}

### Not included (with reasons)
**Skipped by scope** (not relevant for your type of idea):
- {list of skipped outputs with reasons}

**Out of scope v1** (module limitation):
- Packaging 3D design
- Print CMYK-ready specs
- Motion design assets
- Sonic branding
- Real photography

For these, consider:
- Hire specialists using this brand book as brief
- Future Hardcore modules (Brand-Physical, Brand-Motion, Brand-Sonic)

---

## Disclaimers

- **Trademark screening preliminar**: TM checks are web search-based. Consult IP lawyer before filing.
- **Legal documents**: Privacy/Terms skeletons require legal review
- **Brand book as living document**: regenerate when idea evolves significantly (`/brand:new` creates v2)

---

## Versioning

- Brand version: v1.0
- Generated: {timestamp}
- Idea slug: {slug}
- Validation ref: {validation snapshot ref}
- Profile ref: {profile snapshot ref if applicable}

Commands:
- Partial regenerate: `/brand:extend {depto}`
- View history: `/brand:diff v1 v2`
- Full regenerate: `/brand:new`
```

### Paso 7 — Generar AUDIT.md

Full evidence trace del run. Ver [15-versioning-reproducibility.md](./15-versioning-reproducibility.md#audit-md).

## 8.5 Package final — estructura

Ver [18-output-package-structure.md](./18-output-package-structure.md) para estructura completa dinámica.

Resumen:
```
output/{idea-slug}/brand/
├── README.md                           ← Instructions step-by-step
├── AUDIT.md                            ← Evidence + versioning
├── brand-design-document.pdf           ← DELIVERABLE 1
├── prompts-for-claude-design.md        ← DELIVERABLE 2
├── brand-tokens/                       ← DELIVERABLE 3
│   ├── tokens.css
│   ├── tokens.json
│   ├── tailwind.config.js
│   ├── fonts.css
│   ├── README.md
│   └── examples/
└── reference-assets/                   ← DELIVERABLE 4
    ├── logo/
    ├── mood/ (si tier ≥ 1)
    ├── samples/
    └── README.md
```

## 8.6 Tools

- **`ms-office-suite:pdf` skill** (Brand Design Document PDF)
- **File system ops** (assembly)
- **Claude native** (templating + README + prompt library customization)
- **Built-in validators** (JSON schema, CSS parser, HTML parser, SVG parser)

**No usa**: image gen directo (esas gens happen en Visual + Logo deptos)

## 8.7 Persistencia

- `brand/{slug}/handoff` en Engram (manifest del package + coherence trace)
- `brand/{slug}/final-report` en Engram (executive summary — entry point for downstream modules)
- `brand/{slug}/snapshot/v{N}` (frozen state para versioning)

Files reales en filesystem bajo `output/{slug}/brand/`.

## 8.8 Reveal final al user

```
[27:42] ⑤ Handoff Compiler — Package completo

📂 output/auren-compliance/brand/

✓ brand-design-document.pdf (12 pages)
✓ prompts-for-claude-design.md (18 prompts customizados)
✓ brand-tokens/ (5 files + 3 examples)
✓ reference-assets/logo/ (4 SVGs + 8 derivations)
{si tier ≥ 1:}
✓ reference-assets/mood/ (6 images)

Coherence gates: 8/8 passed

⚠ Disclaimers:
  • TM screening preliminar — consultá abogado
  • Privacy/Terms skeletons — legal review recomendado

---

Next steps:
1. Abrir README.md para instructions
2. Ir a claude.ai/design
3. Upload brand-design-document.pdf en design system setup
4. Validar + publicar design system
5. Usar prompts del Library en proyectos específicos de Claude Design

Cost total: ${N}
Time elapsed: 18m 42s
Tier used: 0 (Claude native + Claude Design downstream)
```

## 8.9 Relación con otros deptos

Handoff Compiler es **terminal** — no alimenta otros deptos del módulo Brand.

**Provee a módulos futuros** (Launch, GTM, Ops):
- `brand/{slug}/final-report` (entry point canónico)
- `brand/{slug}/handoff` (manifest)
- Filesystem artifacts

Downstream inmediato: **Claude Design** (user-mediated handoff en v1, automated cuando Anthropic ship API).

## 8.10 Failure modes específicos

### PDF generation falla
- Retry
- Fallback: deliver package sin PDF, entregar markdown brand-book.md
- Flag: "PDF conversion failed, markdown included"

### Token file validation falla persistently
- Flag: "token file X may have issues — review before use"
- Max 2 retries
- Include con warning

### Coherence gate escalation (2+ retries)
- Escalate al user con options (ver [09-coherence-model.md](./09-coherence-model.md))

### Filesystem issues (permissions, disk)
- Clear error message
- Preserve state en Engram para resume

### User cancels mid-compilation
- Persist state con `status: "partial"`
- Resume via `/brand:resume`

## 8.11 SKILL.md a escribir en Sprint 0

`skills/brand/handoff-compiler/SKILL.md` con los 7 pasos detallados.

## 8.12 Reference files a escribir en Sprint 0

- `skills/brand/handoff-compiler/references/data-schema.md`
- `skills/brand/handoff-compiler/references/brand-document-template.md` — structure del PDF
- `skills/brand/handoff-compiler/references/prompts-library-templates.md` — templates per scope
- `skills/brand/handoff-compiler/references/tokens-templates/` — templates for each token file type
- `skills/brand/handoff-compiler/references/package-structure-by-profile.md` — dynamic structure
- `skills/brand/handoff-compiler/references/readme-template.md`

## 8.13 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. DESIGN package completo se genera correctamente
2. Brand Design Document PDF renderea + es subible a Claude Design
3. Prompts Library markdown válido + prompts customizados al brand
4. Brand Tokens: JSON/CSS/Tailwind/HTML valid + functional
5. Reference Assets folder estructurado correctamente
6. Coherence gates detectan incoherencias y regeneran
7. README.md refleja accurately lo incluido + excluido
8. Validation: tokens files parseables
9. Filesystem write permissions handled
10. End-to-end: upload PDF a Claude Design → design system extracted correctly

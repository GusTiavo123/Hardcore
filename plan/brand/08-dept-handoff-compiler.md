# 08 — Department 5: Handoff Compiler

## 8.1 Propósito

Compilar outputs de todos los deptos anteriores en **4 deliverables optimizados para Claude Design** + enforzar coherence gates cross-dept + entregar el package final.

Es el **climax del módulo**. Compila:
- Brand Design Document (PDF)
- Prompts Library (Markdown)
- Brand Tokens (code folder)
- Reference Assets (folder)

Todo optimizado para que Claude Design lo ingiera naturalmente.

**Por qué "Handoff Compiler"**: el nombre refleja el rol — no compila la marca final (eso lo hace Claude Design en el downstream), compila el handoff al siguiente layer del stack.

## 8.2 Inputs

- `brand/{slug}/scope` (manifest)
- `brand/{slug}/strategy` (archetype, voice, positioning, values, sentiment_landscape para Gate 0)
- `brand/{slug}/verbal` (naming artifact + core copy)
- `brand/{slug}/visual` (palette + typography + mood + principles)
- `brand/{slug}/logo` (logo paths + rationale + variants)
- `validation/{slug}/*` (para Gate 0 + AUDIT trace)
- `founder_brand_context` si disponible (para README + AUDIT)

## 8.3 Los 4 Deliverables — overview

### Deliverable 1: Brand Design Document (PDF)

**Propósito**: documento visual que el user sube a Claude Design design system setup. Claude Design lo lee y extrae el design system completo.

**Clave de diseño**: NO es un spec dump. Es un brand book **visual aplicado** que PARECE una marca corriendo. Claude Design infiere mejor desde ejemplos que desde specs listadas (ver [23-brand-design-document-structure.md](./23-brand-design-document-structure.md)).

### Deliverable 2: Prompts Library (Markdown)

**Propósito**: library de prompts pre-escritos, customizados al brand + scope, que el user pega en Claude Design para generar cada deliverable específico (landing, deck, social, etc.).

**Clave de diseño**: cada prompt sigue la estructura best-practice de Claude Design (goal + layout + content + audience) + inyecta context del brand (voice attributes, palette HEX, typography, tagline).

Detalle en [24-prompts-library-templates.md](./24-prompts-library-templates.md).

### Deliverable 3: Brand Tokens (code folder)

**Propósito**: codebase-style folder que Claude Design puede linkear para extraer design tokens automáticamente (la forma más poderosa de pasarle info a Claude Design).

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

**Propósito**: assets individuales que el user puede subir como visual references en proyectos específicos de Claude Design.

**Estructura**:
```
reference-assets/
├── logo/
│   ├── primary.svg
│   ├── primary.png (800px rasterized si rasterization tool disponible)
│   ├── mono.svg
│   ├── inverse.svg
│   └── icon-only.svg
├── mood/                   # Si scope incluye mood imagery (Unsplash refs)
│   ├── mood-01-energy.md   # markdown con Unsplash URL + attribution
│   ├── ...
├── samples/                # Opcional — mockups pre-generados
│   └── README.md
└── README.md
```

## 8.4 Proceso — 7 pasos

### Paso 1 — Coherence gates (9 gates, fail-fast)

Enforce los 9 gates cross-module + cross-dept antes de compilar outputs. Ver [09-coherence-model.md](./09-coherence-model.md) para los 9 gates detallados.

**Pattern fail-fast**:
```
for gate in [G0, G1, ..., G8]:
    result = gate.check(brand_outputs, validation_refs, founder_brand_context)
    if not result.passed:
        halt_pipeline()
        surface_to_user(
            failed_gate=gate,
            responsible_dept=result.responsible_dept,
            feedback=result.feedback,
            criticality=result.criticality_for_profile,
            options=[re_run_dept, accept_with_flag, abort_and_fix_upstream]
        )
        break  # no continuar a la próxima gate hasta que el user decida
```

Cada gate se evalúa una sola vez. Si una falla, el pipeline pausa y el user decide. **No hay regeneration automática**. Cuando el user elige re-correr un dept, el pipeline re-evalúa gates desde cero (clean slate).

Si todos los 9 gates pasan, Handoff procede al Paso 2.

### Paso 2 — Compilar Brand Design Document PDF

Usa `ms-office-suite:pdf` skill. Estructura 8-18 páginas según brand_profile (ver [23-brand-design-document-structure.md](./23-brand-design-document-structure.md) para page range per profile).

Secciones (resumen):

1. Cover con logo + brand name renderizados (no descritos)
2. Brand essence: archetype + promise + positioning en layout editorial
3. Voice & Tone: attributes + do/don'ts con sample copy rendered
4. Palette: swatches reales con HEX + usage rules + contrast matrix
5. Typography: specimens en fonts reales (heading + body + mono)
6. Logo: variants displayed + clearspace + usage
7. Mood & atmosphere: mood imagery refs (si Unsplash refs disponibles) o descripción textual
8. Visual principles: aplicados visualmente, no solo descritos
9. Copy library samples: hero, tagline, CTAs rendered
10. Scope & limitations: transparencia de qué incluye / excluye
11. Appendix: evidence trace, versioning

**Meta-branding**: el PDF usa la propia brand (logo en header, palette como accents, typography embedded). Este es el principio "brand book aplicado" que hace que Claude Design infiera mejor.

### Paso 3 — Compilar Prompts Library Markdown

Genera `prompts-for-claude-design.md` con prompts específicos por scope. Ver [24-prompts-library-templates.md](./24-prompts-library-templates.md) para templates completos.

**Structure**:
```markdown
# Prompts for Claude Design — {Brand Name}

## How to use
1. Upload brand-design-document.pdf to Claude Design "Set up your design system"
2. Validate + publish the design system
3. Copy-paste prompts below into new Claude Design projects

## Design System Reference
[summary de palette HEX, typography, voice para referencia rápida en los prompts]

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

Cada prompt customizado al brand + scope manifest. El número de prompts incluidos depende de `scope.output_manifest.prompts_library.required + optional_recommended` (ver 02-scope-analysis.md).

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
    "background": { "value": "#F4EFE6", "type": "color" }
  },
  "font": {
    "heading": { "value": "Fraunces", "type": "fontFamily" }
  },
  "size": {},
  "spacing": {}
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
- Parse JSON → schema valid? Si no, regenerate
- Parse CSS → syntax valid? Si no, regenerate
- Parse Tailwind config as JS → valid? Si no, regenerate
- Parse HTML examples → parseable? Si no, regenerate
- Max 2 retries por file. Si persiste, flag `token_file_validation_failed: {file}` en envelope y continuar (el user puede revisar manually).

### Paso 5 — Assemble Reference Assets folder

Copiar + organizar:
- Logo SVGs (source + derivations del Depto Logo)
- Mood imagery refs (si scope lo incluye) — Unsplash URLs + attribution strings en markdown files
- Sample applications (si pre-generated)
- README.md explicando cada asset

### Paso 6 — Generar README.md del package

Estructura del README:

```markdown
# {Brand Name} — Brand Package

Generated by Hardcore Brand module · v1.0 · {date}
For use with: **Claude Design** (primary downstream)

> Claude Design requires Claude Pro, Max, Team, or Enterprise subscription.

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
2. Start "Set up your design system"
3. Upload `brand-design-document.pdf` from this folder
4. Claude Design reads it and extracts the design system

### Step 2 — Validate design system
1. Create a test project in Claude Design
2. Prompt: "Create a simple 1-page site for {Brand Name} using my brand"
3. Verify the output matches expectations

### Step 3 — Publish design system
1. In Claude Design settings, toggle "Published"
2. All future projects inherit this design system

### Step 4 — Use Prompts Library
1. Open `prompts-for-claude-design.md`
2. Copy-paste relevant prompts into Claude Design projects
3. Each prompt is pre-customized for your brand

### Step 5 — (Advanced) Link Brand Tokens
Si tenés un codebase existente:
1. Copiá `brand-tokens/` folder en tu repo
2. Importá tokens.css en tu main CSS
3. Linkeá tu codebase a Claude Design para automatic token extraction

### Step 6 — Deploy
Cada Claude Design project puede exportarse:
- HTML/CSS/Tailwind
- PPTX (para decks)
- PDF
- Handoff bundle → Claude Code → deployment

---

## What's included (per scope)

### Always
- brand-design-document.pdf (para Claude Design setup)
- prompts-for-claude-design.md (para Claude Design projects)
- brand-tokens/ (para codebase linking — optional)
- reference-assets/logo/ (SVG logos + derivations)
- README.md (este file)
- AUDIT.md (evidence trace + versioning)

### Your scope ({profile}) included
- {list dynamic de prompts y assets según scope.output_manifest}

### Not included (with reasons)
**Skipped by scope** (not relevant for your type of idea):
- {list de skipped con razones}

**Out of scope v1** (module limitation):
- Packaging 3D design
- Print CMYK-ready specs
- Motion design assets
- Sonic branding
- Real photography
- Ilustraciones orgánicas complejas (logo V1 emite geometric marks; orgánicos requieren iteración en Claude Design)

Para estos, considerar:
- Contratar specialists usando este brand book como brief
- Módulos futuros de Hardcore (Brand-Physical, Brand-Motion, Brand-Sonic)

---

## Disclaimers

- **Trademark screening preliminar**: TM checks via web search on USPTO TESS + WIPO Global Brand Database. No sustituye clearance legal. Consultá abogado de IP antes de registrar.
- **Brand book as living document**: regenerate cuando la idea evoluciona significativamente (`/brand:new` crea v2)
- **Claude Design dependency**: este package está optimizado para Claude Design (claude.ai/design). Funciona con otras design tools pero el valor se maximiza con Claude Design como downstream.

---

## Versioning

- Brand version: v1.0
- Generated: {timestamp}
- Idea slug: {slug}
- Validation ref: {validation snapshot ref}
- Profile ref: {profile snapshot ref si aplicable}

Commands:
- Partial regenerate: `/brand:extend {depto}`
- View history: `/brand:diff v1 v2`
- Full regenerate: `/brand:new`
- Resume interrupted: `/brand:resume`
```

### Paso 7 — Generar AUDIT.md

Full evidence trace del run. Ver [15-versioning-reproducibility.md](./15-versioning-reproducibility.md) para estructura completa.

Contiene:
- Timestamps de cada paso
- Validation + Profile refs (snapshots)
- Coherence gates trace (cuáles pasaron, cuáles fallaron, user decisions)
- Tool versions (de evidence_trace de cada dept)
- Outputs por dept con hashes
- Any flags raised (founder-voice-override-suppressed, decided_without_profile, etc.)

## 8.5 Package final — estructura

Ver [18-output-package-structure.md](./18-output-package-structure.md) para estructura completa dinámica por profile.

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
    ├── mood/ (si aplica)
    ├── samples/
    └── README.md
```

## 8.6 Tools

- **`ms-office-suite:pdf` skill** (Brand Design Document PDF)
- **File system ops** (assembly del package)
- **Claude native** (templating + README + prompt library customization)
- **Built-in validators** (JSON schema, CSS parser, HTML parser, SVG parser)

No usa image gen directo (esas generations suceden en Visual + Logo deptos).

## 8.7 Persistencia

- `brand/{slug}/handoff` en Engram (manifest del package + coherence trace)
- `brand/{slug}/final-report` en Engram (executive summary — entry point for módulos downstream futuros)
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
✓ reference-assets/mood/ (6 Unsplash refs con attribution)

Coherence gates: 9/9 passed

⚠ Disclaimers:
  • TM screening preliminar — consultá abogado de IP antes de registrar
  • Brand book funciona mejor con Claude Design (Pro+); otras tools son posibles

---

Next steps:
1. Abrir README.md para instructions
2. Ir a claude.ai/design (requires Claude Pro/Max/Team/Enterprise)
3. Upload brand-design-document.pdf en "Set up your design system"
4. Validar + publicar design system
5. Usar prompts del Library en proyectos específicos de Claude Design

Time elapsed: 18m 42s
External API cost: $0.00
```

Si el user no tiene Claude Pro (pre-flight debería haber bloqueado, pero fallback si llegó hasta acá), el reveal agrega:

```
⚠ Claude Design requires subscription (Pro, Max, Team, or Enterprise).
   Este package está optimizado para Claude Design. Upgrade en claude.ai/upgrade.
```

## 8.9 Relación con otros deptos

Handoff Compiler es **terminal** — no alimenta otros deptos del módulo Brand.

**Provee a módulos futuros** (Launch, GTM, Ops):
- `brand/{slug}/final-report` (entry point canónico)
- `brand/{slug}/handoff` (manifest)
- Filesystem artifacts

Downstream inmediato: **Claude Design** (user-mediated handoff en v1, automated cuando Anthropic ship API/MCP).

## 8.10 Failure modes específicos

### PDF generation falla
Retry. Fallback: deliver package sin PDF, entregar `brand-design-document.md` (markdown) + instrucciones de conversión manual. Flag: `pdf_conversion_failed: true`.

### Token file validation falla persistently
Flag `token_file_validation_failed: {file}`. Max 2 retries. Incluir file con warning en README.

### Coherence gate falla
Fail-fast — surface al user (ver [09-coherence-model.md](./09-coherence-model.md)).

### Filesystem issues (permissions, disk)
Clear error message al user. Preserve state en Engram para resume con `/brand:resume`.

### User cancela mid-compilation
Persist state con `status: "partial"` en `brand/{slug}/handoff`. Resume via `/brand:resume` recupera desde el último paso.

### Claude Pro no detectado en reveal (pre-flight falló silenciosamente)
Package se entrega con warning prominente en README y reveal. No bloquea la entrega — el user puede usarlo con otras design tools a su criterio.

## 8.11 Archivos a escribir en Sprint 0

Para este depto:
- `skills/brand/handoff-compiler/SKILL.md` — los 7 pasos detallados. **Incluye inline**: README template completo, AUDIT format, package structure per brand_profile, Claude Pro pre-flight check behavior, fail-fast gate behavior
- `skills/brand/handoff-compiler/references/data-schema.md`
- `skills/brand/handoff-compiler/references/brand-document-template.md` — structure del PDF por profile (page ranges + layouts + iteration history)
- `skills/brand/handoff-compiler/references/prompts-library-templates.md` — templates de prompts per scope (el file más grande del módulo; ver 24-prompts-library-templates.md)
- `skills/brand/handoff-compiler/references/tokens-templates.md` — templates de tokens.css / tokens.json / tailwind.config.js / fonts.css / button.html / card.html / hero.html, todos en un solo file con secciones claramente delimitadas

La matriz de coherence criticality per profile vive en `skills/brand/references/coherence-rules.md` (a nivel orchestrator, consumida por Handoff Compiler y otros).

## 8.13 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Package completo se genera correctamente para cada brand profile de testing scope (3 profiles en dogfooding inicial)
2. Brand Design Document PDF renderea + es subible a Claude Design (validar manualmente al menos 1 run)
3. Prompts Library markdown válido + prompts customizados al brand
4. Brand Tokens: JSON/CSS/Tailwind/HTML valid + functional
5. Reference Assets folder estructurado correctamente
6. Coherence gates detectan incoherencias y halt con options al user (fail-fast)
7. User re-corre dept responsible → gates re-evalúan desde cero, pass consistent
8. README.md refleja accurately lo incluido + excluido según scope
9. Validation: tokens files parseables
10. Filesystem write permissions handled
11. End-to-end: upload PDF a Claude Design → design system extracted correctly (validación manual)
12. PDF conversion failure → markdown fallback entregado correctamente
13. User cancela mid-run → `/brand:resume` recupera desde último paso

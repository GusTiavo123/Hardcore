# 18 — Estructura del Output Package

## 18.1 Propósito

Estructura del **paquete entregable** — los 4 deliverables optimizados para Claude Design.

El paquete es autoexplicativo, completo, usable sin instrucciones externas.

## 18.2 Ubicación

```
{repo-root}/output/{idea-slug}/brand/
```

Dentro del repo (consistente con patterns existentes).

## 18.3 Invariantes (siempre presentes)

Independiente de scope/tier, SIEMPRE:

```
output/{idea-slug}/brand/
├── README.md                               ← Always — instructions para Claude Design
├── AUDIT.md                                ← Always — evidence + versioning + cost tracking
├── brand-design-document.pdf               ← Always — DELIVERABLE 1 (Claude Design upload)
├── prompts-for-claude-design.md            ← Always — DELIVERABLE 2 (Claude Design prompts)
├── brand-tokens/                           ← Always — DELIVERABLE 3 (codebase integration)
│   ├── tokens.css
│   ├── tokens.json
│   ├── tailwind.config.js
│   ├── fonts.css
│   ├── README.md
│   └── examples/
│       ├── button.html
│       ├── card.html
│       └── hero.html
└── reference-assets/                       ← Always — DELIVERABLE 4 (visual refs)
    ├── logo/
    │   ├── primary.svg
    │   ├── primary.png (800px rasterized)
    │   ├── mono.svg
    │   ├── inverse.svg
    │   ├── icon-only.svg
    │   └── derivations/
    │       ├── favicon-16.png
    │       ├── favicon-32.png
    │       ├── favicon-48.png
    │       ├── favicon.ico
    │       ├── apple-touch-180.png
    │       ├── og-card-1200x630.png
    │       └── profile-pic-400.png
    └── README.md
```

## 18.4 Elementos dinámicos — según scope + tier

### Brand Design Document PDF — sections dinámicas

Siempre tiene:
- Cover
- Brand essence (archetype + positioning + values)
- Voice & tone
- Palette
- Typography
- Logo section
- Visual principles
- Copy library samples
- Scope declaration + limitations

Tier 1+ añade:
- Mood & atmosphere section con imagery grid (Unsplash Tier 1, Recraft Tier 2)

Scope-dependent sections:
- **b2d-devtool**: Developer aesthetic preview page (code snippet styling, CLI colors)
- **b2local-service**: Print applications preview (flyer mockup, business card)
- **content-media**: Content application preview (podcast cover mock, thumbnail series)
- **community-movement**: Symbolic assets preview (emblem variations, merch direction)
- **b2c-consumer-app**: App icon showcase + screenshot templates preview

Detallado en [24-brand-design-document-structure.md](./24-brand-design-document-structure.md).

### Prompts Library Markdown — dinámica per scope

Structure fija:
```markdown
# Prompts for Claude Design — {Brand Name}

## How to use
[Instructions]

## Design System Reference
[Quick reference palette + typography + voice]

## Project prompts

### {Deliverable 1}
Prompt: ...

### {Deliverable 2}
Prompt: ...
...
```

Cada prompt customizado al brand (name, palette HEX, typography, voice) + formato Claude Design best-practice (goal + layout + content + audience).

Prompts que se incluyen según scope — ver matriz en [03-brand-profiles.md](./03-brand-profiles.md#311-cross-profile---output-matrix-summary).

Templates detallados en [25-prompts-library-templates.md](./25-prompts-library-templates.md).

### Brand Tokens — contenido constante, valores dinámicos

Structure siempre igual. Valores (HEX, font names, spacing) customized desde outputs de Visual + Logo.

### Reference Assets — adicionales dinámicos

**Base (siempre)**:
```
reference-assets/
├── logo/
└── README.md
```

**Tier 1+ añade**:
```
reference-assets/
├── mood/
│   ├── mood-01-energy.{png|jpg}
│   ├── mood-02-texture.png
│   ├── ... (6-8 total)
│   └── README.md (con attribution si Unsplash)
```

**Scope-dependent añade** (cuando applicable):

#### If `b2c-consumer-app` (Tier 1+ auto-elevated)
```
reference-assets/
├── app-icons/
│   ├── ios/ (multiple sizes 20, 29, 40, 58, 60, 80, 87, 120, 180, 1024)
│   └── android/ (foreground.svg, background.svg, adaptive-icon.png, masks)
```

#### If `b2local-service`
```
reference-assets/
├── print-templates/
│   ├── flyer-template.pdf
│   ├── business-card.pdf
│   └── menu-template.pdf (si food)
```

#### If `community-movement` or `content-media`
```
reference-assets/
├── merch-direction/
│   ├── tshirt-layout.pdf
│   ├── sticker-designs.svg
│   └── README.md
```

## 18.5 Estructura completa (maximum)

Para context, mostrando TODA la estructura posible (solo para b2c-consumer-app Tier 2 con max features):

```
output/{slug}/brand/
├── README.md
├── AUDIT.md
├── brand-design-document.pdf
├── prompts-for-claude-design.md
├── brand-tokens/
│   ├── tokens.css
│   ├── tokens.json
│   ├── tailwind.config.js
│   ├── fonts.css
│   ├── README.md
│   └── examples/
│       ├── button.html
│       ├── card.html
│       └── hero.html
└── reference-assets/
    ├── logo/
    │   ├── primary.svg
    │   ├── primary.png
    │   ├── mono.svg
    │   ├── inverse.svg
    │   ├── icon-only.svg
    │   └── derivations/
    │       ├── favicon-16.png
    │       ├── favicon-32.png
    │       ├── favicon-48.png
    │       ├── favicon.ico
    │       ├── apple-touch-180.png
    │       ├── og-card-1200x630.png
    │       └── profile-pic-400.png
    ├── mood/                          # Tier 1+
    │   ├── mood-01-energy.png
    │   ├── mood-02-texture.png
    │   ├── mood-03-composition.png
    │   ├── mood-04-light.png
    │   ├── mood-05-motion.png
    │   ├── mood-06-focus.png
    │   └── README.md
    ├── app-icons/                     # b2c-consumer-app only
    │   ├── ios/
    │   │   ├── icon-20.png
    │   │   ├── icon-29.png
    │   │   ├── icon-40.png
    │   │   ├── icon-60.png
    │   │   ├── icon-80.png
    │   │   ├── icon-120.png
    │   │   ├── icon-180.png
    │   │   └── icon-1024.png
    │   └── android/
    │       ├── foreground.svg
    │       ├── background.svg
    │       ├── adaptive-icon.png
    │       └── launcher-masks/
    └── README.md
```

## 18.6 README.md del package — estructura

Ver template detallado en [08-dept-handoff-compiler.md](./08-dept-handoff-compiler.md#66-paso-6-generar-readme-del-package).

Resumen sections:
- Identity summary (name, archetype, profile, tier used)
- Scope identified + confidence
- **Step-by-step Claude Design workflow** (critical para user)
- Lo que SÍ incluye (por category + deliverable)
- Lo que NO incluye (skipped + out-of-scope con reasons)
- How to use each deliverable
- Disclaimers
- Versioning info

## 18.7 AUDIT.md — estructura

Ver detalles en [15-versioning-reproducibility.md](./15-versioning-reproducibility.md#audit-log).

Summary sections:
- Run metadata (ID, version, mode, tier, duration)
- Tool versions
- Input hashes
- Decisions made per dept
- Coherence trace (8 gates)
- Failures encountered
- Cost tracking
- User interactions
- Claude Design integration status

## 18.8 Entregables por scope × tier — cuadro resumen

| Scope | Tier 0 base | Tier 1 adds | Tier 2 adds |
|---|---|---|---|
| `b2b-enterprise` | 4 deliverables + logo wordmark SVG | Mood refs (Unsplash) | Mood generated + Recraft wordmark |
| `b2b-smb` | 4 deliverables + logo wordmark | Mood refs | Mood generated |
| `b2d-devtool` | 4 deliverables + wordmark; symbolic NOT recommended | Recraft symbolic + mood | All Recraft |
| `b2c-consumer-app` | **Not recommended** (elevates to T1) | **Default** — App icons + Recraft symbolic | App icons + full Recraft + mood generated |
| `b2c-consumer-web` | 4 deliverables + combination logo | Mood refs | Mood generated |
| `b2local-service` | 4 deliverables + combination + printable templates | Mood refs | Mood generated + premium printables |
| `content-media` | 4 deliverables + symbolic (limited Tier 0 quality) | Recraft symbolic + mood + podcast cover quality | Full premium |
| `community-movement` | 4 deliverables + symbolic (limited Tier 0) | Recraft symbolic + merch direction | Full premium |

## 18.9 Cross-references en el package

Algunos assets aparecen con references cruzadas:
- Logo SVG primary: `reference-assets/logo/primary.svg` (canonical) referenced from `brand-design-document.pdf` (embedded) + `brand-tokens/examples/*.html` (linked) + `README.md` (mentioned)
- Palette HEX: `brand-tokens/tokens.json` (source of truth) + `tokens.css` (CSS version) + `tailwind.config.js` (Tailwind version) + referenced in Brand Document PDF palette section + each prompt in Prompts Library

Todos los duplicates son copies/references, no symlinks, para portabilidad (user zip + send, no broken links).

## 18.10 Deployability

Package es **immediately usable**:

### Via Claude Design workflow
```
1. Abrir claude.ai/design
2. Design system setup → Upload brand-design-document.pdf
3. Validate + publish
4. Copy prompts from prompts-for-claude-design.md
5. Run in Claude Design projects
6. Export from Claude Design → Claude Code → deploy
```

### Via codebase integration (advanced)
```
1. Copy brand-tokens/ folder to your repo
2. Import tokens.css in main CSS
3. Link codebase to Claude Design
4. Claude Design auto-extracts design system
5. Use prompts from Library
```

### Via manual use (no Claude Design)
```
1. Use brand-design-document.pdf as brief for human designer
2. Use Reference Assets (logo SVGs) directly in design tools
3. Use Brand Tokens in your own code
4. Copy prompts from Library as guidance (adapt to other AI tools)
```

## 18.11 README template específico (excerpt)

Ver [08-dept-handoff-compiler.md](./08-dept-handoff-compiler.md#66) para template completo.

Elementos clave:

```markdown
# {Brand Name} — Brand Package

Generated by Hardcore Brand module · v1.0 · {date}
For use with: **Claude Design** (primary downstream)

## Quick start

1. **Use with Claude Design** (recommended):
   - Go to claude.ai/design
   - Upload `brand-design-document.pdf` to design system setup
   - Use prompts from `prompts-for-claude-design.md` in projects
   
2. **Use tokens in codebase**:
   ```bash
   cp -r brand-tokens/ your-repo/
   ```
   
3. **Use assets directly**:
   - Logo SVGs: `reference-assets/logo/*.svg`
   - Reference images: `reference-assets/mood/` (if tier ≥ 1)

## Directory guide

[...]

## Scope

Classified as: **{profile}** (confidence {%})
Tier used: {N} (cost: ${amount})

Package optimized for:
- [characteristics based on scope]

## What's included vs not

[...]

## Disclaimers

[...]
```

## 18.12 Testing del package structure

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Package structure correcta por brand profile + tier
2. README lista accurately lo incluido y excluido
3. All invariants present
4. Brand Design Document PDF opens + uploadable to Claude Design
5. Prompts Library markdown valid + prompts customized
6. Brand Tokens parseable (JSON schema, CSS syntax, Tailwind config valid)
7. SVGs editable en vector editors
8. Tier 0 package smaller than Tier 1 (no mood folder)
9. b2c-consumer-app package has app-icons folder (Tier 1+)
10. b2local-service package has print-templates folder

# 18 — Estructura del Output Package

## 18.1 Propósito

Estructura del **paquete entregable** — los 4 deliverables optimizados para Claude Design.

El paquete es autoexplicativo, completo, usable sin instrucciones externas.

## 18.2 Ubicación

```
{repo-root}/output/{idea-slug}/brand/
```

Dentro del repo del user (consistente con patterns existentes de Validation y Profile).

## 18.3 Invariantes (siempre presentes)

Independiente de scope, SIEMPRE:

```
output/{idea-slug}/brand/
├── README.md                               ← Always — instructions para Claude Design
├── AUDIT.md                                ← Always — evidence + versioning
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
    │   ├── primary.png (800px rasterized si rasterization tool disponible)
    │   ├── mono.svg
    │   ├── inverse.svg
    │   ├── icon-only.svg (si aplica al form chosen)
    │   └── derivations/
    │       ├── favicon-16.svg (+png)
    │       ├── favicon-32.svg (+png)
    │       ├── favicon-48.svg (+png)
    │       ├── favicon.ico (si rasterization tool disponible)
    │       ├── apple-touch-180.svg (+png)
    │       ├── og-card-1200x630.svg (+png)
    │       └── profile-pic-400.svg (+png)
    └── README.md
```

Nota: PNG/ICO generations requieren rasterization tool (headless chromium o rsvg-convert). Si no está disponible, entregamos SVG-only con instrucciones manuales en el README (ver [07-dept-logo.md](./07-dept-logo.md)).

## 18.4 Elementos dinámicos — según scope

### Brand Design Document PDF — sections dinámicas

Siempre tiene:
- Cover con logo + brand name
- Brand essence (archetype + positioning + values)
- Voice & tone
- Palette
- Typography
- Logo section
- Visual principles
- Copy library samples
- Scope declaration + limitations
- Appendix (evidence trace, versioning)

Si scope incluye mood imagery (profiles que lo benefician — ver sección 18.8 abajo), se agrega:
- Mood & atmosphere section con Unsplash refs (URL + attribution strings) y prosa que describe el mood

Scope-dependent sections (siempre condicionales):
- **b2d-devtool**: Developer aesthetic preview page (code snippet styling, CLI colors)
- **b2local-service**: Print applications preview (flyer mockup, business card)
- **content-media**: Content application preview (podcast cover mock, thumbnail series)
- **community-movement**: Symbolic assets preview (emblem variations, merch direction)
- **b2c-consumer-app**: App icon showcase + screenshot templates preview

Page range varía por profile (ver [23-brand-design-document-structure.md](./23-brand-design-document-structure.md) para spec por profile).

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
```

Cada prompt customizado al brand (name, palette HEX, typography, voice) + formato Claude Design best-practice (goal + layout + content + audience).

Los prompts que se incluyen dependen del `scope.output_manifest.prompts_library.required + optional_recommended` — ver matriz en [03-brand-profiles.md](./03-brand-profiles.md).

Templates detallados en [24-prompts-library-templates.md](./24-prompts-library-templates.md).

### Brand Tokens — contenido constante, valores dinámicos

Structure siempre igual. Valores (HEX, font names, spacing) customized desde outputs de Visual + Logo.

### Reference Assets — adicionales dinámicos

**Base (siempre)**:
```
reference-assets/
├── logo/
└── README.md
```

**Si el scope incluye mood imagery** (profiles que lo benefician):
```
reference-assets/
└── mood/
    ├── mood-01-{theme}.md    # Archivo con URL Unsplash + attribution + descripción del mood que inspira
    ├── mood-02-{theme}.md
    ├── ... (3-6 total según scope)
    └── README.md
```

Los archivos `mood-XX-*.md` contienen metadata (no imágenes descargadas localmente). Esto evita binarios pesados y respeta ToS de Unsplash (attribution requerido, preferible linkear que downloadar). El user o Claude Design pueden fetchar las imágenes desde los URLs según necesidad.

**Scope-dependent añade** (cuando applicable):

#### Si `b2c-consumer-app` con `app_asset_criticality: primary`
```
reference-assets/
└── app-icons/
    ├── ios/
    │   ├── icon-20.svg (+png si rasterization disponible)
    │   ├── icon-29.svg (+png)
    │   ├── icon-40.svg (+png)
    │   ├── icon-60.svg (+png)
    │   ├── icon-80.svg (+png)
    │   ├── icon-120.svg (+png)
    │   ├── icon-180.svg (+png)
    │   └── icon-1024.svg (+png)
    └── android/
        ├── foreground.svg
        ├── background.svg
        ├── adaptive-icon.svg (+png)
        └── launcher-masks/
            ├── circle.svg
            ├── rounded.svg
            └── squircle.svg
```

#### Si `b2local-service`
```
reference-assets/
└── print-templates/
    ├── flyer-template.svg (+pdf)
    ├── business-card.svg (+pdf)
    └── menu-template.svg (+pdf) # si es food service
```

Nota: para generar PDFs de templates de print, Handoff Compiler usa `ms-office-suite:pdf` skill. Si falla, entrega los SVGs con instrucciones manuales.

#### Si `community-movement` o `content-media`
```
reference-assets/
└── merch-direction/
    ├── tshirt-layout.svg
    ├── sticker-designs.svg
    └── README.md
```

## 18.5 Estructura completa (maximum example)

Ejemplo con todas las features activas (b2c-consumer-app con mood refs y full app icon set):

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
    │       ├── favicon-16.svg (+png)
    │       ├── favicon-32.svg (+png)
    │       ├── favicon-48.svg (+png)
    │       ├── favicon.ico
    │       ├── apple-touch-180.svg (+png)
    │       ├── og-card-1200x630.svg (+png)
    │       └── profile-pic-400.svg (+png)
    ├── mood/
    │   ├── mood-01-energy.md
    │   ├── mood-02-texture.md
    │   ├── mood-03-composition.md
    │   ├── mood-04-light.md
    │   ├── mood-05-motion.md
    │   ├── mood-06-focus.md
    │   └── README.md
    ├── app-icons/
    │   ├── ios/
    │   │   ├── icon-20.svg
    │   │   ├── icon-29.svg
    │   │   ├── icon-40.svg
    │   │   ├── icon-60.svg
    │   │   ├── icon-80.svg
    │   │   ├── icon-120.svg
    │   │   ├── icon-180.svg
    │   │   └── icon-1024.svg
    │   └── android/
    │       ├── foreground.svg
    │       ├── background.svg
    │       ├── adaptive-icon.svg
    │       └── launcher-masks/
    │           ├── circle.svg
    │           ├── rounded.svg
    │           └── squircle.svg
    └── README.md
```

## 18.6 README.md del package — estructura

Ver template detallado en [08-dept-handoff-compiler.md](./08-dept-handoff-compiler.md) (Paso 6).

Resumen de secciones:
- Identity summary (name, archetype, profile)
- Scope identified + confidence
- Claude Pro subscription requirement (critical)
- **Step-by-step Claude Design workflow**
- Lo que SÍ incluye (por category + deliverable)
- Lo que NO incluye (skipped + out-of-scope con reasons)
- How to use each deliverable
- Disclaimers (TM screening preliminar, Claude Design dependency)
- Versioning info + comandos disponibles

## 18.7 AUDIT.md — estructura

Ver detalles en [15-versioning-reproducibility.md](./15-versioning-reproducibility.md).

Secciones:
- Run metadata (ID, version, mode, duration)
- Tool versions usadas
- Input hashes (validation snapshot, profile snapshot)
- Decisions made per dept
- Coherence trace (9 gates) con user decisions si aplica
- Failures encountered (soft failures con flags)
- User interactions (qué se preguntó, qué eligió el user)
- Claude Design integration status (post-delivery si el user reporta)

## 18.8 Entregables por scope — matriz

Todos los profiles reciben los 4 deliverables base. Las diferencias son qué prompts se incluyen en la Library, qué secciones tiene el Brand Document, y qué assets adicionales hay en Reference Assets:

| Scope | Brand Doc extras | Mood refs incluidos | Logo form bias | Asset folders extras |
|---|---|---|---|---|
| `b2b-enterprise` | Security section, pitch deck preview | Opcional (baja prioridad) | wordmark | — |
| `b2b-smb` | Pricing page preview | Opcional | wordmark | — |
| `b2d-devtool` | Developer aesthetic preview, code snippet styling | Opcional | combination o geometric | — |
| `b2c-consumer-app` | App icon showcase, onboarding screens preview | Recomendado | geometric (icon-first) | `app-icons/` si `app_asset_criticality: primary` |
| `b2c-consumer-web` | Social grid preview, referral preview | Recomendado | combination o geometric | — |
| `b2local-service` | Print applications preview | Opcional | combination | `print-templates/` |
| `content-media` | Podcast cover + thumbnail preview | Recomendado | geometric o wordmark | `merch-direction/` (opcional) |
| `community-movement` | Symbolic assets preview, manifesto page | Recomendado | symbolic-geometric | `merch-direction/` |

"Mood refs" siempre via Unsplash free API con attribution. Skippable si Unsplash API está down (soft failure).

## 18.9 Cross-references en el package

Algunos assets aparecen con referencias cruzadas:
- **Logo SVG primary**: `reference-assets/logo/primary.svg` (canonical) + embedded en `brand-design-document.pdf` + referenced en `brand-tokens/examples/*.html` + mencionado en `README.md`
- **Palette HEX**: `brand-tokens/tokens.json` (source of truth DTCG format) + `tokens.css` (CSS version) + `tailwind.config.js` (Tailwind) + referenced en Brand Document palette section + inyectado en cada prompt de la Prompts Library

Todos los duplicates son copies/references, no symlinks, para portabilidad (user zip + send sin broken links).

## 18.10 Deployability

Package es **immediately usable**. Tres paths posibles para el user:

### Path primario: Claude Design workflow (recomendado)
```
1. Abrir claude.ai/design (requires Claude Pro / Max / Team / Enterprise)
2. "Set up your design system" → Upload brand-design-document.pdf
3. Validate con test project
4. Publish el design system
5. Copy prompts from prompts-for-claude-design.md en projects
6. Export desde Claude Design → Claude Code → deploy
```

### Path avanzado: codebase integration
```
1. Copy brand-tokens/ folder a tu repo
2. Import tokens.css en tu main CSS
3. Link codebase a Claude Design (si tenés Pro+)
4. Claude Design auto-extrae design system desde el código
5. Use prompts from Library
```

### Path alternativo: manual (fuera de Claude Design)
```
1. Usar brand-design-document.pdf como brief para human designer
2. Usar Reference Assets (logo SVGs) directamente en Figma, Illustrator, etc.
3. Usar Brand Tokens en tu propio código
4. Copy prompts from Library como guidance (adaptar a otras AI tools)
```

El package está optimizado para el path primario (Claude Design) — si el user no tiene Pro+, el pre-flight del orchestrator bloquea el run (ver 08 y 13). Pero si de algún modo el package termina en manos de alguien sin Claude Design, es usable manualmente.

## 18.11 Testing del package structure

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Package structure correcta por brand profile
2. README lista accurately lo incluido y excluido
3. Todos los invariants presentes
4. Brand Design Document PDF opens + uploadable a Claude Design
5. Prompts Library markdown valid + prompts customizados al brand
6. Brand Tokens parseable (JSON schema DTCG, CSS syntax, Tailwind config valid, HTML parseable)
7. SVGs editables en vector editors
8. `b2c-consumer-app` con `app_asset_criticality: primary` → package tiene `app-icons/` folder
9. `b2local-service` package tiene `print-templates/` folder
10. Profiles con mood refs → `mood/` folder con al menos 3 entries cuando Unsplash está up
11. Unsplash down → package estructura intacta, no `mood/` folder, flag registrado
12. Rasterization tool down → solo SVGs, instrucciones manuales en el README

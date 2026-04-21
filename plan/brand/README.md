# Plan — Módulo Brand & Identity

**Branch**: `feat/hc-brand`
**Estado**: Planning — Sprint 0 pendiente

Plan completo del módulo Brand de Hardcore — tercer módulo del ecosistema (después de Validation y Profile).

---

## Qué es el módulo

Brand produce el brief óptimo + prompts + tokens + assets para que **Claude Design** ejecute la identidad visual de una idea validada. Hardcore aporta el upstream (strategy reasoning, naming con verification, brand tokens, assets curated) con contexto founder-specific + evidence-based que ningún otro workflow tiene. Claude Design ejecuta el downstream (UI generation, mockups aplicados).

**Vision en una frase**: *"Brand intelligence layer para Claude Design"*.

---

## Arquitectura

5 departamentos coordinados por un orchestrator + Scope Analysis inline como Paso 0:

1. **Strategy** — archetype Jung + voice + positioning + values + promise
2. **Verbal Identity** — naming con domain+trademark verification + core copy
3. **Visual System** — palette + typography + mood
4. **Logo & Key Visuals** — SVG logos via Claude native (Tier 0) o Recraft V4 (Tier 1+)
5. **Handoff Compiler** — compila 4 deliverables para Claude Design + enforza 8 coherence gates

Output del módulo = 4 deliverables:
- Brand Design Document PDF (para design system setup de Claude Design)
- Prompts Library Markdown (prompts customizados para Claude Design projects)
- Brand Tokens folder (CSS + JSON + Tailwind, para codebase linking)
- Reference Assets folder (logos SVG + mood imagery + samples)

---

## Cómo usar este plan

Leer en orden si primera lectura. Para iteraciones, directo al archivo correspondiente. Cada archivo self-contained con referencias cruzadas.

**Cambios al plan**:
1. Editar archivo correspondiente
2. Actualizar referencias cruzadas si aplica
3. Commit a `feat/hc-brand`
4. Cuando plan aprobado completo: arrancar Sprint 0 (implementación)

---

## Índice

### Fundamentos
- [01-overview-and-architecture.md](./01-overview-and-architecture.md) — Qué es Brand, posicionamiento, arquitectura
- [02-scope-analysis.md](./02-scope-analysis.md) — Paso 0: clasificación + manifest
- [03-brand-profiles.md](./03-brand-profiles.md) — 8 brand profiles canónicos

### Departamentos
- [04-dept-strategy.md](./04-dept-strategy.md) — Strategy (archetype, voice, positioning)
- [05-dept-verbal.md](./05-dept-verbal.md) — Verbal Identity (naming + core copy)
- [06-dept-visual.md](./06-dept-visual.md) — Visual System (palette, typography, mood)
- [07-dept-logo.md](./07-dept-logo.md) — Logo & Key Visuals (tier-based)
- [08-dept-handoff-compiler.md](./08-dept-handoff-compiler.md) — Handoff Compiler (4 deliverables)

### Sistemas cross-cutting
- [09-coherence-model.md](./09-coherence-model.md) — 8 gates de coherencia + criticality per profile
- [10-persistence-and-contracts.md](./10-persistence-and-contracts.md) — Engram + brand-contract
- [11-tools-stack.md](./11-tools-stack.md) — MCPs + APIs por tier
- [12-modes-and-interactions.md](./12-modes-and-interactions.md) — Modos + puntos de interacción

### Calidad y robustez
- [13-failure-modes.md](./13-failure-modes.md) — Failures + fallbacks
- [14-testing-strategy.md](./14-testing-strategy.md) — Unit + coherence + integration + Claude Design compatibility
- [15-versioning-reproducibility.md](./15-versioning-reproducibility.md) — Snapshots + diff + rollback

### Entregables y limitaciones
- [16-v1-limitations.md](./16-v1-limitations.md) — Qué v1 NO cubre
- [17-cost-and-timing.md](./17-cost-and-timing.md) — Tier 0/1/2 cost + timing per profile
- [18-output-package-structure.md](./18-output-package-structure.md) — Estructura de los 4 deliverables

### Integración y organización
- [19-edge-cases.md](./19-edge-cases.md) — Edge cases handling
- [20-ecosystem-integration.md](./20-ecosystem-integration.md) — Validation + Profile upstream, Claude Design downstream
- [21-file-structure.md](./21-file-structure.md) — Estructura de archivos del módulo
- [22-open-decisions.md](./22-open-decisions.md) — Decisiones pendientes antes de Sprint 0

### Specs detallados de deliverables
- [23-brand-design-document-structure.md](./23-brand-design-document-structure.md) — Spec del PDF para Claude Design
- [24-prompts-library-templates.md](./24-prompts-library-templates.md) — Templates de prompts para Claude Design

---

## Decisiones arquitectónicas del plan

- **5 departamentos** (Strategy + Verbal + Visual + Logo + Handoff Compiler)
- **Scope Analysis como Paso 0** inline en orchestrator
- **Stack**: Engram + Claude native + Recraft V4 (Tier 1+) + Huemint (Tier 1+) + Unsplash (Tier 1) + Domain MCP + PDF skill
- **Image generation en tiers**: Tier 0 default ($0), Tier 1 (~$0.10-0.20), Tier 2 (~$0.40-0.80)
- **Claude Design como downstream primario** para UI generation
- **4 deliverables de output**: Brand Design Document PDF + Prompts Library + Brand Tokens + Reference Assets
- **8 coherence gates** con criticality matrix per profile
- **Post-validation only**: Brand bloqueado sin verdict GO/PIVOT (override disponible)
- **Profile opcional**: Brand funciona sin Profile con personalization parcial

---

## Decisiones abiertas

Pendientes antes de Sprint 0 — ver [22-open-decisions.md](./22-open-decisions.md):

1. Idioma output default
2. Brand Design Document PDF interactivo con links
3. Calibration scenarios para Brand (5 coherence scenarios)
4. Huemint commercial license (pre-launch blocker)
5. Tier elevation UX (auto vs always ask)
6. Error budget caps tier-specific
7. **Claude Design subscription handling en freemium** (Sprint 0 blocker)
8. Versioning de brand profiles roadmap v2

---

## Sprint 0

Cuando el plan esté aprobado, Sprint 0 consiste en escribir los SKILL.md reales + references del módulo (estructura en [21-file-structure.md](./21-file-structure.md)). No hay código ejecutable en Sprint 0 — solo specs.

Total archivos a crear en Sprint 0: **~55 archivos** (specs + references + testing protocol + config updates).

Estimated: **1-2 semanas** de escritura focalizada.

Sprint 1 es implementación + integración + dogfooding contra Hardcore mismo.

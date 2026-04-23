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

5 departamentos coordinados por un orchestrator, con Scope Analysis como primer sub-agent del pipeline:

1. **Scope Analysis** (Paso 0) — clasificación en 5 ejes + manifest de outputs
2. **Strategy** — archetype Jung + voice + positioning + values + sentiment_landscape derivada
3. **Verbal Identity** — naming con domain + trademark verification + core copy
4. **Visual System** — palette + typography + mood refs
5. **Logo & Key Visuals** — SVG logos vía Claude native (wordmark / combination / geometric-symbolic)
6. **Handoff Compiler** — compila 4 deliverables para Claude Design + enforza 9 coherence gates (fail-fast)

Output del módulo = 4 deliverables:
- Brand Design Document PDF (para design system setup de Claude Design)
- Prompts Library Markdown (prompts customizados para Claude Design projects)
- Brand Tokens folder (CSS + JSON + Tailwind, para codebase linking)
- Reference Assets folder (logos SVG + mood refs Unsplash con attribution)

---

## Cómo usar este plan

Leer en orden si es primera lectura. Para iteraciones, ir directo al archivo correspondiente. Cada archivo self-contained con referencias cruzadas.

**Cambios al plan**:
1. Editar archivo correspondiente
2. Actualizar referencias cruzadas si aplica
3. Commit a `feat/hc-brand`
4. Cuando plan esté aprobado completo: arrancar Sprint 0 (implementación)

---

## Índice

### Fundamentos
- [01-overview-and-architecture.md](./01-overview-and-architecture.md) — Qué es Brand, posicionamiento, arquitectura
- [02-scope-analysis.md](./02-scope-analysis.md) — Paso 0: clasificación + manifest
- [03-brand-profiles.md](./03-brand-profiles.md) — 8 brand profiles canónicos

### Departamentos
- [04-dept-strategy.md](./04-dept-strategy.md) — Strategy (archetype, voice, positioning, sentiment)
- [05-dept-verbal.md](./05-dept-verbal.md) — Verbal Identity (naming + core copy)
- [06-dept-visual.md](./06-dept-visual.md) — Visual System (palette, typography, mood refs)
- [07-dept-logo.md](./07-dept-logo.md) — Logo & Key Visuals (Claude native SVG)
- [08-dept-handoff-compiler.md](./08-dept-handoff-compiler.md) — Handoff Compiler (4 deliverables + 9 gates)

### Sistemas cross-cutting
- [09-coherence-model.md](./09-coherence-model.md) — 9 gates (incluyendo G0 archetype-market-fit) + fail-fast
- [10-persistence-and-contracts.md](./10-persistence-and-contracts.md) — Engram + brand-contract
- [11-tools-stack.md](./11-tools-stack.md) — Stack 100% gratis (Engram, open-websearch, Domain MCP, Unsplash free, PDF skill, Claude native)
- [12-modes-and-interactions.md](./12-modes-and-interactions.md) — Modos + puntos de interacción

### Calidad y robustez
- [13-failure-modes.md](./13-failure-modes.md) — Hard vs soft failures + fallbacks
- [14-testing-strategy.md](./14-testing-strategy.md) — Structural + coherence + qualitative review (sin scores numéricos)
- [15-versioning-reproducibility.md](./15-versioning-reproducibility.md) — Snapshots + diff + rollback + reproducibility honesta

### Entregables y limitaciones
- [16-v1-limitations.md](./16-v1-limitations.md) — Qué v1 NO cubre
- [17-cost-and-timing.md](./17-cost-and-timing.md) — $0 en APIs externas + timing per profile
- [18-output-package-structure.md](./18-output-package-structure.md) — Estructura de los 4 deliverables

### Integración y organización
- [19-edge-cases.md](./19-edge-cases.md) — Edge cases handling
- [20-ecosystem-integration.md](./20-ecosystem-integration.md) — Validation + Profile upstream, Claude Design downstream
- [21-file-structure.md](./21-file-structure.md) — Estructura de archivos del módulo

### Specs detallados de deliverables
- [23-brand-design-document-structure.md](./23-brand-design-document-structure.md) — Spec del PDF para Claude Design
- [24-prompts-library-templates.md](./24-prompts-library-templates.md) — Templates de prompts para Claude Design

### Contrato de consumo
- `skills/_shared/brand-contract.md` — Cómo Brand consume Validation + Profile; cómo módulos futuros consumen Brand

---

## Decisiones arquitectónicas

- **5 departamentos + Scope Analysis**: Scope Analysis (sub-agent), Strategy, Verbal, Visual, Logo, Handoff Compiler
- **Scope Analysis como sub-agent** (mismo patrón que los otros deptos y que Validation) — consistencia del department-protocol
- **Stack 100% gratis**: Engram + Claude native + open-websearch + Domain MCP + Unsplash free + PDF skill
- **Claude Pro/Max/Team/Enterprise como gate obligatorio**: pre-flight halt si el user no tiene suscripción activa (Brand requiere Claude Design downstream, que requiere suscripción)
- **Claude Design como downstream primario** para UI generation (PDF + PPTX + codebase linking son los formats que acepta)
- **4 deliverables de output**: Brand Design Document PDF + Prompts Library Markdown + Brand Tokens + Reference Assets
- **9 coherence gates** (G0 = archetype ↔ market reality cross-module, G1-G8 = intra-Brand) con criticality matrix per profile
- **Fail-fast en coherence gates**: si una gate falla, el pipeline pausa y el user decide (re-run dept, accept with flag, abortar). Sin auto-retry cyclic.
- **Voice precedence**: archetype (primary) > scope.verbal_register (constraint de mercado) > profile preference (annotation, no override)
- **Post-validation only**: Brand bloqueado sin verdict GO/PIVOT (override explícito disponible con warning permanente)
- **Profile opcional**: Brand funciona sin Profile con personalization parcial. Threshold 0.4 en completeness.overall para modo full; debajo de 0.4 es partial.
- **Override allowlist**: `{archetype, brand_profile, voice_register, language, name, primary_color, output_manifest.include/exclude}`. Otros keys se rechazan con explicación.

---

## Sprint 0

Cuando el plan esté aprobado, Sprint 0 consiste en escribir los SKILL.md reales + references del módulo (estructura en [21-file-structure.md](./21-file-structure.md)). No hay código ejecutable en Sprint 0 — solo specs en markdown.

Total archivos a crear en Sprint 0: **~30 archivos** (23 specs en skills/brand/ + 1 shared + 5 testing + 2 config updates). Detalle completo en [21-file-structure.md](./21-file-structure.md).

`skills/_shared/brand-contract.md` ya fue escrito en esta pasada de planning.

Sprint 1 es implementación + dogfooding contra Hardcore mismo (brandear Hardcore y testear end-to-end con Claude Design).

# Plan — Módulo Brand & Identity

Este directorio contiene el plan completo del módulo Brand de Hardcore — tercer módulo del ecosistema (después de Validation y Profile). Cada archivo cubre un aspecto específico para permitir iteración focalizada sin tocar el resto del plan.

**Branch**: `feat/hc-brand`
**Estado**: Planning (Sprint 0 aún no empezado)
**Última actualización**: 2026-04-20

---

## Cómo usar este plan

Leer en orden si es primera lectura. Para iteraciones, ir directo al archivo correspondiente. Cada archivo es self-contained: tiene su propio contexto, referencias al resto, y decisiones justificadas.

**Para cambiar algo del plan**:
1. Editar el archivo correspondiente
2. Si el cambio afecta a otros archivos, actualizar las referencias cruzadas
3. Commit al branch `feat/hc-brand`
4. Cuando el plan esté aprobado completo, recién arrancar Sprint 0 (implementación)

---

## Índice de archivos

### Fundamentos
- [01-overview-and-architecture.md](./01-overview-and-architecture.md) — Qué es Brand, posicionamiento, arquitectura general, diagrama del pipeline
- [02-scope-analysis.md](./02-scope-analysis.md) — Paso 0: Scope Analysis (clasificación de idea + manifest)
- [03-brand-profiles.md](./03-brand-profiles.md) — Catálogo de los 8 brand profiles canónicos

### Departamentos
- [04-dept-strategy.md](./04-dept-strategy.md) — Depto 1: Strategy (archetype, voice, positioning)
- [05-dept-verbal.md](./05-dept-verbal.md) — Depto 2: Verbal Identity (naming + copy)
- [06-dept-visual.md](./06-dept-visual.md) — Depto 3: Visual System (palette, typography, mood)
- [07-dept-logo.md](./07-dept-logo.md) — Depto 4: Logo & Key Visuals
- [08-dept-activation.md](./08-dept-activation.md) — Depto 5: Activation (Stitch + packaging)

### Sistemas cross-cutting
- [09-coherence-model.md](./09-coherence-model.md) — Los 9 gates de coherencia entre deptos
- [10-persistence-and-contracts.md](./10-persistence-and-contracts.md) — Engram persistence + brand-contract.md para módulos futuros
- [11-tools-stack.md](./11-tools-stack.md) — MCPs, APIs, skills y justificación de cada uno
- [12-modes-and-interactions.md](./12-modes-and-interactions.md) — Modos normal/fast/extend/override + puntos de interacción con user

### Calidad y robustez
- [13-failure-modes.md](./13-failure-modes.md) — Failure modes + fallbacks por dept
- [14-testing-strategy.md](./14-testing-strategy.md) — Unit, coherence, integration, variance, regression tests
- [15-versioning-reproducibility.md](./15-versioning-reproducibility.md) — Snapshots, versioning, reproducibilidad

### Entregables y limitaciones
- [16-v1-limitations.md](./16-v1-limitations.md) — Qué v1 NO cubre (físicas, motion, sonic, print CMYK)
- [17-cost-and-timing.md](./17-cost-and-timing.md) — Costo por run + flow timing
- [18-output-package-structure.md](./18-output-package-structure.md) — Estructura del paquete entregable (dinámica por scope)

### Integración y organización
- [19-edge-cases.md](./19-edge-cases.md) — Brand sin profile, NO-GO override, ideas híbridas, re-runs
- [20-ecosystem-integration.md](./20-ecosystem-integration.md) — Cómo Brand se conecta con Validation, Profile, módulos futuros
- [21-file-structure.md](./21-file-structure.md) — Estructura de archivos del módulo en el repo
- [22-open-decisions.md](./22-open-decisions.md) — Decisiones pendientes antes de Sprint 0

---

## Decisiones ya tomadas (locked)

Estas no se re-abren en esta fase de planning a menos que haya razón nueva:

- **5 departamentos** (Strategy + Verbal + Visual + Logo + Activation)
- **Scope Analysis como Paso 0** (inline en orchestrator, no sub-agente)
- **Stack de tools**: Stitch MCP + Recraft V4 + Huemint + imprvhub domain MCP + open-websearch + existing pdf skill
- **Post-validation only**: Brand bloqueado sin verdict GO/PIVOT (override explícito disponible para NO-GO)
- **Opción B de Stitch**: full-send sin fallback arquitectónico
- **Profile opcional**: Brand funciona sin Profile (con personalización parcial)

---

## Decisiones abiertas (ver [22-open-decisions.md](./22-open-decisions.md))

Lista corta de lo que falta resolver antes de Sprint 0:
1. Idioma del output default
2. Hosting del microsite (incluimos `netlify.toml`?)
3. Font hosting (CDN vs offline)
4. Brand book interactivo (links clickeables en PDF)
5. Pitch deck: cover solo vs template completo
6. Calibration scenarios para Brand
7. Scope Analysis: inline vs sub-agente propio

---

## Sprint 0 (después de aprobación del plan)

Cuando el plan esté aprobado, Sprint 0 consiste en escribir los SKILL.md reales + references del módulo (estructura en [21-file-structure.md](./21-file-structure.md)). No hay código ejecutable en Sprint 0 — solo specs que implementan este plan.

Sprint 1 es implementación + integración + dogfooding contra Hardcore mismo.

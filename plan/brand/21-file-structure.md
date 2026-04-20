# 21 — Estructura de Archivos del Módulo

## 21.1 Propósito

Definir exactamente qué archivos se crean dónde en el repo durante Sprint 0 (specs) y Sprint 1 (implementación).

Sprint 0 crea specs + references. Sprint 1 lo conecta a la realidad via MCPs + testing.

## 21.2 Estructura general

```
hardcore/ (repo root)
│
├── CLAUDE.md                                   # UPDATE — agregar sección Brand
│
├── skills/
│   ├── _shared/                                # UPDATE — agregar brand-contract.md
│   │   ├── output-contract.md                  # existing, unchanged
│   │   ├── scoring-convention.md               # existing, unchanged (Validation)
│   │   ├── engram-convention.md                # existing, unchanged
│   │   ├── persistence-contract.md             # existing, unchanged
│   │   ├── department-protocol.md              # existing, unchanged
│   │   ├── glossary.md                         # UPDATE — agregar términos Brand
│   │   ├── profile-contract.md                 # existing (Profile), unchanged
│   │   └── brand-contract.md                   # NEW — consumption contract for downstream modules
│   │
│   ├── validation/                             # existing, unchanged
│   ├── profile/                                # existing, unchanged
│   │
│   └── brand/                                  # NEW — todo el módulo
│       ├── SKILL.md                            # Orchestrator (paralelo a validation/orchestrator/)
│       ├── references/
│       │   ├── pipeline-contract.md            # Contrato entre deptos + coherence gates overview
│       │   ├── archetype-guide.md              # 12 Jung archetypes expanded + tables
│       │   ├── brand-profiles.md               # Los 8 profiles canónicos
│       │   ├── coherence-rules.md              # Los 9 gates detallados
│       │   ├── reveal-script.md                # Templates de reveals por modo
│       │   ├── scope-analysis-rubric.md        # Reglas de clasificación
│       │   ├── failure-protocols.md            # Failure modes + fallbacks
│       │   ├── versioning.md                   # Snapshot + diff + rollback protocols
│       │   ├── edge-cases.md                   # Edge cases handling
│       │   ├── interaction-flow.md             # Decision tree de user interactions
│       │   ├── budget-tracking.md              # Cost tracking schema + estimates
│       │   └── version-compatibility.md        # Tool versions matrix
│       │
│       ├── scope-analysis/                     # No sub-agente — orchestrator lo ejecuta
│       │   └── ALGORITHM.md                    # Algoritmo detallado inline
│       │
│       ├── strategy/
│       │   ├── SKILL.md                        # Instrucciones para sub-agente Strategy
│       │   └── references/
│       │       ├── data-schema.md
│       │       └── positioning-frameworks.md   # Templates + examples
│       │
│       ├── verbal/
│       │   ├── SKILL.md
│       │   └── references/
│       │       ├── data-schema.md
│       │       ├── verification-protocol.md    # Domain + TM check queries per jurisdiction
│       │       ├── naming-strategies-by-profile.md
│       │       ├── copy-asset-matrix.md        # Qué assets por brand profile
│       │       └── voice-application-examples.md # Do/don'ts examples per voice attribute
│       │
│       ├── visual/
│       │   ├── SKILL.md
│       │   └── references/
│       │       ├── data-schema.md
│       │       ├── archetype-palette-seeds.md  # 12 archetypes → color families
│       │       ├── archetype-typography-map.md # Archetype × era → font pairings
│       │       ├── wcag-utility.md             # Contrast algorithm pseudocode
│       │       └── mood-prompt-templates.md    # Recraft prompts per archetype
│       │
│       ├── logo/
│       │   ├── SKILL.md
│       │   └── references/
│       │       ├── data-schema.md
│       │       ├── prompt-templates.md         # Recraft prompts per archetype × direction
│       │       ├── direction-strategies-by-profile.md # Directions per brand profile
│       │       └── quality-validation.md       # Automated quality checks
│       │
│       └── activation/
│           ├── SKILL.md
│           └── references/
│               ├── data-schema.md
│               ├── design-md-template.md       # Template para DESIGN.md
│               ├── screen-prompts.md           # Stitch prompts per screen type
│               ├── package-structure-by-profile.md
│               └── readme-template.md          # Template para README.md del package
│
├── testing/
│   ├── PROTOCOL.md                             # existing, unchanged
│   ├── suite.yaml                              # existing (Validation suite)
│   ├── brand-PROTOCOL.md                       # NEW — protocolo testing Brand
│   ├── brand-suite.yaml                        # NEW — 8 ideas curadas per brand profile
│   ├── brand-human-eval-template.md            # NEW — template para human eval
│   ├── brand-runs/                             # NEW — runs de testing Brand
│   │   └── REGISTRY.md                         # Index de runs
│   └── analysis/
│       └── brand-coverage.md                   # NEW — aggregated testing stats
│
├── calibration/                                # OPTIONAL new addition
│   ├── scenarios.md                            # existing (Validation)
│   ├── fit-scenarios.md                        # existing (Profile)
│   └── brand-scenarios.md                      # NEW (si decidimos crear — ver open-decisions)
│
├── plan/                                       # NEW — planning artifacts
│   └── brand/                                  # NEW — este plan
│       ├── README.md
│       ├── 01-overview-and-architecture.md
│       ├── 02-scope-analysis.md
│       ├── 03-brand-profiles.md
│       ├── 04-dept-strategy.md
│       ├── 05-dept-verbal.md
│       ├── 06-dept-visual.md
│       ├── 07-dept-logo.md
│       ├── 08-dept-activation.md
│       ├── 09-coherence-model.md
│       ├── 10-persistence-and-contracts.md
│       ├── 11-tools-stack.md
│       ├── 12-modes-and-interactions.md
│       ├── 13-failure-modes.md
│       ├── 14-testing-strategy.md
│       ├── 15-versioning-reproducibility.md
│       ├── 16-v1-limitations.md
│       ├── 17-cost-and-timing.md
│       ├── 18-output-package-structure.md
│       ├── 19-edge-cases.md
│       ├── 20-ecosystem-integration.md
│       ├── 21-file-structure.md (this file)
│       └── 22-open-decisions.md
│
├── output/                                     # existing — artifacts de runs
│   └── {idea-slug}/
│       ├── brand/                              # NEW — per idea
│       └── validation/                         # existing
│
├── docs/                                       # existing
│   └── idea-loop-architecture.md               # existing
│
└── .mcp.json                                   # UPDATE — agregar new MCPs
```

## 21.3 Archivos nuevos a crear en Sprint 0

### Specs core (skills/brand/)

**Orchestrator level**:
1. `skills/brand/SKILL.md` — orchestrator instructions
2. `skills/brand/references/pipeline-contract.md`
3. `skills/brand/references/archetype-guide.md`
4. `skills/brand/references/brand-profiles.md`
5. `skills/brand/references/coherence-rules.md`
6. `skills/brand/references/reveal-script.md`
7. `skills/brand/references/scope-analysis-rubric.md`
8. `skills/brand/references/failure-protocols.md`
9. `skills/brand/references/versioning.md`
10. `skills/brand/references/edge-cases.md`
11. `skills/brand/references/interaction-flow.md`
12. `skills/brand/references/budget-tracking.md`
13. `skills/brand/references/version-compatibility.md`

**Scope Analysis**:
14. `skills/brand/scope-analysis/ALGORITHM.md`

**Strategy dept**:
15. `skills/brand/strategy/SKILL.md`
16. `skills/brand/strategy/references/data-schema.md`
17. `skills/brand/strategy/references/positioning-frameworks.md`

**Verbal dept**:
18. `skills/brand/verbal/SKILL.md`
19. `skills/brand/verbal/references/data-schema.md`
20. `skills/brand/verbal/references/verification-protocol.md`
21. `skills/brand/verbal/references/naming-strategies-by-profile.md`
22. `skills/brand/verbal/references/copy-asset-matrix.md`
23. `skills/brand/verbal/references/voice-application-examples.md`

**Visual dept**:
24. `skills/brand/visual/SKILL.md`
25. `skills/brand/visual/references/data-schema.md`
26. `skills/brand/visual/references/archetype-palette-seeds.md`
27. `skills/brand/visual/references/archetype-typography-map.md`
28. `skills/brand/visual/references/wcag-utility.md`
29. `skills/brand/visual/references/mood-prompt-templates.md`

**Logo dept**:
30. `skills/brand/logo/SKILL.md`
31. `skills/brand/logo/references/data-schema.md`
32. `skills/brand/logo/references/prompt-templates.md`
33. `skills/brand/logo/references/direction-strategies-by-profile.md`
34. `skills/brand/logo/references/quality-validation.md`

**Activation dept**:
35. `skills/brand/activation/SKILL.md`
36. `skills/brand/activation/references/data-schema.md`
37. `skills/brand/activation/references/design-md-template.md`
38. `skills/brand/activation/references/screen-prompts.md`
39. `skills/brand/activation/references/package-structure-by-profile.md`
40. `skills/brand/activation/references/readme-template.md`

### Shared updates

41. `skills/_shared/brand-contract.md` (NEW)
42. `skills/_shared/glossary.md` (UPDATE — agregar términos Brand)

### Testing

43. `testing/brand-PROTOCOL.md` (NEW)
44. `testing/brand-suite.yaml` (NEW)
45. `testing/brand-human-eval-template.md` (NEW)
46. `testing/brand-runs/REGISTRY.md` (NEW placeholder)
47. `testing/analysis/brand-coverage.md` (NEW placeholder)

### Optional (if decided in open-decisions)

48. `calibration/brand-scenarios.md` (NEW — optional)

### Root-level updates

49. `CLAUDE.md` (UPDATE — agregar sección Brand completa)
50. `.mcp.json` (UPDATE — agregar new MCPs config)

**Total files creados/updateados en Sprint 0: ~50 archivos** (muchos referenced-only hasta Sprint 1)

## 21.4 Archivos que crece en Sprint 1 (implementation)

Sprint 1 no crea muchos archivos nuevos — escribe contenido executable en los SKILL.md creados en Sprint 0. Cambios principales:

- Refinamiento de SKILL.md basado en dogfooding real
- Additions de examples trabajados en references docs
- Testing artifacts (test run results)
- Bug fixes y edge case additions

Sprint 1 también implementa el **setup de MCPs** en user's entorno:
- User installs Stitch MCP (outside repo)
- User installs Image Gen MCP (outside repo)
- User installs Domain MCP (outside repo)
- `.mcp.json` del repo configura references

## 21.5 Archivos de runtime (creados per user run)

Cada brand run crea:

```
output/{idea-slug}/brand/
├── [full package structure — see 18-output-package-structure.md]
```

Engram creates:
```
brand/{idea-slug}/scope
brand/{idea-slug}/strategy
brand/{idea-slug}/verbal
brand/{idea-slug}/visual
brand/{idea-slug}/logo
brand/{idea-slug}/activation
brand/{idea-slug}/final-report
brand/{idea-slug}/snapshot/v{N}
```

Estos NO están versioned en git (están en `.gitignore` or `output/` + Engram DB).

## 21.6 Convenciones de naming

### Markdown files
- kebab-case: `archetype-palette-seeds.md`
- Descriptive: names explain content
- Numbered prefix en plan/ para orden de reading

### Directory structure
- Mirror department structure de Validation (consistency)
- `references/` siempre subfolder para reference docs
- `SKILL.md` always at directory root del dept

### Inside SKILL.md files
- Title + brief description
- Core Principle
- Inputs
- Step-by-step process
- Output Assembly Checklist
- Persistence
- Critical Rules

(Pattern existente en Validation orchestrator SKILL.md)

## 21.7 Build order (Sprint 0 sequencing)

Order sugerido para escribir los 50 archivos:

### Week 1 of Sprint 0 — Foundations
1. `skills/_shared/brand-contract.md` (primera — downstream contract clarity)
2. `skills/_shared/glossary.md` update
3. `skills/brand/SKILL.md` (orchestrator)
4. `skills/brand/references/pipeline-contract.md`
5. `skills/brand/references/brand-profiles.md` (the 8 profiles)
6. `skills/brand/references/archetype-guide.md`
7. `skills/brand/scope-analysis/ALGORITHM.md`
8. `skills/brand/references/scope-analysis-rubric.md`

### Week 2 of Sprint 0 — Deptos
9-13. Strategy dept + references
14-19. Verbal dept + references
20-25. Visual dept + references
26-30. Logo dept + references
31-36. Activation dept + references

### Week 3 of Sprint 0 — Cross-cutting
37. `skills/brand/references/coherence-rules.md`
38. `skills/brand/references/reveal-script.md`
39. `skills/brand/references/failure-protocols.md`
40. `skills/brand/references/versioning.md`
41. `skills/brand/references/edge-cases.md`
42. `skills/brand/references/interaction-flow.md`
43. `skills/brand/references/budget-tracking.md`
44. `skills/brand/references/version-compatibility.md`

### Week 4 of Sprint 0 — Testing + integration
45. `testing/brand-PROTOCOL.md`
46. `testing/brand-suite.yaml`
47. `testing/brand-human-eval-template.md`
48. `CLAUDE.md` update (Brand section)
49. `.mcp.json` update

Total estimated time para Sprint 0: ~1-2 weeks de escritura focalizada (depending on quality bar + iteration rounds).

## 21.8 Reference from plan/ to skills/

Los archivos en `plan/brand/` son documentos de **design**; los archivos en `skills/brand/` son **specs executable**.

**Diferencia**:
- `plan/brand/05-dept-verbal.md` explica **por qué** Verbal está diseñado así + todas las decisiones
- `skills/brand/verbal/SKILL.md` es el **qué** hacer — instrucciones para el sub-agente

Sprint 0 toma decisiones de `plan/` y las convierte a `skills/` specs.

Post-Sprint 0, `plan/brand/` queda como referencia histórica/design rationale. Bug fixes + iteraciones menores son en `skills/brand/`.

## 21.9 Gitignore considerations

Archivos a NOT commitear:
- `output/{slug}/brand/*` — artifacts per-run (cada user tiene suyos)
- `testing/brand-runs/*/brand-book.pdf` — binaries grandes (aunque testing runs podrían ser OK committear según protocolo)

Archivos SÍ commitear:
- Todos los specs de `skills/brand/`
- Todos los planning en `plan/brand/`
- Todos los testing protocols y suite definitions
- CLAUDE.md, .mcp.json, README

## 21.10 Post-v1 evolution

File structure design para permitir additions sin breaking changes:

### Adding new brand profile
Only need to edit: `skills/brand/references/brand-profiles.md` + update matrices en deptos relevant.

### Adding new archetype
Edit `skills/brand/references/archetype-guide.md` + add to compatibility tables.

### Adding new asset type
Edit relevant dept reference matrix (ej: `copy-asset-matrix.md` for verbal) + template.

### Adding new dept (future module)
Create `skills/brand-extension/{new-dept}/` o preferir un módulo separado (`skills/brand-physical/`, `skills/brand-motion/`).

### Adding new tool
Edit `skills/brand/references/version-compatibility.md` + relevant SKILL.md.

Design philosophy: **additive changes are cheap, breaking changes require v2**.

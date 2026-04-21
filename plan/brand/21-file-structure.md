# 21 — Estructura de Archivos del Módulo

## 21.1 Propósito

Exactamente qué archivos se crean dónde en Sprint 0 (specs) y Sprint 1 (implementación).

Estructura simplificada usando Handoff Compiler como depto final.

## 21.2 Estructura general

```
hardcore/ (repo root)
│
├── CLAUDE.md                                   # UPDATE — agregar sección Brand + Claude Design workflow
│
├── skills/
│   ├── _shared/                                # UPDATE — agregar brand-contract.md
│   │   ├── output-contract.md                  # existing, unchanged
│   │   ├── scoring-convention.md               # existing
│   │   ├── engram-convention.md                # existing
│   │   ├── persistence-contract.md             # existing
│   │   ├── department-protocol.md              # existing
│   │   ├── glossary.md                         # UPDATE — agregar términos Brand
│   │   ├── profile-contract.md                 # existing
│   │   └── brand-contract.md                   # NEW — consumption contract
│   │
│   ├── validation/                             # existing
│   ├── profile/                                # existing
│   │
│   └── brand/                                  # NEW — todo el módulo
│       ├── SKILL.md                            # Orchestrator
│       ├── references/
│       │   ├── pipeline-contract.md
│       │   ├── archetype-guide.md              # 12 Jung archetypes
│       │   ├── brand-profiles.md               # 8 canonical profiles
│       │   ├── coherence-rules.md              # 8 gates
│       │   ├── reveal-script.md
│       │   ├── scope-analysis-rubric.md
│       │   ├── failure-protocols.md
│       │   ├── versioning.md
│       │   ├── edge-cases.md
│       │   ├── interaction-flow.md
│       │   ├── budget-tracking.md              # Cost per tier tracking
│       │   ├── version-compatibility.md        # Tool versions
│       │   └── tier-system.md                  # NEW — tier 0/1/2 logic
│       │
│       ├── scope-analysis/                     # No sub-agente — orchestrator inline
│       │   └── ALGORITHM.md
│       │
│       ├── strategy/
│       │   ├── SKILL.md
│       │   └── references/
│       │       ├── data-schema.md
│       │       └── positioning-frameworks.md
│       │
│       ├── verbal/
│       │   ├── SKILL.md
│       │   └── references/
│       │       ├── data-schema.md
│       │       ├── verification-protocol.md
│       │       ├── naming-strategies-by-profile.md
│       │       ├── core-copy-matrix.md         # Core assets matrix
│       │       └── voice-application-examples.md
│       │
│       ├── visual/
│       │   ├── SKILL.md
│       │   └── references/
│       │       ├── data-schema.md
│       │       ├── archetype-palette-seeds.md
│       │       ├── archetype-typography-map.md
│       │       ├── wcag-utility.md
│       │       ├── mood-prompt-templates.md    # Tier 2 Recraft
│       │       └── unsplash-query-templates.md # NEW — Tier 1 mood refs
│       │
│       ├── logo/
│       │   ├── SKILL.md
│       │   └── references/
│       │       ├── data-schema.md
│       │       ├── claude-svg-templates.md     # NEW — Tier 0 SVG templates
│       │       ├── recraft-prompt-templates.md # Tier 1+ prompts
│       │       ├── direction-strategies-by-profile.md
│       │       ├── quality-validation.md
│       │       └── auto-elevation-rules.md     # NEW — tier elevation logic
│       │
│       └── handoff-compiler/                   # REPLACES activation/
│           ├── SKILL.md
│           └── references/
│               ├── data-schema.md
│               ├── brand-document-template.md  # NEW — PDF structure
│               ├── prompts-library-templates.md # NEW — prompts per scope
│               ├── tokens-templates/           # NEW — token file templates
│               │   ├── tokens.css.template
│               │   ├── tokens.json.template
│               │   ├── tailwind.config.js.template
│               │   └── examples/
│               │       ├── button.html.template
│               │       ├── card.html.template
│               │       └── hero.html.template
│               ├── package-structure-by-profile.md
│               └── readme-template.md
│
├── testing/
│   ├── PROTOCOL.md                             # existing
│   ├── suite.yaml                              # existing (Validation)
│   ├── brand-PROTOCOL.md                       # NEW
│   ├── brand-suite.yaml                        # NEW — 8 test ideas
│   ├── brand-human-eval-template.md            # NEW
│   ├── brand-runs/                             # NEW
│   │   └── REGISTRY.md
│   └── analysis/
│       └── brand-coverage.md                   # NEW
│
├── calibration/
│   ├── scenarios.md                            # existing (Validation)
│   ├── fit-scenarios.md                        # existing (Profile)
│   └── brand-scenarios.md                      # OPTIONAL (deferred Sprint 1+)
│
├── plan/                                       # Planning docs (este directorio)
│   └── brand/
│       ├── README.md
│       ├── 01-overview-and-architecture.md
│       ├── 02-scope-analysis.md
│       ├── 03-brand-profiles.md
│       ├── 04-dept-strategy.md
│       ├── 05-dept-verbal.md
│       ├── 06-dept-visual.md
│       ├── 07-dept-logo.md
│       ├── 08-dept-handoff-compiler.md         # Renamed from activation
│       ├── 09-coherence-model.md               # 8 gates
│       ├── 10-persistence-and-contracts.md
│       ├── 11-tools-stack.md                   # Tier-based
│       ├── 12-modes-and-interactions.md
│       ├── 13-failure-modes.md
│       ├── 14-testing-strategy.md
│       ├── 15-versioning-reproducibility.md
│       ├── 16-v1-limitations.md
│       ├── 17-cost-and-timing.md               # Tier-based numbers
│       ├── 18-output-package-structure.md      # 4 deliverables
│       ├── 19-edge-cases.md
│       ├── 20-ecosystem-integration.md
│       ├── 21-file-structure.md (this file)
│       ├── 22-open-decisions.md
│       ├── 23-brand-design-document-structure.md # PDF spec detailed
│       └── 24-prompts-library-templates.md     # Prompts templates
│
├── output/
│   └── {idea-slug}/
│       ├── brand/                              # NEW per run
│       └── validation/                         # existing
│
├── docs/
│   └── idea-loop-architecture.md
│
└── .mcp.json                                   # UPDATE — nuevos MCPs
```

## 21.3 Archivos nuevos a crear en Sprint 0

### Specs core (skills/brand/)

**Orchestrator level** (13 archivos):
1. `skills/brand/SKILL.md`
2. `skills/brand/references/pipeline-contract.md`
3. `skills/brand/references/archetype-guide.md`
4. `skills/brand/references/brand-profiles.md`
5. `skills/brand/references/coherence-rules.md` (8 gates)
6. `skills/brand/references/reveal-script.md`
7. `skills/brand/references/scope-analysis-rubric.md`
8. `skills/brand/references/failure-protocols.md`
9. `skills/brand/references/versioning.md`
10. `skills/brand/references/edge-cases.md`
11. `skills/brand/references/interaction-flow.md`
12. `skills/brand/references/budget-tracking.md`
13. `skills/brand/references/version-compatibility.md`
14. `skills/brand/references/tier-system.md`

**Scope Analysis** (1):
15. `skills/brand/scope-analysis/ALGORITHM.md`

**Strategy dept** (3):
16. `skills/brand/strategy/SKILL.md`
17. `skills/brand/strategy/references/data-schema.md`
18. `skills/brand/strategy/references/positioning-frameworks.md`

**Verbal dept** (6):
19. `skills/brand/verbal/SKILL.md`
20. `skills/brand/verbal/references/data-schema.md`
21. `skills/brand/verbal/references/verification-protocol.md`
22. `skills/brand/verbal/references/naming-strategies-by-profile.md`
23. `skills/brand/verbal/references/core-copy-matrix.md`
24. `skills/brand/verbal/references/voice-application-examples.md`

**Visual dept** (6):
25. `skills/brand/visual/SKILL.md`
26. `skills/brand/visual/references/data-schema.md`
27. `skills/brand/visual/references/archetype-palette-seeds.md`
28. `skills/brand/visual/references/archetype-typography-map.md`
29. `skills/brand/visual/references/wcag-utility.md`
30. `skills/brand/visual/references/mood-prompt-templates.md`
31. `skills/brand/visual/references/unsplash-query-templates.md` — NEW Tier 1

**Logo dept** (6):
32. `skills/brand/logo/SKILL.md`
33. `skills/brand/logo/references/data-schema.md`
34. `skills/brand/logo/references/claude-svg-templates.md` — NEW Tier 0
35. `skills/brand/logo/references/recraft-prompt-templates.md` — Tier 1+
36. `skills/brand/logo/references/direction-strategies-by-profile.md`
37. `skills/brand/logo/references/quality-validation.md`
38. `skills/brand/logo/references/auto-elevation-rules.md` — NEW

**Handoff Compiler dept** (9):
39. `skills/brand/handoff-compiler/SKILL.md`
40. `skills/brand/handoff-compiler/references/data-schema.md`
41. `skills/brand/handoff-compiler/references/brand-document-template.md` — NEW core file
42. `skills/brand/handoff-compiler/references/prompts-library-templates.md` — NEW core file
43. `skills/brand/handoff-compiler/references/tokens-templates/tokens.css.template`
44. `skills/brand/handoff-compiler/references/tokens-templates/tokens.json.template`
45. `skills/brand/handoff-compiler/references/tokens-templates/tailwind.config.js.template`
46. `skills/brand/handoff-compiler/references/tokens-templates/examples/{button,card,hero}.html.template` (3 files)
47. `skills/brand/handoff-compiler/references/package-structure-by-profile.md`
48. `skills/brand/handoff-compiler/references/readme-template.md`

### Shared updates (2):

49. `skills/_shared/brand-contract.md` — NEW
50. `skills/_shared/glossary.md` — UPDATE (add Brand terms)

### Testing (5):

51. `testing/brand-PROTOCOL.md` — NEW
52. `testing/brand-suite.yaml` — NEW (8 ideas)
53. `testing/brand-human-eval-template.md` — NEW
54. `testing/brand-runs/REGISTRY.md` — NEW placeholder
55. `testing/analysis/brand-coverage.md` — NEW placeholder

### Optional (deferred)

- `calibration/brand-scenarios.md` — OPTIONAL (decide Sprint 1/2)

### Root-level updates (2)

56. `CLAUDE.md` — UPDATE (Brand section + Claude Design workflow)
57. `.mcp.json` — UPDATE (new MCPs)

**Total Sprint 0: ~55 archivos**.

**Total: ~55 archivos** en Sprint 0 entre specs + references + testing protocol + config updates.

## 21.4 Archivos que crece en Sprint 1

Sprint 1 implementa + refines. Cambios:
- Refinamiento SKILL.md basado en dogfooding
- Examples trabajados en references
- Testing artifacts (run results)
- Bug fixes + edge cases

Sprint 1 también implementa **setup de MCPs** en user environment:
- User installs Domain MCP (Tier 0 mandatory)
- User installs Image Gen MCP (Tier 1+ optional)
- User verifies Claude Design access (for testing downstream)
- `.mcp.json` configura references

## 21.5 Archivos de runtime (per user run)

Cada brand run crea:
```
output/{idea-slug}/brand/
├── [4 deliverables + README + AUDIT]
```

Engram:
```
brand/{idea-slug}/scope
brand/{idea-slug}/strategy
brand/{idea-slug}/verbal
brand/{idea-slug}/visual
brand/{idea-slug}/logo
brand/{idea-slug}/handoff           # Was "activation"
brand/{idea-slug}/final-report
brand/{idea-slug}/snapshot/v{N}
```

NO versioned en git.

## 21.6 Convenciones de naming

### Markdown files
- kebab-case
- Descriptive
- Numbered prefix en plan/

### Directory structure
- Mirror department structure (consistency)
- `references/` subfolder
- `SKILL.md` at dept root

### Inside SKILL.md
- Title + description
- Core Principle
- Inputs
- Step-by-step process
- Output Assembly Checklist
- Persistence
- Critical Rules

## 21.7 Build order (Sprint 0 sequencing)

### Semana 1 — Foundations
1. `skills/_shared/brand-contract.md`
2. `skills/_shared/glossary.md` update
3. `skills/brand/SKILL.md`
4. `skills/brand/references/pipeline-contract.md`
5. `skills/brand/references/brand-profiles.md`
6. `skills/brand/references/archetype-guide.md`
7. `skills/brand/references/tier-system.md`
8. `skills/brand/scope-analysis/ALGORITHM.md`
9. `skills/brand/references/scope-analysis-rubric.md`

### Semana 2 — Deptos
10-12. Strategy + refs
13-18. Verbal + refs
19-25. Visual + refs
26-32. Logo + refs
33-48. Handoff Compiler + refs + tokens-templates

### Semana 3 — Cross-cutting
49-56. Coherence, reveal, failure, versioning, edge cases, interaction flow, budget, version compat

### Semana 4 — Testing + integration
57-61. Testing protocol + suite + templates + registry
62-63. CLAUDE.md + .mcp.json updates

Total estimated: **1-2 semanas** de escritura focalizada.

## 21.8 Reference from plan/ to skills/

`plan/brand/` = **design docs**. `skills/brand/` = **executable specs**.

Diferencia:
- `plan/brand/05-dept-verbal.md` explica **por qué** Verbal está diseñado así + decisiones
- `skills/brand/verbal/SKILL.md` es **qué** hacer — instrucciones para el sub-agente

Sprint 0 toma decisiones de `plan/` y convierte a `skills/` specs.

Post-Sprint 0, `plan/brand/` queda como historical reference.

## 21.9 Gitignore considerations

NOT commitear:
- `output/{slug}/brand/*` — artifacts per-run
- `testing/brand-runs/*/brand-design-document.pdf` — binary grande (aunque testing runs podrían commitearse según protocol)

Commitear:
- All specs en `skills/brand/`
- All planning en `plan/brand/`
- All testing protocols y suite
- CLAUDE.md, .mcp.json, README

## 21.10 Post-v1 evolution

### Adding new brand profile
Edit `skills/brand/references/brand-profiles.md`.

### Adding new archetype
Edit `skills/brand/references/archetype-guide.md`.

### Adding new prompt type (for Prompts Library)
Edit `skills/brand/handoff-compiler/references/prompts-library-templates.md`.

### Adding new token format
Agregar template en `skills/brand/handoff-compiler/references/tokens-templates/`.

### Adding new tool
Edit `skills/brand/references/version-compatibility.md` + relevant SKILL.md.

### Integrating Claude Design MCP (when Anthropic ships)
Update Handoff Compiler con `--auto-setup` flag. No changes elsewhere.

Design philosophy: additive cheap, breaking requires v2.

# 21 — Estructura de Archivos del Módulo

## 21.1 Propósito

Exactamente qué archivos se crean dónde en Sprint 0 (specs) y Sprint 1 (implementación + dogfooding).

Estructura minimalista, alineada al patrón de Validation y Profile: cada depto tiene típicamente `SKILL.md` + `references/data-schema.md`. El contenido procedural (pasos, tablas de ejecución, ejemplos de voice, failure handling) vive dentro del SKILL.md, no en refs separadas. Refs standalone solo para material consultado transversalmente (archetype guide, brand profiles, coherence rules) o material grande que el agente lee puntualmente (palette seeds, SVG templates, PDF template).

## 21.2 Estructura general

```
hardcore/ (repo root)
│
├── CLAUDE.md                                   # UPDATE — agregar sección Brand + Claude Design workflow
│
├── skills/
│   ├── _shared/                                # UPDATE
│   │   ├── output-contract.md                  # existing, unchanged
│   │   ├── scoring-convention.md               # existing
│   │   ├── engram-convention.md                # existing
│   │   ├── persistence-contract.md             # existing
│   │   ├── department-protocol.md              # existing
│   │   ├── glossary.md                         # UPDATE — agregar términos Brand
│   │   ├── profile-contract.md                 # existing
│   │   └── brand-contract.md                   # ya escrito en esta pasada
│   │
│   ├── validation/                             # existing (unchanged)
│   ├── profile/                                # existing (unchanged)
│   │
│   └── brand/                                  # NEW — todo el módulo
│       ├── SKILL.md                            # Orchestrator — incluye pipeline flow, reveal scripts,
│       │                                       #   interaction decisions, override allowlist,
│       │                                       #   failure handling, versioning, edge cases
│       ├── references/
│       │   ├── sub-agent-template.md           # template de launch para sub-agentes (mismo que Validation)
│       │   ├── archetype-guide.md              # 12 archetypes × voice defaults × typography × palette family
│       │   │                                   #   × sentiment compatibility × voice×register matrix
│       │   ├── brand-profiles.md               # 8 canonical profiles con matrix de outputs completa
│       │   └── coherence-rules.md              # 9 gates (G0-G8) con compatibility matrices +
│       │                                       #   criticality per profile + escalation UI templates
│       │
│       ├── scope-analysis/
│       │   ├── SKILL.md                        # incluye rubric de signals per eje + matching algo + decision tree
│       │   └── references/
│       │       └── data-schema.md
│       │
│       ├── strategy/
│       │   ├── SKILL.md                        # incluye sentiment_landscape derivation +
│       │   │                                   #   positioning frameworks + voice precedence rule
│       │   └── references/
│       │       └── data-schema.md
│       │
│       ├── verbal/
│       │   ├── SKILL.md                        # incluye verification protocol + naming strategies
│       │   │                                   #   per profile + core copy matrix + voice examples
│       │   └── references/
│       │       └── data-schema.md
│       │
│       ├── visual/
│       │   ├── SKILL.md                        # incluye typography pairing tables + unsplash query
│       │   │                                   #   templates + visual principles
│       │   └── references/
│       │       ├── data-schema.md
│       │       ├── archetype-palette-seeds.md  # HSL ranges por archetype (big reference)
│       │       └── wcag-utility.md             # contrast algorithm + pseudocode
│       │
│       ├── logo/
│       │   ├── SKILL.md                        # incluye form language tables + direction strategies +
│       │   │                                   #   quality validation checks + variants derivation rules
│       │   └── references/
│       │       ├── data-schema.md
│       │       └── svg-templates.md            # SVG templates por archetype × form language (big)
│       │
│       └── handoff-compiler/
│           ├── SKILL.md                        # incluye README template + AUDIT format +
│           │                                   #   package structure per profile
│           └── references/
│               ├── data-schema.md
│               ├── brand-document-template.md   # PDF structure per profile (page ranges + layouts)
│               ├── prompts-library-templates.md # prompts per scope (el archivo más grande del módulo)
│               └── tokens-templates.md          # templates de tokens.css / tokens.json / tailwind.config /
│                                                #   fonts.css / button+card+hero.html — todos en un file
│
├── testing/
│   ├── PROTOCOL.md                             # existing (Validation)
│   ├── suite.yaml                              # existing (Validation)
│   ├── brand-PROTOCOL.md                       # NEW
│   ├── brand-suite.yaml                        # NEW — 8 test ideas con expected outcomes
│   ├── brand-human-review-template.md          # NEW — qualitative review template
│   ├── brand-runs/                             # NEW
│   │   └── REGISTRY.md
│   └── analysis/
│       └── brand-coverage.md                   # NEW (placeholder)
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
│       ├── 08-dept-handoff-compiler.md
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
│       ├── 23-brand-design-document-structure.md
│       └── 24-prompts-library-templates.md
│
├── output/
│   └── {idea-slug}/
│       ├── brand/                              # NEW per run
│       └── validation/                         # existing
│
└── .mcp.json                                   # UPDATE — agregar Domain MCP + Unsplash env var
```

## 21.3 Archivos nuevos a crear en Sprint 0

### Skills module (23 archivos)

**Orchestrator level** (5):
1. `skills/brand/SKILL.md`
2. `skills/brand/references/sub-agent-template.md`
3. `skills/brand/references/archetype-guide.md`
4. `skills/brand/references/brand-profiles.md`
5. `skills/brand/references/coherence-rules.md`

**Scope Analysis sub-agent** (2):
6. `skills/brand/scope-analysis/SKILL.md`
7. `skills/brand/scope-analysis/references/data-schema.md`

**Strategy dept** (2):
8. `skills/brand/strategy/SKILL.md`
9. `skills/brand/strategy/references/data-schema.md`

**Verbal dept** (2):
10. `skills/brand/verbal/SKILL.md`
11. `skills/brand/verbal/references/data-schema.md`

**Visual dept** (4):
12. `skills/brand/visual/SKILL.md`
13. `skills/brand/visual/references/data-schema.md`
14. `skills/brand/visual/references/archetype-palette-seeds.md`
15. `skills/brand/visual/references/wcag-utility.md`

**Logo dept** (3):
16. `skills/brand/logo/SKILL.md`
17. `skills/brand/logo/references/data-schema.md`
18. `skills/brand/logo/references/svg-templates.md`

**Handoff Compiler dept** (5):
19. `skills/brand/handoff-compiler/SKILL.md`
20. `skills/brand/handoff-compiler/references/data-schema.md`
21. `skills/brand/handoff-compiler/references/brand-document-template.md`
22. `skills/brand/handoff-compiler/references/prompts-library-templates.md`
23. `skills/brand/handoff-compiler/references/tokens-templates.md`

### Shared (1 nuevo + 1 update)

- `skills/_shared/brand-contract.md` — ya escrito
- `skills/_shared/glossary.md` — UPDATE (agregar términos Brand)

### Testing (5)

24. `testing/brand-PROTOCOL.md`
25. `testing/brand-suite.yaml` (8 test ideas)
26. `testing/brand-human-review-template.md`
27. `testing/brand-runs/REGISTRY.md` (placeholder)
28. `testing/analysis/brand-coverage.md` (placeholder)

### Root-level updates (2)

29. `CLAUDE.md` — UPDATE (agregar Brand section + Claude Design workflow)
30. `.mcp.json` — UPDATE (agregar Domain MCP + Unsplash env var config)

**Total Sprint 0: ~30 archivos** (23 skills + 1 shared + 5 testing + 2 config updates).

## 21.4 Qué vive dentro de cada SKILL.md (no en refs separadas)

Para evitar duplicar contenido o perder información, acá queda registrado qué contenido procedural va dentro de cada SKILL.md en vez de en refs standalone. Cuando se escriban los SKILL.md en Sprint 0, estos son los bloques que deben incluirse:

### `skills/brand/SKILL.md` (orchestrator)
- Pipeline flow (DAG + order of execution)
- Modos de operación (Normal, Fast, Extend, Override, Resume)
- Reveal script templates per dept completion
- Decision tree de interaction points
- Override allowlist + validation rules
- Failure handling + hard vs soft failure behavior
- Versioning logic (snapshots, diff, rollback, audit log)
- Edge cases handling
- Tool version compatibility tracking

### `skills/brand/scope-analysis/SKILL.md`
- Rubric de signals per eje (customer, format, distribution, stage, cultural_scope)
- Matching algorithm (similarity scoring) con pseudocode
- Decision tree para intensity modifiers per profile
- Ejemplos trabajados para los 8 canonical profiles
- Ejemplos de casos híbridos

### `skills/brand/strategy/SKILL.md`
- `sentiment_landscape` derivation algorithm (signals + mapping)
- Archetype selection algorithm
- Voice attributes synthesis (defaults per archetype + register modulation)
- Voice precedence rule (archetype > scope > profile)
- Positioning frameworks (templates + examples)
- Brand values derivation

### `skills/brand/verbal/SKILL.md`
- Verification protocol (Domain MCP + TM screening flow, parallelization)
- Naming strategies per brand_profile (tabla)
- Core copy matrix (qué copy assets per scope)
- Voice application examples per archetype (do/don't concrete examples)

### `skills/brand/visual/SKILL.md`
- Seed colors por archetype (tabla compact; HSL ranges detallados en ref `archetype-palette-seeds.md`)
- Typography pairing tables per archetype × era
- Unsplash query templates per archetype × mood axis
- Visual principles generation rules

### `skills/brand/logo/SKILL.md`
- Form language tables per archetype (wordmark / combination / symbolic-geometric / icon-first)
- Direction strategies per brand_profile
- Quality validation checks (XML parse, element count, palette compliance, 16px legibility)
- Variants derivation rules (mono, inverse, icon-only — transformations programáticas)
- Derived assets logic (favicons, OG cards, app icons, covers, merch direction)

### `skills/brand/handoff-compiler/SKILL.md`
- 7 pasos del proceso (coherence gates, PDF, prompts library, tokens, assets, README, AUDIT)
- README template (full)
- AUDIT format
- Package structure logic per brand_profile
- Claude Pro pre-flight check behavior
- Fail-fast gate behavior

## 21.5 Sprint 1 — implementación + dogfooding

Sprint 1 implementa + refina. Cambios:
- Refinamiento de SKILL.md basado en dogfooding runs reales
- Examples trabajados en references (basados en outputs reales)
- Testing artifacts (run results acumulados en `testing/brand-runs/`)
- Bug fixes + edge cases surfaced durante dogfooding

Sprint 1 también implementa **setup de MCPs** en el environment del user:
- User instala Domain MCP (mandatory)
- User registra Unsplash free API key (mandatory)
- User verifica Claude Pro subscription active (mandatory pre-flight gate)
- `.mcp.json` configura references

Dogfooding target: brandear Hardcore mismo.

## 21.6 Archivos de runtime (per user run)

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
brand/{idea-slug}/handoff
brand/{idea-slug}/final-report
brand/{idea-slug}/snapshot/v{N}
brand/{idea-slug}/snapshot/validation
brand/{idea-slug}/snapshot/profile
```

NO versioned en git. Los filesystem outputs quedan en `output/{slug}/brand/` para consumption directa por el user.

## 21.7 Convenciones de naming

### Markdown files
- kebab-case
- Descriptive
- Numbered prefix en `plan/brand/`

### Directory structure
- Mirror de department structure (consistency con Validation + Profile)
- `references/` subfolder
- `SKILL.md` at dept root

### Inside SKILL.md
- Title + description
- Core Principle
- Inputs (incluye referencias a brand-contract.md)
- Step-by-step process (tablas, algoritmos, ejemplos de ejecución inline)
- Output Assembly Checklist
- Persistence
- Critical Rules

## 21.8 Build order (Sprint 0 sequencing)

### Fase 1 — Foundations (shared + orchestrator)
1. `skills/_shared/brand-contract.md` (ya escrito)
2. `skills/_shared/glossary.md` update
3. `skills/brand/references/brand-profiles.md`
4. `skills/brand/references/archetype-guide.md`
5. `skills/brand/references/coherence-rules.md`
6. `skills/brand/references/sub-agent-template.md`
7. `skills/brand/SKILL.md` (orchestrator — consume refs anteriores)

### Fase 2 — Scope Analysis
8-9. `skills/brand/scope-analysis/SKILL.md` + data-schema

### Fase 3 — Deptos core (Strategy, Verbal, Visual)
10-11. Strategy (SKILL + data-schema)
12-13. Verbal (SKILL + data-schema)
14-17. Visual (SKILL + data-schema + archetype-palette-seeds + wcag-utility)

### Fase 4 — Logo y Handoff
18-20. Logo (SKILL + data-schema + svg-templates)
21-25. Handoff Compiler (SKILL + data-schema + brand-document-template + prompts-library-templates + tokens-templates)

### Fase 5 — Testing + integration
26-28. Testing protocol + suite + human-review-template
29. Testing registry + coverage placeholders
30. CLAUDE.md + .mcp.json updates

Sin deadlines fijos — la velocidad se adapta al ritmo del user.

## 21.9 Reference from plan/ to skills/

`plan/brand/` = **design docs**. `skills/brand/` = **executable specs**.

Diferencia:
- `plan/brand/05-dept-verbal.md` explica **por qué** Verbal está diseñado así + decisiones
- `skills/brand/verbal/SKILL.md` es **qué** hacer — instrucciones para el sub-agente

Sprint 0 toma decisiones de `plan/` y las convierte a `skills/` specs.

Post-Sprint 0, `plan/brand/` queda como historical reference.

## 21.10 Gitignore considerations

NOT commitear:
- `output/{slug}/brand/*` — artifacts per-run
- `testing/brand-runs/*/brand-design-document.pdf` — binarios grandes

Commitear:
- All specs en `skills/brand/`
- All planning en `plan/brand/`
- All testing protocols y suite + human-review templates
- Testing run results en YAML (no PDFs)
- CLAUDE.md, .mcp.json, README

## 21.11 Comparación con otros módulos del ecosistema

| Módulo | Files en skills/ | Deptos |
|---|---|---|
| Validation | 15 | 6 + orchestrator |
| Profile | 4 | 1 |
| Brand (v1 lean) | 23 | 6 + orchestrator + Scope Analysis |

Brand tiene más files por dept que Validation (~3 vs ~2) porque:
- `archetype-guide.md`, `brand-profiles.md`, `coherence-rules.md` son refs big consultadas por múltiples deptos — standalone evita duplicación
- Visual dept tiene `archetype-palette-seeds.md` (HSL ranges detallados) + `wcag-utility.md` (algoritmo con fórmulas)
- Logo dept tiene `svg-templates.md` (templates SVG por archetype × form)
- Handoff Compiler emite templates de output como artefactos (brand-document, prompts-library, tokens-templates) — son strings grandes que el agente escribe al filesystem

Todo lo demás (pasos procedurales, tablas de ejecución, examples, failure handling) vive dentro de cada SKILL.md, consistente con el patrón de Validation y Profile.

## 21.12 Post-v1 evolution

### Adding new brand profile
Edit `skills/brand/references/brand-profiles.md`.

### Adding new archetype
Edit `skills/brand/references/archetype-guide.md`.

### Adding new prompt type (para Prompts Library)
Edit `skills/brand/handoff-compiler/references/prompts-library-templates.md`.

### Adding new token format
Edit `skills/brand/handoff-compiler/references/tokens-templates.md` (agregar bloque con nuevo template).

### Adding new tool
Edit `skills/brand/SKILL.md` (tool version compat section) + el SKILL.md del dept relevante.

### Integrating Claude Design MCP (cuando Anthropic lo ship)
Update Handoff Compiler SKILL.md con `--auto-upload` flag. No changes elsewhere.

Design philosophy: additive cheap, breaking requires v2.

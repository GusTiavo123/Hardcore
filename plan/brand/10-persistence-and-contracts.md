# 10 — Persistencia y Contratos

## 10.1 Propósito

Definir cómo Brand persiste outputs en Engram + filesystem, y cómo módulos futuros (Launch, GTM, Ops) consumen esos outputs vía contratos explícitos.

El contrato refleja los **4 deliverables**: Brand Design Document PDF + Prompts Library + Brand Tokens + Reference Assets.

## 10.2 Persistence en Engram

### Topic keys estandarizados

Todos los artifacts viven bajo `brand/{idea-slug}/*`:

| Topic key | Qué contiene | Escribe | Lee (internamente) |
|---|---|---|---|
| `brand/{slug}/scope` | Scope manifest del Paso 0 | Orchestrator (Scope Analysis) | Todos los deptos |
| `brand/{slug}/strategy` | Decisiones estratégicas | Strategy | Verbal, Visual, Logo, Handoff |
| `brand/{slug}/verbal` | Naming + core copy | Verbal | Logo (wordmark+OG), Handoff |
| `brand/{slug}/visual` | Palette + typography + mood + principles | Visual | Logo, Handoff |
| `brand/{slug}/logo` | Manifest + paths a files | Logo | Handoff |
| `brand/{slug}/handoff` | Package manifest + coherence trace | Handoff Compiler | Módulos futuros |
| `brand/{slug}/final-report` | Executive summary | Handoff Compiler | User (via `/brand:show`) + módulos futuros |
| `brand/{slug}/snapshot/v{N}` | Frozen state post-delivery | Handoff Compiler | Auditoría, `/brand:diff` |

### Convenciones de naming

Siguen `skills/_shared/engram-convention.md`:
- `{idea-slug}` consistente con Validation
- Snapshots `v1`, `v2`, `vN`
- Upsert behavior

### Estructura del content en Engram

```
**What**: {summary} [brand] [{dept_tag}] [{idea-slug-tag}]
**Why**: {for downstream consumption}
**Where**: {filesystem path si aplica} / {topic_key}
**Data**:
{JSON string of full artifact}
```

### Session lifecycle

Similar a Validation:
1. Orchestrator inicia session: `mem_session_start({name: "brand-{slug}-{timestamp}"})`
2. Cada dept graba artifacts
3. Handoff Compiler graba final-report + snapshot
4. Orchestrator cierra session: `mem_session_end()` + `mem_session_summary()`

## 10.3 Filesystem persistence

`output/{idea-slug}/brand/` contiene los 4 deliverables + README + AUDIT.

**Principios**:
- Filesystem para artifacts grandes (PDF, SVG logos, HTML examples)
- Engram para metadata + manifest + machine-readable data
- Engram referencia paths, NO duplica file contents

Estructura completa en [18-output-package-structure.md](./18-output-package-structure.md).

## 10.4 Contratos de consumo (brand-contract.md)

`skills/_shared/brand-contract.md` define cómo módulos futuros consumen Brand artifacts.

Paralelo a `skills/_shared/profile-contract.md` existente.

### Interface del contrato

```
Dado un idea-slug, un módulo consumidor puede:

1. LEER EL FINAL REPORT (entry point canónico):
   artifact = mem_search("brand/{idea-slug}/final-report")
   latest = mem_get_observation(artifact[0].id)
   parsed = parse_json(latest.data_section)
   
2. ACCEDER A DEPTOS ESPECÍFICOS:
   strategy = mem_search("brand/{idea-slug}/strategy")
   verbal = mem_search("brand/{idea-slug}/verbal")
   ...

3. ACCEDER A FILESYSTEM ARTIFACTS:
   path_base = f"output/{idea-slug}/brand/"
   brand_document_pdf = path_base + "brand-design-document.pdf"
   prompts_library = parse_md(path_base + "prompts-for-claude-design.md")
   tokens_json = parse_json(path_base + "brand-tokens/tokens.json")
   logo_svg = path_base + "reference-assets/logo/primary.svg"
   ...

4. ACCEDER A VERSION ESPECÍFICA:
   latest = mem_search("brand/{idea-slug}/final-report", limit=1)
   v2 = mem_search("brand/{idea-slug}/snapshot/v2")
```

### Qué consumers pueden assume (invariantes)

**Siempre disponibles** si Brand corrió successfully:
- `archetype` (string, one of 12 Jung)
- `voice_attributes` (array of 3-5 objects)
- `positioning_statement` (string)
- `brand_name` (string)
- `palette.primary` (object con 5+ colors HEX)
- `typography` (heading + body + mono con Google Fonts imports)
- `logo.primary` (path to SVG)
- **Brand Design Document PDF** (for Claude Design upload)
- **Prompts Library markdown** (for Claude Design projects)
- **Brand Tokens folder** (for codebase integration)
- **Reference Assets folder** (logos + optional mood imagery)

### Qué puede variar (scope-dependent)

- `pitch_deck_prompt` (solo si b2b-enterprise)
- `app_icons_full_set` (solo si b2c-consumer-app)
- `manifesto_opening` (solo si community-movement)
- `whatsapp_templates_seed` (solo si b2local-service)
- `podcast_cover_prompt` (solo si content-media con podcast)

Los consumers deben:
1. Consultar `scope.output_manifest` para saber qué está disponible
2. Gracefully skip si un asset esperado no existe

### Versioning y freshness

- Por default: latest snapshot
- Staleness: si `brand.last_updated` > 180 days, flag
- Invalidation: si Validation/Profile updated después de Brand, flag "brand may be stale"

### Downstream module use cases (futuros)

**Launch module**:
- Lee `handoff.brand_design_document_path` para package assembly
- Lee `handoff.prompts_library_path` para auto-execute prompts en Claude Design
- Lee `logo/primary.svg` para favicon del deploy
- Lee `verbal.core_copy` para meta tags en generated pages

**GTM module**:
- Lee `strategy.target_audience_refined` para audience targeting ads
- Lee `strategy.voice_attributes` para ad copy consistency
- Lee `verbal.core_copy.value_props` para A/B test variants
- Lee `visual.palette` + `logo` para ad creative

**Ops module**:
- Lee `prompts_library.email_prompts` para set up en email providers
- Lee `verbal.communications.whatsapp_greeting_seed` (si local) para WhatsApp Business
- Lee `verbal.social_bios` para consistency audit

**Future Brand Maintenance module**:
- Lee todo para monitor brand consistency en otros content over time

## 10.5 Snapshot model (versioning)

Cada run completo produce un snapshot frozen en `brand/{slug}/snapshot/v{N}`.

Contiene full state del run: scope, strategy, verbal, visual, logo, handoff metadata, tool versions, timestamps, evidence traces.

Ver [15-versioning-reproducibility.md](./15-versioning-reproducibility.md) para detalles.

## 10.6 Relación con Validation + Profile

Brand **lee pero no modifica** Validation ni Profile.

Si Validation/Profile se actualizan después de Brand run:
- No invalida Brand retroactively
- Flag staleness cuando future module consume
- User puede `/brand:new` para regenerar (crea vN+1)

## 10.7 Evidence traces

Cada output de dept incluye `evidence_trace`:

```json
{
  "profile_fields_used": [...],
  "validation_depts_used": [...],
  "scope_modifiers_applied": [...],
  "tool_versions": {
    "recraft_v4": "latest or null if tier 0",
    "huemint_api": "v1 or null if tier 0",
    "domain_mcp": "2.1.0",
    "pdf_skill": "1.2",
    "claude_model": "claude-opus-4-7"
  },
  "tier_used": 0 | 1 | 2,
  "timestamps": {...}
}
```

## 10.8 Snapshot file layout (Engram)

```json
{
  "schema_version": "1.0",
  "snapshot_version": "v1",
  "timestamp_start": "2026-04-20T14:30:00Z",
  "timestamp_end": "2026-04-20T14:57:42Z",
  "idea_slug": "auren-compliance",
  "user_slug": "user-slug-example",
  "tier_used": 0,
  "tool_versions": {...},
  "scope_ref": "brand/{slug}/scope",
  "strategy_ref": "brand/{slug}/strategy",
  "verbal_ref": "brand/{slug}/verbal",
  "visual_ref": "brand/{slug}/visual",
  "logo_ref": "brand/{slug}/logo",
  "handoff_ref": "brand/{slug}/handoff",
  "filesystem_path": "output/auren-compliance/brand/",
  "cost_tracking": {
    "image_gen_usd": 0.00,
    "tier": 0,
    "total_cost_usd": 0.00,
    "total_runtime_seconds": 1122
  },
  "coherence_trace": {...}
}
```

## 10.9 brand-contract.md — a escribir en Sprint 0

Archivo: `skills/_shared/brand-contract.md`

Estructura esperada (paralela a `skills/_shared/profile-contract.md`):

```
1. Overview — qué es el contrato
2. Retrieval protocol — how to fetch brand data
3. Invariants — fields siempre disponibles
4. Scope-dependent fields — cuáles varían
5. Claude Design handoff integration — cómo consumer puede triggear Claude Design workflows
6. Staleness detection
7. Multi-version — cómo elegir snapshot
8. Edge cases — brand run failed, partial results
9. Consumption examples — código/pseudocódigo
10. Testing — cómo verificar consumo correcto
```

## 10.10 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Full run completo → todos los topic keys creados
2. Partial re-run → solo dept afectado se actualiza
3. Snapshot v1 + re-run → snapshot v2 creado preservando v1
4. Consumer simulado (mock Launch module) → puede leer brand artifacts vía contract
5. Staleness: brand viejo + validation updated → flagged
6. Contract includes path a Brand Design Document PDF (for Claude Design consumption)

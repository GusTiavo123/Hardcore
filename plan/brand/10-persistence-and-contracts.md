# 10 — Persistencia y Contratos

## 10.1 Propósito

Definir cómo Brand persiste outputs en Engram + filesystem, y cómo módulos futuros (Launch, GTM, Ops) consumen esos outputs vía contratos explícitos.

El contrato refleja los **4 deliverables**: Brand Design Document PDF + Prompts Library + Brand Tokens + Reference Assets.

El contrato autoritativo está en `skills/_shared/brand-contract.md`. Este archivo resume cómo se persisten los outputs y cómo descubrirlos; los detalles del contrato (field-level input map desde Validation + Profile, precedence rules, pre-flight checks) viven en el contract file.

## 10.2 Persistence en Engram

### Topic keys estandarizados

Todos los artifacts viven bajo `brand/{idea-slug}/*`:

| Topic key | Qué contiene | Escribe | Lee (internamente) |
|---|---|---|---|
| `brand/{slug}/scope` | Scope manifest del Paso 0 | Scope Analysis sub-agent | Todos los deptos |
| `brand/{slug}/strategy` | Decisiones estratégicas + sentiment_landscape derivada | Strategy | Verbal, Visual, Logo, Handoff |
| `brand/{slug}/verbal` | Naming + core copy | Verbal | Logo (wordmark+OG), Handoff |
| `brand/{slug}/visual` | Palette + typography + mood + principles | Visual | Logo, Handoff |
| `brand/{slug}/logo` | Manifest + paths a files | Logo | Handoff |
| `brand/{slug}/handoff` | Package manifest + coherence trace | Handoff Compiler | Módulos futuros |
| `brand/{slug}/final-report` | Executive summary | Handoff Compiler | User (via `/brand:show`) + módulos futuros |
| `brand/{slug}/snapshot/v{N}` | Frozen state post-delivery | Handoff Compiler | Auditoría, `/brand:diff` |
| `brand/{slug}/snapshot/validation` | Frozen validation refs at brand time | Orchestrator (pre-flight) | Auditoría |
| `brand/{slug}/snapshot/profile` | Frozen founder_brand_context (si profile existe) | Orchestrator (pre-flight) | Auditoría |

### Convenciones de naming

Siguen `skills/_shared/engram-convention.md`:
- `{idea-slug}` consistente con Validation
- Snapshots `v1`, `v2`, `vN` para versioning
- Upsert behavior para updates dentro de un run

### Estructura del content en Engram

```
**What**: {summary} [brand] [{dept_tag}] [{idea-slug-tag}]
**Why**: {for downstream consumption}
**Where**: {filesystem path si aplica} / {topic_key}
**Data**:
{JSON string of full artifact}
```

### Session lifecycle

Mismo patrón que Validation y Profile:

1. Orchestrator inicia session: `mem_session_start({name: "brand-{slug}-{timestamp}"})`
2. Orchestrator guarda snapshots de Validation + Profile refs en `brand/{slug}/snapshot/validation` y `brand/{slug}/snapshot/profile`
3. Cada dept graba artifacts al completar
4. Handoff Compiler graba final-report + snapshot/v{N}
5. Orchestrator cierra session: `mem_session_end()` + `mem_session_summary()`

## 10.3 Filesystem persistence

`output/{idea-slug}/brand/` contiene los 4 deliverables + README + AUDIT.

**Principios**:
- Filesystem para artifacts grandes (PDF, SVG logos, HTML examples, token files)
- Engram para metadata + manifest + machine-readable data
- Engram referencia paths, NO duplica file contents

Estructura completa en [18-output-package-structure.md](./18-output-package-structure.md).

## 10.4 Contrato de consumo — brand-contract.md

`skills/_shared/brand-contract.md` es el contrato autoritativo. Define:

- Upstream dependencies (Validation requerida, Profile opcional, Claude Pro gate)
- Engram retrieval protocol para Validation + Profile
- Field-level map Validation → Brand (qué campos lee cada Brand dept de cada Validation dept)
- Field-level map Profile → Brand (via `founder_brand_context` projection)
- Completeness threshold (0.4) para modo full vs partial personalization
- Voice precedence rule (archetype > scope.verbal_register > profile)
- Pre-flight checks del orchestrator (Claude Pro, validation verdict, profile hard-nos)
- Rules para Brand depts consuming context (no re-validar, flag propagation, null handling)
- Snapshot protocol
- Module manifest (profile-needs.md para extensibilidad)
- Downstream contract Brand → Claude Design

### Interface de consumo para módulos futuros

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

4. ACCEDER A VERSION ESPECÍFICA:
   latest = mem_search("brand/{idea-slug}/final-report", limit=1)
   v2 = mem_search("brand/{idea-slug}/snapshot/v2")
```

### Qué consumers pueden asumir (invariantes)

**Siempre disponibles** si Brand corrió successfully (todos los gates pasaron):
- `archetype` (string, one of 12 Jung)
- `voice_attributes` (array de 3-5 objetos con definition + do/don'ts)
- `positioning_statement` (string)
- `brand_name` (string)
- `palette.primary` (object con ≥5 colors HEX)
- `typography` (heading + body + mono con Google Fonts imports)
- `logo.primary` (path to SVG)
- **Brand Design Document PDF** (para Claude Design upload)
- **Prompts Library markdown** (para Claude Design projects)
- **Brand Tokens folder** (para codebase integration)
- **Reference Assets folder** (logos + optional mood refs)
- `sentiment_landscape` (string, one of: trust_heavy | disruption_ready | saturation_neutral | low_trust_context | mixed | insufficient_data)

### Qué puede variar (scope-dependent)

- `pitch_deck_prompt` (solo si b2b-enterprise)
- `app_icons_full_set` (solo si b2c-consumer-app con `app_asset_criticality: primary`)
- `manifesto_opening` (solo si community-movement)
- `whatsapp_templates_seed` (solo si b2local-service)
- `podcast_cover_prompt` (solo si content-media con podcast en scope)
- `mood_imagery_refs` (solo si Visual dept los generó; Unsplash free API)

Los consumers deben:
1. Consultar `scope.output_manifest` para saber qué está disponible
2. Gracefully skip si un asset esperado no existe

### Versioning y freshness

- Por default: latest snapshot
- Staleness: si `brand.last_updated` > 180 días, flag
- Invalidation: si Validation/Profile updated después de Brand run, flag "brand may be stale"

### Downstream module use cases (futuros)

**Launch module**:
- Lee `handoff.brand_design_document_path` para package assembly
- Lee `handoff.prompts_library_path` para auto-execute prompts en Claude Design (cuando API exista)
- Lee `logo/primary.svg` para favicon del deploy
- Lee `verbal.core_copy` para meta tags en generated pages

**GTM module**:
- Lee `strategy.target_audience_refined` para audience targeting en ads
- Lee `strategy.voice_attributes` para ad copy consistency
- Lee `verbal.core_copy.value_props` para A/B test variants
- Lee `visual.palette` + `logo` para ad creative

**Ops module**:
- Lee `prompts_library.email_prompts` para setup en email providers
- Lee `verbal.communications.whatsapp_greeting_seed` (si local) para WhatsApp Business
- Lee `verbal.social_bios` para consistency audit

**Future Brand Maintenance module**:
- Lee todo para monitor brand consistency across content over time

## 10.5 Snapshot model (versioning)

Cada run completo produce un snapshot frozen en `brand/{slug}/snapshot/v{N}`.

Contiene full state del run: scope, strategy, verbal, visual, logo, handoff metadata, tool versions, timestamps, evidence traces, coherence trace.

Ver [15-versioning-reproducibility.md](./15-versioning-reproducibility.md) para detalles.

## 10.6 Relación con Validation + Profile

Brand **lee pero no modifica** Validation ni Profile.

Si Validation/Profile se actualizan después de Brand run:
- No invalida Brand retroactively
- Flag staleness cuando futuro module consume
- User puede `/brand:new` para regenerar (crea vN+1)

Pre-flight del orchestrator snapshots Validation + Profile refs en `brand/{slug}/snapshot/validation` + `brand/{slug}/snapshot/profile` para reproducibilidad exacta.

## 10.7 Evidence traces

Cada output de dept incluye `evidence_trace`:

```json
{
  "profile_fields_used": ["..."],
  "validation_depts_used": ["problem", "market", "competitive", "bizmodel", "risk", "synthesis"],
  "scope_modifiers_applied": ["..."],
  "tool_versions": {
    "engram_mcp": "X.Y.Z",
    "open_websearch_mcp": "X.Y.Z",
    "domain_availability_mcp": "X.Y.Z",
    "unsplash_api_tier": "free-demo",
    "pdf_skill": "X.Y",
    "claude_model": "claude-opus-4-7"
  },
  "timestamps": {
    "dept_start": "ISO-8601",
    "dept_end": "ISO-8601"
  }
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
  "user_slug": "user-slug-example | null",
  "validation_snapshot_ref": "brand/{slug}/snapshot/validation",
  "profile_snapshot_ref": "brand/{slug}/snapshot/profile | null",
  "tool_versions": {},
  "scope_ref": "brand/{slug}/scope",
  "strategy_ref": "brand/{slug}/strategy",
  "verbal_ref": "brand/{slug}/verbal",
  "visual_ref": "brand/{slug}/visual",
  "logo_ref": "brand/{slug}/logo",
  "handoff_ref": "brand/{slug}/handoff",
  "filesystem_path": "output/auren-compliance/brand/",
  "cost_tracking": {
    "external_api_cost_usd": 0.00,
    "total_runtime_seconds": 1122
  },
  "coherence_trace": {
    "gates_executed": [],
    "final_state": "all_gates_passed"
  },
  "flags": []
}
```

## 10.9 brand-contract.md — ya escrito

El contrato ya está en `skills/_shared/brand-contract.md`. Estructura:

1. Upstream dependencies (Validation, Profile, Claude Pro)
2. Engram retrieval protocol
3. Validation → Brand field map (per dept)
4. Profile → Brand field map + `founder_brand_context` projection
5. Completeness threshold
6. Voice precedence rule
7. Pre-flight checks
8. Rules for Brand departments consuming context
9. Snapshot protocol
10. Module manifest (profile-needs.md)
11. Downstream contract Brand → Claude Design (formats, subscription requirement)

## 10.10 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Full run completo → todos los topic keys creados, filesystem path existe
2. Partial re-run (ej. `/brand:extend verbal`) → solo dept afectado se actualiza, otros snapshots preservados
3. Snapshot v1 + re-run → snapshot v2 creado preservando v1
4. Consumer simulado (mock Launch module) → puede leer brand artifacts vía contract con datos válidos
5. Staleness: brand viejo + validation updated → flag emitido al consumer
6. Contract includes path a Brand Design Document PDF (para Claude Design consumption)
7. Pre-flight snapshots de validation + profile → readable post-run
8. Coherence gate fail-fast → estado persisted con `status: "halted_by_user_at_gate_{N}"` para permitir `/brand:resume`

# 10 — Persistencia y Contratos

## 10.1 Propósito

Definir cómo Brand persiste outputs en Engram + filesystem, y cómo módulos futuros (Launch, GTM, Ops) pueden consumir esos outputs vía contratos explícitos.

## 10.2 Persistence en Engram

### Topic keys estandarizados

Todos los artifacts de Brand viven bajo el namespace `brand/{idea-slug}/*`:

| Topic key | Qué contiene | Escribe | Lee (internamente) |
|---|---|---|---|
| `brand/{slug}/scope` | Scope manifest del Paso 0 | Orchestrator (Scope Analysis) | Todos los deptos |
| `brand/{slug}/strategy` | Decisiones estratégicas (archetype, voice, positioning, values, promise) | Strategy | Verbal, Visual, Logo, Activation |
| `brand/{slug}/verbal` | Naming artifact + copy artifact completo | Verbal Identity | Logo (wordmark+OG), Activation |
| `brand/{slug}/visual` | Palette + typography + mood + principles | Visual System | Logo, Activation |
| `brand/{slug}/logo` | Manifest de logos + paths a files | Logo & Key Visuals | Activation |
| `brand/{slug}/activation` | Manifest del package entregado + coherence trace | Activation | Módulos futuros |
| `brand/{slug}/final-report` | Executive summary completo del módulo | Activation | User (via `/brand:show`) + módulos futuros |
| `brand/{slug}/snapshot/v{N}` | Frozen state completo post-delivery | Activation | Auditoría, `/brand:diff` |

### Convenciones de naming

Siguen `skills/_shared/engram-convention.md` existente:

- `{idea-slug}` es el mismo slug usado en Validation (consistency cross-módulo)
- Snapshots versionan con `v1`, `v2`, `vN` — auto-increment cuando se re-run completo
- Upsert behavior: si topic key ya existe, nuevo content sobrescribe + graba en revisions

### Estructura del content en Engram

Cada Engram observation sigue el estándar:

```
**What**: {summary line} [brand] [{dept_tag}] [{idea-slug-tag}]
**Why**: {for downstream consumption + persistence of decision}
**Where**: {filesystem path si aplica} / {topic_key}
**Data**:
{JSON string of the full artifact}
```

### Session lifecycle

Similar a Validation pattern (ver `skills/_shared/engram-convention.md`):

1. Orchestrator inicia session: `mem_session_start({name: "brand-{slug}-{timestamp}"})`
2. Cada dept graba sus artifacts during execution
3. Activation graba `final-report` + snapshot
4. Orchestrator cierra session: `mem_session_end()` + `mem_session_summary()`

Session ID embebido en evidence_trace de cada output para reproducibility.

## 10.3 Filesystem persistence

Brand persiste files reales en `output/{idea-slug}/brand/` (ver [08-dept-activation.md](./08-dept-activation.md#65) + [18-output-package-structure.md](./18-output-package-structure.md) para estructura completa).

**Principios**:

- **Filesystem** para artifacts grandes (logos, mood imagery, PDF, HTML/CSS)
- **Engram** para metadata + manifest + machine-readable data
- Engram referencias paths del filesystem pero NO duplica file contents
- Filesystem paths son relativos desde el repo root (portabilidad)

## 10.4 Contratos de consumo (brand-contract.md)

`skills/_shared/brand-contract.md` define cómo cualquier módulo futuro consume Brand artifacts.

Paralelo a `skills/_shared/profile-contract.md` existente para Profile module.

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
   logo_svg = path_base + "logo/source/primary.svg"
   palette_json = parse_json(path_base + "DESIGN.md")
   ...

4. ACCEDER A VERSION ESPECÍFICA (si múltiples snapshots):
   latest_by_default = mem_search("brand/{idea-slug}/final-report", limit=1)
   specific_version = mem_search("brand/{idea-slug}/snapshot/v2")
```

### Qué módulos consumidores pueden assume (invariantes)

Los siguientes campos **siempre estarán disponibles** si Brand corrió successfully:

- `archetype` (string, one of 12 Jung archetypes)
- `voice_attributes` (array of 3-5 objects)
- `positioning_statement` (string)
- `brand_name` (string)
- `palette.primary` (object with 5+ colors HEX)
- `typography` (heading + body fonts con Google Fonts imports)
- `logo.primary` (path to SVG file)

### Qué puede variar (scope-dependent)

Los siguientes son **opcionales** — dependen del scope del original run:

- `pitch_deck_cover` (solo si b2b-enterprise)
- `app_icons_full_set` (solo si b2c-consumer-app)
- `manifesto_document` (solo si community-movement)
- `whatsapp_templates` (solo si b2local-service)
- `podcast_cover` (solo si content-media con podcast)

Los consumers deben:
1. Consultar `scope.output_manifest` para saber qué está disponible
2. Gracefully skip si un asset esperado no existe

### Versioning y freshness

Los consumers deben:
1. Por default, consumir el **latest snapshot** (highest vN)
2. Detectar **staleness**: si `brand.last_updated` > 180 days, flag al user ("tu brand data tiene 6 meses — considerar regenerar")
3. Respetar **invalidation**: si Validation o Profile se updatearon después de Brand, flag "brand may be stale relative to validation/profile"

### Downstream module use cases (futuros)

Ejemplos de cómo Launch, GTM, Ops consumirían:

**Launch module**:
- Lee `activation.microsite` para deploy
- Lee `activation.brand_book_pdf` para team onboarding
- Lee `activation.social` para schedule launch posts
- Lee `verbal.press_release_boilerplate` si scope lo incluye

**GTM module** (Go-to-Market):
- Lee `strategy.target_audience_refined` para audience targeting
- Lee `strategy.voice_attributes` para ad copy
- Lee `verbal.value_props` para A/B test variants
- Lee `visual.palette` + `logo` para ad creative

**Ops module**:
- Lee `verbal.email_templates` para set up en email provider
- Lee `verbal.whatsapp_templates` (si local) para WhatsApp Business
- Lee `verbal.communications.bios` para consistency en profiles

## 10.5 Snapshot model (versioning)

Cada run completo de Brand produce un **snapshot** frozen:

```
brand/{slug}/snapshot/v1 — primer run
brand/{slug}/snapshot/v2 — segundo run (después de re-run completo)
brand/{slug}/snapshot/v3 — etc.
```

Un snapshot contiene **todo el state** del run:
- Scope manifest
- Strategy output
- Verbal output
- Visual output
- Logo output (metadata — files siguen en filesystem)
- Activation manifest
- Tool versions, timestamps
- Evidence traces completos

Permite:
- Reproducir exactamente el run (si tools/inputs disponibles)
- Comparar entre runs (`/brand:diff v1 v2`)
- Rollback (volver a v1 si v2 es peor)
- Analytics históricos (cómo evolucionó la marca)

### Partial re-runs (extend mode)

`/brand:extend {depto}` regenera SOLO ese dept, keeping downstream aligned:

- Ejemplo: `/brand:extend logo` regenera logo con nuevos prompts
- Ejemplo: `/brand:extend verbal.naming` regenera solo naming (keeping copy)

**Partial re-runs NO crean nuevo snapshot vN** — solo actualizan el topic key del dept afectado. El snapshot es para runs completos.

**Tracking de partial re-runs**: Engram graba en `brand/{slug}/{dept}` con revision count incremented.

## 10.6 Relación con Validation + Profile

Brand **lee pero no modifica** Validation ni Profile.

- Validation artifacts: `validation/{slug}/*` (unchanged)
- Profile artifacts: `profile/{user-slug}/*` (unchanged)

Si Validation o Profile se actualizan después de Brand run:
- No invalida el Brand run retroactivamente
- Pero flagea staleness cuando futuro módulo consume Brand
- User puede `/brand:new` para regenerar con inputs actualizados (crea vN+1)

## 10.7 Evidence traces

Cada output de dept incluye `evidence_trace`:

```json
{
  "profile_fields_used": [...],
  "validation_depts_used": [...],
  "scope_modifiers_applied": [...],
  "tool_versions": {
    "stitch_mcp": "0.3.2",
    "recraft_v4": "latest",
    "huemint_api": "v1"
  },
  "timestamps": {...}
}
```

Esto permite auditoría: "¿Por qué el archetype es Sage? → evidence_trace dice fue derivado de profile.identity + validation.competitive white space + scope.archetype_constraints."

## 10.8 Snapshot file layout (Engram)

```json
{
  "schema_version": "1.0",
  "snapshot_version": "v1",
  "timestamp_start": "2026-04-20T14:30:00Z",
  "timestamp_end": "2026-04-20T14:57:42Z",
  "idea_slug": "auren-compliance",
  "user_slug": "user-slug-example",
  "tool_versions": {...},
  "scope_ref": "brand/{slug}/scope",
  "strategy_ref": "brand/{slug}/strategy",
  "verbal_ref": "brand/{slug}/verbal",
  "visual_ref": "brand/{slug}/visual",
  "logo_ref": "brand/{slug}/logo",
  "activation_ref": "brand/{slug}/activation",
  "filesystem_path": "output/auren-compliance/brand/",
  "cost_tracking": {
    "image_gen_usd": 0.73,
    "stitch_generations_used": 5,
    "total_runtime_seconds": 1662
  },
  "coherence_trace": {...}
}
```

## 10.9 brand-contract.md — lo que Sprint 0 debe escribir

Archivo: `skills/_shared/brand-contract.md`

Estructura esperada (paralela a `skills/_shared/profile-contract.md`):

```
1. Overview — qué es el contrato
2. Retrieval protocol — how to fetch brand data
3. Invariants — fields siempre disponibles
4. Scope-dependent fields — cuáles varían
5. Staleness detection — cómo detectar
6. Multi-version — cómo elegir snapshot
7. Edge cases — brand run failed, partial results
8. Consumption examples — código/pseudocódigo
9. Testing — cómo verificar que un módulo consuma correctamente
```

## 10.10 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Full run completo → todos los topic keys creados correctamente
2. Partial re-run → solo dept afectado se actualiza
3. Snapshot v1 + re-run → snapshot v2 creado preservando v1
4. Consumer simulado (mock Launch module) → puede leer brand artifacts vía contract
5. Staleness detection: brand run antiguo + validation updated → flagged

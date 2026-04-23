# 17 — Costo y Timing

## 17.1 Propósito

Budget detallado por run + timing estimado.

**Nota**: timing numbers son baselines estimados. Sprint 1 calibra con real runs. Cost es fijo: $0 en APIs externas.

## 17.2 Cost por run

| Componente | Costo | Volumen típico |
|---|---|---|
| Engram MCP | Free | N reads/writes |
| open-websearch MCP | Free | 15-25 queries (TM + sentiment) |
| `imprvhub/mcp-domain-availability` | Free | 1 bulk call (10-12 domains) |
| Unsplash free API | Free (commercial-safe con attribution) | 3-6 fetches |
| `ms-office-suite:pdf` skill | Free | 1 PDF |
| Claude native (SVG gen + palette + copy + reasoning) | Incluido en subscription | ~80-120K tokens |
| **Total por run en APIs externas** | — | **$0.00** |

**Dependencia paga asociada**: suscripción Claude Pro/Max/Team/Enterprise del user final (gate obligatorio, no facturable por Hardcore).

El módulo no genera variabilidad de costo por idea, profile ni scope — todos los runs consumen $0 en APIs externas.

## 17.3 Cost tracking en audit

Cada run graba en `audit.cost_tracking` para observabilidad:

```json
{
  "external_api_cost_usd": 0.00,
  "claude_reasoning_tokens_estimated": 85000,
  "engram_operations": 24,
  "web_search_queries": 18,
  "domain_checks": 12,
  "tm_screening_queries": 6,
  "unsplash_fetches": 4,
  "pdf_generations": 1,
  "claude_svgs_generated": 4
}
```

## 17.4 Timing por paso — baseline

Normal mode (con checkpoints mid-run):

| Paso | Tiempo |
|---|---|
| Setup + Engram retrieval + pre-flight checks | 30-60s |
| Scope Analysis (sub-agent) | 1-2 min |
| ① Strategy | 2-3 min |
| ② Verbal Identity (paralelo con ③) | 5-7 min |
| ③ Visual System (paralelo con ②) | 2-3 min |
| ④ Logo & Key Visuals | 3-4 min |
| ⑤ Handoff Compiler | 3-5 min |
| **Total** | **15-20 min** |

El paralelismo Verbal ∥ Visual mantiene el total en ~15-20 min. Sin paralelismo serían ~22-28 min.

## 17.5 Timing por brand profile

Cada profile tiene diferente volumen de output; timing ajustado:

| Brand profile | Normal mode | Observaciones |
|---|---|---|
| `b2b-enterprise` | **20-25 min** | Pitch deck cover + case study template + security/compliance copy agregan ~5 min a Verbal. Brand Document con página extra enterprise-specific |
| `b2b-smb` | **15-20 min** | Matches baseline |
| `b2d-devtool` | **15-20 min** | Similar a b2b-smb. Extra en GitHub README + CLI aesthetic, compensado con menos social prompts |
| `b2c-consumer-app` | **18-22 min** | App icon set + app store templates + onboarding copy agregan a Handoff Compiler. Más user interaction en selections |
| `b2c-consumer-web` | **15-20 min** | Matches baseline |
| `b2local-service` | **10-15 min** | Scope reducido: sin pitch deck, sin TikTok, sin enterprise. Prompts library más corta. Brand Document minimal. WhatsApp templates son punchy |
| `content-media` | **18-24 min** | Podcast cover + video thumbnails series + newsletter template + merch direction agregan a Handoff Compiler |
| `community-movement` | **22-30 min** | Manifesto opening es long-form (Verbal toma ~10 min vs 5-7), symbolic assets prompts + Discord branding agregan tiempo. Handoff Compiler con página del manifesto substancial |

**Insights**:
- `b2local-service` es el más rápido (scope compacto)
- `community-movement` el más lento (manifesto + symbolic focus)
- `b2b-enterprise` agrega tiempo por pitch deck + compliance copy

## 17.6 Timing en fast mode

Fast mode (`/brand:fast`) skippea mid-run checkpoints pero mantiene final review. Reduce ~20% del total:

| Brand profile | Fast mode |
|---|---|
| `b2b-enterprise` | 15-20 min |
| `b2b-smb` | 12-16 min |
| `b2d-devtool` | 12-16 min |
| `b2c-consumer-app` | 14-18 min |
| `b2c-consumer-web` | 12-16 min |
| `b2local-service` | 8-12 min |
| `content-media` | 14-18 min |
| `community-movement` | 18-24 min |

## 17.7 User interaction wait times (normal mode)

Tiempo en el que el user responde checkpoints (no computable automáticamente; depende del user):

- Scope confirmation: 30s - 2 min
- Strategy review: 30s - 1 min
- Naming selection: 1 - 3 min
- Logo selection: 1 - 3 min
- Final pre-delivery review: 1 - 2 min

Total user time: **3-10 min** adicionales al compute time.

## 17.8 Factores que modifican timing

**Aumentan tiempo**:
- Network latency (open-websearch, domain MCP, Unsplash, TM screening)
- User indecision en checkpoints
- Gate failures que disparan re-runs parciales (ver fail-fast protocol en 09)
- Tool failures + retries
- Scope `community-movement` (manifesto long-form)

**Reducen tiempo**:
- Fast mode (skip mid-checkpoints)
- Cached outputs en partial re-runs (`/brand:extend`)
- Scope `b2local-service` (scope compacto)
- Paralelismo Verbal ∥ Visual

## 17.9 Context timing (comparativa)

| Opción | Tiempo |
|---|---|
| Designer tradicional | days - weeks |
| Branding agency | weeks - months |
| DIY con templates + tools gratis | hours - days |
| **Hardcore Brand** | **15-30 min** |

## 17.10 Timing alerts durante run

El orchestrator surface events en tiempo real:

- Mayor dept completions ("Strategy completo en 2:34")
- Si un paso excede expectativa +50%: *"⚠ Este paso está tomando más de lo esperado (esperado ~3 min, actual ~5 min). Esperar o cancelar?"*
- Si total excede 60 min: alert + option to cancel o `/brand:resume` más tarde

## 17.11 Calibration Sprint 1

Track actual timing en `testing/brand-runs/*/test-results.yaml`:

```yaml
timing_actual_seconds: 1042
timing_estimated_seconds: 1080
timing_variance_pct: -3.5

breakdown_per_step:
  setup: 42
  scope_analysis: 68
  strategy: 158
  verbal: 355
  visual: 158
  logo: 195
  handoff: 285
  user_interaction: 85

cost_actual_usd: 0.00
external_api_calls:
  engram: 24
  open_websearch: 18
  domain_mcp: 1
  unsplash: 4
  pdf_skill: 1
```

Si variance > 25% consistentemente en un paso específico, reassess estimate en este doc.

## 17.12 Economics — implicaciones pricing

### Cost per user

Cada run consume **$0 en APIs externas**. Variable cost por user = $0 independientemente del volumen.

La única cost de Hardcore es el compute del host del módulo (servidor/infra donde corre Claude Code + Engram), pero eso es fixed cost, no per-run.

### Freemium economics

| Escenario | Users/mes | Variable cost Brand | Revenue ($29/mo paid tier) | Margin |
|---|---|---|---|---|
| Launch | 100 free + 10 paid | $0 | $290 | ~100% (menos infra fixed) |
| Growth | 500 free + 100 paid | $0 | $2,900 | ~100% |
| Scale | 1000 free + 500 paid | $0 | $14,500 | ~100% |

El módulo Brand es gratis para Hardcore opera. El user aporta su suscripción Claude Pro (no split con Hardcore).

### Comentario sobre pricing en el plan

Estas cifras son referenciales y no comprometen la estrategia GTM. El módulo puede ser freemium sin que fuga de gross margin por APIs. El verdadero cost floor son los costos fijos del servidor y la mantención del producto.

## 17.13 Latency contributors (para optimización futura)

Top contribuyentes en orden:

1. **open-websearch queries** (TM screening + sentiment derivation): ~10-20s por query × 10-15 queries = ~150-300s en total. Paralelización reduce a ~30-60s.
2. **Claude native SVG** (Logo dept): ~10-20s por logo × 3-5 logos = ~30-100s.
3. **Claude reasoning** (Strategy + Verbal naming): ~60-120s cada uno.
4. **Domain MCP bulk**: ~5-10s (bajo impacto).
5. **Unsplash**: <5s.
6. **PDF generation**: ~10-30s.

Optimización principal v1: paralelizar TM queries dentro de Verbal dept. Optimizaciones adicionales post-v1 si se justifican por data.

## 17.14 Reference file a escribir en Sprint 0

Los cost y timing se trackean en el envelope `audit` de cada dept y el final report. No requiere un archivo `budget-tracking.md` separado — el tracking queda en:

- Output envelope (per dept, `audit.cost_tracking` y `audit.timing`)
- Final report (`brand/{slug}/final-report` en Engram agrega totales)
- Test results (`testing/brand-runs/*/test-results.yaml`)

## 17.15 Reglas de los caps

No hay caps. El módulo corre end-to-end sin throttle porque el costo variable es $0 y el timing tiene límite natural por el scope.

Si un run se pasa de 60 min (caso extremo por failures múltiples), el orchestrator ofrece `/brand:resume` en vez de abortar.

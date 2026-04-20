# 17 — Costo y Timing

## 17.1 Propósito

Budget detallado de costo por run + timing estimado. Informa pricing strategy de Hardcore y decisiones de arquitectura.

## 17.2 Cost per run — detallado

### Breakdown por tool

| Componente | Costo unitario | Volumen típico | Subtotal |
|---|---|---|---|
| **Engram MCP** | Free | N reads/writes | $0.00 |
| **open-websearch MCP** | Free | 10-15 queries (TM check) | $0.00 |
| **`imprvhub/mcp-domain-availability`** | Free | 1 bulk call | $0.00 |
| **Huemint API** | Free non-commercial | 1-2 calls | $0.00 |
| **Stitch MCP** | Free (350/mes tier) | 4-7 screens | $0.00 |
| **`ms-office-suite:pdf` skill** | Free | 1 PDF | $0.00 |
| **Recraft V4 — mood imagery** | $0.04/img | 6-8 imgs | $0.24 – $0.32 |
| **Recraft V4 — logo concepts** | $0.04/img | 4-5 imgs | $0.16 – $0.20 |
| **Recraft V4 — logo variants** | $0.04/img | 3-4 imgs (mono, inverse, icon-only) | $0.12 – $0.16 |
| **Recraft V4 — derivations** | $0.04/img | 0-8 imgs (depende scope) | $0.00 – $0.32 |
| **Claude reasoning (tokens)** | Included in subscription | ~50-80K tokens | Absorbido |

### Total cost por brand profile

Varía según scope complexity:

| Brand profile | Image gen count | Cost estimated |
|---|---|---|
| `b2b-enterprise` | ~20 imgs (mood 8 + logo 5 + variants 4 + derivations 3) | ~$0.80 |
| `b2b-smb` | ~17 imgs (mood 6 + logo 5 + variants 4 + derivations 2) | ~$0.68 |
| `b2d-devtool` | ~15 imgs (mood 6 + logo 4 + variants 3 + derivations 2) | ~$0.60 |
| `b2c-consumer-app` | ~28 imgs (mood 6 + logo 5 + variants 4 + app icon set 10 + derivations 3) | ~$1.12 |
| `b2c-consumer-web` | ~17 imgs (mood 6 + logo 5 + variants 4 + derivations 2) | ~$0.68 |
| `b2local-service` | ~15 imgs (mood 6 + logo 4 + variants 3 + derivations 2) | ~$0.60 |
| `content-media` | ~18 imgs (mood 8 + logo 4 + variants 3 + merch 3) | ~$0.72 |
| `community-movement` | ~17 imgs (mood 6 + logo 4 + variants 4 + symbolic + merch 3) | ~$0.68 |

**Rango general: $0.60 - $1.12 per run**.

### Cost variables

Cost up:
- User regenerations (pedir más options de logo, regen copy) — cada round agrega image gens
- Retries por failures (prompt no devuelve quality) — max 2-3 retries per gen
- Coherence gate failures requiring regens

Cost down:
- Fast mode (fewer user interactions = fewer regen requests)
- Scope compacto (b2d-devtool tiende a menos derivations)
- Cached reuse in partial re-runs

### Cost tracking

Cada run graba en `audit.cost_tracking`:

```json
{
  "image_gen_usd": 0.73,
  "stitch_generations_used": 5,
  "stitch_remaining_quota": 345,
  "domain_checks": 12,
  "tm_searches": 12,
  "pdf_generations": 1,
  "total_image_count": 18,
  "total_cost_usd": 0.73,
  "cost_breakdown": {
    "mood_imagery": 0.32,
    "logo_concepts": 0.20,
    "logo_variants": 0.16,
    "logo_derivations": 0.05
  }
}
```

### Cost caps

Sanity checks:
- **Per-run max**: $5 (10× typical budget). If approaching, alert user
- **Per-day max per user**: $20 (for freemium users — prevent accidents)
- **Per-month max per user**: configurable por tier (freemium, paid tier)

Exceder el cap → alert + pause run, user confirms antes de continuar.

## 17.3 Timing por paso

### Normal mode

| Paso | Tiempo estimado | Operaciones dominantes |
|---|---|---|
| Setup + Engram retrieval | 30-60s | I/O reads, parsing |
| Scope Analysis (inline) | 1-2 min | Razonamiento + user confirm if low confidence |
| ① Strategy | 2-3 min | Razonamiento puro + Engram writes |
| ② Verbal (paralelo con ③) | 5-7 min | Domain check I/O + TM screening I/O + copy gen |
| ③ Visual System (paralelo) | 3-5 min | Huemint call + Recraft mood gens (6-8) |
| ④ Logo | 4-6 min | Recraft logo gens + user selection + variants + derivations |
| ⑤ Activation | 5-8 min | Stitch gens + coherence gates + PDF gen + packaging |
| **Total** | **20-30 min** | |

### Fast mode

Sin user interaction waits:
- Pasos 1-5 en ~15-20 min total
- Razonamiento similar pero sin pauses esperando user input

### User interaction wait times

En Normal mode, el user introduce delays:
- Scope confirmation: 30s-2min (user reads + responds)
- Strategy review: 30s-1min (accept default vs overrride)
- Naming selection: 1-3min (user compares top 5)
- Logo selection: 1-3min (user compares 4-5 concepts)

**Total user interaction time**: 3-9 min típicamente.

### Factors que affectan timing

Up (slower):
- Network latency (Recraft API, Stitch, Huemint, domain check)
- User indecision en interaction points
- Coherence gate regenerations
- Tool failures y retries

Down (faster):
- Fast mode
- Cached outputs en partial re-runs
- Stitch's 350 free tier usually fast
- Strong signals upstream (clear validation + profile) reduce reasoning time

## 17.4 Economics — pricing strategy implications

### Cost per user (free tier)

Freemium: 1 brand gratis por user. Absorbe costo ~$0.80.

Si 1000 users sign up → $800 de costo de acquisition. Marketing-equivalent.

### Cost per paid user

Paid tier (hypothetical $29/mes):
- Usuario típico run Brand 2-3× por mes (al iterar su idea)
- Cost: $1.60 - $2.40 per user per mes
- Revenue: $29/mes
- Gross margin: ~92%

Brand es highly profitable per user una vez pagan.

### Cost scenarios

| Usuarios/mes | Cost est. | Revenue est. | Gross margin |
|---|---|---|---|
| 100 free + 10 paid | $80 + $24 = $104 | $290 | 64% |
| 500 free + 100 paid | $400 + $240 = $640 | $2,900 | 78% |
| 1000 free + 500 paid | $800 + $1,200 = $2,000 | $14,500 | 86% |

Como el usage scales, margin improves (paid user revenue dwarfs free user cost).

### Stitch free tier consideration

350 generations/mes free. Cada Brand run usa 4-7 Stitch generations. Max runs que caben en free tier: **50-87 runs/mes**.

Past that:
- Option A: wait for Stitch to exit Labs (Q4 2026) con paid tier ($10-15/mes estimated)
- Option B: fallback a manual HTML templates en runs que excedan quota
- Option C: upgrade when Stitch has commercial tier

**Impact on pricing**: el precio de Hardcore's Brand feature debe absorber ~$0.80 variable cost + eventual Stitch commercial tier cost.

## 17.5 Cost optimization opportunities

### Opportunities identified

1. **Cache visual imagery if archetype unchanged**: si user re-run Brand en same idea pero only Strategy changed, reuse mood imagery y logos. Savings: ~$0.50/run en extend mode.

2. **Batch image generations**: single API call con multiple images vs multiple single calls. Reduces overhead pero minor cost savings.

3. **Lower-cost mood imagery**: podríamos usar Flux Schnell ($0.03) vs Recraft ($0.04) para mood, dado que mood no necesita SVG ni logo-specialization. Savings: ~$0.08/run en mood imagery.
   - **Decisión**: no hacer en v1 por simplicity del stack. Considerar en v2 si costs scale.

4. **Stitch free tier maximization**: instead de generar 7 screens, generate 4-5 core y derive otros via composition. Savings: Stitch quota preservation.

### Not optimizing in v1

Trade-off: optimization adds complexity. v1 prioritiza simplicity + wow over cost optimization. Revisit con data real.

## 17.6 Latency optimization

Tools que contribuyen más a latency:

1. **Recraft V4**: ~5-15s per image × 15-20 imgs = 75-300s total (serial)
   - **Opportunity**: batch/parallel calls where supported
2. **Stitch**: ~15-30s per screen × 5 screens = 75-150s
3. **Huemint**: <5s (fast)
4. **Domain MCP**: ~5-10s bulk
5. **TM screening via open-websearch**: ~10-20s per query × 10 candidates = 100-200s
   - **Opportunity**: parallel web search queries

Total sin parallelization: ~8-15 min of pure API time + Claude reasoning overhead.

Con parallelization: ~5-8 min API time.

## 17.7 Acceptable timing tradeoffs

The user expects "25-30 min for a full brand package" — this is actually fast compared to:
- Designer: days-weeks
- Branding agency: weeks-months
- DIY: hours-days

25-30 min is a wow factor, not a concern. No aggressive timing optimization needed for v1.

## 17.8 Timing alerts

Durante ejecución, user ve progress updates:
- Every major dept completion: "[X:XX] ④ Logo ready..."
- Si un step excede expectativa: "⚠ Este paso está tomando más de lo esperado (Recraft API slow), continuando..."
- Si total run excede 60 min: alert al user, offer to cancel + resume later

## 17.9 Reference file a escribir en Sprint 0

`skills/brand/references/budget-tracking.md` con:
- Cost tracking schema
- Per-profile cost estimates
- Timing estimates
- Acceptable ranges y alerts
- Optimization strategies (future)

## 17.10 Testing cost + timing

Track per test run:
- Actual cost vs estimated
- Actual timing vs estimated
- Variance por profile

Report en `testing/brand-runs/*/test-results.yaml`:

```yaml
cost_actual_usd: 0.78
cost_estimated_usd: 0.68
cost_variance: 15%

timing_actual_seconds: 1742
timing_estimated_seconds: 1500
timing_variance: 16%

breakdown_per_step:
  setup: 45s
  scope: 72s
  strategy: 165s
  verbal: 380s
  visual: 220s
  logo: 295s
  activation: 465s
  user_interaction: 100s
```

Si consistente variance > 25%, reassess estimates.

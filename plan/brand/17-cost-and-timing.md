# 17 — Costo y Timing (Tier-based)

## 17.1 Propósito

Budget detallado por run + timing estimado.

**Nota**: timing numbers son baselines estimados — Sprint 1 calibra con real runs. Cost numbers están basados en API pricing oficial.

## 17.2 Cost per run — por tier

### Tier 0 (DEFAULT) — Zero cost

| Componente | Costo | Volumen típico | Subtotal |
|---|---|---|---|
| Engram MCP | Free | N reads/writes | $0.00 |
| open-websearch MCP | Free | 10-15 queries (TM) | $0.00 |
| `imprvhub/mcp-domain-availability` | Free | 1 bulk call | $0.00 |
| `ms-office-suite:pdf` skill | Free | 1 PDF | $0.00 |
| Claude native (SVG gen + palette + reasoning) | Incluido subscription | ~80-120K tokens | Absorbido |
| **Total Tier 0** | — | — | **$0.00** |

### Tier 1 — Minimal paid usage

| Componente | Costo unitario | Volumen | Subtotal |
|---|---|---|---|
| Todo Tier 0 | | | $0.00 |
| Recraft V4 (symbolic logos only) | $0.04/img | 3-5 imgs | $0.12-0.20 |
| Unsplash API (mood refs) | Free tier | 6-8 fetches | $0.00 |
| Huemint API (palette ML) | Free non-commercial | 1 call | $0.00 |
| **Total Tier 1** | — | — | **$0.12-0.20** |

### Tier 2 — Premium quality

| Componente | Costo | Volumen | Subtotal |
|---|---|---|---|
| Todo Tier 1 base | | | $0.00-0.20 |
| Recraft V4 (all logos) | $0.04/img | 10-14 imgs | $0.40-0.56 |
| Recraft V4 (mood generated) | $0.04/img | 6-8 imgs | $0.24-0.32 |
| Huemint paid license | ~$10-50/mo (pending negotiation) | N/A | amortized over many runs |
| **Total Tier 2 per run** | — | — | **~$0.64-0.88** |

## 17.3 Cost por brand profile × tier

Matriz de cost esperado por combinación:

| Brand profile | Tier 0 | Tier 1 (auto-elevated if required) | Tier 2 |
|---|---|---|---|
| `b2b-enterprise` | $0.00 | ~$0.16 (si Recraft wordmark refinado) | ~$0.64 |
| `b2b-smb` | $0.00 | — (Tier 0 suficiente típicamente) | ~$0.60 |
| `b2d-devtool` | $0.00 (wordmark) — **aceptable mayoría casos** | $0.16 (si scope symbolic-first) | ~$0.64 |
| `b2c-consumer-app` | **Possible pero quality limitada** (app icon a 16×16 challenging con Claude SVG) | $0.28 (auto-elevated: 4 symbolic concepts + iOS/Android icon set regens + OG card) | ~$0.80 |
| `b2c-consumer-web` | $0.00 | $0.16 (opcional mood imagery) | ~$0.68 |
| `b2local-service` | $0.00 — **minimal scope, Tier 0 ideal** | — (rara vez necesario) | ~$0.56 (raramente justified) |
| `content-media` | $0.00 para newsletter-focused · **$0.20-0.28 para podcast/video-focused** (auto-eleva para podcast cover quality) | $0.20-0.28 | ~$0.72 |
| `community-movement` | $0.00 para text-heavy (manifesto) · **$0.16-0.20 si symbolic assets importan mucho** | $0.16-0.20 | ~$0.68 |

**Nota sobre `b2c-consumer-app` Tier 0**: es possible pero limitado. Apps con wordmark logo minimalista (Notion, Linear mobile style) funcionan Tier 0. Apps con identity primarily icon-driven (Duolingo owl, Tinder flame) necesitan Tier 1+.

**Rango general**: **$0.00 - $0.80 per run** dependiendo de tier + profile.

## 17.4 Insight clave

Tier 0 es completamente free y suficiente para dogfooding + early stage. Tier 1 para quality mejorada en casos específicos. Tier 2 solo para premium.

## 17.5 Cost variables

Cost up:
- User regenerations
- Retries por failures
- Coherence gate failures requiring regens
- Tier elevations durante run

Cost down:
- Fast mode (fewer regen requests)
- Scope compacto
- Cached reuse en partial re-runs

## 17.6 Cost tracking

Cada run graba en `audit.cost_tracking`:

```json
{
  "tier_used": 0,
  "image_gen_usd": 0.00,
  "image_gen_count": 0,
  "image_gen_breakdown": {
    "claude_native_svgs": 4,
    "recraft_logos": 0,
    "recraft_mood": 0,
    "unsplash_fetches": 0,
    "huemint_calls": 0
  },
  "domain_checks": 12,
  "tm_searches": 12,
  "pdf_generations": 1,
  "total_cost_usd": 0.00,
  "claude_reasoning_tokens_estimated": 85000
}
```

## 17.7 Cost caps

- **Per-run max**: $5 (10× typical Tier 2)
- **Per-day max per user**: $20 (freemium protection)
- **Per-month max per user**: configurable por tier

Exceder cap → alert + pause, user confirms antes de continuar.

## 17.8 Timing por paso

Estimaciones baseline basadas en API latency típica + Claude reasoning. Sprint 1 calibra con real runs.

### Normal mode — baseline Tier 0

| Paso | Tier 0 | Tier 1 | Tier 2 |
|---|---|---|---|
| Setup + Engram retrieval | 30-60s | 30-60s | 30-60s |
| Scope Analysis (inline) | 1-2 min | 1-2 min | 1-2 min |
| ① Strategy | 2-3 min | 2-3 min | 2-3 min |
| ② Verbal (paralelo con ③) | 5-7 min | 5-7 min | 5-7 min |
| ③ Visual System (paralelo) | 2-3 min | 3-5 min | 4-6 min |
| ④ Logo | 3-4 min | 4-6 min | 5-8 min |
| ⑤ Handoff Compiler | 3-5 min | 3-5 min | 3-5 min |
| **Total** | **15-20 min** | **18-25 min** | **22-30 min** |

### Normal mode — per brand profile

Diferentes profiles tienen diferente volumen de output que afecta timing:

| Brand profile | Tier 0 estimated | Why distinto de baseline |
|---|---|---|
| `b2b-enterprise` | **20-25 min** | Pitch deck cover + case study template + security/compliance copy agregan ~5 min a Verbal. Brand Document tiene página extra enterprise-specific |
| `b2b-smb` | **15-20 min** (baseline) | Matches el baseline. El profile que usamos para estimaciones iniciales |
| `b2d-devtool` | **15-20 min** | Similar a b2b-smb. Bit extra en Verbal (GitHub README, CLI aesthetic). Balanced out con menos social prompts |
| `b2c-consumer-app` | **20-28 min** (Tier 1+ típico) | App icon set genera 8-10 extra images (Tier 1+). App store templates + onboarding screens agregan Handoff Compiler time. Más user interaction en selections |
| `b2c-consumer-web` | **15-20 min** | Matches baseline |
| `b2local-service` | **10-15 min** ⚡ | **Más rápido**: scope reducido (no pitch deck, no TikTok, no enterprise), prompts library más corta, Brand Document minimal. WhatsApp templates son punchy |
| `content-media` | **18-24 min** | Podcast cover prompt + video thumbnails series + newsletter template + merch direction agregan Handoff Compiler time |
| `community-movement` | **22-30 min** | **Más lento**: manifesto opening es long-form (Verbal toma ~10 min vs 5-7), symbolic assets prompts + Discord branding prompts agregan tiempo. Handoff Compiler page del manifesto es substantial |

**Insights**:
- `b2local-service` es más rápido de lo que baseline sugería (scope compacto)
- `community-movement` es más lento (manifesto + symbolic focus)
- `b2c-consumer-app` agrega tiempo por app icon generation (Tier 1+)
- `b2b-enterprise` agrega tiempo por pitch deck + case study assets

### Fast mode — per profile

| Brand profile | Tier 0 fast |
|---|---|
| `b2b-enterprise` | 15-18 min |
| `b2b-smb` | 12-15 min |
| `b2d-devtool` | 12-15 min |
| `b2c-consumer-app` | 15-22 min (Tier 1 typical) |
| `b2c-consumer-web` | 12-15 min |
| `b2local-service` | 8-12 min ⚡ |
| `content-media` | 14-18 min |
| `community-movement` | 18-24 min |

### Calibration plan Sprint 1

Track actual timing en `testing/brand-runs/*/test-results.yaml`:
- Field: `timing_actual_seconds_per_dept`
- Compare to estimated
- After 3+ runs per profile, update este doc con calibrated numbers

### User interaction wait times (Normal)

- Scope confirmation: 30s-2min
- Strategy review: 30s-1min
- Naming selection: 1-3min
- Logo selection: 1-3min
- Tier elevation prompt (si aplica): 30s-1min

Total user time: 3-10 min.

## 17.9 Factors affecting timing

Up (slower):
- Network latency (Recraft, Huemint, domain, web search)
- User indecision
- Coherence gate regens
- Tool failures + retries
- Tier elevations mid-run

Down (faster):
- Fast mode
- Cached outputs en partial re-runs
- Tier 0 (no external API latency)

## 17.10 Acceptable timing tradeoffs

- Designer traditional: days-weeks
- Branding agency: weeks-months
- DIY: hours-days
- **Hardcore Brand**: 15-30 min

Wow factor preserved incluso en Tier 0 (15-20 min).

## 17.11 Timing alerts

Durante ejecución:
- Major dept completions
- Si step excede expectativa: "⚠ Este paso está tomando más..."
- Si total > 60 min: alert + option to cancel + resume

## 17.12 Economics — pricing strategy implications

### Cost per user (freemium)

Freemium: 1 brand gratis. Absorbe $0-$0.80 según tier del user.

**Tier 0 freemium** (recommended): user corre en Tier 0 default, cost $0. Upgrade prompt si necesita symbolic logos.

1000 users freemium Tier 0 default → $0 marketing cost. Tier 1 opt-ins: ~10% tal vez → $20 total month.

### Cost per paid user

Paid tier (hypothetical $29/mo):
- User corre Brand 2-3×/mes
- Tier 0 most users: $0 variable cost
- Tier 1 opt-in heavy users: $0.20 × 3 = $0.60/mo
- Gross margin: ~98%

Brand es highly profitable per user una vez pagan.

### Cost scenarios

| Usuarios/mes | Tier 0 usage | Tier 1 opt-ins | Est cost | Est revenue ($29/mo paid) | Margin |
|---|---|---|---|---|---|
| 100 free + 10 paid | 95% Tier 0 | 5% Tier 1 | $5 | $290 | **98%** |
| 500 free + 100 paid | 90% Tier 0 | 10% Tier 1 | $30 | $2,900 | **99%** |
| 1000 free + 500 paid | 85% Tier 0 | 15% Tier 1 | $100 | $14,500 | **99.3%** |

Margins altos porque la mayoría de users corre en Tier 0 (zero variable cost).

### Huemint commercial license consideration

Cuando Hardcore lance comercial, Huemint requires commercial license ($10-50/mo estimated). Amortized over monthly runs es trivial ($0.001-0.005 per run).

Alternative: fallback to Claude-generated palette para commercial users en Tier 0 (zero-cost compliance).

## 17.13 Cost optimization opportunities

Opportunities:
1. **Cache visual assets si archetype unchanged**: partial re-runs reuse → savings en extend mode
2. **Batch Recraft calls** (si supported): reduce API overhead
3. **Lower-cost palette** (Colormind) como fallback si Huemint caro después

**No optimizing en v1**: simplicity + wow > cost optimization. Revisit with data.

## 17.14 Latency optimization

Top latency contributors:
1. **Recraft V4** (Tier 1+): ~5-15s per image × N imgs
2. **Claude native SVG** (Tier 0): ~10-20s per logo (faster than Recraft since no API round-trip)
3. **Huemint** (Tier 1+): <5s
4. **Domain MCP**: ~5-10s bulk
5. **TM screening**: ~10-20s per query × 10 candidates = 100-200s (biggest contributor)

Opportunity: parallelize TM queries.

## 17.15 Reference file a escribir en Sprint 0

`skills/brand/references/budget-tracking.md` con:
- Cost tracking schema per tier
- Timing estimates per tier
- Acceptable ranges + alerts
- Optimization strategies (future)
- Tier degradation cost implications

## 17.16 Testing cost + timing

Track per test run en `testing/brand-runs/*/test-results.yaml`:

```yaml
tier_used: 0
cost_actual_usd: 0.00
cost_estimated_usd: 0.00
cost_variance: 0%

timing_actual_seconds: 1042
timing_estimated_seconds: 1080
timing_variance: -3.5%

breakdown_per_step:
  setup: 42s
  scope: 68s
  strategy: 158s
  verbal: 355s
  visual: 158s (Tier 0 — no Huemint/Recraft)
  logo: 195s (Tier 0 — Claude SVG generation)
  handoff: 285s
  user_interaction: 85s

cost_breakdown:
  claude_native_svgs: 4 (cost: $0.00)
  recraft: 0 (Tier 0)
  huemint: 0 (Tier 0)
  unsplash: 0 (Tier 0)
```

Si variance > 25% consistente, reassess estimates.

# 22 — Open Decisions (pre-Sprint 0)

## 22.1 Propósito

Lista de decisiones **pendientes** antes de empezar a escribir el código de Sprint 0. Cada decisión con options + recomendación + impacto de la decisión.

Algunas se pueden diferir a Sprint 1 si no bloquean Sprint 0. Marcamos cuál.

## 22.2 Decisiones pendientes — tabla summary

| # | Decisión | Blocker para Sprint 0? | Prioridad |
|---|---|---|---|
| 1 | Idioma del output default | No | Media |
| 2 | Hosting del microsite (netlify.toml?) | No | Media |
| 3 | Font hosting (CDN vs offline) | No | Baja |
| 4 | Brand book PDF interactivo (links clickeables) | No | Baja |
| 5 | Pitch deck completo vs cover only | No | Media |
| 6 | Calibration scenarios para Brand | No | Media |
| 7 | Scope Analysis: inline vs sub-agente | No | Baja |
| 8 | Huemint commercial license strategy | Sí (pre-launch) | Alta |
| 9 | Versioning de brand profiles (v2 roadmap) | No | Baja |
| 10 | Stitch free tier strategy post-quota | No | Media |
| 11 | Error budget per run (hard caps) | No | Media |
| 12 | Language detection vs explicit | No | Baja |

## 22.3 Decisiones en detalle

### Decision 1 — Idioma del output default

**Pregunta**: ¿En qué idioma por default se genera el output? (copy, brand book, README)

**Options**:
- **A. Spanish default, English as override**: project convention de Hardcore es español. Match con eso.
- **B. Detectar desde inputs**: analizar validation + profile + idea text. Si predomina español → Spanish. Si predomina English → English. Si mix → ask user.
- **C. English default, Spanish as override**: más usable globally, matchea la convention de tools AI internacionales.
- **D. Multi-language output simultáneo**: genera en 2 idiomas en paralelo.

**Recomendación**: **Option B — detectar desde inputs**. Razones:
- Match con user expectation (lengua de su idea)
- Si user escribió la idea en español, espera output en español
- Evita enforced convention que no matchea uso real
- Fallback al language del profile si ambiguo

**Impacto**:
- Strategy dept determina language at scope analysis
- Verbal dept adapts copy generation language
- Brand book sections language-aware
- README bilingual if both strong signals

**Blocker**: no blocker Sprint 0 — spec puede incluir esta lógica. Sprint 1 valida con test cases.

---

### Decision 2 — Hosting del microsite

**Pregunta**: ¿Entregamos `netlify.toml` / `vercel.json` / `github-pages.yml` en el package para one-click deploy?

**Options**:
- **A. Ninguno — user responsible de setup**: raw HTML/CSS only
- **B. Solo netlify.toml** (más simple, free-tier más generoso)
- **C. Solo vercel.json** (mejor integration con Next.js si user upgradea)
- **D. All three**: netlify, vercel, github pages configs
- **E. User choice via flag**: `/brand:new --deploy-target=netlify|vercel|github|none`

**Recomendación**: **Option D — all three**. Razones:
- Overhead is minimal (tres archivos pequeños)
- Maximizes user options
- Cierra el loop "genero → live en 5 min"
- README instructions cover all

**Impacto**:
- Activation genera 3 config files
- Templates para cada config en references
- README documenta las 3 options

**Blocker**: no — decisión de implementación en Sprint 1.

---

### Decision 3 — Font hosting (CDN vs offline)

**Pregunta**: ¿Fonts cargadas via Google Fonts CDN o embedded en el microsite?

**Options**:
- **A. CDN por default**: microsite usa Google Fonts imports, requiere internet
- **B. Offline embedded**: descargar fonts files, incluir en microsite, zero-dependency
- **C. Both via flag**: default CDN, `--offline` flag embeds

**Recomendación**: **Option C — both via flag**. CDN default porque:
- Smaller package size
- Auto-updates si Google hace font changes
- Caching del browser (si user visitó otro site con same fonts, cache hit)

Offline embedded para users que:
- Querran deploy a non-CDN environment
- Privacy concerns (no call-home)
- Portabilidad extra

**Impacto**:
- Activation: handle both paths
- Small addition a CLI args

**Blocker**: no.

---

### Decision 4 — Brand book PDF interactivo

**Pregunta**: ¿Incluimos links clickeables en el PDF que abren sections del microsite / assets?

**Options**:
- **A. Plain PDF** (simplest)
- **B. Interactive PDF with internal + external links**

**Recomendación**: **Option B**. Razones:
- `pdf` skill probably supports it trivially
- UX mejor
- Professional

**Impacto**: mínimo — configuration en PDF generation.

**Blocker**: no.

---

### Decision 5 — Pitch deck: cover only vs complete template

**Pregunta**: Para scope `b2b-enterprise`, ¿generamos solo pitch deck cover slide, o un 10-slide template completo?

**Options**:
- **A. Cover only**: mínimo — el cover es el más brand-critical
- **B. Full 10-slide template**: problem, solution, market, competition, traction, team, ask, etc.
- **C. Full template solo si stage > pre-launch**: si ya tienen traction, pitch deck matters más

**Recomendación**: **Option B — full 10-slide template si b2b-enterprise, solo cover si b2b-smb**. Razones:
- `b2b-enterprise` needs pitch deck para sales cycles anyway
- `b2b-smb` probably no va a investor-pitch early, el cover alcanza
- Scope lo determina correctamente

**Impacto**: Activation genera más templates si b2b-enterprise. Added Stitch generations.

**Blocker**: no.

---

### Decision 6 — Calibration scenarios para Brand

**Pregunta**: ¿Creamos `calibration/brand-scenarios.md` análogo a `calibration/scenarios.md` existente para Validation?

**Validation tiene 13 scenarios** con scores fijos + expected verdicts. Útil para verificar que changes en rubrics no rompen scoring.

**Brand no tiene scoring numérico en el mismo sentido**. ¿Qué verificaría?

**Options**:
- **A. Skip** — no calibration scenarios en v1. Confiar en tests de integración.
- **B. 8 scenarios** (one per brand profile) con:
  - Fixed inputs (scope, validation stub, profile stub)
  - Expected archetype range
  - Expected coherence behavior (all gates should pass)
  - Expected output structure
- **C. Partial**: solo scenarios para coherence gates (test edge cases)

**Recomendación**: **Option C — partial para coherence gates**. Razones:
- Coherence gates SÍ tienen binary pass/fail behavior (like scoring)
- 8 full scenarios es mucho trabajo de fixture creation
- Coherence-only scenarios son más test-focused
- Full 8-profile testing puede vivir en testing/brand-runs/

**Impacto**:
- Sprint 0: crear `calibration/brand-scenarios.md` con ~5 coherence scenarios
- Efecto medio en planning

**Blocker**: no. Can decide in Sprint 1 after implementing.

---

### Decision 7 — Scope Analysis: inline vs sub-agente

**Pregunta**: ¿Scope Analysis es ejecutado inline por el orchestrator, o como sub-agente separado?

**Options**:
- **A. Inline** (current plan): orchestrator lo ejecuta directamente
- **B. Sub-agente**: launch separate sub-agente como otros deptos

**Recomendación**: **Option A — inline** (como planeado). Razones:
- Es razonamiento liviano sin tools externos
- Sub-agente agrega overhead (context window, tool setup)
- Mismo patrón que `/profile:show` (orchestrator-handled)
- Si complexity crece, convertir a sub-agente es easy

**Impacto**: ya planeado así, no change.

**Blocker**: no.

---

### Decision 8 — Huemint commercial license strategy

**Pregunta**: Huemint free tier es "non-commercial". Para launch comercial de Hardcore, ¿qué hacemos?

**Options**:
- **A. Upgrade a Huemint paid tier**: contactar Huemint, negociar
- **B. Fallback a Claude-generated palettes en modo commercial**: detect commercial use → use fallback
- **C. Swap a Colormind API**: free, commercially OK (con contacto directo)
- **D. Build palette generation custom** (ML): expensive, not worth v1

**Recomendación**: **Option A (con B como backup)**. Razones:
- Huemint es lo mejor del mercado
- Costo de upgrade probably < $50/mes enterprise
- Vale la pena la quality
- Option B como fallback if negotiation fails

**Impacto**:
- Pre-launch: negotiate license con Huemint
- Architecture: still use Huemint as primary, Claude-palette as fallback (already planned)

**Blocker**: **Sí para launch comercial** — no para Sprint 0 / dogfooding internal.

**Action**: pre-launch (Sprint 2-3), reach out a Huemint.

---

### Decision 9 — Versioning de brand profiles (roadmap v2)

**Pregunta**: Los 8 brand profiles canónicos son v1. ¿Cómo versionamos profiles y agregamos nuevos en v2?

**Options**:
- **A. In-place updates**: edit `brand-profiles.md` directly, no versioning
- **B. Version the reference doc**: `brand-profiles-v1.md`, `brand-profiles-v2.md` con migration notes
- **C. Additive only**: nunca remover profiles, solo agregar. Old runs referencia profile version at time of run.

**Recomendación**: **Option C — additive only**. Razones:
- Old snapshots siguen válidos
- Profile IDs stable (never renamed or removed)
- New profiles agregados como extension
- Backward compat garantizado

**Impacto**: design decision en Sprint 0 para snapshot format.

**Blocker**: no — relevant para v2 planning.

---

### Decision 10 — Stitch free tier strategy post-quota

**Pregunta**: Si user excede Stitch free tier (350/mes), ¿qué hacer?

**Options**:
- **A. Hard block**: "Stitch quota exceeded. Wait next month or upgrade."
- **B. Fallback a manual HTML templates**: degrade mode, less quality pero functional
- **C. User provides own Stitch quota/key**: advanced users pueden point to their own account

**Recomendación**: **Option B (fallback)** para v1. **Option A** considered as "degraded quality" warning.

- En free tier: hard block si quota del user (shared Hardcore quota) se excedió
- En paid tier (future): upgrade quota dedicated
- Siempre: user can choose degraded mode manualmente

**Impacto**: Activation dept handles graceful degradation (ya planeado en failure modes).

**Blocker**: no para Sprint 0. Relevant para scale planning.

---

### Decision 11 — Error budget per run (hard caps)

**Pregunta**: ¿Imponemos hard caps en cost y time per run?

**Options**:
- **A. No caps** (current plan)
- **B. Hard cap $5/run**: sanity check, alert beyond
- **C. Hard cap $2/run** (tighter, could trigger on edge cases)

**Recomendación**: **Option B — $5 cap con alert at $2**. Razones:
- Prevents runaway costs en edge cases (infinite retries)
- $5 es 5-10× budget típico — only triggers on pathological cases
- Alert at $2 warns user antes de continuar

**Impacto**:
- Orchestrator tracks cumulative cost per run
- Alert at threshold
- Pause for user confirm if exceeds cap

**Blocker**: no.

---

### Decision 12 — Language detection vs explicit

**Pregunta**: ¿Cómo Brand decide language del output?

**Options**:
- **A. Auto-detect from inputs** (Decision 1 decided this via Option B)
- **B. User must specify via override**: `--language=es`
- **C. Hybrid**: auto-detect + user can override

**Recomendación**: **Option C — hybrid**. Auto-detect es default, user can override.

**Relación con Decision 1**: Decision 1 + Decision 12 son la misma decisión desde ángulos distintos. Consolidar en Decision 1.

**Impacto**: already covered en Decision 1.

**Blocker**: no.

## 22.4 Otras consideraciones pendientes (minor)

### Font licensing

Google Fonts are free for commercial use. But some "Google Fonts" are actually Monotype-licensed mirrors with restrictions. Need to verify specific fonts in curated pairings.

**Action**: durante Sprint 0, verify each recommended font in `archetype-typography-map.md` tiene clear commercial license.

### Icon libraries

Microsite generation puede necesitar icons (hamburger menu, check marks, etc.). Stitch might include these. Otherwise, use Heroicons or Lucide (both free commercial).

**Action**: verify Stitch handles this. If not, add icon library to stack.

### Accessibility beyond WCAG

WCAG covers color contrast. Other accessibility considerations (keyboard nav, screen readers, alt text) are more implementation-level.

**Action**: Stitch probably handles alt text automatically. Verify.

### Legal compliance per region

Brand generates Privacy / Terms skeleton. Region-specific legal (GDPR, CCPA, LGPD) requires more than skeleton.

**Action**: always include "requires legal review" warning. No specific compliance promises.

### Analytics integration

Microsite no incluye analytics code por default. Could add Plausible / Umami / GA4 setup.

**Action**: out of scope v1. User adds their own.

## 22.5 Decision log format

Once decisions are made, record in:

```
plan/brand/decision-log.md

## Decisions Made

### 2026-04-22 — Decision 1 (Language default)
Chosen: Option B (auto-detect from inputs)
Rationale: [...]
Impact: [...]
Decided by: @gustavo

### 2026-04-22 — Decision 2 (Microsite hosting)
Chosen: Option D (all three configs)
...
```

Create when Sprint 0 starts.

## 22.6 Decisions that can wait

Marked with "Blocker: no" above — can be deferred to Sprint 1 based on implementation learnings:

- Decision 3 (Font hosting)
- Decision 4 (Interactive PDF)
- Decision 6 (Calibration scenarios)
- Decision 7 (Scope Analysis architecture)
- Decision 9 (Profile versioning)
- Decision 11 (Error budget caps)

Solo Decision 8 (Huemint commercial) es pre-launch blocker, not Sprint 0 blocker.

## 22.7 Process for resolving decisions

1. **Review este documento con user** (you)
2. **Discuss options + make decisions** explicitly
3. **Record in decision-log.md** (create after this review)
4. **Update relevant plan docs** to reflect decisions
5. **Proceed to Sprint 0** with decisions locked

Ideal: resolve decisions en 1 focused session antes de Sprint 0. Doesn't have to be all at once — can resolve blockers first, defer others.

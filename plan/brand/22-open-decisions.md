# 22 — Open Decisions (pre-Sprint 0)

## 22.1 Propósito

Lista de decisiones pendientes antes de Sprint 0.

Las "recomendaciones" en este doc reflejan opinions basadas en reasoning — todas son abiertas a override del user.

## 22.2 Decisiones pendientes — tabla summary

| # | Decisión | Blocker Sprint 0? | Prioridad |
|---|---|---|---|
| 1 | Idioma del output default | No | Media |
| 2 | Brand Design Document PDF interactivo (links clickeables) | No | Baja |
| 3 | Calibration scenarios para Brand (5 coherence scenarios) | No | Baja |
| 4 | Huemint commercial license (Tier 1+ commercial) | Sí pre-launch comercial | Media |
| 5 | Tier elevation UX (auto vs always ask) | No | Media |
| 6 | Error budget caps (Tier 0/1/2 distinto?) | No | Baja |
| 7 | Language detection vs explicit | No | Baja |
| 8 | Claude Design subscription handling en freemium | Sí | Alta |
| 9 | Versioning profile brand profiles roadmap v2 | No | Baja |

## 22.3 Decisiones en detalle

### Decision 1 — Idioma del output default

**Pregunta**: ¿En qué idioma se genera el output?

**Options**:
- A. Spanish default (project convention)
- **B. Auto-detect from inputs** (recommended)
- C. English default
- D. Multi-language simultáneo

**Recomendación**: **Option B** — analizar validation + profile + idea text. Match language predominante.

**Impacto**: Scope Analysis determina language. Verbal adapts copy generation. Brand Document sections language-aware. Prompts Library output en mismo language.

**Blocker**: no para Sprint 0.

---

### Decision 2 — Brand Design Document PDF interactivo

**Pregunta**: ¿Include links clickeables en PDF?

**Options**:
- A. Plain PDF
- B. Interactive with internal + external links

**Recomendación**: **Option B** — trivial en pdf skill, mejor UX.

**Blocker**: no.

---

### Decision 3 — Calibration scenarios

**Pregunta**: ¿Creamos `calibration/brand-scenarios.md`?

**Propuesta**: 5 coherence scenarios (inject incoherences específicas, verify gates). ~4 horas de fixture creation.

**Options**:
- A. Skip — confiar en integration tests
- B. 5 coherence scenarios
- C. Full 8 scenarios (one per brand profile) — considerable trabajo

**Recomendación**: **Option B**. Coherence gates son la parte más critical testeable.

**Blocker**: no. Decide en Sprint 1.

---

### Decision 4 — Huemint commercial license

**Pregunta**: Para commercial launch Tier 1+, ¿qué hacer con Huemint?

**Options**:
- A. Upgrade Huemint paid tier
- B. Fallback to Claude-palette en modo commercial
- C. Swap to Colormind API
- D. Build palette generation custom

**Recomendación**: **Option A** (con B como backup). $10-50/mo razonable, amortiza bien.

**Impacto**: pre-launch negotiate con Huemint. Architecture already supports fallback.

**Blocker**: **Sí para launch comercial, no para Sprint 0 / dogfooding**.

**Action**: pre-launch (Sprint 2-3), reach out a Huemint.

---

### Decision 5 — Tier elevation UX

**Pregunta**: Cuando scope requiere tier elevation (symbolic logo, app icon), ¿cómo handle?

**Options**:
- A. **Auto-elevate + ask confirmation** (recommended) — scope detecta, orchestrator prompt al user
- B. Always auto-elevate without asking (risk: unexpected cost)
- C. Always ask at run start ("what tier?") regardless of scope
- D. Ask only on first-ever run, remember preference

**Recomendación**: **Option A** — balance entre control del user y automation. User sabe el costo antes de pagar.

**Impacto**: Logo dept implementation. Reveal al user (Punto 5 de interaction).

**Blocker**: no.

---

### Decision 6 — Error budget caps

**Pregunta**: ¿Hard caps diferentes por tier?

**Options**:
- A. Single $5/run cap (consistent across tiers)
- B. Tier-specific caps: Tier 0 $0.50 cap (alert if exceeded — bug), Tier 1 $2, Tier 2 $5
- C. No hard caps

**Recomendación**: **Option B** — tier-aware caps detect anomalies per context.

**Impacto**: budget tracking implementation.

**Blocker**: no.

---

### Decision 7 — Language detection vs explicit

Consolidada con Decision 1. Option B (hybrid — auto-detect + user override disponible).

---

### Decision 8 — Claude Design subscription en freemium

**Pregunta crítica**: Users freemium de Hardcore can run Brand, pero need Claude Pro+ para consumir output completamente. ¿Cómo handle?

**Options**:
- A. **Require Claude subscription para use Hardcore Brand**: user sin Claude Pro bloqueado
- B. **Allow run sin Claude subscription, clear guidance**: user genera package, usa como brief para other tools
- C. **Generate alternative outputs para non-Claude users**: duplicate workflow sin Claude Design dependency
- D. **Partner con Anthropic**: free Claude Design trial para Hardcore users

**Recomendación**: **Option B** — allow run with clear disclosure. Package es útil standalone (PDF brief, Tokens, Assets). Claude Design optimizes but not required.

**Impacto**: README del package explica alternative paths. Reveal al user al final explica. No arbitrary blocking.

**Blocker**: **Sí** — afecta user acquisition strategy. Decidir antes de Sprint 0 affects messaging + positioning.

---

### Decision 9 — Versioning de brand profiles (roadmap v2)

**Option C — additive only**. Nunca remover profiles, solo agregar. Old runs referencia profile version at time of run.

**Blocker**: no — relevant para v2.

## 22.4 Otras consideraciones pendientes (minor)

### Font licensing
Google Fonts are free for commercial use. Verify specific fonts en curated pairings durante Sprint 0.

### Icon libraries
Claude Design probably handles icons natively. Verify — si not, add Heroicons/Lucide.

### Legal compliance per region
Privacy/Terms skeletons siempre con "requires legal review".

### Analytics integration
Out of scope v1. User adds their own.

## 22.5 Decision log format

Archivo `plan/brand/decision-log.md` (a crear cuando comiencen resoluciones):

```
## 2026-04-22 — Decision 1 (Language default)
Chosen: Option B (auto-detect)
Rationale: [...]
Impact: [...]
Decided by: @gustavo
```

## 22.6 Decisiones que pueden diferirse

Marked con "Blocker: no":
- Decision 2 (Interactive PDF)
- Decision 3 (Calibration scenarios)
- Decision 5 (Tier elevation UX details)
- Decision 6 (Error budget caps)
- Decision 9 (Profile versioning)

**Blockers**:
- Decision 4 (Huemint commercial) — pre-launch comercial, not Sprint 0
- Decision 8 (Claude Design subscription) — Sprint 0 need to decide messaging

## 22.7 Process para resolver decisiones

1. Review este documento
2. Discuss options + decide explicitly
3. Record en decision-log.md
4. Update relevant plan docs
5. Proceed Sprint 0

Ideal: resolve blockers (especially Decision 8) en 1 focused session antes de Sprint 0.

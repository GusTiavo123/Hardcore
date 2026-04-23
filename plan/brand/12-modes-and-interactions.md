# 12 — Modos de Operación y Puntos de Interacción con User

## 12.1 Propósito

Definir los **modos** en que Brand puede ejecutarse + los **puntos de interacción** donde el user participa.

## 12.2 Los modos

### Modo Normal (default)

Invocación: `"brandea esta idea"` / `/brand:new`

**Características**:
- 4 puntos de interacción mid-run con el user (post Scope si low confidence, post Strategy, post Verbal naming, post Logo)
- 1 punto final obligatorio (pre-delivery review del package)
- Reveal progresivo después de cada dept
- Tiempo total: 15-25 min según brand profile (ver [17-cost-and-timing.md](./17-cost-and-timing.md))

### Modo Fast

Invocación: `/brand:fast` / `"brandea rápido"`

- Skip de interacciones mid-run (Scope confirmation, Strategy review, Naming, Logo selection → auto-picks top-ranked)
- **Mantiene el final review pre-delivery** como safety net no negociable. El user revisa el package antes del delivery final y puede pedir `/brand:extend {dept}` si algo no convence.
- Reveal comprimido durante la ejecución
- Tiempo total: 12-20 min

### Modo Extend

Invocación: `/brand:extend {dept}`

- Regenera solo el dept especificado
- Otros deptos reutilizados desde Engram cache
- Coherence gates re-ejecutados (desde cero, full set)
- Examples:
  ```
  /brand:extend logo
  /brand:extend verbal.naming
  /brand:extend verbal.core_copy
  /brand:extend visual.palette
  /brand:extend handoff   # regenera los 4 deliverables, no los upstream
  ```
- Versioning: incrementa snapshot (v{N+1})

### Modo Override

Invocación: `/brand:override {key}={value}` (pre-run) o `/brand:new --{key}={value}` (inline en el command)

**Allowlist de overrides** (overrides fuera de esta lista son rechazados con explicación):

| Key | Valores válidos | Effect |
|---|---|---|
| `archetype` | uno de los 12 Jung archetypes | Strategy usa este archetype directamente, bypass de selection algorithm |
| `brand_profile` | uno de los 8 canonical profiles | Scope Analysis usa este profile, bypass de classification scoring |
| `voice_register` | `formal-professional` \| `professional-warm` \| `casual-friendly` \| `playful-bold` \| `expressive-raw` | Overrides default register del scope |
| `language` | `es` \| `en` \| `pt` \| ... (códigos ISO 639-1) | Override del output language (default inferred desde profile.languages + cultural_scope) |
| `name` | string | Verbal dept skip naming generation, usa este nombre + ejecuta verification (domain + TM) |
| `primary_color` | HEX (`#RRGGBB`) | Visual dept usa como seed obligatorio para palette |
| `output_manifest.include` | array de strings | Agrega outputs al required del scope manifest |
| `output_manifest.exclude` | array de strings | Remove outputs del required del scope manifest |

**Overrides rechazados** (ejemplos de lo que NO acepta el allowlist):
- `typography_era` → requiere editar SKILL.md, no override runtime
- `palette_mood` → derivable desde archetype + primary_color, no directo
- `logo_form` → se deriva de scope; si el user quiere forzarlo, usa `brand_profile` override

### Modo Resume

Invocación: `/brand:resume`

- Recupera estado persistido de un run interrumpido (cancel, timeout, gate halt sin decisión, error de tooling)
- Reanuda desde el último paso completado
- Si el último paso fue un coherence gate halt, re-prompt al user con las opciones que quedaron pendientes

**Estado persistido para resume** (en `brand/{slug}/handoff`):
- Último dept completado
- Último gate evaluado + resultado
- User decisions tomadas
- Timestamps de cada paso

## 12.3 Los puntos de interacción (Modo Normal)

### Punto 1: Post Scope Analysis (condicional)

**Cuándo**: `brand_profile.primary_confidence < 0.7` en la clasificación.

Ver [02-scope-analysis.md](./02-scope-analysis.md) para el prompt completo. El orchestrator renderiza las `confirmation_options` provistas por el sub-agent de Scope Analysis.

**Skipped en**: Fast mode (auto-picks primary), confidence ≥ 0.7, o user proveyó `brand_profile` override.

### Punto 2: Post Strategy

**Cuándo**: siempre en Normal mode, unless `archetype` override previo.

```
[3:42] ① Strategy ready — Archetype: SAGE

[Full reveal — ver 04-dept-strategy.md §4.7]

¿OK o preferís alternativa?
  [Enter] accept
  'ruler' | 'hero' | 'creator' — override archetype
  'voice' — ajustar voice attributes (re-runs voice derivation)
  'skip' — proceed con flag 'user_skipped_strategy_review'
```

**Skipped en**: Fast mode, `archetype` override previo.

### Punto 3: Post Verbal Naming

**Cuándo**: siempre en Normal mode, unless `name` override.

```
[7:14] ② Verbal Identity — Top 7 nombres

[Tabla con availability + fit + score]

Recomendado: Auren

Opciones:
  [Enter] accept Auren
  '{otro nombre de la tabla}' pick otro
  'more' regenerate batch con feedback
  'manual {name}' provide your own name (ejecuta verification)
```

**Skipped en**: Fast mode (auto-picks top), `name` override previo.

### Punto 4: Post Logo

**Cuándo**: siempre en Normal mode.

```
[17:45] ④ 4 logo concepts

[4 SVGs rendered en grid]

Opciones:
  'B1' | 'B2' | 'B3' | 'C1' — pick one
  'direction B' — regenerate 2-3 variants dentro de esa direction
  'none' — full regen con feedback (max 2 rondas antes de offer manual)
  'manual' — upload your own SVG logo
```

**Skipped en**: Fast mode (auto-picks highest-quality ranked por Logo dept).

### Punto 5 (condicional): Coherence gate halt

**Cuándo**: alguno de los 9 gates falla.

Ver [09-coherence-model.md §9.6](./09-coherence-model.md) para el prompt completo. El pipeline pausa con opciones: re-correr dept responsable, aceptar con flag, abortar y fix upstream.

**Skipped en**: ningún modo skipea este punto. Fail-fast es sagrado — gate failure requiere decisión explícita del user.

### Punto 6: Pre-delivery final review (OBLIGATORIO)

**Cuándo**: siempre, en todos los modes (Normal, Fast, Extend, Resume).

```
[27:42] ⑤ Handoff Compiler — Package listo para review

📂 output/auren-compliance/brand/

[Lista de los 4 deliverables con brief preview de cada uno]

Last check antes de finalizar:
  [Enter] delivery (package final queda en output/)
  '/brand:extend {dept}' — regenerar dept antes de entregar
  'abort' — descartar run (persist parcial para `/brand:resume` futuro)
```

Este es el safety net del Fast mode. En Normal ya hubo revisiones intermedias; en Fast es la primera oportunidad del user de ver todo junto antes del entrega final.

### Punto 7: Post-delivery instructions

**Cuándo**: automático después del delivery final.

```
✓ Package entregado en output/auren-compliance/brand/

📋 Next steps para usar con Claude Design:

  1. Abrir claude.ai/design (requires Claude Pro / Max / Team / Enterprise)
  2. Set up your design system → Upload brand-design-document.pdf
  3. Validar con un test project
  4. Publicar el design system
  5. Usar prompts de prompts-for-claude-design.md en nuevos projects
  6. Claude Design export → Claude Code → deploy

¿Querés que abra el README con las instructions completas? [y/n]
```

En Fast mode este step es una línea más corta; en Normal el prompt completo.

## 12.4 Edge cases en interacción

Ver [19-edge-cases.md](./19-edge-cases.md) para detalles completos.

- **Override inválido** (key fuera del allowlist o value fuera del enum) → rejection con explicación del allowlist
- **Override conflict con scope** (ej. `archetype=Outlaw` con `brand_profile=b2b-enterprise`) → block con options: ajustar override o abortar
- **Timeout del user en un prompt** → persist estado, ofrecer `/brand:resume` para retomar
- **Cancel mid-flow** → partial state persisted en `brand/{slug}/handoff` con `status: "partial"`
- **Gate halt sin decisión del user** (se cerró la session mientras esperaba input) → `/brand:resume` re-prompt desde el gate pendiente

## 12.5 Summary tabla — mode × interaction

| Interaction point | Normal | Fast | Extend | Override |
|---|---|---|---|---|
| 1. Scope confirmation (si low conf) | ✓ | skip (auto-picks) | n/a | skip si brand_profile override |
| 2. Post-Strategy review | ✓ | skip | solo si extending strategy | skip si archetype override |
| 3. Naming selection | ✓ | skip | solo si extending verbal.naming | skip si name override |
| 4. Logo selection | ✓ | skip | solo si extending logo | skip si manual logo |
| 5. Coherence gate halt | ✓ | ✓ | ✓ | ✓ |
| 6. Pre-delivery final review | ✓ | ✓ | ✓ | ✓ |
| 7. Post-delivery instructions | ✓ | ✓ (brief) | ✓ si handoff re-gen | ✓ |

Puntos 5 y 6 NUNCA se skipean — son safety nets críticos.

## 12.6 UX del reveal progresivo

Cada dept devuelve un reveal visual intermedio antes de continuar.

### Formato del reveal

1. **Header con timestamp + dept number**:
   ```
   [3:42] ① Strategy ready — Archetype: SAGE
   ```
2. **Core content** — qué se decidió/generó
3. **Evidence one-line** — por qué así
4. **Interaction prompt** (si aplica)

### Reveal estructurado por dept

- Scope Analysis: classification + brand_profile + confidence (conciso)
- Strategy: archetype + positioning + voice + values + sentiment_landscape derivada
- Verbal naming: tabla top 5 con availability + TM screening + fit
- Verbal copy: selected copy samples (hero + tagline + value props)
- Visual: palette swatches + typography rendered + mood refs (si aplica)
- Logo: 4-5 SVGs rendered + rationales
- Handoff Compiler: package path + 4 deliverables listados + next steps para Claude Design

### Fast mode reveals

Comprimidos durante la ejecución:

```
[02:10] ⓪ Scope: b2b-smb (confidence 0.84) ✓
[05:30] ① Strategy: Sage + positioning + voice + values ✓
[12:45] ② Verbal: Auren (Top 1, fit 9.1) + 18 core copy assets ✓
[15:20] ③ Visual: Navy/Off-white/Amber palette + Fraunces/Inter ✓
[18:30] ④ Logo: B2 selected (highest quality) + 12 derivations ✓
[22:14] ⑤ Handoff: 4 deliverables compiled — review antes de entregar
```

Seguido del **Punto 6 (pre-delivery review)** que es obligatorio.

## 12.7 Dónde vive esto en Sprint 0

Todo el mode handling + interaction design vive **dentro de `skills/brand/SKILL.md`** (orchestrator):
- Templates exactos de reveals por mode (sección dedicada)
- Decision tree de interaction points
- Override allowlist + validation rules (tabla)
- Mode handling (Normal, Fast, Extend, Override, Resume)
- Resume logic desde estado persistido

Sin refs standalone — son decisiones del orchestrator, no data consultada repetidamente.

## 12.8 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Normal mode → 4 puntos mid-run + 1 pre-delivery triggered correctamente
2. Fast mode → auto-picks en mid-run, final review presentado
3. Fast mode → user pide `/brand:extend logo` en final review → re-corre Logo, re-coherence, re-review
4. Extend logo → solo logo dept re-runs + coherence re-eval desde cero
5. Override archetype compatible → Strategy usa override sin preguntar
6. Override archetype blocked (violación de scope constraints) → rejection con opciones
7. Override fuera de allowlist → rejection con mensaje listando allowlist
8. User cancel mid-flow → partial state persisted, `/brand:resume` reanuda desde último paso
9. Gate halt sin respuesta (timeout) → `/brand:resume` re-prompt el gate pendiente
10. Resume desde Strategy → no re-corre Scope Analysis (cache)
11. Scope confidence low → Punto 1 triggered
12. Scope confidence high → Punto 1 skipped
13. Coherence gate fails → Punto 5 triggered, user elige opción, pipeline continúa según decisión

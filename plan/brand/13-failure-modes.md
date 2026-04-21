# 13 — Failure Modes y Fallbacks

## 13.1 Propósito

Documentar qué puede salir mal en cada paso + respuesta sistemática. Falla graceful > falla hard. User siempre termina con algo usable.


## 13.2 Principios generales

1. **Never silent fail**: user debe saberlo
2. **Always degrade gracefully**: output parcial con flags > halt
3. **Always recoverable**: `/brand:resume` o `/brand:extend`
4. **Always traceable**: failures en AUDIT.md + Engram
5. **Never retry infinitely**: max retries clara, después escalate
6. **Tier degradation path**: Tier 2 fail → Tier 1. Tier 1 fail → Tier 0. Tier 0 fail → manual mode con user

## 13.3 Failure modes por dept

### Orchestrator / Scope Analysis

| Failure | Detection | Fallback |
|---|---|---|
| Validation artifacts missing | mem_search empty | Abort: "Brand requiere Validation. Run `/validation:new` primero." |
| Verdict is NO-GO sin override | Verdict check | Block + offer `--force` option |
| Profile missing | mem_search empty | Proceed with flag `decided_without_profile: true`, suggest `/profile:new` |
| Scope confidence < 0.5 | Calculation | Trigger user confirmation (Punto 1) |
| User cancels scope confirmation | Signal | Abort, graba partial state |
| User declares scope manually via confirmation | User input | Use manual classification, flag `"user_classified"` |

### Strategy

| Failure | Detection | Fallback |
|---|---|---|
| All 12 archetypes blocked | Empty filter result | Relax constraints, remove preferred_range filter, flag |
| Profile contradicts positioning severely | Consistency check | Flag conflict, elegir least contradictory |
| Validation data insufficient | Presence check | Use Market as fallback, flag |
| Claude schema-invalid output | JSON parse fail | Retry with schema reminder, max 2 retries |

### Verbal Identity

| Failure | Detection | Fallback |
|---|---|---|
| Domain MCP down | 3× retry fails | Skip domain verification, flag "domains no verificados — retry con /brand:extend verbal.naming" |
| open-websearch fails | 3× retry fails | Skip TM screening, flag "TM no verified — consultá manualmente" |
| 0 names pass checks | All candidates flagged red | Present raw candidates + conflicts matrix, user decides |
| All .com taken para all candidates | Domain check | Suggest modifier strategies, regenerate |
| User rejects 3+ rounds | Input pattern | Offer "manual name" mode |
| Copy self-check fails persistently | 2× retries fail | Include con flag "voice compliance low", no halt |

### Visual System

| Failure | Detection | Fallback (Tier-aware) |
|---|---|---|
| Huemint API down (Tier 1+) | 3× retry fails | Fallback a Claude-generated palette (degrade to Tier 0 behavior). Flag "palette sin ML optimization" |
| Huemint devuelve palette fallando WCAG | Contrast check | Auto-adjust, si no fixable alternate palette, si tampoco regenerate con seeds |
| Recraft API down (Tier 2 mood) | 3× retry fails | Fallback a Unsplash (Tier 1 behavior). Flag |
| Unsplash API down (Tier 1 mood) | 3× retry fails | Skip mood imagery (Tier 0 behavior). Flag |
| Claude-generated palette fails contrast (Tier 0) | WCAG check | Auto-adjust darkening/lightening |
| Typography pairing no tiene Google Fonts adecuadas | Catalog lookup fail | Fallback a Inter + Fraunces default. Flag |

### Logo & Key Visuals

| Failure | Detection | Fallback (Tier-aware) |
|---|---|---|
| Claude-generated SVG inválido (Tier 0) | XML parse fail | Retry explicit prompt. Max 2 retries. Auto-elevate to Tier 1 con user confirm if persistent |
| Recraft API down (Tier 1+) | 3× retry fails | Degrade to Claude native (Tier 0 behavior). Flag "symbolic logos limited quality" |
| SVG malformed | Validation fails | Retry with format emphasis. Fallback raster PNG (degraded). Flag |
| Quality validation fails persistently | 2× retries per concept | Include con flag, user decides |
| App icon 16×16 not legible (Tier 1+) | Visual scale check | Regenerate. Max 3 retries. Warn user if persistent |
| User rejects 3+ rounds | Input pattern | Offer manual upload mode |
| User scope requires symbolic-first but --tier=0 | Pre-check | Prompt user to elevate tier (Punto 5 interaction) |

### Handoff Compiler

| Failure | Detection | Fallback |
|---|---|---|
| PDF generation falla | skill error | Retry. Fallback: deliver markdown brand-book.md. Flag "PDF conversion failed" |
| JSON token file invalid | Schema validation | Retry. Max 2. Flag if persistent |
| CSS token file invalid syntax | Parser check | Retry. Max 2. Flag |
| HTML example invalid | HTML5 parser | Retry. Max 2. Flag |
| Tailwind config not valid JS | Node syntax check | Retry. Max 2. Flag |
| Coherence gate falla persistently | Gate retry counter | Escalate a user (Punto 6, ver [09](./09-coherence-model.md)) |
| Filesystem write fails (permissions) | IO error | Clear error message, abort, state saved en Engram |
| Disk space insufficient | IO error | Clean up partial, clear error |
| Brand Design Document PDF not uploadable to Claude Design | User reports post-delivery | Investigate format issues, may need PDF regeneration with compatibility fix |

## 13.4 Cross-cutting failure scenarios

### Session crashes / conversation context lost

Engram es persistent — si conversation resetea:
- Data en Engram sobrevive
- User: `/brand:resume {slug}` para continuar
- Orchestrator detecta state en Engram y resumes desde último dept completado

### User misbehavior

- Invalid commands → help text
- Contradictory overrides → explain conflict, ask resolution
- Abusive prompts → ignore + continue defaults

### Timing out

- Default timeout per depto: 15 min
- Después de timeout: abort that dept, flag, option to retry
- Orchestrator-level timeout: 60 min total (excluye post-delivery Claude Design handoff que es user-mediated)

### Corrupted Engram data

- mem_get_observation returns garbage: log error, skip, partial proceed
- User notified

## 13.5 Escalation UI templates

### Tool down escalation

```
⚠ {Tool name} está down después de 3 intentos.

Puedo proceder con fallback:
  {Fallback description specific to tool}
  Current tier: {N} → will degrade to Tier {M}

O podés:
  'retry' — intentar de nuevo
  'skip' — proceed sin este output
  'cancel' — abortar run, state saved for resume

¿Qué preferís?
```

### Quality failure escalation

```
⚠ {Dept} generó outputs {quality issue}.

Probé {N} regeneraciones. Current state: {description}.

Opciones:
  'accept' — use current con flags en brand book
  'regenerate' — intentar con tu feedback
  'manual' — proveé {asset} vos mismo
  'cancel' — abort, resume después
```

### Coherence escalation

Ver [09-coherence-model.md#96](./09-coherence-model.md#96).

### Scope low confidence

Ver [02-scope-analysis.md#27](./02-scope-analysis.md#27).

### Tier elevation prompt

Ver [07-dept-logo.md#73](./07-dept-logo.md#73) (auto-elevation rule).

### Budget cap reached

```
⚠ Este run se está acercando al cap de $5.

Gastado hasta ahora: $3.80
Próximo paso estimado: ~$1.50

Opciones:
  'continue' — proceed con el gasto
  'abort' — stop here, deliver partial
  'raise cap' — increase cap (mencionar máximo)
```

## 13.6 Partial output policy

Cuando run falla parcialmente:

1. **README.md** declara qué se completó + qué faltó
2. **AUDIT.md** graba failures + retry attempts + tool errors
3. **Badge en brand book PDF**: "PARTIAL DELIVERY"
4. **Engram `brand/{slug}/handoff`** contiene `status: "partial"` + `failed_outputs: [...]`
5. **Resume path** documented

Ejemplo README header partial:

```markdown
# Auren — Brand Package (PARTIAL DELIVERY)

⚠ Este run completó algunas pero no todas las operations:

Completed:
  ✓ Strategy
  ✓ Verbal Identity
  ✓ Visual System
  ✓ Logo
  ⚠ Handoff Compiler: PDF failed, markdown delivered instead

Pending:
  ○ brand-design-document.pdf — retry: `/brand:extend handoff.pdf`

Claude Design handoff requires PDF. Until PDF regenerates, can use:
  • brand-design-document.md (markdown alternative) + upload via codebase link
  • Or wait for PDF regen

Todos los pending pueden completarse con extend commands arriba.
Nada de lo completed se pierde — persistido en Engram.
```

## 13.7 Cost tracking in failure scenarios

Si failures causan retries, cost acumula:

- Track actual vs estimated en AUDIT.md
- Cap per run: $5 (10× typical Tier 2)
- Alert si aproxima cap

Tier 0 runs nunca deberían exceder $0 — if cost > $0 en Tier 0, flag as bug.

## 13.8 Claude Design-specific failure modes

### User doesn't have Claude Pro/Max/Team

**Detection**: user reports Claude Design inaccessible.

**Response**: graceful guidance
```
Claude Design requires Claude Pro/Max/Team/Enterprise subscription.

Your options:
  1. Upgrade to Pro (~$20/mo) to use Claude Design
  2. Use the Brand Design Document PDF manually as brief for other design tools
     (Figma AI, Midjourney, human designer)
  3. Wait for Anthropic to announce a free Claude Design tier (no guarantees)

All Hardcore outputs remain usable regardless.
```

### User uploads PDF to Claude Design but it doesn't extract design system correctly

**Detection**: user feedback post-delivery.

**Response**: 
- Verify PDF has all required sections
- If missing, re-run Handoff Compiler with diagnostic flags
- If present, investigate Claude Design parsing (may require Hardcore update if Claude Design changes format expectations)

### Claude Design exits Labs with breaking changes

**Detection**: Anthropic announcement + testing reveals issues.

**Response**:
- Update Brand Document format in Handoff Compiler
- Re-test all scope profiles
- Bump `brand_module_version`
- Notify all existing users to regenerate

## 13.9 Reference file a escribir en Sprint 0

`skills/brand/references/failure-protocols.md` con:
- Tabla exhaustiva de failures per tool + per tier
- Retry strategies detalladas
- Tier degradation logic
- Escalation UI templates completos
- Recovery commands mapping
- Partial output policies

## 13.10 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Simulate Recraft down (Tier 1) → fallback a Claude native works
2. Simulate Huemint down (Tier 1) → fallback a Claude palette works
3. Simulate PDF skill error → markdown fallback works
4. Inject invalid JSON en tokens → retry + validation works
5. Simulate filesystem permission error → clear abort, state saved
6. User cancels at 50% → partial state saved, resumable
7. Coherence gate fails 3× → escalation UI triggered
8. Scope confidence 0.4 → user confirmation prompted
9. All naming candidates TM red → present with conflicts matrix
10. Cost cap reached (Tier 2) → alert user
11. Session resume after crash → picks up correctly
12. Tier elevation required but user declines → proceed with quality flag

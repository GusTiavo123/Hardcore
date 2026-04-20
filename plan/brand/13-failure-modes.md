# 13 — Failure Modes y Fallbacks

## 13.1 Propósito

Documentar exhaustivamente qué puede salir mal en cada paso del pipeline + cuál es la respuesta sistemática. Falla graceful > falla hard. User siempre termina con algo usable.

## 13.2 Principios generales

1. **Never silent fail**: si algo falla, user debe saberlo
2. **Always degrade gracefully**: preferir output parcial con flags que halt completo
3. **Always recoverable**: partial runs deben poder resumir via `/brand:resume` o `/brand:extend`
4. **Always traceable**: failure details grabados en AUDIT.md + Engram
5. **Never retry infinitely**: max retries clara per tool, después escalate

## 13.3 Failure modes por dept

### Orchestrator / Scope Analysis

| Failure | Detection | Fallback |
|---|---|---|
| Validation artifacts missing from Engram | `mem_search("validation/{slug}")` returns empty | Abort con error claro: "Brand requiere Validation output. Run `/validation:new` primero." |
| Verdict is NO-GO (sin override) | Verdict field check | Block con mensaje + offer override option |
| Profile missing (pero expected) | `mem_search("profile/{user-slug}")` empty | Proceed sin profile, flag `decided_without_profile: true`, suggest `/profile:new` al user |
| Scope classification confidence < 0.5 | Internal calculation | Trigger user confirmation (Punto 1 de interacción) |
| User cancels scope confirmation | Signal | Abort, graba partial state |

### Strategy

| Failure | Detection | Fallback |
|---|---|---|
| All 12 archetypes blocked (constraints too strict) | Empty result from filter | Relax constraints by removing preferred_range restriction (still respect hard blocks), flag en output |
| Profile contradicts positioning severely | Internal consistency check | Flag conflict, elegir archetype least contradictory, graba warning |
| Validation data insuficiente (Problem dept sparse) | Data presence check | Use Market dept como fallback source, flag "target inferred from market not problem" |
| Claude generation returns schema-invalid output | JSON parse fail | Retry with explicit schema reminder, max 2 retries |

### Verbal Identity

| Failure | Detection | Fallback |
|---|---|---|
| Domain MCP down (connection timeout) | 3× retry fails | Skip domain verification. Flag: "domains no verificados en este run. Retry con `/brand:extend verbal.naming` cuando servicio esté up." |
| open-websearch fails for TM check | 3× retry fails | Skip TM screening. Flag: "TM screening no completado — consultá manualmente antes de registrar marca." |
| 0 names pass all checks (domain + TM + linguistic) | All candidates flagged red | Present raw candidates con conflicts matrix. User decide: accept risk, regenerate con constraints, o manual name. |
| All domain TLDs taken para all candidates | Domain check result | Suggest modifier strategies ("Get{Name}", "{Name}HQ", "use{Name}", ".tech / .finance TLDs"), regenerate |
| User rechaza 3+ rounds de nombres | User input pattern | Offer "manual name" mode: user provee su propio nombre, Verbal solo verify + copy |
| Copy self-check falla persistently (asset no exhibit voice) | 2× retries fail | Include asset with flag "voice compliance low — review manually", no halt |
| Huge linguistic risk detectado (marca contains slur accidental in target language) | Claude reasoning | Exclude from candidates, NEVER present to user |

### Visual System

| Failure | Detection | Fallback |
|---|---|---|
| Huemint API down | 3× retry fails | Claude-generated palette using color theory principles + archetype seeds. Flag: "palette sin ML optimization (Huemint down)." |
| Huemint devuelve palette que falla WCAG | Contrast check fails | Attempt auto-adjust (darken text, lighten bg). If not fixable, re-request Huemint con different seeds. If still failing after 2 attempts, use alternate palette from the batch returned. |
| Recraft API down for mood imagery | 3× retry fails | Deliver Visual System sin mood imagery. Flag: "mood imagery pending. Retry con `/brand:extend visual.mood_imagery`." |
| Typography pairing no tiene Google Fonts adequate | Catalog lookup fails | Fallback to más genérico (Inter + Fraunces default pair). Flag. |
| Recraft genera mood images irrelevantes | Quality check (Claude reasoning) | Re-prompt with más explicit archetype + style constraints. Max 2 retries. Include best-effort if still subpar, flag. |

### Logo & Key Visuals

| Failure | Detection | Fallback |
|---|---|---|
| Recraft API down | 3× retry fails | Fail graceful: deliver package sin logo. README flag: "logo generation pending. Use `/brand:extend logo` when service up." |
| SVG output malformed (invalid XML) | SVG parse attempt fails | Retry con prompt emphasis "output must be valid SVG XML". Max 2 retries. If persistent, fallback to PNG raster (degraded but usable). |
| Logo quality low (all-black, empty, gibberish text) | Quality validation utility | Regenerate that specific concept. Max 2 retries per concept. After 2, include with flag. |
| App icon at 16×16 not legible | Visual check on scaled version | Regenerate with prompt "design must remain identifiable at 16px square". Max 3 retries. If persistent, warn user explicitly in brand book: "app icon may have legibility issues at small sizes." |
| User rejects 3+ rounds of logos | User input pattern | Offer "manual upload" mode: user provee logo, Logo dept skipea generation, derived assets still generated from user's logo |
| Derived asset composition fails (OG card rendering) | Composition utility error | Retry with fallback template. If persistent, skip that derivation, flag en output. |

### Activation

| Failure | Detection | Fallback |
|---|---|---|
| Stitch rate-limited (429 response) | HTTP 429 | Retry con exponential backoff (3 attempts, 30s / 60s / 120s waits). If persistent: degrade to internal HTML templates (lower quality). Flag: "UI generated without Stitch (degraded mode)." |
| Stitch generates invalid HTML | HTML5 parse check | Request regen con "output must be valid HTML5". Max 2 retries. If persistent, use fallback templates. |
| Stitch free tier exceeded (350/mes) | Quota-specific 429 | Notify user: "Stitch quota exceeded this month. Brand completed con manual templates. Full Stitch in next month run." Deliver with fallback. |
| Coherence gate fails persistently (>2 retries) | Gate retry counter | Escalate to user con options (ver [09-coherence-model.md#95](./09-coherence-model.md#95)) |
| PDF generation fails (`pdf` skill error) | Skill error response | Retry. If persistent, deliver package sin PDF, deliver markdown brand-book.md instead. Flag: "PDF conversion failed, markdown included." |
| Filesystem write fails (permissions, disk space) | IO error | Clear error message, abort, graba state in Engram para resume |
| Dependency on other dept outputs missing | Data presence check | Abort with clear error listing which dept outputs are missing |
| User cancels mid-activation | Signal | Persist state con `status: "partial"`. Resume via `/brand:resume`. |

## 13.4 Cross-cutting failure scenarios

### Session crashes / conversation context lost

Engram es persistent — si la conversation se resetea:
- Data en Engram sobrevive
- User puede `/brand:resume {slug}` para continuar
- Orchestrator detecta state en Engram y resumes desde el último dept completado

### User misbehavior

- **Invalid commands**: respond con help text, no halt
- **Contradictory overrides**: explicar conflict, ask for resolution
- **Abusive prompts**: ignore + continue with defaults

### Timing out

- Default timeout por depto: 15 min (generous)
- Después de timeout: abort that dept, flag en output, option to retry
- Orchestrator-level timeout: 60 min total (from scope to activation)

### Corrupted Engram data

- If `mem_get_observation` returns garbage: Log error, skip that data, proceed with partial
- User notified: "data del depto X corrupted, regenerating..."

## 13.5 Escalation UI templates

### Tool down escalation

```
⚠ {Tool name} está down después de 3 intentos.

Puedo proceder con fallback:
  {Fallback description specific to tool}

O podés:
  'retry' — intentar de nuevo (a veces servicios vuelven en segundos)
  'skip' — proceed sin este output, regenerar después
  'cancel' — abortar run, graba state for resume

¿Qué preferís?
```

### Quality failure escalation

```
⚠ {Dept} generó outputs {quality issue descripción}.

Probé {N} regeneraciones. Outputs actuales están {current state description}.

Opciones:
  'accept' — use current outputs con flags en brand book
  'regenerate' — intentar otra vez con tu feedback
  'manual' — proveé {asset} vos mismo, Brand continúa
  'cancel' — abort, resume después
```

### Coherence escalation

Ya cubierto en [09-coherence-model.md#95](./09-coherence-model.md#95).

### Scope low confidence escalation

Ya cubierto en [02-scope-analysis.md#27](./02-scope-analysis.md#27).

## 13.6 Partial output policy

Cuando un run falla parcialmente, el output entregado:

1. **README.md** del package DEBE declarar qué se completó + qué faltó
2. **AUDIT.md** graba failures exactos + retry attempts + tool errors
3. **Badge visual en brand book PDF**: "PARTIAL DELIVERY" header
4. **Engram `brand/{slug}/activation`** contiene `status: "partial"` + `failed_outputs: [...]`
5. **Resume path** documented: qué comando usar para completar

Ejemplo README header si partial:

```markdown
# Auren — Brand Package (PARTIAL DELIVERY)

⚠ Este run completó algunas pero no todas las operations:

Completed:
  ✓ Strategy
  ✓ Verbal Identity
  ✓ Visual System (sin mood imagery — Recraft API down)
  ✓ Logo (sin derivations completas — favicon generated, OG card pending)
  ✓ Activation (sin microsite — Stitch rate-limited)

Pending:
  ○ Visual mood imagery — retry: `/brand:extend visual.mood_imagery`
  ○ Logo OG card + some derivations — retry: `/brand:extend logo.derivations`
  ○ Microsite HTML — retry: `/brand:extend activation.microsite`

Todos los pending pueden completarse incrementalmente con los extend commands arriba.
Nada de lo completed se pierde — están persistidos en Engram.
```

## 13.7 Cost tracking in failure scenarios

Si failures causan retries, cost puede acumular más de lo esperado:

- Track cost actual vs estimated en AUDIT.md
- Cap cost máximo por run: $5 (10× el budget estimado es umbral de sanity check)
- Si se acerca al cap: alert user antes de continuar con más retries

## 13.8 Reference file a escribir en Sprint 0

`skills/brand/references/failure-protocols.md` con:
- Tabla exhaustiva de failures per tool
- Retry strategies detalladas
- Escalation UI templates completos
- Recovery commands mapping
- Partial output policies

## 13.9 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Simulate Stitch down → fallback templates kick in, output deliverable
2. Simulate Recraft down for logo → package entrega sin logo + flag
3. Inject invalid JSON from Strategy → parse error → retry works
4. Simulate filesystem permission error → clear abort, Engram state saved
5. User cancels at 50% → partial state saved, resumable
6. Coherence gate fails 3× → escalation UI triggered
7. Scope confidence 0.4 → user confirmation prompted
8. All naming candidates TM red → present with conflicts matrix
9. Cost cap reached → alert user
10. Session resume after crash → picks up where left off

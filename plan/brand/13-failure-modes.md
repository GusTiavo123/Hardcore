# 13 — Failure Modes y Fallbacks

## 13.1 Propósito

Documentar qué puede salir mal en cada paso + respuesta sistemática. Falla graceful > falla hard. El user siempre termina con algo usable o con un path claro de recovery.

## 13.2 Principios generales

1. **Never silent fail**: el user debe saber qué pasó y qué puede hacer
2. **Always degrade gracefully**: output parcial con flags > halt, salvo dependencias críticas (Engram, Claude Pro)
3. **Always recoverable**: `/brand:resume` o `/brand:extend` después de cualquier failure no-crítico
4. **Always traceable**: failures registradas en AUDIT.md + Engram
5. **Never retry infinitely**: max retries clara (2-3 según el tool), después escalate al user
6. **Hard failures son pocos**: sin Engram, sin Validation, sin Claude Pro → no podemos correr. El resto degrada.

## 13.3 Hard failures (halt absoluto)

Estos failures bloquean el pipeline completo. Surface al user con mensaje claro y abort:

| Failure | Detection | Mensaje al user |
|---|---|---|
| Engram MCP no disponible | tool availability check pre-flight | *"Brand requires Engram MCP. Start Engram and retry."* |
| Claude Pro subscription no detectada | pre-flight check (orchestrator) | *"Brand requires Claude Design access via Claude Pro, Max, Team, or Enterprise. Upgrade at claude.ai/upgrade and retry."* |
| Validation artifacts missing | `mem_search("validation/{slug}/*")` empty | *"No validation found for '{slug}'. Run /validate first."* |
| Validation verdict NO-GO sin override | verdict check | Block + opción `"brandea igual"` para override explícito + warning permanente en outputs |
| Profile hard-no violation | pre-filter check | *"La idea violates tu hard-no: '{hard_no}'. Revisá el profile o reconsiderá la idea."* Block. |
| Filesystem write denied | IO error al crear output dir | *"No puedo escribir en output/. Verificá permisos."* Abort. |

Todos los hard failures preservan state en Engram para `/brand:resume` cuando el issue se resuelva.

## 13.4 Soft failures por dept (graceful degradation)

### Scope Analysis

| Failure | Detection | Fallback |
|---|---|---|
| Scope confidence < 0.5 | calculation | Fallback a `b2b-smb` con flag `low_confidence_classification: true` + trigger user confirmation (Punto 1) |
| Insufficient data en validation para classificar cleanly | missing fields check | Use defaults del scope más cercano, flag |
| User cancels scope confirmation prompt | signal | Persist partial state, offer `/brand:resume` |

### Strategy

| Failure | Detection | Fallback |
|---|---|---|
| Todos los 12 archetypes blocked | empty filter result | Relax constraints removiendo `preferred_range` filter, flag `archetype_blocked_relaxation_applied: true` |
| Profile contradice positioning severely | consistency check | Flag conflict en envelope, elegir archetype least contradictory |
| Validation data insuficiente para sentiment_landscape derivation | missing fields | `sentiment_landscape: "insufficient_data"`, Gate 0 surface al user |
| Claude schema-invalid output | JSON parse fail | Retry con schema reminder, max 2 retries. Si persiste: halt dept + surface error |
| open-websearch falla (si Strategy lo usa para research adicional) | 3× retry fails | Proceed sin research externa, flag `external_research_skipped: true` |

### Verbal Identity

| Failure | Detection | Fallback |
|---|---|---|
| Domain MCP down | 3× retry fails | Skip domain verification, flag `domain_availability_checked: false` + mensaje al user *"Domains no verificados — retry con /brand:extend verbal.naming cuando Domain MCP vuelva"* |
| open-websearch falla (TM screening) | 3× retry fails | Skip TM screening, flag `trademark_screened: false` con warning explícito: *"TM no verified — consultá manualmente en USPTO TESS y WIPO Global Brand Database"* |
| 0 names pass checks (todos red en TM o domain) | all candidates flagged | Present raw candidates + conflicts matrix, user decide si adopta alguno con tensión o pide regen |
| Todos los `.com` están taken para todos los candidates | domain check | Suggest modifier strategies (prefix, suffix, alternate TLD), regenerate |
| User rechaza 3+ rondas de naming | input pattern | Offer "manual name" mode |
| Copy voice self-check falla persistently | 2× retries fail | Include copy con flag `voice_compliance_partial: true`, no halt — Gate 7 lo agarrará si es severo |

### Visual System

| Failure | Detection | Fallback |
|---|---|---|
| Unsplash API down | 3× retry fails | Skip mood imagery refs. Brand Document describe mood en prosa sin imágenes. Flag `mood_imagery_skipped: true` |
| Unsplash devuelve 0 resultados para queries | response check | Refine queries con synonyms; si sigue 0, skip mood refs con flag |
| Claude-generated palette falla WCAG contrast | WCAG check | Auto-adjust darkening/lightening hasta pasar; si no fixable después de 2 iteraciones, regenerate palette entero |
| Typography pairing no tiene Google Fonts adecuadas | catalog lookup fail | Fallback a Inter + Fraunces + JetBrains Mono (default pairing). Flag `typography_fallback_to_default: true` |

### Logo & Key Visuals

| Failure | Detection | Fallback |
|---|---|---|
| Claude-generated SVG inválido (XML parse fail) | parse error | Retry con explicit prompt. Max 2 retries por concept. Si persiste: skip ese concept, continuar con los que sí pasaron (mínimo 3 válidos) |
| SVG malformed semánticamente (paths vacíos, colors invalid) | validation fails | Retry con format emphasis. Max 2 retries |
| Quality validation falla en 2+ concepts consecutivos | quality counter | Include con flag `quality_degraded: true` y warning al user en Punto 4 |
| App icon 16×16 no legible (consumer-app, `app_asset_criticality: primary`) | visual scale check | Regenerate con prompt adicional de simplificación. Max 3 retries. Si persistent: flag + warn user, ofrecer manual-upload |
| User rechaza 3+ rondas de regeneration | input pattern | Offer "manual upload" mode |
| Rasterization tool (headless chromium / rsvg) down o ausente | tool check | Entregar SVGs sin PNGs, README con instrucciones manuales de conversión. Flag `rasterization_deferred_to_user: true` |

### Handoff Compiler

| Failure | Detection | Fallback |
|---|---|---|
| PDF generation falla | `ms-office-suite:pdf` skill error | Retry. Si persiste: deliver package con `brand-design-document.md` (markdown) + instrucciones de conversión manual. Flag `pdf_conversion_failed: true` |
| JSON token file invalid | schema validation | Retry con explicit format reminder. Max 2. Flag `token_file_validation_failed: tokens.json` |
| CSS token file invalid syntax | CSS parser | Retry. Max 2. Flag |
| HTML example invalid | HTML5 parser | Retry. Max 2. Flag |
| Tailwind config no es JS válido | Node syntax check | Retry. Max 2. Flag |
| Coherence gate falla | gate check | **Fail-fast**: halt + surface al user con opciones (re-run dept, accept con flag, abort). Ver [09-coherence-model.md](./09-coherence-model.md) |
| Filesystem write fails (permissions) | IO error | Clear error, abort, state saved en Engram |
| Disk space insufficient | IO error | Clean up partial, clear error al user |

## 13.5 Cross-cutting failure scenarios

### Session crashes / context loss

Engram es persistent — si la conversation resetea:
- Data en Engram sobrevive
- User: `/brand:resume {slug}` para continuar
- Orchestrator detecta state en Engram y resumes desde último dept completado (o desde el último gate pendiente si fue un halt sin decisión)

### User misbehavior

- **Comandos inválidos** → help text
- **Contradictory overrides** (ej. `archetype=Outlaw` + `brand_profile=b2b-enterprise`) → explicar conflicto + pedir resolution
- **Overrides fuera del allowlist** → rejection con lista del allowlist valid
- **Prompts abusivos** → ignore y continuar defaults

### Timing out

- **Default timeout per dept**: 15 min (evita runs colgados por infinite retry)
- Después de timeout: abort ese dept, flag, ofrecer `/brand:extend {dept}` para retry
- **Orchestrator-level timeout**: 60 min total (no incluye post-delivery Claude Design handoff que es user-mediated off-module)
- Si el total se excede, ofrecer `/brand:resume` en vez de abortar

### Corrupted Engram data

- `mem_get_observation` returns garbage (schema mismatch, parse error)
- Log error, skip esa entry, proceed con degraded data donde sea posible
- User notificado con flag `engram_data_corruption: {topic_key}`

## 13.6 Escalation UI templates

### Tool down

```
⚠ {Tool name} falló 3 intentos.

Impact: {qué output se ve afectado}

Puedo proceder con fallback:
  {Fallback description}
  (Flag permanente en el brand book: "{flag text}")

O podés:
  'retry' — intentar de nuevo ahora
  'skip' — proceder sin este output (con flag)
  'cancel' — abortar run, state saved para `/brand:resume`

¿Qué preferís?
```

### Quality failure

```
⚠ {Dept} generó outputs con {quality issue}.

Probé {N} regeneraciones. Current state: {description}.

Opciones:
  'accept' — use current con flag en brand book
  'regenerate' — intentar con tu feedback
  'manual' — proveé {asset} vos mismo
  'cancel' — abort, resume después
```

### Coherence gate halt (fail-fast)

Ver [09-coherence-model.md §9.6](./09-coherence-model.md).

### Scope low confidence

Ver [02-scope-analysis.md §2.4 Paso F](./02-scope-analysis.md).

### Claude Pro missing (pre-flight)

```
⚠ Brand requiere Claude Design access.

Claude Design está disponible en:
  • Claude Pro (~$20/mo)
  • Claude Max
  • Claude Team
  • Claude Enterprise

No disponible en Free tier.

Upgrade: claude.ai/upgrade
Una vez upgrado, corré `/brand:new` de nuevo.

El run no se ejecutó — no hay state que recuperar.
```

## 13.7 Partial output policy

Cuando un run llega al final pero con algún soft-failure en el camino:

1. **README.md** declara explícitamente qué se completó + qué faltó
2. **AUDIT.md** graba todos los failures + retry attempts + tool errors
3. **Badge en el Brand Document PDF** (si aplicable): "PARTIAL DELIVERY" en cover
4. **Engram `brand/{slug}/handoff`** contiene `status: "partial"` + `failed_outputs: [...]`
5. **Resume path documented** en el README para completar lo pendiente

Ejemplo header README partial:

```markdown
# Auren — Brand Package (PARTIAL DELIVERY)

⚠ Este run completó algunas operations pero no todas:

Completed:
  ✓ Strategy
  ✓ Verbal Identity (TM screening skipped — open-websearch down)
  ✓ Visual System
  ✓ Logo
  ⚠ Handoff Compiler: PDF falló, markdown entregado como alternativa

Pending:
  ○ brand-design-document.pdf — retry con `/brand:extend handoff`
  ○ trademark screening — retry con `/brand:extend verbal` cuando open-websearch vuelva

Claude Design handoff requires PDF. Mientras el PDF regenerates, podés usar:
  • brand-design-document.md (markdown alternativa) + upload via codebase link en Claude Design
  • O esperar a regenerar el PDF

Todos los pending pueden completarse con extend commands arriba.
Nada de lo completed se pierde — persistido en Engram.
```

## 13.8 Claude Design-specific failure modes

### User reports que Claude Design no extrae el design system correctamente desde el PDF

**Detection**: user feedback post-delivery.

**Response**:
- Verificar que el PDF tenga todas las secciones required (ver [23-brand-design-document-structure.md](./23-brand-design-document-structure.md))
- Si faltan secciones: re-run Handoff Compiler con flag de diagnóstico y regenerar
- Si las secciones están: investigar Claude Design parsing (puede requerir update del template si Claude Design cambió expectations de formato)
- Backup path: usar los 3 deliverables secundarios (Prompts Library + Brand Tokens + Reference Assets) para seedear el design system manualmente en Claude Design

### Claude Design sale de Labs con breaking changes en el formato esperado

**Detection**: Anthropic announcement + testing reveals issues.

**Response**:
- Update del Brand Document template en Handoff Compiler
- Re-test todos los scope profiles
- Bump `brand_module_version`
- Notificar a existing users para regenerar packages

### Claude Design MCP/API se ship (futuro)

**Detection**: Anthropic announcement.

**Response**:
- Agregar `--auto-upload` flag al Handoff Compiler que invoca directamente el MCP/API
- Mantener path manual como fallback
- No es un failure — es una evolución del handoff

## 13.9 Observability

Todo failure se registra en:

- **AUDIT.md** del package (human-readable)
- **`brand/{slug}/handoff.audit`** en Engram (machine-readable, para testing y cross-run analysis)

Formato en Engram:

```json
{
  "failures": [
    {
      "dept": "verbal",
      "type": "tool_timeout",
      "tool": "domain_availability_mcp",
      "retries_attempted": 3,
      "fallback_applied": "skip_verification",
      "flag_raised": "domain_availability_checked: false",
      "user_notified": true,
      "timestamp": "ISO-8601"
    }
  ]
}
```

## 13.10 Dónde vive esto en Sprint 0

El failure handling se escribe **dentro de `skills/brand/SKILL.md`** (orchestrator) como sección dedicada:
- Tabla exhaustiva de failures per tool
- Retry strategies detalladas
- Escalation UI templates completos
- Recovery commands mapping (`/brand:resume`, `/brand:extend`)
- Partial output policies
- Hard vs soft failure distinction

Failures específicos por dept (SVG validation, palette WCAG, domain MCP timeouts, etc.) se documentan dentro del SKILL.md del dept correspondiente. No hay ref standalone — los failure protocols son lógica de orchestrator + dept, no data consultada repetidamente.

## 13.11 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Simulate Engram down → hard halt con mensaje claro
2. Simulate Claude Pro missing en pre-flight → hard halt
3. Simulate Validation missing → hard halt con instrucción `/validate`
4. Simulate Domain MCP down → graceful skip en Verbal con flag
5. Simulate open-websearch down → skip TM screening + sentiment derivation con flags
6. Simulate Unsplash down → skip mood imagery con flag
7. Simulate PDF skill error → markdown fallback works
8. Inject invalid JSON en tokens → retry + validation works
9. Simulate filesystem permission error → clear abort con state saved
10. User cancels at 50% → partial state saved, `/brand:resume` recupera
11. Coherence gate fails → fail-fast halt, user decides, pipeline continúa según decisión
12. Scope confidence < 0.5 → user confirmation prompted con fallback a b2b-smb
13. All naming candidates TM red → present con conflicts matrix al user
14. Session crash mid-run → Engram preserva state, `/brand:resume` funciona
15. SVG generation persistent fail → skip concept, min 3 concepts válidos para continuar
16. Rasterization tool ausente → entregar SVGs con instrucciones manuales

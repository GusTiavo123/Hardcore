# 19 — Edge Cases

## 19.1 Propósito

Casos no-happy-path que el módulo maneja correctamente. Cada edge case con detección + respuesta.


## 19.2 Input edge cases

### Brand sin Profile

**Situación**: user invoca Brand sin profile creado.

**Comportamiento**:
- Brand NO bloquea
- Scope Analysis procede con idea + validation only
- Strategy archetype sin profile fit check
- Verbal usa market.geographies como fallback
- Outputs con flag `"decided_without_profile: true"`
- README recomenda `/profile:new`

### Brand sobre Validation NO-GO

**Comportamiento**:
- Default: bloqueado con mensaje
- Override: `--force` flag, warning permanente grabado

### Brand sin Claude subscription

**Situación**: user completa Brand run pero no tiene Claude Pro+ para usar Claude Design.

**Detección**: orchestrator no puede verificar programáticamente (Claude subscription es external). Lo detectamos si user reporta en reveal.

**Comportamiento**:
- Brand run procede normalmente (genera 4 deliverables)
- README del package explica alternative paths:
  - Upgrade Claude Pro para usar Claude Design
  - Usar Brand Design Document PDF como brief para Figma AI / Midjourney / human designer
  - Usar Brand Tokens en cualquier codebase
  - Reference Assets son usables en cualquier tool

Ver [16-v1-limitations.md](./16-v1-limitations.md#dependencia-de-claude-design-para-execution).

### Brand sobre idea con múltiples Validations

- Default: latest snapshot
- `/brand:new --validation-version=v1` para specific

### Brand sobre idea híbrida

- `primary + secondary` con composition_weights
- Union de required outputs
- Intensity modifiers weighted
- Tier: max de ambos (conservative)

### Brand sobre idea que no matchea ningún profile

- `confidence < 0.5` → fallback `b2b-smb` con flag
- Manual classification prompt

## 19.3 Execution edge cases

### User cancels mid-flow

- Persist state partial en Engram
- Show summary de completado
- `/brand:resume` para continuar

### Timeout en user interaction

- 10 min no response → pause
- 24h → cancel run, flag incomplete

### Partial run (failures mid-flow)

- Deliver con lo completado + flags
- `/brand:extend {failed_dept}` retry

### Re-run completo en idea ya brandeada

- Confirm user: new run (v2), extend, show v1, cancel

### Inputs modificados desde último run

- Detect via input hashes
- Inform user + continue/cancel choice

## 19.4 Tier-related edge cases

### Scope requires symbolic-first pero user en Tier 0

**Detección**: pre-check en Logo dept.

**Respuesta**: tier elevation prompt (Punto 5 de interaction):

```
Tu scope requiere symbolic logos.
Tier 0 produce wordmarks bien pero symbolic limitados.

Opciones:
  1. Elevar a Tier 1 (~$0.20)
  2. Cambiar a wordmark-preferred
  3. Proceder Tier 0 acknowledging quality loss
```

### User previously set --tier=0 explicitly pero scope requires elevation

**Comportamiento**: respetar user preference. Warning visible pero no bloquea.

```
⚠ Vos elegiste Tier 0 pero scope sugeriría Tier 1+.
Continuando Tier 0. Symbolic logos tendrán quality limitada.

Si cambias de opinión: /brand:extend logo --tier=1
```

### Tier elevation mid-run

**Situación**: durante run, algún gate o quality validation triggers tier elevation.

**Comportamiento**: 
- Pause, ask user confirmation para additional cost
- If yes: proceed at higher tier from that point
- Grabar tier change en audit

### User exceeds Tier 2 free budgets

**Situación**: Tier 2 genera muchos retries, cost aproxima cap.

**Comportamiento**:
- Alert at 70% of per-run cap
- Pause at 100% cap, user confirms continuation

## 19.5 Output edge cases

### Package path conflict (re-run)

- Default: backup current → overwrite
- Previous snapshot files preserved en backup
- `/brand:cleanup` deletes old

### File system permissions

- Clear error message
- State preserved en Engram

### Disk space insufficient

- Clean up partial files
- Suggest `/brand:cleanup`

## 19.6 User input edge cases

### Invalid override

- Reject con explicit reason + valid options

### Override conflicts con scope

- Block + options (change override, change scope, force with warning)

### User requests asset out of scope v1

- Explicit rejection + alternatives:
  - Brand Document PDF como brief para human designer
  - Future Hardcore modules (Brand-Physical, etc.)

## 19.7 Tool edge cases

### Multiple tools down simultaneamente

- Handle independently (retries, fallbacks)
- Multiple critical: user confirms continue con severe degradation or cancel

### Tool returns unexpected format

- Flag in internal logs
- Retry con format emphasis
- Fallback if persistent

### Huemint returns invalid color (Tier 1+)

- Clamp to valid RGB range
- Retry with different temperature
- Fallback Claude palette (Tier 0 behavior)

## 19.8 Data consistency edge cases

### Engram inconsistency

**Situación**: topic keys conflicting (ej: strategy present pero visual missing).

**Comportamiento**: warn + offer options (re-run depto, full re-run, inspect Engram)

### Filesystem / Engram divergence

**Detección**: missing files vs snapshot manifest.

**Respuesta**: warn + options (regenerate, restore from backup, continue partial)

## 19.9 Concurrency edge cases

### Two brand runs simultaneous on same idea

- Block second: options (cancel ongoing, wait, resume)

### Brand runs on different ideas simultaneously

- Allowed — no conflict

## 19.10 Claude Design-related edge cases

### User uploads Brand Document PDF but Claude Design rejects/fails

**Detección**: user reports issue post-delivery.

**Posibles causas + responses**:
- PDF demasiado grande → regenerate con compression flag
- Claude Design cambios de formato expectations → update Hardcore PDF generation
- Specific page corruption → regenerate specific section

### Claude Design extracts design system incorrectly

**Situación**: user uploads, Claude Design extracts but colors/fonts don't match.

**Comportamiento**:
- Investigate: fue nuestro output incomplete o Claude Design parsing issue?
- Si fue nuestro: fix Handoff Compiler template
- Si fue Claude Design: document workaround (manual color/font entry in Claude Design)

### Claude Design changes behavior breaking our PDF

**Situación**: Anthropic updates Claude Design, parsing changes.

**Comportamiento**:
- Monitoring post-launch
- Quick update al Brand Document template
- Bump brand_module_version
- Notify existing users para regenerate

### Anthropic releases Claude Design MCP

**Situación**: Claude Design exposes API/MCP.

**Comportamiento**:
- Update Handoff Compiler con `--auto-setup` flag
- Integrate MCP invocation
- Mantain manual path como fallback
- Update docs + version bump

## 19.11 Reference file a escribir en Sprint 0

`skills/brand/references/edge-cases.md` con tabla completa de cada edge case + detección + response.

## 19.12 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Edge cases críticos:

- [ ] Brand sin profile → flagged, runs
- [ ] NO-GO blocked por default, --force works
- [ ] Idea híbrida → merged manifest
- [ ] Low-confidence scope → user confirmation
- [ ] User cancel → state persisted, resumable
- [ ] Re-run on existing → choice prompted
- [ ] Invalid override → rejection
- [ ] Conflicting override → blocked con options
- [ ] Out-of-scope request → alternatives
- [ ] Tool down → fallback
- [ ] Engram inconsistency → detected
- [ ] Concurrent runs same slug → blocked
- [ ] Concurrent different slugs → both proceed
- [ ] Tier 0 symbolic request → elevation prompt
- [ ] User keeps Tier 0 despite elevation → proceed with flag
- [ ] User sin Claude subscription → README guidance
- [ ] Claude Design handoff issues → troubleshooting guidance

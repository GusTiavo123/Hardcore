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

### Brand sin Claude Pro subscription

**Situación**: user invoca Brand sin Claude Pro/Max/Team/Enterprise.

**Detección**: pre-flight check del orchestrator (ver 08-dept-handoff-compiler.md §8 y 13-failure-modes.md §13.3).

**Comportamiento**: hard halt antes de lanzar ningún dept. Mensaje claro:

```
⚠ Brand requires Claude Design access.

Claude Design está disponible en Claude Pro, Max, Team o Enterprise.
Upgrade en claude.ai/upgrade y corré /brand:new de nuevo.

El run no se ejecutó — no hay state parcial.
```

Ver [16-v1-limitations.md](./16-v1-limitations.md#dependencia-de-claude-design-gate-de-entrada).

### Brand sobre idea con múltiples Validations

- Default: latest snapshot
- `/brand:new --validation-version=v1` para specific

### Brand sobre idea híbrida

- `primary + secondary` con composition_weights
- Union de required outputs
- Intensity modifiers weighted (ver 03-brand-profiles.md §3.12)

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

## 19.4 Logo form edge cases

### Scope demanda ilustración orgánica compleja

**Situación**: scope configuración sugiere mark con ilustración expresiva (ej. mascota) que Claude native SVG no alcanza con consistencia.

**Detección**: el user feedback en el logo selection indica "más orgánico" o rechaza múltiples rounds geometric.

**Respuesta**:
- Flag `organic_mark_requested_geometric_delivered: true`
- Sugerir manual-upload del mark orgánico hecho por un illustrator con nuestro Brand Document como brief
- O iterar geometric en Claude Design downstream para variaciones orgánicas sobre la base

### User rechaza 3+ rondas de logo

**Respuesta**: después de 3 rondas, offer "manual upload" mode. User provee SVG propio, dept valida y propaga a Handoff.

### Quality validation fails persistently en todos los concepts

**Respuesta**: present con flag `quality_degraded: true`, user elige acepta, regen, o manual-upload.

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

### Palette generation produce colors inválidos (fuera de gamut RGB o contrast insuficiente en todas las combinations)

- Auto-adjust para llevar dentro de gamut
- Re-run palette generation con seeds más distantes si contrast sigue failing
- Surface al user con 3 alternate palettes si automated fixes no resuelven

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

## 19.11 Dónde vive esto en Sprint 0

Edge cases handling se escribe **dentro de `skills/brand/SKILL.md`** (orchestrator) como sección dedicada con tabla completa de cada edge case + detección + response. Edge cases específicos por dept van dentro del SKILL.md del dept correspondiente.

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
- [ ] User rechaza 3+ rounds de logo → manual upload mode offered
- [ ] Scope demanda mark orgánico complejo → flag + manual-upload suggestion
- [ ] User sin Claude Pro → pre-flight halt con mensaje claro
- [ ] Claude Design handoff issues → troubleshooting guidance en README

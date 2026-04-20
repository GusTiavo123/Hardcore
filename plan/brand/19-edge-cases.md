# 19 — Edge Cases

## 19.1 Propósito

Documentar casos no-happy-path que el módulo debe manejar correctamente. Edge cases mal manejados = user frustrado. Cada edge case con detección + respuesta.

## 19.2 Edge cases por categoría

## 19.3 Input edge cases

### Brand sin Profile

**Situación**: user invoca Brand pero no tiene profile creado.

**Detección**: `mem_search("profile/{user-slug}")` returns empty.

**Comportamiento**:
- Brand NO bloquea (no se halta la ejecución)
- Scope Analysis procede con solo idea + validation
- Strategy archetype chosen without profile fit check (basado en idea + scope constraints)
- Verbal no usa `profile.target_geographies` para linguistic check (usa `market.geographies` como fallback)
- Todos los outputs get flag `"decided_without_profile: true"`
- README del package:
  ```
  ⚠ Brand generado sin profile del founder.
  Personalization parcial. Considerá crear profile con `/profile:new`
  y regenerar el brand para output más personalizado.
  ```

**Test case**: Brand run sin profile completa exitosamente con flags.

---

### Brand sobre Validation NO-GO

**Situación**: idea tiene verdict NO-GO, user intenta brandear.

**Detección**: Validation synthesis report check.

**Comportamiento**:
- Default: bloqueado con mensaje:
  ```
  ⚠ Esta idea tiene verdict NO-GO en Validation.
  
  Knockouts activos:
    - Problem score 32 < 40 (sin evidence de pain real)
    - Risk score 25 < 30 (reguladores bloquean modelo)
  
  Brandearla sería fabricar identidad sobre fundamentos débiles.
  
  Si querés continuar de todos modos:
    /brand:new --force
  
  Si querés re-validar (recommended):
    /validation:new
  ```

- Override path: `--force` flag explicit
  - Grabar decisión + warning permanente en Engram: `brand/{slug}/forced_no_go: true`
  - Proceder con todas las limitations habituales
  - Brand book incluye warning visible:
    ```
    ⚠ DISCLAIMER: Esta marca fue generada para una idea con verdict NO-GO en Validation.
    Los knockouts documentados no fueron resueltos. Considerar re-validar antes de usar
    esta marca commercially.
    ```

**Test case**: NO-GO blocking works, --force override works con warnings.

---

### Brand sobre idea con múltiples Validations

**Situación**: user ha corrido Validation 2+ veces sobre la misma idea (snapshots v1, v2). ¿Cuál consume Brand?

**Detección**: Multiple snapshots found.

**Comportamiento**:
- Default: consume el latest snapshot
- User puede specificar: `/brand:new --validation-version=v1` para usar otro
- Reveal show qué version se usó

**Test case**: default latest, --validation-version override works.

---

### Brand sobre idea híbrida (multi-profile)

**Situación**: idea matches multiple brand profiles significativamente (ej: b2d-devtool + community-movement).

**Detección**: Scope Analysis returns primary + secondary con composition_weights.

**Comportamiento**:
- Output manifest toma UNION de required de ambos profiles
- Optional recommended también union
- Skip: intersection (solo si AMBOS skipean)
- Intensity modifiers: weighted average para escalas continuas, primary gana categóricas si weight > 0.6
- Archetype constraints: union de blocked, intersection de preferred_range
- README explica la composition:
  ```
  Scope identificado: híbrido
    Primary: b2d-devtool (weight 0.65)
    Secondary: community-movement (weight 0.35)
  
  Package incluye outputs de ambos profiles.
  ```

**Test case**: hybrid scope produces merged output manifest correctly.

---

### Brand sobre idea que no matchea ningún profile bien

**Situación**: Scope Analysis confidence < 0.5 for todos los profiles.

**Detección**: primary_confidence < 0.5.

**Comportamiento**:
- Fallback a `b2b-smb` (most generic) con flag `"low_confidence_classification: true"`
- PERO pregunta al user para manual confirmation:
  ```
  No pude clasificar tu idea con confianza alta en los 8 brand profiles canónicos.
  
  Mejor match: b2b-smb (confidence 0.42)
  
  ¿Qué preferís?
    1. Usar b2b-smb como scope (puede no encajar perfectamente)
    2. Clasificar manualmente — describí qué tipo de producto es
    3. Cancelar — mejorar la idea o profile antes de brandear
  ```
- Si user elige manual (option 2), ask follow-up questions para refinar
- Grabar como data interesante para future profile creation

**Test case**: low confidence triggers user confirmation + manual path works.

## 19.4 Execution edge cases

### User cancels mid-flow

**Situación**: user hits Ctrl+C, interrupt signal, o dice "cancel".

**Detección**: signal interrupt.

**Comportamiento**:
- Persistir state actual en Engram con `status: "partial"`
- Graba qué dept estaba ejecutando
- Show summary:
  ```
  Run cancelled at Depto: ④ Logo
  
  Completed:
    ✓ Scope Analysis
    ✓ Strategy (Sage archetype)
    ✓ Verbal Identity (Auren + 18 copy assets)
    ✓ Visual System (palette + typography + 6 mood)
    ⚠ Logo: 4 concepts generados pero no user selection
    ○ Activation: not started
  
  Resume con: `/brand:resume auren-compliance`
  ```

- `/brand:resume` pickup desde donde quedó

**Test case**: mid-flow cancel persists state, resume works.

---

### Timeout en user interaction

**Situación**: user no responde por 10+ minutos en interaction prompt.

**Detección**: no input after configurable timeout.

**Comportamiento**:
- Después de 10 min: pause y persist state. Show "Pausado por inactividad. Resume con `/brand:resume`."
- Después de 24 hours: cancel run, flag as incomplete.

**Test case**: long idle triggers pause, resume works.

---

### Partial run (failures mid-flow)

**Situación**: un dept falla (ej: Recraft down durante Logo), no hay recovery.

**Detección**: dept status "failed" despite retries.

**Comportamiento**:
- Entregar package con lo completado + flags en README
- Partial state flag en Engram
- `/brand:extend {failed_dept}` retry path documented

Ver [13-failure-modes.md](./13-failure-modes.md#partial-output-policy) para policy completa.

**Test case**: Recraft down mid-run → partial package delivered con flags.

---

### Re-run completo en idea ya brandeada

**Situación**: user corre `/brand:new` sobre una idea que ya tiene snapshot v1.

**Detección**: `brand/{slug}/snapshot/v1` existe en Engram.

**Comportamiento**:
- Confirm con user:
  ```
  Ya existe brand v1 para esta idea (creado 2026-04-20).
  
  ¿Qué querés hacer?
    1. Nuevo run completo (crea v2, keeping v1 para comparison)
    2. Extend selected parts (ej: /brand:extend logo)
    3. Show current v1 (`/brand:show`)
    4. Cancel
  ```
- Si opción 1: procede, crea v2
- Opción 2: cancels y ask qué dept extend

**Test case**: re-run on existing brand triggers choice, v2 created correctly.

---

### Inputs modificados desde último run

**Situación**: user corrió Brand v1, después updateó Profile, ahora quiere re-run.

**Detección**: input hashes en snapshot v1 vs current inputs diferentes.

**Comportamiento**:
- Inform user del cambio:
  ```
  Tu profile cambió desde el último brand run:
    - Updated: profile.constraints.risk_tolerance (low → medium)
    - Added: profile.skills.business ("Sales")
  
  Esto podría afectar:
    - Archetype selection (Hero ahora posible)
    - Voice attributes modulation
  
  Continuar con re-run? [y/n]
  ```
- Si sí: procede, v2 con nuevos inputs
- Audit graba diff entre inputs

**Test case**: input change detection triggers notice.

## 19.5 Output edge cases

### Package path conflict (filesystem)

**Situación**: `output/{slug}/brand/` ya existe (re-run sobre idea existente).

**Comportamiento**:
- Default: backup current state a `output/{slug}/brand-v1-backup/` antes de sobrescribir
- Luego recrea `output/{slug}/brand/` con nuevos files
- Previous snapshot files preserved en backup
- User puede `/brand:cleanup` para deletar backups viejos

**Test case**: re-run preserves old state via backup.

---

### File system permissions

**Situación**: permission denied en `output/` directory.

**Detección**: IO error on write.

**Comportamiento**:
- Clear error message:
  ```
  ⚠ No pude escribir en output/auren-compliance/brand/
  
  Error: Permission denied
  
  Solutions:
    - chmod 755 output/
    - chown {user} output/
    - Run Hardcore con permissions elevados
  
  Tu progreso está guardado en Engram. Fix permissions y retry con:
    /brand:resume auren-compliance
  ```

**Test case**: permission errors handled gracefully.

---

### Disk space insufficient

**Situación**: `/` or `output/` está full durante package assembly.

**Detección**: IO error specific a disk full.

**Comportamiento**:
- Clean up partial files del current run
- Clear error:
  ```
  ⚠ Disk space insufficient para completar package.
  
  Required: ~60MB
  Available: ~12MB
  
  Free up space (podrías usar /brand:cleanup para deletar old backups) y retry:
    /brand:resume
  ```

**Test case**: disk full errors handled, progress preserved in Engram.

## 19.6 User input edge cases

### User provee override inválido

**Situación**: `/brand:override archetype=InvalidName`

**Comportamiento**:
- Reject con explicit reason:
  ```
  Override rejected: "InvalidName" no es un archetype válido.
  
  Archetypes válidos: Innocent, Sage, Explorer, Outlaw, Magician, Hero,
                      Lover, Jester, Everyman, Caregiver, Ruler, Creator
  
  O remové el override y dejá a Strategy auto-seleccionar.
  ```

**Test case**: invalid overrides rejected clearly.

---

### User provee override en conflicto con scope

**Situación**: scope `b2b-enterprise`, user override `archetype=Jester` (bloqueado en archetype_constraints).

**Comportamiento**:
- Block por default:
  ```
  Override "archetype=Jester" rejected.
  
  Razón: Jester está bloqueado para scope b2b-enterprise.
  Reasoning: Jester tiene baja credibilidad en contextos B2B enterprise,
             puede alienar decision makers en sales cycles largos.
  
  Opciones:
    1. Use archetype compatible: Sage, Ruler, Hero, Creator, Caregiver, Everyman
    2. Cambiar scope manually con /brand:override scope=b2c-consumer-app
    3. Force con --force (NO recomendado; brand book incluirá warning permanente)
  ```

- `--force` path grabar warning + proceed

**Test case**: conflicting overrides blocked, --force works with warnings.

---

### User pide asset no supported

**Situación**: user dice `/brand:extend packaging-3d` (not en v1 scope).

**Comportamiento**:
- Explicit rejection:
  ```
  "packaging-3d" no está cubierto en Brand v1.
  
  Brand v1 cubre: digital brand assets (web, social, email, logo digital).
  
  Para packaging 3D, considerar:
    - Hire diseñador físico con el brand book como brief
    - Future módulo Brand-Physical (no built yet)
  
  Si querés, puedo generar un "packaging direction" brief:
    /brand:extend packaging-direction (returns escrito, no 3D render)
  ```

**Test case**: out-of-scope requests handled with alternatives.

## 19.7 Tool edge cases

### Multiple tools down simultaneamente

**Situación**: Recraft AND Stitch down simultaneamente.

**Comportamiento**:
- Each tool handled independently (retries, fallbacks)
- Si multiple critical tools down:
  ```
  ⚠ Multiple servicios críticos down:
    - Recraft (image gen)
    - Stitch (UI gen)
  
  Puedo proceder con severe degradation:
    - Logo: NO generado (fallback markdown description)
    - Microsite: NO generado
    - Mood imagery: NO generado
  
  Recomendación: cancelar y retry en 15-30 min.
  
  Cancel? [y/n]
  ```

**Test case**: multiple tool failures handled gracefully.

---

### Tool returns unexpected response format

**Situación**: Recraft devuelve raster PNG en vez de SVG.

**Detección**: output format check.

**Comportamiento**:
- Flag en internal logs
- Retry con explicit format request
- Si persiste: accept raster, flag en output "SVG not generated — raster fallback"

**Test case**: format mismatches handled.

---

### Huemint returns invalid color format

**Situación**: API devuelve algo parseable pero con colors fuera del espacio válido (ej: RGB > 255).

**Detección**: validation post-parse.

**Comportamiento**:
- Attempt to clamp values to valid range
- If unfixable: retry Huemint with different temperature
- If persistent: fallback a Claude-generated palette

**Test case**: invalid Huemint output handled.

## 19.8 Data consistency edge cases

### Engram inconsistency (topic keys conflicting)

**Situación**: `brand/{slug}/strategy` y `brand/{slug}/verbal` están pero `brand/{slug}/visual` missing inexplicably.

**Detección**: expected Engram read fails.

**Comportamiento**:
- Warn explicitly
- Offer options:
  ```
  ⚠ Inconsistencia en Engram data para {slug}:
    Missing: brand/{slug}/visual
    Present: brand/{slug}/strategy, brand/{slug}/verbal
  
  Posible causa: run previo partial o corrupted.
  
  Opciones:
    1. Re-run Visual System (/brand:extend visual) para completar
    2. Full re-run (cancel this, use /brand:new with overrides to preserve decisions)
    3. Manual inspect Engram (/brand:audit)
  ```

**Test case**: Engram inconsistencies detected and options offered.

---

### Filesystem / Engram divergence

**Situación**: Engram says snapshot v1 complete, but files missing from filesystem.

**Detección**: file existence check against snapshot manifest.

**Comportamiento**:
- Detect missing files at start of ANY brand command on that slug
- Warn y offer:
  ```
  ⚠ Algunos files del brand package v1 están missing:
    - microsite/index.html
    - logo/source/primary.svg
  
  Probably fueron deletados manualmente o filesystem corrupted.
  
  Opciones:
    1. Re-run para regenerate (puede ser parcial con extend)
    2. Restore from backup (si tenés)
    3. Continue sin estos (algunos features puede que no funcionen)
  ```

**Test case**: filesystem/engram divergence detected.

## 19.9 Concurrency edge cases

### Two brand runs simultáneamente on same idea

**Situación**: user inicia brand:new, antes de terminar inicia otro brand:new en same slug.

**Detección**: check for active brand session on slug.

**Comportamiento**:
- Block second: 
  ```
  Ya hay un brand run activo para {slug} (iniciado 3 min ago, stage: ② Verbal).
  
  Opciones:
    1. Cancelar el run en progreso y empezar nuevo
    2. Wait para que complete
    3. /brand:resume {slug} para ver status
  ```

**Test case**: concurrent runs on same slug prevented.

---

### Brand runs on different ideas simultáneamente

**Situación**: user corre brand:new en 2 ideas diferentes concurrently.

**Comportamiento**:
- Allowed — no conflict (different slugs, separate Engram topic keys, separate filesystem dirs)
- Each progresses independently
- Reveals labeled with idea slug para clarity

**Test case**: parallel brand runs on different slugs work.

## 19.10 Reference file a escribir en Sprint 0

`skills/brand/references/edge-cases.md` con tabla completa de cada edge case + detección + response.

## 19.11 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Edge cases críticos a testear:

- [ ] Brand sin profile → flagged, runs successfully
- [ ] Brand sobre NO-GO → blocked by default, --force works
- [ ] Brand sobre idea híbrida → merged manifest
- [ ] Low-confidence scope → user confirmation triggered
- [ ] User cancel mid-flow → state persisted, resumable
- [ ] Re-run on existing brand → choice prompted
- [ ] Invalid override → clear rejection
- [ ] Conflicting override → blocked con options
- [ ] Out-of-scope request → alternatives offered
- [ ] Tool down → fallback works
- [ ] Engram inconsistency → detected and handled
- [ ] Concurrent runs on same slug → second blocked
- [ ] Concurrent runs on different slugs → both proceed

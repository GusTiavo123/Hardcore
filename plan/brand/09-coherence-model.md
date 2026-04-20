# 09 — Coherence Model

## 9.1 Propósito

Brand produce outputs de 5 deptos distintos. **Coherencia cross-dept** es el moat del módulo — sin gates de coherencia enforced, podríamos tener un nombre que no rima con el copy, un logo que no respeta la paleta, una voice en el archetype incompatible.

Este archivo define los **9 coherence gates** que Activation enforza antes de delivery. Análogo a los knockouts de Validation, pero no rechazan — **regeneran el dept afectado** para resolver.

## 9.2 Principio general

**"Cada gate falla → dept responsible regenera con feedback → gate re-evalúa."**

Máximo 2 regeneration passes cross-dept. Si tras 2 passes el gate sigue fallando, **escalate al user** con opciones específicas.

## 9.3 Los 9 gates

### Gate 1 — Archetype ↔ Founder Profile

**Qué verifica**: El archetype elegido es compatible con las características del founder profile (si existe).

**Checks concretos**:

| Profile attribute | Archetype incompatible |
|---|---|
| `constraints.risk_tolerance: low` | Outlaw, Hero (primary), Rebel |
| `motivation.primary_goal: calm` | Jester, Hero, Outlaw |
| `motivation.orientation: business` (no creative) | — (ninguno bloquea, pero Creator scores lower) |
| `identity.personality: introverted (inferible)` | Jester, Hero público |
| `constraints.hard_nos` contiene tema del archetype | contextual |

**Si falla**: Strategy regenera archetype con nuevo constraint set. Escoge next-best candidate de alternatives documented.

**Si no hay profile**: skip este gate (no datos para evaluar).

### Gate 2 — Voice ↔ Archetype

**Qué verifica**: Los voice attributes exhiben la personalidad del archetype.

**Compatibility matrix** (subset):

| Archetype | Voice attributes compatibles | Voice attributes incompatibles |
|---|---|---|
| Sage | claro, autorizante, preciso, pedagógico, medido | playful, visceral, raw, irónico (salvo light) |
| Ruler | confiado, premium, exclusivo, autorizante, formal | casual, humilde, playful |
| Jester | juguetón, irónico, ligero, irreverente, inesperado | formal, medido, grave |
| Outlaw | contundente, desafiante, visceral, provocador | medido, suave, amigable |
| Caregiver | empático, cálido, protector, reconfortante | desafiante, distant, frío |
| ... | ... | ... |

**Check implementation**: Claude reasoning basado en la tabla + samples del copy.

**Si falla**: Verbal regenera copy con voice reminder explícito. O Strategy ajusta voice attributes hacia el archetype.

### Gate 3 — Palette ↔ Archetype

**Qué verifica**: La paleta generada respeta las tendencias del archetype.

**Checks**:

- Cool deep tones para Sage, Ruler, Magician → OK
- Warm soft tones para Caregiver, Innocent → OK
- High contrast para Outlaw, Hero → OK
- Vibrant multi para Jester, Creator → OK
- **Mismatch ejemplos**: Sage con neon colors → FAIL. Caregiver con harsh high-contrast → FAIL.

**Check implementation**: HEX values analyzed (saturation, brightness, contrast) compared to archetype expected range.

**Si falla**: Visual System regenera palette con seed colors ajustados al archetype.

### Gate 4 — Palette ↔ Scope (visual_formality)

**Qué verifica**: La paleta respeta el `visual_formality` del scope.

**Checks**:

- `visual_formality: high` → saturación < 60, no multi-accent > 2, no neons
- `visual_formality: medium` → saturation ≤ 80, 1-2 accents OK
- `visual_formality: low` → permisivo, hasta 3 accents, saturation alta OK

**Si falla**: Visual System regenera palette con formality constraint explícito.

### Gate 5 — Typography ↔ Archetype/Era

**Qué verifica**: El typography pairing matches tanto archetype como typography_era.

**Checks**:

- Archetype Sage + era neutral-modern → Fraunces + Inter OK; display font heading → FAIL
- Archetype Jester + era experimental → display expressive OK; classical serif → FAIL
- Archetype Ruler + era editorial-classic → Playfair + Söhne OK

**Si falla**: Visual System cambia pairing.

### Gate 6 — Logo ↔ Palette (legibility)

**Qué verifica**: El logo renderiza legible en **todas** las variantes de palette.

**Checks**:

- Primary logo sobre background color: contrast ratio ≥ 4.5:1
- Primary logo sobre primary color: contrast ratio ≥ 4.5:1
- Mono variant sobre any bg: ratio ≥ 4.5:1
- Inverse variant sobre dark bg: ratio ≥ 4.5:1

**Implementation**: Pixel-level contrast analysis del SVG rendered.

**Si falla**: Logo regenera variant afectado con color adjustments.

### Gate 7 — Copy ↔ Voice (sample check)

**Qué verifica**: Sample chunks del copy generado exhiben los voice attributes detectably.

**Implementation**:
- Select 5 random copy chunks del Verbal output
- For each, Claude self-check: "¿Este text exhibe {voice_attribute_1}, {voice_attribute_2}, ...?"
- If ≥80% exhibit each attribute, pass
- Otherwise fail con specific assets flagged

**Si falla**: Verbal regenera los chunks flagged con voice reminder.

### Gate 8 — Logo form ↔ Scope

**Qué verifica**: El logo chosen respeta `scope.intensity_modifiers.logo_primary_form`.

**Checks**:

- `logo_primary_form: icon-first` → chosen logo debe ser symbolic o combination con symbol dominant
- `logo_primary_form: wordmark-preferred` → chosen debe incluir wordmark prominente
- `logo_primary_form: symbolic-first` → chosen debe ser symbolic predominantly

**Si falla**: user override o Logo regenera con form constraint.

### Gate 9 — Screen set ↔ Manifest

**Qué verifica**: Todos los screens listed en `scope.output_manifest.required` para Activation están generados y válidos.

**Checks**:

- Para cada `activation.{screen}` en required: archivo existe, HTML parseable, no empty
- Stitch outputs validados individualmente

**Si falla**: Activation re-invoca Stitch para screens faltantes.

## 9.4 Implementation pattern

```
def run_coherence_gates(brand_outputs):
    gates = [
        Gate1_ArchetypeFounder,
        Gate2_VoiceArchetype,
        Gate3_PaletteArchetype,
        Gate4_PaletteScope,
        Gate5_TypographyArchetype,
        Gate6_LogoPalette,
        Gate7_CopyVoice,
        Gate8_LogoFormScope,
        Gate9_ScreenSetManifest
    ]
    
    retry_count = {}  # {gate_id: count}
    
    for gate in gates:
        result = gate.check(brand_outputs)
        
        if result.passed:
            continue
        
        responsible_dept = result.responsible_dept
        feedback = result.feedback
        
        retry_count[gate.id] = retry_count.get(gate.id, 0) + 1
        
        if retry_count[gate.id] > 2:
            # Escalate to user
            options = build_user_options(result)
            user_decision = ask_user(result, options)
            handle_user_decision(user_decision)
            break
        
        # Regenerate responsible dept with feedback
        brand_outputs[responsible_dept] = regenerate(responsible_dept, feedback)
        
        # Re-check gate
        continue
```

## 9.5 Escalation UI al user

```
⚠ Coherence gate 3 (palette ↔ archetype) failing after 2 regenerations.

Issue: 
  Current palette has saturation 85+ across all colors (aggressive/vibrant).
  Archetype Sage typically uses cool deep tones with saturation 40-60 + warm accent.
  Mismatch severity: HIGH.

Lo que probé:
  Attempt 1: Seed ajustado a navy + off-white → Huemint devolvió palette similar
  Attempt 2: Seed explícito con brand_value "Rigor" constraint → mismo resultado

Opciones:
  1. Accept current palette despite mismatch (archetype no se expresará fielmente — 
     flag permanente en brand book)
  2. Change archetype to Creator or Explorer (mejor matchean palette vibrant) — 
     re-runs Visual + Logo downstream
  3. Manual palette override (yo te doy HEX values y Visual regenera typography + mood)
  4. Exit run y fix upstream (restart con profile ajustado)

¿Cuál elegís? [1/2/3/4]
```

## 9.6 Coherence trace en output

Todos los gate checks (passed o failed) se registran en `brand/{slug}/activation.coherence_trace`:

```json
{
  "gates_executed": [
    {
      "gate_id": 1,
      "name": "Archetype ↔ Founder Profile",
      "result": "passed",
      "retries": 0
    },
    {
      "gate_id": 3,
      "name": "Palette ↔ Archetype",
      "result": "passed_after_retry",
      "retries": 1,
      "feedback_used": "Palette saturation too high for Sage — ajustar a cool deep tones",
      "resolved_by": "visual_system_regenerated"
    },
    ...9 total
  ],
  "escalations": [],
  "final_state": "all_gates_passed"
}
```

Esta trace va en el AUDIT.md del package para trazabilidad.

## 9.7 Gates opcionales (future v2)

Candidatos para v2:

- **Gate 10 — Scale coherence**: Typography scale (h1-h6) sigue ratio coherente (1.2, 1.25, etc.), no arbitrario
- **Gate 11 — Accessibility broader**: Colorblind-safe palette check, dyslexia-friendly typography
- **Gate 12 — Cultural sensitivity**: Colors/symbols que pueden ofender en target_geographies
- **Gate 13 — Brand voice consistency across languages**: si multi-language, voice mantenido en traducciones

No incluidos en v1 por complejidad de implementación vs valor marginal.

## 9.8 Reference file a escribir en Sprint 0

`skills/brand/references/coherence-rules.md` contiene:

- Los 9 gates con full spec (condición + check algorithm + feedback template + resolution strategy)
- Compatibility matrices expandidas (archetype ↔ voice, archetype ↔ palette, archetype ↔ typography)
- Examples trabajados de failure cases + resolutions
- Escalation UI templates

## 9.9 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Input coherente → todos los gates pass first attempt
2. Inject palette incoherente (Sage + neon colors) → Gate 3 detects, Visual regenerates, passes
3. Inject voice incoherente (Sage + voice "playful irónico") → Gate 2 detects, resolves
4. Inject logo illegible sobre palette → Gate 6 detects, resolves
5. Inject missing required screen → Gate 9 detects, re-invokes Stitch
6. 3+ persistent failures → escalation to user triggered
7. User decision "accept mismatch" → flag permanente en brand book

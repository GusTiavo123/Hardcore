# 09 — Coherence Model (8 gates)

## 9.1 Propósito

Brand produce outputs de 5 deptos distintos. **Coherencia cross-dept** es el moat del módulo — sin gates de coherencia enforced, podríamos tener un nombre que no rima con el copy, un logo que no respeta la paleta, una voice en el archetype incompatible.

**8 coherence gates** enforced por Handoff Compiler antes de delivery.

## 9.2 Principio general

**"Cada gate falla → dept responsible regenera con feedback → gate re-evalúa."**

Máximo 2 regeneration passes cross-dept. Si tras 2 passes el gate sigue fallando, **escalate al user** con opciones específicas.

Los gates los enforza **Handoff Compiler** (Depto 5) como paso 1 antes de compilar los 4 deliverables.

## 9.3 Los 8 gates

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

**Si falla**: Strategy regenera archetype con nuevo constraint set. Escoge next-best candidate.

**Si no hay profile**: skip este gate (no datos).

### Gate 2 — Voice ↔ Archetype

**Qué verifica**: Los voice attributes exhiben la personalidad del archetype.

**Compatibility matrix** (subset):

| Archetype | Voice compatibles | Voice incompatibles |
|---|---|---|
| Sage | claro, autorizante, preciso, pedagógico, medido | playful, visceral, raw, irónico (salvo light) |
| Ruler | confiado, premium, exclusivo, autorizante, formal | casual, humilde, playful |
| Jester | juguetón, irónico, ligero, irreverente, inesperado | formal, medido, grave |
| Outlaw | contundente, desafiante, visceral, provocador | medido, suave, amigable |
| Caregiver | empático, cálido, protector, reconfortante | desafiante, distant, frío |

**Si falla**: Verbal regenera con voice reminder. O Strategy ajusta voice attributes.

### Gate 3 — Palette ↔ Archetype

**Qué verifica**: La paleta respeta las tendencias del archetype.

**Checks**:
- Cool deep tones para Sage, Ruler, Magician → OK
- Warm soft para Caregiver, Innocent → OK
- High contrast para Outlaw, Hero → OK
- Vibrant multi para Jester, Creator → OK
- Mismatches: Sage con neon → FAIL. Caregiver con harsh contrast → FAIL.

**Implementation**: HEX values analyzed (saturation, brightness) vs archetype expected range.

**Si falla**: Visual System regenera palette con seed colors ajustados.

### Gate 4 — Palette ↔ Scope (visual_formality)

**Qué verifica**: La paleta respeta `visual_formality` del scope.

**Checks**:
- `high` → saturación < 60, max 1 accent > 2, no neons
- `medium` → saturation ≤ 80, 1-2 accents OK
- `low` → permisivo

**Si falla**: Visual System regenera con formality constraint.

### Gate 5 — Typography ↔ Archetype/Era

**Qué verifica**: Typography pairing matches tanto archetype como typography_era.

**Checks**:
- Archetype Sage + era neutral-modern → Fraunces + Inter OK
- Archetype Sage + display font heading → FAIL
- Archetype Jester + era experimental → display expressive OK
- Archetype Jester + classical serif → FAIL

**Si falla**: Visual System cambia pairing.

### Gate 6 — Logo ↔ Palette (legibility)

**Qué verifica**: Logo renderiza legible en todas las variantes de palette.

**Checks**:
- Primary logo sobre background: contrast ratio ≥ 4.5:1
- Primary logo sobre primary color: ≥ 4.5:1
- Mono variant sobre any bg: ≥ 4.5:1
- Inverse variant sobre dark bg: ≥ 4.5:1

**Implementation**: Pixel-level contrast analysis del SVG rendered.

**Si falla**: Logo regenera variant afectado con color adjustments.

### Gate 7 — Copy ↔ Voice (sample check)

**Qué verifica**: Sample chunks del copy exhibit voice attributes detectably.

**Implementation**:
- Select 5 random copy chunks del Verbal output
- Claude self-check: "¿Exhibe {voice_attribute_1}, {voice_attribute_2}, ...?"
- If ≥80% exhibit each attribute, pass
- Otherwise fail con specific assets flagged

**Si falla**: Verbal regenera chunks flagged con voice reminder.

### Gate 8 — Logo form ↔ Scope

**Qué verifica**: Logo chosen respeta `scope.intensity_modifiers.logo_primary_form`.

**Checks**:
- `logo_primary_form: icon-first` → chosen debe ser symbolic o combination con symbol dominant
- `logo_primary_form: wordmark-preferred` → chosen debe incluir wordmark prominente
- `logo_primary_form: symbolic-first` → chosen debe ser symbolic predominantly

**Si falla**: user override o Logo regenera con form constraint.

## 9.4 Completeness check (no es gate)

Schema completeness check del Handoff Compiler verifica que todos los **prompts required** del scope manifest están incluidos en el Prompts Library output. No es un gate de coherencia cross-dept — es validación del manifest.

## 9.5 Implementation pattern

```python
def run_coherence_gates(brand_outputs):
    gates = [
        Gate1_ArchetypeFounder,
        Gate2_VoiceArchetype,
        Gate3_PaletteArchetype,
        Gate4_PaletteScope,
        Gate5_TypographyArchetype,
        Gate6_LogoPalette,
        Gate7_CopyVoice,
        Gate8_LogoFormScope
    ]
    
    retry_count = {}
    
    for gate in gates:
        result = gate.check(brand_outputs)
        
        if result.passed:
            continue
        
        responsible_dept = result.responsible_dept
        feedback = result.feedback
        
        retry_count[gate.id] = retry_count.get(gate.id, 0) + 1
        
        if retry_count[gate.id] > 2:
            options = build_user_options(result)
            user_decision = ask_user(result, options)
            handle_user_decision(user_decision)
            break
        
        brand_outputs[responsible_dept] = regenerate(responsible_dept, feedback)
        continue
```

## 9.6 Escalation UI al user

```
⚠ Coherence gate 3 (palette ↔ archetype) failing after 2 regenerations.

Issue: 
  Current palette has saturation 85+ across all colors (aggressive/vibrant).
  Archetype Sage typically uses cool deep tones saturation 40-60 + warm accent.
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

## 9.7 Coherence trace en output

Todos los gate checks se registran en `brand/{slug}/handoff.coherence_trace`:

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
    ...8 total
  ],
  "escalations": [],
  "final_state": "all_gates_passed"
}
```

Esta trace va en el AUDIT.md del package.

## 9.7b Gate criticality per brand profile

Los 8 gates NO son igual aplicables a todos los profiles — **criticality varía por profile**. Algunos gates son existenciales en un profile y near-irrelevant en otro.

Esta matriz es guidance para el Handoff Compiler para decidir cuánto rigor aplicar per gate per profile.

**Legend**:
- 🔴 **CRITICAL** — failure here is brand-breaking, no compromise
- 🟡 **STANDARD** — enforce normalmente, escalation apropiada
- 🟢 **FLEXIBLE** — enforce pero acceptable to have partial fails (marked con flag) en este profile

| Gate | b2b-enterprise | b2b-smb | b2d-devtool | b2c-consumer-app | b2c-consumer-web | b2local-service | content-media | community-movement |
|---|---|---|---|---|---|---|---|---|
| **G1 — Archetype ↔ Founder** | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🔴 (creator = brand) | 🟡 |
| **G2 — Voice ↔ Archetype** | 🔴 (register violation = unprofessional) | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🔴 (voice = creator identity) | 🔴 (movement voice defines cause) |
| **G3 — Palette ↔ Archetype** | 🔴 (corporate credibility) | 🟡 | 🟢 (devs care less about palette politeness) | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 |
| **G4 — Palette ↔ Scope formality** | 🔴 (formality alta requerida) | 🟡 | 🟢 (flexibility tolerable) | 🟢 (low formality, palette expressive OK) | 🟡 | 🟡 | 🟢 (creator aesthetic libre) | 🟢 (movement aesthetic libre) |
| **G5 — Typography ↔ Archetype/Era** | 🔴 (serif formality importa) | 🟡 | 🟡 (monospace expectations) | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 |
| **G6 — Logo ↔ Palette legibility** | 🟡 | 🟡 | 🟡 | 🔴 (CRITICAL — app icon a 16×16 must work) | 🟡 | 🟡 (print contexts — mono logo indispensable) | 🟡 | 🔴 (symbolic merch must be legible) |
| **G7 — Copy ↔ Voice** | 🔴 (register formality crítico) | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🔴 (creator voice authenticity) | 🔴 (manifesto voice must exhibit values) |
| **G8 — Logo form ↔ Scope** | 🟡 (wordmark expected pero flexible) | 🟡 | 🟡 | 🔴 (icon-first non-negotiable) | 🟡 | 🟡 | 🟡 | 🔴 (symbolic must be dominant) |

### Implicaciones operativas

**Gates críticos recibien más retries antes de escalar**:
- 🔴 gate: max 3 retries antes de escalate to user (vs 2 default)
- 🟡 gate: max 2 retries (default)
- 🟢 gate: max 2 retries pero user puede `--allow-soft-fail` para acceptar with flag

**Escalation UI cambia tone**:
- 🔴 gate escalation: "This is critical for {profile}. Recommend fixing upstream."
- 🟢 gate escalation: "This mismatch is acceptable for {profile} if you prefer. Proceed with flag?"

### Por qué esto importa (ejemplos concretos)

**b2c-consumer-app**: Gate 6 (Logo ↔ Palette) es **crítico** porque app icon a 16×16 px tiene que ser legible o el user no lo encuentra en su home screen. Para b2b-enterprise, el logo casi nunca aparece a esa size — está siempre en contextos grandes (landing headers, email signatures, pitch deck covers).

**community-movement**: Gate 7 (Copy ↔ Voice) es **crítico** porque el manifesto literalmente ES el statement de valores de la movement. Voice que no exhibit los values = manifesto vacío = no une gente. Para b2b-smb, voice inconsistency en un FAQ es recoverable.

**content-media (creator brand)**: Gate 1 y Gate 2 son **críticos** porque el creator ES la marca. Un archetype que no matchea al creator real se siente fake inmediatamente, pierde audience trust.

**b2d-devtool**: Gates de palette/typography son más **flexibles** porque developers explícitamente tolerate (even prefer) brands con personality técnica/rebelde que violan "corporate standards". Stripe/Vercel/Railway exhiben personality fuerte donde otros profiles no tolerarían.

**b2b-enterprise**: múltiples gates 🔴 porque enterprise buyers descartan brands con **cualquier** signal de unprofessionalism. Credibility se compone multiplicativamente — single failing signal puede matar un $50K deal.

### Implementation note

El coherence checker del Handoff Compiler lee esta tabla para:
1. Determinar max_retries per gate per profile
2. Ajustar escalation UI messaging per gate criticality
3. Decide si "allow soft fail with flag" es una opción válida

Implementation en `skills/brand/handoff-compiler/references/coherence-criticality.md` (nuevo file a escribir Sprint 0).

## 9.8 Reference file a escribir en Sprint 0

`skills/brand/references/coherence-rules.md` contiene:
- Los 8 gates con full spec (condición + check algorithm + feedback template + resolution)
- Compatibility matrices expandidas
- Examples trabajados de failure cases + resolutions
- Escalation UI templates

## 9.9 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Input coherente → todos los gates pass first attempt
2. Inject palette incoherente (Sage + neon) → Gate 3 detects, Visual regenerates, passes
3. Inject voice incoherente (Sage + voice "playful irónico") → Gate 2 detects, resolves
4. Inject logo illegible sobre palette → Gate 6 detects, resolves
5. Inject logo con form incorrecto (wordmark en scope symbolic-first) → Gate 8 detects
6. 3+ persistent failures → escalation to user triggered
7. User decision "accept mismatch" → flag permanente en brand book
8. No gate referencia generación de screens nuestra (Claude Design es downstream)

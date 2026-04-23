# 09 — Coherence Model (9 gates)

## 9.1 Propósito

Brand produce outputs de 5 deptos distintos. **Coherencia cross-dept + coherencia con la realidad de mercado** es el moat del módulo. Sin gates enforced, podríamos tener un nombre que no rima con el copy, un logo que no respeta la paleta, una voice incompatible con el archetype, o un archetype que contradice el posicionamiento que validamos.

**9 coherence gates** enforzados por Handoff Compiler antes de delivery.

## 9.2 Principio general — fail-fast

**"Cada gate se evalúa una sola vez. Si falla, el pipeline pausa y el user decide el siguiente paso."**

No hay regeneration automática. El orchestrator surface la falla al user con opciones concretas, y el user elige entre:

1. Re-correr el dept responsable (con feedback aplicado)
2. Aceptar la falla con flag permanente en el brand book
3. Abortar y arreglar upstream (ej. cambiar archetype, reajustar profile, re-validar mercado)

**Por qué fail-fast y no auto-retry**: reproducibilidad (mismo input → mismo output), simplicidad del pipeline, decisiones conscientes del user en lugar de loops escondidos. Auto-retry se considerará en v2 si aparecen patrones claros de gate failures recuperables por regeneration determinista.

Las gates las enforza **Handoff Compiler** (Depto 5) como paso 1 antes de compilar los 4 deliverables.

## 9.3 Los 9 gates

### Gate 0 — Archetype ↔ Market reality (cross-module)

**Qué verifica**: El archetype elegido por Strategy es compatible con la realidad de mercado según Validation.

**Insumos**:
- `strategy.archetype` (Strategy output)
- `validation/{slug}/market.market_stage`
- `validation/{slug}/competitive.direct_competitors[].weaknesses[]`
- `validation/{slug}/competitive.market_gaps[]`
- `validation/{slug}/competitive.failed_competitors[].reason_failed`

**Derivation del `sentiment_landscape`** (Strategy lo produce a partir de los inputs anteriores):

- `trust_heavy` — si market_stage=`mature` AND weaknesses menciona "trust/reliability/compliance" o failed_competitors tienen reason_failed=`regulatory` o `trust_breach`
- `disruption_ready` — si weaknesses incluye `outdated`, `slow`, `legacy`, `bureaucratic` AND market_gaps contiene frases de "no alternatives", "underserved"
- `saturation_neutral` — si market_stage=`growing` AND sin señales extremas
- `low_trust_context` — si competitive.sentiment es mayoritariamente negativa y failed_competitors > 3

**Compatibility matrix**:

| Sentiment landscape | Archetypes compatibles | Archetypes bloqueados | Archetypes con fricción |
|---|---|---|---|
| `trust_heavy` | Sage, Ruler, Caregiver, Everyman | Outlaw, Rebel | Hero (cuidado con arrogancia), Jester (frivolidad percibida) |
| `disruption_ready` | Outlaw, Hero, Magician, Explorer, Creator | — | Ruler (conservador), Everyman (indiferenciado) |
| `saturation_neutral` | Todos | — | — |
| `low_trust_context` | Sage, Caregiver, Everyman | Outlaw, Jester | Ruler (si trust issue es por gatekeeping) |

**Si falla**: Strategy seleccionó un archetype incompatible con la realidad de mercado. Surface al user:

```
⚠ Gate 0 — Archetype no matchea la realidad de mercado

Strategy eligió: Outlaw (rule-breaking, desafiante)
Market según Validation: trust-heavy (compliance-heavy fintech, 3 failed competitors por regulatory, sentiment score low)
Conflict: Outlaw tiende a bajar confianza en markets trust-heavy. Empresa reputation suicide para compliance.

Opciones:
  1. Re-correr Strategy con constraint explicit ("market is trust-heavy, avoid Outlaw/Rebel")
  2. Aceptar con flag permanente (no recomendado — risk strategic)
  3. Abortar y re-validar si el market framing es correcto
```

**Si no hay suficiente data para derivar sentiment_landscape**: Gate 0 marca `insufficient_data` y el user decide si continuar sin este check o volver a Validation para enriquecer.

### Gate 1 — Archetype ↔ Founder Profile

**Qué verifica**: El archetype es compatible con el founder profile (si existe).

**Checks**:

| Profile attribute | Archetype incompatible |
|---|---|
| `constraints.risk_tolerance: conservative` | Outlaw, Hero (primary), Magician |
| `motivation.primary_goal: financial-freedom` con working_style `solo` | Hero, Ruler (escala pretendida inalcanzable solo) |
| `motivation.working_style.orientation: technical` puro | Lover, Caregiver (si idea es B2C emocional) |
| `constraints.hard_nos` contiene valores del archetype | bloqueo contextual |

**Si falla**: Surface al user. Opciones: re-correr Strategy con founder constraint, aceptar con flag, o actualizar profile.

**Si no hay profile**: skip (mark `skipped_no_profile`).

### Gate 2 — Voice ↔ Archetype

**Qué verifica**: Voice attributes exhiben la personalidad del archetype.

**Compatibility matrix** (subset):

| Archetype | Voice compatibles | Voice incompatibles |
|---|---|---|
| Sage | claro, autorizante, preciso, pedagógico, medido | playful, visceral, raw, irónico (salvo light) |
| Ruler | confiado, premium, exclusivo, autorizante, formal | casual, humilde, playful |
| Jester | juguetón, irónico, ligero, irreverente, inesperado | formal, medido, grave |
| Outlaw | contundente, desafiante, visceral, provocador | medido, suave, amigable |
| Caregiver | empático, cálido, protector, reconfortante | desafiante, distante, frío |
| Hero | confiado, motivacional, determinado, directo | humilde, vacilante, ambiguo |
| Explorer | curioso, expansivo, libre, aventurero | rígido, pesimista, burocrático |
| Creator | expresivo, visual, experimental, original | genérico, previsible, templado |
| Innocent | optimista, claro, honesto, amable | cínico, sarcástico, amenazante |
| Lover | sensual, emocional, íntimo, evocador | analítico puro, clínico |
| Magician | misterioso, transformativo, visionario | mundano, literal |
| Everyman | accesible, directo, honesto, genuino | elitista, pretencioso, enigmático |

**Si falla**: Surface al user. Opciones: re-correr Verbal con voice reminder, re-correr Strategy si voice fue mal derivada desde archetype, aceptar con flag.

### Gate 3 — Palette ↔ Archetype

**Qué verifica**: La paleta respeta las tendencias del archetype.

**Checks**:
- Cool deep tones (hue 200-260, sat 40-60, light 25-55) → Sage, Ruler, Magician
- Warm soft (hue 20-50, sat 30-50, light 60-80) → Caregiver, Innocent
- High contrast (sat 70+, light extremes) → Outlaw, Hero
- Vibrant multi (3+ accents, sat 60-85) → Jester, Creator
- Neutral sophisticated (sat 15-40, light varied) → Everyman, Explorer

**Implementation**: cada HEX de la paleta se convierte a HSL y se mide contra el expected range del archetype. Fail si > 50% de los colors están fuera de range.

**Si falla**: Surface al user. Opciones: re-correr Visual con seed colors ajustados, aceptar con flag, o reconsider archetype (si user sospecha archetype mal elegido).

### Gate 4 — Palette ↔ Scope (visual_formality)

**Qué verifica**: Paleta respeta `scope.visual_formality`.

**Checks**:
- `high` → saturación media < 60, max 1 accent > sat 70, no colors puros neon
- `medium` → saturation media ≤ 80, 1-2 accents OK
- `low` → permisivo (solo bloquea si palette es monótona vs scope expresivo)

**Si falla**: Surface al user. Opciones: re-correr Visual con formality constraint, aceptar con flag.

### Gate 5 — Typography ↔ Archetype/Era

**Qué verifica**: Typography pairing matches archetype + `scope.typography_era`.

**Checks** (ejemplos):
- Archetype Sage + era `neutral-modern` → Fraunces + Inter ✓
- Archetype Sage + display script → ✗
- Archetype Jester + era `experimental` → display expressive ✓
- Archetype Jester + serif clásico → ✗
- Archetype Ruler + era `timeless` → serif moderno (Didone) ✓
- Archetype Outlaw + era `retro-rebel` → sans condensed industrial ✓

**Si falla**: Surface al user. Opciones: re-correr Visual con pairing constraint, aceptar con flag.

### Gate 6 — Logo ↔ Palette (legibility)

**Qué verifica**: Logo renderiza legible en todas las variants de palette.

**Checks**:
- Primary logo sobre light background: contrast ratio ≥ 4.5:1
- Primary logo sobre primary color: ≥ 4.5:1
- Mono variant sobre any bg: ≥ 4.5:1
- Inverse variant sobre dark bg: ≥ 4.5:1

**Implementation**: pixel-level contrast analysis del SVG rendered contra cada bg color. Usa WCAG contrast formula sobre luminance.

**Si falla**: Surface al user. Opciones: re-correr Logo con color adjustments, ajustar palette (re-correr Visual), aceptar con flag (no recomendado — accessibility).

### Gate 7 — Copy ↔ Voice

**Qué verifica**: Sample chunks del copy exhiben los voice attributes detectably.

**Implementation**:
- Select 5 random copy chunks del Verbal output (landing headlines, about, pricing, CTA, manifesto si aplica)
- Self-check: *"¿Exhibe este copy los atributos {voice_attribute_1}, {voice_attribute_2}, ...?"*
- Score binario por atributo por chunk
- Pass si ≥ 80% de los (chunk × attribute) pares scorean positivo

**Si falla**: Surface al user con specific chunks flagged. Opciones: re-correr Verbal con voice reminder para esos chunks, aceptar con flag.

### Gate 8 — Logo form ↔ Scope

**Qué verifica**: Logo chosen respeta `scope.logo_primary_form`.

**Checks**:
- `icon-first` → chosen debe ser symbolic-dominant o combination con symbol prominente
- `wordmark-preferred` → chosen debe incluir wordmark legible y prominente
- `symbolic-first` → chosen debe ser symbolic predominantly (text secundario o ausente)
- `combination` → chosen debe tener ambos elementos balanceados

**Si falla**: Surface al user. Opciones: re-correr Logo con form constraint, o override scope (si user cambió de opinión).

## 9.4 Completeness check (no es gate)

Handoff Compiler verifica que todos los prompts required en `scope.output_manifest` están incluidos en la Prompts Library output. No es coherence cross-dept — es validación de manifest. Si falta algún prompt, Handoff lo regenera internamente (sin interacción del user).

## 9.5 Implementation pattern

```python
def run_coherence_gates(brand_outputs, validation_refs, profile_ref):
    gates = [
        Gate0_ArchetypeMarketFit,   # cross-module
        Gate1_ArchetypeFounder,
        Gate2_VoiceArchetype,
        Gate3_PaletteArchetype,
        Gate4_PaletteScope,
        Gate5_TypographyArchetype,
        Gate6_LogoPalette,
        Gate7_CopyVoice,
        Gate8_LogoFormScope
    ]

    trace = []

    for gate in gates:
        result = gate.check(brand_outputs, validation_refs, profile_ref)
        trace.append(result)

        if not result.passed:
            return FailFastResult(
                failed_gate=gate,
                responsible_dept=result.responsible_dept,
                feedback=result.feedback,
                criticality=result.criticality_for_profile,
                options=build_user_options(result),
                trace=trace
            )

    return AllPassedResult(trace=trace)
```

## 9.6 Escalation UI al user

```
⚠ Gate 3 (palette ↔ archetype) falló

Estado:
  Archetype: Sage
  Palette generada: saturación media 85, 3 colors puros neon
  Expected para Sage: cool deep tones, saturación 40-60

Qué implica (criticality para profile b2b-enterprise):
  🔴 CRITICAL — paleta neon en enterprise rompe credibilidad corporate. Enterprise buyers descartan brands con signals de unprofessionalism.

Opciones:
  1. Re-correr Visual System con constraint "cool deep tones, navy/slate/amber palette" (recomendado)
  2. Re-correr Strategy con archetype alternativo (si Sage no es el correcto)
  3. Accept palette con flag permanente en brand book (NO recomendado para b2b-enterprise)
  4. Abortar run y revisar upstream

¿Cuál? [1/2/3/4]
```

## 9.7 Coherence trace en output

Todos los gate checks se registran en `brand/{slug}/handoff.coherence_trace`:

```json
{
  "gates_executed": [
    {
      "gate_id": 0,
      "name": "Archetype ↔ Market reality",
      "result": "passed",
      "sentiment_landscape_derived": "trust_heavy"
    },
    {
      "gate_id": 1,
      "name": "Archetype ↔ Founder Profile",
      "result": "passed"
    },
    {
      "gate_id": 3,
      "name": "Palette ↔ Archetype",
      "result": "failed",
      "feedback": "Palette saturation 85 too high for Sage — expected 40-60",
      "criticality_for_profile": "critical",
      "user_decision": "re_run_visual",
      "re_run_outcome": "passed_on_second_pass"
    }
  ],
  "final_state": "all_gates_passed | halted_by_user | failed_after_user_decision",
  "halt_reason": null | "string"
}
```

Esta trace se persiste en el AUDIT section del brand package.

## 9.8 Gate criticality per brand profile

Los 9 gates no son igual aplicables a todos los profiles. **Criticality varía por profile** e informa:
- El default recommendation en el escalation UI (fix vs accept)
- El tone del mensaje al user
- Si "aceptar con flag" es una opción razonable o un hard no

**Legend**:
- 🔴 **CRITICAL** — falla aquí es brand-breaking. Default recommendation: fix upstream.
- 🟡 **STANDARD** — enforza normalmente. Default recommendation: re-run dept responsable.
- 🟢 **FLEXIBLE** — enforza pero acceptar con flag es razonable en este profile.

| Gate | b2b-enterprise | b2b-smb | b2d-devtool | b2c-consumer-app | b2c-consumer-web | b2local-service | content-media | community-movement |
|---|---|---|---|---|---|---|---|---|
| **G0 — Archetype ↔ Market** | 🔴 | 🔴 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🔴 |
| **G1 — Archetype ↔ Founder** | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🔴 (creator = brand) | 🟡 |
| **G2 — Voice ↔ Archetype** | 🔴 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🔴 | 🔴 |
| **G3 — Palette ↔ Archetype** | 🔴 | 🟡 | 🟢 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 |
| **G4 — Palette ↔ Scope formality** | 🔴 | 🟡 | 🟢 | 🟢 | 🟡 | 🟡 | 🟢 | 🟢 |
| **G5 — Typography ↔ Archetype/Era** | 🔴 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 |
| **G6 — Logo ↔ Palette legibility** | 🟡 | 🟡 | 🟡 | 🔴 | 🟡 | 🟡 | 🟡 | 🔴 |
| **G7 — Copy ↔ Voice** | 🔴 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🔴 | 🔴 |
| **G8 — Logo form ↔ Scope** | 🟡 | 🟡 | 🟡 | 🔴 | 🟡 | 🟡 | 🟡 | 🔴 |

### Implicaciones operativas

El escalation UI ajusta tone y default recommendation según criticality:

- 🔴 gate failure → *"Esto es crítico para {profile}. Recomendamos re-correr {dept}. Aceptar con flag podría comprometer {específico impacto}."*
- 🟡 gate failure → *"Re-correr {dept} es lo más limpio. Aceptar con flag es viable si los tradeoffs te convencen."*
- 🟢 gate failure → *"Para {profile}, este mismatch es tolerable. Aceptar con flag es razonable si la dirección actual te convence."*

### Por qué esto importa (ejemplos concretos)

**b2c-consumer-app**: Gate 6 (Logo ↔ Palette legibility) es crítico porque el app icon a 16×16 px tiene que ser reconocible o el user no lo encuentra en su home screen. Para b2b-enterprise, el logo casi nunca aparece a ese tamaño.

**community-movement**: Gate 7 (Copy ↔ Voice) es crítico porque el manifesto literalmente ES el statement de valores. Voice que no exhibe los values = manifesto vacío = no une gente.

**content-media (creator brand)**: Gate 1 (Archetype ↔ Founder) es crítico porque el creator ES la marca. Archetype que no matchea al creator real se siente fake, pierde audience trust.

**b2d-devtool**: Gates de palette/typography son flexibles porque developers toleran (y a veces prefieren) brands con personality técnica/rebelde que violan "corporate standards". Stripe/Vercel/Railway exhiben personality fuerte donde otros profiles no lo tolerarían.

**b2b-enterprise**: múltiples gates 🔴 porque enterprise buyers descartan brands con cualquier signal de unprofessionalism. Credibility se compone multiplicativamente — un solo failing signal puede matar un $50K deal.

La tabla de criticality vive dentro de `skills/brand/references/coherence-rules.md` (misma ref que tiene los 9 gates completos) para que el runtime del gate checker consume una sola ref.

## 9.9 Archivo a escribir en Sprint 0

`skills/brand/references/coherence-rules.md` (a nivel orchestrator, consumido por Handoff Compiler y cualquier dept que necesite validar coherence) contiene:
- Los 9 gates con full spec (condición + check algorithm + feedback template + opciones user)
- Compatibility matrices expandidas per archetype
- Derivation algorithm para `sentiment_landscape` (Gate 0) — referencia inversa al algoritmo definido en `strategy/SKILL.md`
- Criticality matrix per brand_profile per gate (para modular escalation UI)
- Escalation UI templates per criticality level
- Examples trabajados de failure cases + user resolutions típicas

## 9.10 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Input coherente con market trust-heavy + archetype Sage → todos los gates pass
2. Inject archetype Outlaw con market trust-heavy → Gate 0 halts, surface al user
3. Inject palette incoherente (Sage + neon) → Gate 3 halts, surface al user
4. Inject voice incoherente (Sage + voice "playful irónico") → Gate 2 halts
5. Inject logo illegible sobre palette → Gate 6 halts
6. Inject logo con form incorrecto (wordmark en scope symbolic-first) → Gate 8 halts
7. User acepta con flag → flag permanente registrado en brand book + AUDIT
8. User re-corre dept → outcome se registra en trace; next gate evaluation arranca desde cero
9. `insufficient_data` en Gate 0 → user decide continuar skip vs re-validar mercado
10. Criticality escalation UI renderiza tone apropiado por profile

# 12 — Modos de Operación y Puntos de Interacción con User

## 12.1 Propósito

Definir los **modos** en que Brand puede ejecutarse + los **puntos de interacción** donde el user participa o pasa por default.

El balance crítico: **control del user vs velocidad del flow**. Muchos prompts = friction; pocos = pérdida de voice del user en el output.

## 12.2 Los 4 modos

### Modo Normal (default)

Invocación: `"brandea esta idea"` / `/brand:new`

**Características**:
- 3 puntos de interacción con user (ver sección 12.3)
- Reveal progresivo después de cada dept
- User puede aceptar default o redirigir en cada punto
- Tiempo total: 25-35 min (con latencia de user responses)

**Cuándo usarlo**:
- Primera vez corriendo Brand en esta idea
- User quiere involvement en decisiones clave (archetype, nombre, logo)
- Producto final-production quality matters

### Modo Fast

Invocación: `/brand:fast` / `"brandea rápido"`

**Características**:
- Skip todas las interacciones de user
- Auto-pick top-ranked en cada decisión point
- Reveal comprimido (solo summary al final de cada dept, no full visual)
- Tiempo total: 15-20 min

**Cuándo usarlo**:
- Dogfooding rápido (iterar sobre el módulo mismo)
- Freemium first-run para reducir friction al usuario nuevo
- Background regeneration automatizada
- CI/testing

**Trade-off**: user no tiene control granular. Si no le gusta el output, extend mode o re-run.

### Modo Extend (partial re-run)

Invocación: `/brand:extend {depto}` o `/brand:extend {depto.specific_output}`

**Características**:
- Regenera solo el dept especificado
- Otros deptos reutilizados desde Engram (cache implícito)
- Coherence gates re-ejecutados con el nuevo output
- Si regenerating dept downstream requiere upstream reworking, flag al user

**Ejemplos**:
```
/brand:extend logo                  # Regenera todo el dept Logo
/brand:extend verbal.naming         # Solo naming de Verbal, keeping copy
/brand:extend verbal.copy           # Solo copy, keeping nombre existente
/brand:extend visual.palette        # Solo palette, keeping typography + mood
/brand:extend activation.microsite  # Solo microsite, keeping brand book
```

**Feedback opcional**:
```
/brand:extend logo --feedback "más minimalista, menos ornamental"
/brand:extend verbal.copy --feedback "menos formal, más punchy"
```

**Cuándo usarlo**:
- User quiere iterar sobre una pieza sin regenerar todo (cost + time efficiency)
- Testing de un cambio específico
- Recovery de failure en un dept (si Recraft estuvo down, extend logo después)

**Tracking**: partial re-runs NO crean nuevo snapshot vN completo — solo actualizan el topic key del dept. Revision count del dept incrementa.

### Modo Override

Invocación: `/brand:override {key}={value}` antes de run O durante interacción

**Características**:
- Fuerza decisión específica pre-run
- Strategy respeta el override si no contradice `scope.archetype_constraints.blocked`
- Si contradice, pide justification adicional (ver edge case sección 12.4)

**Overrides válidos**:

| Key | Valores | Effect |
|---|---|---|
| `archetype` | any of 12 Jung archetypes | Strategy usa este archetype directamente (skip selection logic) |
| `voice_register` | any of 5 register values | Overrides el default del brand profile |
| `typography_era` | any of 4 era values | Overrides default |
| `primary_color` | HEX color | Huemint usa este como seed primario obligatorio |
| `name` | string | Verbal skip naming generation, usa este nombre + verification |
| `language` | es, en, pt, ... | Override language del output |
| `output_manifest.include` | array of asset keys | Agrega outputs que el scope skipearía |
| `output_manifest.exclude` | array of asset keys | Remove outputs del required default |

**Ejemplo**:
```
/brand:new --override archetype=Hero --override primary_color=#FF3A5C --override language=es
```

O durante flow:
```
[Post-Strategy reveal]
    Archetype: SAGE
    ¿OK? [Enter=yes | otro nombre=override]

[user: hero]
    Re-ejecutando Strategy con archetype=Hero...
```

**Cuándo usarlo**:
- User tiene visión clara y quiere skipear exploración
- Constraint de brand existente (ya tienen nombre, solo quieren resto del package)
- Experimentación (A/B testing de directions)

## 12.3 Los 3 puntos de interacción (Modo Normal)

### Punto 1: Post Scope Analysis (condicional)

**Cuándo ocurre**: solo si `confidence < 0.7` del brand profile matching.

**Prompt**:
```
Clasifiqué tu idea como B2B SMB SaaS (confidence 0.62 — medio).

Señales que me llevaron ahí:
- Target audience: compliance officers de fintechs
- Pricing model: subscription $200-500/mo
- Distribution: content + outbound

¿Te suena correcto?
  1. ✓ Correcto (b2b-smb)
  2. Es B2B enterprise (large companies, $50K+)
  3. Es B2D (developer tool con component fintech)
  4. Es B2C consumer (end users)
  5. Otra (describila)
```

**User input**: número o texto libre.

**Skipped en**: Fast mode, confidence ≥ 0.7.

### Punto 2: Post Strategy (opcional)

**Cuándo ocurre**: siempre en Normal mode, unless override previo.

**Prompt**:
```
[3:42] ① Strategy ready — Archetype: SAGE

[Full reveal as described in 04-dept-strategy.md #7]

¿OK para continuar o preferís alternativa?
  [Enter para continuar]
  'ruler' | 'hero' | 'creator' — override archetype
  'voice' — ajustar voice attributes
  'skip' — proceed anyway con un flag
```

**User input**:
- Enter / nothing → accept
- Archetype name → Strategy re-runs con override
- "voice" → ask user for voice adjustments
- "skip" → proceed con flag (puede causar coherence gate issues downstream)

**Skipped en**: Fast mode, override previo de archetype.

### Punto 3: Post Verbal — Naming selection (OBLIGATORIO en Normal)

**Cuándo ocurre**: siempre en Normal mode, unless `name` override.

**Prompt**:
```
[7:14] ② Verbal Identity — verificando 12 candidatos...

[Progress: domain check ✓ · trademark screening ✓ · linguistic check ✓]

[9:14] Top 7 nombres (ranked):

    Nombre         .com  .io  .ai  .mx   TM   Fit  Mem  Score
    Auren           ✓    ✓    ✓    ✓    ✓    9    9    9.1  ← top
    RegClarity      ✗    ✓    ✓    ✓    ✓    9    8    8.2
    ...

    Recomendado: Auren (domains libres, TM clean, fit Sage fuerte)

    Opciones:
      [Enter] para aceptar Auren
      '{otro nombre}' para elegir otro
      'more' para regenerar con feedback
      'manual {name}' si querés proponer tu propio nombre
```

**User input**:
- Enter / nothing → auto-picks recommended
- Name from list → use that
- "more" → regenerate round con user feedback prompt
- "manual {name}" → skip generation, usar ese nombre + verification

**Skipped en**: Fast mode (auto-picks top-ranked), `name` override previo.

### Punto 4: Post Logo — Logo selection (OBLIGATORIO en Normal)

**Cuándo ocurre**: siempre en Normal mode.

**Prompt**:
```
[17:45] ④ 4 logo concepts generated

    [B1 SVG rendered]  [B2 SVG rendered]  [B3 SVG rendered]  [C1 SVG rendered]
    
    Cada con rationale 1-line.

    Opciones:
      'B1' | 'B2' | 'B3' | 'C1' — pick one
      'direction B' — regenerate más variants de wordmark direction
      'direction C' — regenerate combination direction
      'none' — regenerate todos con feedback
      'manual' — upload tu propio logo
```

**User input**:
- Logo ID → use that
- "direction X" → regenerate 3-4 variants of that direction
- "none" → feedback prompt → regenerate all
- "manual" → user uploads / provides logo, Logo dept skipea generation

**Skipped en**: Fast mode (auto-picks highest-quality based on internal scoring).

### Punto 5 (condicional): Coherence gate escalation

**Cuándo ocurre**: si un gate falla 2+ veces tras regeneration.

**Prompt**: ver [09-coherence-model.md#95](./09-coherence-model.md#95) para full escalation UI.

**User input**: elige entre opciones específicas al gate failing.

**No skipeable**: Fast mode también lo enfrenta — aunque en Fast puede default a "accept mismatch" si user lo configuró así (TBD).

## 12.4 Edge cases en interacción

### User provee override inválido

Ej: scope `b2b-enterprise`, user override `archetype=Jester` (bloqueado).

```
Override rejected: archetype "Jester" está en archetype_constraints.blocked para scope b2b-enterprise.
Razón: Jester tiene baja credibilidad en contextos B2B enterprise, puede alienar decision makers.

Opciones:
  1. Cambiar override a archetype compatible: Sage, Ruler, Hero, Creator, Caregiver, Everyman
  2. Forzar con --force (NO recomendado, el brand book incluirá warning permanente)
  3. Cancelar override, dejar a Strategy auto-seleccionar
```

User elige. Si usa `--force`, grabar warning permanente en Engram + brand book.

### User no responde (timeout)

Si user no responde por X minutos (configurable, default 10 min):
- En Normal mode: grabar session state en Engram, pausar execution
- User puede `/brand:resume` para continuar
- Timeout 24h: cancel run, flag as incomplete

### User cancela mid-flow

Signal interrupt (user: "cancel" / Ctrl+C / `/brand:cancel`):
- Persist state actual en Engram con `status: "partial"`
- Show summary de qué se completó + qué faltó
- `/brand:resume` para continuar donde dejó

### User provee decisión ambigua

Ej: "quiero algo entre Sage y Creator"

- Claude interpreta si puede (mezcla — Strategy puede intentar blend)
- Si ambiguo: ask clarification ("¿Sage primary con Creator influence, o Creator primary con Sage influence?")

## 12.5 Summary tabla — mode × interaction

| Interaction point | Normal | Fast | Extend | Override |
|---|---|---|---|---|
| 1. Scope confirmation (if low conf) | ✓ | skip | n/a | skip (already set) |
| 2. Post-Strategy review | ✓ | skip | Only if extending strategy | skip (override pre-set) |
| 3. Naming selection | ✓ | skip | Only if extending verbal.naming | skip (if name override) |
| 4. Logo selection | ✓ | skip | Only if extending logo | skip (if manual logo) |
| 5. Coherence escalation (if gate fails 2×) | ✓ | ✓ | ✓ | ✓ |

## 12.6 UX del reveal progresivo

Cada dept devuelve un reveal visual intermedio al user antes de continuar al siguiente. Esto es crítico para el wow factor (ver [01-overview-and-architecture.md#12](./01-overview-and-architecture.md#12) — "filosofía").

### Formato del reveal

Cada dept reveal incluye:
1. **Header con timestamp + depto number**:
   ```
   [3:42] ① Strategy ready — Archetype: SAGE
   ```
2. **Core content** — qué se decidió/generó, en formato visual-friendly
3. **Evidence one-line** — por qué así
4. **Interaction prompt** (si aplica) — qué puede hacer el user

### Reveal estructurado por dept

- Strategy: archetype + positioning + voice + values (compact)
- Verbal naming: tabla de top 5 con availability + fit score
- Verbal copy: selected copy samples (hero + tagline + 1-2 more)
- Visual: palette swatches + typography samples rendered + mood grid
- Logo: 4-5 SVGs rendered + rationales
- Activation: final package path + microsite link + PDF link + cost

### Fast mode reveals

Comprimidos — un solo line-summary por dept:
```
[15:20] ① Strategy: Sage + positioning + voice ✓
[17:45] ② Verbal: Auren (Top 1, score 9.1) + 18 copy assets ✓
[21:30] ③ Visual: Navy/Off-white/Amber palette + Fraunces/Inter + 6 mood imgs ✓
[26:14] ④ Logo: B2 selected (highest quality score) + 12 derivations ✓
[32:40] ⑤ Activation: Microsite + Brand book + 47 files delivered ✓
```

## 12.7 Reference files a escribir en Sprint 0

- `skills/brand/references/reveal-script.md` — templates exactos de reveals por mode
- `skills/brand/references/interaction-flow.md` — decision tree de interaction points
- `skills/brand/SKILL.md` orchestrator instructions para mode handling

## 12.8 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Normal mode → 3-4 puntos de interacción triggered correctamente
2. Fast mode → auto-picks en todos los puntos, no prompts al user
3. Extend logo → solo logo dept re-runs, otros reused
4. Override archetype compatible → Strategy usa override
5. Override archetype blocked → rejection + options
6. User cancel mid-flow → partial state persisted
7. Scope confidence low → Point 1 triggered
8. Scope confidence high → Point 1 skipped

# 12 — Modos de Operación y Puntos de Interacción con User

## 12.1 Propósito

Definir los **modos** en que Brand puede ejecutarse + los **puntos de interacción** donde el user participa.

## 12.2 Los 4 modos

### Modo Normal (default)

Invocación: `"brandea esta idea"` / `/brand:new`

**Características**:
- 3-4 puntos de interacción con user
- Reveal progresivo después de cada dept
- Tiempo total: 18-22 min

### Modo Fast

Invocación: `/brand:fast` / `"brandea rápido"`

- Skip interacciones
- Auto-pick top-ranked en cada decisión point
- Reveal comprimido
- Tiempo total: 12-15 min

### Modo Extend

Invocación: `/brand:extend {depto}`

- Regenera solo dept específico
- Otros deptos reutilizados (cache Engram)
- Coherence gates re-ejecutados
- Examples:
  ```
  /brand:extend logo
  /brand:extend verbal.naming
  /brand:extend verbal.core_copy
  /brand:extend visual.palette
  /brand:extend handoff (regenera los 4 deliverables pero no regens upstream)
  ```

### Modo Override

Invocación: `/brand:override {key}={value}` o `/brand:new --{key}={value}`

**Overrides válidos**:

| Key | Valores | Effect |
|---|---|---|
| `archetype` | any of 12 Jung | Strategy usa override directamente |
| `voice_register` | any of 5 values | Overrides default |
| `typography_era` | any of 4 values | Overrides default |
| `primary_color` | HEX | Huemint uses as seed obligatorio |
| `name` | string | Verbal skip generation, usa este + verify |
| `language` | es, en, pt, ... | Override output language |
| `tier` | 0, 1, 2 | Override image_gen_tier del scope |
| `output_manifest.include` | array | Agrega outputs al required |
| `output_manifest.exclude` | array | Remove outputs del required |

## 12.3 Los 3-4 puntos de interacción (Modo Normal)

### Punto 1: Post Scope Analysis (condicional)

**Cuándo**: `confidence < 0.7` del brand profile matching.

Ver [02-scope-analysis.md](./02-scope-analysis.md#27-user-interaction) para el prompt completo.

**Skipped en**: Fast mode, confidence ≥ 0.7.

### Punto 2: Post Strategy (opcional)

**Cuándo**: siempre en Normal mode, unless override previo.

```
[3:42] ① Strategy ready — Archetype: SAGE

[Full reveal]

¿OK o preferís alternativa?
  [Enter] accept
  'ruler' | 'hero' | 'creator' — override archetype
  'voice' — ajustar voice attributes
  'skip' — proceed con flag
```

**Skipped en**: Fast mode, override previo de archetype.

### Punto 3: Post Verbal Naming (OBLIGATORIO)

**Cuándo**: siempre en Normal mode, unless `name` override.

```
[7:14] ② Verbal Identity — Top 7 nombres

[Tabla con availability + fit + score]

Recomendado: Auren

Opciones:
  [Enter] accept Auren
  '{otro nombre}' pick otro
  'more' regenerate con feedback
  'manual {name}' your own name
```

**Skipped en**: Fast mode (auto-picks top), `name` override previo.

### Punto 4: Post Logo (OBLIGATORIO)

**Cuándo**: siempre en Normal mode.

```
[17:45] ④ 4 logo concepts (Tier {N})

[4 SVGs rendered en grid]

Opciones:
  'B1' | 'B2' | 'B3' | 'C1' — pick one
  'direction B' — regenerate variants de esa direction
  'none' — full regen con feedback
  'manual' — upload your own logo
```

**Skipped en**: Fast mode (auto-picks highest-quality).

### Punto 5: Tier elevation confirmation (condicional)

**Cuándo**: scope requires `symbolic-first` o `icon-first` pero current tier es 0.

```
Tu scope requiere symbolic logos.
Tier 0 (Claude native) produce wordmarks bien pero symbolic marks limitados.

Opciones:
  1. Elevar a Tier 1 (~$0.20 Recraft para 3 symbolic concepts)
  2. Cambiar a wordmark-preferred
  3. Proceder con Tier 0 acknowledging quality loss
```

**Skipped en**: user previously set `--tier=0` explicitly (assumes aware).

### Punto 6 (condicional): Coherence gate escalation

**Cuándo**: gate falla 2+ veces tras regeneration.

Ver [09-coherence-model.md#96-escalation-ui-al-user](./09-coherence-model.md#96-escalation-ui-al-user) para prompt completo.

### Punto 7: Post-delivery Claude Design handoff instructions

**Cuándo**: siempre en Normal mode después de Handoff Compiler.

```
[27:42] ⑤ Handoff Compiler — Package completo

📂 output/auren-compliance/brand/
[Lista de deliverables]

📋 Next steps para usar con Claude Design:

  1. Abrir claude.ai/design
  2. Design System Setup → Upload brand-design-document.pdf
  3. Validar con test project
  4. Publicar design system
  5. Usar prompts de prompts-for-claude-design.md en nuevos projects
  6. Claude Design handoff bundle → Claude Code → deploy

¿Querés que abra el README con las instructions completas? [y/n]
```

## 12.4 Edge cases en interacción

Ver [19-edge-cases.md](./19-edge-cases.md) para detalles completos.

- Override inválido → rejection con explanation
- Override conflict con scope → block con options
- Timeout → persist state, `/brand:resume`
- Cancel mid-flow → partial state persisted

## 12.5 Summary tabla — mode × interaction

| Interaction point | Normal | Fast | Extend | Override |
|---|---|---|---|---|
| 1. Scope confirmation (if low conf) | ✓ | skip | n/a | skip |
| 2. Post-Strategy review | ✓ | skip | Only if extending strategy | skip |
| 3. Naming selection | ✓ | skip | Only if extending verbal.naming | skip if name override |
| 4. Logo selection | ✓ | skip | Only if extending logo | skip if manual logo |
| 5. Tier elevation confirmation | conditional | skip (respects --tier) | conditional | skip if --tier set |
| 6. Coherence escalation | ✓ | ✓ | ✓ | ✓ |
| 7. Claude Design handoff instructions | ✓ | shown once (brief) | shown if handoff regen | ✓ |

## 12.6 UX del reveal progresivo

Cada dept devuelve un reveal visual intermedio antes de continuar.

### Formato del reveal

1. **Header con timestamp + depto number**:
   ```
   [3:42] ① Strategy ready — Archetype: SAGE
   ```
2. **Core content** — qué se decidió/generó
3. **Evidence one-line** — por qué así
4. **Interaction prompt** (si aplica)

### Reveal estructurado por dept

- Strategy: archetype + positioning + voice + values (compact)
- Verbal naming: tabla top 5 con availability + fit
- Verbal copy: selected copy samples (hero + tagline + value props)
- Visual: palette swatches + typography rendered + mood grid (si tier ≥ 1)
- Logo: 4-5 SVGs rendered + rationales
- Handoff Compiler: package path + 4 deliverables listed + next steps for Claude Design

### Fast mode reveals

Comprimidos:
```
[15:20] ① Strategy: Sage + positioning + voice ✓
[17:45] ② Verbal: Auren (Top 1, score 9.1) + 12 core copy assets ✓
[21:30] ③ Visual: Navy/Off-white/Amber palette + Fraunces/Inter ✓
[26:14] ④ Logo: B2 selected + 12 derivations ✓ (Tier 0)
[32:40] ⑤ Handoff: 4 deliverables + PDF + Prompts Library + Tokens + Assets ✓
        → Next: upload brand-design-document.pdf to Claude Design
```

## 12.7 Reference files a escribir en Sprint 0

- `skills/brand/references/reveal-script.md` — templates exactos de reveals por mode
- `skills/brand/references/interaction-flow.md` — decision tree de interaction points
- `skills/brand/SKILL.md` orchestrator instructions para mode handling

## 12.8 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Normal mode → 4 puntos de interacción triggered correctamente
2. Fast mode → auto-picks en todos los puntos
3. Extend logo → solo logo dept re-runs
4. Override archetype compatible → Strategy usa override
5. Override archetype blocked → rejection + options
6. User cancel mid-flow → partial state persisted
7. Scope confidence low → Point 1 triggered
8. Scope confidence high → Point 1 skipped
9. Scope requires symbolic + Tier 0 → Point 5 tier elevation triggered
10. Coherence gate fails 2× → Point 6 escalation triggered
11. Post-delivery → Point 7 shows Claude Design instructions

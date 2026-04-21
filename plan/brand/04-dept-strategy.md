# 04 — Department 1: Strategy

## 4.1 Propósito

Strategy es el **único depto que toma decisiones estratégicas**. Convierte scope manifest + validation output + profile en:

- **Archetype locked** (uno de los 12 de Jung, con rationale)
- **Voice attributes definidas** (3-5 adjetivos con definición + do/don'ts)
- **Positioning statement** (frase estructurada)
- **Target audience refinada**
- **Brand values** (3-5 con evidence trace)
- **Brand promise** (oración única)

Todo lo demás en el módulo EJECUTA estas decisiones. Si Strategy está mal, todo está mal. Por eso es un depto aislado con boundary propio.

Su output alimenta el Brand Document (Handoff Compiler) + es context para los prompts del Prompts Library.

## 4.2 Inputs

### Obligatorios
- `brand/{slug}/scope` (manifest del Paso 0)
- `validation/{slug}/report` + dept outputs (Problem, Market, Competitive, BizModel, Risk, Synthesis)
- Idea text original

### Opcionales
- `profile/{user-slug}/core` + `extended`
- User overrides del orchestrator (ej: `override archetype=Hero`)

## 4.3 Proceso detallado

### Paso 1 — Context synthesis

Construir hoja interna (no persistida) que resume founder + idea + market mood + scope context.

### Paso 2 — Archetype selection

**Los 12 arquetipos de Jung** (reference completa en `skills/brand/references/archetype-guide.md`):

| Archetype | Core desire | Strategy | Típico market fit |
|---|---|---|---|
| Innocent | Happiness, simplicity | Wholesomeness | Personal wellness, family |
| Sage | Truth, wisdom | Expertise, guidance | Education, research, consulting |
| Explorer | Freedom, discovery | Adventure, frontier | Travel, outdoor, frontier tech |
| Outlaw | Revolution, disruption | Rule-breaking | Rebellious brands, challengers |
| Magician | Transformation, vision | Make dreams real | Visionary tech, deep transformation |
| Hero | Courage, mastery | Bold solutions | Fitness, productivity |
| Lover | Intimacy, passion | Beauty, connection | Lifestyle, luxury, relationships |
| Jester | Joy, fun | Levity, play | Entertainment, casual consumer |
| Everyman | Belonging, connection | Relatable, down-to-earth | Mass consumer, accessible |
| Caregiver | Service, protection | Nurture, support | Healthcare, nonprofit, kids |
| Ruler | Control, order | Authority, premium | Enterprise, luxury, financial |
| Creator | Self-expression, innovation | Build, craft | Design tools, creative platforms |

**Algoritmo**:

```
def select_archetype(context):
    candidates = all_12_archetypes
    candidates = [a for a in candidates if a not in scope.archetype_constraints.blocked]
    
    scores = {}
    for archetype in candidates:
        score = 0
        if profile:
            score += fit_with_profile(archetype, profile) * 0.35
        score += fit_with_positioning(archetype, context) * 0.35
        score += differentiation_from_market(archetype, context.market_mood) * 0.20
        if archetype in scope.archetype_constraints.preferred_range:
            score += 0.10
        scores[archetype] = score
    
    top_3 = sorted(scores.items(), key=lambda x: -x[1])[:3]
    return {
        "chosen": top_3[0][0],
        "rationale": build_rationale(top_3[0][0], context),
        "alternatives": [
            {"name": top_3[1][0], "reason_rejected": explain(...)},
            {"name": top_3[2][0], "reason_rejected": explain(...)}
        ]
    }
```

### Paso 3 — Voice attributes (3-5 adjetivos)

Base defaults por archetype (tabla completa en reference):

| Archetype | Voice defaults |
|---|---|
| Sage | claro, autorizante, medido, pedagógico, preciso |
| Ruler | autorizante, confiado, premium, exclusivo, cálido-formal |
| Hero | determinado, motivacional, directo, fuerte, action-oriented |
| Creator | exploratorio, inspirador, técnico-artístico, apasionado |
| Jester | juguetón, irónico, ligero, irreverente, inesperado |
| Everyman | cálido, directo, accesible, humilde, relatable |
| Caregiver | cálido, empático, reconfortante, protector, claro |
| Innocent | optimista, simple, puro, genuino, esperanzador |
| Explorer | curioso, aventurero, libre, abierto, frontera |
| Outlaw | contundente, desafiante, disruptor, visceral, provocador |
| Magician | visionario, transformador, místico, catalyst, possibility-focused |
| Lover | sensual, emocional, íntimo, estético, apasionado |

**Modulación por register**:

| Register | Effect |
|---|---|
| `formal-professional` | Remueve "irónico, playful, visceral". Agrega "medido, credible" |
| `professional-warm` | Balance — mantiene personality softening extremes |
| `casual-friendly` | Permite "directo, sincero, humano" |
| `playful-bold` | Amplifica elementos lúdicos |
| `expressive-raw` | Permite "visceral, crudo, emocional" |

**Output por voice attribute**:
```json
{
  "attribute": "claro",
  "definition": "lenguaje directo, sin jargon opaco",
  "do_examples": ["Este análisis toma 40 horas. Auren lo hace en 2.", "..."],
  "dont_examples": ["Nuestra solución innovadora aprovecha sinergias...", "..."]
}
```

Cada voice attribute con do/don'ts concretos. Estos viajan al Brand Document + son referenced por cada prompt del Prompts Library.

### Paso 3b — Do/Don't examples por archetype

Ejemplos de referencia para todos los 12 archetypes. Son **templates** — Strategy los customiza al brand/idea específicos durante generation.

#### Sage

**Voice attribute ejemplo**: "preciso"

- ✓ DO: "Cortás 40 horas de trabajo semanal. No 'mucho tiempo', no 'rápidamente'. 40 horas."
- ✓ DO: "La evidence sugiere tres opciones. Te explico cada una."
- ✗ DON'T: "Revolucionamos la industria con AI de próxima generación."
- ✗ DON'T: "El mejor producto del mercado (punto)."

**Context de aplicación**: documentation, legal copy, analytical content, technical explanations, consulting reports.

#### Ruler

**Voice attribute ejemplo**: "autorizante"

- ✓ DO: "Built for teams that set the standard."
- ✓ DO: "We've served Fortune 500 compliance teams since 2018."
- ✗ DON'T: "Join our amazing community of builders!"
- ✗ DON'T: "Anyone can achieve X with us."

**Context de aplicación**: enterprise landing pages, premium brand positioning, financial services, luxury products, executive-targeted content.

#### Hero

**Voice attribute ejemplo**: "action-oriented"

- ✓ DO: "Stop tracking habits. Start building them."
- ✓ DO: "10,000 steps isn't a goal. It's today's floor."
- ✗ DON'T: "Our app helps you explore your wellness journey."
- ✗ DON'T: "Consider the possibility of a healthier lifestyle."

**Context de aplicación**: fitness/productivity apps, challenge-based products, transformation-focused brands, B2B products that champion user against enemy (inefficiency, waste, chaos).

#### Creator

**Voice attribute ejemplo**: "inspirador"

- ✓ DO: "You don't find the right font. You build the voice with it."
- ✓ DO: "Every canvas is empty until it isn't."
- ✗ DON'T: "Use our templates for easy results."
- ✗ DON'T: "Design without thinking."

**Context de aplicación**: design tools, creative platforms, maker communities, developer tools with craft positioning (Linear, Figma, Notion in early days).

#### Jester

**Voice attribute ejemplo**: "juguetón"

- ✓ DO: "Your spreadsheet is on fire. 🔥 We have the water."
- ✓ DO: "Yes, we're named after a vegetable. Move on."
- ✗ DON'T: "Our enterprise solution optimizes workflow efficiency."
- ✗ DON'T: "We value collaborative synergies."

**Context de aplicación**: consumer apps with personality (Duolingo, Cleo, Robinhood early), brands targeting Gen Z, subversive B2B brands (Basecamp historically).

#### Outlaw

**Voice attribute ejemplo**: "desafiante"

- ✓ DO: "The old way is broken. We know. We made the new one."
- ✓ DO: "Your bank doesn't want you here. Perfect."
- ✗ DON'T: "We're committed to delivering value within existing frameworks."
- ✗ DON'T: "Join the industry leaders."

**Context de aplicación**: disruptor brands (crypto early, fintech challengers, rebellious consumer brands), movements against incumbents, aggressively positioned startups.

#### Magician

**Voice attribute ejemplo**: "transformador"

- ✓ DO: "What took 10 engineers now takes 1 prompt."
- ✓ DO: "The future isn't coming. It's running in your terminal."
- ✗ DON'T: "Our tool does X well."
- ✗ DON'T: "Step-by-step improvement guaranteed."

**Context de aplicación**: cutting-edge AI tools, transformational products (Cursor, Midjourney, early Notion), visionary brands.

#### Everyman

**Voice attribute ejemplo**: "accesible"

- ✓ DO: "You don't need a finance degree. You need 15 minutes."
- ✓ DO: "Here's what we do, in plain English."
- ✗ DON'T: "Leverage our proprietary algorithmic infrastructure."
- ✗ DON'T: "Exclusive access for qualified prospects."

**Context de aplicación**: mainstream consumer brands, accessible SaaS (Linear, Notion), broad-audience products.

#### Caregiver

**Voice attribute ejemplo**: "empático"

- ✓ DO: "Start where you are. No judgment."
- ✓ DO: "We'll walk through this with you."
- ✗ DON'T: "Optimize your output with our tool."
- ✗ DON'T: "Compete with the best."

**Context de aplicación**: healthcare, mental health apps, parenting products, support communities, accessibility-focused tools.

#### Innocent

**Voice attribute ejemplo**: "simple"

- ✓ DO: "Breathe in. Breathe out. That's it."
- ✓ DO: "Three questions. Three minutes. Done."
- ✗ DON'T: "Leverage our advanced mindfulness engine."
- ✗ DON'T: "Complex journaling methodologies."

**Context de aplicación**: meditation/wellness apps (Calm, Headspace), simplicity-focused products, kids products, Clean-slate rebranding.

#### Explorer

**Voice attribute ejemplo**: "aventurero"

- ✓ DO: "We went off the map so you don't have to."
- ✓ DO: "Built in the wild. Tested in the impossible."
- ✗ DON'T: "Industry-standard approach."
- ✗ DON'T: "Safe, reliable, predictable."

**Context de aplicación**: travel/outdoor brands, frontier tech, adventurous consumer products (GoPro, Patagonia, expedition-themed tools).

#### Lover

**Voice attribute ejemplo**: "íntimo"

- ✓ DO: "We pay attention to the details you notice."
- ✓ DO: "Made for the way you actually feel, not the way you think you should."
- ✗ DON'T: "Maximize your productivity."
- ✗ DON'T: "Mass-market solution."

**Context de aplicación**: beauty/lifestyle brands, relationship apps, luxury positioning with emotional depth, journaling apps, dating.

### Paso 3c — Voice register × archetype matrix

Cómo cambia la expresión de voice attributes según register:

| Archetype | formal-professional | casual-friendly | playful-bold | expressive-raw |
|---|---|---|---|---|
| Sage | "Our analysis demonstrates..." | "Here's what the data shows..." | ~incompatible (Sage rarely playful) | ~incompatible (Sage avoids extremes) |
| Ruler | "Our platform serves..." | Too informal for Ruler | ~incompatible | ~incompatible |
| Hero | "Achieve peak performance" | "Get after it" | "Crush your goals 💪" | "This is the line. Cross it." |
| Creator | "Design considered..." | "Made with intention" | "Built weird, on purpose" | "We don't apologize for the aesthetic" |
| Jester | ~incompatible | "Yeah this is fun" | "BEEP BOOP 🤖" | "This is unhinged and we love it" |
| Everyman | "We help people with..." | "We're here for everyone" | "Just, like, a normal product" | "Fine, sometimes we're weird" |
| Caregiver | "We provide support for..." | "We've got you" | "We're here, grabbing your hand 🤝" | "You don't have to do this alone" |
| Innocent | "Our app simplifies..." | "Keep it simple" | "Three taps. Done. 🎉" | Generally stays sweet |
| Explorer | "Built for expeditions" | "Made for the trail" | "WE WENT WHERE?! 🌋" | "Untamed. Not for everyone." |
| Outlaw | ~compatible but dulls edge | "Screw the old way" | "Burn it down 🔥" | "The rules were bullshit." |
| Magician | "Transform your workflow" | "Change how you build" | "Abracadabra your stack ✨" | "Magic isn't real. Except this." |
| Lover | "Designed with care" | "Made with love" | "Fall in love with X 💕" | "You deserve this." |

**~incompatible** = registers that fight the archetype — avoid or use sparingly con user awareness.

### Cómo Strategy usa estas tables

1. Identificar archetype (Paso 2)
2. Identificar register del scope (intensity_modifiers.verbal_register)
3. Usar combinación para construir voice_attributes + do/don'ts específicos
4. Si combinación flagged como ~incompatible: ajustar (choose different voice attrs o escalate to user que el register choice no matchea archetype)

Esta tabla DEBE ir también como reference en `skills/brand/references/archetype-guide.md` para consultarse por Strategy dept y Verbal dept.

### Paso 4 — Brand values (3-5)

Cada value con name + definition + evidence source + rationale.

### Paso 5 — Brand promise

Formula: "Para [target], [nombre/categoría] que [diferenciador principal]."

### Paso 6 — Positioning statement

Expansión del promise con más context (categoría + reason to believe + unlike competitor).

### Paso 7 — Target audience refinement

Del Problem dept obtenemos targets genéricos. Strategy los refina con psychographics + channels + pain narrative para informar Verbal + prompts del Library.

## 4.4 Tools

**Ninguno externo**. Solo Engram retrieval + Claude reasoning.

**Justificación**: Strategy es decisión. Variance externa contamina decisiones.

## 4.5 Output schema completo

```json
{
  "schema_version": "1.0",
  "status": "ok",
  "department": "strategy",
  "scope_ref": "brand/{slug}/scope",
  "archetype": {
    "chosen": "Sage",
    "rationale": "...",
    "considered_alternatives": [{"name": "Ruler", "reason_rejected": "..."}, ...],
    "decided_without_profile": false
  },
  "voice_attributes": [
    {
      "attribute": "claro",
      "definition": "...",
      "do_examples": ["..."],
      "dont_examples": ["..."]
    },
    ...3-5 total
  ],
  "brand_values": [
    {"value": "Rigor", "definition": "...", "evidence_source": "...", "rationale": "..."},
    ...3-5 total
  ],
  "brand_promise": "...",
  "positioning_statement": "...",
  "target_audience_refined": {
    "primary": {"description": "...", "psychographics": "...", "channels": [...], "pain_narrative": "..."},
    "secondary": {...}
  },
  "evidence_trace": {
    "profile_fields_used": [...],
    "validation_depts_used": [...],
    "scope_modifiers_applied": [...]
  }
}
```

## 4.6 Persistencia

`brand/{slug}/strategy` en Engram.

## 4.7 Reveal al user

```
[3:42] ① Strategy ready — Archetype: SAGE

"Para compliance officers de fintechs LATAM,
 Auren es la plataforma que reduce auditorías
 regulatorias de 40h a 2h sin sacrificar rigor."

Voice attributes:
  • claro           — directo, sin jargon opaco
  • autorizante     — precisa sin arrogancia
  • directo         — sentencias cortas, lead con claim
  • empático-técnico — respeta inteligencia del lector

Brand values: Rigor · Claridad · Pragmatismo

Archetype considered:
  ✓ Sage (chosen — fit founder + white space vs competitors)
  ✗ Ruler (descartado — Workiva ocupa el espacio)
  ✗ Hero (descartado — no matchea risk_tolerance low del founder)

¿OK para continuar o preferís alternativa?
  [Enter para continuar]
```

En **fast mode**: skipea el prompt y procede.

## 4.8 Relación con otros deptos

**Verbal Identity consume**:
- Archetype (modulación de naming style preferred)
- Voice attributes (aplicar en toda la generación de copy)
- Positioning statement (para hero headline, value props)
- Target audience refined (para adaptar copy per segment)

**Visual System consume**:
- Archetype (seed primary para palette + typography era)
- Brand values (afecta visual principles)

**Logo consume** (indirecto via Visual + Verbal):
- Archetype vocabulary para prompt engineering
- Voice attributes para rationale

**Handoff Compiler consume**:
- Todo para el Brand Document PDF
- Todo para el Prompts Library (cada prompt include voice attributes como guía)
- Brand values para el README del package

## 4.9 Failure modes específicos

### No se puede elegir archetype (todos blocked)
- Relax constraints removing preferred_range restriction
- Flag en output
- Si sigue fallando: escalate al user con opciones

### Profile contradictorio con idea
- Flag en envelope, elegir el archetype least contradictory
- Opcional: suggest profile update

### Validation data insuficiente
- Use Market dept como fallback para target
- Flag `"target_audience_inferred_from_market_dept"`

### Claude generation returns schema-invalid
- Retry with explicit schema reminder, max 2 retries

## 4.10 SKILL.md a escribir en Sprint 0

`skills/brand/strategy/SKILL.md` — instrucciones completas. Estructura:

1. Identity
2. Inputs (Engram queries)
3. Representation principles
4. Process step-by-step (7 pasos)
5. Archetype selection algorithm
6. Voice attribute synthesis
7. Output Assembly Checklist
8. Persistence
9. Critical Rules

## 4.11 Reference files a escribir en Sprint 0

- `skills/brand/strategy/references/data-schema.md`
- `skills/brand/references/archetype-guide.md` — 12 archetypes expandidos con:
  - Voice defaults
  - Visual associations
  - Typography associations
  - Palette families
  - Positioning patterns
  - Archetype compatibility matrix
- `skills/brand/strategy/references/positioning-frameworks.md` — templates + examples

## 4.12 Testing de Strategy

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Input B2B SaaS + Sage-compatible profile → Sage con confidence alta
2. Input consumer app + Explorer-compatible profile → Explorer
3. Input con profile contradictorio → flagged, ajustado conservadoramente
4. Input sin profile → `decided_without_profile: true`
5. Mismo input, 2 runs → archetype consistent
6. Voice attributes detectably derivadas del archetype + register

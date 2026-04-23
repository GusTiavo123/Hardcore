# 04 — Department 1: Strategy

## 4.1 Propósito

Strategy es el **único depto que toma decisiones estratégicas**. Convierte scope manifest + validation output + profile en:

- **Archetype locked** (uno de los 12 de Jung, con rationale)
- **Voice attributes definidas** (3-5 adjetivos con definición + do/don'ts)
- **Positioning statement** (frase estructurada)
- **Target audience refinada** (con psychographics, channels, pain_narrative — campos consumidos por Verbal + Visual)
- **Brand values** (3-5 con evidence trace)
- **Brand promise** (oración única)
- **Sentiment landscape derivada** (cross-module signal para Gate 0)

Todo lo demás en el módulo EJECUTA estas decisiones. Si Strategy está mal, todo está mal. Por eso es un depto aislado con boundary propio.

Su output alimenta el Brand Document (Handoff Compiler) + es context para los prompts del Prompts Library + es input para Gate 0 (coherence model).

## 4.2 Inputs

Los inputs se consumen según el contrato `skills/_shared/brand-contract.md`. Strategy lee:

### Obligatorios
- `brand/{slug}/scope` (manifest del Paso 0, incluye `intensity_modifiers.verbal_register` y `archetype_constraints`)
- `validation/{slug}/synthesis.data` — verdict, score_breakdown, key_strengths, key_concerns, founder_fit
- `validation/{slug}/problem.data` — problem_statement, target_user, industry, pain_intensity, current_solutions, demand_stack
- `validation/{slug}/market.data` — market_stage, som, early_adopters, growth_rate
- `validation/{slug}/competitive.data` — direct_competitors (weaknesses), market_gaps, pricing_benchmark, failed_competitors (para sentiment derivation)
- `validation/{slug}/bizmodel.data` — recommended_model, pricing_suggestion
- `validation/{slug}/risk.data` — overall_risk_level, top_3_killers
- Idea text original

### Opcionales
- `founder_brand_context` (projection del profile, pasada por el orchestrator según brand-contract.md)
- User overrides del orchestrator (ej: `override archetype=Hero`)

## 4.3 Proceso detallado

### Paso 1 — Context synthesis

Construir una hoja interna (no persistida, contextual para el resto del proceso) que resume:

- Founder context: domain expertise (depth), risk_tolerance, values, working_style, credibility_capital, previous_ventures relevantes
- Idea essence: problem + solution + target
- Market mood: market_stage, growth_rate, direct_competitors key weaknesses, market_gaps principales, sentiment signals
- Scope context: brand_profile, verbal_register, archetype constraints (blocked + preferred_range)

Esta síntesis informa pasos subsiguientes — no se emite al output directamente.

### Paso 1b — Sentiment landscape derivation (input para Gate 0)

Derivar un descriptor del sentiment landscape del mercado que se usa para (a) modulación de archetype selection, (b) input de Gate 0 en Handoff Compiler.

Derivación determinística a partir de competitive + market:

| Signal combinado | sentiment_landscape |
|---|---|
| `market_stage = mature` AND (weaknesses menciona "trust/reliability/compliance" OR failed_competitors.reason_failed = regulatory/trust_breach) | `trust_heavy` |
| weaknesses incluye `outdated/slow/legacy/bureaucratic` AND market_gaps con frases "no alternatives" / "underserved" | `disruption_ready` |
| market_stage = `growing` AND sin señales extremas | `saturation_neutral` |
| sentiment mayoritariamente negativa (3+ direct_competitors con weaknesses críticas) AND failed_competitors > 3 | `low_trust_context` |
| Otra combinación | `mixed` |

Si los datos de competitive son insuficientes (ej. <2 direct_competitors), emitir `sentiment_landscape: "insufficient_data"` — Gate 0 manejará el caso.

El valor derivado se emite en el output schema como `sentiment_landscape` y se pasa a Handoff Compiler como input de Gate 0.

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
candidates = all_12_archetypes \ scope.archetype_constraints.blocked

for archetype in candidates:
    fit_profile = fit_with_profile(archetype, founder_brand_context)  # 0..1, si profile disponible
    fit_position = fit_with_positioning(archetype, context)            # 0..1
    differentiation = differentiation_from_market(archetype, competitors)  # 0..1
    sentiment_fit = fit_with_sentiment_landscape(archetype, sentiment_landscape)  # 0..1
    preferred_bonus = 0.10 if archetype in scope.archetype_constraints.preferred_range else 0

    weights:
      fit_profile: 0.30 (if profile available) / 0 (si ausente, redistribuir)
      fit_position: 0.30
      differentiation: 0.20
      sentiment_fit: 0.20

    score = fit_profile * w_profile
          + fit_position * 0.30
          + differentiation * 0.20
          + sentiment_fit * 0.20
          + preferred_bonus

top_3 = sorted(scores, desc)[:3]
chosen = top_3[0]
```

**`fit_with_sentiment_landscape` mapping** (0..1):

| sentiment | Archetypes con score alto (≥0.8) | Archetypes con score medio (0.4–0.7) | Archetypes con score bajo (<0.4) |
|---|---|---|---|
| `trust_heavy` | Sage, Ruler, Caregiver, Everyman | Hero, Magician (cuidado con hype) | Outlaw, Jester, Rebel |
| `disruption_ready` | Outlaw, Hero, Magician, Explorer, Creator | Jester | Ruler, Everyman |
| `saturation_neutral` | Todos | — | — |
| `low_trust_context` | Sage, Caregiver, Everyman | Ruler (si trust issue no es por gatekeeping), Innocent | Outlaw, Jester |
| `insufficient_data` | Usar solo las otras dimensiones (ignore sentiment_fit weight, renormalize) | | |

**Output de este paso**:

```json
{
  "chosen": "Sage",
  "rationale": "string — por qué Sage dado founder + positioning + mercado trust_heavy",
  "considered_alternatives": [
    {"name": "Ruler", "reason_rejected": "espacio ocupado por Workiva en LATAM compliance"},
    {"name": "Caregiver", "reason_rejected": "no matchea credibility_capital del founder"}
  ],
  "sentiment_landscape_used": "trust_heavy"
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

### Paso 3a — Precedencia de voz (regla de arbitraje)

Tres fuentes pueden influir la voz. Cuando conflictan, aplicar este orden de precedencia (definido en `skills/_shared/brand-contract.md`):

1. **Archetype** (primary, derivado en Paso 2) — establece la voice baseline
2. **Scope.verbal_register** (constraint de mercado) — puede *restringir* el register dentro de opciones compatibles con el archetype
3. **Profile working_style / communication_style** (modifier) — preferencia del founder

**Regla**:
- Archetype elige la familia base de voice attributes
- Scope aplica modulación por register (ver 3c) — puede elegir qué atributos amplificar/suprimir dentro del rango compatible con el archetype
- Profile registra la preferencia del founder como **annotation** en el Brand Document pero NO override si conflicta con los dos anteriores

**Ejemplo de conflicto**:
- Archetype = Sage → voice baseline pedagógica
- Scope.verbal_register = `formal-professional` (por brand_profile b2b-enterprise compliance-heavy) → suprime "playful" y "irónico"
- Profile indica preferencia de tono "casual, irreverente"
- **Resolución**: voice = formal-pedagógico. El Brand Document anota: *"Founder preferred casual/irreverent tone; suppressed por market formality requirement. Considerar re-visitar si el positioning cambia."*
- Flag `founder-voice-override-suppressed` en envelope

El output registra qué preference se aplicó y cuál se suprimió para transparencia:

```json
"voice_precedence_applied": {
  "archetype_contribution": "Sage → pedagogical baseline",
  "scope_register_contribution": "formal-professional → suppress playful/ironic",
  "profile_preference_applied": false,
  "profile_preference_noted_in_document": true,
  "conflicts_resolved": ["founder preferred casual tone; market register is formal"]
}
```

### Paso 3b — Modulación por register

| Register | Effect sobre voice attributes |
|---|---|
| `formal-professional` | Remueve "irónico, playful, visceral". Agrega "medido, credible" |
| `professional-warm` | Balance — mantiene personality, softening extremes |
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

### Paso 3c — Do/Don't examples por archetype

Ejemplos de referencia para los 12 archetypes. Son **templates** — Strategy los customiza al brand/idea específicos durante generation.

#### Sage
- ✓ DO: "Cortás 40 horas de trabajo semanal. No 'mucho tiempo', no 'rápidamente'. 40 horas."
- ✓ DO: "La evidence sugiere tres opciones. Te explico cada una."
- ✗ DON'T: "Revolucionamos la industria con AI de próxima generación."
- ✗ DON'T: "El mejor producto del mercado (punto)."

**Context**: documentation, legal copy, analytical content, technical explanations, consulting reports.

#### Ruler
- ✓ DO: "Built for teams that set the standard."
- ✓ DO: "We've served Fortune 500 compliance teams since 2018."
- ✗ DON'T: "Join our amazing community of builders!"
- ✗ DON'T: "Anyone can achieve X with us."

**Context**: enterprise landing, premium brand positioning, financial services, luxury, executive-targeted content.

#### Hero
- ✓ DO: "Stop tracking habits. Start building them."
- ✓ DO: "10,000 steps isn't a goal. It's today's floor."
- ✗ DON'T: "Our app helps you explore your wellness journey."
- ✗ DON'T: "Consider the possibility of a healthier lifestyle."

**Context**: fitness/productivity apps, challenge-based products, transformation-focused brands, B2B products that champion user against enemy (inefficiency, waste, chaos).

#### Creator
- ✓ DO: "You don't find the right font. You build the voice with it."
- ✓ DO: "Every canvas is empty until it isn't."
- ✗ DON'T: "Use our templates for easy results."
- ✗ DON'T: "Design without thinking."

**Context**: design tools, creative platforms, maker communities, developer tools with craft positioning (Linear, Figma, Notion in early days).

#### Jester
- ✓ DO: "Your spreadsheet is on fire. 🔥 We have the water."
- ✓ DO: "Yes, we're named after a vegetable. Move on."
- ✗ DON'T: "Our enterprise solution optimizes workflow efficiency."
- ✗ DON'T: "We value collaborative synergies."

**Context**: consumer apps with personality (Duolingo, Cleo, Robinhood early), brands targeting Gen Z, subversive B2B brands.

#### Outlaw
- ✓ DO: "The old way is broken. We know. We made the new one."
- ✓ DO: "Your bank doesn't want you here. Perfect."
- ✗ DON'T: "We're committed to delivering value within existing frameworks."
- ✗ DON'T: "Join the industry leaders."

**Context**: disruptor brands (crypto early, fintech challengers, rebellious consumer brands), movements against incumbents.

#### Magician
- ✓ DO: "What took 10 engineers now takes 1 prompt."
- ✓ DO: "The future isn't coming. It's running in your terminal."
- ✗ DON'T: "Our tool does X well."
- ✗ DON'T: "Step-by-step improvement guaranteed."

**Context**: cutting-edge AI tools, transformational products (Cursor, Midjourney, early Notion), visionary brands.

#### Everyman
- ✓ DO: "You don't need a finance degree. You need 15 minutes."
- ✓ DO: "Here's what we do, in plain English."
- ✗ DON'T: "Leverage our proprietary algorithmic infrastructure."
- ✗ DON'T: "Exclusive access for qualified prospects."

**Context**: mainstream consumer brands, accessible SaaS (Linear, Notion), broad-audience products.

#### Caregiver
- ✓ DO: "Start where you are. No judgment."
- ✓ DO: "We'll walk through this with you."
- ✗ DON'T: "Optimize your output with our tool."
- ✗ DON'T: "Compete with the best."

**Context**: healthcare, mental health apps, parenting products, support communities, accessibility-focused tools.

#### Innocent
- ✓ DO: "Breathe in. Breathe out. That's it."
- ✓ DO: "Three questions. Three minutes. Done."
- ✗ DON'T: "Leverage our advanced mindfulness engine."
- ✗ DON'T: "Complex journaling methodologies."

**Context**: meditation/wellness apps (Calm, Headspace), simplicity-focused products, kids products, clean-slate rebranding.

#### Explorer
- ✓ DO: "We went off the map so you don't have to."
- ✓ DO: "Built in the wild. Tested in the impossible."
- ✗ DON'T: "Industry-standard approach."
- ✗ DON'T: "Safe, reliable, predictable."

**Context**: travel/outdoor brands, frontier tech, adventurous consumer products (GoPro, Patagonia).

#### Lover
- ✓ DO: "We pay attention to the details you notice."
- ✓ DO: "Made for the way you actually feel, not the way you think you should."
- ✗ DON'T: "Maximize your productivity."
- ✗ DON'T: "Mass-market solution."

**Context**: beauty/lifestyle brands, relationship apps, luxury positioning with emotional depth, journaling apps.

### Paso 3d — Voice register × archetype matrix

Cómo cambia la expresión de voice attributes según register:

| Archetype | formal-professional | casual-friendly | playful-bold | expressive-raw |
|---|---|---|---|---|
| Sage | "Our analysis demonstrates..." | "Here's what the data shows..." | ~incompatible | ~incompatible |
| Ruler | "Our platform serves..." | Too informal | ~incompatible | ~incompatible |
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

**~incompatible** = registers que pelean con el archetype — evitar o usar sparingly con awareness del user.

Si la combinación resultante es `~incompatible`, Strategy flagea `voice_register_archetype_tension: true` en el output y sugiere que el user re-elige register o el orchestrator escala pre-run.

Esta tabla va también en `skills/brand/references/archetype-guide.md` para ser consultada por Strategy y Verbal.

### Paso 4 — Brand values (3-5)

Cada value con name + definition + evidence source (typical: profile.motivation.values si hay match, o principle derivado de la idea) + rationale.

### Paso 5 — Brand promise

Formula: "Para [target refined], [nombre/categoría] que [diferenciador principal]."

### Paso 6 — Positioning statement

Expansión del promise con más context: category + reason to believe (proof anchors) + unlike competitor (diferenciación explícita).

### Paso 7 — Target audience refinement

Del Problem dept obtenemos targets genéricos. Strategy los refina en la estructura que Verbal y Visual consumen:

```json
"target_audience_refined": {
  "primary": {
    "description": "string — 1-2 líneas de quién es",
    "psychographics": "string — valores, mindset, fears, aspirations",
    "channels": ["linkedin", "podcasts técnicos", "conferencias de compliance"],
    "pain_narrative": "string — cómo el target narrativamente describe su pain",
    "language_register_native": "formal-professional | etc"
  },
  "secondary": null | {...}
}
```

Estos sub-keys son consumidos por:
- Verbal: para adaptar copy per segment + channel
- Visual: para mood imagery queries + aesthetic calibration

## 4.4 Tools

**Ninguno externo en la mayoría de runs**. Solo Engram retrieval + Claude reasoning.

**Excepción**: si `sentiment_landscape` derivation queda `insufficient_data` y el user autoriza research adicional, Strategy puede ejecutar open-websearch queries limitadas (~3-5) sobre el sector para enriquecer signals. Default: no web search en Strategy.

## 4.5 Output schema completo

```json
{
  "schema_version": "1.0",
  "status": "ok",
  "department": "strategy",
  "scope_ref": "brand/{slug}/scope",

  "archetype": {
    "chosen": "Sage",
    "rationale": "string",
    "considered_alternatives": [
      {"name": "Ruler", "reason_rejected": "string"},
      {"name": "Caregiver", "reason_rejected": "string"}
    ],
    "sentiment_landscape_used": "trust_heavy | disruption_ready | saturation_neutral | low_trust_context | mixed | insufficient_data"
  },

  "voice_attributes": [
    {
      "attribute": "claro",
      "definition": "string",
      "do_examples": ["string"],
      "dont_examples": ["string"]
    }
  ],

  "voice_precedence_applied": {
    "archetype_contribution": "string",
    "scope_register_contribution": "string",
    "profile_preference_applied": "boolean",
    "profile_preference_noted_in_document": "boolean",
    "conflicts_resolved": ["string"]
  },

  "voice_register_archetype_tension": "boolean",

  "brand_values": [
    {
      "value": "Rigor",
      "definition": "string",
      "evidence_source": "founder profile | validation.problem | derived from positioning",
      "rationale": "string"
    }
  ],

  "brand_promise": "string",
  "positioning_statement": "string",

  "target_audience_refined": {
    "primary": {
      "description": "string",
      "psychographics": "string",
      "channels": ["string"],
      "pain_narrative": "string",
      "language_register_native": "string"
    },
    "secondary": null
  },

  "sentiment_landscape": "trust_heavy | disruption_ready | saturation_neutral | low_trust_context | mixed | insufficient_data",

  "flags": [],

  "evidence_trace": {
    "profile_fields_used": ["string"],
    "validation_depts_used": ["problem", "market", "competitive", "bizmodel", "risk", "synthesis"],
    "scope_modifiers_applied": ["string"],
    "sentiment_landscape_derivation_path": "string — qué signals llevaron al descriptor elegido"
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

Sentiment landscape: trust_heavy (market mature + regulatory failed competitors)

Archetype considered:
  ✓ Sage (chosen — fit founder + white space vs competitors + compatible con trust_heavy market)
  ✗ Ruler (descartado — Workiva ocupa el espacio)
  ✗ Hero (descartado — no matchea risk_tolerance conservador del founder)

¿OK para continuar o preferís alternativa?
  [Enter para continuar]
```

En **fast mode**: skipea el prompt y procede.

## 4.8 Relación con otros deptos

**Verbal Identity consume**:
- `archetype` — modulación de naming style preferred
- `voice_attributes` — aplicar en toda la generación de copy
- `positioning_statement` — para hero headline, value props
- `target_audience_refined.primary.channels` — qué prompts del Prompts Library son priority
- `target_audience_refined.primary.pain_narrative` — para landing hero copy

**Visual System consume**:
- `archetype` — seed primary para palette + typography era
- `brand_values` — afecta visual principles
- `target_audience_refined.primary.psychographics` — informa mood imagery queries

**Logo consume** (vía Visual + Verbal):
- `archetype` vocabulary para form language
- `voice_attributes` para rationale

**Handoff Compiler consume**:
- Todo el output para el Brand Document PDF
- `sentiment_landscape` como input de Gate 0 (coherence)
- Todo para el Prompts Library (cada prompt incluye voice attributes como guía)

## 4.9 Failure modes específicos

### No se puede elegir archetype (todos blocked)
Relax constraints removiendo `preferred_range` restriction. Si sigue fallando, flag en output + escalate al user con opciones.

### Profile contradictorio con idea (hard_nos hits)
Halt en pre-filter (orchestrator), no llega a Strategy. Si pasa el pre-filter pero hay tensión menor, flag en envelope, elegir el archetype least contradictory.

### Validation data insuficiente para sentiment_landscape derivation
`sentiment_landscape: "insufficient_data"`. Gate 0 surface al user que decide si continuar skip vs re-validar competitive.

### Claude generation returns schema-invalid
Retry con explicit schema reminder, max 2 retries. Si persistente, halt dept con error.

## 4.10 Archivos a escribir en Sprint 0

Para este depto:
- `skills/brand/strategy/SKILL.md` — instrucciones completas. **Incluye inline**: sentiment_landscape derivation algorithm, archetype selection algorithm, voice attributes synthesis (defaults + register modulation + precedence rule), positioning frameworks (templates + examples), brand values derivation
- `skills/brand/strategy/references/data-schema.md`

La ref compartida `skills/brand/references/archetype-guide.md` (a nivel orchestrator) contiene:
- 12 archetypes expandidos con voice defaults, visual associations, typography associations, palette families, positioning patterns
- Archetype × sentiment_landscape compatibility matrix
- Voice × register matrix

Esta ref la consumen Strategy, Verbal, Visual y Logo — por eso vive a nivel orchestrator.

## 4.12 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Input B2B SaaS + Sage-compatible profile + trust_heavy sentiment → Sage con confidence alta
2. Input consumer app + Explorer-compatible profile + disruption_ready → Explorer
3. Input con profile contradictorio → flagged, ajustado conservadoramente
4. Input sin profile → `decided_without_profile: true`, weight redistribution funciona
5. Mismo input, 2 runs → archetype consistent, voice_attributes consistent
6. Voice attributes detectably derivadas del archetype + register
7. Sentiment landscape `insufficient_data` → flag emitido, downstream puede decidir
8. Voice precedence conflict (founder vs scope) → scope wins, profile preference anotada
9. Scope register + archetype tension (`~incompatible`) → flag emitido

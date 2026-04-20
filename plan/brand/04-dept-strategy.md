# 04 — Department 1: Strategy

## 4.1 Propósito

Strategy es el **único depto que toma decisiones estratégicas**. Convierte el scope manifest + validation output + profile en:

- **Archetype locked** (uno de los 12 de Jung, con rationale)
- **Voice attributes definidas** (3-5 adjetivos con definición + do/don'ts)
- **Positioning statement** (frase estructurada)
- **Target audience refinada** (más específica que la del Problem dept)
- **Brand values** (3-5 con evidence trace)
- **Brand promise** (oración única)

Todo lo demás en el módulo EJECUTA estas decisiones. Si Strategy está mal, todo está mal. Por eso es un depto aislado con boundary propio.

## 4.2 Inputs

### Obligatorios
- `brand/{slug}/scope` (manifest del Paso 0)
- `validation/{slug}/report` + todos los dept outputs:
  - Problem: target audience real, evidence, pain points
  - Market: SOM, segmentos, geografías, CAGR
  - Competitive: incumbents + gaps + moats + white space visual/narrativo
  - BizModel: pricing model, unit economics (informa voice — "premium" vs "budget")
  - Risk: timing context, regulatory (puede informar archetype conservative vs disruptive)
  - Synthesis: verdict + scores + flags
- Idea text original

### Opcionales
- `profile/{user-slug}/core` + `extended` (toda la profile si existe)
- User overrides del orchestrator (ej: `override archetype=Hero` si el user lo forzó)

## 4.3 Proceso detallado

### Paso 1 — Context synthesis

Construir una hoja interna (no se persiste — es razonamiento intermedio) que resume:

```
WHO — Founder (si existe):
  - Name, background, domain expertise
  - Risk tolerance, commitment
  - Audience pre-existente (si hay)
  - Values declarados
  - Constraints (hard_nos, regulatory_limits)

WHAT — La idea:
  - Categoría (del Validation)
  - Target audience refinada (del Problem dept)
  - Diferenciador principal (del Competitive + Problem)
  - Pricing model (del BizModel)
  - Timing context (del Risk)

MARKET MOOD — Cómo se ve el mercado visualmente/narrativamente:
  - Tone dominante de competidores (corporate/serio, playful/irreverent, cold/technical)
  - Visual patterns (minimalistic vs expressive, restrained vs loud)
  - Positioning gaps (dónde hay white space narrativo o visual)

SCOPE CONTEXT:
  - Brand profile primary (de Paso 0)
  - Intensity modifiers
  - Archetype constraints (blocked + preferred_range)
```

### Paso 2 — Archetype selection

**Los 12 arquetipos de Jung** (reference completa en `skills/brand/references/archetype-guide.md` a escribir en Sprint 0):

| Archetype | Core desire | Strategy | Típico market fit |
|---|---|---|---|
| Innocent | Happiness, simplicity | Wholesomeness | Personal wellness, family products |
| Sage | Truth, wisdom | Expertise, guidance | Education, research, consulting |
| Explorer | Freedom, discovery | Adventure, frontier | Travel, outdoor, frontier tech |
| Outlaw | Revolution, disruption | Rule-breaking | Rebellious brands, challengers |
| Magician | Transformation, vision | Make dreams real | Visionary tech, deep transformation |
| Hero | Courage, mastery | Bold solutions | Fitness, productivity, champion against pain |
| Lover | Intimacy, passion | Beauty, connection | Lifestyle, luxury, relationships |
| Jester | Joy, fun | Levity, play | Entertainment, casual consumer |
| Everyman | Belonging, connection | Relatable, down-to-earth | Mass consumer, accessible |
| Caregiver | Service, protection | Nurture, support | Healthcare, nonprofit, kids |
| Ruler | Control, order | Authority, premium | Enterprise, luxury, financial |
| Creator | Self-expression, innovation | Build, craft | Design tools, creative platforms |

**Algoritmo de selección** (pseudocódigo):

```
def select_archetype(context):
    candidates = all_12_archetypes
    
    # Paso A: eliminar blocked por scope
    candidates = [a for a in candidates if a not in scope.archetype_constraints.blocked]
    
    # Paso B: score cada candidato contra múltiples factores
    scores = {}
    for archetype in candidates:
        score = 0
        # Factor 1: fit con founder profile (si existe)
        if profile:
            score += fit_with_profile(archetype, profile) * 0.35
        
        # Factor 2: fit con positioning (diferenciador + target)
        score += fit_with_positioning(archetype, context) * 0.35
        
        # Factor 3: diferenciación vs mood de mercado
        # Si mercado es "corporate/sage" dominant, Sage scores lower (no diferencia)
        # Ruler o Hero scoreen higher (diferenciación)
        score += differentiation_from_market(archetype, context.market_mood) * 0.20
        
        # Factor 4: preferred_range bonus
        if archetype in scope.archetype_constraints.preferred_range:
            score += 0.10
        
        scores[archetype] = score
    
    # Paso C: top 3 se consideran
    top_3 = sorted(scores.items(), key=lambda x: -x[1])[:3]
    
    # Paso D: return primary + 2 alternatives para trazabilidad
    return {
        "chosen": top_3[0][0],
        "rationale": build_rationale(top_3[0][0], context),
        "alternatives": [
            {"name": top_3[1][0], "reason_rejected": explain_why_not(top_3[1][0], top_3[0][0])},
            {"name": top_3[2][0], "reason_rejected": explain_why_not(top_3[2][0], top_3[0][0])}
        ]
    }
```

**Funciones de fit** (a implementar en SKILL.md — son Claude reasoning guiado por tablas en references):

- `fit_with_profile(archetype, profile)`: considera risk_tolerance, personality traits inferibles, declared values. Tabla de compatibilidad.
- `fit_with_positioning(archetype, context)`: considera category (fintech is often Ruler/Sage), differentiator tone, target audience culture.
- `differentiation_from_market(archetype, market_mood)`: Inverso del matching — queremos diferenciación. Si mercado es 80% Sage y candidate es Sage, diferenciación = baja. Si candidate es Ruler (adjacent pero distinct), diferenciación = alta.

### Paso 3 — Voice attributes

Basado en archetype + `scope.intensity_modifiers.verbal_register`.

**Base defaults por archetype** (tabla en reference):

| Archetype | Voice defaults |
|---|---|
| Sage | claro, autorizante, medido, pedagógico, preciso |
| Ruler | autorizante, confiado, premium, exclusivo, cálido pero formal |
| Hero | determinado, motivacional, directo, fuerte, orientado a acción |
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

| Register | Effect on voice |
|---|---|
| `formal-professional` | Remueve adjetivos como "irónico, playful, visceral". Agrega "medido, credible, profesional" |
| `professional-warm` | Balance — mantiene personality del archetype pero softens extremes |
| `casual-friendly` | Permite "directo, sincero, humano" — típico de SaaS SMB |
| `playful-bold` | Amplifica elementos lúdicos del archetype. Consumer apps. |
| `expressive-raw` | Permite "visceral, crudo, emocional" — creators y movements |

**Output por voice attribute**:
```json
{
  "attribute": "claro",
  "definition": "lenguaje directo, sin jargon opaco, accesible al lector no-experto sin condescender",
  "do_examples": [
    "Este análisis toma 40 horas. Auren lo hace en 2.",
    "Recomendado cuando tu team revisa >20 auditorías/trimestre."
  ],
  "dont_examples": [
    "Nuestra solución innovadora aprovecha sinergias disruptivas...",
    "Leveraging cutting-edge AI paradigms..."
  ]
}
```

Cada voice attribute se acompaña de do/don'ts concretos. Estos sirven de referencia para el Verbal dept cuando genera copy.

### Paso 4 — Brand values

3-5 values. Cada uno con:
- Name (sustantivo)
- Definition (qué significa en contexto de esta marca)
- Evidence source (de dónde sale — profile.motivation, validation insight, archetype default)
- Rationale

Ejemplo:
```json
{
  "value": "Rigor",
  "definition": "Cada claim respaldado por evidence o cuantificación. No hype sin data.",
  "evidence_source": "profile.background (ex-corporate analytical) + validation.problem.evidence (target audience = compliance officers que viven con audits)",
  "rationale": "El target desconfía profesionalmente de overclaims. Rigor es tanto un value del founder como un imperativo del mercado."
}
```

### Paso 5 — Brand promise

Formula: "Para [target], [nombre/categoría] que [diferenciador principal]."

Ejemplo: "Para compliance officers de fintechs LATAM, Auren es la plataforma que reduce auditorías regulatorias de 40h a 2h sin sacrificar rigor."

### Paso 6 — Positioning statement

Expansión del brand promise con más context:

Formula: "Para [target específico], [product name] es [categoría] que [diferenciador principal] porque [reason to believe]. Unlike [alternative approach o incumbent], [what we do uniquely]."

Ejemplo:
"Para compliance officers de fintechs seed-Series A en MX, CO, AR, Auren es la plataforma de auditorías regulatorias que reduce 40 horas de trabajo manual en 2 horas supervisadas, porque automatiza la colección y análisis de evidencia mientras preserva el control humano sobre conclusiones. Unlike soluciones enterprise como Workiva (diseñadas para Fortune 500 con pricing $50K+/año) o hojas de Excel custom, Auren está construida específicamente para el regime regulatorio LATAM (AFIP, SAT, DIAN) con pricing accesible a fintechs en fases tempranas."

### Paso 7 — Target audience refinement

Del Problem dept obtenemos targets genéricos. Strategy los refina para brand/marketing purposes:

```json
{
  "primary": {
    "description": "Compliance officers de fintechs seed-Series A en MX, CO, AR",
    "psychographics": "Ex-big4 auditors o ex-corporate, detallistas, cautelosos con tech but open si confiable, frustrados con herramientas enterprise overkill",
    "channels_preferred": ["LinkedIn Groups", "Fintech conferences LATAM (Money20/20, Finnosummit)", "Podcasts de compliance"],
    "pain_narrative": "'Me pagan bien pero mi vida es revisar spreadsheets hasta las 11pm'"
  },
  "secondary": {
    "description": "CTOs de fintechs early-stage que supervisan compliance",
    "psychographics": "Builders frustrados con tener que navegar regulatory, quieren tools que hagan compliance 'tractable'",
    "channels_preferred": ["Dev Twitter (fintech niche)", "Indie Hackers", "LinkedIn"]
  }
}
```

Esta información la usa Verbal para adaptar copy a cada audience segment.

## 4.4 Tools

**Ninguno externo**. Solo:
- Engram retrieval (del scope, validation, profile)
- Claude reasoning

**Justificación**: Strategy es decisión pura. Variance externa (APIs que devuelven cosas distintas cada vez) contaminaría decisiones que deben ser determinísticas dado el input.

## 4.5 Output schema completo

```json
{
  "schema_version": "1.0",
  "status": "ok",
  "department": "strategy",
  "scope_ref": "brand/{slug}/scope",
  "archetype": {
    "chosen": "Sage",
    "rationale": "Founder es ex-corporate analytical con risk_tolerance low + idea resuelve complejidad regulatoria = posicionamiento natural de guía experto. Descarté Ruler porque competidores enterprise (Workiva, MetricStream) ya ocupan autoridad corporate serio — Sage diferencia con calidad pedagógica que enterprise no entrega. Descarté Hero porque el founder profile (cauteloso, analítico) no sostiene el archetype Hero sin sonar falso.",
    "considered_alternatives": [
      {
        "name": "Ruler",
        "reason_rejected": "Mercado ya lo ocupa. Auren no puede competir en autoridad institucional con Workiva; debe competir en claridad y accesibilidad."
      },
      {
        "name": "Hero",
        "reason_rejected": "Archetype requiere founder boldness y target aspiracional. Profile del founder es cauto/analítico. Target audience es cauta profesionalmente. Sage sostiene mejor."
      }
    ],
    "decided_without_profile": false
  },
  "voice_attributes": [
    {
      "attribute": "claro",
      "definition": "lenguaje directo, sin jargon opaco",
      "do_examples": ["Este análisis toma 40 horas. Auren lo hace en 2.", "..."],
      "dont_examples": ["Aprovechando sinergias disruptivas...", "..."]
    },
    {
      "attribute": "autorizante",
      "definition": "precisión sin arrogancia — muestra expertise sin condescender",
      "do_examples": [...],
      "dont_examples": [...]
    },
    {
      "attribute": "directo",
      "definition": "sentencias cortas, lead con claim, soporta con evidencia",
      "do_examples": [...],
      "dont_examples": [...]
    },
    {
      "attribute": "empático-técnico",
      "definition": "respeta la inteligencia del lector sin asumir jargon",
      "do_examples": [...],
      "dont_examples": [...]
    }
  ],
  "brand_values": [
    {
      "value": "Rigor",
      "definition": "...",
      "evidence_source": "...",
      "rationale": "..."
    },
    {
      "value": "Claridad",
      "definition": "...",
      "evidence_source": "...",
      "rationale": "..."
    },
    {
      "value": "Pragmatismo",
      "definition": "...",
      "evidence_source": "...",
      "rationale": "..."
    }
  ],
  "brand_promise": "Para compliance officers de fintechs LATAM, Auren es la plataforma que reduce auditorías regulatorias de 40h a 2h sin sacrificar rigor.",
  "positioning_statement": "Para compliance officers de fintechs seed-Series A en MX, CO, AR, Auren es la plataforma de auditorías regulatorias que reduce 40 horas de trabajo manual en 2 horas supervisadas, porque automatiza la colección y análisis de evidencia mientras preserva el control humano sobre conclusiones. Unlike soluciones enterprise como Workiva, Auren está construida específicamente para el regime regulatorio LATAM con pricing accesible a fintechs early-stage.",
  "target_audience_refined": {
    "primary": {...},
    "secondary": {...}
  },
  "evidence_trace": {
    "profile_fields_used": ["identity.professional_background", "skills.domain_expertise", "constraints.risk_tolerance", "motivation.primary_goal"],
    "validation_depts_used": ["problem", "market", "competitive", "bizmodel"],
    "scope_modifiers_applied": ["verbal_register:professional-warm", "archetype_constraints.preferred_range"]
  }
}
```

## 4.6 Persistencia

`brand/{slug}/strategy` en Engram. Topic key estable — upsert si re-run.

## 4.7 Reveal al user (post-Strategy)

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

¿OK para continuar o prefieres alternativa?
  [Enter para continuar | 'ruler' | 'hero' | 'otro']
```

En **fast mode**: skipea el prompt de confirmation y procede automáticamente.

## 4.8 Relación con otros deptos

**Verbal Identity consume**:
- `archetype` (para modulación de naming style preferred)
- `voice_attributes` (para aplicar en toda la generación de copy)
- `positioning_statement` (para hero headline, value props)
- `target_audience_refined` (para adaptar copy per segment)
- `brand_values` (para about section, manifesto-like content)

**Visual System consume**:
- `archetype` (seed primary para palette + typography era)
- `brand_values` (afecta visual principles — Rigor → whitespace generous; Pragmatismo → no ornamentation)

**Logo consume** (indirect — via Visual + Verbal):
- `archetype` vocabulary para prompt engineering
- `voice_attributes` para rationale del logo

**Activation consume**:
- Todo para coherence gates + brand book compilation

## 4.9 Failure modes específicos

### No se puede elegir archetype (todos blocked)
Raro pero posible si constraints son muy restrictivos.
- Acción: relajar constraints del scope, flag al user, re-intentar
- Si sigue fallando: escalate al user con opciones manuales

### Profile contradictorio con idea
Ej: Profile dice `risk_tolerance: low` pero la idea es blockchain/crypto (naturalmente Outlaw).
- Acción: flag en el envelope, elegir el archetype menos contradictorio (Sage para crypto que prioriza trust)
- Opcional: sugerir al user que su profile puede necesitar update si la idea refleja un shift

### Validation data insuficiente
Ej: Problem dept no tiene target audience bien definido.
- Acción: usar Market dept como fallback
- Flag en envelope: `"target_audience_inferred_from_market_dept"` (menos preciso)

## 4.10 SKILL.md a escribir en Sprint 0

`skills/brand/strategy/SKILL.md` — instrucciones completas para el sub-agente. Estructura esperada:

```
1. Identity (qué es este depto, rol)
2. Inputs (Engram queries + expected data)
3. Representation principles (cómo representar decisiones)
4. Process step-by-step (los 7 pasos)
5. Archetype selection algorithm (detallado)
6. Voice attribute synthesis (detallado)
7. Output assembly checklist
8. Persistence to Engram
9. Critical rules (no fabricación, evidence trace obligatorio, etc.)
```

## 4.11 Reference files a escribir en Sprint 0

- `skills/brand/strategy/references/data-schema.md` — schema completa del output
- `skills/brand/references/archetype-guide.md` — los 12 arquetipos expandidos con tablas de:
  - Voice defaults
  - Visual associations
  - Typography associations
  - Palette families
  - Positioning patterns típicos
  - Archetype compatibility matrix (cuáles combinan bien, cuáles no — para hybrids)
- `skills/brand/strategy/references/positioning-frameworks.md` — templates de positioning statements, ejemplos trabajados

## 4.12 Testing de Strategy

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos mínimos:

1. Input B2B SaaS + Sage-compatible profile → output Sage con confidence alta
2. Input consumer app + Explorer-compatible profile → output Explorer
3. Input con profile contradictorio → flagged, archetype ajustado conservadoramente
4. Input sin profile → `decided_without_profile: true`, archetype basado solo en idea
5. Mismo input, 2 runs → archetype consistent (misma decisión dado mismo input)
6. Voice attributes detectably derivadas del archetype + register

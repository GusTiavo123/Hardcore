# Idea Loop — Generación + Validación Iterativa

## Qué es esto

Un meta-orchestrator que genera, valida e itera sobre ideas de negocio automáticamente. Recibe un perfil de founder + un seed (tema, industria, problema o idea inicial) y ejecuta N ciclos de generación → validación → aprendizaje → decisión. Al final entrega un portfolio rankeado de ideas exploradas con el journey completo.

No reemplaza el pipeline de validación — lo usa como motor interno. Agrega dos capacidades nuevas encima: **generación de ideas** y **decisión entre iteraciones**.

---

## Arquitectura

```
┌──────────────────────────────────────────────────────────────────┐
│                      META-ORCHESTRATOR                           │
│                                                                  │
│  ┌──────────┐    ┌──────────────┐    ┌──────────────────────┐   │
│  │ FOUNDER  │───▶│    IDEA      │───▶│  VALIDATION PIPELINE │   │
│  │ PROFILE  │    │  GENERATOR   │    │  (existing 6-dept)   │   │
│  └──────────┘    └──────────────┘    └──────────┬───────────┘   │
│                         ▲                       │               │
│                         │                       ▼               │
│                  ┌──────┴───────┐    ┌──────────────────────┐   │
│                  │   DECISION   │◀───│     PORTFOLIO        │   │
│                  │    ENGINE    │───▶│     TRACKER          │   │
│                  └──────────────┘    └──────────────────────┘   │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

4 componentes nuevos:
1. **Founder Profile** — contexto persistente que ancla toda generación
2. **Idea Generator** — produce ideas a partir de señales reales + constraints
3. **Decision Engine** — decide qué hacer después de cada validación
4. **Portfolio Tracker** — acumula hallazgos, anti-patrones y candidatos

El pipeline de validación existente (hc-orchestrator + 6 departamentos) se usa tal cual, siempre en fast mode.

---

## Input del Loop

### Founder Profile (obligatorio, una sola vez)

```json
{
  "founder_profile": {
    "skills": ["desarrollo web full-stack", "marketing digital"],
    "domain_expertise": ["e-commerce", "fintech LATAM"],
    "geography": "Argentina, operación en LATAM",
    "capital": "bootstrap | pre-seed ($10-50K) | seed ($50-500K)",
    "time": "full-time | part-time | side-project",
    "risk_tolerance": "conservative | moderate | aggressive",
    "network": ["contactos en joyerías Bolivia", "comunidad dev Argentina"],
    "hard_no": ["nada que requiera licencia médica", "no crypto"],
    "interests": ["arbitraje regional", "herramientas para PyMEs"]
  }
}
```

**Por qué esto es obligatorio:** Sin founder profile, el sistema optimiza ideas en abstracto. Con él, filtra ideas que el founder no puede ejecutar y prioriza las que aprovechan sus ventajas. Un ex-banker validando fintech ≠ un dev validando fintech — el perfil de riesgo, el GTM y la factibilidad de ejecución son completamente distintos.

**Campos críticos:**
- `hard_no` — elimina ramas enteras del árbol de exploración (nunca generar ideas que toquen estos temas)
- `skills` + `domain_expertise` — sesga la generación hacia ideas donde el founder tiene unfair advantage
- `capital` — filtra ideas que requieren más capital del disponible (el meta-orchestrator puede inferir esto de los unit economics del BizModel)
- `geography` — ancla búsquedas y market sizing a mercados reales

### Loop Config

```json
{
  "seed": "herramientas para joyeros independientes en LATAM",
  "max_iterations": 5,
  "target": {
    "min_score": 70,
    "min_confidence": "medium",
    "verdict": "GO"
  },
  "exploration_budget": 0.3,
  "mode": "fast"
}
```

- `seed` — punto de partida. Puede ser una industria, un problema, una idea concreta, o vacío (el sistema genera desde el founder profile)
- `max_iterations` — máximo de ciclos completos de validación
- `target` — cuándo considerar que una idea es "suficientemente buena"
- `exploration_budget` — fracción de iteraciones dedicadas a explorar direcciones nuevas vs refinar (0.3 = al menos 1 de cada 3-4 iteraciones es exploración pura)

---

## El Loop — Ciclo por Iteración

```
ITERATION N:
│
├─ 1. CONTEXT ASSEMBLY
│     Leer: founder_profile + portfolio_state + hallazgos acumulados
│
├─ 2. STRATEGY SELECTION (Decision Engine)
│     Decidir: ¿qué tipo de idea generar esta iteración?
│     Output: strategy + inputs para el generator
│
├─ 3. IDEA GENERATION
│     Producir 1 idea concreta basada en la strategy
│     Output: idea text (en lenguaje natural, como si la dijera un founder)
│
├─ 4. VALIDATION
│     Ejecutar pipeline completo (fast mode) con la idea generada
│     Output: verdict + scores + data completa
│
├─ 5. LEARNING EXTRACTION
│     Extraer: qué aprendimos que no sabíamos antes
│     Output: hallazgos, anti-patrones, señales prometedoras
│
├─ 6. PORTFOLIO UPDATE
│     Agregar idea al portfolio, actualizar rankings, acumular conocimiento
│
├─ 7. STOP CHECK
│     ¿Alcanzamos el target? ¿Convergimos? ¿Agotamos iteraciones?
│     Si no → volver a 1
│
└─ 8. FINAL REPORT
      Presentar portfolio completo rankeado + journey + recomendación
```

---

## Componente 1: Idea Generator

### Estrategias de Generación

El generator no inventa ideas de la nada. Siempre parte de **señales reales** encontradas en iteraciones anteriores o en el seed. Tiene 5 estrategias:

| Strategy | Cuándo se usa | Input | Output |
|----------|--------------|-------|--------|
| **SEED** | Iteración 1, o cuando se agota un branch | `seed` + `founder_profile` | Idea inicial anclada al seed y al founder |
| **PIVOT** | Después de PIVOT con suggestions | `pivot_suggestions[].revalidation_idea` más prometedor | Idea derivada del pivot suggestion |
| **DERIVE** | Después de NO-GO o PIVOT sin suggestions fuertes | `market_gaps[]` + `early_adopters[]` + `failed_competitors[]` acumulados | Idea nueva sintetizada de hallazgos cross-iteración |
| **REFINE** | Después de PIVOT con score alto (60-69) | Idea anterior + `key_concerns` + `score_reasoning` | Misma idea modificada para atacar las debilidades |
| **EXPLORE** | Forzado por exploration_budget, o después de 2+ NO-GOs | `founder_profile` + `anti_patterns` acumulados | Idea en dirección completamente nueva |

### Cómo genera cada estrategia

**SEED:**
```
Dado el perfil del founder ({skills}, {domain_expertise}, {geography})
y el tema seed "{seed}",
genera UNA idea de negocio concreta que:
- El founder pueda ejecutar con sus skills y capital ({capital})
- Opera en {geography}
- No toca: {hard_no}
- Aprovecha: {network} si es relevante

La idea debe ser específica: qué producto/servicio, para quién, cómo genera dinero.
NO debe ser genérica ("una plataforma para...") sino concreta ("venta de X a Y mediante Z").
```

**PIVOT:**
```
La validación anterior de "{idea}" resultó en PIVOT ({score}/100).
El pipeline sugirió este pivot: "{revalidation_idea}"

Reformulá esta sugerencia como una idea de negocio concreta, manteniendo
lo que funcionó ({key_strengths}) y evitando lo que falló ({key_concerns}).
Respetá los constraints del founder: {hard_no}, {capital}, {geography}.
```

**DERIVE:**
```
En las últimas {N} validaciones descubrimos:
- Market gaps: {accumulated_gaps}
- Early adopters con demanda: {accumulated_early_adopters}
- Competidores que fallaron por: {accumulated_failure_patterns}
- Anti-patrones a evitar: {anti_patterns}

Genera UNA idea nueva que:
- Ataque al menos 1 market gap real encontrado
- Apunte a un early adopter segment identificado
- Evite las razones de fracaso de competidores anteriores
- El founder pueda ejecutar ({skills}, {capital}, {geography})
```

**REFINE:**
```
La idea "{idea}" sacó {score}/100 (PIVOT).
Las principales debilidades fueron:
{key_concerns con score_reasoning específico}

El departamento de Risk identificó estos killers: {top_3_killers}
El BizModel flag: {bizmodel_flags}

Modificá la idea para atacar estas debilidades específicas.
Podés: cambiar el target, reducir el scope, modificar el modelo de revenue,
eliminar el componente más riesgoso, o cambiar la geografía.
NO cambies la esencia — refiná, no pivotees.
```

**EXPLORE:**
```
Las direcciones ya exploradas fueron: {domains_exhausted}
Los anti-patrones a evitar: {anti_patterns}

Genera UNA idea en una dirección DIFERENTE a todo lo explorado antes.
Basate en el perfil del founder ({skills}, {domain_expertise}, {interests})
para encontrar un ángulo completamente distinto.

Constraints: {hard_no}, {capital}, {geography}.

PROHIBIDO: variaciones de ideas ya validadas. Debe ser un cambio de dominio o problema.
```

### Anti-Gaming: Separación Generator / Validator

**Regla crítica:** El Idea Generator NO ve los scoring rubrics. No sabe que "complaint volume" o "paid alternatives" son sub-dimensiones. Si los ve, aprende a generar ideas que maximizan esas métricas en vez de generar buenos negocios.

Implementación:
- El Generator recibe hallazgos en **lenguaje natural** (gaps, concerns, strengths), nunca scores numéricos crudos ni nombres de sub-dimensiones
- El Generator recibe el `revalidation_idea` pero no el `score_reasoning` detallado del departamento
- El único número que ve es el score total y el verdict (para saber si fue GO/PIVOT/NO-GO)
- Los inputs del Generator vienen filtrados por el Decision Engine, que sí tiene acceso completo

**Excepción:** REFINE sí recibe `key_concerns` detallados porque necesita saber qué arreglar. Pero no recibe los rubrics — recibe las observaciones ("regulación en LATAM es fragmentada") no las métricas ("regulatory_legal: 5/25").

---

## Componente 2: Decision Engine

### Lógica de Decisión Post-Validación

```
DESPUÉS DE CADA VALIDACIÓN:

1. ¿Es la mejor idea hasta ahora?
   → Si sí, actualizar best_candidate en portfolio

2. ¿Alcanzó el target (score ≥ target, confidence ≥ min, verdict = GO)?
   → Si sí, marcar como target_reached (pero NO parar automáticamente — seguir buscando
     a menos que se agoten iteraciones)

3. ¿Toca exploración forzada?
   → Si iterations_since_last_explore ≥ ceil(1 / exploration_budget), forzar EXPLORE

4. Sino, elegir strategy basada en el resultado:

   IF verdict == "GO":
     IF score >= target + 5:
       → EXPLORE (ya tenemos candidata fuerte, buscar alternativas)
     ELSE:
       → REFINE (intentar subir el score de la candidata)

   IF verdict == "PIVOT":
     IF tiene pivot_suggestions con revalidation_idea:
       → Rankear suggestions por: cuáles atacan las concerns más pesadas
       → PIVOT (con la suggestion top)
     ELIF score >= 55:
       → REFINE (la idea tiene potencial, pulir)
     ELSE:
       → DERIVE (combinar hallazgos acumulados en algo nuevo)

   IF verdict == "NO-GO":
     IF knockout == "problem":
       → El dolor no existe. No refinar.
       → Si hay market_gaps interesantes → DERIVE
       → Sino → EXPLORE (cambiar de dominio)
     IF knockout == "market":
       → Dolor real pero mercado chico
       → DERIVE (buscar mercado más grande con dolor similar)
     IF knockout == "risk":
       → Idea viable pero ejecutarla es suicida
       → REFINE si se puede quitar el componente riesgoso
       → EXPLORE si el riesgo es inherente al dominio
     IF knockout == "multi-weakness":
       → Idea fundamentalmente débil → EXPLORE

5. Verificar que la strategy elegida no repite un patrón agotado:
   → Si la misma dirección ya tuvo 2 intentos sin mejora (±3 pts), marcar como
     domain_exhausted y forzar EXPLORE
```

### Selección de Pivot Suggestion

Cuando hay múltiples `pivot_suggestions`, rankear por:

1. **Feasibility score** — ¿el founder puede ejecutarlo?
   - Matchear `revalidation_idea` contra `founder_profile.skills` y `capital`
   - Descartar suggestions que violan `hard_no`

2. **Concern coverage** — ¿cuántas key_concerns ataca?
   - Parsear `addresses` field de cada suggestion
   - Priorizar la que ataca la concern de mayor peso (el departamento con score más bajo)

3. **Novelty** — ¿es suficientemente diferente de lo ya explorado?
   - Comparar con `ideas_explored[].slug` y `domains_exhausted`
   - Penalizar suggestions que son variaciones menores de ideas ya intentadas

---

## Componente 3: Portfolio Tracker

### Portfolio State (persistido en Engram entre iteraciones)

```yaml
loop_id: "loop-{seed-slug}-{date}"
founder_profile: { ... }  # snapshot para referencia
seed: "..."
config:
  max_iterations: 5
  target: { min_score: 70, min_confidence: "medium", verdict: "GO" }
  exploration_budget: 0.3
current_iteration: 3
target_reached: false

ideas:
  - iteration: 1
    slug: "joyas-oro-bolivia-argentina"
    idea: "Importación de joyas de oro 18k desde Bolivia para reventa en Argentina"
    strategy: SEED
    verdict: NO-GO
    score: 28
    knockout: "problem"
    key_learning: "El oro tiene precio spot internacional, no hay arbitraje significativo"
    promising_signals: []
    anti_patterns_found: ["arbitraje de commodities con precio spot global"]

  - iteration: 2
    slug: "marketplace-joyeros-latam"
    idea: "Marketplace B2B para joyeros independientes en LATAM"
    strategy: DERIVE
    verdict: PIVOT
    score: 62
    knockout: null
    key_learning: "Mercado fragmentado de $2B, 80% informal. Gap: no hay herramientas digitales para joyeros artesanales"
    promising_signals:
      - "45K joyeros independientes en Argentina (CAME census)"
      - "0 plataformas B2B para joyería artesanal en español"
    anti_patterns_found: []
    pivot_suggestions_available:
      - "Plataforma de gestión de inventario + punto de venta para joyerías"
      - "Marketplace de insumos (piedras, oro, herramientas) para joyeros"

  - iteration: 3
    slug: "pos-joyerias-independientes"
    idea: "Software de punto de venta + inventario especializado para joyerías"
    strategy: PIVOT
    verdict: GO
    score: 73
    knockout: null
    key_learning: "Vertical SaaS para joyerías no existe. Usan Excel o sistemas genéricos."

best_candidate:
  slug: "pos-joyerias-independientes"
  score: 73
  iteration: 3

accumulated_knowledge:
  market_gaps:
    - gap: "No hay herramientas digitales en español para joyeros artesanales"
      source_iteration: 2
      times_confirmed: 1
    - gap: "Joyeros usan Excel para inventario de piezas únicas"
      source_iteration: 3
      times_confirmed: 2
  early_adopters:
    - segment: "Joyeros independientes en Buenos Aires (Libertad/Centro)"
      channel: "Cámara Argentina de Joyería"
      source_iteration: 2
  failure_patterns:
    - pattern: "Arbitraje de commodities con precio spot global no funciona"
      source_iteration: 1
  anti_patterns:
    - "Arbitraje de commodities con precio spot internacional"
    - "Marketplaces genéricos sin diferenciación vertical"
  domains_exhausted:
    - "arbitraje oro Bolivia-Argentina"
```

### Qué se acumula y qué no

**Se acumula (cross-iteración):**
- `market_gaps` con `times_confirmed` (si el mismo gap aparece en múltiples validaciones, es más fuerte)
- `early_adopters` con channels concretos
- `failure_patterns` y `anti_patterns`
- `domains_exhausted` (para evitar repetir)
- `promising_signals` con conteo de confirmaciones

**No se acumula (muere con la iteración):**
- Scores numéricos crudos (solo el Generator no los ve; el Decision Engine sí)
- Evidence URLs (ya están en los outputs del pipeline)
- Sub-scores por departamento

### Engram Persistence

```
topic_key: "loop/{loop_id}/state"
type: "config"

topic_key: "loop/{loop_id}/iteration-{N}"
type: "discovery"

topic_key: "loop/{loop_id}/portfolio"
type: "decision"
```

---

## Componente 4: Stopping Criteria

El loop para cuando CUALQUIERA de estas condiciones se cumple:

| Condición | Detalle |
|-----------|---------|
| **Target reached** | Se encontró una idea con `verdict == target.verdict` AND `score >= target.min_score` AND `confidence >= target.min_confidence` |
| **Iterations exhausted** | `current_iteration >= max_iterations` |
| **Convergence detected** | Las últimas 2 iteraciones en la misma dirección produjeron scores con delta ≤ 3 puntos (no hay más jugo) |
| **All directions exhausted** | `domains_exhausted` cubre todas las ramas razonables dado el `founder_profile` |
| **User abort** | El founder decide parar (checkpoint opcional entre iteraciones) |

**Cuando para, el meta-orchestrator entrega:**

1. **Best candidate** — la idea con mejor score (o el mejor GO si hay varios)
2. **Portfolio completo** — todas las ideas exploradas, ordenadas por score
3. **Journey narrative** — cómo llegó de la iteración 1 a la candidata final, qué aprendió en cada paso
4. **Accumulated knowledge** — market gaps confirmados, early adopters, anti-patrones
5. **Recommended next steps** — del best_candidate's validation output
6. **Unexplored directions** — si quedaron ramas interesantes sin explorar

---

## Output Final

### Para el Founder

```markdown
# Loop Report: {seed}
## {iterations_completed} iteraciones | Best: {best_score}/100 ({best_verdict})

### Candidata Principal
**{best_idea}**
Verdict: {verdict} | Score: {score} | Confidence: {confidence}

{executive_summary de la validación}

### El Journey
| # | Idea | Strategy | Score | Verdict | Key Learning |
|---|------|----------|-------|---------|--------------|
| 1 | Joyas oro Bolivia→Argentina | SEED | 28 | NO-GO | No hay arbitraje real |
| 2 | Marketplace B2B joyeros | DERIVE | 62 | PIVOT | Mercado fragmentado, sin tools |
| 3 | POS para joyerías | PIVOT | 73 | GO | Vertical SaaS inexistente |

### Conocimiento Acumulado
**Market gaps confirmados:**
- No hay herramientas digitales en español para joyeros (confirmado 2x)

**Anti-patrones:**
- Arbitraje de commodities con precio spot global

### Próximos Pasos
{next_steps + validation_experiments del best_candidate}

### Direcciones No Exploradas
- Marketplace de insumos para joyeros (sugerido en iteración 2, no validado)
```

---

## Integración con Pipeline Existente

### Qué cambia en el pipeline actual

**Nada.** El pipeline de validación se usa tal cual. El meta-orchestrator lo invoca como una función:

```
input: idea text + slug + persistence_mode + detail_level
output: full validation envelope (verdict, scores, data, evidence)
```

El meta-orchestrator:
1. Genera la idea (texto libre)
2. Genera el slug
3. Llama al hc-orchestrator existente en fast mode
4. Recibe el output completo
5. Extrae hallazgos y decide

### Cambios necesarios en el pipeline

Ninguno estructural. Solo:
- El meta-orchestrator necesita leer los outputs completos de cada departamento (no solo el synthesis) para extraer market_gaps, early_adopters, etc.
- En mode `engram`, el meta-orchestrator persiste su propio state bajo `loop/` namespace (separado de `validation/`)

### DAG del Meta-Loop vs Pipeline

```
META-LOOP (nuevo):
  Loop iteration 1 → PIPELINE (existente, completo) → Learn → Decide
  Loop iteration 2 → PIPELINE (existente, completo) → Learn → Decide
  Loop iteration 3 → PIPELINE (existente, completo) → Learn → Decide
  ...
  → Final Report
```

El meta-orchestrator NO interfiere con el pipeline interno. No cambia scores, no modifica departamentos, no salta pasos. Usa el pipeline como black box y toma decisiones sobre qué idea alimentarle la próxima vez.

---

## Riesgos y Mitigaciones

| Riesgo | Mitigación |
|--------|------------|
| **Teaching to the test** — ideas que scorean bien pero no son buenos negocios | Generator no ve rubrics. Solo recibe hallazgos en lenguaje natural. Separación estricta. |
| **Hill-climbing local** — refinar forever sin explorar | `exploration_budget` fuerza EXPLORE cada N iteraciones. `domains_exhausted` previene loops. |
| **Convergencia prematura** — parar cuando hay mejores ideas sin explorar | Target reached no para el loop inmediatamente — sigue buscando hasta agotar iteraciones. |
| **Costo excesivo** — 5 iteraciones × 6 departamentos = 30 agent runs | Fast mode + concise detail. Considerar modo "screening" que solo corra Problem + Market antes del pipeline completo. |
| **Ideas genéricas** — "plataforma SaaS para X" repetitivo | El founder profile ancla las ideas. Los hallazgos reales las hacen específicas. La regla de no repetir domains_exhausted fuerza novedad. |
| **Pérdida de hallazgos valiosos** — un PIVOT score 55 puede tener descubrimientos más valiosos que un GO score 72 | Portfolio tracker acumula `promising_signals` y `market_gaps` con conteo de confirmaciones, independiente del score. |

---

## Screening Mode (optimización de costo)

Para reducir el costo de iteraciones exploratorias, el meta-orchestrator puede correr un **screening pass** antes del pipeline completo:

```
SCREENING (2 departamentos):
  Problem Validation → si score < 40 → skip, next iteration
  Market Sizing → si score < 40 → skip, next iteration
  Si ambos ≥ 40 → correr pipeline completo
```

Esto evita gastar 4 departamentos en ideas que van a ser NO-GO por Problem o Market knockout. El costo de screening es ~33% de una validación completa.

El screening solo se usa con strategies EXPLORE y DERIVE (ideas nuevas). PIVOT y REFINE ya vienen de ideas que pasaron Problem/Market, así que van directo al pipeline completo.

---

## Skill Structure

```
skills/
├── hc-meta/
│   └── SKILL.md              # Meta-orchestrator del loop
├── hc-idea-generator/
│   └── SKILL.md              # Generación de ideas (5 strategies)
├── hc-decision-engine/
│   └── SKILL.md              # Lógica de decisión post-validación
├── _shared/
│   ├── founder-profile.md    # Schema del founder profile
│   ├── portfolio-contract.md # Schema del portfolio state
│   └── ... (existing)
├── hc-orchestrator/           # Sin cambios
├── hc-problem/                # Sin cambios
├── hc-market/                 # Sin cambios
├── hc-competitive/            # Sin cambios
├── hc-bizmodel/               # Sin cambios
├── hc-risk/                   # Sin cambios
└── hc-synthesis/              # Sin cambios
```

---

## Ejemplo de Flujo Completo

**Input:**
```
Founder: dev full-stack, expertise en e-commerce, basado en Argentina,
         bootstrap ($5K), side-project, contactos joyeros Bolivia
Seed: "oportunidad con joyería y oro entre Bolivia y Argentina"
Iterations: 5, Target: GO ≥ 70
```

**Iteración 1 (SEED):**
- Idea: "Importar joyas de oro 18k desde Bolivia para revender en Argentina"
- Resultado: NO-GO (28/100) — Problem knockout
- Learning: "No hay arbitraje real, el oro tiene precio spot global"
- Anti-pattern: "Arbitraje de commodities con precio spot"
- Decision: NO-GO por Problem → dolor no existe → DERIVE de hallazgos

**Iteración 2 (DERIVE):**
- Input: Market gaps encontrados = "80% joyeros LATAM son informales, sin herramientas digitales"
- Idea: "Marketplace B2B para joyeros independientes en LATAM"
- Resultado: PIVOT (62/100) — Risk 42, marketplace two-sided chicken-egg
- Learning: "45K joyeros independientes en Argentina, 0 plataformas en español"
- Pivot suggestion: "Software de gestión para joyerías en vez de marketplace"
- Decision: PIVOT con suggestion fuerte → PIVOT strategy

**Iteración 3 (PIVOT):**
- Input: revalidation_idea del pivot
- Idea: "POS + inventario especializado para joyerías independientes"
- Resultado: GO (73/100)
- Learning: "Vertical SaaS inexistente. Joyeros usan Excel. CAC bajo vía cámaras."
- Decision: GO alcanzó target (73 ≥ 70) → marcar best_candidate, seguir iterando

**Iteración 4 (EXPLORE — forzado por exploration_budget):**
- Input: founder profile + anti-patterns
- Idea: "Plataforma de e-commerce para joyería artesanal directa al consumidor"
- Resultado: PIVOT (58/100) — competidores fuertes (Etsy, MercadoLibre)
- Learning: "DTC joyería es competido pero hay gap en certificación de oro"
- Decision: Score menor que best_candidate, PIVOT sin suggestion fuerte → no perseguir

**Iteración 5 (REFINE del best_candidate):**
- Input: POS joyerías + concerns del GO (Risk = 48, churn concern)
- Idea: "POS + inventario para joyerías con módulo de certificación de oro integrado"
- Resultado: GO (76/100) — Risk mejoró por diferenciación defensible
- Learning: "Certificación de oro como moat reduce riesgo competitivo"
- Decision: Mejor score hasta ahora → nuevo best_candidate

**Output:**
- Best: "POS + inventario + certificación de oro para joyerías" — 76/100 GO
- Journey: 5 iteraciones, de arbitraje físico → marketplace → vertical SaaS → SaaS + moat
- Key insight: El founder empezó buscando arbitraje de commodities y terminó encontrando un vertical SaaS con moat regulatorio

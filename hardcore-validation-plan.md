# Idea Validation — Hardcore Agent Team
## Plan de Desarrollo: Sistema Multi-Agente para Validación de Ideas de Startup

---

## QUÉ ES ESTO

Un equipo de 6 agentes AI especializados que toman una idea de startup en texto libre y producen un veredicto claro (GO / NO-GO / PIVOT) con datos reales, razonamiento explícito y próximos pasos accionables.

Se basa en la arquitectura de [Agent Teams Lite](https://github.com/Gentleman-Programming/agent-teams-lite) (orquestación multi-agente) y [Engram](https://github.com/Gentleman-Programming/engram) (memoria persistente entre agentes y sesiones).

### Contexto futuro (no se implementa ahora)

Este agent team es un módulo del ecosistema **Hardcore** (Founder Operating System). Eventualmente se conectará con otros módulos (Idea Discovery, Deep Research, Product Definition, etc.) a través de Engram como bus de memoria compartida. Usa `project: "hardcore"` en Engram y el prefijo `validation/` en topic_key para namespacing dentro del proyecto compartido. **El scope de este plan es exclusivamente Idea Validation.**

---

## POR QUÉ ESTA ARQUITECTURA

### El mapping con Agent Teams Lite

Agent Teams Lite usa un orquestador delegate-only que lanza sub-agentes con contexto fresco para cada fase. Nuestro caso es estructuralmente idéntico:

| Concepto en SDD | Concepto en Idea Validation |
|---|---|
| Orquestador | Orchestrator (rutea entre departamentos) |
| Sub-agente (Explorer, Proposer, etc.) | Departamento (Problem, Market, etc.) |
| Artefacto (proposal.md, design.md) | Output estructurado JSON de cada dept |
| Change (`sdd/add-dark-mode/`) | Validación (`validation/mi-idea-saas/`) |
| DAG de fases | DAG de departamentos |
| Contrato de resultado | Output contract estandarizado |

Lo que cambia es el dominio. La mecánica (delegate-only, contexto fresco, Engram como memoria) es la misma.

### Qué tomamos de cada repo

**De Agent Teams Lite:**
- Patrón orquestador delegate-only
- Contrato de resultado estructurado (status, executive_summary, artifacts)
- Skills como archivos Markdown puros (zero dependencies)
- DAG de dependencias entre fases
- Archivos `_shared/` para convenciones DRY
- Política de persistencia pluggable (engram / file / none)

**De Engram:**
- MCP tools para persistencia (mem_save, mem_search, mem_get_observation, etc.)
- Progressive disclosure (search → timeline → get full content)
- Naming determinístico para artefactos
- Session lifecycle (mem_session_start → work → mem_session_summary → mem_session_end)
- topic_key para upserts (re-validar sin duplicar)
- Type enums válidos (decision, discovery, config, etc.)

### Adaptaciones al dominio (divergencias intencionales)

| Aspecto | ATL/Engram | Idea Validation | Razón |
|---|---|---|---|
| Output contract | `risks` field | `flags` field | Nuestros flags son alertas operativas; risk analysis es un departamento dedicado |
| Output contract | Sin `score` | Con `score` + `score_reasoning` | Necesitamos scoring para el weighted verdict |
| Persistence modes | 4 (engram/openspec/hybrid/none) | 3 (engram/file/none) | No necesitamos hybrid; `file` es openspec simplificado |
| Engram `type` | Usado tal cual | Mapeado: discovery/decision/config | Nuestros tipos originales no eran enums válidos de Engram |
| Engram `tags` | Disponible | No usado (no existe en la API) | Keywords embebidos en content para FTS5 search |
| Content format | `**What**/**Why**/**Where**/**Learned**` | `**What**/**Why**/**Where**/**Data**` | Adaptado al dominio de validación |

---

## ARQUITECTURA

### Estructura de Directorios

```
idea-validation/
├── README.md
├── LICENSE
│
├── skills/
│   ├── _shared/                         # Convenciones compartidas por todos los depts
│   │   ├── persistence-contract.md      # Reglas de persistencia (engram/file/none)
│   │   ├── engram-convention.md         # Naming, type mapping, session lifecycle
│   │   ├── scoring-convention.md        # Sub-dimensiones, pesos, knockouts
│   │   └── output-contract.md           # Contrato JSON que retorna cada dept
│   │
│   ├── hc-orchestrator/SKILL.md         # Orquestador (delegate-only)
│   │
│   ├── hc-problem/SKILL.md              # Dept 1: Problem Validation
│   ├── hc-market/SKILL.md               # Dept 2: Market Sizing
│   ├── hc-competitive/SKILL.md          # Dept 3: Competitive Intelligence
│   ├── hc-bizmodel/SKILL.md             # Dept 4: Business Model
│   ├── hc-risk/SKILL.md                 # Dept 5: Risk Assessment
│   └── hc-synthesis/SKILL.md            # Dept 6: GO/NO-GO Synthesis
│
├── examples/
│   ├── claude-code/CLAUDE.md            # Config para Claude Code
│   ├── opencode/opencode.json           # Config para OpenCode
│   └── cursor/.cursorrules              # Config para Cursor
│
└── scripts/
    └── install.sh                       # Instalador multi-tool
```

### El DAG de Departamentos

```
                    INPUT: idea (texto libre)
                           │
                           ▼
                   ┌───────────────┐
                   │   PROBLEM     │   Raíz. No depende de nada.
                   │  VALIDATION   │   Peso: 30%
                   └───────┬───────┘
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
     ┌────────────────┐      ┌──────────────────┐
     │  MARKET SIZING │      │  COMPETITIVE     │   PARALELO.
     │  Peso: 25%     │      │  INTELLIGENCE    │   Ambos dependen
     └────────┬───────┘      │  Peso: 15%       │   solo de Problem.
              │              └──────────┬───────┘
              └────────────┬────────────┘
                           │
                           ▼
                   ┌───────────────┐
                   │  BUSINESS     │   Depende de Market + Competitive.
                   │  MODEL        │   Necesita pricing benchmark y
                   │  Peso: 20%   │   market size para unit economics.
                   └───────┬───────┘
                           │
                           ▼
                   ┌───────────────┐
                   │    RISK       │   Depende de TODO lo anterior.
                   │  ASSESSMENT   │   Peso: 10% (poder real: veto
                   └───────┬───────┘   vía knockouts)
                           │
                           ▼
                   ┌───────────────┐
                   │   GO/NO-GO    │   Sintetiza todos los scores.
                   │   SYNTHESIS   │
                   └───────────────┘
                           │
                           ▼
                  OUTPUT: Veredicto + Report
```

Market y Competitive corren en paralelo porque son independientes entre sí — ambos solo necesitan el análisis del problema. Business Model necesita a ambos (pricing benchmark viene de Competitive, tamaño de oportunidad viene de Market).

### Flujo del Orquestador

```
USUARIO: "Validá esta idea: una plataforma de..."

ORQUESTADOR:
  1. Parsea la idea, genera slug (ej: "platform-freelance-contracts")

  2. Inicia sesión Engram:
     mem_session_start(id: "validation-{slug}-{date}", project: "hardcore")

  3. Busca en Engram: mem_search("validation/{slug}/report", project: "hardcore")
     → Si existe: "Ya validaste esto el 15/03. ¿Re-validar o ver resultados?"
     → Si no existe: arranca el DAG

  4. → Lanza sub-agente PROBLEM VALIDATION
     ← Recibe: {status: "ok", score: 78, executive_summary: "..."}
     → Persiste: mem_save(topic_key: "validation/{slug}/problem", type: "discovery")
     → Muestra resumen al usuario

  5. → Lanza MARKET SIZING ∥ COMPETITIVE INTEL (paralelo)
     ← Recibe ambos resultados
     → Persiste ambos (type: "discovery")
     → Muestra resumen consolidado

  6. → Lanza BUSINESS MODEL
     ← Lee de Engram: market data + competitive pricing
     → Persiste (type: "discovery")

  7. → Lanza RISK ASSESSMENT
     ← Lee de Engram: todo lo anterior
     → Persiste (type: "discovery")

  8. → Lanza SYNTHESIS
     ← Lee todos los scores y summaries
     → Calcula weighted score, aplica knockouts, emite veredicto
     → Persiste report final (type: "decision")

  9. → Presenta veredicto al usuario con evidencia
     → mem_session_summary(goal, accomplished, discoveries, next_steps)
     → mem_session_end()
```

**Human-in-the-loop** (configurable):
- Después de Problem Validation: "¿El problema está bien planteado?"
- Después de Market + Competitive: "¿Querés continuar sabiendo el landscape?"
- En modo "fast": ejecuta todo sin paradas intermedias.

---

## OUTPUT CONTRACT

Cada departamento retorna este envelope estandarizado (extiende el contrato de ATL con campos de dominio):

```json
{
  "status": "ok | warning | blocked | failed",
  "department": "problem | market | competitive | bizmodel | risk | synthesis",
  "executive_summary": "1-2 oraciones decision-grade para el orquestador",
  "detailed_report": "opcional — análisis extendido para detail_level deep",
  "score": 0-100,
  "score_reasoning": "breakdown por sub-dimensión con puntos (ver scoring-convention.md)",
  "data": {
    // Output estructurado específico del departamento
  },
  "evidence": [
    {
      "source": "url",
      "quote": "dato puntual",
      "reliability": "high | medium | low"
    }
  ],
  "artifacts": [
    {
      "name": "problem-analysis",
      "store": "engram",
      "ref": "observation-id o topic_key"
    }
  ],
  "flags": ["alertas operativas para el orquestador"],
  "next_recommended": ["market", "competitive"]
}
```

`executive_summary` es lo que el orquestador muestra al usuario entre fases. `score_reasoning` es un breakdown obligatorio de sub-dimensiones (no prosa vaga). `flags` son alertas operativas (no confundir con risk analysis — eso es un departamento dedicado).

---

## SCORING

### Diseño: Sub-dimensiones medibles

Cada score 0-100 es la **suma de sub-dimensiones ancladas a criterios observables y contables**. Esto reduce la varianza entre ejecuciones de ±10 puntos (con rúbricas vagas) a ±3-5 puntos (con sub-scores).

Ver `skills/_shared/scoring-convention.md` para las rúbricas completas de cada departamento.

### Resumen de sub-dimensiones

| Departamento | Sub-dimensiones (puntos cada una) | Total |
|---|---|---|
| Problem | Volumen quejas (20) + Recencia (20) + Intensidad dolor (20) + Workarounds (20) + Alternativas pagas (20) | 100 |
| Market | Calidad data (25) + SOM (25) + CAGR (25) + Early adopters (25) | 100 |
| Competitive | Validación mercado (20) + Debilidad incumbente (20) + Gaps (20) + Pricing intel (20) + Failure intel (20) | 100 |
| BizModel | LTV/CAC (25) + Modelo validado (25) + Payback (25) + Pricing power (25) | 100 |
| Risk | Ejecución (25) + Regulatorio (25) + Timing (25) + Dependencias (25) | 100 |

### Pesos (validados por simulación)

| Departamento | Peso | Rationale |
|---|---|---|
| Problem | 30% | Fundación — si no hay dolor real, nada más importa |
| Market | 25% | Techo — define el upper bound de la oportunidad |
| Competitive | 15% | Subordinado a Problem + Market; landscape importa pero menos que los fundamentals |
| Business Model | 20% | Unit economics son make-or-break para sustentabilidad |
| Risk | 10% | Meta-análisis; su poder real es a través de knockouts, no del peso |

**Formula**: `weighted_score = (Problem × 0.30) + (Market × 0.25) + (Competitive × 0.15) + (BizModel × 0.20) + (Risk × 0.10)`

Pesos validados con simulación de 13 escenarios: 84.6% accuracy (vs 61.5% con pesos uniformes de 25/20/20/20/15).

### Reglas de decisión (con knockouts)

**NO-GO automático** (cualquiera de estos):
- `Problem < 40` — no hay evidencia de dolor real
- `Market < 40` — mercado demasiado chico o inexistente
- `Risk < 30` — riesgos críticos sin mitigación
- Dos o más scores `< 45` — múltiples fundamentals débiles

**GO** (TODOS deben cumplirse):
- `weighted_score >= 70`
- `Problem >= 60` — el problema debe ser al menos moderado
- Todos los demás scores `>= 45`

**PIVOT** (todo lo que no es GO ni NO-GO):
- Se generan 2-3 direcciones alternativas
- Se identifican los scores que bloquean el GO

---

## DETALLE POR DEPARTAMENTO

### Dept 1: Problem Validation (hc-problem)

**Rol**: ¿El problema existe de verdad? ¿Es lo suficientemente doloroso para que alguien pague?

**Proceso**:
1. Extraer el problema implícito de la descripción de la idea
2. Formular 3-5 queries de búsqueda para evidencia de dolor:
   - `"{problema} frustrating" site:reddit.com`
   - `"{problema} alternative" site:g2.com OR site:capterra.com`
   - `"{problema}" complaint OR review OR "hate"`
3. Contar y clasificar resultados según las 5 sub-dimensiones (ver scoring-convention.md):
   - Complaint Volume: cuántos threads únicos
   - Complaint Recency: % de los últimos 24 meses
   - Pain Intensity: markers de urgencia/desesperación
   - Workaround Evidence: workarounds distintos descritos
   - Existing Paid Alternatives: productos pagos encontrados
4. Calcular score como suma de sub-dimensiones

**Output `data`**:
```json
{
  "problem_exists": true,
  "problem_statement": "descripción refinada del problema",
  "pain_intensity": "critical | high | medium | low",
  "current_solutions": [
    {"solution": "Excel/Google Sheets manual", "satisfaction": "low"}
  ],
  "evidence_summary": "X quejas encontradas en Reddit/foros, patrón: ...",
  "sub_scores": {
    "complaint_volume": 12,
    "complaint_recency": 16,
    "pain_intensity": 14,
    "workaround_evidence": 15,
    "paid_alternatives": 15
  },
  "problem_score": 72
}
```

---

### Dept 2: Market Sizing (hc-market)

**Rol**: ¿Cuánto vale esta oportunidad en dinero?

**Input adicional**: Lee de Engram el output de Problem Validation.

**Proceso**:
1. `mem_search("validation/{slug}/problem", project: "hardcore")` → `mem_get_observation(id)` → recuperar contexto
2. Buscar reportes de mercado:
   - `"{industria} market size 2024 2025"`
   - `"{segmento} TAM SAM report"`
   - `"{industria} growth rate forecast"`
3. Evaluar según 4 sub-dimensiones (ver scoring-convention.md):
   - Data Availability: calidad y cantidad de fuentes
   - Market Scale: SOM calculado
   - Growth Trajectory: CAGR encontrado
   - Early Adopter Identifiability: segmentos con canal concreto
4. Calcular score como suma de sub-dimensiones

**Output `data`**:
```json
{
  "tam": {"value": 50000000000, "currency": "USD", "source": "Grand View Research 2024"},
  "sam": {"value": 5000000000, "currency": "USD", "source": "cálculo basado en..."},
  "som": {"value": 50000000, "currency": "USD", "source": "estimación: X% de SAM"},
  "growth_rate": "12% anual",
  "market_stage": "growing",
  "early_adopters": {
    "segment": "freelancers tech con >$100k ingresos anuales",
    "estimated_size": 500000,
    "characteristics": ["tech-savvy", "pain-aware", "willingness to pay"],
    "reachable_channels": [{"name": "r/freelance", "members": 250000}]
  },
  "sub_scores": {
    "data_availability": 18,
    "market_scale": 19,
    "growth_trajectory": 13,
    "early_adopter_identifiability": 18
  },
  "market_score": 68
}
```

---

### Dept 3: Competitive Intelligence (hc-competitive)

**Rol**: ¿Quién más resuelve esto? ¿Dónde están los gaps?

**Input adicional**: Lee de Engram el output de Problem Validation.

**Proceso**:
1. `mem_search("validation/{slug}/problem", project: "hardcore")` → `mem_get_observation(id)` → recuperar contexto
2. Buscar competidores directos e indirectos en G2, Capterra, ProductHunt, Crunchbase
3. Analizar reviews negativas para gaps
4. Buscar competidores muertos en Failory, CB Insights
5. Evaluar según 5 sub-dimensiones (ver scoring-convention.md):
   - Market Validation Signal: cantidad de competidores (más = mercado validado)
   - Incumbent Weakness: fuerza del más fuerte (INVERTIDO: más débil = más oportunidad)
   - Market Gap Evidence: gaps recurrentes en reviews
   - Pricing Intelligence: pricing recuperable
   - Failure Intelligence: post-mortems y churn signals
6. Calcular score como suma de sub-dimensiones

**Output `data`**:
```json
{
  "direct_competitors": [
    {
      "name": "Competidor Real",
      "url": "https://...",
      "pricing": {"model": "subscription", "range": "$29-99/mo"},
      "strengths": ["..."],
      "weaknesses": ["..."],
      "estimated_size": "Series A, ~$5M ARR"
    }
  ],
  "indirect_competitors": [],
  "failed_competitors": [
    {"name": "...", "reason_failed": "...", "source": "url"}
  ],
  "market_gaps": ["gap 1", "gap 2"],
  "pricing_benchmark": {"low": 19, "mid": 49, "high": 149, "currency": "USD/mo"},
  "sub_scores": {
    "market_validation": 14,
    "incumbent_weakness": 11,
    "gap_evidence": 15,
    "pricing_intelligence": 13,
    "failure_intelligence": 12
  },
  "competitive_score": 65
}
```

---

### Dept 4: Business Model (hc-bizmodel)

**Rol**: ¿Los números cierran?

**Input adicional**: Lee de Engram Market Sizing + Competitive Intelligence.

**Proceso**:
1. `mem_search("validation/{slug}/market")` + `mem_search("validation/{slug}/competitive")` → `mem_get_observation(id)` para cada uno
2. Calcular unit economics basados en pricing benchmark + benchmarks de industria
3. Evaluar según 4 sub-dimensiones (ver scoring-convention.md):
   - LTV/CAC Ratio: calculado con benchmarks
   - Revenue Model Validation: precedentes del mismo modelo
   - Payback Period: meses para recuperar CAC
   - Pricing Power: spread competitivo y existencia de premium players
4. Sensitivity analysis: ¿qué pasa si CAC sube 20%? ¿si churn sube 20%?
5. Calcular score como suma de sub-dimensiones

**Output `data`**:
```json
{
  "recommended_model": "subscription",
  "pricing_suggestion": {
    "price_point": 49,
    "billing": "monthly",
    "justification": "Mid-range del benchmark ($19-$149), alineado con pain intensity high"
  },
  "unit_economics": {
    "estimated_cac": 120,
    "estimated_ltv": 588,
    "ltv_cac_ratio": 4.9,
    "payback_months": 2.4
  },
  "sensitivity_analysis": {
    "cac_plus_20": "LTV/CAC baja a 4.1x — sigue saludable",
    "churn_plus_20": "LTV baja a $470, ratio a 3.9x — viable pero ajustado",
    "price_minus_20": "LTV baja a $470, payback sube a 3.1 meses — viable"
  },
  "assumptions": [
    "Churn mensual: 5% (benchmark SaaS SMB)",
    "CAC basado en canal principal: content marketing + paid search"
  ],
  "sub_scores": {
    "ltv_cac_ratio": 22,
    "revenue_model_validation": 18,
    "payback_period": 21,
    "pricing_power": 15
  },
  "model_score": 76
}
```

---

### Dept 5: Risk Assessment (hc-risk)

**Rol**: ¿Qué puede matar esto?

**Input adicional**: Lee de Engram TODOS los departamentos anteriores.

**Proceso**:
1. Recuperar todos los artefactos previos via mem_search → mem_get_observation
2. Evaluar según 4 sub-dimensiones INVERTIDAS (ver scoring-convention.md):
   - Execution Feasibility: APIs, OSS, talent, infra costs
   - Regulatory & Legal: frameworks, enforcement, legislation
   - Market Timing: Google Trends, competitor launches, investment activity
   - Dependency & Concentration: platform risk, channel concentration
3. Cada riesgo: probabilidad × impacto + mitigación
4. Rankear top 3 riesgos que podrían matar la idea
5. Calcular score como suma de sub-dimensiones (100 = bajo riesgo)

**Output `data`**:
```json
{
  "risks": [
    {
      "category": "market",
      "risk": "Timing — el segmento puede no estar listo para pagar",
      "probability": "medium",
      "impact": "high",
      "mitigation": "Validar con 10 entrevistas pagadas antes de construir"
    }
  ],
  "dependencies": [
    {"dependency": "API de tercero X", "criticality": "high", "fallback": "API alternativa Y"}
  ],
  "overall_risk_level": "medium",
  "top_3_killers": ["riesgo 1", "riesgo 2", "riesgo 3"],
  "sub_scores": {
    "execution_feasibility": 18,
    "regulatory_legal": 22,
    "market_timing": 15,
    "dependency_concentration": 17
  },
  "risk_score": 72
}
```

---

### Dept 6: GO/NO-GO Synthesis (hc-synthesis)

**Rol**: Veredicto final con razonamiento explícito.

**Input**: Scores y datos de los 5 departamentos.

**Proceso**:
1. Recuperar todos los scores y summaries de Engram
2. Calcular weighted score: `(P × 0.30) + (M × 0.25) + (C × 0.15) + (B × 0.20) + (R × 0.10)`
3. Aplicar knockouts:
   - **NO-GO automático**: Problem < 40, Market < 40, Risk < 30, o 2+ scores < 45
   - **GO**: weighted ≥ 70 AND Problem ≥ 60 AND todos los demás ≥ 45
   - **PIVOT**: todo lo demás
4. Si PIVOT: generar 2-3 direcciones alternativas basadas en los scores más bajos
5. Generar next steps y validation experiments

**Output `data`**:
```json
{
  "verdict": "GO",
  "confidence": "medium",
  "weighted_score": 72,
  "score_breakdown": {
    "problem": {"score": 78, "weight": 0.30, "contribution": 23.4},
    "market": {"score": 68, "weight": 0.25, "contribution": 17.0},
    "competitive": {"score": 65, "weight": 0.15, "contribution": 9.75},
    "bizmodel": {"score": 76, "weight": 0.20, "contribution": 15.2},
    "risk": {"score": 72, "weight": 0.10, "contribution": 7.2}
  },
  "knockouts_triggered": [],
  "executive_summary": "La idea tiene un problema real con dolor demostrable...",
  "key_strengths": ["..."],
  "key_concerns": ["..."],
  "assumptions": ["..."],
  "pivot_suggestions": [],
  "next_steps": [
    {"action": "...", "priority": "high", "timeframe": "1-2 semanas"}
  ],
  "validation_experiments": [
    {"experiment": "Landing page + waitlist", "success_metric": ">100 signups en 7 días", "effort": "low"}
  ]
}
```

---

## ENGRAM: NAMING Y PERSISTENCIA

### Compatibilidad con la API de Engram

| Constraint | Cómo lo manejamos |
|---|---|
| `type` es enum (7 valores) | Mapeamos: depts → `discovery`, synthesis/report → `decision`, state → `config` |
| `tags` no existe | Keywords embebidos en content `**What**` section para FTS5 search |
| Content format recomendado | Adaptado `**What**/**Why**/**Where**/**Data**` al dominio |
| Session lifecycle obligatorio | Orchestrator hace `mem_session_start` / `mem_session_summary` / `mem_session_end` |

### Naming Convention

```
validation/{idea-slug}/{department}

Ejemplos:
  validation/platform-freelance-contracts/problem
  validation/platform-freelance-contracts/market
  validation/platform-freelance-contracts/competitive
  validation/platform-freelance-contracts/bizmodel
  validation/platform-freelance-contracts/risk
  validation/platform-freelance-contracts/synthesis
  validation/platform-freelance-contracts/report
  validation/platform-freelance-contracts/state
```

### Cómo persiste cada departamento

```
mem_save(
  title: "Validation: {slug} — {department} ({score}/100)",
  topic_key: "validation/{slug}/{department}",
  type: "discovery",
  project: "hardcore",
  scope: "project",
  content: "**What**: {executive_summary} [validation] [{department}] [{industry}]\n\n**Why**: Score {score}/100 — {score_reasoning}\n\n**Where**: validation/{slug}/{department}\n\n**Data**:\n{JSON}"
)
```

`topic_key` permite upsert: si re-ejecutás un departamento, actualiza en vez de duplicar.

### Cómo un departamento lee el output de otro (2 pasos — OBLIGATORIO)

```
1. mem_search("validation/{slug}/{dept-que-necesito}", project: "hardcore")
   → Retorna resultado compacto (TRUNCADO) con observation ID

2. mem_get_observation(id=XX)
   → Retorna contenido completo, sin truncar

NUNCA usar el resultado de mem_search directamente — siempre llamar mem_get_observation.
```

### Session Lifecycle

```
Inicio:   mem_session_start(id: "validation-{slug}-{date}", project: "hardcore")
Trabajo:  mem_save() por cada departamento completado
Cierre:   mem_session_summary(session_id, goal, accomplished, discoveries, next_steps)
          mem_session_end(session_id)
Recovery: mem_context(project: "hardcore") → restaurar estado tras compaction
```

### Report final consolidado

```
mem_save(
  title: "VALIDATION REPORT: {slug} — {VERDICT} ({weighted_score}/100)",
  topic_key: "validation/{slug}/report",
  type: "decision",
  project: "hardcore",
  scope: "project",
  content: "**What**: {verdict} — {executive_summary} [validation] [report] [{verdict}] [{industry}]\n\n**Why**: Weighted score {weighted_score}/100\n\n**Where**: validation/{slug}/report\n\n**Data**:\n{full report}"
)
```

### Cross-validation (habilitado por diseño, implementado después)

El naming consistente y los keywords embebidos en content permiten queries futuras:
```
mem_search("validation report GO", project: "hardcore")      → todas las ideas GO
mem_search("validation report fintech", project: "hardcore")  → todas las ideas fintech
mem_search("validation problem", project: "hardcore")         → todos los problem analyses
```

---

## DECISIONES TÉCNICAS

| Decisión | Elección | Rationale |
|---|---|---|
| **Web search** | Serper | Mejor ratio precio/query ($50/5000). Tavily es alternativa. |
| **LLM sub-agentes** | Claude Sonnet para depts 1-5, Opus para Synthesis | Sonnet es suficiente para análisis individual, Synthesis necesita mejor razonamiento |
| **Persistencia default** | Engram | Repo limpio, búsqueda FTS5, compatible con futuro |
| **Formato report** | JSON + Markdown en Engram | Structured para programmatic access, legible para humanos |
| **Human-in-the-loop** | Configurable (default: pausa después de Problem) | Balance entre control y velocidad |
| **Paralelismo** | Market ∥ Competitive | Son independientes, reduce latencia total ~30% |
| **Pesos** | 30/25/15/20/10 | Simulación 13 escenarios: 84.6% accuracy vs 61.5% uniforme |
| **Scoring** | Sub-dimensiones medibles | Reduce varianza de ±10 a ±3-5 puntos entre ejecuciones |
| **Risk weight** | 10% + knockouts | Su valor es de veto (knockout), no de promedio ponderado |

---

## PLAN DE IMPLEMENTACIÓN

### Phase 0: Foundation ✅ DONE

**Objetivo**: Infraestructura base lista.

**Completado**:
- Estructura de directorios
- `_shared/output-contract.md` — envelope JSON con `detailed_report`, `flags` vs ATL `risks`
- `_shared/scoring-convention.md` — 22 sub-dimensiones medibles, pesos simulados, knockouts
- `_shared/engram-convention.md` — type mapping válido, sin `tags`, content format adaptado, session lifecycle
- `_shared/persistence-contract.md` — 3 modos (engram/file/none) con degradación graceful
- `hc-orchestrator/SKILL.md` — DAG completo, session lifecycle, state recovery

### Phase 1: Departamentos uno a uno ✅ DONE

**Objetivo**: Cada departamento funciona standalone y produce output con sub-scores correctos.

```
Semana 1:
├── Día 1-2: hc-problem/SKILL.md
│   └── Testear con 3 ideas distintas
│   └── Verificar que sub-scores son reproducibles (±3-5 puntos)
│   └── Verificar que evidence tiene URLs reales
├── Día 3-4: hc-market/SKILL.md
│   └── Testear que lee de Engram el output de Problem (2-step recovery)
│   └── Verificar que TAM/SAM/SOM tienen fuentes institucionales
│   └── Verificar que early adopters tienen canales concretos
└── Día 5: hc-competitive/SKILL.md
    └── Testear que competidores son reales (URLs válidas)
    └── Verificar que Incumbent Weakness está invertido correctamente
    └── Verificar pricing benchmark

Semana 2:
├── Día 1-2: hc-bizmodel/SKILL.md
│   └── Testear que lee Market + Competitive de Engram
│   └── Verificar que LTV/CAC usa benchmarks reales, no assumptions
│   └── Verificar sensitivity analysis
├── Día 3: hc-risk/SKILL.md
│   └── Testear que lee todos los depts anteriores
│   └── Verificar que scoring es invertido (100 = bajo riesgo)
└── Día 4-5: hc-synthesis/SKILL.md
    └── Testear weighted score con pesos 30/25/15/20/10
    └── Verificar knockouts: Problem<40→NO-GO, Market<40→NO-GO, Risk<30→NO-GO
    └── Verificar GO requiere Problem≥60 y todos≥45
    └── Testear pivot suggestions
```

**Entregable**: 6 skills funcionales con sub-scoring reproducible.

**Testeo**: Ejecutar cada skill manualmente. Verificar:
- ¿Los sub-scores son consistentes entre ejecuciones? (varianza ≤5 puntos)
- ¿La evidence es real y verificable?
- ¿Los competidores existen?
- ¿Los números de unit economics son plausibles?
- ¿El score reasoning muestra breakdown de sub-dimensiones?

### Phase 2: Orquestación

**Objetivo**: El orquestador ejecuta el DAG completo de punta a punta.

```
├── Día 1-2: Completar hc-orchestrator/SKILL.md
│   ├── Session lifecycle (mem_session_start → mem_session_end)
│   ├── Delegación con type mapping correcto (discovery/decision/config)
│   ├── Manejo del paso paralelo (Market ∥ Competitive)
│   └── Human-in-the-loop checkpoints
│
├── Día 3-4: Integración end-to-end
│   ├── Ejecutar pipeline completo con 3 ideas distintas
│   ├── Verificar 2-step recovery entre departamentos
│   ├── Verificar que el report final consolida todo
│   └── Medir latencia total del pipeline
│
├── Día 5: Error handling
│   ├── ¿Qué pasa si web search no retorna nada útil?
│   ├── ¿Qué pasa si un departamento retorna status: "blocked"?
│   ├── ¿Qué pasa si Engram no está disponible? (fallback a none)
│   └── ¿Qué pasa si context se compacta? (mem_context recovery)
│
└── Día 6-7: Escribir configs de ejemplo
    ├── examples/claude-code/CLAUDE.md
    ├── examples/opencode/opencode.json
    └── examples/cursor/.cursorrules
```

**Entregable**: Pipeline completo. `/validate:new mi idea de...` ejecuta 6 departamentos y produce veredicto.

### Phase 3: Hardening

**Objetivo**: El sistema es confiable y consistente.

```
├── Testear con 10 ideas diversas:
│   ├── 3 ideas obviamente buenas (debería dar GO)
│   ├── 3 ideas obviamente malas (debería dar NO-GO)
│   ├── 2 ideas ambiguas (debería dar PIVOT con sugerencias)
│   └── 2 ideas en industrias distintas (fintech, healthtech, B2B SaaS, consumer)
│
├── Verificar sub-scoring reproducibility
│   └── Ejecutar misma idea 3 veces, medir varianza por sub-dimensión
│   └── Aceptable: ≤5 puntos de varianza por sub-score
│
├── Calibrar knockouts contra resultados
│   └── ¿Los knockouts disparan correctamente?
│   └── ¿Algún GO que debería ser PIVOT?
│   └── ¿Algún NO-GO que debería ser PIVOT?
│
├── Mejorar prompts de web search
│   └── Las queries genéricas retornan basura — refinar
│
├── Agregar validación de evidence
│   └── Flag "unverified" si un dato no tiene URL fuente
│
└── Documentar: README, install guide, ejemplos de uso
```

**Entregable**: Sistema robusto, documentado, con resultados verificados en 10 ideas.

---

## RIESGOS TÉCNICOS

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| Web search retorna basura o nada | Alta | Alto | Múltiples queries reformuladas por dept, fallback a knowledge del LLM con flag "unverified" |
| Sub-scores con alta varianza entre ejecuciones | Media | Alto | Sub-dimensiones ancladas a conteos, no juicios. Testeo de varianza en Phase 3 |
| LLM hallucina competidores | Media | Alto | Forzar evidence URL para cada competidor, validar existencia, flag si no hay fuente |
| Latencia total del pipeline alta (>5 min) | Media | Medio | Paralelizar Market ∥ Competitive, optimizar queries |
| Engram no disponible | Baja | Alto | Fallback a modo "none" (efímero), el pipeline sigue funcionando sin persistencia |
| Datos de mercado stale o incorrectos | Alta | Medio | Incluir fecha de la fuente, sub-score de Data Availability penaliza data vieja |
| Knockouts demasiado agresivos o permisivos | Media | Alto | Calibrar en Phase 3 con 10 ideas diversas, ajustar thresholds si necesario |

---

## COMANDOS

| Comando | Qué hace |
|---|---|
| `/validate:new <idea>` | Inicia validación completa de una idea |
| `/validate:fast <idea>` | Ejecuta todo sin paradas humanas intermedias |
| `/validate:status` | Muestra estado del pipeline en curso |
| `/validate:report <slug>` | Recupera report de una validación previa |
| `/validate:compare <slug1> <slug2>` | Compara dos validaciones side-by-side |
| `/validate:rerun <slug> <dept>` | Re-ejecuta un departamento específico |

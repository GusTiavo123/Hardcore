# HARDCORE — Idea Validation Agent Team
## Plan de Desarrollo: Sistema Multi-Agente para Validación de Ideas de Startup

---

## QUÉ ES ESTO

Un equipo de 6 agentes AI especializados que toman una idea de startup en texto libre y producen un veredicto claro (GO / NO-GO / PIVOT) con datos reales, razonamiento explícito y próximos pasos accionables.

Se basa en la arquitectura de [Agent Teams Lite](https://github.com/Gentleman-Programming/agent-teams-lite) (orquestación multi-agente) y [Engram](https://github.com/Gentleman-Programming/engram) (memoria persistente entre agentes y sesiones).

### Contexto futuro (no se implementa ahora)

Este agent team es el Módulo 2 de un ecosistema más amplio llamado **Hardcore** (Founder Operating System). Eventualmente se conectará con otros módulos (Idea Discovery, Deep Research, Product Definition, etc.) a través de Engram como bus de memoria compartida. Las decisiones de naming y estructura de datos de este módulo deben ser compatibles con esa visión, pero **el scope de este plan es exclusivamente Idea Validation**.

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
- Session lifecycle
- topic_key para upserts (re-validar sin duplicar)

---

## ARQUITECTURA

### Estructura de Directorios

```
hardcore-validation/
├── README.md
├── LICENSE
│
├── skills/
│   ├── _shared/                         # Convenciones compartidas por todos los depts
│   │   ├── persistence-contract.md      # Reglas de persistencia (engram/file/none)
│   │   ├── engram-convention.md         # Naming: validation/{slug}/{dept}
│   │   ├── scoring-convention.md        # Rubrics, normalización, rangos
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
                   │  VALIDATION   │
                   └───────┬───────┘
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
     ┌────────────────┐      ┌──────────────────┐
     │  MARKET SIZING │      │  COMPETITIVE     │   PARALELO.
     │                │      │  INTELLIGENCE    │   Ambos dependen
     └────────┬───────┘      └──────────┬───────┘   solo de Problem.
              │                         │
              └────────────┬────────────┘
                           │
                           ▼
                   ┌───────────────┐
                   │  BUSINESS     │   Depende de Market + Competitive.
                   │  MODEL        │   Necesita pricing benchmark y
                   └───────┬───────┘   market size para unit economics.
                           │
                           ▼
                   ┌───────────────┐
                   │    RISK       │   Depende de TODO lo anterior.
                   │  ASSESSMENT   │
                   └───────┬───────┘
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
  2. Busca en Engram: mem_search("validation platform-freelance-contracts")
     → Si existe: "Ya validaste esto el 15/03. ¿Re-validar o ver resultados?"
     → Si no existe: arranca el DAG

  3. → Lanza sub-agente PROBLEM VALIDATION
     ← Recibe: {status: "ok", score: 78, executive_summary: "..."}
     → Persiste: mem_save(topic_key: "validation/.../problem")
     → Muestra resumen al usuario

  4. → Lanza MARKET SIZING ∥ COMPETITIVE INTEL (paralelo)
     ← Recibe ambos resultados
     → Persiste ambos
     → Muestra resumen consolidado

  5. → Lanza BUSINESS MODEL
     ← Lee de Engram: market data + competitive pricing
     → Persiste

  6. → Lanza RISK ASSESSMENT
     ← Lee de Engram: todo lo anterior
     → Persiste

  7. → Lanza SYNTHESIS
     ← Lee todos los scores y summaries
     → Calcula weighted score, emite veredicto
     → Persiste report final

  8. → Presenta veredicto al usuario con evidencia
     → mem_session_summary()
```

**Human-in-the-loop** (configurable):
- Después de Problem Validation: "¿El problema está bien planteado?"
- Después de Market + Competitive: "¿Querés continuar sabiendo el landscape?"
- En modo "fast": ejecuta todo sin paradas intermedias.

---

## OUTPUT CONTRACT

Cada departamento retorna este envelope estandarizado:

```json
{
  "status": "ok | warning | blocked | failed",
  "department": "problem | market | competitive | bizmodel | risk | synthesis",
  "executive_summary": "1-2 oraciones decision-grade para el orquestador",
  "score": 0-100,
  "score_reasoning": "por qué este score específico",
  "data": {
    // Output estructurado específico del departamento
    // (ver detalle por departamento más abajo)
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
  "flags": ["flag si algo requiere atención del orquestador"],
  "next_recommended": ["market", "competitive"]
}
```

`executive_summary` es lo que el orquestador muestra al usuario entre fases. `data` contiene el análisis completo. `flags` permite que un departamento escale problemas (ej: "no encontré datos de mercado confiables").

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
3. Analizar resultados: ¿quejas reales? ¿cuántas? ¿qué tan recientes?
4. Clasificar intensidad:
   - **Critical**: Pérdida de dinero/tiempo, urgencia demostrable
   - **High**: Frustración repetida, workarounds elaborados
   - **Medium**: Molestia reconocida, no prioritaria
   - **Low**: Nice-to-have, poca evidencia
5. Identificar soluciones actuales (cómo lo resuelven hoy sin el producto)
6. Calcular score con reasoning explícito

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
  "problem_score": 78
}
```

**Scoring rubric**:
- 80-100: Quejas frecuentes documentadas, workarounds costosos, urgencia
- 60-79: Problema real, algunas quejas, alternativas aceptables existen
- 40-59: Problema difuso, poca evidencia directa, puede ser nice-to-have
- 0-39: Sin evidencia de dolor real, soluciones existentes son suficientes

---

### Dept 2: Market Sizing (hc-market)

**Rol**: ¿Cuánto vale esta oportunidad en dinero?

**Input adicional**: Lee de Engram el output de Problem Validation.

**Proceso**:
1. `mem_search("validation/{slug}/problem")` → recuperar contexto
2. Buscar reportes de mercado:
   - `"{industria} market size 2024 2025"`
   - `"{segmento} TAM SAM report"`
   - `"{industria} growth rate forecast"`
3. Calcular TAM → SAM → SOM con fuentes explícitas
4. Determinar market stage
5. Identificar early adopters: quién compra primero y por qué

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
    "characteristics": ["tech-savvy", "pain-aware", "willingness to pay"]
  },
  "market_score": 72
}
```

**Scoring rubric**:
- 80-100: SOM > $50M, crecimiento >15% anual, early adopters claros
- 60-79: SOM $10-50M, crecimiento moderado, segmentos identificables
- 40-59: SOM $1-10M, mercado estable o fragmentado
- 0-39: SOM < $1M o mercado en decline

---

### Dept 3: Competitive Intelligence (hc-competitive)

**Rol**: ¿Quién más resuelve esto? ¿Dónde están los gaps?

**Input adicional**: Lee de Engram el output de Problem Validation.

**Proceso**:
1. `mem_search("validation/{slug}/problem")` → recuperar contexto
2. Buscar competidores directos:
   - `"{solución}" site:producthunt.com`
   - `"{solución}" site:g2.com`
   - `"{solución} pricing" OR "{solución} plans"`
3. Buscar competidores indirectos (alternativas distintas al mismo problema)
4. Para cada competidor: pricing, modelo, fortalezas, debilidades
5. Buscar competidores muertos:
   - `"{solución} startup failed" OR "shutdown" OR "pivoted"`
   - Failory, CB Insights post-mortems
6. Identificar gaps no cubiertos
7. Construir pricing benchmark

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
  "indirect_competitors": [...],
  "failed_competitors": [
    {"name": "...", "reason_failed": "...", "source": "url"}
  ],
  "market_gaps": ["gap 1", "gap 2"],
  "pricing_benchmark": {"low": 19, "mid": 49, "high": 149, "currency": "USD/mo"},
  "competitive_score": 65
}
```

**Scoring rubric** (oportunidad de diferenciación):
- 80-100: Pocos competidores, gaps claros, ningún dominante con moat
- 60-79: Competencia moderada, diferenciación posible
- 40-59: Mercado saturado pero gaps específicos identificables
- 0-39: Dominante claro con moat fuerte, sin gaps aparentes

---

### Dept 4: Business Model (hc-bizmodel)

**Rol**: ¿Los números cierran?

**Input adicional**: Lee de Engram Market Sizing + Competitive Intelligence.

**Proceso**:
1. `mem_search("validation/{slug}/market")` + `mem_search("validation/{slug}/competitive")`
2. Proponer modelo de monetización basado en pricing benchmark + market size
3. Estimar unit economics:
   - CAC: benchmark por industria/canal
   - LTV: pricing × retention estimada × lifetime
   - LTV/CAC ratio (saludable: >3x)
   - Payback period
4. Sensitivity analysis: ¿qué pasa si CAC sube 20%? ¿si churn sube 20%?
5. Documentar assumptions

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
  "model_score": 74
}
```

**Scoring rubric**:
- 80-100: LTV/CAC > 5x, payback < 6 meses, modelo probado en industria
- 60-79: LTV/CAC 3-5x, payback 6-12 meses, viable con ajustes
- 40-59: LTV/CAC 1-3x, payback > 12 meses, assumptions frágiles
- 0-39: LTV/CAC < 1x, insostenible

---

### Dept 5: Risk Assessment (hc-risk)

**Rol**: ¿Qué puede matar esto?

**Input adicional**: Lee de Engram TODOS los departamentos anteriores.

**Proceso**:
1. Recuperar todos los artefactos previos
2. Evaluar por categoría:
   - **Técnicos**: ¿Se puede construir? ¿Dependencias críticas?
   - **Mercado**: ¿Timing? ¿Adopción realista?
   - **Regulatorios**: ¿Compliance? ¿Restricciones?
   - **Ejecución**: ¿Equipo? ¿Capital? ¿Timeline?
3. Cada riesgo: probabilidad × impacto + mitigación
4. Rankear top 3 riesgos que podrían matar la idea

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
    {"dependency": "API de tercero X", "criticality": "high"}
  ],
  "overall_risk_level": "medium",
  "top_3_killers": ["riesgo 1", "riesgo 2", "riesgo 3"],
  "risk_score": 62
}
```

**Scoring** (invertido: 100 = bajo riesgo):
- 80-100: Riesgos menores, todos mitigables, sin dependencias críticas
- 60-79: Algunos riesgos significativos pero mitigables
- 40-59: Riesgos importantes, mitigación requiere esfuerzo sustancial
- 0-39: Riesgos críticos sin mitigación clara

---

### Dept 6: GO/NO-GO Synthesis (hc-synthesis)

**Rol**: Veredicto final con razonamiento explícito.

**Input**: Scores y datos de los 5 departamentos.

**Proceso**:
1. Recuperar todos los scores y summaries de Engram
2. Calcular weighted score:
   - Problem: 25%
   - Market: 20%
   - Competitive: 20%
   - Business Model: 20%
   - Risk: 15%
3. Aplicar reglas de decisión:
   - **GO**: weighted >= 70 AND ningún score individual < 40
   - **PIVOT**: weighted 50-69 OR exactamente un score < 40
   - **NO-GO**: weighted < 50 OR dos o más scores < 40
4. Si PIVOT: generar 2-3 direcciones alternativas
5. Generar next steps y validation experiments

**Output `data`**:
```json
{
  "verdict": "GO",
  "confidence": "medium",
  "weighted_score": 72,
  "score_breakdown": {
    "problem": {"score": 78, "weight": 0.25, "contribution": 19.5},
    "market": {"score": 72, "weight": 0.20, "contribution": 14.4},
    "competitive": {"score": 65, "weight": 0.20, "contribution": 13.0},
    "bizmodel": {"score": 74, "weight": 0.20, "contribution": 14.8},
    "risk": {"score": 62, "weight": 0.15, "contribution": 9.3}
  },
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
```

### Cómo persiste cada departamento

```
mem_save({
  title: "Validation: {slug} — {department} ({score}/100)",
  type: "validation-{department}",
  topic_key: "validation/{slug}/{department}",
  content: "## Summary\n{executive_summary}\n\n## Score: {score}/100\n{score_reasoning}\n\n## Data\n{JSON}",
  project: "hardcore",
  tags: ["validation", "{department}", "{industry}"]
})
```

`topic_key` permite upsert: si re-ejecutás un departamento, actualiza en vez de duplicar.

### Cómo un departamento lee el output de otro

```
1. mem_search("validation/{slug}/{dept-que-necesito}")
   → Retorna resultado compacto con observation ID

2. mem_get_observation(id=XX)
   → Retorna contenido completo (el JSON con todos los datos)

3. El sub-agente parsea el JSON y usa los datos que necesita
```

### Report final consolidado

Después de la síntesis, se persiste un report que consolida todo:

```
mem_save({
  title: "VALIDATION REPORT: {slug} — {VERDICT} ({weighted_score}/100)",
  type: "validation-report",
  topic_key: "validation/{slug}/report",
  content: "[reporte completo con todos los scores, evidencia, y veredicto]",
  project: "hardcore",
  tags: ["validation", "report", "{verdict}", "{industry}"]
})
```

### Cross-validation (habilitado por diseño, implementado después)

El naming consistente permite queries futuras como:
```
mem_search("validation-report GO")      → todas las ideas que dieron GO
mem_search("validation-report fintech") → todas las ideas fintech validadas
```

No se implementa lógica de meta-análisis ahora, pero la estructura de datos lo soporta.

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

---

## PLAN DE IMPLEMENTACIÓN

### Phase 0: Foundation (3-4 días)

**Objetivo**: Tener la infraestructura base lista.

```
Tareas:
├── Instalar y verificar Engram funcionando
├── Crear repo hardcore-validation con estructura de directorios
├── Escribir skills/_shared/output-contract.md
├── Escribir skills/_shared/scoring-convention.md
├── Escribir skills/_shared/engram-convention.md (naming, recovery protocol)
├── Escribir skills/_shared/persistence-contract.md (engram/file/none)
└── Escribir esqueleto de hc-orchestrator/SKILL.md (sin lógica de departamentos)
```

**Entregable**: Repo con estructura, convenciones definidas, Engram corriendo.

### Phase 1: Departamentos uno a uno (10-14 días)

**Objetivo**: Cada departamento funciona standalone y produce output correcto.

```
Semana 1:
├── Día 1-2: hc-problem/SKILL.md
│   └── Testear con 3 ideas distintas, verificar que evidence es real
├── Día 3-4: hc-market/SKILL.md
│   └── Testear que lee de Engram el output de Problem
│   └── Verificar que TAM/SAM/SOM tienen fuentes
└── Día 5: hc-competitive/SKILL.md
    └── Testear que competidores son reales (URLs válidas)
    └── Verificar pricing benchmark

Semana 2:
├── Día 1-2: hc-bizmodel/SKILL.md
│   └── Testear que lee Market + Competitive de Engram
│   └── Verificar unit economics hacen sentido numérico
├── Día 3: hc-risk/SKILL.md
│   └── Testear que lee todos los depts anteriores
└── Día 4-5: hc-synthesis/SKILL.md
    └── Testear cálculo de weighted score
    └── Verificar reglas GO/NO-GO/PIVOT
    └── Testear generación de pivot suggestions
```

**Entregable**: 6 skills que funcionan individualmente, cada uno persistiendo en Engram.

**Testeo**: Ejecutar cada skill manualmente en Claude Code con una idea real. Verificar:
- ¿Los scores son consistentes entre ejecuciones? (baja varianza)
- ¿La evidence es real y verificable?
- ¿Los competidores existen?
- ¿Los números de unit economics son plausibles?
- ¿El score reasoning justifica el score?

### Phase 2: Orquestación (5-7 días)

**Objetivo**: El orquestador ejecuta el DAG completo de punta a punta.

```
├── Día 1-2: Completar hc-orchestrator/SKILL.md
│   ├── Lógica de detección de idea y generación de slug
│   ├── Chequeo de validación previa en Engram
│   ├── Delegación secuencial a cada departamento
│   ├── Manejo del paso paralelo (Market ∥ Competitive)
│   └── Human-in-the-loop checkpoints
│
├── Día 3-4: Integración end-to-end
│   ├── Ejecutar pipeline completo con 3 ideas distintas
│   ├── Verificar que cada dept lee correctamente de Engram
│   ├── Verificar que el report final consolida todo
│   └── Medir latencia total del pipeline
│
├── Día 5: Error handling
│   ├── ¿Qué pasa si web search no retorna nada útil?
│   ├── ¿Qué pasa si un departamento retorna status: "blocked"?
│   ├── ¿Qué pasa si Engram no está disponible?
│   └── Fallbacks y flags para cada caso
│
└── Día 6-7: Escribir configs de ejemplo
    ├── examples/claude-code/CLAUDE.md
    ├── examples/opencode/opencode.json
    └── examples/cursor/.cursorrules
```

**Entregable**: Pipeline completo ejecutable via Claude Code u OpenCode. Le decís `/validate:new mi idea de...` y ejecuta los 6 departamentos, produce veredicto.

### Phase 3: Hardening (3-5 días)

**Objetivo**: El sistema es confiable y consistente.

```
├── Testear con 10 ideas diversas:
│   ├── 3 ideas obviamente buenas (debería dar GO)
│   ├── 3 ideas obviamente malas (debería dar NO-GO)
│   ├── 2 ideas ambiguas (debería dar PIVOT con sugerencias)
│   └── 2 ideas en industrias distintas (fintech, healthtech, B2B SaaS, consumer)
│
├── Calibrar scoring rubrics basándose en resultados
│   └── Ajustar thresholds si los scores están sesgados
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
| Scores inconsistentes entre ejecuciones | Media | Alto | Rubrics detalladas en cada skill, temperature=0, examples concretos en el prompt |
| LLM hallucina competidores | Media | Alto | Forzar evidence URL para cada competidor, validar existencia, flag si no hay fuente |
| Latencia total del pipeline alta (>5 min) | Media | Medio | Paralelizar Market ∥ Competitive, optimizar queries |
| Engram no disponible | Baja | Alto | Fallback a modo "none" (efímero), el pipeline sigue funcionando sin persistencia |
| Datos de mercado stale o incorrectos | Alta | Medio | Incluir fecha de la fuente, flag si data > 2 años, disclaimer de estimaciones |

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

---

## ESTIMACIÓN TOTAL

| Phase | Duración | Entregable |
|---|---|---|
| Phase 0: Foundation | 3-4 días | Repo + convenciones + Engram |
| Phase 1: Departamentos | 10-14 días | 6 skills funcionales |
| Phase 2: Orquestación | 5-7 días | Pipeline end-to-end |
| Phase 3: Hardening | 3-5 días | Sistema robusto + docs |
| **TOTAL** | **~4-5 semanas** | **Idea Validation completo** |

Esto asume trabajo part-time (evenings/weekends). Full-time se comprime a ~2-3 semanas.

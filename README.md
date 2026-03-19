# Idea Validation — Hardcore Agent Team

Un equipo de 6 agentes AI especializados que toman una idea de startup en texto libre y producen un veredicto claro (**GO** / **NO-GO** / **PIVOT**) con datos reales, razonamiento explícito y próximos pasos accionables.

Módulo del ecosistema **Hardcore** (Founder Operating System). Basado en la arquitectura de [Agent Teams Lite](https://github.com/Gentleman-Programming/agent-teams-lite) (orquestación multi-agente) y [Engram](https://github.com/Gentleman-Programming/engram) (memoria persistente entre agentes y sesiones).

## Cómo Funciona

```
TU IDEA → Problem Validation → Market Sizing ∥ Competitive Intel → Business Model → Risk → GO/NO-GO
```

Un orquestador delegate-only coordina 6 departamentos especializados. Cada uno calcula un score 0-100 basado en **sub-dimensiones medibles** (no juicio subjetivo). Al final, un weighted score con reglas de knockout produce el veredicto.

| Departamento | Qué analiza | Peso | Sub-dimensiones |
|---|---|---|---|
| **Problem** | ¿El problema existe y duele? | 30% | Volumen de quejas, recencia, intensidad, workarounds, alternativas pagas |
| **Market** | ¿Cuánto vale la oportunidad? | 25% | Calidad de data, SOM, CAGR, early adopters |
| **Competitive** | ¿Quién más lo resuelve? ¿Hay gaps? | 15% | Validación de mercado, debilidad incumbente, gaps, pricing, failures |
| **Business Model** | ¿Los números cierran? | 20% | LTV/CAC, modelo validado, payback, pricing power |
| **Risk** | ¿Qué puede matar esto? | 10% | Ejecución, regulatorio, timing, dependencias |
| **Synthesis** | Veredicto final + próximos pasos | — | Weighted score + knockouts |

### Reglas de Decisión

- **GO**: weighted ≥ 70, Problem ≥ 60, todos los demás ≥ 45
- **NO-GO automático**: Problem < 40, Market < 40, Risk < 30, o dos+ scores < 45
- **PIVOT**: todo lo demás → incluye pivot suggestions

Los pesos y knockouts fueron validados con simulación de 13 escenarios (84.6% accuracy vs 61.5% con pesos uniformes).

## Requisitos

- [Engram](https://github.com/Gentleman-Programming/engram) v1.0+ instalado y en PATH
- Un agente AI compatible con MCP (OpenCode, Claude Code, Cursor, Antigravity, etc.)

## Quick Start

### 1. Clonar el repo

```bash
git clone https://github.com/tu-usuario/idea-validation.git
cd idea-validation
```

### 2. Instalar Engram

**Windows:**
```powershell
Invoke-WebRequest -Uri "https://github.com/Gentleman-Programming/engram/releases/latest" -OutFile engram.zip
Expand-Archive engram.zip -DestinationPath "$env:USERPROFILE\bin"
[Environment]::SetEnvironmentVariable("Path", "$env:USERPROFILE\bin;" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")
```

**macOS/Linux:**
```bash
brew install gentleman-programming/tap/engram
```

### 3. Configurar tu agente

**OpenCode:** Copiar `examples/opencode/opencode.json` a tu proyecto y las carpetas `commands/` para slash commands.

### 4. Usar

```
/validate:new Una plataforma que ayuda a freelancers a gestionar contratos e invoices
```

O sin paradas intermedias:

```
/validate:fast Una plataforma que ayuda a freelancers a gestionar contratos e invoices
```

## Estructura del Proyecto

```
skills/
├── _shared/                      # Convenciones compartidas
│   ├── output-contract.md        # JSON envelope de cada departamento
│   ├── scoring-convention.md     # Sub-dimensiones, pesos, knockouts
│   ├── engram-convention.md      # Naming, type mapping, session lifecycle
│   └── persistence-contract.md   # Modos: engram (obligatorio) / file
├── hc-orchestrator/SKILL.md      # Orquestador delegate-only
├── hc-problem/SKILL.md           # Dept 1: Problem Validation
├── hc-market/SKILL.md            # Dept 2: Market Sizing
├── hc-competitive/SKILL.md       # Dept 3: Competitive Intelligence
├── hc-bizmodel/SKILL.md          # Dept 4: Business Model
├── hc-risk/SKILL.md              # Dept 5: Risk Assessment
└── hc-synthesis/SKILL.md         # Dept 6: GO/NO-GO Synthesis
testing/
├── PROTOCOL.md                   # Protocolo de testing y checklist
├── suite.yaml                    # 10 ideas curadas con expectativas
├── runs/                         # Resultados de runs reales (commiteados)
└── analysis/                     # Análisis de varianza cross-machine
calibration/
└── scenarios.md                  # 13 escenarios de calibración de scoring
examples/
└── opencode/                     # Config para OpenCode
scripts/
└── setup.sh                      # Instalador de herramientas (Engram + open-websearch)
```

## Compatibilidad

### Con Agent Teams Lite
Usamos el patrón delegate-only, output contracts, skills como Markdown puro, y `_shared/` para convenciones DRY. Lo que cambia es el dominio — la mecánica es la misma.

### Con Engram
Todos los `mem_save` usan `type` enums válidos de Engram (`discovery`, `decision`, `config`). No usamos `tags` (no existe en la API). Content format adaptado a `**What**/**Why**/**Where**/**Data**`. Session lifecycle completo (`mem_session_start` → `mem_session_summary` → `mem_session_end`).

## Plan Completo

Ver [hardcore-validation-plan.md](./hardcore-validation-plan.md) para la especificación detallada de cada departamento, sub-scoring rubrics, DAG de dependencias, y plan de implementación por fases.

## Estado Actual

- [x] **Phase 0: Foundation** — Estructura, convenciones, scoring con sub-dimensiones, orchestrator
- [x] **Phase 1: Departamentos** — 6 skills implementados con proceso, queries, sub-scoring, persistencia
- [/] **Phase 2: Orquestación + Testing** — Orchestrator + Claude Code integration + testing protocol con 10 ideas curadas. Pendiente: runs reales en múltiples máquinas
- [ ] **Phase 3: Hardening** — Varianza ≤5pts, calibración de knockouts, accuracy ≥80%
- [ ] **Idea Loop** — Meta-orchestrator de generación iterativa (diseño en idea-loop-architecture.md)

## Contexto

Este agent team es un módulo del ecosistema **Hardcore** (Founder Operating System). Usa `project: "hardcore"` en Engram y el prefijo `validation/` en topic_key para namespacing. Eventualmente se conectará con otros módulos (Idea Discovery, Deep Research, Product Definition) a través de Engram como bus de memoria compartida.

## Licencia

MIT

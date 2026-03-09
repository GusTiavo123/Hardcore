# HARDCORE — Idea Validation Agent Team

Un equipo de 6 agentes AI especializados que toman una idea de startup en texto libre y producen un veredicto claro (**GO** / **NO-GO** / **PIVOT**) con datos reales, razonamiento explícito y próximos pasos accionables.

Basado en la arquitectura de [Agent Teams Lite](https://github.com/Gentleman-Programming/agent-teams-lite) (orquestación multi-agente) y [Engram](https://github.com/Gentleman-Programming/engram) (memoria persistente entre agentes y sesiones).

## Cómo Funciona

```
TU IDEA → Problem Validation → Market Sizing ∥ Competitive Intel → Business Model → Risk → GO/NO-GO
```

Un orquestador delegate-only coordina 6 departamentos especializados. Cada uno analiza un aspecto de la idea y retorna un score 0-100 con evidencia. Al final, un weighted score produce el veredicto.

| Departamento | Qué analiza | Peso |
|---|---|---|
| **Problem** | ¿El problema existe y duele? | 25% |
| **Market** | ¿Cuánto vale la oportunidad? | 20% |
| **Competitive** | ¿Quién más lo resuelve? ¿Hay gaps? | 20% |
| **Business Model** | ¿Los números cierran? | 20% |
| **Risk** | ¿Qué puede matar esto? | 15% |
| **Synthesis** | Veredicto final + próximos pasos | — |

## Requisitos

- [Engram](https://github.com/Gentleman-Programming/engram) v1.0+ instalado y en PATH
- Un agente AI compatible con MCP (OpenCode, Claude Code, Cursor, Antigravity, etc.)

## Quick Start

### 1. Clonar el repo

```bash
git clone https://github.com/tu-usuario/multi-agente.git
cd multi-agente
```

### 2. Instalar Engram

**Windows:**
```powershell
# Descargar desde GitHub Releases
Invoke-WebRequest -Uri "https://github.com/Gentleman-Programming/engram/releases/latest" -OutFile engram.zip
Expand-Archive engram.zip -DestinationPath "$env:USERPROFILE\bin"
# Agregar al PATH
[Environment]::SetEnvironmentVariable("Path", "$env:USERPROFILE\bin;" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")
```

**macOS/Linux:**
```bash
brew install gentleman-programming/tap/engram
```

### 3. Configurar tu agente

**OpenCode:** Copiar `examples/opencode/opencode.json` a tu proyecto.

### 4. Usar

```
/validate:new Una plataforma que ayuda a freelancers a gestionar contratos e invoices
```

## Estructura del Proyecto

```
skills/
├── _shared/                      # Convenciones compartidas
│   ├── output-contract.md        # JSON envelope de cada departamento
│   ├── scoring-convention.md     # Rubrics, pesos, reglas GO/NO-GO
│   ├── engram-convention.md      # Naming determinístico para Engram
│   └── persistence-contract.md   # Modos: engram / file / none
├── hc-orchestrator/SKILL.md      # Orquestador delegate-only
├── hc-problem/SKILL.md           # Dept 1: Problem Validation
├── hc-market/SKILL.md            # Dept 2: Market Sizing
├── hc-competitive/SKILL.md       # Dept 3: Competitive Intelligence
├── hc-bizmodel/SKILL.md          # Dept 4: Business Model
├── hc-risk/SKILL.md              # Dept 5: Risk Assessment
└── hc-synthesis/SKILL.md         # Dept 6: GO/NO-GO Synthesis
examples/
└── opencode/                     # Config para OpenCode
```

## Plan Completo

Ver [hardcore-validation-plan.md](./hardcore-validation-plan.md) para la especificación detallada de cada departamento, output contracts, DAG de dependencias, y plan de implementación por fases.

## Estado Actual

- [x] **Phase 0: Foundation** — Estructura, convenciones, Engram
- [ ] **Phase 1: Departamentos** — Implementar los 6 skills
- [ ] **Phase 2: Orquestación** — Pipeline end-to-end
- [ ] **Phase 3: Hardening** — Testing con 10 ideas, calibración

## Contexto

Este agent team es el **Módulo 2** de un ecosistema más amplio llamado **Hardcore** (Founder Operating System). Eventualmente se conectará con otros módulos a través de Engram como bus de memoria compartida.

## Licencia

MIT
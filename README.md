# Hardcore — AI Agent Business Operating System

Un ecosistema modular de agentes AI donde vos sos el CEO y los agentes son tus departamentos. Cada módulo cubre una función empresarial real — desde validar una idea hasta darle identidad a tu empresa.

## Módulos

### Idea Validation (disponible)

6 departamentos especializados que toman una idea de startup y producen un veredicto **GO / NO-GO / PIVOT** con evidencia real, scoring explícito y próximos pasos accionables.

```
TU IDEA → Problem → Market ∥ Competitive → BizModel ∥ Risk → Veredicto
```

| Departamento | Qué analiza | Peso |
|---|---|---|
| **Problem** | ¿El problema existe y duele? | 30% |
| **Market** | ¿Cuánto vale la oportunidad? | 25% |
| **Competitive** | ¿Quién más lo resuelve? | 15% |
| **BizModel** | ¿Los números cierran? | 20% |
| **Risk** | ¿Qué puede matar esto? | 10% |
| **Synthesis** | Veredicto final + próximos pasos | — |

Reglas de decisión:
- **GO**: weighted >= 70, Problem >= 60, todos >= 45
- **NO-GO**: Problem < 40, Market < 40, Risk < 30, o 2+ scores < 45
- **PIVOT**: todo lo demás

### Founder Profile (en desarrollo)

Entiende quién sos — skills, recursos, constraints, mercados — para personalizar todo lo que viene después.

### Brand & Identity (planificado)

Genera la identidad empresarial de una idea validada — posicionamiento, naming, paleta, tono de voz.

## Requisitos

- [Engram](https://github.com/Gentleman-Programming/engram) v1.0+ (memoria persistente entre agentes)
- Un agente AI compatible con MCP (Claude Code, OpenCode, Cursor, etc.)

## Quick Start

### 1. Clonar

```bash
git clone https://github.com/tu-usuario/idea-validation.git
cd idea-validation
```

### 2. Setup

```bash
bash scripts/setup.sh
```

### 3. Usar

```
validá esta idea: Una plataforma que ayuda a freelancers a gestionar contratos e invoices
```

O sin paradas:

```
validación rápida: Una plataforma que ayuda a freelancers a gestionar contratos e invoices
```

## Estructura

```
skills/
├── _shared/                    # Convenciones compartidas
├── hc-orchestrator/            # Orquestador delegate-only
├── hc-problem/                 # Problem Validation (30%)
├── hc-market/                  # Market Sizing (25%)
├── hc-competitive/             # Competitive Intelligence (15%)
├── hc-bizmodel/                # Business Model (20%)
├── hc-risk/                    # Risk Assessment (10%)
└── hc-synthesis/               # GO/NO-GO Synthesis
testing/                        # Suite de 10 ideas + protocolo + runs
calibration/                    # 13 escenarios de calibración de scoring
docs/                           # Documentación histórica y arquitectura
```

## Roadmap

Ver [ROADMAP.md](./ROADMAP.md) para el plan estratégico completo.

## Licencia

MIT

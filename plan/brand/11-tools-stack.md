# 11 — Stack de Tools

## 11.1 Propósito

Documentar cada tool/API/skill que Brand usa, con justificación explícita. Stack 100% gratis a excepción de la suscripción de Claude Pro del user final (requerida para Claude Design downstream).

**Principio de decisión**: agregar una herramienta cuando existe una operación genuinamente distinta, o un diferencial de calidad grande. No agregar "porque es mejor marginal".

## 11.2 Stack completo

| Capacidad | Tool | Costo | Setup |
|---|---|---|---|
| Persistencia + memoria | Engram MCP | Free | Ya instalado |
| Web search general | open-websearch MCP | Free | Ya instalado |
| PDF generation | `ms-office-suite:pdf` skill | Free | Ya disponible |
| Domain availability | `imprvhub/mcp-domain-availability` | Free | `uvx` one-liner |
| Trademark screening | open-websearch sobre USPTO TESS + WIPO Global Brand Database | Free | — |
| Mood imagery references | Unsplash free API | Free (commercial-safe con attribution) | API key gratis |
| Logo SVG generation | Claude native | Incluido en subscription | — |
| Palette generation | Claude native (color theory reasoning) | Incluido | — |
| Typography pairing | Claude native + Google Fonts catalog | Free | — |
| Claude reasoning | Claude Pro/Max/Team/Enterprise | Suscripción user | User account |
| **Downstream**: UI execution | **Claude Design** (claude.ai/design) | Incluido en Claude Pro+ | Cuenta Pro+ activa |

**Costo total del módulo por run: $0.00.** Único costo es la suscripción Claude Pro del user (requerida como gate por ser el downstream obligatorio).

## 11.3 Tools existentes (ya en Hardcore)

### Engram MCP
- **Uso**: persistencia cross-session, retrieval de Validation + Profile, snapshots pre-run, save de cada dept output
- **Justificación**: core del ecosystem Hardcore, ya usado por Validation y Profile
- **Reference**: `skills/_shared/engram-convention.md`
- **Consumo Brand**: ver `skills/_shared/brand-contract.md` para los topic keys que lee Brand

### open-websearch MCP
- **Uso**:
  - Trademark screening (Verbal Fase B): queries sobre USPTO TESS + WIPO Global Brand Database
  - Sentiment landscape derivation (Strategy, Gate 0): queries sobre sentiment en competitive landscape
  - Research general cuando Strategy necesita context de mercado adicional
- **Justificación**: existente, suficiente para screening preliminar y web research
- **Limitación**: no sustituye trademark search API profesional. Disclaimer obligatorio en la Verbal dept output: "Screening preliminar, no reemplaza asesoría legal".

### `ms-office-suite:pdf` skill
- **Uso**: generación del Brand Design Document PDF (Handoff Compiler)
- **Justificación**: skill existente, no necesitamos agregar librería
- **Fallback si falla**: Handoff Compiler entrega `.md` + instrucciones para conversión manual

## 11.4 Tools nuevas

### Claude native — SVG, palette, typography

**Uso**:
- **Logo dept**: wordmarks, lettermarks, simple combinations, abstract marks geométricos — todos via SVG markup generado por Claude
- **Visual System**: palette derivation (color theory + archetype seeds), typography pairing con Google Fonts catalog, mood principles en texto
- **Handoff Compiler**: templating del Brand Document, prompts library, tokens

**Justificación**:
- Claude escribe SVG markup válido directamente en el output, revisable y editable
- Zero cost — uses existing Claude subscription
- Resultado es texto (vector) — reproducible, versionable, sin binarios
- Quality suficiente para wordmarks y marks geométricos razonables

**Limitación**: abstract symbols orgánicos complejos son más difíciles de lograr con SVG directo. V1 sesga el logo primary form hacia wordmark/lettermark/geometric (ver 07-dept-logo.md). Casos que requieran ilustración compleja quedan fuera de scope v1.

**Implementation**: prompt templates con ejemplos + constraint list en `skills/brand/logo/references/svg-templates.md` (Sprint 0).

### `imprvhub/mcp-domain-availability`

**Uso**: Verbal Identity Fase B (domain verification) — chequear availability de 3-5 dominios candidatos por naming shortlist.

**Justificación**:
- 50+ TLDs cubiertos
- Verificación dual (DNS + WHOIS)
- Bulk checking (hasta ~12 candidatos simultáneos)
- Zero-clone install via `uvx`
- Free, sin API key

**Setup user** (necesario antes de Sprint 1):
1. `uvx --from imprvhub/mcp-domain-availability domain-mcp`
2. Configurar MCP en Claude Code settings (`.mcp.json`)

**Reference**: [imprvhub/mcp-domain-availability](https://github.com/imprvhub/mcp-domain-availability)

**Fallback si down**: skip verification, flag explícito en output (`"domain_availability_checked": false`), continuar pipeline sin bloquear.

### Unsplash free API — mood imagery references

**Uso**: Visual System (mood section) — fetch de 3-6 imágenes de referencia que inspiran el mood visual, NO para uso directo en brand assets. El Brand Document y Reference Assets folder citan estas imágenes con Unsplash URL + attribution string.

**Justificación**:
- Free API con tier demo usable sin infra
- Commercial use permitido con attribution (no viola ToS cuando Hardcore monetice)
- 5M+ fotos HD con curación decente
- API key gratis en minutos

**Setup user**: registrar app gratis en unsplash.com/developers, obtener `UNSPLASH_ACCESS_KEY`. Configurar en `.env`.

**Uso técnico**: queries construidas por Visual dept basadas en `mood_keywords` derivados del archetype + scope. Ej: "minimal, architectural, monochrome" → Unsplash API → top 3-6 resultados → URLs + attribution strings guardados en Brand outputs.

**Limitación**: solo 50 req/h en tier demo (más que suficiente; un run usa 3-6 queries). Tier production (5000 req/h) está a 1 click si alguna vez escala.

**Fallback si down**: skip mood imagery, Brand Document describe el mood en prosa sin imagery refs. Pipeline no se bloquea.

### Trademark screening — open-websearch sobre USPTO TESS + WIPO Global Brand Database

**Uso**: Verbal Identity Fase B — screening preliminar de conflictos de marca para top 3 naming candidates.

**Justificación**:
- USPTO TESS (Trademark Electronic Search System) es público y web-accesible, no requiere API key
- WIPO Global Brand Database es público y web-accesible, cubre >65 jurisdicciones
- open-websearch construye queries structured contra esas URLs y parsea resultados

**Implementación**: Verbal dept construye queries estandarizadas (ej. `site:tmsearch.uspto.gov "{name}"` y `site:branddb.wipo.int "{name}"`) y usa open-websearch para ejecutar. Matches se surface con link al registro público + disclaimer de que es screening preliminar.

**Limitación**: screening ≠ clearance legal. Brand output incluye disclaimer permanente: *"Trademark search is a preliminary signal, not legal clearance. Consult a trademark attorney before commercial launch."*

**Fallback si open-websearch down**: skip TM screening, flag `trademark_screened: false`, continuar con warning explícito al user.

## 11.5 Downstream: Claude Design (no es parte del stack técnico, pero es gate)

**Claude Design no es un tool en nuestro stack** — es el downstream layer donde el user ejecuta la identidad visual usando el Brand Design Document como input.

**Status (2026-04)**:
- Web app en `claude.ai/design` (lanzada 2026-04-17 por Anthropic Labs)
- Incluida en Claude Pro, Max, Team y Enterprise (NO disponible en Free)
- Acepta PDF, PowerPoint, screenshots, logos, codebases como input
- No expone API/MCP todavía; integrations anunciadas "over coming weeks"

**Nuestra dependencia**:
- V1: user hace handoff manual (upload del PDF Brand Design Document + paste de prompts de la Prompts Library + upload de Reference Assets)
- V2 (cuando Anthropic ship API/MCP): Handoff Compiler auto-invoca Claude Design sin intervención manual

**Gate en pre-flight**: el orchestrator verifica que el user tenga Claude Pro+ antes de arrancar. Sin subscription, halt con mensaje:

> *"Brand requires Claude Design access. Claude Design is available on Claude Pro, Max, Team, or Enterprise subscriptions. Upgrade at claude.ai/upgrade and re-run."*

## 11.6 Stack en formato dependency

```yaml
# Obligatorias
engram_mcp:
  required: yes
  already_setup: yes

open_websearch_mcp:
  required: yes
  already_setup: yes

pdf_skill:
  required: yes
  already_setup: yes

domain_availability_mcp:
  required: yes
  setup_user: uvx imprvhub/mcp-domain-availability
  install_time: ~2 min

unsplash_free_api:
  required: yes
  setup_user: register app at unsplash.com/developers (free, instant)
  env_var: UNSPLASH_ACCESS_KEY

claude_subscription:
  required: yes
  tier: Pro | Max | Team | Enterprise
  includes:
    - Claude Design access (downstream, mandatory)
    - Claude reasoning (SVG gen, palette, typography, copy)
```

## 11.7 Tool usage per depto

| Depto | Tools usados |
|---|---|
| Orchestrator | Engram |
| Scope Analysis (sub-agent) | Engram + Claude native |
| Strategy | Engram + Claude native + open-websearch (para sentiment derivation cuando competitive data es insuficiente) |
| Verbal Identity | Engram + Claude native + Domain MCP + open-websearch (para TM screening) |
| Visual System | Engram + Claude native + Unsplash free API (mood refs) |
| Logo & Key Visuals | Engram + Claude native (SVG) |
| Handoff Compiler | Engram + pdf skill + Claude native (templating) |

## 11.8 Cost summary

**Por run del módulo Brand: $0.00 en APIs externas.**

El único costo asociado es la suscripción Claude Pro+ del user, que es gate obligatorio (no facturable por Hardcore; es cuenta del user).

Ver [17-cost-and-timing.md](./17-cost-and-timing.md) para breakdown por dept + timing estimates.

## 11.9 Fallbacks si un tool está down

Ver [13-failure-modes.md](./13-failure-modes.md) para protocolo completo. Resumen:

| Tool down | Fallback |
|---|---|
| Engram | HALT — dependencia crítica, no hay workaround |
| Domain MCP | Skip verification, flag `domain_availability_checked: false`, continuar |
| open-websearch | Skip TM screening y sentiment derivation externa, flag explícito, continuar con heurísticas de Strategy |
| pdf skill | Entregar Brand Document como `.md`, instrucciones de conversión manual para el user |
| Unsplash | Skip mood imagery refs, Brand Document describe mood en prosa sin imágenes |

El pipeline nunca se bloquea por tool failure salvo Engram (sin persistencia no podemos continuar). Los fallbacks producen outputs degradados pero funcionales.

## 11.10 Tool version tracking

Cada run graba en el envelope `evidence_trace` la versión de cada tool usada para reproducibilidad:

```json
{
  "tool_versions": {
    "engram_mcp": "X.Y.Z",
    "open_websearch_mcp": "X.Y.Z",
    "domain_availability_mcp": "X.Y.Z",
    "unsplash_api_tier": "free-demo | free-production",
    "pdf_skill": "X.Y",
    "claude_model": "claude-opus-4-7"
  }
}
```

## 11.11 Cambios posibles post-v1

### Claude Design MCP/API (cuando Anthropic ship it)
- Integración automática Handoff → Claude Design
- Zero user friction
- Major upgrade del workflow
- Spec se actualiza en 08-dept-handoff-compiler.md sin romper outputs existentes

### USPTO TSDR API oficial (si algún día lo valoramos)
- API key gratis, 60 req/min
- Más estructurada que screening via open-websearch
- Opción solo si screening via web search resulta insuficiente en dogfooding

### Módulos futuros con capabilities nuevas
- Brand-Physical (packaging + print CMYK)
- Brand-Motion (animations, video)
- Brand-Sonic (audio identity)

Estos son post-v1 y no afectan el stack actual.

## 11.12 Acceptance criteria del stack (para Sprint 1)

- [ ] Engram ya funcional (compartido con Validation y Profile)
- [ ] open-websearch ya funcional
- [ ] pdf skill testeada emitiendo un Brand Document sample
- [ ] Domain availability MCP instalado y testeado con 3-5 dominios
- [ ] Unsplash API key configurada en `.env`
- [ ] Claude Design account accesible (user tiene Pro+ activo) y testeado manualmente subiendo un PDF sample al design system setup
- [ ] Trademark screening ejecutable via open-websearch (USPTO TESS + WIPO Global Brand Database URLs responden)
- [ ] Failure mode tests pasando para cada tool (simular each-one-down)

# 11 — Stack de Tools (Tier-based)

## 11.1 Propósito

Documentar cada tool/API/skill que Brand usa, con justificación explícita. Claude Design como downstream, image generation en 3 tiers para cost control.

**Principio de decisión**: agregar una herramienta cuando existe una operación genuinamente distinta, o un diferencial de calidad grande. No agregar "porque es mejor marginal".

## 11.2 Stack por tier

### Tier 0 — DEFAULT (zero cost)

Para: dogfooding, early stage, vos mismo usando Hardcore.

| Capacidad | Tool | Costo |
|---|---|---|
| Persistencia memoria | Engram MCP | Free |
| Web search (TM screening) | open-websearch MCP | Free |
| PDF generation | `ms-office-suite:pdf` skill | Free |
| Domain availability | `imprvhub/mcp-domain-availability` | Free |
| Logo SVG generation (wordmarks) | Claude native | Free |
| Palette generation | Claude native (color theory reasoning) | Free |
| Typography pairing | Claude native + Google Fonts catalog | Free |
| Mood imagery | **Skipped** (usa description en Brand Document) | Free |
| Claude reasoning | Claude subscription | Included |
| **Downstream execution** | **Claude Design** (requires Pro/Max/Team/Enterprise) | Included in subscription |

**Total cost/run: ~$0.00**

### Tier 1 — Leveled up (cuando scope lo requiere o user opta)

Agrega (vs Tier 0):

| Capacidad | Tool | Costo |
|---|---|---|
| Symbolic logo generation | **Recraft V4** via `merlinrabens/image-gen-mcp-server` | $0.04/img × 3-5 = $0.12-0.20 |
| Mood imagery references | **Unsplash API** (free 50req/h demo) | Free |
| Palette ML | **Huemint API** (free non-commercial) | Free en early stage |

**Total cost/run: ~$0.10-0.20**

**Cuándo se activa**:
- Auto-elevation: `scope.logo_primary_form: symbolic-first` o `icon-first`
- User override: `/brand:new --tier=1`

### Tier 2 — Premium

Agrega (vs Tier 1):

| Capacidad | Tool | Costo |
|---|---|---|
| Logo completo via Recraft | Recraft V4 para todos los logos + variants + derivations | $0.04 × 10-20 = $0.40-0.80 |
| Mood imagery generated | Recraft V4 | $0.04 × 6-8 = $0.24-0.32 |
| Huemint paid tier | Commercial license | ~$10-50/mo estimated |

**Total cost/run: ~$0.40-0.80 + subscription Huemint**

**Cuándo se activa**: user override `/brand:new --tier=2`

## 11.3 Tools existentes (ya en Hardcore)

### Engram MCP
- **Uso**: persistencia cross-session, retrieval de Validation + Profile
- **Justificación**: core del ecosystem Hardcore
- **Reference**: `skills/_shared/engram-convention.md`

### open-websearch MCP
- **Uso**: trademark screening (Verbal Fase B Paso 4)
- **Justificación**: existente en el repo, suficiente para screening preliminar
- **Limitación**: no sustituye trademark search API profesional (disclaimer obligatorio)

### `ms-office-suite:pdf` skill
- **Uso**: generación del Brand Design Document PDF (Handoff Compiler Paso 2)
- **Justificación**: skill existente, no hay necesidad de agregar otro tool

## 11.4 Tools nuevas — Tier 0

### Claude native SVG generation (logo + mood description)

**Uso**: Logo dept (wordmarks y simple combinations), Visual dept (palette reasoning, typography, principles).

**Justificación**:
- Claude escribe SVG markup válido directamente
- Zero cost — uses existing Claude subscription
- Editable output (SVG is text)
- Sufficient quality para wordmarks y simple geometric marks

**Limitación**: complex abstract symbols son más difíciles — Tier 1+ usa Recraft para symbolics.

**Implementation**: prompt structure con ejemplos + templates (see `skills/brand/logo/references/claude-svg-templates.md` a escribir en Sprint 0).

### `imprvhub/mcp-domain-availability`

**Uso**: Verbal Identity Fase B Paso 3 (domain verification).

**Justificación**:
- 50+ TLDs
- Verificación dual (DNS + WHOIS)
- Bulk checking (10-12 candidatos simultáneos)
- Zero-clone install via `uvx`
- Free, sin API key

**Setup user** (necesario antes de Sprint 1):
1. `uvx --from imprvhub/mcp-domain-availability domain-mcp`
2. Configurar MCP en Claude Code settings

**Reference**: [imprvhub/mcp-domain-availability](https://github.com/imprvhub/mcp-domain-availability)

## 11.5 Tools Tier 1

### Recraft V4 via `merlinrabens/image-gen-mcp-server`

**Uso** (Tier 1): logos simbólicos solo (cuando scope lo requiere).
**Uso** (Tier 2): todos los logos + mood imagery.

**Justificación Recraft V4**:
- **#1 en benchmarks de HuggingFace para logos** en 2026
- **SVG vector nativo** — crítico para logos editables
- Logo-specialized training + built-in brand styling tools
- Costo: $0.04/imagen — mismo rango que DALL-E 3 pero specialized

**Justificación MCP multi-provider**:
- Permite swap de providers via env vars sin cambiar código
- Mantiene flexibilidad si en futuro queremos Flux 2 Pro para mood específico

**Setup user** (necesario solo si elevates a Tier 1+):
1. Crear cuenta en platform.recraft.ai
2. Obtener API key ($10-20 de crédito inicial alcanza)
3. Install: `npm install -g @merlinrabens/image-gen-mcp-server` (o similar)
4. Env: `RECRAFT_API_KEY` + `IMAGE_GEN_PROVIDER=recraft`

**Reference**: [merlinrabens/image-gen-mcp-server](https://github.com/merlinrabens/image-gen-mcp-server)

### Unsplash API

**Uso** (Tier 1): mood imagery references curated.

**Justificación**:
- 5M+ fotos HD
- Free tier: 50 req/h demo, 5000 req/h production
- No API key needed para demo tier (hack: direct public URLs)
- Attribution fácil de documentar

**Setup user**: no mandatory setup (direct URL fetching funciona). Si scale high, register app.

**Alternativa**: Pexels API (similar, no attribution display required).

### Huemint API

**Uso** (Tier 1+): palette ML generation.

**Justificación**:
- ML-based (Transformer + Diffusion)
- Modo "brand-intersection" específico para branding
- API HTTP simple — no MCP needed
- Free para uso non-commercial

**Setup user**: no API key para free tier.

**Consideración license**: free tier es non-commercial. Para launch comercial requiere upgrade (ver [22-open-decisions.md](./22-open-decisions.md)).

**Reference**: [huemint.com](https://huemint.com/)

## 11.6 Tools Tier 2 (premium)

Mismas que Tier 1 pero con:
- Huemint paid tier (commercial license)
- Recraft V4 usado para mood imagery + logos wordmark además de symbolic
- Mayor budget de image generations

## 11.7 Downstream: Claude Design (no en nuestro stack técnico, pero crítico)

**Claude Design no es un tool en nuestro stack**. Es el downstream layer que consume nuestro output.

**Status en 2026-04**:
- Web app en `claude.ai/design`
- Incluido en Pro/Max/Team/Enterprise subscriptions
- No expone API/MCP actualmente (Anthropic anunció integrations "coming in weeks")

**Nuestra dependencia**:
- V1: user hace handoff manual (upload PDF, paste prompts)
- V2 (cuando Anthropic ship API): Handoff Compiler auto-invoca Claude Design

## 11.8 Stack summary en formato dependency

```yaml
# Tier 0 (default) — all that's strictly needed
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
  required: yes (for naming verification)
  setup_user: uvx imprvhub/mcp-domain-availability

claude_subscription:
  required: yes
  includes: Claude Design access (downstream), reasoning, SVG generation

# Tier 1 — user opts in or scope requires
recraft_via_image_gen_mcp:
  required_if: tier >= 1 AND scope requires symbolic logo
  setup_user: Recraft account + API key + npm MCP install

unsplash_api:
  required_if: tier >= 1 AND scope requires mood imagery
  setup_user: none (free tier direct URL access)

huemint_api:
  required_if: tier >= 1 AND palette ML wanted
  setup_user: none (non-commercial free)

# Tier 2 — premium
recraft_full_usage:
  required_if: tier == 2
  setup_user: same as Tier 1 + higher credit budget

huemint_paid:
  required_if: tier == 2 AND commercial launch
  setup_user: contact Huemint for commercial license
```

## 11.9 Tool usage per depto

| Depto | Tier 0 tools | Tier 1 tools (additive) | Tier 2 tools (additive) |
|---|---|---|---|
| Orchestrator | Engram | — | — |
| Scope Analysis (inline) | Engram + Claude native | — | — |
| Strategy | Engram + Claude native | — | — |
| Verbal Identity | Engram + domain MCP + open-websearch + Claude native | — | — |
| Visual System | Engram + Claude native (palette + type) | + Huemint (palette ML) + Unsplash (mood refs) | + Recraft (mood generated) + Huemint paid |
| Logo & Key Visuals | Engram + Claude native (SVG) | + Recraft (symbolic) | + Recraft everywhere |
| Handoff Compiler | Engram + pdf skill + Claude native (templating) | — | — |

## 11.10 Total cost per run (resumen)

Ver [17-cost-and-timing.md](./17-cost-and-timing.md) para breakdown detallado.

Resumen:
- **Tier 0**: ~$0.00/run
- **Tier 1**: ~$0.10-0.20/run
- **Tier 2**: ~$0.40-0.80/run

## 11.11 Fallbacks si un tool está down

Ver [13-failure-modes.md](./13-failure-modes.md). Summary:

| Tool down | Fallback |
|---|---|
| Domain MCP | Skip verification, warn user |
| open-websearch | Skip TM screening, flag |
| pdf skill | Deliver package con markdown brand-book.md instead |
| Recraft (Tier 1+) | Degrade to Claude native (Tier 0 behavior) |
| Unsplash (Tier 1) | Skip mood imagery, use Brand Document description only |
| Huemint (Tier 1+) | Fallback to Claude-generated palette |

## 11.12 Tool version tracking

Cada run graba en `evidence_trace`:

```json
{
  "tool_versions": {
    "tier_used": 0,
    "recraft_model": null,
    "huemint_api": null,
    "unsplash_api": null,
    "domain_availability_mcp": "2.1.0",
    "pdf_skill": "1.2",
    "claude_model": "claude-opus-4-7"
  }
}
```

## 11.13 Cambios posibles post-v1

### Candidatos para v2

**Claude Design MCP** (when Anthropic ship it):
- Integración automática de Handoff → Claude Design
- Zero user friction
- Major upgrade del workflow

**Ideogram 3.0** para wordmarks text-heavy:
- Solo si detectamos Recraft V4 wordmarks subpar en casos específicos
- Costo adicional ~$0.04/img

**USPTO TSDR API** para rigor legal:
- Cuando Hardcore tenga users pagos
- API key gratis, 60 req/min

**Módulos futuros con capabilities nuevas**:
- Brand-Physical (packaging + print CMYK)
- Brand-Motion (after-effects templates)
- Brand-Sonic (Suno/Stable Audio integration)

## 11.14 Acceptance criteria del stack (para Sprint 1)

### Tier 0 readiness
- [ ] Domain availability MCP installed + tested
- [ ] Claude Design account accessible (for testing downstream workflow)
- [ ] pdf skill functional
- [ ] open-websearch tested for TM queries
- [ ] Failure mode tests Tier 0

### Tier 1 readiness (if user opts in)
- [ ] Recraft account + API key
- [ ] Image gen MCP installed
- [ ] Unsplash API accessible
- [ ] Huemint API accessible
- [ ] Failure mode tests Tier 1

### Downstream integration (Claude Design manual v1)
- [ ] Brand Design Document PDF upload tested en Claude Design onboarding
- [ ] Prompts Library usable en Claude Design chat
- [ ] Brand Tokens folder recognized when linked (if user tests codebase linking)
- [ ] Reference Assets subibles como visual references

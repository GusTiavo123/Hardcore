# 11 — Stack de Tools

## 11.1 Propósito

Documentar cada tool/API/skill que el módulo Brand usa, con justificación explícita de por qué esa y no otra.

**Principio de decisión**: "agregar una herramienta cuando existe una operación genuinamente distinta, o un diferencial de calidad grande. No agregar porque es mejor marginal para su nicho."

## 11.2 Resumen del stack

| Capacidad | Tool | Tipo | Costo | Quién lo usa |
|---|---|---|---|---|
| Persistencia memoria | Engram MCP | Existing | Free | Orchestrator + todos los deptos |
| Web search general | open-websearch MCP | Existing | Free | Verbal (TM screening) |
| PDF generation | `ms-office-suite:pdf` skill | Existing | Free | Activation |
| UI generation | Stitch MCP | **Nuevo** | Free 350/mes | Activation |
| Image generation (logos + mood) | Recraft V4 via `merlinrabens/image-gen-mcp-server` | **Nuevo** | $0.04/img | Visual, Logo |
| Color palette ML | Huemint API | **Nuevo** (HTTP directo) | Free non-commercial | Visual |
| Domain availability | `imprvhub/mcp-domain-availability` | **Nuevo** | Free | Verbal |
| Claude native (reasoning, NL) | N/A | Existing | — | Todos |

## 11.3 Tools existentes (ya en Hardcore)

### Engram MCP
- **Uso**: persistencia cross-session, retrieval de Validation + Profile
- **Justificación**: core del ecosistema Hardcore, no se cuestiona
- **Reference**: existing `skills/_shared/engram-convention.md`

### open-websearch MCP
- **Uso**: trademark screening (Verbal Identity Fase B Paso 4)
- **Justificación**: existente en el repo, suficiente para screening preliminar
- **Limitación**: búsqueda web no sustituye trademark search API profesional (disclaimer obligatorio)

### `ms-office-suite:pdf` skill
- **Uso**: generación del brand book PDF (Activation Paso 4)
- **Justificación**: skill existente disponible en el harness, no hay necesidad de agregar otro tool
- **Alternativa considerada**: Pandoc + LaTeX — rejected porque más complejo, requires setup, el skill nativo es suficiente

## 11.4 Tools nuevas (a agregar al stack)

### Stitch MCP (`@_davideast/stitch-mcp`)

**Uso**: generación de UI (landing pages, social post templates, email templates, pitch deck cover) en Activation.

**Justificación**:
- Google Stitch es estado del arte en 2026 para UI generation
- Gemini 3 Flash / 3.1 Pro — mejor que lo que podríamos construir con templates HTML manuales
- MCP oficial para Claude Code — integration natural
- 350 generations/mes free tier (suficiente para 50+ runs de Brand)
- Output: HTML + CSS + Tailwind + React + Figma export — todos los formatos que necesitamos
- DESIGN.md mechanism permite inyectar nuestras decisiones de marca

**Trade-off aceptado**: dependencia de servicio externo Google Labs. User decidió Opción B (full-send sin hedge) — ver [22-open-decisions.md](./22-open-decisions.md).

**Setup requerido** (user debe hacer en su entorno):
1. `npx @_davideast/stitch-mcp init`
2. Autenticar con cuenta Google
3. Configurar MCP server en Claude Code settings

**Ubicación en pipeline**: Paso 2 de Activation

**Alternativas consideradas y rechazadas**:
- Build HTML templates manualmente — lower quality, más maintenance, pierde wow factor
- v0 (Vercel) — similar but less integrated with Claude Code ecosystem
- Figma AI — más design-focused pero no genera código deployable

**Reference docs**:
- Setup guide: [sotaaz.com/post/stitch-mcp-guide-en](https://www.sotaaz.com/post/stitch-mcp-guide-en)
- GitHub: [davideast/stitch-mcp](https://github.com/davideast/stitch-mcp)
- 7 open skills: [google-labs-code/stitch-skills](https://github.com/google-labs-code/stitch-skills)

### Recraft V4 via `merlinrabens/image-gen-mcp-server`

**Uso**: 
- Visual System: mood imagery generation (6-8 images por run)
- Logo: logo generation (4-5 concepts + variants + derivations)

**Justificación de Recraft V4**:
- **#1 en benchmarks de HuggingFace para logos en 2026**
- **SVG vector nativo** — esto es crítico. SVG editables, escalables, permanent; PNG raster es artefacto muerto para un logo
- Logo-specialized training (built-in brand styling tools)
- Costo: $0.04/imagen — mismo rango que DALL-E 3 pero specialized

**Justificación del MCP multi-provider** (vs dedicated Recraft MCP):
- `merlinrabens/image-gen-mcp-server` soporta múltiples providers via env vars
- Permite swap sin cambiar código si en futuro queremos Flux 2 Pro o Ideogram para casos específicos
- Mantener flexibilidad arquitectónica

**Setup requerido** (user):
1. Crear cuenta en Recraft (platform.recraft.ai)
2. Obtener API key
3. Instalar MCP server: `npm install -g @merlinrabens/image-gen-mcp-server` (o similar command per README)
4. Configurar env var `RECRAFT_API_KEY` y `IMAGE_GEN_PROVIDER=recraft`

**Alternativas consideradas y rechazadas**:
- DALL-E 3 — older (2023), raster only (vs SVG), less logo-specialized
- Flux 2 Pro — excellent for photorealism but overkill + no native SVG
- Ideogram 3.0 — best for text rendering but overlap con Recraft para wordmarks
- Midjourney — no API real, no viable

**Costo estimado por run**:
- Mood imagery: 6-8 images × $0.04 = $0.24-0.32
- Logo concepts: 4-5 × $0.04 = $0.16-0.20
- Logo variants: 3-4 × $0.04 = $0.12-0.16
- Logo derivations: 4-8 × $0.04 = $0.16-0.32 (si app icon full set es más)
- **Total Recraft per run: $0.50-1.00**

**Reference docs**:
- Recraft V4 specs: [recraft.ai](https://www.recraft.ai/)
- MCP server: [merlinrabens/image-gen-mcp-server](https://github.com/merlinrabens/image-gen-mcp-server)

### Huemint API

**Uso**: palette generation ML-powered (Visual System Paso 2).

**Justificación**:
- ML-based (Transformer AI + Diffusion AI models) — estado del arte para palettes
- Modo "brand-intersection" específicamente optimizado para branding
- Free tier para uso non-commercial (para v1 dogfooding + pre-launch funciona)
- HTTP API simple — no MCP necesario
- Permite seed colors + palette completion

**Uso específico**:
- Endpoint: `POST https://api.huemint.com/color`
- Input: mode + seed colors + config
- Output: 3-5 palettes completas

**Alternativas consideradas y rechazadas**:
- Colormind API — pre-LLM era, less sophisticated ML
- TheColorAPI — color theory math, no ML
- Adobe Color — no clean public API
- Manual palette from Claude — OK como fallback pero less rigorous

**Consideración de licencia**: free tier es "non-commercial". Para Hardcore commercial launch, necesitaremos:
- Upgrade a paid tier de Huemint, o
- Fallback a Claude-generated palettes en modo commercial (documentado en failure modes)
- Revisit en [22-open-decisions.md](./22-open-decisions.md)

**Setup requerido**: no API key necesaria para free tier. HTTP request directo.

**Reference docs**:
- API docs: [colormind.io/api-access](http://colormind.io/api-access/) (Colormind también tiene API — fallback option)
- Huemint: [huemint.com](https://huemint.com/)

### `imprvhub/mcp-domain-availability`

**Uso**: verificación de disponibilidad de dominios (Verbal Identity Fase B Paso 3).

**Justificación**:
- 50+ TLDs soportados
- Verificación dual (DNS + WHOIS) — más robusta que una sola
- Bulk checking (10-12 candidatos simultáneos)
- Smart suggestions cuando un dominio está tomado
- Zero-clone install via `uvx`
- Free, sin API key

**Setup requerido** (user):
1. `uvx --from imprvhub/mcp-domain-availability domain-mcp` (o install method per README)
2. Configurar MCP en Claude Code settings

**Alternativas consideradas y rechazadas**:
- `vinsidious/whodis-mcp-server` — less comprehensive
- `patrickdappollonio/domaintools-whois-dns` — complex setup
- Manual DNS + curl — functional pero requiere build propio
- Namecheap / Domainr commercial APIs — cost + overkill

**Reference docs**:
- [imprvhub/mcp-domain-availability](https://github.com/imprvhub/mcp-domain-availability)

## 11.5 Stack summary en formato dependency

```yaml
# Existing (no new setup needed)
engram_mcp:
  required: yes
  already_setup: yes

open_websearch_mcp:
  required: yes
  already_setup: yes

pdf_skill:
  required: yes
  already_setup: yes

# New — user must setup before Sprint 1 implementation
stitch_mcp:
  required: yes
  setup_user:
    - create Google account
    - npx @_davideast/stitch-mcp init
    - configure in Claude Code settings
  free_tier_limit: 350 generations/month
  cost_commercial: $10-15/month when exits Labs (estimated Q4 2026)

image_gen_mcp:
  required: yes
  provider: recraft
  setup_user:
    - create account on platform.recraft.ai
    - obtain API key
    - install merlinrabens/image-gen-mcp-server
    - configure env: RECRAFT_API_KEY, IMAGE_GEN_PROVIDER=recraft
  cost_per_image: $0.04
  cost_per_brand_run: $0.50-1.00

huemint_api:
  required: yes
  setup_user: none (HTTP direct)
  license: free non-commercial (revisit for commercial)
  commercial_consideration: upgrade path pending

domain_availability_mcp:
  required: yes
  setup_user:
    - install via uvx: uvx imprvhub/mcp-domain-availability
    - configure in Claude Code
  cost: free
```

## 11.6 Tool usage per depto (resumen)

| Depto | Tools usadas |
|---|---|
| Orchestrator | Engram |
| Scope Analysis (inline) | Engram + Claude native |
| Strategy | Engram + Claude native |
| Verbal Identity | Engram + `imprvhub/mcp-domain-availability` + open-websearch + Claude native |
| Visual System | Engram + Huemint API + Recraft V4 (via image-gen MCP) + Claude native |
| Logo & Key Visuals | Engram + Recraft V4 (via image-gen MCP) + Claude native |
| Activation | Engram + Stitch MCP + `ms-office-suite:pdf` + Claude native |

## 11.7 Total cost per run

Ver [17-cost-and-timing.md](./17-cost-and-timing.md). Resumen: **~$0.50-1.00 por run** dependiendo del scope (app icon full set vs no eleva costo).

## 11.8 Fallbacks si un tool está down

Ver [13-failure-modes.md](./13-failure-modes.md) para protocolo completo. Summary:

| Tool down | Fallback |
|---|---|
| Stitch MCP | Manual HTML templates (degraded quality, flagged en output) |
| Recraft / image-gen MCP | Skip generations afectadas, flag en output, user puede `/brand:extend` después |
| Huemint API | Claude-generated palette con color theory principles |
| Domain MCP | Skip verification, warn user explícitamente |
| open-websearch | Skip TM screening, flag "TM not verified en este run" |

## 11.9 Tool version tracking

Cada run graba en `evidence_trace`:

```json
{
  "tool_versions": {
    "stitch_mcp": "0.3.2",
    "image_gen_mcp": "1.0.5",
    "recraft_model": "v4",
    "huemint_api": "v1 (2026-04)",
    "domain_availability_mcp": "2.1.0"
  }
}
```

Para reproducibility futura: si un run necesita ser reproducido, tool versions permiten detectar breaking changes.

## 11.10 Cambios posibles en el stack post-v1

### Candidatos para v2

**Ideogram 3.0** para wordmarks text-heavy
- Si detectamos que Recraft V4 genera wordmarks con mala tipografía en casos específicos
- Ideogram es best in class para text rendering
- Costo adicional ~$0.04/img

**Flux 2 Pro** para fotorealismo si aparece demand
- Si futuros módulos (Brand-Physical, Product-Mockups) necesitan fotorealism
- Complementario a Recraft (specialized), no reemplaza

**USPTO TSDR API** si se comercializa
- Cuando Hardcore tenga usuarios pagos y legal rigor matters más
- Obtener API key (gratis pero rate-limited 60/min)
- Integrar como supplement al open-websearch screening preliminar

**Motion design tool** (future módulo Brand-Motion)
- Runway, Kaiber, otros — cuando querramos agregar motion
- Out of scope v1

**Audio AI** (future módulo Brand-Sonic)
- Suno, Stable Audio, otros — cuando querramos agregar sonic branding
- Out of scope v1

## 11.11 Acceptance criteria del stack (para Sprint 1)

Antes de declarar "stack ready", verificar:

- [ ] Stitch MCP installed + authenticated + tested con request básico
- [ ] Recraft API key funcional + image gen MCP installed + tested con request básico
- [ ] Huemint API HTTP accesible (curl test)
- [ ] Domain availability MCP installed + tested
- [ ] Todos los MCPs registrados en Claude Code settings
- [ ] Tool versions documented en AUDIT.md template
- [ ] Failure mode tests pasaron (ver [14-testing-strategy.md](./14-testing-strategy.md))

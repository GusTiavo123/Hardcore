# 20 — Ecosystem Integration

## 20.1 Propósito

Cómo Brand se conecta con el resto del ecosistema Hardcore + con Claude Design downstream.

Claude Design es el downstream layer explícito. Módulos futuros consumen via brand-contract.md.

## 20.2 Upstream dependencies

### Validation module (obligatorio)

**Qué Brand consume**:
- `validation/{idea-slug}/report` — verdict, scores, flags
- `validation/{idea-slug}/problem` — target audience, pain points
- `validation/{idea-slug}/market` — SOM, segmentos, geografías
- `validation/{idea-slug}/competitive` — incumbents, gaps, white space
- `validation/{idea-slug}/bizmodel` — pricing, revenue model
- `validation/{idea-slug}/risk` — timing, regulatory
- `validation/{idea-slug}/synthesis` — verdict + scores

**Cuándo falla sin Validation**: cannot run — mandatory.

### Profile module (opcional)

**Qué Brand consume**:
- `profile/{user-slug}/core`
- `profile/{user-slug}/extended`

**Mapping fields → usage**: ver tabla en [01-overview-and-architecture.md#17](./01-overview-and-architecture.md#17).

**Cuando falta**: backward compatible, flag `decided_without_profile: true`.

## 20.3 Downstream: Claude Design

**Claude Design es el PRIMARY downstream consumer** de nuestro output.

### Integración actual (manual — v1)

Flow:
```
1. Hardcore Brand generates package
2. User opens claude.ai/design
3. User uploads brand-design-document.pdf (design system setup)
4. Claude Design extracts design system
5. User validates + publishes
6. User copy-pastes prompts from prompts-for-claude-design.md into Claude Design projects
7. Claude Design generates deliverables with design system applied
8. Claude Design handoff bundle → Claude Code → deploy
```

### Integración futura (programmatic — v2)

Cuando Anthropic ship Claude Design MCP:

Flow:
```
1. Hardcore Brand generates package (same)
2. Handoff Compiler --auto-setup flag:
   - Invoke Claude Design MCP
   - Upload brand-design-document.pdf via API
   - Validate design system
   - Publish automatically
3. User optionally: ejecuta prompts via MCP (auto-run all required prompts)
4. Claude Design generates everything automatically
5. Output routed back to Hardcore for user review
6. User approves → Claude Design handoff to Claude Code → deploy
```

Architecture prepared: Handoff Compiler ya produce package en formato Claude Design-compatible. Solo falta agregar MCP invocation layer cuando API disponible.

### Dependency risk

Brand v1 depende fuertemente de Claude Design para execution. Si Claude Design:
- Cambia format expectations → update Brand Document template
- Aumenta pricing → affects user economics (Brand sigue funcional)
- Deprecada → fallback a manual path (Brand Document como brief para human designer)
- Expande capabilities → Brand puede aprovechar

**Mitigation**: Brand outputs son tool-agnostic en el core. Brand Design Document PDF, Tokens CSS/JSON, SVGs — todos son standard formats usables en cualquier tool.

## 20.4 Downstream: módulos futuros de Hardcore

Brand provee artifacts vía `skills/_shared/brand-contract.md` (a escribir en Sprint 0).

### Launch module (future)

**Consume**:
- `brand/{slug}/handoff` (package manifest + deliverables paths)
- Invoca Claude Design (vía MCP when available) para deploy microsite
- `verbal.core_copy.value_props` para meta tags

### GTM module (future)

**Consume**:
- `strategy.target_audience_refined`
- `strategy.voice_attributes`
- `verbal.core_copy.value_props` para A/B tests
- `visual.palette` + logo para ad creative

### Ops module (future)

**Consume**:
- `prompts_library` para set up email/WhatsApp templates en tools de operations
- `verbal.communications.bios` para consistency audit

### Future Brand Maintenance module

**Consume**: todo para monitor consistency over time.

## 20.5 Cross-module data flow

### Flujo canónico del user

```
/profile:new
  ↓ profile/{user-slug}/*

/validation:new "{idea}"
  ↓ validation/{idea-slug}/*
  ↓ Verdict GO/PIVOT

/brand:new
  ↓ brand/{idea-slug}/* (4 deliverables en output/{slug}/brand/)
  ↓ 
[Claude Design — user-mediated v1, auto v2]
  ↓ Design system + UI generations
  ↓ Handoff bundle → Claude Code → deploy

Future:
/launch:new
  ↓ Consumes brand + validation
  ↓ Orchestrates launch (deploy, PR, social)
```

### Dependency graph

```
                   profile/{user-slug}/*
                            ↓
                            ↓
                            ↓
validation/{idea-slug}/* → brand/{idea-slug}/* → Claude Design (downstream)
                            ↓                            ↓
                            ↓                     Claude Code → deploy
                            ↓
                            ↓ → launch/{idea-slug}/* (future)
                            ↓ → gtm/{idea-slug}/* (future)
                            ↓ → ops/{idea-slug}/* (future)
```

## 20.6 Shared conventions

Brand aligns con `skills/_shared/` conventions existentes:

| Convention | Brand compliance |
|---|---|
| `output-contract.md` | Brand envelope: schema_version, status, department, executive_summary, data, evidence, artifacts, flags, next_recommended |
| `scoring-convention.md` | N/A (Brand tiene coherence gates, no scoring) |
| `engram-convention.md` | Topic key pattern `brand/{slug}/{artifact}` |
| `persistence-contract.md` | Requires Engram. Filesystem para deliverables |
| `department-protocol.md` | Deptos follow sub-agent launch pattern |
| `glossary.md` | Brand agrega terms (archetype, voice_attributes, brand_profile, tier, etc.) — extendido en Sprint 0 |
| `profile-contract.md` | Brand es consumer de profile |

Nuevo convention:
- `brand-contract.md` — how future modules consume Brand (paralelo a profile-contract)

## 20.7 Configuration management

### CLAUDE.md updates (Sprint 0)

CLAUDE.md (project instructions) debe updatearse:
- Section "How to Brand an Idea" (paralelo a "How to Validate" y "How to Build a Founder Profile")
- Brand commands table
- Brand departments
- How Brand integrates con Validation + Profile
- **Claude Design workflow section** (downstream)
- Brand persistence model

### Skills registration

New skills:
- `skills/brand/SKILL.md` (orchestrator)
- `skills/brand/strategy/SKILL.md`
- `skills/brand/verbal/SKILL.md`
- `skills/brand/visual/SKILL.md`
- `skills/brand/logo/SKILL.md`
- `skills/brand/handoff-compiler/SKILL.md`

Sub-agentes (no user-invocable directly).

### MCP configuration

Nuevos MCPs en `.mcp.json`:
- `imprvhub/mcp-domain-availability` (required Tier 0)
- `merlinrabens/image-gen-mcp-server` (required Tier 1+)

User setup necesario — ver [11-tools-stack.md](./11-tools-stack.md).

## 20.8 Backward compatibility

Brand NO rompe Validation ni Profile:
- Validation unchanged, readable by Brand
- Profile unchanged, readable by Brand
- New topic key namespace (`brand/*`)
- New skills subdirectory (`skills/brand/*`)

Existing tests continúan pasando.

## 20.9 Future extensibility

### Adding new brand profile

Edit `skills/brand/references/brand-profiles.md`. No code change — Scope Analysis picks up automatically.

### Adding new archetype

Edit `skills/brand/references/archetype-guide.md`.

### Adding new asset

Edit relevant reference matrix. Dept picks up based on scope.

### Adding new dept (future module)

Prefer separate módulos (`skills/brand-physical/`, etc.) vs extending Brand.

### Adding new tool

Edit `skills/brand/references/version-compatibility.md` + relevant SKILL.md.

### Integrating Claude Design MCP (when released)

Update Handoff Compiler con `--auto-setup` flag. No changes elsewhere.

**Design philosophy**: additive changes cheap, breaking changes require v2.

## 20.10 Documentation hierarchy

Para evitar duplication:

| Info tipo | Lives in |
|---|---|
| Module philosophy | `plan/brand/` (planning docs) |
| Canonical specs | `skills/brand/*/SKILL.md` |
| References | `skills/brand/references/` + `skills/brand/{dept}/references/` |
| User-facing | `CLAUDE.md` (section) + README del package + Brand Document PDF |
| Testing protocol | `testing/brand-PROTOCOL.md` |
| Test results | `testing/brand-runs/` |

## 20.11 Reference file a escribir en Sprint 0

- `skills/_shared/brand-contract.md` — consumption contract para módulos futuros
- `CLAUDE.md` section update con Brand module + Claude Design workflow

## 20.12 Testing integración

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Validation + Brand → Brand reads Validation correctly
2. Profile + Validation + Brand → Brand reads both
3. Brand sin profile → backward compatible con flags
4. Future module (mock Launch) reads Brand vía contract → works
5. CLAUDE.md coherent with other modules
6. Existing Validation + Profile tests continúan pasando
7. **Claude Design handoff**: Brand Document PDF uploadable + extractable
8. **Brand Tokens folder**: linkable a Claude Design codebase integration

## 20.13 The vision — Hardcore como sistema

**Profile** dice quién sos.
**Validation** dice si tu idea vale la pena.
**Brand** le da brief + prompts + tokens + assets para que **Claude Design** ejecute la identidad visual.
**Launch** (future) la deploya.
**GTM** (future) la comunica al mercado.
**Ops** (future) la opera día a día.

Hardcore no compite con Claude Design — lo alimenta con contexto que ningún otro workflow tiene. Profile + Validation = founder-specific + evidence-based context que Claude Design no puede generar por sí solo.

Ese es el moat real. Hardcore = **brand intelligence layer para Claude Design**, expandible a un full operational OS del founder.

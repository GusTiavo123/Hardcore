# 20 — Ecosystem Integration

## 20.1 Propósito

Cómo Brand se conecta con el resto del ecosistema Hardcore (Validation + Profile presentes, módulos futuros) para funcionar como parte de un sistema coherente, no como herramienta aislada.

## 20.2 Upstream dependencies

### Validation module (obligatorio)

**Qué Brand consume**:
- `validation/{idea-slug}/report` — verdict, scores, flags (para determinar si Brand puede correr)
- `validation/{idea-slug}/problem` — target audience real, pain points, user research
- `validation/{idea-slug}/market` — SOM, segmentos, geografías, CAGR (informa cultural_scope)
- `validation/{idea-slug}/competitive` — incumbents, gaps, moats, visual landscape del mercado
- `validation/{idea-slug}/bizmodel` — pricing model, unit economics (informa distribution en Scope Analysis, informa voice register)
- `validation/{idea-slug}/risk` — timing context, regulatory (puede informar archetype conservative vs disruptive)
- `validation/{idea-slug}/synthesis` — verdict + scores + cross-dept flags

**Cuándo Brand falla sin Validation**:
- NO PUEDE correr — obligatorio
- Error message: "Brand requiere Validation output. Run `/validation:new` primero."

**Si Validation se update después de Brand run**:
- Brand snapshot v1 preservado
- Flag staleness cuando módulo futuro lea Brand: "brand v1 was created against validation v1, current validation is v2"
- User puede `/brand:new` para regenerar con updated inputs (crea v2)

### Profile module (opcional)

**Qué Brand consume si existe**:
- `profile/{user-slug}/core` — identity, skills, resources, constraints
- `profile/{user-slug}/extended` — network, motivation, advantages, previous ventures

**Cómo Brand usa Profile**:

| Campo del profile | Usado en | Cómo |
|---|---|---|
| `identity.name` | Strategy (brand_values evidence), Verbal (personal bio) | Direct reference |
| `identity.languages` | Verbal (naming linguistic check, copy language) | Filter |
| `professional_background` | Strategy (archetype fit) | Compatibility matrix |
| `skills.domain_expertise` | Strategy (positioning — insider knowledge) | Evidence |
| `resources.capital` | Scope Analysis (stage inference) | Signal |
| `constraints.risk_tolerance` | Strategy (archetype fit) | Hard filter para Outlaw/Hero |
| `constraints.hard_nos` | Scope Analysis (block sensitive archetypes) | Filter |
| `network.audience` | Verbal (copy de founder-as-creator) | Context |
| `motivation.primary_goal` | Strategy (archetype fit) | Signal |
| `meta_signals` (if persisted) | Scope Analysis (cultural context) | Context |

**Cuándo Brand corre sin Profile**:
- Degrades gracefully (ver [19-edge-cases.md#brand-sin-profile](./19-edge-cases.md#brand-sin-profile))
- Flag `decided_without_profile: true`
- Personalization parcial
- README + brand book suggest creating profile

## 20.3 Downstream consumption (módulos futuros)

Brand produce artifacts que módulos futuros pueden consumir vía `skills/_shared/brand-contract.md` (ver [10-persistence-and-contracts.md](./10-persistence-and-contracts.md)).

### Launch module (future)

**Qué consumiría**:
- `brand/{slug}/activation.microsite` — para deploy automatizado
- `brand/{slug}/activation.brand_book_pdf` — para team onboarding
- `brand/{slug}/activation.social` — para schedule launch posts en platforms
- `brand/{slug}/verbal.press_release_boilerplate` — para outreach PR
- `brand/{slug}/verbal.sample_posts_*` — para seed social presence

**Flow example**:
```
User: /launch auren-compliance --platforms=linkedin,twitter,producthunt

Launch module:
  1. Read brand artifacts (contract)
  2. Deploy microsite to vercel (use brand.microsite/ + netlify.toml si disponible)
  3. Schedule 5 LinkedIn posts desde brand.communications.bios.linkedin-company + sample-posts
  4. Generate Product Hunt description desde brand.verbal.value_props + about
  5. Send PR draft a founder para approval
```

### Go-to-Market (GTM) module (future)

**Qué consumiría**:
- `brand/{slug}/strategy.target_audience_refined` — para audience targeting en ads
- `brand/{slug}/strategy.voice_attributes` — para ad copy consistency
- `brand/{slug}/verbal.value_props` — para A/B test variants
- `brand/{slug}/visual.palette` + `logo` — para ad creative
- `brand/{slug}/verbal.cta_copy` — para CTA variations

### Operations (Ops) module (future)

**Qué consumiría**:
- `brand/{slug}/verbal.email_templates` — para set up en email provider (Loops, Klaviyo, Customer.io)
- `brand/{slug}/verbal.whatsapp_templates` (si local) — para WhatsApp Business API setup
- `brand/{slug}/verbal.communications.bios` — para consistency audit en profiles existentes
- `brand/{slug}/verbal.faq_seed` — para chatbot / customer support KB

### Future "Brand Maintenance" module

**Conceptual**: ongoing brand consistency checking.

**Qué consumiría**:
- All brand artifacts
- Monitor other content (blog posts, emails sent, social posts) para consistency con voice attributes
- Flag drift del brand over time

## 20.4 Cross-module data flow

### El flujo canónico del user

Ordenar de forma natural:

```
User arrives → /profile:new
  ↓ Creates profile/{user-slug}/*
  
User has idea → /validation:new "{idea}"
  ↓ Runs validation pipeline
  ↓ Creates validation/{idea-slug}/*
  ↓ Verdict GO o PIVOT
  
User (optional) → /brand:new
  ↓ Reads profile + validation
  ↓ Creates brand/{idea-slug}/*
  ↓ Generates package
  
User (future) → /launch:new
  ↓ Reads brand + validation
  ↓ Deploys + orchestrates launch
  
User (future) → /gtm:new
  ↓ Reads brand + validation
  ↓ Generates ad campaigns
```

Cada paso **lee** pero no modifica los anteriores. Artifacts inmutables (via snapshots).

### Dependency graph

```
                     profile/{user-slug}/*
                              ↓
                              ↓
                              ↓
validation/{idea-slug}/* → brand/{idea-slug}/* → launch/{idea-slug}/* (future)
                              ↓
                              ↓
                              ↓
                              ↓ → gtm/{idea-slug}/* (future)
                              ↓
                              ↓ → ops/{idea-slug}/* (future)
```

## 20.5 Shared conventions

Brand aligns con existing `skills/_shared/` conventions:

| Existing convention | Brand compliance |
|---|---|
| `output-contract.md` | Brand output envelope has: schema_version, status, department, executive_summary, data, evidence, artifacts, flags, next_recommended |
| `scoring-convention.md` | N/A (Brand no tiene scoring en sentido Validation). Brand tiene coherence gates en su lugar |
| `engram-convention.md` | Brand usa topic_key pattern `brand/{slug}/{artifact}`. Follows naming + session lifecycle conventions |
| `persistence-contract.md` | Brand requires Engram. Optional file mode for debugging |
| `department-protocol.md` | Brand deptos follow sub-agent launch pattern con inputs + outputs schema |
| `glossary.md` | Brand adds its own terms (archetype, voice_attributes, brand_profile, etc.) — will extend glossary in Sprint 0 |
| `profile-contract.md` | Brand is a consumer of profile via this contract |

Nuevo convention que Brand introduce:
- `brand-contract.md` — how future modules consume Brand (paralelo a profile-contract)

## 20.6 Configuration management

### CLAUDE.md updates

CLAUDE.md (project instructions) debe updatearse en Sprint 0 para incluir:

- Section "How to Brand an Idea" (paralelo a existing "How to Validate an Idea" y "How to Build a Founder Profile")
- Brand commands table
- Brand departments
- How Brand integrates con Validation + Profile
- Brand persistence model

### Skills registration

New skills a registrar:
- `skills/brand/SKILL.md` (orchestrator)
- `skills/brand/strategy/SKILL.md`
- `skills/brand/verbal/SKILL.md`
- `skills/brand/visual/SKILL.md`
- `skills/brand/logo/SKILL.md`
- `skills/brand/activation/SKILL.md`

Estos skills no son user-invocable directamente (sub-agentes). El orchestrator los invoca.

### MCP configuration

Nuevos MCPs a agregar en `.mcp.json` o settings del user:
- Stitch MCP (`@_davideast/stitch-mcp`)
- Image Gen MCP (`@merlinrabens/image-gen-mcp-server`)
- Domain Availability MCP (`imprvhub/mcp-domain-availability`)

User setup required — ver [11-tools-stack.md](./11-tools-stack.md) para pasos.

## 20.7 Backward compatibility

Brand NO rompe Validation ni Profile.

- Validation artifacts: unchanged, readable by Brand
- Profile artifacts: unchanged, readable by Brand
- New topic key namespace (`brand/*`) — no collision
- New skills subdirectory (`skills/brand/*`) — no overlap con existing skills

Existing tests de Validation y Profile continúan pasando después de Brand implementation.

## 20.8 Future extensibility

Brand está diseñado para extenderse:

### Adding new brand profiles

Agregar a `skills/brand/references/brand-profiles.md`:
- New profile entry with its characteristics
- Expected signals for matching
- Output manifest defaults
- Intensity modifier defaults
- Archetype constraints

No cambio de code — just reference doc update. Scope Analysis picks it up automatically.

### Adding new assets

Agregar a `skills/brand/verbal/references/copy-asset-matrix.md` (o visual, o logo):
- New asset entry con condition rules (qué scopes lo necesitan)
- Generation template

Dept picks it up automatically based on scope manifest.

### Adding new tools

Agregar a `skills/brand/references/version-compatibility.md`:
- New tool + tested versions
- How it integrates

Update relevant dept SKILL.md con how to use.

### Adding new future modules

Document en `skills/_shared/brand-contract.md` cómo consume. Extensibility sin breaking changes.

## 20.9 Documentation hierarchy

Para evitar duplication + asegurar single source of truth:

| Info tipo | Lives in |
|---|---|
| Overall module philosophy | `plan/brand/` (planning docs, este directorio) |
| Canonical specs | `skills/brand/*/SKILL.md` |
| References (archetypes, profiles, etc.) | `skills/brand/references/` |
| User-facing docs | `CLAUDE.md` (section de Brand) + brand book PDF per run |
| Testing protocol | `testing/brand-PROTOCOL.md` |
| Results de tests | `testing/brand-runs/` |

## 20.10 Reference file a escribir en Sprint 0

- `skills/_shared/brand-contract.md` — consumption contract para módulos futuros
- `CLAUDE.md` section update con Brand module

## 20.11 Testing de integración

Ver [14-testing-strategy.md](./14-testing-strategy.md). Integration tests:

1. Validation run + Brand run → Brand reads Validation correctly
2. Profile run + Validation run + Brand run → Brand reads both correctly
3. Brand sin profile → backward compatible, runs with flags
4. Future module (mock Launch) reads Brand via contract → works
5. CLAUDE.md updates coherent, no contradicciones con Validation/Profile sections
6. Existing Validation + Profile tests continúan pasando con Brand in place

## 20.12 The vision — Hardcore como sistema

Brand no es un producto standalone. Es parte del arco completo:

**Profile** dice quién sos.
**Validation** dice si tu idea vale la pena.
**Brand** le da identidad ejecutable a esa idea.
**Launch** (future) la pone en el mundo.
**GTM** (future) la comunica al mercado.
**Ops** (future) la opera día a día.

Cada módulo independiente pero potenciado por los anteriores. Ese es el moat — no somos "otra herramienta AI", somos el sistema completo.

Brand v1 es un milestone crítico: cierra el arco "idea → marca" y habilita el launch de Hardcore mismo (dogfooding).

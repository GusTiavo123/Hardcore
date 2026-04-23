# 14 — Testing Strategy

## 14.1 Propósito

Cómo validar que Brand produce outputs correctos, robustos, y usables. Paralelo a `testing/PROTOCOL.md` de Validation.

Testing focus en los 4 deliverables + compatibility con Claude Design downstream.

## 14.2 El challenge fundamental

Validation tiene outputs fácilmente verificables (scores, verdicts, knockouts). **Brand no tiene ese tipo de ground truth**. No hay umbral objetivo para "buena marca" equivalente a "Problem ≥ 40". Por eso:

- **No hay knockouts numéricos de calidad** en Brand
- **No hay "≥ 7.5/10" como gate de shipping**
- **El shipping criterion es founder approval** — el founder/CEO revisa el output y decide si va
- **Lo automatizable son cosas estructurales** (envelope completo, gates binarios pass/fail, files parseables)
- **Lo subjetivo se trackea cualitativamente** (failure modes en lenguaje plano, no scores)

Esto es una decisión consciente: fingir un gate numérico donde la realidad es subjetiva crea false confidence. Preferimos honestidad.

## 14.3 Estrategia de testing — 6 capas

1. **Structural tests** (automated) — outputs completos y conforming al schema
2. **Coherence gate tests** (automated, binary) — los 9 gates pass o fallan; esto ES objetivo
3. **Scope-appropriateness tests** (semi-automated) — outputs correctos para el brand profile
4. **Claude Design compatibility tests** (manual) — PDF parseable por Claude Design downstream
5. **Qualitative review** (founder/CEO) — shipping criterion. Sin score numérico.
6. **Regression tests** (automated) — Brand no rompe Validation/Profile

Variance entre runs se trackea como dato (no como gate): útil para identificar inestabilidad pero no bloquea shipping.

## 14.4 Test suite

Nuevo archivo: `testing/brand-suite.yaml` (paralelo a `testing/suite.yaml`).

### Test ideas curadas (8 ideas, una por brand profile)

```yaml
version: "1.0"

brand_test_ideas:
  - id: "brand-test-b2b-enterprise"
    text: "Enterprise security platform for Fortune 500 financial institutions, providing real-time compliance monitoring across regulatory frameworks (SOX, GDPR, PCI-DSS)"
    expected_brand_profile: "b2b-enterprise"
    expected_archetype_range: ["Sage", "Ruler", "Hero"]
    required_outputs_include: ["pitch_deck_prompt", "case_study_prompt", "security_page_prompt"]
    must_skip: ["tiktok_bio", "app_icon_full_set"]

  - id: "brand-test-b2b-smb"
    text: "Software de facturación y gestión de cobros automatizado para freelancers de tecnología en LATAM, con integración tributaria MX/CO/AR"
    expected_brand_profile: "b2b-smb"
    expected_archetype_range: ["Sage", "Everyman", "Creator"]
    required_outputs_include: ["pricing_page_prompt", "linkedin_bio", "email_welcome_prompt"]
    must_skip: ["tiktok_bio", "pitch_deck_full"]

  - id: "brand-test-b2d-devtool"
    text: "CLI tool that auto-generates interactive API docs from TypeScript codebases, with team collaboration and hosted docs portal"
    expected_brand_profile: "b2d-devtool"
    expected_archetype_range: ["Creator", "Magician", "Sage", "Explorer"]
    required_outputs_include: ["github_readme_prompt", "docs_landing_prompt", "code_snippet_styling_prompt"]
    must_skip: ["pitch_deck_full", "tiktok_bio", "app_icon_full_set"]

  - id: "brand-test-b2c-consumer-app"
    text: "Mobile app para habit tracking con gamification, targeted a young professionals que quieren build routines"
    expected_brand_profile: "b2c-consumer-app"
    expected_archetype_range: ["Jester", "Hero", "Everyman", "Creator"]
    required_outputs_include: ["app_store_listing_prompt", "instagram_templates_prompt", "app_icon_full_set"]
    must_skip: ["pitch_deck_full", "case_study_prompt"]

  - id: "brand-test-b2c-consumer-web"
    text: "Web platform for curated vintage clothing resale"
    expected_brand_profile: "b2c-consumer-web"
    expected_archetype_range: ["Creator", "Lover", "Explorer"]
    required_outputs_include: ["instagram_templates_prompt", "newsletter_template_prompt", "referral_copy"]
    must_skip: ["app_icon_full_set", "pitch_deck_full"]

  - id: "brand-test-b2local-service"
    text: "Barbershop premium en Palermo, Buenos Aires"
    expected_brand_profile: "b2local-service"
    expected_archetype_range: ["Everyman", "Ruler", "Caregiver", "Sage"]
    required_outputs_include: ["whatsapp_templates", "google_my_business_copy", "printable_flyer_prompt"]
    must_skip: ["pitch_deck", "tiktok_bio", "developer_assets"]

  - id: "brand-test-content-media"
    text: "Weekly newsletter + podcast sobre product strategy y growth for startup founders LATAM"
    expected_brand_profile: "content-media"
    expected_archetype_range: ["Sage", "Creator", "Explorer"]
    required_outputs_include: ["podcast_cover_prompt", "newsletter_template_prompt", "social_post_series_prompt"]
    must_skip: ["pitch_deck_full", "pricing_page_formal"]

  - id: "brand-test-community-movement"
    text: "Comunidad online de mujeres founders tech en LATAM, Discord + eventos mensuales + mentoring 1:1"
    expected_brand_profile: "community-movement"
    expected_archetype_range: ["Hero", "Caregiver", "Rebel", "Everyman"]
    required_outputs_include: ["manifesto_opening", "symbolic_assets_prompt", "discord_branding_prompt"]
    must_skip: ["pricing_page_enterprise", "app_icon_full_set"]
```

### Dogfooding inicial — subset de 3 profiles

Los 8 tests arriba son el suite completo para coverage total. El dogfooding inicial (primeros runs reales) corre 3 profiles representativos:

- `brand-test-b2b-smb` — cubre el flujo "standard" SaaS
- `brand-test-b2c-consumer-app` — cubre el flujo consumer con app icon
- `brand-test-b2local-service` — cubre el flujo compacto / scope reducido

Los otros 5 se corren a medida que aparezcan casos reales o cuando se haga el pass completo de coverage.

## 14.5 Test categories

### Category 1 — Unit tests por dept (structural, automated)

**Scope Analysis**:
- [ ] B2B SaaS clara → `b2b-smb` confidence ≥ 0.8
- [ ] Consumer mobile app clara → `b2c-consumer-app` confidence ≥ 0.8
- [ ] Híbrida B2D + community → primary + secondary ambos con composition_weights
- [ ] Ambigua → `requires_user_confirmation: true`
- [ ] Local service → `b2local-service`
- [ ] Sin profile → proceeds con flag `decided_without_profile: true`
- [ ] User override respetado en re-invocación
- [ ] Output envelope schema-valid

**Strategy**:
- [ ] B2B SaaS + Sage-compatible profile + trust_heavy sentiment → Sage
- [ ] Consumer app + Explorer profile + disruption_ready sentiment → Explorer
- [ ] Sin profile → `decided_without_profile: true`, weight redistribution funciona
- [ ] Mismo input 2 runs → archetype consistent (variance tracking)
- [ ] Voice attributes derivadas del archetype + register
- [ ] Sentiment landscape derivation para varios contextos de market
- [ ] Voice precedence conflict resuelto correctamente con flag
- [ ] Output envelope schema-valid

**Verbal**:
- [ ] 15-20 candidatos inicial → 10-12 verified → top 5-7 presentados
- [ ] Naming: todos los TM red excluidos del top
- [ ] Scope b2b-smb prefiere descriptive
- [ ] Scope b2c-consumer-app prefiere short/memorable
- [ ] Copy: scope b2b-enterprise genera pitch deck cover copy, NO TikTok bio
- [ ] Voice self-check: assets exhibit voice detectably (Gate 7 lo agarra si no)
- [ ] Domain MCP integration functional
- [ ] TM screening via open-websearch functional
- [ ] Graceful degradation cuando Domain MCP o open-websearch down
- [ ] Output envelope schema-valid

**Visual**:
- [ ] Claude-generated palette + typography + mood queries
- [ ] Archetype Sage + formality medium → palette conservadora (sat 40-60)
- [ ] Archetype Jester + formality low → palette vibrant
- [ ] WCAG contrast check funciona (auto-adjust si falla)
- [ ] Typography pairing matchea archetype + typography_era
- [ ] Unsplash mood refs funcionan (con attribution)
- [ ] Graceful degradation cuando Unsplash down (skip mood refs)
- [ ] Output envelope schema-valid

**Logo**:
- [ ] `wordmark-preferred` scope → 4 SVG wordmarks válidos
- [ ] `combination` scope → mezcla wordmark + geometric
- [ ] `symbolic-first` scope → 3 geometric marks + 1 combination
- [ ] `icon-first` (consumer-app) → 4 marks que pasan 16px legibility
- [ ] Variants mono/inverse/icon-only via programmatic transform preservan structure
- [ ] Derivations (favicon, OG card, covers) rendean desde SVG source
- [ ] `app_asset_criticality: primary` → set completo iOS + Android
- [ ] User manual-upload path funciona
- [ ] Rasterization tool ausente → SVG-only con instrucciones manuales
- [ ] Output envelope schema-valid

**Handoff Compiler**:
- [ ] Brand Design Document PDF generado completo, page range correcto por profile
- [ ] Prompts Library markdown valid con prompts customizados al brand
- [ ] Brand Tokens: JSON/CSS/Tailwind/HTML parseables + valid
- [ ] Reference Assets folder structured per scope
- [ ] README.md accurate respecto a includes/skips
- [ ] AUDIT.md con full trace de 9 gates + flags + timestamps
- [ ] Output envelope schema-valid

### Category 2 — Coherence gate tests (automated, binary)

Los 9 gates son binarios — pasan o fallan. Tests inyectan inputs específicos para validar behavior:

- [ ] **G0**: archetype Outlaw + market trust_heavy → halt con surface al user
- [ ] **G0**: sentiment insufficient_data → `skipped_insufficient_data`, user decide
- [ ] **G1**: archetype Outlaw + profile risk_tolerance=conservative → halt
- [ ] **G1**: sin profile → `skipped_no_profile`
- [ ] **G2**: voice playful + archetype Sage → halt
- [ ] **G3**: palette neon + archetype Sage → halt
- [ ] **G4**: palette saturación 85 + visual_formality=high → halt
- [ ] **G5**: display script + archetype Ruler → halt
- [ ] **G6**: logo contrast 3.2:1 → halt (WCAG fail)
- [ ] **G7**: copy samples no exhiben voice attributes en 80% → halt
- [ ] **G8**: wordmark chosen + scope symbolic-first → halt
- [ ] User re-corre dept → gates re-evalúan desde cero, pass consistente
- [ ] User acepta con flag → flag persistido en AUDIT.md y brand book
- [ ] Criticality matrix influye el escalation UI (messaging correcto por profile)

### Category 3 — Scope-appropriateness tests (semi-automated)

Verify que cada scope produce los outputs apropiados:

- [ ] b2b-enterprise → incluye pitch deck prompt, case study template, security page
- [ ] b2b-smb → incluye pricing page, LinkedIn bio, email welcome
- [ ] b2d-devtool → incluye GitHub README, docs landing, code snippet styling
- [ ] b2c-consumer-app → incluye app store listing, Instagram templates, app icon full set
- [ ] b2c-consumer-web → incluye Instagram templates, newsletter template, referral copy
- [ ] b2local-service → incluye WhatsApp templates, Google My Business copy, flyer
- [ ] content-media → incluye podcast cover, newsletter template, social post series
- [ ] community-movement → incluye manifesto opening, symbolic assets, Discord branding
- [ ] Ningún profile incluye outputs de otro profile indebidamente (ej. b2b-enterprise no tiene TikTok bio)

### Category 4 — Claude Design compatibility tests (manual)

**Requieren Claude Pro subscription + una cuenta activa en claude.ai/design**:

- [ ] Brand Design Document PDF uploads a Claude Design "Set up your design system" sin errors
- [ ] Claude Design extrae design system correctamente:
  - Colors match la palette de Visual output
  - Typography match fonts de Visual output
  - Logo displayed correctamente
- [ ] Design system validated con test project produce output brand-consistent
- [ ] Prompts del Prompts Library pegados en Claude Design projects producen deliverables que matchean el brand
- [ ] Brand Tokens folder linkable como codebase funciona (si el user tests este path)
- [ ] Reference Assets uploadables como visual references

**Automated checks sobre los archivos output**:

- [ ] PDF no corrupto (opens en PDF readers standard)
- [ ] PDF tiene todas las secciones required según brand profile
- [ ] Prompts Library con estructura correcta (goal + layout + content + audience por prompt)
- [ ] Cada prompt customizado con brand name, palette HEX, voice

### Category 5 — Integration tests (end-to-end)

**Happy path**:
- [ ] Dogfood: run Brand para Hardcore mismo → package produce un brand coherente
- [ ] 3 ideas del dogfooding subset end-to-end (b2b-smb, consumer-app, local-service)
- [ ] End-to-end flow: Scope → Strategy → Verbal ∥ Visual → Logo → Handoff → Package delivered
- [ ] **End-to-end con Claude Design**: user sube PDF → Claude Design genera landing → matches brand expectations (manual validation)

**Cross-dept data flow**:
- [ ] Strategy output consumido correctamente por Verbal y Visual
- [ ] Visual palette aplicada en Logo
- [ ] Todo integrado en Handoff brand-tokens/ (colors, fonts, spacing)
- [ ] Engram topic keys + filesystem paths consistentes

**Resume / partial**:
- [ ] User cancel mid-run → `/brand:resume` recupera desde último paso
- [ ] Soft failure (ej. Unsplash down) → package delivered parcial con flags correctos
- [ ] `/brand:extend {dept}` → regenera solo ese dept, coherence re-eval, versioning incrementa

### Category 6 — Qualitative review (founder/CEO)

**Shipping criterion** — el founder/CEO revisa el package y decide si va.

No hay rubric numérico. El review es prosa corta en `human-review.md` por run:

```markdown
# Brand Review — {idea-id} — {date}

## What worked
- {cosa específica}
- {cosa específica}

## What didn't work
- {failure mode en lenguaje plano}
- {patrón que falla consistentemente}

## Would ship?
- Yes / No / Yes-con-ajustes

## If ajustes: qualé
- {lista de ajustes necesarios antes de shipping}

## Notes para iteración del módulo
- {qué cambiar en los SKILL.md / references}
```

No hay umbral numérico de pass/fail. Shipping happens cuando el founder dice "va", no cuando un score > X.

El tracking de múltiples reviews forma una lista de failure modes que guía iteración del módulo — **lenguaje plano, no scores**.

### Category 7 — Regression tests (automated)

- [ ] Validation module funciona sin regresiones (tests existentes de Validation pasan)
- [ ] Profile module funciona sin regresiones (tests existentes de Profile pasan)
- [ ] Engram reads/writes consistentes (no contamination cross-módulo)
- [ ] Shared contracts (`output-contract.md`, `engram-convention.md`, etc.) respetados

## 14.6 Test execution process

### Per-idea run

1. Ensure prerequisites:
   - Validation corrida para la idea
   - Profile opcional creado (o explícito no-profile)
   - Claude Pro subscription del user activa (pre-flight)
2. Run Brand en Normal mode (dogfooding) o Fast mode (regresión)
3. Export a `testing/brand-runs/{date}_{machine}_{idea-id}/`
4. Run automated checks (categories 1-3, 5, 7)
5. Run Claude Design compatibility tests (category 4) — manual, requires account
6. Write qualitative review (category 6)
7. Commit run results en git
8. Track en `testing/brand-runs/REGISTRY.md`

### Aggregated reporting

`testing/analysis/brand-coverage.md`:
- Profiles tested (cuáles del suite se corrieron)
- Failure modes encontradas (lenguaje plano, acumulados)
- Patrones observados (qué rompe consistentemente, qué funciona)
- Coverage gaps
- Variance observations (archetype consistency, palette family consistency entre runs)

## 14.7 Test outputs directory

```
testing/
├── brand-suite.yaml
├── brand-PROTOCOL.md
├── brand-human-review-template.md
├── brand-runs/
│   ├── REGISTRY.md
│   ├── 2026-04-25_desktop_b2b-enterprise-test/
│   │   ├── scope.json
│   │   ├── strategy.json
│   │   ├── verbal.json
│   │   ├── visual.json
│   │   ├── logo.json
│   │   ├── handoff.json
│   │   ├── final-report.json
│   │   ├── human-review.md
│   │   ├── claude-design-compatibility.md
│   │   └── test-results.yaml
│   └── ...
└── analysis/
    └── brand-coverage.md
```

## 14.8 Phase gates

### Pre-Sprint 1 gate
- [ ] Plan files completos y consistentes (este plan)
- [ ] User approved plan
- [ ] brand-contract.md escrito
- [ ] Tool stack setup (Engram, open-websearch, Domain MCP, Unsplash API key, PDF skill)
- [ ] Claude Pro account del user disponible para testing

### Sprint 1 → dogfooding gate
- [ ] All 5 depts funcionan end-to-end
- [ ] 3 dogfooding profiles (b2b-smb, consumer-app, local-service) testables con ≥ 1 run
- [ ] Founder aprueba al menos 1 run end-to-end
- [ ] Dogfood de Hardcore mismo funcional
- [ ] Brand Design Document PDF testado en Claude Design account (extrae design system OK)
- [ ] 9 coherence gates working (automated tests pasan)
- [ ] Failure modes tested con fallbacks (Engram → hard halt, Unsplash → skip, etc.)

### Dogfooding → full coverage gate
- [ ] Los 8 brand profiles corridos al menos 1 vez con founder approval
- [ ] Claude Design compatibility verificada en todos los 8 profiles
- [ ] 0 critical failure modes unhandled (los hard halts surface correctamente, los soft degrades flagean)
- [ ] brand-contract.md estable (sin changes en los últimos 2 dogfooding runs)
- [ ] Documentación del módulo completa (SKILL.md + references para cada dept)

## 14.9 Calibration scenarios (deferred)

Validation tiene `calibration/scenarios.md` con 13 scenarios. Brand podría tener coherence-focused scenarios equivalentes: inyectar inputs específicos que deberían triggerear cada gate con fallas controladas.

**Propuesta**: 10 coherence scenarios (1+ per gate: archetype-market mismatch, voice-archetype mismatch, palette-archetype mismatch, etc.). Total trabajo ~6 horas de fixture creation.

**Estado**: deferred a post-dogfooding. Primero runs reales para ver qué failure modes aparecen en la práctica, después scenarios artificiales para coverage.

## 14.10 Reference files a escribir en Sprint 0

- `testing/brand-PROTOCOL.md` — protocolo detallado de testing
- `testing/brand-suite.yaml` — las 8 test ideas con expected outcomes
- `testing/brand-human-review-template.md` — template del qualitative review
- `testing/analysis/brand-coverage.md` — placeholder para aggregated reporting

## 14.11 Acceptance criteria del módulo

Brand se considera "production-ready" cuando:

- [ ] Unit tests pasan (Cat 1) para los 5 deptos
- [ ] Los 9 coherence gates pasan los tests de injection (Cat 2)
- [ ] Scope-appropriateness confirmada para los 3 profiles de dogfooding inicial (Cat 3)
- [ ] Claude Design compatibility confirmada en al menos 3 profiles (Cat 4)
- [ ] End-to-end integration runs successful para los 3 profiles (Cat 5)
- [ ] Qualitative reviews del founder marcan al menos 3 runs como "ship" o "ship con ajustes menores" (Cat 6)
- [ ] Regression tests pass (Cat 7)
- [ ] Dogfood de Hardcore mismo aprobado y usado en el launch real del proyecto

Post-"production-ready", el módulo evoluciona con feedback real de users, no con scores sintéticos.

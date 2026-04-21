# 14 — Testing Strategy

## 14.1 Propósito

Cómo validar que Brand produce outputs correctos, robustos, y usables. Paralelo a `testing/PROTOCOL.md` de Validation.

Testing focus en los 4 deliverables + compatibility con Claude Design downstream.

**Nota**: thresholds en este doc (ej: "human eval ≥ 7.5/10", "variance ≥ 80%", "confidence ≥ 0.7") son baselines razonables — Sprint 1 los calibra con resultados reales.

## 14.2 Fundamental challenge

Validation tiene outputs fácilmente verificables (scores, verdicts, knockouts). Brand tiene outputs más subjetivos. Strategy:

1. **Structural** — outputs completos y conforming al schema (automated)
2. **Coherence** — 8 gates pass (automated)
3. **Scope-appropriateness** — outputs correctos para el brand profile (semi-automated)
4. **Claude Design compatibility** — Brand Document PDF parseable por Claude Design (manual testing)
5. **Human evaluation** — final subjective quality (manual)
6. **Variance** — consistency entre runs (automated comparison)
7. **Regression** — Brand no rompe Validation/Profile (automated)

## 14.3 Test suite

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
    default_tier: 0
  
  - id: "brand-test-b2b-smb"
    text: "Software de facturación y gestión de cobros automatizado para freelancers de tecnología en LATAM, con integración tributaria MX/CO/AR"
    expected_brand_profile: "b2b-smb"
    expected_archetype_range: ["Sage", "Everyman", "Creator"]
    required_outputs_include: ["pricing_page_prompt", "linkedin_bio", "email_welcome_prompt"]
    must_skip: ["tiktok_bio", "pitch_deck_full"]
    default_tier: 0
  
  - id: "brand-test-b2d-devtool"
    text: "CLI tool that auto-generates interactive API docs from TypeScript codebases, with team collaboration and hosted docs portal"
    expected_brand_profile: "b2d-devtool"
    expected_archetype_range: ["Creator", "Magician", "Sage", "Explorer"]
    required_outputs_include: ["github_readme_prompt", "docs_landing_prompt", "code_snippet_styling_prompt"]
    must_skip: ["pitch_deck_full", "tiktok_bio", "app_icon_full_set"]
    default_tier: 0
    may_auto_elevate_tier: true  # si logo_primary_form: symbolic-first
  
  - id: "brand-test-b2c-consumer-app"
    text: "Mobile app para habit tracking con gamification, targeted a young professionals que quieren build routines"
    expected_brand_profile: "b2c-consumer-app"
    expected_archetype_range: ["Jester", "Hero", "Everyman", "Creator"]
    required_outputs_include: ["app_store_listing_prompt", "instagram_templates_prompt", "app_icon_full_set"]
    must_skip: ["pitch_deck_full", "case_study_prompt"]
    default_tier: 1  # app icon requires Tier 1+
    auto_elevate_reason: "app_asset_criticality: primary"
  
  - id: "brand-test-b2c-consumer-web"
    text: "Web platform for curated vintage clothing resale"
    expected_brand_profile: "b2c-consumer-web"
    expected_archetype_range: ["Creator", "Lover", "Explorer"]
    required_outputs_include: ["instagram_templates_prompt", "newsletter_template_prompt", "referral_copy"]
    must_skip: ["app_icon_full_set", "pitch_deck_full"]
    default_tier: 0
  
  - id: "brand-test-b2local-service"
    text: "Barbershop premium en Palermo, Buenos Aires"
    expected_brand_profile: "b2local-service"
    expected_archetype_range: ["Everyman", "Ruler", "Caregiver", "Sage"]
    required_outputs_include: ["whatsapp_templates", "google_my_business_copy", "printable_flyer_prompt"]
    must_skip: ["pitch_deck", "tiktok_bio", "developer_assets"]
    default_tier: 0
  
  - id: "brand-test-content-media"
    text: "Weekly newsletter + podcast sobre product strategy y growth for startup founders LATAM"
    expected_brand_profile: "content-media"
    expected_archetype_range: ["Sage", "Creator", "Explorer"]
    required_outputs_include: ["podcast_cover_prompt", "newsletter_template_prompt", "social_post_series_prompt"]
    must_skip: ["pitch_deck_full", "pricing_page_formal"]
    default_tier: 0
  
  - id: "brand-test-community-movement"
    text: "Comunidad online de mujeres founders tech en LATAM, Discord + eventos mensuales + mentoring 1:1"
    expected_brand_profile: "community-movement"
    expected_archetype_range: ["Hero", "Caregiver", "Rebel", "Everyman"]
    required_outputs_include: ["manifesto_opening", "symbolic_assets_prompt", "discord_branding_prompt"]
    must_skip: ["pricing_page_enterprise", "app_icon_full_set"]
    default_tier: 0
```

## 14.4 Test categories

### Category 1 — Unit tests por dept

**Scope Analysis**:
- [ ] B2B SaaS clara → `b2b-smb` confidence ≥ 0.8
- [ ] Consumer mobile app clara → `b2c-consumer-app` confidence ≥ 0.8
- [ ] Híbrida B2D + community → primary/secondary ambos
- [ ] Ambigua → triggers user confirmation
- [ ] Local service → `b2local-service`
- [ ] Sin profile → proceeds with flag
- [ ] User override respetado
- [ ] Auto-eleva tier para `b2c-consumer-app` (app icon requires Tier 1)

**Strategy**:
- [ ] B2B SaaS + Sage-compatible profile → Sage
- [ ] Consumer app + Explorer profile → Explorer
- [ ] Sin profile → `decided_without_profile: true`
- [ ] Mismo input 2 runs → archetype consistent
- [ ] Voice attributes derivadas del archetype + register

**Verbal**:
- [ ] 15-20 candidatos inicial, reduce a 10-12 verified, top 5-7 presentados
- [ ] Naming: all TM red excluidos
- [ ] Scope b2b-smb prefiere descriptive
- [ ] Scope b2c-consumer-app prefiere short/memorable
- [ ] Copy: scope b2b-enterprise genera pitch deck cover copy, NO TikTok bio
- [ ] Voice self-check: assets exhibit voice detectably
- [ ] Domain MCP integration functional
- [ ] TM screening interpreted correctly

**Visual**:
- [ ] Tier 0: Claude-generated palette + typography, no mood imagery
- [ ] Tier 1: Huemint palette + Unsplash mood refs
- [ ] Tier 2: Huemint paid + Recraft mood
- [ ] Archetype Sage + formality medium → palette conservadora
- [ ] Archetype Jester + formality low → palette vibrant
- [ ] WCAG check ajusta si falla
- [ ] Typography era matchea pairing

**Logo**:
- [ ] Tier 0 + wordmark-preferred → 4 Claude-SVG wordmarks, valid
- [ ] Tier 0 + symbolic-first → user prompted to elevate
- [ ] Tier 1 + symbolic-first → Recraft symbolic + Claude wordmark mixed
- [ ] Tier 2 + any → Recraft todo
- [ ] SVG output válido
- [ ] Variants preservan structure
- [ ] Derivations rendean
- [ ] `app_asset_criticality: primary` (Tier 1+) → iOS + Android set

**Handoff Compiler**:
- [ ] Brand Design Document PDF generado completo
- [ ] Prompts Library markdown valid con prompts customizados
- [ ] Brand Tokens: JSON/CSS/Tailwind/HTML parseable + valid
- [ ] Reference Assets folder structured
- [ ] Coherence gates 8/8 enforced
- [ ] README.md accurate
- [ ] AUDIT.md con full trace

### Category 2 — Coherence tests

Inject inputs con incoherencias, verify gates detect + resolve:

- [ ] Palette incoherente (Sage + neon) → Gate 3 detects, Visual regenerates
- [ ] Voice incoherente (Sage + playful irónico) → Gate 2 detects
- [ ] Logo illegible → Gate 6 detects
- [ ] Logo wordmark en scope symbolic-first → Gate 8 detects
- [ ] 3+ persistent failures → escalation triggered
- [ ] User "accept mismatch" → flag permanente

### Category 3 — Claude Design compatibility tests

**Manual testing** — requires Claude Design account:

- [ ] Brand Design Document PDF uploads to Claude Design onboarding without errors
- [ ] Claude Design extracts design system correctly:
  - Colors match palette from our Visual output
  - Typography matches fonts from our Visual output
  - Logo displayed correctly in design system
- [ ] Design system validated with test project produces brand-consistent output
- [ ] Prompts from Prompts Library produce deliverables matching brand
- [ ] Brand Tokens folder linkable as codebase works (si user tests this path)
- [ ] Reference Assets uploadables as visual references

**Automated checks on PDF/markdown**:
- [ ] PDF has all required sections per brand profile
- [ ] PDF not corrupted (opens in standard PDF viewers)
- [ ] Prompts library has correct structure (goal + layout + content + audience per prompt)
- [ ] Each prompt customized with brand name, palette, voice

### Category 4 — Integration tests

**Happy path**:
- [ ] Dogfood contra Hardcore mismo (run Brand for Hardcore idea)
- [ ] 3 ideas validadas del suite con distintos profiles
- [ ] End-to-end: Scope → Strategy → Verbal+Visual → Logo → Handoff → Package delivered
- [ ] **End-to-end con Claude Design**: user runs Brand → uploads PDF → Claude Design generates landing → matches brand expectations

**Cross-dept**:
- [ ] Strategy consumed correctly by Verbal, Visual
- [ ] Visual palette applied in Logo
- [ ] All integrated in Handoff brand-tokens/
- [ ] Engram + filesystem paths consistent

### Category 5 — Variance tests

Misma idea + profile, múltiples runs (mismo tier):

- [ ] Archetype: same o adjacent (Sage↔Ruler OK, Sage↔Jester fail)
- [ ] Palette: same family, matices pueden variar
- [ ] Logo concepts: distintos (creativity expected)
- [ ] Copy tagline: distinto, mismo voice detectable
- [ ] Coherence score entre runs ≥ 80% (baseline — calibrar Sprint 1)

### Category 6 — Human evaluation

`testing/brand-human-eval-template.md`:

```markdown
# Brand Human Eval — {idea-id} — {date}

## Strategy quality
- Archetype fits founder + idea? (1-10)
- Voice attributes coherent with archetype? (1-10)

## Verbal quality  
- Name memorable? (1-10)
- Copy exhibits voice consistently? (1-10)

## Visual quality
- Palette evokes intended mood? (1-10)
- Typography pairs well? (1-10)

## Logo quality
- Feels like a brand? (1-10)
- SVG editable? (Y/N)
- Tier used: 0 / 1 / 2

## Claude Design handoff
- PDF uploaded to Claude Design successfully? (Y/N)
- Design system extracted matches brand? (1-10)
- Prompts from Library produced usable Claude Design outputs? (1-10)

## Overall
- Would ship this? (Y/N)
- Specific issues:
- What's missing?

Score: {average}/10
```

Target: promedio ≥ 7.5/10 para pass. Baseline razonable — Sprint 1 calibra con primeros 5-10 runs.

### Category 7 — Regression tests

- [ ] Validation module unaffected
- [ ] Profile module unaffected
- [ ] Engram reads/writes consistent
- [ ] No contamination cross-módulo

### Category 8 — Tier-specific tests

**Tier 0**:
- [ ] All 8 profiles testable en Tier 0 (aunque degraded quality para symbolic logos)
- [ ] Zero image gen cost verified
- [ ] Claude SVG wordmarks quality acceptable
- [ ] Claude-palette + Google Fonts typography quality acceptable

**Tier 1**:
- [ ] Auto-elevation triggers correctly (symbolic-first, icon-first, primary app icon)
- [ ] User can manually elevate via --tier=1
- [ ] Recraft integration functional
- [ ] Unsplash integration functional
- [ ] Huemint integration functional
- [ ] Cost per run ~$0.10-0.20

**Tier 2**:
- [ ] User can manually set --tier=2
- [ ] All gens via Recraft
- [ ] Higher quality outputs verified
- [ ] Cost per run ~$0.40-0.80

**Tier degradation**:
- [ ] Tier 2 → Tier 1 if Recraft down for mood
- [ ] Tier 1 → Tier 0 if Recraft down entirely
- [ ] User notified of degradation

## 14.5 Test execution process

### Per-idea run

1. Ensure prerequisites:
   - Validation de la idea corrida
   - Profile opcional creado
2. Run Brand in fast mode initially
3. Export a `testing/brand-runs/{date}_{machine}_{idea-id}/`
4. Run automated checks (categories 1-2, 7-8)
5. Run Claude Design compatibility tests (category 3) — manual
6. Run human eval (category 6)
7. Commit run results
8. Track en `testing/brand-runs/REGISTRY.md`

### Aggregated reporting

`testing/analysis/brand-coverage.md`:
- Profiles tested
- Human eval scores per profile
- Variance metrics
- Tier distribution
- Failure modes encountered
- Coverage gaps

## 14.6 Test outputs directory

```
testing/
├── brand-suite.yaml
├── brand-PROTOCOL.md
├── brand-human-eval-template.md
├── brand-runs/
│   ├── 2026-04-25_desktop_b2b-enterprise-test/
│   │   ├── scope.json
│   │   ├── strategy.json
│   │   ├── verbal.json
│   │   ├── visual.json
│   │   ├── logo.json
│   │   ├── handoff.json
│   │   ├── final-report.json
│   │   ├── human-eval.md
│   │   ├── claude-design-compatibility.md (manual test results)
│   │   └── test-results.yaml
│   └── ...
└── analysis/
    └── brand-coverage.md
```

## 14.7 Phase gates

### Pre-Sprint 1 gate
- [ ] Plan files completos y consistentes
- [ ] User approved plan
- [ ] Tool stack Tier 0 setup (minimal)

### Sprint 1 → Sprint 2 gate
- [ ] All 5 depts funcionan end-to-end en Tier 0
- [ ] All 8 brand profiles testable con ≥ 1 run
- [ ] 3+ runs con human eval ≥ 7/10
- [ ] Dogfooding against Hardcore successful (Brand generado para Hardcore mismo)
- [ ] Brand Design Document PDF testable en Claude Design account
- [ ] Coherence gates working
- [ ] Failure modes tested con fallbacks

### Sprint 2 → Launch gate
- [ ] 10+ completed runs across varied ideas + tiers
- [ ] Human eval average ≥ 8/10
- [ ] Claude Design compatibility verified on all 8 profiles
- [ ] 0 critical failure modes unhandled
- [ ] Documentation complete
- [ ] brand-contract.md stable

## 14.8 Calibration scenarios (deferred)

Validation tiene `calibration/scenarios.md` con 13 scenarios. Brand podría tener equivalent.

**Propuesta**: 5 coherence-focused scenarios (inject incoherencias específicas, verify gates behavior). Total trabajo ~4 horas de fixture creation.

**Decisión**: diferir a Sprint 1/2 — ver después de primeros runs reales si calibration necesario.

## 14.9 Reference file a escribir en Sprint 0

`testing/brand-PROTOCOL.md` — protocolo detallado.

## 14.10 Acceptance criteria final

Brand "production-ready" cuando:

- [ ] Unit tests pass (Cats 1-2)
- [ ] Integration tests pass on all 8 profiles (Cat 4)
- [ ] Claude Design compatibility confirmed (Cat 3)
- [ ] Variance tests OK (Cat 5)
- [ ] Human eval ≥ 8/10 across 10+ runs (Cat 6)
- [ ] Regression tests pass (Cat 7)
- [ ] All tiers tested (Cat 8)
- [ ] Failure modes documented y tested
- [ ] Dogfooding: Brand generado para Hardcore, usado para lanzamiento real

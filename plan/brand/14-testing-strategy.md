# 14 — Testing Strategy

## 14.1 Propósito

Cómo validar que el módulo Brand produce outputs correctos, robustos, y usables. Paralelo a `testing/PROTOCOL.md` existente para Validation, adaptado para las particularidades de Brand (outputs menos cuantificables que scoring).

## 14.2 Fundamental challenge

Validation tiene outputs fácilmente verificables: scores numéricos, verdicts GO/PIVOT/NO-GO, knockouts rules. Brand tiene outputs que son **más subjetivos**: ¿el archetype es "correcto"? ¿el copy "suena bien"? ¿el logo es "bueno"?

**Estrategia de testing**:

1. **Structural** — outputs completos y conforming al schema (fácil, automated)
2. **Coherence** — gates pasan (automated via the 9 gates)
3. **Scope-appropriateness** — outputs correctos para el brand profile detected (semi-automated)
4. **Human evaluation** — final subjective quality (manual, por idea)
5. **Variance** — consistency entre runs (automated comparación)
6. **Regression** — Brand no rompe Validation ni Profile (automated)

## 14.3 Test suite — estructura

Paralelo a `testing/suite.yaml` existente. Nuevo archivo: `testing/brand-suite.yaml`.

### Test ideas curadas (8 ideas, una por brand profile)

```yaml
version: "1.0"

brand_test_ideas:
  - id: "brand-test-b2b-enterprise"
    text: "Enterprise security platform for Fortune 500 financial institutions, providing real-time compliance monitoring across regulatory frameworks (SOX, GDPR, PCI-DSS)"
    expected_brand_profile: "b2b-enterprise"
    expected_archetype_range: ["Sage", "Ruler", "Hero"]
    required_outputs_include: ["pitch_deck", "case_study_template", "security_page"]
    must_skip: ["tiktok_bio", "app_icon_full_set"]
    
  - id: "brand-test-b2b-smb"
    text: "Software de facturación y gestión de cobros automatizado para freelancers de tecnología en LATAM, con integración tributaria MX/CO/AR"
    expected_brand_profile: "b2b-smb"
    expected_archetype_range: ["Sage", "Everyman", "Creator"]
    required_outputs_include: ["pricing_page", "linkedin_bio", "email_templates"]
    must_skip: ["tiktok_bio", "pitch_deck_full"]
  
  - id: "brand-test-b2d-devtool"
    text: "CLI tool that auto-generates interactive API docs from TypeScript codebases, with team collaboration and hosted docs portal for mid-size eng teams"
    expected_brand_profile: "b2d-devtool"
    expected_archetype_range: ["Creator", "Magician", "Sage", "Explorer"]
    required_outputs_include: ["github_readme", "docs_landing", "code_snippet_styling"]
    must_skip: ["pitch_deck_full", "tiktok_bio", "app_icon_full_set"]
  
  - id: "brand-test-b2c-consumer-app"
    text: "Mobile app para habit tracking con gamification, targeted a young professionals que quieren build routines"
    expected_brand_profile: "b2c-consumer-app"
    expected_archetype_range: ["Jester", "Hero", "Everyman", "Creator"]
    required_outputs_include: ["app_icon_full_set", "app_store_copy", "instagram_templates", "tiktok_concepts"]
    must_skip: ["pitch_deck_full", "case_study_template"]
  
  - id: "brand-test-b2c-consumer-web"
    text: "Web platform for curated vintage clothing resale, connecting verified sellers with fashion-conscious buyers"
    expected_brand_profile: "b2c-consumer-web"
    expected_archetype_range: ["Creator", "Lover", "Explorer"]
    required_outputs_include: ["instagram_templates", "newsletter_template", "referral_copy"]
    must_skip: ["app_icon_full_set", "pitch_deck_full"]
  
  - id: "brand-test-b2local-service"
    text: "Barbershop premium en Palermo, Buenos Aires, con servicios de corte, afeitado tradicional, y workshop de skincare masculino"
    expected_brand_profile: "b2local-service"
    expected_archetype_range: ["Everyman", "Ruler", "Caregiver", "Sage"]
    required_outputs_include: ["whatsapp_templates", "google_my_business", "printable_flyers", "phone_script"]
    must_skip: ["pitch_deck", "tiktok_bio", "developer_assets"]
  
  - id: "brand-test-content-media"
    text: "Weekly newsletter + podcast sobre product strategy y growth for startup founders in LATAM, monetized via sponsorships"
    expected_brand_profile: "content-media"
    expected_archetype_range: ["Sage", "Creator", "Explorer"]
    required_outputs_include: ["podcast_cover", "newsletter_template", "social_post_series"]
    must_skip: ["pitch_deck_full", "pricing_page_formal"]
  
  - id: "brand-test-community-movement"
    text: "Comunidad online de mujeres founders tech en LATAM, con Discord + eventos monthly + mentoring 1:1"
    expected_brand_profile: "community-movement"
    expected_archetype_range: ["Hero", "Caregiver", "Rebel", "Everyman"]
    required_outputs_include: ["manifesto_document", "symbolic_assets", "discord_branding", "recruiting_copy"]
    must_skip: ["pricing_page_enterprise", "app_icon_full_set"]
```

Estas 8 ideas cubren los 8 brand profiles canónicos.

**Requirements**: cada idea debe tener previamente:
- Run de Validation completo (idealmente verdict GO o PIVOT)
- Opcionalmente un Profile para variance testing

## 14.4 Test categories

### Category 1 — Unit tests por dept

**Strategy**:
- [ ] Input B2B SaaS + Sage-compatible profile → output Sage con confidence alta
- [ ] Input consumer app + Explorer-compatible profile → output Explorer
- [ ] Input sin profile → `decided_without_profile: true`, archetype basado solo en idea
- [ ] Mismo input, 2 runs → archetype consistent (misma decisión dado mismo input)
- [ ] Voice attributes derivadas del archetype + register
- [ ] Schema completo — todos los campos presentes
- [ ] Evidence trace poblado

**Verbal Identity**:
- [ ] Naming: genera 15-20 candidatos inicial, reduce a 10-12 verified, presenta top 5-7
- [ ] Naming: all TM red candidates excluidos del top
- [ ] Naming: scope b2b-smb prefiere descriptive/compound strategies
- [ ] Naming: scope b2c-consumer-app prefiere short/memorable
- [ ] Copy: scope b2b-enterprise genera pitch deck copy, NO TikTok bio
- [ ] Copy: scope b2c-consumer-app genera app store descriptions, NO pitch deck
- [ ] Voice self-check: assets exhibit voice detectably
- [ ] Domain MCP integration functional
- [ ] TM screening returns results interpretables

**Visual System**:
- [ ] Archetype Sage + formality medium → palette conservadora con accent sutil
- [ ] Archetype Jester + formality low → palette vibrant multi-accent
- [ ] WCAG check detecta contrast failures y ajusta
- [ ] Typography era matchea pairing correcto
- [ ] Mood imagery generada coherent entre las 6-8 imágenes
- [ ] Huemint integration functional
- [ ] Recraft integration functional
- [ ] Scope sin `mood_imagery` en required → skip generation

**Logo**:
- [ ] `logo_primary_form: wordmark-preferred` → 3 wordmarks + 1 combination generados
- [ ] `logo_primary_form: icon-first` → 4 symbolic, legible a 16×16
- [ ] SVG output válido (parseable, no corrupto)
- [ ] Variants (mono, inverse) preservan structure del primary
- [ ] Derivations (favicon, OG card) rendean correctamente
- [ ] `app_asset_criticality: primary` → set completo iOS + Android
- [ ] User regen con feedback → feedback applied

**Activation**:
- [ ] DESIGN.md parseable by Stitch
- [ ] Stitch genera screens correctos según scope
- [ ] Coherence gates detectan incoherencias y regeneran
- [ ] Brand book PDF completo con todas las sections
- [ ] Package structure dinámica correct per profile
- [ ] README.md refleja incluidos + excluidos accurately
- [ ] Microsite HTML opens correctly

**Scope Analysis**:
- [ ] Idea B2B SaaS clara → clasifica `b2b-smb` con confidence ≥ 0.8
- [ ] Idea consumer mobile app clara → clasifica `b2c-consumer-app` con confidence ≥ 0.8
- [ ] Idea híbrida B2D + community → primary/secondary ambos
- [ ] Idea ambigua → triggers user confirmation
- [ ] Idea local service → clasifica `b2local-service` correctamente
- [ ] Idea sin profile → proceeds with flag
- [ ] User override previo → manifest respeta hints

### Category 2 — Coherence tests

Inject inputs con incoherencias deliberadas y verify que gates detectan + resolven:

- [ ] Palette incoherente injected (Sage + neon colors) → Gate 3 detects, Visual regenerates, passes
- [ ] Voice incoherente (Sage + voice "playful irónico") → Gate 2 detects, resolves
- [ ] Logo illegible sobre palette → Gate 6 detects, resolves
- [ ] Missing required screen → Gate 9 detects, re-invokes Stitch
- [ ] 3+ persistent failures → escalation to user triggered
- [ ] User decision "accept mismatch" → flag permanente en brand book

### Category 3 — Integration tests

**Happy path test**:
- [ ] Run complete Brand against Hardcore itself (primer test real — dogfooding)
- [ ] Run complete Brand against 3 ideas from testing/suite.yaml con distintos profiles
- [ ] Verify end-to-end: Scope → Strategy → Verbal+Visual → Logo → Activation → Package delivered

**Cross-dept integration**:
- [ ] Strategy output consumed correctly by Verbal, Visual
- [ ] Visual palette applied in Logo dept
- [ ] Logo + Visual + Verbal all integrated in Activation DESIGN.md
- [ ] All paths in Engram and filesystem consistent

### Category 4 — Variance tests

Misma idea + profile, múltiples runs. Verificar:

- [ ] Archetype: mismo O adjacent (Sage↔Ruler OK, Sage↔Jester fail)
- [ ] Palette: same family, matices pueden variar
- [ ] Logo concepts: distintos (esperado, creatividad)
- [ ] Copy tagline: distinto text, mismo voice detectable
- [ ] Weighted "coherence score" entre runs ≥ 80%

**Target**: variance aceptable porque Brand tiene componente creative, pero NO debe ser wildly different (eg: Sage → Jester) para mismo input.

### Category 5 — Human evaluation

Subjective quality assessment — no automatable but systematic:

Crear `testing/brand-human-eval-template.md`:

```markdown
# Brand Human Eval — {idea-id} — {date}

## Archetype feel
- Does the archetype feel right for this founder + idea? (1-10)
- Specific notes:

## Name quality  
- Memorable? (1-10)
- Pronounceable? (1-10)
- Fits the brand? (1-10)
- Specific notes:

## Voice coherence
- Voice feels consistent across copy? (1-10)
- Matches the archetype? (1-10)
- Authentic vs generic? (1-10)

## Visual system
- Palette evokes the intended mood? (1-10)
- Typography pairs well? (1-10)
- Mood imagery representative? (1-10)

## Logo
- Logos feel like a brand? (1-10)
- Variants work in context? (1-10)
- SVG editability confirmed? (Y/N)

## Activation
- Microsite looks like a real brand? (1-10)
- Brand book professional? (1-10)
- Package structure usable? (1-10)

## Overall
- Would you ship this as a real brand? (Y/N)
- Specific issues:
- What's missing?
- What surprised positively?

## Score: {average}/10
```

Ejecutar human eval para cada test idea. Target: promedio ≥ 7.5/10 para pass.

### Category 6 — Regression tests

Verify Brand no rompe otros módulos:

- [ ] Validation module unaffected (suite tests siguen pasando)
- [ ] Profile module unaffected
- [ ] Engram reads/writes consistent con conventions
- [ ] No contamination cross-módulo (brand artifacts don't leak into validation topic keys)

## 14.5 Test execution process

Paralelo a `testing/PROTOCOL.md` existente:

### Per-idea run

1. Ensure prerequisites:
   - Validation de la idea corrida y persistida
   - Profile opcional creado
2. Run Brand in **fast mode** inicialmente (más rápido para iteration)
3. Export results a `testing/brand-runs/{date}_{machine}_{idea-id}/`
4. Run automated checks (structural, coherence, scope-appropriateness)
5. Run human eval
6. Commit run results
7. Track in `testing/brand-runs/REGISTRY.md`

### Aggregated reporting

`testing/analysis/brand-coverage.md`:

- Which brand profiles tested
- Average human eval score per profile
- Variance metrics
- Failure modes encountered
- Coverage gaps

## 14.6 Test outputs directory structure

```
testing/
├── brand-suite.yaml                          # Test ideas curadas (existing pattern)
├── brand-human-eval-template.md              # Template para eval
├── brand-runs/                               # Runs ejecutados
│   ├── 2026-04-25_desktop_b2b-enterprise-test/
│   │   ├── scope.json
│   │   ├── strategy.json
│   │   ├── verbal.json
│   │   ├── visual.json
│   │   ├── logo.json
│   │   ├── activation.json
│   │   ├── final-report.json
│   │   ├── human-eval.md
│   │   └── test-results.yaml
│   ├── 2026-04-25_desktop_b2c-consumer-app-test/
│   └── ...
└── analysis/
    └── brand-coverage.md
```

## 14.7 Phase gates

### Pre-Sprint 1 gate
- [ ] Plan files completos (este plan)
- [ ] User approved plan (no major cambios pending)
- [ ] Tool stack setup complete (Sprint 0 task)

### Sprint 1 → Sprint 2 gate (ready for external use)
- [ ] All 5 depts funcionan end-to-end
- [ ] All 8 brand profiles testable con ≥ 1 run
- [ ] 3+ completed runs con human eval ≥ 7/10
- [ ] Dogfooding against Hardcore itself successful
- [ ] Coherence gates all working
- [ ] All failure modes tested con fallbacks validated

### Sprint 2 → Launch gate
- [ ] 10+ completed runs across varied ideas
- [ ] Human eval average ≥ 8/10
- [ ] 0 critical failure modes unhandled
- [ ] Calibration scenarios ejecutados (si decidimos crearlos — ver [22-open-decisions.md](./22-open-decisions.md))
- [ ] Documentation complete
- [ ] brand-contract.md stable y used por al menos 1 consumer module (future Launch module)

## 14.8 Calibration scenarios (decisión pending)

Validation tiene `calibration/scenarios.md` con 13 scenarios. Brand podría tener equivalent.

**Propuesta**: 8 calibration scenarios (uno per brand profile) con:
- Fixed inputs (scope decision, validation output stub, profile stub)
- Expected archetype range
- Expected coherence behavior
- Expected output structure

**Pros**: high confidence en correctness
**Cons**: considerable trabajo de creación (8 complete fixtures)

**Decisión**: pending ver [22-open-decisions.md](./22-open-decisions.md).

## 14.9 Testing en producción (post-launch)

Future considerations (out of scope v1 plan pero worth noting):

- **A/B testing infrastructure**: generate 2 archetypes for same idea, user picks preferred, learn preferences
- **Satisfaction tracking**: post-delivery survey, score por idea
- **Usage analytics**: track qué deliverables se usan realmente
- **Auto-improvement**: flagged outputs inform prompt tuning

## 14.10 Reference file a escribir en Sprint 0

`testing/brand-PROTOCOL.md` — protocolo detallado paralelo al `testing/PROTOCOL.md` existente.

## 14.11 Acceptance criteria final del módulo

Brand se declara "production-ready" cuando:

- [ ] Todos los unit tests pass (Categories 1-2)
- [ ] Integration tests (Category 3) pass on all 8 brand profiles
- [ ] Variance tests (Category 4) muestran consistency aceptable
- [ ] Human eval (Category 5) promedio ≥ 8/10 across 10+ runs
- [ ] Regression tests (Category 6) pass — no break de Validation/Profile
- [ ] Failure modes documentados y tested (Category dedicada)
- [ ] Dogfooding: Brand generado para Hardcore mismo, se usa para el lanzamiento real

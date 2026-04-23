# 02 — Scope Analysis (Paso 0)

## 2.1 Propósito

Clasificar el tipo de idea y producir un **manifest de scope** que define:
- Qué outputs aplican (`required`, `optional_recommended`, `skip`, `out_of_scope_declared`)
- Qué modificadores de intensidad aplicar (`verbal_register`, `visual_formality`, etc.)
- Qué archetypes están bloqueados o preferidos por el contexto de mercado + profile

Este manifest es el **contrato** que los 4 deptos downstream (Strategy, Verbal, Visual, Logo) consumen para adaptar su ejecución al tipo de idea. El Handoff Compiler también consume el manifest para decidir qué secciones del Brand Document generar y qué prompts incluir en la Prompts Library.

## 2.2 Ejecución — sub-agent (mismo patrón que los 4 deptos)

Scope Analysis se ejecuta como **sub-agent** lanzado por el orchestrator, siguiendo el mismo patrón de la DAG de Validation y del resto de los deptos de Brand. Razones:

- **Consistencia con el department-protocol compartido** (`skills/_shared/department-protocol.md`). No introducir excepciones que abran la puerta a otros deptos "liviano inline" más adelante.
- **Mismo envelope de output** — todos los deptos retornan el output-contract estándar, incluido Scope Analysis.
- **Mismo patrón de persistencia en Engram** (`brand/{slug}/scope`).
- El overhead de un sub-agent extra es negligible comparado con el beneficio de homogeneidad.

El sub-agent de Scope Analysis no requiere WebSearch ni tools externos — solo Engram retrieval + reasoning.

## 2.3 Inputs

### Obligatorios (retrieved via Engram por el sub-agent)
- `validation/{slug}/synthesis` (verdict, scores, flags)
- `validation/{slug}/problem` (target audience, pain points, industry, demand_stack)
- `validation/{slug}/market` (SOM, segments, geographies, market_stage)
- `validation/{slug}/competitive` (direct_competitors, market_gaps, pricing_benchmark)
- `validation/{slug}/bizmodel` (recommended_model, pricing_suggestion)
- Idea text original

### Opcionales
- `founder_brand_context` (pasado desde el orchestrator si profile existe)
- User overrides explícitos (ej: `"tono formal"`, `"scope: b2b-smb"`)

El sub-agent recibe los inputs como parte del prompt de lanzamiento (ver sub-agent-template en orchestrator references). No accede directamente al user.

## 2.4 Proceso detallado

### Paso A — Clasificación multi-axis

Cada idea se clasifica en **5 ejes ortogonales**:

#### Eje 1: `customer` — quién es el cliente

| Valor | Señales que lo indican |
|---|---|
| `B2B` | Target del Problem dept menciona companies/teams/orgs, pricing tier >$100/mo, sales cycle implícito |
| `B2C` | Target son individuos/consumers, pricing <$50/mo o one-time, distribution social/viral |
| `B2D` | Target son developers/engineers, pricing puede ser $0 (open source + paid tier), distribución por GitHub/docs/dev Twitter |
| `B2G` | Target es gobierno/agencias, sales cycle 12-24 meses, compliance-heavy |
| `Internal` | Product para uso interno de organizaciones |

#### Eje 2: `format` — cómo se entrega el producto

| Valor | Señales |
|---|---|
| `SaaS` | Software as a Service, web-based, subscription model |
| `mobile-app` | App nativa iOS/Android |
| `physical-product` | Bien físico (limited coverage en v1) |
| `service-local` | Servicio prestado localmente |
| `service-global` | Servicio remoto |
| `content-media` | Newsletter, podcast, YouTube, blog |
| `community` | Comunidad estructurada |
| `marketplace` | Plataforma dos lados |
| `API` | Developer-facing API |

#### Eje 3: `distribution` — cómo llega el producto al cliente

Array multi-valor:

| Valor | Señales |
|---|---|
| `sales-driven` | Enterprise, outbound, demos |
| `social-driven` | Consumer, TikTok/IG viral |
| `community-driven` | Discord/Slack, grassroots |
| `content-driven` | SEO, blog, newsletter |
| `app-store` | Mobile app, ASO |
| `marketplace` | Via plataformas de terceros |
| `partnership-driven` | Canales de partners |
| `PR-driven` | Earned media |

#### Eje 4: `stage` — madurez

| Valor | Señales |
|---|---|
| `pre-launch` | No lanzado aún |
| `MVP` | Recién lanzado |
| `growth` | Post-PMF |
| `scale` | Late-stage |

#### Eje 5: `cultural_scope`

| Valor | Señales |
|---|---|
| `global` | Target internacional, inglés primario |
| `regional-LATAM` | Target LATAM, español |
| `regional-US` | Target US primario |
| `regional-EU` | Target Europa |
| `local` | City/country specific |
| `niche-community` | Comunidad específica |

### Paso B — Matching a brand profile canónico

Dados los 5 ejes, match contra los 8 brand profiles (ver [03-brand-profiles.md](./03-brand-profiles.md)) usando similarity scoring:

```
scoring function:
  base_score = 0
  if classification.customer in profile.expected_customer: base_score += 3
  if classification.format in profile.expected_format: base_score += 3
  if any(d in profile.expected_distribution for d in classification.distribution): base_score += 2
  if classification.stage in profile.expected_stage: base_score += 1
  if classification.cultural_scope in profile.expected_cultural_scope: base_score += 1
  
primary = profile con highest score
primary_confidence = primary.score / 10
```

**Threshold**: si `primary_confidence < 0.7`, el sub-agent retorna el output con flag `requires_user_confirmation: true` y el orchestrator prompt al user antes de proseguir con el pipeline.

### Paso C — Generar output manifest

Para cada output posible del módulo (ver matriz en [03-brand-profiles.md](./03-brand-profiles.md)), marcar estado:

- `required`: siempre se genera
- `optional_recommended`: se genera si scope lo soporta
- `skip`: se omite silenciosamente
- `out_of_scope_declared`: v1 no cubre (ej: motion, sonic branding)

El manifest refleja los outputs que **Brand produce** (naming, brand document sections, logo variants, prompts específicos por deliverable). La generación de UI aplicada (landing, decks, mockups) la ejecuta Claude Design downstream — no se lista en nuestro manifest como output propio; aparece como **prompt template** en la Prompts Library.

### Paso D — Intensity modifiers

Modificadores finos que los deptos consumen para calibrar tono, formato, y volumen de output:

```json
{
  "verbal_register": "formal-professional | professional-warm | casual-friendly | playful-bold | expressive-raw",
  "copy_depth": "long-form-allowed | medium | punchy-only",
  "visual_formality": "high | medium | low",
  "logo_primary_form": "symbolic-first | wordmark-preferred | combination | icon-first",
  "typography_era": "editorial-classic | neutral-modern | expressive-contemporary | experimental",
  "social_presence_priority": "enterprise-linkedin-only | professional-multichannel | consumer-heavy | community-native | content-creator | local-whatsapp",
  "app_asset_criticality": "not-needed | derivative | primary",
  "print_needs": "none | minimal | heavy",
  "sonic_needs": "none | branded | heavy",
  "motion_needs": "none | subtle | expressive"
}
```

Los modifiers son derivados determinísticamente del brand_profile + classification + founder_brand_context (si existe). No hay ramificaciones en base a tier ni cost — el módulo usa un solo stack de tools (ver [11-tools-stack.md](./11-tools-stack.md)).

### Paso E — Archetype constraints

Según brand profile + founder profile:

| Brand profile | Archetypes bloqueados típicos |
|---|---|
| `b2b-enterprise` | Jester, Outlaw, Rebel |
| `b2b-smb` | Outlaw, Rebel (sin soporte profile) |
| `b2d-devtool` | Caregiver |
| `b2c-consumer-app` | Ruler típicamente |
| `community-movement` | Ruler |
| `b2local-service` | Outlaw, Rebel |

Plus profile-based blocks (si `founder_brand_context` existe):
- `profile.risk_tolerance: conservative` → Outlaw, Hero bloqueados
- `profile.working_style.orientation: technical` puro → Lover, Caregiver con fricción en B2C emocional

La lista final de archetypes compatibles (no bloqueados) pasa a Strategy para seleccionar uno con justificación.

### Paso F — Confidence assessment

Si `primary_confidence >= 0.7`, output marca `requires_user_confirmation: false` y el pipeline continúa sin interrupción.

Si `primary_confidence < 0.7`, el output del sub-agent incluye:

```json
{
  "requires_user_confirmation": true,
  "confirmation_options": [
    {"id": 1, "label": "b2b-smb (confidence 0.62) — correct"},
    {"id": 2, "label": "b2b-enterprise — large companies"},
    {"id": 3, "label": "b2d-devtool — developer audience"},
    {"id": 4, "label": "b2c-consumer-app"},
    {"id": 5, "label": "other — describe"}
  ],
  "confirmation_context": "Tu idea clasificó como b2b-smb con señales: compliance officers, subscription $200-500/mo, distribution content+outbound. ¿Correcto?"
}
```

El orchestrator presenta las opciones al user y re-invoca el sub-agent de Scope Analysis con `user_override: {brand_profile: "...", ...}` si el user corrige.

## 2.5 Output schema completo

```json
{
  "schema_version": "1.0",
  "department": "scope_analysis",
  "timestamp": "ISO-8601",

  "inputs_summary": {
    "validation_slug": "string",
    "profile_user_slug": "string | null",
    "has_profile": true,
    "validation_verdict": "GO | PIVOT | NO-GO",
    "user_overrides": {}
  },

  "classification": {
    "customer": "B2B",
    "customer_secondary": null,
    "format": "SaaS",
    "distribution": ["content-driven", "sales-driven"],
    "stage": "pre-launch",
    "cultural_scope": "regional-LATAM"
  },

  "brand_profile": {
    "primary": "b2b-smb",
    "primary_confidence": 0.84,
    "secondary": null,
    "composition_weights": {"b2b-smb": 1.0}
  },

  "requires_user_confirmation": false,
  "confirmation_options": null,
  "confirmation_context": null,

  "output_manifest": {
    "brand_document_sections": {
      "required": [
        "cover", "brand_essence", "voice_tone", "palette",
        "typography", "logo", "visual_principles", "copy_samples"
      ],
      "optional_recommended": ["mood_atmosphere", "case_study_framing"],
      "skip": ["manifesto_page", "app_icon_grid"],
      "out_of_scope_declared": ["motion_guidelines", "sonic_guidelines"]
    },
    "prompts_library": {
      "required": [
        "landing_hero", "landing_features", "pricing_page",
        "about_page", "linkedin_post_templates[3]", "email_welcome",
        "pitch_one_liner_graphic"
      ],
      "optional_recommended": ["case_study_template", "press_release_template"],
      "skip": ["tiktok_post", "instagram_story", "app_store_listing", "podcast_cover", "manifesto_page"]
    },
    "brand_tokens": {
      "required": ["tokens.css", "tokens.json", "tailwind.config", "fonts.css", "examples/button", "examples/card", "examples/hero"]
    },
    "reference_assets": {
      "required": ["logo_primary", "logo_mono", "logo_inverse", "logo_icon_only", "favicon_set"],
      "optional_recommended": ["mood_imagery_refs", "sample_application"]
    }
  },

  "intensity_modifiers": {
    "verbal_register": "professional-warm",
    "copy_depth": "medium",
    "visual_formality": "medium",
    "logo_primary_form": "wordmark-preferred",
    "typography_era": "neutral-modern",
    "social_presence_priority": "professional-multichannel",
    "app_asset_criticality": "derivative",
    "print_needs": "minimal",
    "sonic_needs": "none",
    "motion_needs": "none"
  },

  "archetype_constraints": {
    "blocked": ["Jester", "Outlaw"],
    "preferred_range": ["Sage", "Ruler", "Hero", "Everyman"],
    "reasoning": "string — why these are blocked vs preferred for this classification + profile"
  },

  "reasoning_trace": {
    "classification_signals": {},
    "profile_matching_scores": {},
    "modifier_decisions": {}
  }
}
```

## 2.6 Persistencia

`brand/{idea-slug}/scope` en Engram. Save via el sub-agent al final de su ejecución, siguiendo `skills/_shared/engram-convention.md` y `skills/_shared/department-protocol.md`.

## 2.7 User interaction

El sub-agent de Scope Analysis no interactúa directamente con el user. Cualquier interacción (confirmación de classification ambigua, user override) la media el orchestrator:

- Si `requires_user_confirmation: true`: orchestrator renderiza las `confirmation_options` y re-invoca el sub-agent con el override aplicado
- Si user aplicó override pre-run (ej. `/brand:override brand_profile=b2b-enterprise`): orchestrator pasa el override en los inputs iniciales

## 2.8 Edge cases

### Idea ambigua, múltiples matches cercanos
Si primary y secondary tienen scores dentro de 1 punto, forzar user confirmation (flag `requires_user_confirmation: true`).

### Idea que no matchea ningún profile bien
`primary_confidence < 0.5` → fallback a `b2b-smb` con flag `low_confidence_classification: true` + prompt de user confirmation obligatorio. El user puede elegir otro profile o describir manualmente.

### Idea híbrida
`primary + secondary` con `composition_weights`. El output manifest toma union de required sections/prompts. Intensity modifiers se derivan con primary dominante; secondary aporta modificadores donde no conflictan.

### Profile ausente
Proceed con idea + validation solamente. Archetype constraints relajadas (sin profile-based blocks). Flag `decided_without_profile: true` en el output.

### Profile con completeness < 0.4
Mismo tratamiento que profile ausente pero con flag `decided_with_partial_profile: true`. Las partes del profile que sí están disponibles se aplican a los modifiers; las ausentes se ignoran.

## 2.9 Archivos a escribir en Sprint 0

Para este depto:
- `skills/brand/scope-analysis/SKILL.md` — sub-agent instructions. **Incluye inline**: rubric de signals per eje, matching algorithm con pseudocódigo, decision tree para intensity modifiers, ejemplos trabajados para los 8 canonical profiles y 5-10 casos híbridos
- `skills/brand/scope-analysis/references/data-schema.md` — output schema + assembly checklist

Las refs standalone (archetype-guide, brand-profiles, coherence-rules) viven a nivel orchestrator y son consumidas por Scope Analysis via cross-reference.

## 2.10 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos mínimos:

1. Idea B2B SaaS clara → `b2b-smb` con confidence ≥ 0.8
2. Idea consumer mobile app clara → `b2c-consumer-app` con confidence ≥ 0.8
3. Idea híbrida B2D + community → primary + secondary ambos con composition_weights
4. Idea ambigua (score cercano) → `requires_user_confirmation: true`
5. Idea local service → `b2local-service` correctamente, manifest compacto
6. Idea sin profile → proceeds con `decided_without_profile: true`
7. User override previo → manifest respeta hints
8. User override post-confirmation → re-invocación del sub-agent produce output consistente

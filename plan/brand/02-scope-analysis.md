# 02 — Scope Analysis (Paso 0)

## 2.1 Propósito

Clasificar el tipo de idea y producir un **manifest de scope** que define:
- Qué outputs aplican (`required`, `optional_recommended`, `skip`, `out_of_scope_declared`)
- Qué modificadores de intensidad aplicar (`verbal_register`, `visual_formality`, etc.)
- Qué archetypes están bloqueados o preferidos
- Qué tier de image gen usar por default

Este manifest es el **contrato** que los 5 deptos downstream consumen para adaptar su ejecución al tipo de idea.

## 2.2 Ejecución — inline en orchestrator (no sub-agente)

Scope Analysis se ejecuta directamente por el orchestrator de Brand (patrón equivalente a `/profile:show` en el módulo Profile). No es un sub-agente separado porque:

- Es razonamiento liviano sin tools externos
- Lanzar sub-agente agrega overhead (context window, tool setup) sin beneficio
- El output es consumido inmediatamente por todos los deptos

Si en el futuro la complejidad crece, se convierte a sub-agente. En v1, inline.

## 2.3 Inputs

### Obligatorios (retrieved via Engram)
- `validation/{slug}/report` (verdict, scores, flags)
- `validation/{slug}/problem` (target audience real, pain points, user research)
- `validation/{slug}/market` (SOM, segmentos, geografías)
- `validation/{slug}/competitive` (incumbents, visual landscape del mercado)
- `validation/{slug}/bizmodel` (modelo de revenue, pricing — informa distribution)
- Idea text original

### Opcionales
- `profile/{user-slug}/core` + `extended`
- User overrides explícitos (ej: `"tono formal"`, `"tier premium"`)

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

```python
def match_brand_profile(classification, canonical_profiles):
    scores = {}
    for profile in canonical_profiles:
        score = 0
        if classification.customer in profile.expected_customer:
            score += 3
        if classification.format in profile.expected_format:
            score += 3
        if any(d in profile.expected_distribution for d in classification.distribution):
            score += 2
        if classification.stage in profile.expected_stage:
            score += 1
        if classification.cultural_scope in profile.expected_cultural_scope:
            score += 1
        scores[profile.id] = score
    
    primary = max(scores.items(), key=lambda x: x[1])
    primary_confidence = primary[1] / 10
    
    return {
        "primary": primary[0],
        "primary_confidence": primary_confidence,
        "secondary": next_best if significant else None,
        "composition_weights": normalize(...)
    }
```

**Threshold**: `primary_confidence < 0.7` triggers user confirmation.

### Paso C — Generar output manifest

Para cada output posible del módulo (ver matriz en [03-brand-profiles.md](./03-brand-profiles.md)), marcar estado:

- `required`: siempre se genera
- `optional_recommended`: se genera si scope lo soporta
- `skip`: se omite silenciosamente
- `out_of_scope_declared`: v1 no cubre

**Nota**: el manifest refleja los outputs que **nosotros producimos** (naming, brand document sections, logo variants, prompts específicos por deliverable). La generación de UI (landing, decks, mockups) la ejecuta Claude Design downstream — no se lista en nuestro manifest como output nuestro, se lista como **prompt** en el Prompts Library.

### Paso D — Intensity modifiers

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
  "motion_needs": "none | subtle | expressive",
  "image_gen_tier": "0 | 1 | 2"
}
```

**Modifier `image_gen_tier`**: default `0` (Tier 0, zero cost). Puede ser elevado por user override `/brand:new --tier=1` o por scope requirement (ej: si `b2c-consumer-app` requiere symbolic app icon, auto-elevates a Tier 1).

### Paso E — Archetype constraints

Según brand profile + user profile:

| Brand profile | Archetypes bloqueados típicos |
|---|---|
| `b2b-enterprise` | Jester, Outlaw, Rebel |
| `b2b-smb` | Outlaw, Rebel (sin soporte profile) |
| `b2d-devtool` | Caregiver |
| `b2c-consumer-app` | Ruler típicamente |
| `community-movement` | Ruler |
| `b2local-service` | Outlaw, Rebel |

Plus profile-based blocks:
- `profile.risk_tolerance: low` → Outlaw, Hero bloqueados
- `profile.primary_goal: calm` → Jester, Hero, Outlaw bloqueados

### Paso F — Confidence assessment

Si `confidence < 0.7`, pause y ask user:

```
Clasifiqué tu idea como B2B SMB SaaS (confidence 0.62).

Señales principales:
- Target audience: compliance officers de fintechs
- Pricing model: subscription $200-500/mo
- Distribution: content + outbound

¿Te suena correcto?
  1. ✓ Correcto (b2b-smb)
  2. Es B2B enterprise (large companies, $50K+)
  3. Es B2D (developer tool)
  4. Es B2C consumer
  5. Otra (describila)
```

## 2.5 Output schema completo

```json
{
  "schema_version": "1.0",
  "department": "scope_analysis",
  "timestamp": "ISO-8601",
  "inputs_summary": {
    "validation_slug": "...",
    "profile_user_slug": "..." | null,
    "has_profile": true | false,
    "validation_verdict": "GO | PIVOT | NO-GO",
    "user_overrides": {}
  },
  "classification": {
    "customer": "B2B",
    "customer_secondary": null,
    "format": "SaaS",
    "distribution": ["content-driven", "outbound-sales"],
    "stage": "pre-launch",
    "cultural_scope": "regional-LATAM"
  },
  "brand_profile": {
    "primary": "b2b-smb",
    "primary_confidence": 0.84,
    "secondary": null,
    "composition_weights": {"b2b-smb": 1.0}
  },
  "output_manifest": {
    "brand_document_sections": {
      "required": [
        "cover", "brand_essence", "voice_tone", "palette",
        "typography", "logo", "visual_principles", "copy_samples"
      ],
      "optional_recommended": ["mood_atmosphere"],
      "conditional_on_tier": ["mood_imagery_generated"]
    },
    "prompts_library": {
      "required": [
        "landing_hero", "landing_features", "pricing_page",
        "about_page", "linkedin_post_templates[3]", "email_welcome",
        "pitch_one_liner_graphic"
      ],
      "optional_recommended": [
        "case_study_template", "press_release_template"
      ],
      "skip": [
        "tiktok_post", "instagram_story", "app_store_listing",
        "podcast_cover", "manifesto_page"
      ]
    },
    "brand_tokens": {
      "required": ["tokens.css", "tokens.json", "tailwind.config", "fonts.css", "examples/button", "examples/card", "examples/hero"]
    },
    "reference_assets": {
      "required": ["logo_primary", "logo_mono", "logo_inverse", "logo_icon_only", "favicon_set"],
      "conditional_on_tier": ["mood_imagery[6]", "sample_application"]
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
    "motion_needs": "none",
    "image_gen_tier": 0
  },
  "archetype_constraints": {
    "blocked": ["Jester", "Outlaw"],
    "preferred_range": ["Sage", "Ruler", "Hero", "Everyman"],
    "reasoning": "..."
  },
  "reasoning_trace": {
    "classification_signals": {...},
    "profile_matching_scores": {...},
    "modifier_decisions": {...}
  }
}
```

## 2.6 Persistencia

`brand/{idea-slug}/scope` en Engram.

## 2.7 User interaction

- Si `confidence < 0.7`: ask-for-confirmation prompt
- Si user override: applied before scope generation
- Si confidence ≥ 0.7: proceed sin interrupción

## 2.8 Edge cases

### Idea ambigua, múltiples matches cercanos
- Si primary y secondary tienen scores casi iguales, force user confirmation

### Idea que no matchea ningún profile bien
- `confidence < 0.5` → fallback a `b2b-smb` con flag `"low_confidence_classification: true"` + ask manual description

### Idea híbrida
- `primary + secondary` con composition_weights
- Output manifest toma union de required
- Intensity modifiers: weighted average / primary dominante

### Profile ausente
- Proceed con idea + validation
- Archetype constraints relajadas (sin profile-based blocks)
- Flag `"decided_without_profile: true"`

## 2.9 Reference file a escribir en Sprint 0

`skills/brand/references/scope-analysis-rubric.md` contiene:
- Tabla expandida de señales per eje
- Algoritmo de matching con pseudocódigo
- Decision tree completo para intensity modifiers
- Ejemplos trabajados para las 8 canonical profiles
- Ejemplos trabajados para 5-10 casos híbridos
- Cómo auto-elevar tier según requirements del scope

## 2.10 Testing de Scope Analysis

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos mínimos:

1. Idea B2B SaaS clara → clasifica `b2b-smb` con confidence ≥ 0.8
2. Idea consumer mobile app clara → clasifica `b2c-consumer-app` con confidence ≥ 0.8
3. Idea híbrida B2D + community → primary/secondary ambos
4. Idea ambigua → triggers user confirmation
5. Idea local service → clasifica `b2local-service` correctamente
6. Idea sin profile → proceeds with flag
7. User override previo → manifest respeta hints
8. Scope auto-eleva a Tier 1 cuando `b2c-consumer-app` requiere app icon symbolic

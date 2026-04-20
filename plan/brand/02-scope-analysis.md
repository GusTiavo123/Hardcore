# 02 — Scope Analysis (Paso 0)

## 2.1 Propósito

Clasificar el tipo de idea y producir un **manifest de scope** que define:
- Qué outputs aplican (`required`, `optional_recommended`, `skip`, `out_of_scope_declared`)
- Qué modificadores de intensidad aplicar (`verbal_register`, `visual_formality`, etc.)
- Qué archetypes están bloqueados o preferidos

Este manifest es el **contrato** que los 5 deptos downstream consumen para adaptar su ejecución al tipo de idea.

## 2.2 Ejecución — inline en orchestrator (no sub-agente)

Scope Analysis se ejecuta directamente por el orchestrator de Brand (patrón equivalente a `/profile:show` en el módulo Profile). No es un sub-agente separado porque:

- Es razonamiento liviano sin tools externos
- Lanzar sub-agente agrega overhead (context window, tool setup) sin beneficio
- El output es consumido inmediatamente por todos los deptos

Si en el futuro la complejidad crece (ej: Scope requiere web research para benchmarks), se convierte a sub-agente. En v1, inline.

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
- User overrides explícitos (ej: `"tono formal"`, `"no me interesa presencia social"`)

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
| `Internal` | Product para uso interno de organizaciones, no GTM externo |

**Señales cruzadas**: una idea puede ser `B2B` pero con componente `B2D` (ej: SaaS B2B con API developer-facing). El eje captura el **primary**; en casos híbridos se registra ambos.

#### Eje 2: `format` — cómo se entrega el producto

| Valor | Señales |
|---|---|
| `SaaS` | Software as a Service, web-based, subscription model, login requerido |
| `mobile-app` | App nativa iOS/Android, distribution via app stores |
| `physical-product` | Bien físico, requiere fulfillment, packaging real |
| `service-local` | Servicio prestado localmente (restaurante, clínica, barbería) |
| `service-global` | Servicio remoto (consultoría, freelancer platform, agency) |
| `content-media` | Newsletter, podcast, YouTube channel, blog monetizable |
| `community` | Comunidad estructurada (Discord, Slack, forum) posiblemente monetizada |
| `marketplace` | Plataforma dos lados (buyers + sellers) |
| `API` | Developer-facing API como producto |

#### Eje 3: `distribution` — cómo llega el producto al cliente

Array multi-valor. Un producto puede tener varios canales primarios:

| Valor | Señales |
|---|---|
| `sales-driven` | Enterprise/high-ticket, outbound sales, demos |
| `social-driven` | Consumer, TikTok/IG viral, influencer partnerships |
| `community-driven` | Discord/Slack, grassroots, word of mouth |
| `content-driven` | SEO, blog, newsletter, thought leadership |
| `SEO-driven` | Organic search as primary channel |
| `app-store` | Mobile app, ASO-optimized |
| `marketplace` | Distribución via plataforma de terceros |
| `partnership-driven` | Canales de partners, reseller networks |
| `PR-driven` | Earned media, press coverage |

**Regla**: tomar los top 2 canales primarios inferibles del BizModel + Market depts.

#### Eje 4: `stage` — madurez de la idea

| Valor | Señales |
|---|---|
| `pre-launch` | No lanzado aún, needs waitlist + landing + brand foundation |
| `MVP` | Lanzando o recién lanzado, needs conversion-optimized landing + onboarding |
| `growth` | Post-product/market fit, needs content engine + paid ads + social |
| `scale` | Late-stage, needs enterprise sales materials + case studies |

Inferir del profile + validation. Si ambiguo, default a `pre-launch` (asumir peor caso — máxima cantidad de assets foundational needed).

#### Eje 5: `cultural_scope` — alcance cultural/geográfico

| Valor | Señales |
|---|---|
| `global` | Target internacional, inglés primario, no location-bound |
| `regional-LATAM` | Target en LATAM, español (posiblemente portugués para Brasil) |
| `regional-US` | Target US primario |
| `regional-EU` | Target Europa |
| `local` | City/country specific (restaurant, local service) |
| `niche-community` | Target es una comunidad específica (vegan developers, etc.) |

### Paso B — Matching a brand profile canónico

Dados los 5 ejes clasificados, matchear contra los 8 brand profiles canónicos (definidos en [03-brand-profiles.md](./03-brand-profiles.md)) usando similarity scoring:

```python
# Pseudocódigo
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
    
    sorted_matches = sorted(scores.items(), key=lambda x: -x[1])
    
    primary = sorted_matches[0]
    primary_score = primary[1]
    primary_confidence = primary_score / 10  # max possible
    
    secondary = None
    if len(sorted_matches) > 1:
        secondary_score = sorted_matches[1][1]
        if secondary_score / primary_score > 0.70:
            # Segunda clasificación con peso significativo
            secondary = sorted_matches[1]
    
    return {
        "primary": primary[0],
        "primary_confidence": primary_confidence,
        "secondary": secondary[0] if secondary else None,
        "composition_weights": normalize(primary_score, secondary_score if secondary else 0)
    }
```

**Threshold de confidence**: si `primary_confidence < 0.7`, triggerea user confirmation.

### Paso C — Generar output manifest

Para cada output posible del módulo (ver matriz completa en [03-brand-profiles.md](./03-brand-profiles.md)), marcar estado basado en el brand profile matching:

- `required`: siempre se genera
- `optional_recommended`: se genera si el scope lo soporta sin fricción (ej: scope no lo excluye explícitamente)
- `skip`: se omite silenciosamente (ahorra tokens, ahorra costo)
- `out_of_scope_declared`: el módulo declara que NO puede cubrir esto en v1 (ej: packaging físico)

### Paso D — Intensity modifiers

Parámetros numéricos/enum que modifican cómo los deptos downstream ejecutan:

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

Cada brand profile tiene defaults para estos modifiers; Scope Analysis puede ajustarlos basado en señales específicas del profile del founder.

### Paso E — Archetype constraints

Algunos archetypes son incompatibles con ciertos scopes:

| Brand profile | Archetypes bloqueados | Razón |
|---|---|---|
| `b2b-enterprise` | Jester, Outlaw, Rebel (a menos que founder específico lo sostiene) | Baja credibilidad en contextos corporate conservadores |
| `b2b-smb` | Outlaw, Rebel (sin soporte específico) | Puede alienar SMB decision makers |
| `b2d-devtool` | Caregiver (raro, no matchea dev culture) | — |
| `b2c-consumer-app` | Ruler (puede sentirse rígido) | — |
| `community-movement` | Ruler (contradice el spirit) | — |
| `b2local-service` | Outlaw, Rebel | Mercado local conservador típicamente |
| Si `profile.risk_tolerance == "low"` | Outlaw, Hero | Contradicen el profile |
| Si `profile.introverted == true` o `primary_goal == "calm"` | Jester, Hero | — |

Retornar `blocked` + `preferred_range` + `reasoning`.

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
    "customer_secondary": null | "B2D",
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
    "required": [
      "strategy.positioning",
      "strategy.archetype",
      "strategy.voice",
      "verbal.name",
      "verbal.tagline",
      "verbal.hero_copy",
      "verbal.value_props_3versions",
      "verbal.about_short",
      "verbal.about_medium",
      "verbal.cta_copy",
      "verbal.email_templates_transactional",
      "verbal.linkedin_bio_company",
      "verbal.linkedin_bio_personal",
      "verbal.sample_posts_linkedin_5",
      "verbal.pitch_oneliner",
      "visual.palette_primary",
      "visual.palette_alternates_2",
      "visual.typography",
      "visual.mood_imagery_6",
      "visual.principles",
      "logo.primary",
      "logo.mono",
      "logo.inverse",
      "logo.icon_only",
      "logo.favicon_set",
      "logo.og_card",
      "logo.profile_picture",
      "logo.linkedin_cover",
      "activation.landing",
      "activation.pricing_page",
      "activation.about_page",
      "activation.brand_book_pdf",
      "activation.design_md",
      "activation.audit_md"
    ],
    "optional_recommended": [
      "verbal.case_study_template",
      "verbal.press_release_boilerplate",
      "verbal.pitch_30s",
      "verbal.faq_seed_10",
      "verbal.email_sequence_welcome",
      "activation.email_signature_template"
    ],
    "skip": [
      "verbal.tiktok_bio",
      "verbal.instagram_templates",
      "verbal.podcast_cover_copy",
      "verbal.whatsapp_templates",
      "verbal.manifesto_document",
      "logo.app_icon_full_set",
      "logo.app_icon_masks",
      "activation.social_post_templates_instagram",
      "activation.social_post_templates_tiktok",
      "activation.app_landing_storestyle",
      "activation.community_page"
    ],
    "out_of_scope_declared": [
      "packaging_3d",
      "print_cmyk_ready",
      "motion_assets",
      "sonic_branding",
      "photography_real"
    ]
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
    "reasoning": "B2B SaaS pre-launch con cultural_scope LATAM excluye archetypes con baja credibilidad en contextos profesionales conservadores. Sage es el más probable dado el signal del target audience (compliance officers) y del profile del founder (analytical, ex-corporate)."
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

Topic key consistent. Upsert if re-run (new scope manifest sobreescribe, old snapshot available via Engram history).

## 2.7 User interaction

### Caso A: confidence ≥ 0.7 — proceder sin interrupción

El manifest se genera y se pasa a Strategy sin preguntar. El reveal al user incluye un resumen del scope detectado ("clasifiqué tu idea como X") para transparencia, pero no espera input.

### Caso B: confidence < 0.7 — ask for confirmation

```
Clasifiqué tu idea como B2B SMB SaaS (confidence 0.62 — medio).

Señales que me llevaron ahí:
- Target audience del Problem dept: compliance officers de fintechs
- Revenue model del BizModel: subscription pricing $200-500/mo
- Distribution implícita: content + outbound

¿Te suena correcto, o querés ajustar?
  1. ✓ Correcto
  2. Es B2B enterprise (large companies)
  3. Es B2B consumer hybrid (prosumers)
  4. Es B2D (developer tool con component fintech)
  5. Otra clasificación (describila)
```

User elige. Si usa la opción 5, re-ejecuta clasificación con el input.

### Caso C: user override explícito

Si el user dijo al invocar el módulo algo como `"brand this idea, tone formal, no social"`, parsear esos hints y pre-ajustar el manifest. No es override del brand profile (sigue siendo detectado) pero modifica los `intensity_modifiers` respectivamente.

## 2.8 Edge cases

### Idea ambigua, múltiples matches cercanos
- Si primary y secondary tienen scores casi iguales (<10% diferencia), forzar user confirmation aunque confidence sea > 0.7
- Presentar ambas opciones: "Podría ser b2b-smb o b2d-devtool. ¿Cuál te queda mejor?"

### Idea que no matchea ninguno de los 8 profiles
- Fallback a `b2b-smb` con flag `"low_confidence_classification: true"`
- Ask for user to describe manually si es algo novedoso
- Permitir scope custom (registrar para futuro análisis — puede sugerir nuevo profile)

### Idea híbrida (ej: B2B + consumer educational content)
- `primary + secondary` con weights
- Output manifest toma union de required de ambos
- Intensity modifiers: weighted average para escalas continuas, rules específicas para categóricas (ej: primary gana el register si weight > 0.6)

### Profile ausente
- Scope Analysis igual procede con idea + validation only
- Archetype constraints relajados (no hay profile info para bloqueos adicionales)
- Flag en output: `"decided_without_profile: true"`

## 2.9 Reference file a escribir en Sprint 0

`skills/brand/references/scope-analysis-rubric.md` contiene:
- Tabla expandida de señales per eje
- Algoritmo de matching con pseudocódigo
- Decision tree completo para intensity modifiers
- Ejemplos trabajados para las 8 canonical profiles
- Ejemplos trabajados para 5-10 casos híbridos

## 2.10 Testing de Scope Analysis

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos de test mínimos:

1. Idea B2B SaaS clara → clasifica `b2b-smb` con confidence ≥ 0.8
2. Idea consumer mobile app clara → clasifica `b2c-consumer-app` con confidence ≥ 0.8
3. Idea híbrida B2D + community → primary/secondary ambos
4. Idea ambigua → triggers user confirmation
5. Idea local service → clasifica `b2local-service` correctamente
6. Idea sin profile → proceeds with flag
7. User override previo → manifest respeta hints

## 2.11 Cambios posibles post-v1

- Aprender de runs reales: si el mismo tipo de idea aparece muchas veces y no encaja bien, considerar agregar un nuevo canonical profile
- Tuning de weights del algoritmo de matching (inicialmente todos igual importancia, puede ajustarse)
- Agregar señales nuevas (ej: idioma del pitch, industria específica)
- Eventualmente: ML model trained sobre runs históricos para clasificación automática

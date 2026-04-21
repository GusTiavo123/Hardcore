# 05 — Department 2: Verbal Identity

## 5.1 Propósito

Todo lo **verbal** que nuestro módulo produce — **naming con verificación externa + core copy assets** que alimentan el Brand Document + viajan a los prompts del Prompts Library.

Verbal Identity genera solo lo necesario para alimentar el brief:

- Naming (completo con verification)
- Core copy: tagline, hero headline/sub, value props, about short, CTAs, pitch one-liner
- Voice examples (do/don'ts rendered con copy samples)

**El copy específico long-form** (emails completos, sample social posts long-form, press releases completas, long-form about) lo **genera Claude Design** cuando el user ejecuta los prompts del Prompts Library, usando nuestros voice attributes como guía.

## 5.2 Inputs

### Obligatorios
- `brand/{slug}/scope` (manifest — determina qué core copy assets generar)
- `brand/{slug}/strategy` (archetype, voice_attributes, positioning, target, brand_values, promise)

### Opcionales
- Profile (idioma primario, cultural context, target_geographies)
- Validation Problem + Competitive (categoría del mercado, terminología del industry)

## 5.3 Proceso — 4 fases

### Fase A — Naming generation

**Paso 1: Generar 15-20 candidatos** usando múltiples estrategias, modulado por scope:

| Estrategia | Preferida en |
|---|---|
| Descriptive | `b2b-enterprise`, `b2b-smb` |
| Compound | B2B, dev tools |
| Abstract | Consumer, movements, luxury |
| Invented | Consumer apps, dev tools |
| Metaphorical | Community, content, movements |
| Acronym functional | B2B dev tools |
| Founder-derived | Consultoría, content-creator |
| Place-derived | Local services, regional |
| Number/word-play | Consumer apps, creator brands |

**Paso 2: Filtro inicial** (Claude reasoning):
- Pronunciable en target_geographies
- Spelling-forgiving
- No colisión con términos técnicos
- Memorable en 3 segundos
- 4-12 caracteres idealmente

Reducir de 15-20 a **10-12 candidates** para verification.

### Fase B — Verification (paralelo)

**Paso 3: Domain availability** vía `imprvhub/mcp-domain-availability`:
- TLDs: `.com`, `.io`, `.ai`, `.app`, `.co` + geografías de profile
- Bulk request para los 10-12 candidatos

**Paso 4: Trademark screening** vía `open-websearch`:
- Queries dirigidas por jurisdicción (USPTO, EUIPO, INPI, IMPI, SIC)
- Flags: green / yellow / red
- **Disclaimer obligatorio**: "Screening preliminar. No sustituye consulta legal."

**Paso 5: Linguistic check**:
- Connotaciones negativas en target_geographies
- Existing brand collisions

### Fase C — Ranking + Selection

**Paso 6: Weighted scoring**:
- Availability (domain + TM): 40%
- Strategic fit (archetype + positioning): 30%
- Memorability/pronunciability: 20%
- Linguistic safety: 10%

**Paso 7: User selection**:
- Top 5-7 presentados
- User pick o auto-pick en fast mode / dominant candidate

### Fase D — Core copy generation (con nombre locked)

**Paso 8: Generar core copy assets** definidos en `scope.output_manifest` para Verbal:

#### Core assets (casi todos los scopes)

| Asset | Descripción | Variants |
|---|---|---|
| Tagline | Frase icónica | 3 (corta 2-4w, media 5-7w, aspiracional 8+w) |
| Hero headline | Primera impresión landing | 1 primary + 2 alternatives |
| Hero subheadline | Support al headline | 1 |
| Value propositions | Por qué elegir | 3 versiones (1-line, paragraph, 3-bullet-list) |
| About short | 1 párrafo | 1 |
| About medium | 3 párrafos | 1 |
| CTA copy | Primary + secondary | 2 |
| Pitch one-liner | Elevator | 1 |
| FAQ seed | 10 Q&As seed | 10 |

#### Social bios core (por scope)

| Asset | Scope que lo triggerea |
|---|---|
| LinkedIn bio company + personal | B2B, B2D |
| Twitter/X bio (160 chars) | B2D, content-media, b2c-web |
| Instagram bio (150 chars) | consumer-app, consumer-web, content-media, local |
| TikTok bio (80 chars) | consumer-app, content-media (young target) |

#### Pitch materials core (condicional)

| Asset | Scope |
|---|---|
| Pitch 30s | `b2b-enterprise`, `b2b-smb`, some `b2c` |
| Pitch deck cover slide copy | `b2b-enterprise` required |

#### Communication core

| Asset | Scope |
|---|---|
| Email signature | Most scopes |
| WhatsApp greeting seed | `b2local-service` |
| Phone greeting script | `b2local-service` |

#### Developer-specific (b2d-devtool)

| Asset | Scope |
|---|---|
| GitHub README excerpt | `b2d-devtool` |
| CLI help text seed | `b2d-devtool` |

#### Community (community-movement)

| Asset | Scope |
|---|---|
| Manifesto opening + structure | `community-movement` |
| Recruiting copy core | `community-movement` |

#### Consumer app (b2c-consumer-app)

| Asset | Scope |
|---|---|
| App store description short | `b2c-consumer-app` |
| App store description long | `b2c-consumer-app` |

**Lo que NO generamos aquí (delegado a Claude Design)**:
- Emails completos (welcome sequence, onboarding sequence) — prompt va en Library
- Sample social posts 5-10 long-form — prompt va en Library
- Press release completo — prompt va en Library
- Full case study — prompt va en Library
- Blog post completo — prompt va en Library
- Email template HTML aplicado — Claude Design

### Paso 9: Voice self-check

Cada asset pasa por self-check interno:
- ¿Exhibe detectably los voice attributes?
- Si no: regenerate con voice reminder, max 2 retries
- Si persiste: include con flag

## 5.4 Tools

- `imprvhub/mcp-domain-availability` — domain verification
- `open-websearch` — trademark + linguistic research
- Claude native — toda la generación verbal

## 5.5 Output schema

```json
{
  "schema_version": "1.0",
  "status": "ok",
  "department": "verbal",
  "scope_ref": "...",
  "strategy_ref": "...",
  
  "naming_artifact": {
    "candidates_all": [...20 candidates],
    "candidates_verified": [...7 top candidates con verification matrix],
    "chosen": "Auren",
    "chosen_rationale": "...",
    "user_selection_method": "user-picked | auto-picked | dominant-auto-picked",
    "disclaimer": "Screening preliminar. No sustituye consulta legal."
  },
  
  "core_copy_artifact": {
    "taglines": [
      {"length": "short", "text": "Audit the audits."},
      {"length": "medium", "text": "..."},
      {"length": "aspirational", "text": "..."}
    ],
    "hero": {
      "primary": {"headline": "...", "subheadline": "..."},
      "alternatives": [...]
    },
    "value_props": {
      "one_line": "...",
      "paragraph": "...",
      "three_bullets": ["...", "...", "..."]
    },
    "about": {"short": "...", "medium": "..."},
    "cta": {"primary": "...", "secondary": "..."},
    "pitch": {
      "one_liner": "...",
      "thirty_seconds": "..."
    },
    "social_bios": {
      "linkedin_company": "...",
      "linkedin_personal": "...",
      "twitter": "...",
      "instagram": "...",
      "tiktok": "..."
    },
    "communications_core": {
      "email_signature": "...",
      "whatsapp_greeting_seed": "..." (si b2local-service),
      "phone_greeting_script": "..." (si b2local-service)
    },
    "specialized_by_scope": {
      // b2d-devtool:
      "github_readme_excerpt": "...",
      "cli_help_seed": "...",
      // b2c-consumer-app:
      "app_store_short": "...",
      "app_store_long": "...",
      // community-movement:
      "manifesto_opening": "...",
      "recruiting_copy": "...",
      // b2b-enterprise:
      "pitch_deck_cover_slide": "..."
    },
    "faq_seed": [
      {"q": "...", "a": "..."},
      ...10 total
    ]
  },
  
  "self_check_results": {
    "all_assets_voice_compliant": true,
    "flagged_assets": [],
    "regeneration_count": 2
  },
  
  "evidence_trace": {...}
}
```

## 5.6 Persistencia

`brand/{slug}/verbal` en Engram.

## 5.7 Reveal al user

### Reveal intermedio (naming)

```
[7:14] ② Verbal Identity — verificando 12 candidatos...

[Progress: domain check ✓ · trademark screening ✓ · linguistic check ✓]

[9:14] Top 7 nombres

Nombre         .com  .io  .ai  .mx   TM   Fit  Mem  Score
Auren           ✓    ✓    ✓    ✓    ✓    9    9    9.1  ← top
RegClarity      ✗    ✓    ✓    ✓    ✓    9    8    8.2
...

Recomendado: Auren — todos dominios libres, TM clean, fit Sage fuerte.

¿Auren, otro, o más opciones?
```

### Reveal final (core copy)

```
[11:02] Core copy generado

Voice applied: {claro · autorizante · directo · empático-técnico}

HERO
  "Stop drowning in compliance spreadsheets."
  "Auren converts 40-hour regulatory audits into 2 supervised hours."
  CTA: "See it on your own data →"

TAGLINE
  "Audit the audits."

+ 12 assets más (value props, about, social bios, ...)

Note: copy específico por deliverable (emails completos, posts largos)
se genera via Claude Design usando los prompts del Library.
```

## 5.8 Relación con otros deptos

**Logo consume**:
- Nombre elegido para wordmarks + OG card
- Tagline para OG card

**Handoff Compiler consume**:
- Naming artifact → sección naming del Brand Document + metadata del package
- Core copy → Brand Document samples + inyectado en prompts del Library
- Voice examples → Brand Document voice section + referenced por cada prompt

## 5.9 Failure modes específicos

### 0 candidatos pasan verification
- Present raw candidates con conflicts matrix
- User decide: accept risk, regenerate con constraints, manual name

### Domain MCP down
- Retry 3× → skip verification con flag explícito

### Trademark search ambiguo
- Muchos yellow flags → flag, user decide (disclaimer obligatorio)

### User rechaza 3+ rounds
- Offer "manual name" mode

### Copy self-check falla persistently
- Include con annotation "voice compliance low — review manually"

## 5.10 SKILL.md a escribir en Sprint 0

`skills/brand/verbal/SKILL.md` con las 4 fases detalladas + asset list completa + self-check logic.

## 5.11 Reference files a escribir en Sprint 0

- `skills/brand/verbal/references/data-schema.md`
- `skills/brand/verbal/references/verification-protocol.md` — queries precisas por jurisdicción
- `skills/brand/verbal/references/naming-strategies-by-profile.md`
- `skills/brand/verbal/references/core-copy-matrix.md` — qué core assets por brand profile (reduced version)
- `skills/brand/verbal/references/voice-application-examples.md` — ejemplos do/don'ts

## 5.12 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Given Strategy con voice específico → todos los core assets exhibit voice detectably
2. Naming con `.com` todos taken → presenta alternatives gracefully
3. Trademark screening con hits rojos → excluye del top 5
4. Fast mode → auto-picks correctamente
5. Scope b2b-enterprise → genera pitch deck cover copy, NO generate TikTok bio
6. Scope b2c-consumer-app → genera app store descriptions
7. Scope community-movement → genera manifesto opening

# 05 — Department 2: Verbal Identity

## 5.1 Propósito

Todo lo **verbal** — naming con verificación externa + todo el copy aplicado. Una sola voice expresada en formatos distintos.

**Por qué naming + copy están juntos**: ambos son expresiones de la misma voice. Separarlos significa dos agentes interpretando voice distinto → disonancia entre nombre y copy. La verificación de naming (domain + TM) es un subprocess interno del depto.

## 5.2 Inputs

### Obligatorios
- `brand/{slug}/scope` (manifest — determina qué copy assets generar)
- `brand/{slug}/strategy` (archetype, voice_attributes, positioning, target, brand_values, promise)

### Opcionales
- Profile (idioma primario, cultural context, target_geographies)
- Validation Problem + Competitive (categoría del mercado, terminología del industry)

## 5.3 Proceso — 5 fases

### Fase A — Naming generation

**Paso 1: Generar 15-20 candidatos** usando múltiples estrategias, con preferencia modulada por `scope.intensity_modifiers.logo_primary_form` y brand profile:

| Estrategia | Descripción | Preferido en |
|---|---|---|
| Descriptive | Explica qué hace | `b2b-enterprise`, `b2b-smb` |
| Compound | Dos conceptos fusionados | B2B, dev tools |
| Abstract | No describe, se convierte en marca | Consumer, movements, luxury |
| Invented | Palabra nueva pronunciable | Consumer apps, dev tools |
| Metaphorical | Imagen evocativa | Community, content, movements |
| Acronym functional | Siglas con significado | B2B dev tools |
| Founder-derived | Usa nombre del founder | Consultoría, content-creator |
| Place-derived | Referencia lugar | Local services, regional brands |
| Number/word-play | Juegos con números o palabras | Consumer apps, creator brands |

Cada estrategia produce 2-4 candidatos. Mix balanceado entre las 3-4 más relevantes según scope.

**Paso 2: Filtro inicial** (Claude reasoning):

- Pronunciable en target_geographies (inglés default + idiomas de las geografías)
- Spelling-forgiving (si alguien escucha el nombre, puede escribirlo correctamente)
- No colisión con términos técnicos del space
- Memorable en 3 segundos (subjetivo pero evaluable)
- 4-10 caracteres idealmente (flexible, pero <12 para consumer)

Reducir de 15-20 a **10-12 candidates** para verification.

### Fase B — Verification (paralelo para todos los candidatos)

**Paso 3: Domain availability check**

Tool: `imprvhub/mcp-domain-availability` (ver [11-tools-stack.md](./11-tools-stack.md))

TLDs a chequear:
- Always: `.com`, `.io`, `.ai`, `.app`, `.co`
- Por profile.target_geographies: `.mx`, `.co`, `.ar`, `.cl`, `.uy`, `.br`, `.pe`, `.us` (LATAM), `.de`, `.fr`, `.es`, `.uk` (EU), etc.

Bulk request para los 10-12 candidatos simultáneamente.

Response esperada:
```json
{
  "Auren": {
    ".com": "available",
    ".io": "taken",
    ".ai": "available",
    ".app": "available",
    ".mx": "available"
  },
  "RegClarity": {...}
}
```

**Paso 4: Trademark screening**

Tool: `open-websearch` (ver [11-tools-stack.md](./11-tools-stack.md))

Queries dirigidas por jurisdicción:

- USPTO: `"{candidato}" site:tsdr.uspto.gov`
- EUIPO: `"{candidato}" site:tmview.europa.eu`
- INPI Argentina: `"{candidato}" site:inpi.gob.ar` (si geography incluye AR)
- IMPI México: `"{candidato}" site:gob.mx/impi` (si MX)
- SIC Colombia: `"{candidato}" site:sic.gov.co` (si CO)
- INAPI Chile: si CL
- INPI Brasil: si BR

Por cada candidato, Claude analiza resultados:

- **Green**: sin hits, o hits en categoría claramente no relacionada (ej: nombre de marca de comida vs software)
- **Yellow**: hits en categoría adjacente o no definitivo — precaución
- **Red**: hit exacto en misma categoría — bloqueante

**Disclaimer obligatorio en output**: *"Screening preliminar. Los resultados dependen de la precisión de la búsqueda web y no sustituyen una consulta con un profesional de propiedad intelectual."*

**Paso 5: Linguistic check**

Claude reasoning sobre cada candidato:

- Connotaciones negativas en idiomas de target_geographies
- Malas traducciones / cognados peligrosos
- Existing brand collisions en el space (brands conocidas con nombre similar)

Output: green / yellow / red per candidate, con explanation si flag.

### Fase C — Ranking

**Paso 6: Weighted scoring** de los 10-12 candidatos:

| Factor | Weight | Scoring |
|---|---|---|
| Availability (domain + TM green) | 40% | `.com` libre = 10; `.com` taken pero alternatives libres = 6; all taken = 2; TM red = 0 |
| Strategic fit (archetype + positioning) | 30% | Claude reasoning 0-10 |
| Memorability / pronunciability | 20% | Claude reasoning 0-10 |
| Linguistic safety | 10% | Binary (red = 0, else 10) |

Total: 0-10 score por candidato.

### Fase D — Selection

**Paso 7: Present top 5-7 al user**:

```
Nombre         .com  .io  .ai  .mx   TM   Fit  Mem  Score
Auren           ✓    ✓    ✓    ✓    ✓    9    9    9.1  ← top
RegClarity      ✗    ✓    ✓    ✓    ✓    9    8    8.2
Auditora        ✓    ✗    ✓    ✓    ⚠    7    7    6.5
Halo            ✗    ✗    ✗    ✗    ⚠    8    9    4.8
Watchtower      ✓    ✓    ✓    ✗    ✓    8    7    7.8
Veritas         ✗    ✗    ✓    ✓    ⚠    8    8    6.3

Recomendado: Auren
  - Todos dominios libres
  - TM clean en screening preliminar
  - Fit fuerte con archetype Sage (abstract, memorable)
  - Fácil pronunciar y escribir en ES/EN

¿Elegís Auren, otro, o querés más opciones?
```

**Decisión**:
- User pick explícito
- Auto-pick en fast mode O si top candidato domina (score > 2nd by 15%)
- Si user pide más opciones: regenerate con feedback ("quiero algo más corto" / "menos abstracto")

### Fase E — Copy generation

Con nombre locked, generar **todos los copy assets definidos en `scope.output_manifest.required` + `optional_recommended` para Verbal**.

**Paso 8: Generar cada asset** aplicando:
- Voice attributes del Strategy
- Register de intensity_modifiers
- Copy_depth modulation
- Idioma primario del scope

**Asset list expandida** (qué se genera según scope):

#### Core (casi todos los scopes)
| Asset | Descripción | Variants típicas |
|---|---|---|
| Tagline | Frase icónica de la marca | 3 versiones (corta 2-4 words, media 5-7 words, aspiracional 8+ words) |
| Hero headline | Primera impresión de landing | 1 primary + 2 alternatives |
| Hero subheadline | Support al headline | 1 |
| Value propositions | Por qué elegir | 3 versiones (1-line, paragraph, 3-bullet-list) |
| About section short | 1 párrafo | 1 |
| About section medium | 3 párrafos | 1 |
| CTA copy | Primary + secondary | 2 |
| Pitch one-liner | Elevator | 1 |
| FAQ seed | 10 Q&As en voice | 10 |

#### Social presence
| Asset | Scope que lo triggerea |
|---|---|
| LinkedIn bio company | B2B, B2D, content-creator con LinkedIn |
| LinkedIn bio personal | B2B, B2D, content-creator |
| LinkedIn sample posts (5) | B2B, B2D |
| Twitter/X bio (160 chars) | B2D, content-media, consumer-web |
| Twitter/X sample posts (5-10) | B2D, content-media |
| Instagram bio (150 chars) | consumer-app, consumer-web, content-media, local |
| Instagram sample posts (10) | consumer-app, consumer-web, content-media |
| TikTok bio (80 chars) | consumer-app, content-media (if younger target) |
| TikTok post concepts (5) | consumer-app |

#### Email & communications
| Asset | Scope |
|---|---|
| Email signature | Most scopes |
| Welcome email | SaaS scopes |
| Transactional emails (set) | SaaS scopes |
| Onboarding email sequence (5 emails) | `b2b-smb`, `b2c-consumer-web` |
| Press release boilerplate | `b2b-enterprise`, `b2b-smb` optional |
| WhatsApp greeting | `b2local-service` |
| WhatsApp FAQ | `b2local-service` |
| WhatsApp booking confirmation | `b2local-service` |
| Phone greeting script | `b2local-service` |

#### Pitch materials
| Asset | Scope |
|---|---|
| Pitch 30s (investor) | `b2b-enterprise`, `b2b-smb`, some `b2c` |
| Pitch deck cover slide copy | `b2b-enterprise` required, others optional |
| Pitch deck 10-slide template | `b2b-enterprise` |

#### Sales materials (B2B)
| Asset | Scope |
|---|---|
| Case study template | `b2b-enterprise` required, `b2b-smb` optional |
| Whitepaper boilerplate | `b2b-enterprise` |
| Comparison vs competitors | `b2b-smb` |

#### Content
| Asset | Scope |
|---|---|
| Blog post template | `b2b-smb`, `b2d-devtool`, `content-media` |
| Newsletter template | `content-media`, some `b2c-consumer-web` |
| Podcast show notes template | `content-media` (if podcast) |
| Video description template | `content-media` (if video) |
| Podcast cover copy | `content-media` |

#### Developer-specific (b2d-devtool)
| Asset | Scope |
|---|---|
| GitHub README template | `b2d-devtool` |
| Docs homepage copy | `b2d-devtool` |
| CLI help text style | `b2d-devtool` |
| Code snippet comments style | `b2d-devtool` |

#### Consumer app (b2c-consumer-app)
| Asset | Scope |
|---|---|
| App store description short | `b2c-consumer-app` |
| App store description long | `b2c-consumer-app` |
| Onboarding screen copy | `b2c-consumer-app` |
| Push notification templates | `b2c-consumer-app` |
| Referral/share copy | `b2c-consumer-app` |

#### Community (community-movement)
| Asset | Scope |
|---|---|
| Manifesto document (structured) | `community-movement` |
| Member onboarding sequence | `community-movement` |
| Recruiting copy | `community-movement` |
| Code of conduct template | `community-movement` |
| Discord/Slack welcome | `community-movement` |

#### Local (b2local-service)
| Asset | Scope |
|---|---|
| Google My Business copy | `b2local-service` |
| Printable flyer copy | `b2local-service` |
| Menu copy (if food) | `b2local-service` food subset |
| Business card copy | `b2local-service` |
| Signage copy direction | `b2local-service` |

### Paso 9: Self-check de voice

Cada asset generado pasa por self-check interno:

```
for each copy_asset:
  does_exhibit_voice = claude_check(copy_asset, voice_attributes)
  if not does_exhibit_voice:
    regenerate with explicit voice reminder
    max 2 retries
```

Si después de 2 retries no exhibe voice, flag pero incluir (el user puede ajustar manualmente).

## 5.4 Tools

- **`imprvhub/mcp-domain-availability`** — domain verification (ver [11-tools-stack.md](./11-tools-stack.md))
- **`open-websearch`** — trademark screening + linguistic research
- **Claude native** — toda la generación verbal (naming + copy)

## 5.5 Output schema

```json
{
  "schema_version": "1.0",
  "status": "ok",
  "department": "verbal",
  "scope_ref": "brand/{slug}/scope",
  "strategy_ref": "brand/{slug}/strategy",
  
  "naming_artifact": {
    "candidates_all": [
      {
        "name": "Auren",
        "strategy": "abstract",
        "rationale": "evocativo, corto, pronunciable ES/EN, no-descriptive permite category expansion"
      },
      ...18 more
    ],
    "candidates_verified": [
      {
        "name": "Auren",
        "domain_availability": {
          ".com": "available",
          ".io": "available",
          ".ai": "available",
          ".app": "available",
          ".mx": "available"
        },
        "trademark_screening": {
          "uspto": "green (no hits)",
          "euipo": "green",
          "impi": "green",
          "flag": "green"
        },
        "linguistic_check": {
          "flag": "green",
          "notes": "Sin connotaciones negativas detectadas en ES, EN, PT"
        },
        "strategic_fit_score": 9,
        "memorability_score": 9,
        "total_score": 9.1
      },
      ...6 more
    ],
    "chosen": "Auren",
    "chosen_rationale": "...",
    "user_selection_method": "user-picked | auto-picked | dominant-auto-picked",
    "disclaimer": "Screening preliminar. No sustituye consulta legal profesional."
  },
  
  "copy_artifact": {
    "taglines": [
      {"length": "short", "text": "Audit the audits."},
      {"length": "medium", "text": "Regulatory audits, simplified."},
      {"length": "aspirational", "text": "Because compliance should be clear, not cryptic."}
    ],
    "hero": {
      "primary": {
        "headline": "Stop drowning in compliance spreadsheets.",
        "subheadline": "Auren converts 40-hour regulatory audits into 2 supervised hours."
      },
      "alternatives": [...]
    },
    "value_props": {
      "one_line": "Cut audit time from 40h to 2h without sacrificing rigor.",
      "paragraph": "...",
      "three_bullets": ["...", "...", "..."]
    },
    "about": {
      "short": "...",
      "medium": "..."
    },
    "cta": {
      "primary": "See it on your own data →",
      "secondary": "Watch 2-min demo"
    },
    "pitch": {
      "one_liner": "...",
      "thirty_seconds": "..."
    },
    "social": {
      "linkedin_bio_company": "...",
      "linkedin_bio_personal": "...",
      "linkedin_sample_posts": [...5 posts]
    },
    "emails": {...},
    ...more assets según scope
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
    ...

    Recomendado: Auren — todos dominios libres, TM clean, fit fuerte Sage.

    ¿Auren, otro, o más opciones?
```

User pick. Entonces:

### Reveal final (copy)

```
[11:02] Copy generado

  Voice applied: {claro · autorizante · directo · empático-técnico}

  HERO
    "Stop drowning in compliance spreadsheets."
    "Auren converts 40-hour regulatory audits into 2 supervised hours."
    [See it on your own data →]

  TAGLINE
    "Audit the audits."

  + 18 assets más (value props, about, emails, LinkedIn, press release, ...)
     [Ver todos en brand/verbal output]

  Disclaimer: TM screening preliminar. Consultá abogado antes de registrar.
```

## 5.8 Relación con otros deptos

**Logo consume** el nombre para wordmarks + OG card design
**Activation consume** todo el copy para llenar el microsite generado por Stitch

## 5.9 Failure modes específicos

### 0 candidatos pasan verification
Todos tienen domain taken + TM red. Raro pero posible en spaces saturados (ej: fintech US).

- Acción: presentar candidatos con conflicts matrix al user
- User decide: agregar TLDs alternativos (`.tech`, `.finance`), usar modifier prefijo/suffix ("Get{Name}", "{Name}HQ"), o regenerate completamente con constraint "must be >6 chars" o "must be invented word"

### Domain MCP down
- Retry 3×
- Si persiste: skip verification, present candidatos con flag "verification no completada — chequear manualmente"

### Trademark search ambiguo
Muchos yellow flags (posibles conflicts no definitivos).
- Flag en output
- User decide si proceder (disclaimer obligatorio)

### User rechaza todas las opciones
Ej: 3 rounds de regeneration, user no le gusta ninguna.
- Tras 3 rounds, ofrecer modo "user provides name directly" — user da su nombre preferido y el dept lo verifica + genera copy

### Copy self-check falla persistently
Asset generado no exhibe voice tras 2 retries.
- Flag el asset
- Incluir en output con annotation "voice compliance low — revisar manualmente"

## 5.10 SKILL.md a escribir en Sprint 0

`skills/brand/verbal/SKILL.md` con las 5 fases detalladas, asset list completa, self-check logic.

## 5.11 Reference files a escribir en Sprint 0

- `skills/brand/verbal/references/data-schema.md`
- `skills/brand/verbal/references/verification-protocol.md` — queries precisas por jurisdicción, interpretation rules
- `skills/brand/verbal/references/naming-strategies-by-profile.md` — mapping profile → preferred naming strategies
- `skills/brand/verbal/references/copy-asset-matrix.md` — qué assets por brand profile (matriz completa)
- `skills/brand/verbal/references/voice-application-examples.md` — ejemplos per voice attribute de do/don'ts en cada asset type

## 5.12 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Given Strategy con voice específico → todos los assets exhibit voice detectably
2. Naming con `.com` todos taken → presenta alternatives gracefully
3. Trademark screening con hits rojos → los excluye del top 5
4. Fast mode → auto-picks correctamente
5. Scope b2b-enterprise → genera pitch deck copy, NO genera TikTok bio
6. Scope b2c-consumer-app → genera app store descriptions, NO pitch deck formal

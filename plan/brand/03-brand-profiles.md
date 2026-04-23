# 03 — Catálogo de los 8 Brand Profiles Canónicos

## 3.1 Qué son los brand profiles

Un brand profile es una **configuración canónica** que agrupa las decisiones típicas para un tipo de idea: qué outputs son required, qué skip, qué intensity modifiers usar por default, qué archetypes funcionan vs no funcionan.

**Importante**: los outputs listados reflejan **lo que nuestro módulo produce** (sections del Brand Document, prompts en el Library, assets en Reference folder). La UI final (landing, decks, mockups) la genera Claude Design — nosotros le damos los prompts correctos.

Live reference: `skills/brand/references/brand-profiles.md` (a escribir en Sprint 0).

## 3.2 Los 8 profiles — overview

| ID | Nombre | Customer tipo | Format típico | Stage frecuente |
|---|---|---|---|---|
| `b2b-enterprise` | Enterprise SaaS | Large companies | SaaS | scale |
| `b2b-smb` | SMB SaaS | SMBs/startups | SaaS | pre-launch / MVP / growth |
| `b2d-devtool` | Developer Tool | Developers/eng teams | SaaS, API, CLI | pre-launch / MVP |
| `b2c-consumer-app` | Consumer Mobile App | Mass consumer | mobile-app | pre-launch / MVP / growth |
| `b2c-consumer-web` | Consumer Web Product | Mass consumer | SaaS web / content-media | MVP / growth |
| `b2local-service` | Local Service | Local customers | service-local | any |
| `content-media` | Content/Creator Brand | Audience | content-media | growth / scale |
| `community-movement` | Community/Cause/Movement | Members | community | pre-launch / growth |

---

## 3.3 Profile 1 — `b2b-enterprise`

### Descripción
Enterprise SaaS — productos que se venden a grandes empresas via outbound sales, deal sizes $50K+ anuales, sales cycles 6-12 meses.

### Expected signals
- `customer: B2B` (large companies)
- `format: SaaS, API, service-global`
- `distribution: sales-driven, partnership-driven, content-driven`
- `stage: scale | growth`

### Outputs que nuestro módulo produce

**Brand Document sections required**: all (cover + brand essence + voice/tone formal + palette conservative + typography authoritative + logo wordmark + visual principles + copy samples)

**Prompts Library required** (para Claude Design):
- Landing page formal con security badges + logos de clientes placeholders
- Pricing page enterprise ("Contact sales" default)
- Security/compliance page (SOC2, GDPR, etc.)
- About page enterprise-oriented
- **Pitch deck prompt** (10-slide structure: problem, solution, market, competition, traction, team, ask)
- **Case study template prompt**
- Whitepaper prompt
- Email sequences enterprise (outbound cold, nurture)
- LinkedIn post templates (5, professional register)
- Press release prompt

**Reference Assets required**: logo full system + favicon + OG card + LinkedIn cover banner

**Skip**: TikTok bio prompt, Instagram consumer templates, app icon, podcast cover, WhatsApp templates

### Intensity modifiers defaults
```
verbal_register: "formal-professional"
copy_depth: "long-form-allowed"
visual_formality: "high"
logo_primary_form: "wordmark-preferred"
typography_era: "neutral-modern" (o "editorial-classic")
social_presence_priority: "enterprise-linkedin-only"
app_asset_criticality: "not-needed"
```

### Archetype constraints
- **Blocked**: Jester, Outlaw, Rebel
- **Preferred range**: Sage, Ruler, Hero, Caregiver, Creator
- **Sweet spots**: Sage, Ruler, Hero

### Ejemplos reales
Datadog, Snowflake, MongoDB, Stripe (enterprise).

---

## 3.4 Profile 2 — `b2b-smb`

### Descripción
SMB SaaS — productos para small/mid businesses, self-serve o sales-assisted, pricing $10-500/mo.

### Expected signals
- `customer: B2B` (SMB/startups)
- `format: SaaS`
- `distribution: content-driven, SEO-driven, social-driven (LinkedIn)`
- `stage: pre-launch | MVP | growth`

### Outputs que nuestro módulo produce

**Brand Document sections required**: all sections con register professional-warm

**Prompts Library required**:
- Landing conversion-optimized
- Pricing page (self-serve tiers)
- About page short
- Comparison content vs competitors
- Email sequences (welcome, onboarding, upgrade)
- LinkedIn post templates (5)
- Blog post template
- Pitch one-liner graphic

**Optional recommended**: Case study template, Twitter/X post templates

**Skip**: Pitch deck formal completo, whitepaper, TikTok/Instagram consumer, app icon, community page, podcast cover

### Intensity modifiers defaults
```
verbal_register: "professional-warm"
copy_depth: "medium"
visual_formality: "medium"
logo_primary_form: "wordmark-preferred"
typography_era: "neutral-modern"
social_presence_priority: "professional-multichannel"
app_asset_criticality: "derivative"
```

### Archetype constraints
- **Blocked**: Outlaw, Rebel (sin profile strong)
- **Preferred range**: Sage, Hero, Everyman, Creator, Caregiver
- **Sweet spots**: Sage, Hero, Everyman

### Ejemplos reales
Linear, Superhuman, Notion (pre-enterprise), Vercel.

---

## 3.5 Profile 3 — `b2d-devtool`

### Descripción
Developer tool — productos para developers/engineering teams. Distribution via GitHub, docs, dev Twitter, conferences.

### Expected signals
- `customer: B2D`
- `format: SaaS, API, CLI`
- `distribution: content-driven (docs/blog), community-driven, partnership-driven`
- `stage: pre-launch | MVP | growth`

### Outputs que nuestro módulo produce

**Brand Document sections required**: all, plus dev-specific (code styling preview, CLI aesthetic)

**Prompts Library required**:
- **Docs-style landing prompt** (code snippets en hero, quickstart visible)
- **Code snippet styling prompt** (syntax highlighting aligned con palette)
- **CLI/terminal branding prompt** (prompt style, ASCII art, colors)
- **GitHub README template prompt** (banner, badges, install, usage)
- Dev Twitter post templates (5)
- Blog post template (technical, long-form)
- Documentation homepage prompt

**Optional recommended**: LinkedIn presence light, conference talk abstract template, newsletter template

**Skip**: Consumer social (TikTok, Instagram), app icon mobile, WhatsApp, pitch deck enterprise formal

### Intensity modifiers defaults
```
verbal_register: "casual-friendly" (con precision técnica)
copy_depth: "medium"
visual_formality: "low-medium"
logo_primary_form: "symbolic-first"  (mascots/marks conceptuales funcionan)
typography_era: "neutral-modern" (con preferencia por monospace secondaries)
social_presence_priority: "professional-multichannel" (Twitter/X + GitHub + dev blog)
app_asset_criticality: "derivative"
```

### Archetype constraints
- **Blocked**: Caregiver, Ruler (rígido para dev culture)
- **Preferred range**: Sage, Creator, Explorer, Magician, Jester, Rebel
- **Sweet spots**: Creator, Magician, Explorer

### Ejemplos reales
Stripe, Supabase, Linear, Railway, Vercel, Cursor, Postman.

---

## 3.6 Profile 4 — `b2c-consumer-app`

### Descripción
Consumer mobile app — distribución via app stores, monetization freemium/subscription/IAP.

### Expected signals
- `customer: B2C`
- `format: mobile-app`
- `distribution: app-store, social-driven, community-driven`
- `stage: pre-launch | MVP | growth`

### Outputs que nuestro módulo produce

**Brand Document sections required**: all, plus app-specific (icon showcase, screenshot templates preview)

**Prompts Library required**:
- **App store listing page prompt**
- **App store screenshots templates** (5 screens con overlays + copy)
- **Onboarding screens prompt** (first-run experience flow)
- **Viral share visuals prompt**
- **Instagram post templates** (3 layouts)
- **TikTok cover prompt**
- Launch email prompt
- Push notification templates

**Reference Assets required**: **App icon set completo** (iOS múltiples sizes + Android adaptive icon foreground/background + mask variants)

**Skip**: LinkedIn heavy, pitch deck formal, case study templates B2B, enterprise emails, community page formal

### Intensity modifiers defaults
```
verbal_register: "playful-bold"
copy_depth: "punchy-only"
visual_formality: "low"
logo_primary_form: "icon-first"  (icon = brand core)
typography_era: "expressive-contemporary"
social_presence_priority: "consumer-heavy"
app_asset_criticality: "primary"
sonic_needs: "branded"
motion_needs: "expressive"
```

### Archetype constraints
- **Blocked**: Ruler (muy rígido)
- **Preferred range**: Jester, Creator, Explorer, Innocent, Lover, Magician, Everyman, Hero
- **Sweet spots**: Jester, Creator, Magician

### Ejemplos reales
Duolingo, Calm, Headspace, Tinder, Cash App.

### Notas
- App icon es **el** artefacto más importante del profile
- Icon debe ser legible a 16×16, memorable a 60×60 (Gate 6 enforza legibility)
- Consumer apps toleran personality extreme

---

## 3.7 Profile 5 — `b2c-consumer-web`

### Descripción
Consumer web product — SaaS o content-media consumer-facing, web-based.

### Expected signals
- `customer: B2C`
- `format: SaaS (web), content-media`
- `distribution: SEO-driven, social-driven, content-driven`
- `stage: MVP | growth`

### Outputs que nuestro módulo produce

**Brand Document sections required**: all con register casual-friendly

**Prompts Library required**:
- Landing conversion-optimized consumer (emotional hero)
- Pricing page consumer-friendly (freemium si aplica)
- Email campaigns consumer (welcome, engagement, retention)
- Instagram post templates (5)
- Newsletter template
- Referral visuals

**Optional recommended**: TikTok templates (si target younger), YouTube channel art, Twitter/X

**Skip**: App icon (no mobile), LinkedIn heavy, enterprise materials, pitch deck formal

### Intensity modifiers defaults
```
verbal_register: "casual-friendly"
copy_depth: "medium"
visual_formality: "low-medium"
logo_primary_form: "combination"
typography_era: "expressive-contemporary"
social_presence_priority: "consumer-heavy"
app_asset_criticality: "derivative"
```

### Archetype constraints
- **Blocked**: Ruler, Outlaw (context-dependent)
- **Preferred range**: Creator, Explorer, Innocent, Lover, Everyman, Caregiver, Magician, Jester

### Ejemplos reales
Substack, Medium, Pinterest, Airbnb, Figma.

---

## 3.8 Profile 6 — `b2local-service`

### Descripción
Local service — negocio físico en una ubicación específica (restaurant, clinic, barbershop, gym).

### Expected signals
- `customer: B2C / B2B local`
- `format: service-local`
- `distribution: SEO-driven (local), social-driven (IG local), community-driven`
- `cultural_scope: local`

### Outputs que nuestro módulo produce

**Brand Document sections required**: all, plus local-specific (local application preview)

**Prompts Library required**:
- **Local landing prompt** (con map, hours, address, local phone)
- **Google My Business listing copy**
- **WhatsApp templates** (greeting, FAQ, booking confirmation, reminder) — CRÍTICO en LATAM
- **Printable flyer prompt** (design direction + copy)
- **Phone greeting script**
- **Instagram local post templates** (3)
- **Business card prompt**

**Optional recommended**: Printable menu (si food), signage direction, uniform/merch

**Reference Assets required**: logo full system + favicon (limited — no heavy social)

**Skip**: LinkedIn heavy, pitch deck, TikTok global, case studies B2B, developer assets, enterprise

**Out of scope declared**: Packaging 3D (food services), print CMYK heavy

### Intensity modifiers defaults
```
verbal_register: "professional-warm"  (en idioma local)
copy_depth: "punchy-only"
visual_formality: "medium"
logo_primary_form: "combination"  (símbolo + nombre)
typography_era: "neutral-modern" o "editorial-classic"
social_presence_priority: "local-whatsapp"
app_asset_criticality: "not-needed"
print_needs: "heavy"
```

### Archetype constraints
- **Blocked**: Outlaw, Rebel
- **Preferred range**: Everyman, Caregiver, Innocent, Ruler (premium local), Sage (expertise local)
- **Sweet spots**: Everyman, Caregiver

### Notas específicas
- Idioma CRÍTICO con dialect awareness
- Trust signals matter más que innovation

---

## 3.9 Profile 7 — `content-media`

### Descripción
Content/creator brand — newsletter, podcast, YouTube, blog, social media creator.

### Expected signals
- `customer: B2C` (audience)
- `format: content-media`
- `distribution: SEO-driven, social-driven, content-driven, community-driven`
- `stage: growth | scale`

### Outputs que nuestro módulo produce

**Brand Document sections required**: all, plus creator-specific (podcast cover preview, video thumbnail preview)

**Prompts Library required**:
- **Podcast cover prompt** (si podcast — 3000×3000 specs)
- **Video thumbnails series template prompt** (YouTube 1280×720)
- **Newsletter template prompt**
- **Social post series templates** (Instagram carousel, X thread, LinkedIn post)
- Author bio (short, medium, long)
- **Merch direction prompt** (tees, stickers, mugs)

**Optional recommended**: Course cover templates, sponsorship deck, press kit, email sequences (welcome, upsell)

**Skip**: Pitch deck enterprise formal, case studies B2B, developer-facing, enterprise emails

### Intensity modifiers defaults
```
verbal_register: "expressive-raw"
copy_depth: "medium"
visual_formality: "low"
logo_primary_form: "symbolic-first" o "combination"
typography_era: "expressive-contemporary"
social_presence_priority: "content-creator"
app_asset_criticality: "derivative"
sonic_needs: "branded"
```

### Archetype constraints
- **Highly profile-dependent** — archetype del creator = archetype del brand
- **Preferred range**: all 12 posible
- **Sweet spots**: Sage (educational), Creator (build-with-me), Jester (entertainment), Explorer, Hero

### Ejemplos reales
Morning Brew, Huberman Lab, MrBeast, Every, Stratechery, Tim Ferriss.

---

## 3.10 Profile 8 — `community-movement`

### Descripción
Community/cause/movement — organizaciones/colectivos unidos por causa/identity.

### Expected signals
- `customer: B2C` (members)
- `format: community`
- `distribution: community-driven, social-driven, PR-driven`
- `cultural_scope: niche-community | regional | global`

### Outputs que nuestro módulo produce

**Brand Document sections required**: all, plus manifesto preview

**Prompts Library required**:
- **Manifesto document prompt** (CRÍTICO — structured chapter-based)
- **Symbolic assets prompt** (flag-like emblems)
- **Discord/Slack server branding prompt** (avatar, banner, emoji direction)
- **Member onboarding sequence prompt**
- **Recruiting copy templates**
- **Merch direction prompt** (identity merch)

**Optional recommended**: Newsletter, event assets, governance docs (si DAO)

**Skip**: Pricing page traditional, sales materials B2B, developer tools specific, enterprise

### Intensity modifiers defaults
```
verbal_register: "expressive-raw" o "playful-bold"
copy_depth: "long-form-allowed"  (manifesto)
visual_formality: "low-medium"
logo_primary_form: "symbolic-first"
typography_era: "expressive-contemporary" o "editorial-classic"
social_presence_priority: "community-native"
app_asset_criticality: "not-needed"
```

### Archetype constraints
- **Blocked**: Ruler (contradice spirit comunal)
- **Preferred range**: Rebel, Hero, Explorer, Creator, Magician, Innocent, Caregiver
- **Sweet spots**: Rebel, Hero, Caregiver

### Ejemplos reales
Dribbble, Black Lives Matter, r/wallstreetbets, Greenpeace, Indie Hackers.

---

## 3.11 Cross-profile — output matrix summary

Matriz de outputs por profile. Columns: qué aparece como `required` (✓), `optional_recommended` (○), `skip` (—), `out_of_scope` (✗):

| Output nuestro módulo | ent | smb | dev | c-app | c-web | local | media | comm |
|---|---|---|---|---|---|---|---|---|
| Brand Document PDF | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Prompts: Landing | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Prompts: Pricing | ✓ | ✓ | ○ | ✓ | ✓ | — | ○ | ○ |
| Prompts: Pitch deck full | ✓ | — | — | — | — | — | — | — |
| Prompts: Pitch one-liner graphic | ✓ | ✓ | ✓ | ✓ | ✓ | — | ✓ | ✓ |
| Prompts: Case study | ✓ | ○ | ○ | — | — | — | — | — |
| Prompts: TikTok post | — | — | — | ✓ | ○ | — | ✓ | ○ |
| Prompts: Instagram post | — | ○ | — | ✓ | ✓ | ✓ | ✓ | ○ |
| Prompts: LinkedIn post | ✓ | ✓ | ○ | — | — | — | ○ | ○ |
| WhatsApp templates | — | — | — | — | — | ✓ | — | — |
| Reference: App icon set | — | — | — | ✓ | — | — | — | — |
| Prompts: Code snippet styling | — | — | ✓ | — | — | — | — | — |
| Prompts: GitHub README | — | — | ✓ | — | — | — | — | — |
| Prompts: Podcast cover | — | — | — | — | ○ | — | ✓ | — |
| Prompts: Manifesto | — | — | — | — | — | — | — | ✓ |
| Reference: Symbolic assets | — | — | ○ | — | — | — | — | ✓ |
| Prompts: Merch direction | — | — | — | — | — | ○ | ✓ | ✓ |
| Printable flyers | — | — | — | — | — | ✓ | — | — |
| Email transactional prompt | ✓ | ✓ | ✓ | ✓ | ✓ | — | ○ | ○ |
| Security/compliance page prompt | ✓ | ○ | ✓ | — | — | — | — | — |

## 3.12 Composición de profiles (híbridos)

Una idea puede matchear múltiples profiles con weights. Ejemplo: developer tool con componente community-driven (`b2d-devtool` 0.65 + `community-movement` 0.35).

**Cómo se resuelve el manifest compuesto**:

1. **Outputs required**: union
2. **Outputs optional_recommended**: union
3. **Outputs skip**: intersection (solo si AMBOS lo skipean)
4. **Outputs out_of_scope**: union
5. **Intensity modifiers**: weighted average para escalas continuas, primary gana categóricas si weight > 0.6
6. **Archetype constraints**: union de blocked, intersection de preferred_range

## 3.13 Fallback cuando ninguno matchea

Si `primary_confidence < 0.5`:
- Fallback a `b2b-smb` con flag `"low_confidence_classification: true"`
- Ask user para descripción manual
- Permitir scope custom

## 3.14 Evolución de la taxonomía

Candidatos para agregar post-v1 si patterns emergen:

- `b2g-gov-contractor`
- `marketplace-twosided`
- `edtech-educational`
- `healthcare-regulated`
- `fintech-regulated`
- `nonprofit-cause`

Agregar cuando ≥3 runs no encajen bien.

## 3.15 Reference file a escribir en Sprint 0

`skills/brand/references/brand-profiles.md` con:
- 8 descripciones expandidas con ejemplos reales
- Matriz de outputs completa
- Tablas de intensity modifier defaults
- Archetype constraints explícitas
- Ejemplos trabajados de composition scenarios

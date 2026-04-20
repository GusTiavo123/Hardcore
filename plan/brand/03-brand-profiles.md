# 03 — Catálogo de los 8 Brand Profiles Canónicos

## 3.1 Qué son los brand profiles

Un brand profile es una **configuración canónica** que agrupa las decisiones típicas para un tipo de idea: qué outputs son required, qué skip, qué intensity modifiers usar por default, qué archetypes funcionan vs no funcionan.

Los profiles son **referencias estables**, no clasificaciones rígidas. Una idea real puede matchear multiple profiles (composition) o caer en edge cases. Pero el 80% de las ideas que pasan por Hardcore encajan razonablemente en uno de los 8.

**Live reference**: `skills/brand/references/brand-profiles.md` (a escribir en Sprint 0 — este archivo es el plan que informa ese reference).

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
Enterprise SaaS — productos que se venden a grandes empresas via outbound sales, con deal sizes $50K+ anuales, sales cycles de 6-12 meses.

### Expected signals (para matching)
- `customer: B2B` (large companies en target audience)
- `format: SaaS` (también `API`, `service-global`)
- `distribution: sales-driven`, `partnership-driven`, `content-driven`
- `stage: scale` (también `growth` para empresas startup-grown)

### Outputs `required`
- Landing formal con hero + value props enterprise-focused + proof points (logos clientes, testimonials si existen)
- Pricing page con tiers enterprise visibles ("Contact sales" default)
- Security/compliance page (SOC2, GDPR, etc.)
- About page enterprise-oriented (team + mission + funding si aplica)
- **Pitch deck full** (cover + 10 slide template: problem, solution, market, competition, traction, team, ask)
- **Case study templates** (structured: customer → problem → implementation → results)
- **Whitepaper boilerplate** (para content-driven distribution)
- Email sequences enterprise (outbound cold, nurture, follow-up)
- LinkedIn company bio + founder bio
- LinkedIn sample posts (5, professional register)
- Press release boilerplate
- Logo full system (primary + mono + inverse + icon-only)
- Logo wordmark-preferred (primary form)
- Favicon set
- OG card
- LinkedIn cover banner
- Brand book PDF completo + formal

### Outputs `skip`
- TikTok bio / templates (irrelevante para target)
- Instagram presence casual (LinkedIn domina)
- App icon full set (no mobile app)
- Consumer social posts templates
- Community page
- WhatsApp templates
- Podcast cover (a menos que tengan podcast B2B existente — optional_recommended)

### Outputs `out_of_scope_declared`
- Packaging físico
- Print CMYK heavy
- Motion assets
- Sonic branding

### Intensity modifiers defaults
```
verbal_register: "formal-professional"
copy_depth: "long-form-allowed"
visual_formality: "high"
logo_primary_form: "wordmark-preferred"
typography_era: "neutral-modern" (o "editorial-classic" para industrias tradicionales)
social_presence_priority: "enterprise-linkedin-only"
app_asset_criticality: "not-needed"
print_needs: "minimal"
sonic_needs: "none"
motion_needs: "none"
```

### Archetype — constraints
- **Blocked**: Jester, Outlaw, Rebel (baja credibilidad enterprise)
- **Preferred range**: Sage, Ruler, Hero, Caregiver, Creator
- **Sweet spots**: Sage (expert guide), Ruler (authority), Hero (champion of enterprise pain)

### Voice defaults
Adjectives likely: `preciso, autorizante, medido, credible, confiado`. Avoid: `playful, irónico, casual, emocional`.

### Paleta típica
Tonos conservadores: navy + slate + off-white + un accent (amber, teal, deep red). Saturation reducida. Sin neons.

### Typography típica
Serif editorial para authority (Fraunces, Crimson, Merriweather) o sans neutral moderno para enterprise tech (Inter, IBM Plex, Söhne). Evitar display expresivo.

### Ejemplos reales (para referencia)
Datadog, Snowflake, MongoDB, Stripe (enterprise tier), Notion (enterprise), Airtable (enterprise).

---

## 3.4 Profile 2 — `b2b-smb`

### Descripción
SMB SaaS — productos que se venden a small/mid businesses, self-serve o sales-assisted, pricing $10-500/mo, sales cycle de días a semanas.

### Expected signals
- `customer: B2B` (SMB o startups)
- `format: SaaS`
- `distribution: content-driven, SEO-driven, social-driven (LinkedIn), sales-driven (light)`
- `stage: pre-launch | MVP | growth` (mayoría)

### Outputs `required`
- Landing conversion-optimized (hero clear value prop, features, pricing, CTA aggressive)
- Pricing page (self-serve tiers visibles)
- About page short
- Comparison content template (vs competidores)
- Email sequences (welcome, onboarding, upgrade)
- LinkedIn company bio + founder bio
- LinkedIn sample posts (5, professional-warm register)
- Blog post template
- Pitch one-liner
- Pitch 30s (para investors si aplica)
- Logo full system
- Favicon set
- OG card
- Brand book PDF

### Outputs `optional_recommended`
- Case study template (si tienen o planean tener clientes con permiso)
- Twitter/X presence bio + sample posts
- Email signature template
- Press release boilerplate

### Outputs `skip`
- Pitch deck formal completo (solo cover + one-liner)
- Whitepaper (demasiado enterprise)
- TikTok / Instagram consumer
- App icon
- Community page (a menos que el SaaS tenga componente community explícito)
- Podcast cover

### Intensity modifiers defaults
```
verbal_register: "professional-warm"
copy_depth: "medium"
visual_formality: "medium"
logo_primary_form: "wordmark-preferred" (algunos combinations OK)
typography_era: "neutral-modern"
social_presence_priority: "professional-multichannel" (LinkedIn primary + Twitter/X secondary)
app_asset_criticality: "derivative"
print_needs: "minimal"
sonic_needs: "none"
motion_needs: "subtle"
```

### Archetype — constraints
- **Blocked**: Outlaw, Rebel (sin profile strong que los sostenga)
- **Preferred range**: Sage, Hero, Everyman, Creator, Caregiver
- **Sweet spots**: Sage, Hero, Everyman (relatable/practical)

### Ejemplos reales
Linear (Everyman con edge), Superhuman (Hero), Notion (pre-enterprise era — Creator), Vercel (Sage/Creator).

---

## 3.5 Profile 3 — `b2d-devtool`

### Descripción
Developer tool — productos que se venden a developers/engineering teams. Distribution es a través de GitHub, docs, dev Twitter, conferences. Open source friendly.

### Expected signals
- `customer: B2D` (developers explícitamente en target)
- `format: SaaS, API, CLI`
- `distribution: content-driven (docs/blog), community-driven, partnership-driven (integrations)`
- `stage: pre-launch | MVP | growth`

### Outputs `required`
- **Docs-style landing** (technical, code snippets visible en hero, quickstart en first scroll)
- **Code snippet styling** (specific syntax highlighting theme aligned con brand palette)
- **CLI/terminal branding** (si producto tiene CLI: prompt style, ASCII art optional, color scheme terminal)
- **GitHub README template** (structured: banner, badges, install, usage, docs link, contributing)
- **Dev Twitter presence** (bio + 5 sample posts en voice técnico casual)
- Documentation homepage design direction
- Blog post template (technical, long-form allowed)
- Logo system con variante **monoscope/icon-only** prominente (para favicon, GitHub avatar)
- OG card optimizada para dev Twitter
- Brand book PDF

### Outputs `optional_recommended`
- LinkedIn presence (secondary para dev tools pero valioso para B2B sales)
- Conference talk abstract template
- Newsletter template (si content-driven)
- Email sequences (signup → activation focused)

### Outputs `skip`
- Consumer social (TikTok, Instagram)
- App icon mobile
- Community general (unless Discord/Slack is explicit)
- WhatsApp
- Pitch deck enterprise formal
- Podcast (unless existing)

### Intensity modifiers defaults
```
verbal_register: "casual-friendly" (con precision técnica — devs detectan jargon falso al instante)
copy_depth: "medium" (technical content puede ser long, marketing copy debe ser punchy)
visual_formality: "low-medium"
logo_primary_form: "symbolic-first" (mascotes, marks conceptuales funcionan para dev tools — Docker whale, GitHub octocat)
typography_era: "neutral-modern" (con preferencia por monospace secondaries — JetBrains Mono, IBM Plex Mono)
social_presence_priority: "professional-multichannel" (Twitter/X + GitHub + dev blog)
app_asset_criticality: "derivative"
print_needs: "none"
sonic_needs: "none"
motion_needs: "subtle"
```

### Archetype — constraints
- **Blocked**: Caregiver (muy soft para dev culture), Ruler (muy rígido)
- **Preferred range**: Sage, Creator, Explorer, Magician, Jester (allowed con carefulness), Rebel (permitido con profile support)
- **Sweet spots**: Creator (build with us), Magician (transform your workflow), Explorer (frontier tech)

### Ejemplos reales
Stripe (Sage/Creator), Supabase (Creator/Explorer), Linear (Everyman+Creator), Railway (Creator), Vercel (Magician), Cursor (Magician+Rebel), Postman (Everyman+Creator).

### Notas específicas
- Dev tools toleran humor sofisticado (Stripe jokes, GitHub octocat)
- Anti-jargon corporate es casi obligatorio
- Open source positioning afecta voice (welcoming, community-first)
- Technical accuracy es non-negotiable — errores en code snippets destruyen credibility

---

## 3.6 Profile 4 — `b2c-consumer-app`

### Descripción
Consumer mobile app — productos que se distribuyen via app stores (iOS/Android), monetization via freemium/subscription/in-app purchase, distribution social/viral.

### Expected signals
- `customer: B2C` (mass consumer o niche consumer)
- `format: mobile-app`
- `distribution: app-store, social-driven (TikTok, Instagram), community-driven`
- `stage: pre-launch | MVP | growth`

### Outputs `required`
- **App icon completo** (CRÍTICO — primary asset, no derivativo): set iOS (multiple sizes), set Android (adaptive icon con foreground/background), mask variants
- **App store screenshots** (template structure for 5-6 screens con overlays + copy)
- **App landing page** (store-style: hero con phone mockup, features con screenshots, social proof, CTA download)
- **Onboarding screens design direction** (first-run experience flow)
- **Viral share visuals** (share card templates, referral asset designs)
- **Instagram presence** (bio + 10 sample posts visuales en voice)
- **TikTok presence** (bio + 5 sample post concepts — captions + visual direction, no producción de video)
- Launch email template
- Push notification templates (welcome, engagement, re-engagement)
- Logo con **icon-only form prominente** (icon IS the brand — logo expande el icon)
- Brand book PDF

### Outputs `optional_recommended`
- Twitter/X presence (secondary para consumer, salvo ideas Twitter-native)
- YouTube channel art (si content strategy incluye video)
- Press kit (para PR push en launch)

### Outputs `skip`
- LinkedIn presence heavy (company bio light OK, sample posts skip)
- Pitch deck formal completo (a menos que raising externally — optional_recommended)
- Case study templates (B2B concept)
- Enterprise email sequences
- Community page formal (apps sometimes have community — conditional)

### Intensity modifiers defaults
```
verbal_register: "playful-bold"
copy_depth: "punchy-only" (consumer attention span)
visual_formality: "low"
logo_primary_form: "icon-first" (icon = brand core)
typography_era: "expressive-contemporary" (sans geométrico moderno, display fonts permitidos)
social_presence_priority: "consumer-heavy" (Instagram + TikTok primary)
app_asset_criticality: "primary"
print_needs: "none"
sonic_needs: "branded" (app sound effect, onboarding audio)
motion_needs: "expressive" (app transitions, logo animation, splash screen)
```

### Archetype — constraints
- **Blocked**: Ruler (muy rígido para consumer), Caregiver solo si literalmente es app de cuidado
- **Preferred range**: Jester, Creator, Explorer, Innocent, Lover, Magician, Everyman, Hero
- **Sweet spots**: Jester (fun consumer apps), Creator (creative tools apps), Magician (transformative apps)

### Voice defaults
`amigable, enérgica, directa, un poco irreverente`. Copy optimizado para thumb-scroll attention.

### Paleta típica
Vibrant, high-contrast, memorable. Multi-accent permitido. Saturation alta.

### Typography típica
Sans geométrico moderno (Manrope, Söhne, DM Sans). Display fonts permitidos para branding moments. Weight contrasts extremos.

### Ejemplos reales
Duolingo (Jester), Calm (Innocent+Caregiver), Headspace (Sage+Innocent), Tinder (Lover+Jester), Notion mobile (Creator+Everyman), Cash App (Everyman+Creator).

### Notas
- App icon es **el** artefacto más importante. Puede ser el 80% de la identidad visual percibida.
- Icon debe ser legible a 16×16, memorable a 60×60, aspiracional a 180×180.
- Consumer apps toleran personality extreme más que cualquier otro segmento.

---

## 3.7 Profile 5 — `b2c-consumer-web`

### Descripción
Consumer web product — SaaS o content-media consumer-facing, web-based (no app). Subscription consumer ($5-30/mo), freemium, ad-supported o one-time purchase.

### Expected signals
- `customer: B2C` (mass consumer)
- `format: SaaS (web), content-media`
- `distribution: SEO-driven, social-driven, content-driven`
- `stage: MVP | growth`

### Outputs `required`
- Landing conversion-optimized consumer (hero emotional, features simple, social proof, pricing clear)
- Pricing page consumer-friendly (freemium si aplica, visible)
- Email campaigns consumer (welcome, engagement, retention, winback)
- Instagram presence (bio + 10 sample posts)
- Newsletter branding (si content strategy)
- Referral visuals (share cards, referral email)
- Logo system full
- Favicon + OG card
- Brand book PDF

### Outputs `optional_recommended`
- TikTok presence (si target younger)
- YouTube channel art (si video strategy)
- Podcast cover (si podcast planeado)
- Twitter/X presence

### Outputs `skip`
- App icon (no mobile app unless PWA)
- LinkedIn heavy (light presence OK)
- Enterprise materials
- Pitch deck formal completo

### Intensity modifiers defaults
```
verbal_register: "casual-friendly"
copy_depth: "medium" (emotional content puede ser longer)
visual_formality: "low-medium"
logo_primary_form: "combination" (logo + name both important)
typography_era: "expressive-contemporary"
social_presence_priority: "consumer-heavy"
app_asset_criticality: "derivative" (favicon OK, no app full set)
print_needs: "none"
sonic_needs: "branded" (si video content)
motion_needs: "subtle-to-expressive"
```

### Archetype — constraints
- **Blocked**: Ruler, Outlaw (contexto-dependent)
- **Preferred range**: Creator, Explorer, Innocent, Lover, Everyman, Caregiver, Magician, Jester
- **Sweet spots**: depends heavily on vertical

### Ejemplos reales
Substack (Creator+Sage), Medium (Creator), Pinterest (Creator+Explorer), Airbnb (Explorer+Caregiver), Figma (Creator+Magician).

---

## 3.8 Profile 6 — `b2local-service`

### Descripción
Local service — negocio físico prestando servicios en una ubicación geográfica específica. Restaurant, clinic, barbershop, gym, tutoring center, cleaning service.

### Expected signals
- `customer: B2C` o `B2B` local
- `format: service-local`
- `distribution: SEO-driven (local SEO), social-driven (Instagram local), community-driven (local), PR-driven (local)`
- `cultural_scope: local`

### Outputs `required`
- **Local landing** (con address, hours, map embed, local phone)
- **Google My Business listing copy** (description optimizada, categories, attributes)
- **WhatsApp templates** (greeting, FAQ, booking confirmation, reminder) — CRÍTICO en LATAM
- **Printable flyers/menus** (PDF ready con direction para imprenta local)
- **Phone greeting script** (hola + menu + call-to-action)
- **Instagram presence** (bio local + 10 sample posts localmente relevantes)
- **Business card design direction** (print-ready)
- Logo full system
- Favicon
- Brand book PDF con focus en materiales aplicables a negocio físico

### Outputs `optional_recommended`
- Printable menu template (si food/hospitality)
- Signage direction (exterior, interior)
- Uniform/merch direction (si staff-visible)
- Door/window signage copy

### Outputs `skip`
- LinkedIn presence heavy (profesional dueño OK, company casi no relevante)
- Pitch deck (no necesita raising típicamente)
- TikTok (a menos que video strategy — local services típicamente no dependen)
- Case studies B2B format
- Developer-facing anything
- Enterprise materials
- App icon full set (a menos que tienen mobile booking app)

### Outputs `out_of_scope_declared`
- Packaging 3D (food services necesitan packaging real — v1 no cubre)
- Print CMYK heavy (entregamos RGB con flag)

### Intensity modifiers defaults
```
verbal_register: "professional-warm" (en idioma local, con dialect awareness)
copy_depth: "punchy-only" (local customers no leen long-form)
visual_formality: "medium" (formal enough to inspire confidence, warm enough to feel welcoming)
logo_primary_form: "combination" (símbolo + nombre — name matters for word-of-mouth)
typography_era: "neutral-modern" o "editorial-classic" (depende de vibe — tradicional vs moderno)
social_presence_priority: "local-whatsapp"
app_asset_criticality: "not-needed"
print_needs: "heavy" (flyers, business cards, menus, signage)
sonic_needs: "none" (o "branded" si tienen jingle radio/TV local)
motion_needs: "none"
```

### Archetype — constraints
- **Blocked**: Outlaw, Rebel (desconfianza en contextos locales típicos)
- **Preferred range**: Everyman (relatable local), Caregiver (serve community), Innocent (trustworthy), Ruler (premium local), Sage (expertise local)
- **Sweet spots**: Everyman (warm and local), Caregiver (community-focused)

### Notas específicas
- Idioma CRÍTICO — debe ser en idioma local con dialect awareness (ej: restaurant en Bogotá usa "parcero" en copy informal, restaurant en CDMX usa "güey")
- Trust signals matter más que innovation (horarios precisos, address visible, phone real)
- WhatsApp Business API integrations podrían ser extend target en v2

---

## 3.9 Profile 7 — `content-media`

### Descripción
Content/creator brand — newsletter, podcast, YouTube channel, blog, social media creator, educational content. Monetization via ads, subscriptions, sponsorships, courses, merch.

### Expected signals
- `customer: B2C` (audience/readers/listeners)
- `format: content-media`
- `distribution: SEO-driven, social-driven, content-driven, community-driven`
- `stage: growth | scale` (content brands usually post-MVP)

### Outputs `required`
- **Podcast cover** (si podcast — 3000×3000 square format specs)
- **Video thumbnails series** (templates YouTube 1280×720 with consistent branding)
- **Newsletter template** (header, content blocks, footer con author branding)
- **Social post series templates** (Instagram carousel, X thread, LinkedIn post)
- **Author bio** (short, medium, long versions — para guest appearances)
- **Merch direction** (tees, stickers, mugs — templates + design direction, not production)
- Logo con variante **memorable/iconic** (creators viven de recognition — logo debe ser icónico)
- Favicon
- OG card optimizada para social sharing de content
- Brand book PDF

### Outputs `optional_recommended`
- Course cover templates (si sell courses)
- Sponsorship deck template (para pitch a brands)
- Press kit (para interviews, features)
- Email sequences (welcome to newsletter, upsell to paid, engagement)
- Speaking topics page (si speaker active)

### Outputs `skip`
- Pitch deck enterprise formal
- Case studies B2B
- Developer-facing
- Enterprise emails
- Pricing page enterprise (si tienen paid content, consumer-style pricing)
- LinkedIn heavy (ciertos creators LinkedIn-primary — conditional)

### Intensity modifiers defaults
```
verbal_register: "expressive-raw" (creator voice = their voice, authentic)
copy_depth: "medium" (content creators pueden long-form)
visual_formality: "low"
logo_primary_form: "symbolic-first" o "combination" (iconicity matters)
typography_era: "expressive-contemporary" (personality-forward)
social_presence_priority: "content-creator" (platform depends on creator — YouTube+IG, o Newsletter+X, o Podcast+IG)
app_asset_criticality: "derivative"
print_needs: "minimal" (merch — direction only)
sonic_needs: "branded" (CRÍTICO si podcast/video — intro music, audio logo)
motion_needs: "subtle" (lower thirds, transitions — direction only)
```

### Archetype — constraints
- **Highly profile-dependent**: el archetype del creator = archetype del brand
- **Preferred range**: all 12 possible — depends on creator
- **Sweet spots**: Sage (educational), Creator (build-with-me), Jester (entertainment), Explorer (adventure content), Hero (transformation content)

### Ejemplos reales
Morning Brew (Jester+Sage), Huberman Lab (Sage), MrBeast (Hero+Jester), Every (Sage), Stratechery (Sage), Tim Ferriss (Explorer+Sage).

---

## 3.10 Profile 8 — `community-movement`

### Descripción
Community/cause/movement — organizaciones o colectivos unidos por una causa, identity, o interés. Puede ser structurado (nonprofit, DAO) o informal (online community).

### Expected signals
- `customer: B2C` (members/participants)
- `format: community`
- `distribution: community-driven, social-driven, PR-driven`
- `cultural_scope: niche-community | regional | global`

### Outputs `required`
- **Manifesto document** (CRÍTICO — core artifact, structured chapter-based)
- **Symbolic assets** (flag-like, emblem-style — symbols unite communities)
- **Discord/Slack server branding** (avatar, banner, roles naming, emojis)
- **Member onboarding materials** (welcome sequence, code of conduct, contribution guide)
- **Recruiting copy** (why join, what you'll get, what we stand for)
- **Merch direction** (identity merch — tees, pins, stickers; merch es señal de pertenencia)
- Logo system con **symbolic-first** strong
- Favicon
- Brand book PDF + manifesto-oriented
- Sample social posts (rallying, unifying voice)

### Outputs `optional_recommended`
- Newsletter template (community digest)
- Event/gathering assets (if IRL events)
- Governance documentation template (si DAO/formal structure)
- Donation/membership page (si monetized)

### Outputs `skip`
- Pricing page traditional (a menos que paid membership — optional)
- Sales materials B2B
- Developer tools specific
- Enterprise emails
- Case studies (puede ser "stories" en su lugar)

### Intensity modifiers defaults
```
verbal_register: "expressive-raw" o "playful-bold" (depends on cause tone)
copy_depth: "long-form-allowed" (manifesto es long-form)
visual_formality: "low-medium" (formality baja pero NOT casual if cause is serious)
logo_primary_form: "symbolic-first"
typography_era: "expressive-contemporary" o "editorial-classic" (gravitas)
social_presence_priority: "community-native"
app_asset_criticality: "not-needed"
print_needs: "minimal" (merch direction + flyers posibles)
sonic_needs: "none" (rarely branded audio)
motion_needs: "subtle"
```

### Archetype — constraints
- **Blocked**: Ruler (contradice spirit comunal en most cases)
- **Preferred range**: Rebel, Hero, Explorer, Creator, Magician, Innocent, Caregiver
- **Sweet spots**: Rebel (counter-cultural movements), Hero (cause-driven), Caregiver (support communities)

### Ejemplos reales
Dribbble (Creator community), Black Lives Matter (Hero+Rebel), r/wallstreetbets (Rebel+Jester), Greenpeace (Hero+Caregiver), Indie Hackers (Everyman+Creator).

---

## 3.11 Cross-profile — output matrix summary

Matriz visual de qué output aparece en qué profile como `required` (✓), `optional_recommended` (○), `skip` (—), `out_of_scope` (✗):

| Output | ent | smb | dev | c-app | c-web | local | media | comm |
|---|---|---|---|---|---|---|---|---|
| Landing | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Pricing page | ✓ | ✓ | ○ | ✓ | ✓ | — | ○ | ○ |
| Pitch deck full | ✓ | — | — | — | — | — | — | — |
| Pitch one-liner | ✓ | ✓ | ✓ | ✓ | ✓ | — | ✓ | ✓ |
| Case study template | ✓ | ○ | ○ | — | — | — | — | — |
| TikTok bio | — | — | — | ✓ | ○ | — | ✓ | ○ |
| Instagram bio | — | ○ | — | ✓ | ✓ | ✓ | ✓ | ○ |
| LinkedIn bio | ✓ | ✓ | ○ | — | — | — | ○ | ○ |
| WhatsApp templates | — | — | — | — | — | ✓ | — | — |
| App icon full set | — | — | — | ✓ | — | — | — | — |
| Code snippet styling | — | — | ✓ | — | — | — | — | — |
| GitHub README | — | — | ✓ | — | — | — | — | — |
| Podcast cover | — | — | — | — | ○ | — | ✓ | — |
| Manifesto document | — | — | — | — | — | — | — | ✓ |
| Symbolic assets | — | — | ○ | — | — | — | — | ✓ |
| Merch direction | — | — | — | — | — | ○ | ✓ | ✓ |
| Printable flyers | — | — | — | — | — | ✓ | — | — |
| Email transactional | ✓ | ✓ | ✓ | ✓ | ✓ | — | ○ | ○ |
| Security/compliance page | ✓ | ○ | ✓ | — | — | — | — | — |
| Brand book PDF | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

## 3.12 Composición de profiles (híbridos)

Una idea puede matchear múltiples profiles con weights. Ejemplo: developer tool con fuerte componente community-driven (`b2d-devtool` 0.65 + `community-movement` 0.35).

**Cómo se resuelve el manifest compuesto**:

1. **Outputs `required`**: union de required de ambos (ambos se generan)
2. **Outputs `optional_recommended`**: union de optional recommended
3. **Outputs `skip`**: intersection (solo si AMBOS lo skipean)
4. **Outputs `out_of_scope`**: union
5. **Intensity modifiers**: weighted average para escalas continuas (ej: `visual_formality` numeric), rules específicas para categóricos (primary profile gana si weight > 0.6; si not, user confirms)
6. **Archetype constraints**: union de blocked, intersection de preferred_range

## 3.13 Fallback cuando ninguno matchea

Si confidence del primary match < 0.5 (muy ambiguo):
- Fallback a `b2b-smb` (el más genérico) con flag `"low_confidence_classification: true"`
- Ask user para descripción manual
- Permitir user custom manifest override
- **Registrar el caso para análisis futuro** — puede indicar need de nuevo profile

## 3.14 Evolución de la taxonomía

Los 8 profiles son un punto de partida. Candidatos para agregar post-v1 basado en patterns observados:

- `b2g-gov-contractor` (separate de enterprise — dinámica distinta)
- `marketplace-twosided` (tiene needs específicos dual-audience)
- `edtech-educational` (mezcla content-media + b2b-smb)
- `healthcare-regulated` (compliance-heavy, trust-critical)
- `fintech-regulated` (similar pero con nuances propios)
- `nonprofit-cause` (separate de community-movement)

Agregar cuando haya ≥3 runs que no encajan bien en los existentes.

## 3.15 Reference file a escribir en Sprint 0

`skills/brand/references/brand-profiles.md` contendrá:
- Las 8 descripciones expandidas con más ejemplos reales
- Matriz de outputs completa
- Tablas de intensity modifier defaults
- Archetype constraints explícitas
- Ejemplos trabajados de composition scenarios (5-10 casos)
- Decision tree para fallbacks

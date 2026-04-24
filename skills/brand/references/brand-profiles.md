# Brand Profiles — 8 Canonical Configurations

Reference file consumed by Scope Analysis, Strategy, Verbal, Visual, Logo and Handoff Compiler. Defines the canonical decisions per brand type: expected signals, output manifest, intensity modifier defaults, archetype constraints.

See `skills/_shared/glossary.md` for the term definition. See `skills/brand/scope-analysis/SKILL.md` for the matching algorithm.

---

## Profile Overview

| ID | Name | Customer | Format | Typical stage |
|---|---|---|---|---|
| `b2b-enterprise` | Enterprise SaaS | Large companies | SaaS | scale |
| `b2b-smb` | SMB SaaS | SMBs / startups | SaaS | pre-launch / MVP / growth |
| `b2d-devtool` | Developer Tool | Developers / eng teams | SaaS, API, CLI | pre-launch / MVP |
| `b2c-consumer-app` | Consumer Mobile App | Mass consumer | mobile-app | pre-launch / MVP / growth |
| `b2c-consumer-web` | Consumer Web Product | Mass consumer | SaaS web / content-media | MVP / growth |
| `b2local-service` | Local Service | Local customers | service-local | any |
| `content-media` | Content / Creator Brand | Audience | content-media | growth / scale |
| `community-movement` | Community / Cause / Movement | Members | community | pre-launch / growth |

---

## 1 — `b2b-enterprise`

Enterprise SaaS — sold to large companies via outbound, deal sizes $50K+, 6-12 month cycles.

**Expected signals**
- `customer: B2B` (large)
- `format: SaaS | API | service-global`
- `distribution: sales-driven | partnership-driven | content-driven`
- `stage: scale | growth`

**Brand Document sections required**: cover, brand_essence, voice_tone, palette, typography, logo, visual_principles, copy_samples.

**Prompts Library required**:
- Landing (formal, security badges, client-logo placeholders)
- Pricing (enterprise, "Contact sales")
- Security/compliance page
- About (enterprise-oriented)
- Pitch deck (10-slide structure)
- Case study template
- Whitepaper
- Email sequences (outbound cold, nurture)
- LinkedIn post templates (5, professional)
- Press release

**Reference Assets required**: logo full system + favicon + OG card + LinkedIn cover banner.

**Skip**: TikTok/Instagram consumer, app icon, podcast cover, WhatsApp templates.

**Intensity modifiers (defaults)**
```
verbal_register: formal-professional
copy_depth: long-form-allowed
visual_formality: high
logo_primary_form: wordmark-preferred
typography_era: neutral-modern | editorial-classic
social_presence_priority: enterprise-linkedin-only
app_asset_criticality: not-needed
print_needs: minimal
sonic_needs: none
motion_needs: none
```

**Archetype constraints**
- Blocked: Jester, Outlaw, Rebel
- Preferred range: Sage, Ruler, Hero, Caregiver, Creator
- Sweet spots: Sage, Ruler, Hero

**Examples**: Datadog, Snowflake, MongoDB, Stripe (enterprise).

---

## 2 — `b2b-smb`

SMB SaaS — for small/mid businesses, self-serve or sales-assisted, $10-500/mo.

**Expected signals**
- `customer: B2B` (SMB/startups)
- `format: SaaS`
- `distribution: content-driven | SEO-driven | social-driven (LinkedIn)`
- `stage: pre-launch | MVP | growth`

**Brand Document sections required**: all (register `professional-warm`).

**Prompts Library required**:
- Landing (conversion-optimized)
- Pricing (self-serve tiers)
- About (short)
- Comparison content vs. competitors
- Email sequences (welcome, onboarding, upgrade)
- LinkedIn post templates (5)
- Blog post template
- Pitch one-liner graphic

**Optional**: Case study, Twitter/X post templates.

**Skip**: Pitch deck formal, whitepaper, TikTok/Instagram consumer, app icon, community page, podcast cover.

**Intensity modifiers (defaults)**
```
verbal_register: professional-warm
copy_depth: medium
visual_formality: medium
logo_primary_form: wordmark-preferred
typography_era: neutral-modern
social_presence_priority: professional-multichannel
app_asset_criticality: derivative
print_needs: minimal
sonic_needs: none
motion_needs: none
```

**Archetype constraints**
- Blocked: Outlaw, Rebel (without strong profile justification)
- Preferred range: Sage, Hero, Everyman, Creator, Caregiver
- Sweet spots: Sage, Hero, Everyman

**Examples**: Linear, Superhuman, Notion (pre-enterprise), Vercel.

---

## 3 — `b2d-devtool`

Developer tool — for devs/eng teams. Distribution via GitHub, docs, dev Twitter, conferences.

**Expected signals**
- `customer: B2D`
- `format: SaaS | API | CLI`
- `distribution: content-driven (docs/blog) | community-driven | partnership-driven`
- `stage: pre-launch | MVP | growth`

**Brand Document sections required**: all + dev-specific (code styling preview, CLI aesthetic).

**Prompts Library required**:
- Docs-style landing (code in hero, quickstart visible)
- Code snippet styling (syntax highlighting aligned with palette)
- CLI/terminal branding (prompt style, ASCII art, colors)
- GitHub README template (banner, badges, install, usage)
- Dev Twitter post templates (5)
- Blog post template (technical, long-form)
- Documentation homepage

**Optional**: LinkedIn light, conference talk abstract, newsletter.

**Skip**: Consumer social, app icon mobile, WhatsApp, pitch deck formal.

**Intensity modifiers (defaults)**
```
verbal_register: casual-friendly (with technical precision)
copy_depth: medium
visual_formality: low-medium
logo_primary_form: symbolic-first
typography_era: neutral-modern (monospace secondary preferred)
social_presence_priority: professional-multichannel (Twitter/X + GitHub + dev blog)
app_asset_criticality: derivative
print_needs: none
sonic_needs: none
motion_needs: none
```

**Archetype constraints**
- Blocked: Caregiver, Ruler (too rigid for dev culture)
- Preferred range: Sage, Creator, Explorer, Magician, Jester, Rebel
- Sweet spots: Creator, Magician, Explorer

**Examples**: Stripe, Supabase, Linear, Railway, Vercel, Cursor, Postman.

---

## 4 — `b2c-consumer-app`

Consumer mobile app — distribution via app stores, monetization freemium/subscription/IAP.

**Expected signals**
- `customer: B2C`
- `format: mobile-app`
- `distribution: app-store | social-driven | community-driven`
- `stage: pre-launch | MVP | growth`

**Brand Document sections required**: all + app-specific (icon showcase, screenshot templates preview).

**Prompts Library required**:
- App store listing page
- App store screenshots templates (5 screens with overlays + copy)
- Onboarding screens (first-run experience)
- Viral share visuals
- Instagram post templates (3 layouts)
- TikTok cover
- Launch email
- Push notification templates

**Reference Assets required**: logo full system + **full app icon set** (iOS multiple sizes + Android adaptive icon foreground/background + mask variants).

**Skip**: LinkedIn heavy, pitch deck formal, case study B2B, enterprise emails, formal community page.

**Intensity modifiers (defaults)**
```
verbal_register: playful-bold
copy_depth: punchy-only
visual_formality: low
logo_primary_form: icon-first
typography_era: expressive-contemporary
social_presence_priority: consumer-heavy
app_asset_criticality: primary
print_needs: none
sonic_needs: branded
motion_needs: expressive
```

**Archetype constraints**
- Blocked: Ruler (too rigid)
- Preferred range: Jester, Creator, Explorer, Innocent, Lover, Magician, Everyman, Hero
- Sweet spots: Jester, Creator, Magician

**Examples**: Duolingo, Calm, Headspace, Tinder, Cash App.

**Notes**
- App icon is THE most important artifact for this profile.
- Icon must be legible at 16×16, memorable at 60×60 (Gate 6 enforces).
- Consumer apps tolerate extreme personality.

---

## 5 — `b2c-consumer-web`

Consumer web product — SaaS or content-media consumer-facing, web-based.

**Expected signals**
- `customer: B2C`
- `format: SaaS (web) | content-media`
- `distribution: SEO-driven | social-driven | content-driven`
- `stage: MVP | growth`

**Brand Document sections required**: all (register `casual-friendly`).

**Prompts Library required**:
- Landing (consumer conversion-optimized, emotional hero)
- Pricing (consumer-friendly, freemium if applicable)
- Email campaigns (welcome, engagement, retention)
- Instagram post templates (5)
- Newsletter template
- Referral visuals

**Optional**: TikTok (if younger target), YouTube channel art, Twitter/X.

**Skip**: App icon, LinkedIn heavy, enterprise materials, pitch deck formal.

**Intensity modifiers (defaults)**
```
verbal_register: casual-friendly
copy_depth: medium
visual_formality: low-medium
logo_primary_form: combination
typography_era: expressive-contemporary
social_presence_priority: consumer-heavy
app_asset_criticality: derivative
print_needs: none
sonic_needs: subtle
motion_needs: subtle
```

**Archetype constraints**
- Blocked: Ruler, Outlaw (context-dependent)
- Preferred range: Creator, Explorer, Innocent, Lover, Everyman, Caregiver, Magician, Jester

**Examples**: Substack, Medium, Pinterest, Airbnb, Figma.

---

## 6 — `b2local-service`

Local service — physical business in a specific location (restaurant, clinic, barbershop, gym).

**Expected signals**
- `customer: B2C | B2B local`
- `format: service-local`
- `distribution: SEO-driven (local) | social-driven (IG local) | community-driven`
- `cultural_scope: local`

**Brand Document sections required**: all + local-specific (local application preview).

**Prompts Library required**:
- Local landing (map, hours, address, local phone)
- Google My Business listing copy
- WhatsApp templates (greeting, FAQ, booking confirmation, reminder) — CRITICAL in LATAM
- Printable flyer (design direction + copy)
- Phone greeting script
- Instagram local post templates (3)
- Business card

**Optional**: Printable menu (food), signage direction, uniform/merch.

**Reference Assets required**: logo full system + favicon (limited — no heavy social).

**Skip**: LinkedIn heavy, pitch deck, TikTok global, case studies B2B, developer assets, enterprise.

**Out of scope declared**: Packaging 3D (food), print CMYK heavy.

**Intensity modifiers (defaults)**
```
verbal_register: professional-warm (in local language)
copy_depth: punchy-only
visual_formality: medium
logo_primary_form: combination
typography_era: neutral-modern | editorial-classic
social_presence_priority: local-whatsapp
app_asset_criticality: not-needed
print_needs: heavy
sonic_needs: none
motion_needs: none
```

**Archetype constraints**
- Blocked: Outlaw, Rebel
- Preferred range: Everyman, Caregiver, Innocent, Ruler (premium local), Sage (expertise local)
- Sweet spots: Everyman, Caregiver

**Notes**
- Language is CRITICAL with dialect awareness.
- Trust signals matter more than innovation.

---

## 7 — `content-media`

Content / creator brand — newsletter, podcast, YouTube, blog, social creator.

**Expected signals**
- `customer: B2C` (audience)
- `format: content-media`
- `distribution: SEO-driven | social-driven | content-driven | community-driven`
- `stage: growth | scale`

**Brand Document sections required**: all + creator-specific (podcast cover preview, video thumbnail preview).

**Prompts Library required**:
- Podcast cover (if podcast — 3000×3000 specs)
- Video thumbnails series template (YouTube 1280×720)
- Newsletter template
- Social post series templates (Instagram carousel, X thread, LinkedIn post)
- Author bio (short, medium, long)
- Merch direction (tees, stickers, mugs)

**Optional**: Course cover templates, sponsorship deck, press kit, email sequences.

**Skip**: Pitch deck enterprise, case studies B2B, developer-facing, enterprise emails.

**Intensity modifiers (defaults)**
```
verbal_register: expressive-raw
copy_depth: medium
visual_formality: low
logo_primary_form: symbolic-first | combination
typography_era: expressive-contemporary
social_presence_priority: content-creator
app_asset_criticality: derivative
print_needs: minimal
sonic_needs: branded
motion_needs: subtle
```

**Archetype constraints**
- **Highly profile-dependent** — archetype of the creator = archetype of the brand.
- Preferred range: all 12 possible.
- Sweet spots: Sage (educational), Creator (build-with-me), Jester (entertainment), Explorer, Hero.

**Examples**: Morning Brew, Huberman Lab, MrBeast, Every, Stratechery, Tim Ferriss.

---

## 8 — `community-movement`

Community / cause / movement — organizations or collectives united by cause/identity.

**Expected signals**
- `customer: B2C` (members)
- `format: community`
- `distribution: community-driven | social-driven | PR-driven`
- `cultural_scope: niche-community | regional | global`

**Brand Document sections required**: all + manifesto preview.

**Prompts Library required**:
- Manifesto document (CRITICAL — structured chapter-based)
- Symbolic assets (flag-like emblems)
- Discord/Slack server branding (avatar, banner, emoji direction)
- Member onboarding sequence
- Recruiting copy templates
- Merch direction (identity merch)

**Optional**: Newsletter, event assets, governance docs (if DAO).

**Skip**: Pricing page traditional, sales materials B2B, developer tools specific, enterprise.

**Intensity modifiers (defaults)**
```
verbal_register: expressive-raw | playful-bold
copy_depth: long-form-allowed (manifesto)
visual_formality: low-medium
logo_primary_form: symbolic-first
typography_era: expressive-contemporary | editorial-classic
social_presence_priority: community-native
app_asset_criticality: not-needed
print_needs: minimal
sonic_needs: none
motion_needs: subtle
```

**Archetype constraints**
- Blocked: Ruler (contradicts communal spirit)
- Preferred range: Rebel, Hero, Explorer, Creator, Magician, Innocent, Caregiver
- Sweet spots: Rebel, Hero, Caregiver

**Examples**: Dribbble, Black Lives Matter, r/wallstreetbets, Greenpeace, Indie Hackers.

---

## Cross-Profile Output Matrix

Columns: `required` (✓), `optional_recommended` (○), `skip` (—), `out_of_scope` (✗).

| Output | ent | smb | dev | c-app | c-web | local | media | comm |
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

---

## Hybrid Profiles (Composition)

An idea may match multiple profiles with weights. Example: developer tool with community component → `b2d-devtool` 0.65 + `community-movement` 0.35.

**Resolution rules**:

| Axis | Rule |
|---|---|
| Outputs `required` | Union |
| Outputs `optional_recommended` | Union |
| Outputs `skip` | Intersection (only if BOTH skip) |
| Outputs `out_of_scope` | Union |
| Intensity modifiers (continuous scales) | Weighted average |
| Intensity modifiers (categorical) | Primary wins if weight > 0.6, else escalate to user |
| Archetype constraints — blocked | Union |
| Archetype constraints — preferred_range | Intersection |

**Example — `b2d-devtool` (0.65) + `community-movement` (0.35)**:
- Required prompts: union → includes GitHub README, code snippet styling, Discord branding, recruiting copy, merch direction
- Typography era: primary-weighted → `neutral-modern` (b2d dominant)
- Archetype preferred: intersection → Creator, Explorer, Magician, Rebel
- Voice register: `casual-friendly` (both compatible)

**Example — `b2c-consumer-app` (0.55) + `content-media` (0.45)**:
- App icon still required (consumer-app has it)
- Podcast cover added (from content-media if creator has podcast)
- Register: escalate (`playful-bold` vs `expressive-raw` — user confirms)

---

## Fallback

When no profile matches well (`primary_confidence < 0.5`):
- Fallback to `b2b-smb` with `low_confidence_classification: true`
- Trigger user confirmation with options
- Allow custom scope if user describes manually

---

## Post-v1 Evolution Candidates

Add when ≥3 runs don't fit well:

- `b2g-gov-contractor`
- `marketplace-twosided`
- `edtech-educational`
- `healthcare-regulated`
- `fintech-regulated`
- `nonprofit-cause`

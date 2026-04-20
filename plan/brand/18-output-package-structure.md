# 18 — Estructura del Output Package

## 18.1 Propósito

Definir la estructura del **paquete entregable** — el directorio que el user recibe como output final del módulo. Dinámico según scope, pero con invariantes claros.

El paquete es el **artefacto primario** del módulo. Debe ser autoexplicativo, completo, usable sin instrucciones externas.

## 18.2 Ubicación

```
{repo-root}/output/{idea-slug}/brand/
```

Dentro del repo existente (consistente con `testing/runs/` pattern para Validation).

## 18.3 Invariantes (siempre presentes)

Independiente de scope, estos archivos SIEMPRE existen:

```
output/{idea-slug}/brand/
├── README.md              ← Auto-generated, explica qué contiene y cómo usar
├── brand-book.pdf         ← Manual completo de marca
├── DESIGN.md              ← Source of truth machine-readable (Stitch-compatible)
├── AUDIT.md               ← Evidence trace, tool versions, decisions, costs
├── logo/                  ← Al menos variants básicas + rationale
├── copy-library.md        ← Todo el copy organizado
└── communications/        ← Al menos pitch one-liner + bios
```

## 18.4 Estructura dinámica por scope

### Full estructura possible

```
output/{idea-slug}/brand/
│
├── README.md                           ← ALWAYS — auto-generated
├── brand-book.pdf                      ← ALWAYS
├── DESIGN.md                           ← ALWAYS — machine-readable
├── AUDIT.md                            ← ALWAYS — versioning + evidence
├── copy-library.md                     ← ALWAYS — todo el copy organizado
│
├── microsite/                          ← IF landing in required (todos los profiles)
│   ├── index.html
│   ├── pricing.html                    ← IF pricing in required
│   ├── about.html                      ← IF about in required
│   ├── docs.html                       ← IF b2d-devtool
│   ├── case-studies.html               ← IF b2b-enterprise
│   ├── app-landing.html                ← IF b2c-consumer-app
│   ├── community.html                  ← IF community-movement
│   ├── contact.html                    ← ALWAYS
│   ├── privacy.html                    ← ALWAYS (skeleton legal — needs review)
│   ├── terms.html                      ← ALWAYS (skeleton)
│   ├── security.html                   ← IF b2b-enterprise or fintech
│   ├── assets/
│   │   ├── logo.svg
│   │   ├── favicon.ico
│   │   ├── og-card.png
│   │   └── mood/ (subset de mood imagery)
│   ├── styles.css                      ← Tailwind build OR inline
│   ├── netlify.toml                    ← IF decided in 22-open-decisions
│   ├── vercel.json                     ← IF decided
│   └── stitch-source/
│       ├── figma-export.fig
│       └── react/ (if applicable)
│
├── pitch-deck/                         ← IF b2b-enterprise
│   ├── cover-slide.html
│   └── template-slides/
│       ├── problem.html
│       ├── solution.html
│       ├── market.html
│       ├── competition.html
│       ├── traction.html
│       ├── team.html
│       └── ask.html
│
├── app-assets/                         ← IF b2c-consumer-app
│   ├── app-icons/
│   │   ├── ios/
│   │   │   ├── icon-20.png
│   │   │   ├── icon-29.png
│   │   │   ├── icon-40.png
│   │   │   ├── icon-60.png
│   │   │   ├── icon-87.png
│   │   │   ├── icon-120.png
│   │   │   ├── icon-180.png
│   │   │   └── icon-1024.png
│   │   └── android/
│   │       ├── foreground.svg
│   │       ├── background.svg
│   │       ├── adaptive-icon.png
│   │       ├── ic_launcher_round.png
│   │       └── ic_launcher.png
│   ├── screenshots-templates/
│   │   ├── screen-1-hero.html
│   │   ├── screen-2-feature.html
│   │   ├── screen-3-social-proof.html
│   │   ├── screen-4-cta.html
│   │   └── screen-5-closing.html
│   ├── onboarding-templates/
│   │   ├── onboarding-1-welcome.html
│   │   ├── onboarding-2-permissions.html
│   │   └── onboarding-3-ready.html
│   └── share-visuals/
│       ├── referral-card.png
│       └── achievement-share.png
│
├── local/                              ← IF b2local-service
│   ├── maps-listing-copy.md
│   ├── whatsapp-templates/
│   │   ├── greeting.md
│   │   ├── faq.md
│   │   ├── booking-confirmation.md
│   │   └── reminder.md
│   ├── phone-scripts.md
│   ├── printable/
│   │   ├── flyer-template.pdf
│   │   ├── business-card.pdf
│   │   ├── menu-template.pdf            ← If food
│   │   └── signage-direction.md
│   └── google-my-business.md
│
├── logo/                               ← ALWAYS (some subset)
│   ├── source/
│   │   ├── primary.svg
│   │   ├── primary-mono.svg
│   │   ├── primary-inverse.svg
│   │   └── icon-only.svg               ← IF symbolic or combination form
│   ├── derivations/
│   │   ├── favicon-16.png
│   │   ├── favicon-32.png
│   │   ├── favicon-48.png
│   │   ├── favicon.ico                 ← Multi-size combined
│   │   ├── apple-touch-180.png
│   │   ├── og-card-1200x630.png
│   │   ├── profile-pic-400.png
│   │   ├── profile-pic-400-bg.png
│   │   ├── cover-x-1500x500.png        ← IF social X in scope
│   │   └── cover-linkedin-1584x396.png ← IF social LinkedIn in scope
│   ├── app-icons/                      ← IF b2c-consumer-app (redundant with app-assets, cross-ref)
│   ├── merch/                          ← IF community-movement or content-media
│   │   ├── tshirt-layout.pdf
│   │   ├── sticker-designs.svg
│   │   ├── mug-layout.pdf
│   │   └── README.md
│   ├── rationale.md                    ← ALWAYS — por qué el logo se ve así
│   └── usage-guidelines.md             ← ALWAYS — do/don'ts, clearspace, min size
│
├── social/                             ← IF social_presence_priority is not "enterprise-linkedin-only"
│   ├── avatars/
│   │   ├── avatar-x.png
│   │   ├── avatar-linkedin.png
│   │   ├── avatar-instagram.png
│   │   └── avatar-tiktok.png           ← IF TikTok in scope
│   ├── banners/
│   │   ├── banner-x.png
│   │   ├── banner-linkedin.png
│   │   ├── banner-facebook.png         ← IF Facebook in scope
│   │   └── banner-youtube.png          ← IF YouTube in scope
│   ├── post-templates-instagram/       ← IF Instagram in scope
│   │   ├── template-square.html
│   │   ├── template-carousel-1.html
│   │   ├── template-carousel-2.html
│   │   └── template-story.html
│   ├── post-templates-x/               ← IF X/Twitter in scope
│   │   ├── template-post.html
│   │   └── template-thread-card.html
│   ├── post-templates-linkedin/        ← IF LinkedIn in scope
│   │   └── template-post.html
│   ├── post-templates-tiktok/          ← IF TikTok in scope
│   │   └── template-cover.html
│   └── sample-posts.md                 ← ALWAYS (if social_presence)
│
├── communications/                     ← ALWAYS (subset)
│   ├── email-signature.html            ← ALWAYS
│   ├── pitch-one-liner.txt             ← ALWAYS
│   ├── elevator-30s.txt                ← IF pitch_30s in scope
│   ├── press-release-boilerplate.md    ← IF b2b-enterprise or scope includes
│   ├── email-templates/
│   │   ├── welcome.html                ← IF SaaS scopes
│   │   ├── transactional.html          ← IF SaaS scopes
│   │   ├── newsletter.html             ← IF content-media or marketing scope
│   │   └── onboarding-sequence/        ← IF b2b-smb or b2c-consumer-web
│   │       ├── email-1-welcome.html
│   │       ├── email-2-onboarding.html
│   │       ├── email-3-value.html
│   │       ├── email-4-upgrade.html
│   │       └── email-5-retention.html
│   ├── whatsapp-templates/             ← IF b2local-service (redundant with local/)
│   ├── bios/                           ← ALWAYS (for scopes with social)
│   │   ├── linkedin-company.md
│   │   ├── linkedin-personal.md
│   │   ├── twitter.md
│   │   ├── instagram.md
│   │   ├── tiktok.md                   ← IF TikTok in scope
│   │   └── personal-brand.md
│   ├── manifesto.md                    ← IF community-movement
│   └── recruiting-copy.md              ← IF community-movement
│
├── mood-references/                    ← IF mood_imagery in scope required
│   ├── mood-01-energy.png
│   ├── mood-02-texture.png
│   ├── mood-03-composition.png
│   ├── mood-04-light.png
│   ├── mood-05-motion.png
│   ├── mood-06-focus.png
│   └── README.md (description per image)
│
└── developer/                          ← IF b2d-devtool
    ├── github-readme-template.md
    ├── docs-homepage-copy.md
    ├── cli-help-text-style.md
    └── code-snippet-theme.json         ← Syntax highlighting theme aligned with palette
```

## 18.5 README.md del package — estructura

Ya cubierto en [08-dept-activation.md#63-paso-6](./08-dept-activation.md#63-paso-6). Resumen:

- Identity summary (name, archetype, profile)
- Scope identified + confidence
- Lo que SÍ incluye (por category)
- Lo que NO incluye (skipped + out-of-scope con reasons)
- How to use (deployment instructions, editing guides)
- Disclaimers
- Versioning info

## 18.6 AUDIT.md — estructura

Graba trazabilidad completa del run:

```markdown
# AUDIT — {idea-slug} Brand Run

## Run Metadata

- Run ID: {UUID}
- Brand module version: 1.0
- Mode: normal
- Started: 2026-04-20T14:30:00Z
- Completed: 2026-04-20T14:57:42Z
- Duration: 27m 42s

## Tool Versions

- Stitch MCP: 0.3.2
- Image Gen MCP: 1.0.5
- Recraft Model: v4
- Huemint API: v1
- Domain Availability MCP: 2.1.0
- PDF Skill: 1.2

## Input Hashes

- Validation: sha256:abc123...
- Profile: sha256:def456...
- Idea text: sha256:ghi789...

## Decisions Made

### Scope Analysis
- Brand profile: b2b-smb (confidence 0.84)
- Classification signals: [...]
- Intensity modifiers: [...]

### Strategy
- Archetype: Sage
- Alternatives considered: [Ruler rejected (competitors ocupan), Hero rejected (profile incompat)]
- Voice attributes: [...]
- Brand values: [...]

### Verbal
- Name chosen: Auren (from 7 top candidates)
- Reason chosen: Top score 9.1, all domains free, TM clean
- User selection method: user-picked
- Copy assets generated: 18

### Visual
- Palette: Navy/Off-white/Amber
- Palette narrative: "Navy grounds, off-white breathes, amber humanizes"
- Typography: Fraunces + Inter + JetBrains Mono
- Mood imagery: 6 generated

### Logo
- Chosen: B2 (wordmark hybrid)
- Directions generated: 4 (3 wordmark + 1 combination)
- User selection: user-picked
- Variants: 4 (primary, mono, inverse, icon-only)
- Derivations: 12

### Activation
- Screens generated: 4 (landing, pricing, about, security)
- Coherence gates: 9/9 passed (1 retry on gate 3)
- PDF generated: yes (28 pages)

## Coherence Trace

See detailed in activation.coherence_trace in Engram.

Summary:
- All 9 gates passed
- Gate 3 required 1 retry: palette initially too saturated for Sage, regenerated

## Failures Encountered

- None critical
- Gate 3 retry as noted

## Cost Tracking

- Total USD: $0.73
- Image gen: 18 images (mood 6, logo 5, variants 4, derivations 3)
- Stitch generations used: 5
- Detailed breakdown in audit.cost_tracking

## User Interactions

- Scope confirmation: not prompted (confidence high)
- Strategy review: accepted default (Sage)
- Naming selection: user picked "Auren" from top 5
- Logo selection: user picked "B2"
- Coherence escalation: not triggered
```

## 18.7 Entregables por scope — cuadro resumen

| Scope | Directories activos en package |
|---|---|
| `b2b-enterprise` | microsite/, pitch-deck/, logo/, social/ (LinkedIn focus), communications/ (incl. press release, case studies), mood-references/ |
| `b2b-smb` | microsite/, logo/, social/ (LinkedIn + X), communications/, mood-references/ |
| `b2d-devtool` | microsite/ (con docs/), logo/, social/ (X + LinkedIn + GitHub), communications/, developer/, mood-references/ |
| `b2c-consumer-app` | microsite/ (con app-landing), app-assets/, logo/ (with app-icons), social/ (Instagram + TikTok), communications/, mood-references/ |
| `b2c-consumer-web` | microsite/, logo/, social/ (Instagram), communications/ (newsletter heavy), mood-references/ |
| `b2local-service` | microsite/ (local landing), local/, logo/, social/ (Instagram local), communications/ (WhatsApp heavy), minimal mood-references/ |
| `content-media` | microsite/, logo/, social/ (per creator channels), communications/ (newsletter + show notes), podcast or video-specific assets, mood-references/, merch/ |
| `community-movement` | microsite/, logo/ (symbolic strong), social/ (discord-focused), communications/ (manifesto + recruiting), merch/, mood-references/ |

## 18.8 Cross-references en el package

Algunos assets aparecen en múltiples directorios por practicality:

- **Logo**: primary está en `logo/source/` (canonical) pero copy en `microsite/assets/` (for microsite use)
- **Favicon**: está en `logo/derivations/` (canonical) Y en `microsite/assets/` (para el HTML)
- **OG card**: `logo/derivations/og-card-1200x630.png` + linked desde `microsite/index.html` meta tags
- **App icons**: en `app-assets/app-icons/` (canonical para app scope) Y referenced en `logo/` README para discoverability

Todos los duplications son copies, no symlinks, para portabilidad del package (user puede zip + send sin broken links).

## 18.9 Deployability

Package debe ser **inmediatamente usable**:

### Microsite deployment

```bash
cd output/{idea-slug}/brand/microsite/
# Vercel
vercel

# Netlify
netlify deploy --prod

# GitHub Pages (requires repo + push)
```

Con `netlify.toml` o `vercel.json` included (ver [22-open-decisions.md](./22-open-decisions.md)), deployment es zero-config.

### Logo usage

Source SVGs en `logo/source/` son editable directly en Figma, Illustrator, or any vector editor.

### Copy integration

`copy-library.md` es copy-pasteable. Organizado por use case. User copia + pega en su tool.

## 18.10 README template específico (excerpt)

```markdown
# {Brand Name} — Brand Package

...

## Quick start

1. **See your brand live**: open `microsite/index.html` in your browser
2. **Deploy**: `cd microsite/ && vercel` (zero config)
3. **Edit logo**: open `logo/source/primary.svg` in Figma
4. **Use the copy**: `copy-library.md` has everything organized

## Directory guide

- `microsite/` — Your landing page + pages, ready to deploy
- `logo/` — All logo variants + favicon + derivatives
- `social/` — Profile pictures, banners, post templates
- `communications/` — Email signature, bios, pitch lines, templates
- `brand-book.pdf` — 28-page complete brand manual
- `DESIGN.md` — Machine-readable design system (for future tools)

## Scope

Classified as: **B2B SMB SaaS** (confidence 84%)

Package optimized for:
- Content-driven + outbound sales distribution
- LATAM-focused cultural scope
- Pre-launch stage

## Disclaimers

...
```

## 18.11 Testing del package structure

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Package structure dinámica correcta por brand profile (b2b-enterprise tiene pitch-deck/, b2c-consumer-app tiene app-assets/, etc.)
2. README lista accurately lo incluido y excluido
3. All invariant files present (README, brand-book.pdf, DESIGN.md, AUDIT.md, logo/, copy-library.md)
4. Microsite opens correctly in browser
5. SVGs editable en vector editors
6. PDF renders correctly
7. Deployment configs (netlify.toml, vercel.json) work if included

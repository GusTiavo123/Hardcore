# Brand Design Document — PDF Structure Template

Reference consumed by Handoff Compiler in Step 2 (PDF compilation). Defines the PDF's page structure, layout guidance, and scope-specific variations.

---

## Core Principle

The PDF is NOT a spec dump. It is a **visually applied brand book** that reads like a running brand. Claude Design infers better from examples than from spec lists.

Anti-pattern:
```
Primary color: #0B1F3A (Navy)
Usage: backgrounds, auth, headers
```

Preferred:
```
[Large navy rectangle as page background]
[Sample heading "Navigate compliance with clarity" rendered in Fraunces 600]
[Small HEX tag bottom corner: #0B1F3A — Navy — backgrounds/auth]
```

---

## Meta-Branding

The PDF uses the brand itself:
- Logo primary in header of every page
- Color accents applied in the document's own UI
- Typography embedded (Fraunces for headings, Inter for body, etc.)
- Voice attributes respected in prose

The document is itself an example of the brand applied.

---

## Page Range per Brand Profile

| Brand profile | Page range | Rationale |
|---|---|---|
| `b2local-service` | 8-10 | Compact scope, no pitch deck, no enterprise sections |
| `b2b-smb` | 10-12 | Baseline |
| `b2d-devtool` | 10-13 | + Developer aesthetic preview, code snippet styling page |
| `b2c-consumer-web` | 10-12 | Baseline + social grid preview |
| `content-media` | 12-14 | + Podcast cover preview, newsletter template, merch direction |
| `b2c-consumer-app` | 12-15 | + App icon showcase, onboarding screens preview |
| `community-movement` | 14-16 | + Manifesto page, symbolic assets showcase, merch direction |
| `b2b-enterprise` | 14-18 | + Pitch deck preview, case study template, security/compliance copy |

---

## Base Sections — Always Present

### Page 1 — Cover

**Layout**: full page.

**Content**:
- Logo primary rendered large (centered, ~40% of page width)
- Brand name rendered in heading font (e.g., Fraunces 900, largest size)
- Tagline rendered in body font (large size)
- Date + "Brand Design System" subtle in footer

**Claude Design infers**: visual hierarchy, logo placement, typography scale, tagline style.

### Page 2 — Brand Essence

**Layout**: editorial 2-column.

**Content**:
- Heading: "Who we are"
- Archetype identification: e.g., "Sage — the expert guide"
- Brand promise (1 large sentence, quote style)
- Positioning statement (longer paragraph)
- Target audience refined (primary + secondary, brief)

**Claude Design infers**: editorial voice, tone, how the brand talks about itself.

### Page 3 — Voice & Tone

**Layout**: split page.

**Content**:
- Voice attributes listed with definitions (3-5)
- **Do / Don't columns** with sample copy:
  ```
  DO:                          DON'T:
  "Audit the audits."          "Our innovative synergies..."
  "40 hours → 2 hours."        "Revolutionary paradigms..."
  ```
- Voice principles applied in prose examples

**Claude Design infers**: acceptable copy style, tone boundaries.

### Page 4 — Color Palette

**Layout**: full-width color swatches + usage notes.

**Content**:
- Large swatches for primary, background, accent, text_primary, text_secondary
- Each swatch with HEX + name + usage description applied visibly on the swatch itself
- Contrast matrix visual (grid showing which text works on which bg)
- **Applied example**: mini-card showing palette in use (title + body + CTA button)

**Claude Design infers**: exact HEX codes, semantic usage, contrast rules.

### Page 5 — Typography

**Layout**: typography specimen page.

**Content**:
- **Heading font specimen**: large sample "The quick brown fox" rendered, plus sizes (48px, 32px, 24px)
- **Body font specimen**: paragraph of sample text, plus size variants
- **Mono font specimen** (if applicable): code-style sample
- Font metadata: family, weights available, Google Fonts import URL, size scale
- **Applied example**: mini-page layout showing typography hierarchy in action

**Claude Design infers**: font families, weights, sizes, line heights, how to pair.

### Page 6 — Logo System

**Layout**: logo showcase grid.

**Content**:
- Logo primary (large display)
- Logo variants: mono, inverse, icon-only (smaller, side by side)
- Clearspace diagram (minimum whitespace around logo)
- Minimum size per variant (wordmark 120px, icon 24px, favicon 16px typical)
- Don'ts list (no rotation, no filter, no recoloring outside palette, no distortion)

**Claude Design infers**: logo placement rules, variant usage, minimum sizes.

### Page 7 — Mood & Atmosphere

**Layout**: image grid (if refs) or prose description (if skipped).

**Content** (if Unsplash refs available):
- 3-6 mood images rendered with captions
- Each ref with URL + photographer attribution
- Mood axis description per ref (energy, texture, light, etc.)
- Prose: "The visual tone of {Brand} feels like..." + description

**Content** (if refs skipped — Unsplash down or scope excludes):
- Prose description of mood only
- Emphasize: "generous whitespace", "high contrast", "warm palette with single accent", etc.

**Claude Design infers**: visual style direction, imagery guidance.

### Page 8 — Visual Principles

**Layout**: principles with visual examples.

**Content**:
- Whitespace philosophy (with demonstration)
- Shape language (geometric/organic/mixed, with samples)
- Imagery style direction (guidance for Claude Design downstream)
- Density preference (low/medium/high, with sample layout)
- Motion principles (even if static PDF, describes speed/easing direction)

**Claude Design infers**: layout discipline, shape vocabulary, density, motion guidance.

### Page 9 — Copy Library Samples

**Layout**: rendered copy examples.

**Content**:
- Hero headline rendered at real size
- Tagline rendered in multiple lengths
- CTA examples (primary + secondary)
- Value props displayed as they'd appear on a landing page
- Social bios rendered in mock profile contexts (if applicable)

**Claude Design infers**: real copy length + style, how copy occupies space.

### Page 10 — Scope & Limitations

**Layout**: clean list page.

**Content**:
- What this brand book covers (all required outputs per scope manifest)
- What it doesn't cover (out-of-scope-declared: packaging 3D, print CMYK, motion, sonic, photography, organic illustrations)
- Next-layer workflow: Claude Design downstream for applied deliverables
- Disclaimers:
  - *"Trademark screening is preliminary — consult IP attorney before registering."*
  - *"Claude Design (Pro+) is the recommended downstream tool."*

**Claude Design infers**: context of what this is + isn't.

### Page N — Appendix

**Layout**: minimal.

**Content**:
- Brand module version (v1.0)
- Generation date
- Idea slug
- Validation + Profile refs (snapshot IDs)
- Archetype rationale summary
- Evidence trace pointer: "See AUDIT.md for full trace."

**Claude Design infers**: versioning context, not directly applied.

---

## Scope-Dependent Extra Sections

### `b2b-enterprise`

Add after Page 9, before Page 10:

**Pitch deck preview page**: 10-slide sketch (cover / problem / solution / market / competitive / traction / team / ask / financials / close). Small renderings with copy placeholders in brand voice.

**Security/compliance copy page**: sample compliance-language paragraphs (SOC2, GDPR, etc.) in brand voice (typically formal-professional).

**Case study template page**: structure (challenge → approach → results → testimonial) with placeholder copy.

**Executive audience section**: single page sample LinkedIn post for C-level targeting, formal.

### `b2d-devtool`

**Developer aesthetic preview page**: code snippet with syntax highlighting aligned to palette. Terminal/CLI aesthetic sample.

**GitHub README template page**: banner + badges + install + usage blocks rendered in brand palette.

**Documentation homepage sample page**: clean docs-style layout with brand colors.

### `b2local-service`

**Print applications preview page**: flyer mockup + business card mockup, rendered in brand.

**WhatsApp templates page**: rendered message bubbles (greeting, FAQ, booking confirmation, reminder) in brand voice.

**Local signage direction page**: signage samples in brand.

### `content-media`

**Podcast cover preview page** (if podcast in scope): 3000×3000 cover mockup rendered.

**Video thumbnails series page**: 3-5 thumbnail layouts with brand typography + color.

**Newsletter template page**: email layout with brand colors + typography.

**Merch direction page**: t-shirt / sticker / mug mockups.

### `b2c-consumer-app`

**App icon showcase page**: iOS set at multiple sizes (20-1024) + Android adaptive foreground+background + mask variants (circle, rounded, squircle).

**Onboarding screens preview page**: 3-5 first-run screens sketched in brand.

**App store listing preview page**: short description + 5 screenshot overlays rendered.

**Push notification templates page**: sample notification previews in brand voice.

### `b2c-consumer-web`

**Social grid preview page**: Instagram 3×3 grid of sample posts in brand.

**Referral preview page**: referral card / share visual sample.

### `community-movement`

**Manifesto page**: structured chapters preview (opening paragraph + chapter list). Full manifesto text (long-form) if within reasonable page budget.

**Symbolic assets showcase page**: flag-like emblems, member badges, recruitment asset sketches.

**Discord/Slack branding page**: server avatar + banner + emoji direction rendered.

**Recruiting copy page**: member onboarding sequence sample copy.

---

## Page Ordering

Always order: Cover → Essence → Voice → Palette → Typography → Logo → Mood → Principles → Copy Samples → [Scope extras] → Scope & Limitations → Appendix.

Scope extras go after Copy Samples and before Scope & Limitations.

---

## Visual Treatment

- **Headers**: logo primary (small, left) + page number (right) on every page except cover.
- **Footer**: brand name + date (subtle, bottom center) on every page except cover.
- **Whitespace**: generous per brand's visual principles (unless scope/archetype demands density).
- **Sample sizes**:
  - Palette swatches: ~100×100px minimum
  - Typography specimens: largest weight at ≥64px
  - Logo in showcase: primary at ~300px wide
  - Mood images: ~400px wide, captioned
- **Page background**: neutral (brand background color) unless a section calls for primary color page (e.g., logo inverse demo).

---

## Embedded Machine-Readable Design Tokens

The PDF embeds machine-readable design tokens that Claude Design can extract reliably. Without these, Claude Design may infer colors approximately but won't get exact HEX values.

### Color tokens (Page 4 — Palette)

Each swatch displays:
- HEX code prominently (e.g., `#0B1F3A`)
- Machine-readable line: `color-primary: #0B1F3A`
- Semantic usage tag: `usage: backgrounds, auth, headers`
- The swatch itself rendered in that exact color

Example layout per swatch:
```
[ Large rectangle filled with #0B1F3A, ~120×120 px ]
─────────────────────────────────
NAVY
color-primary: #0B1F3A
HSL: hsl(216, 68%, 14%)
usage: backgrounds, auth, headers
```

### Typography tokens (Page 5 — Typography)

Each font specimen displays:
- Family name in actual font: `Fraunces`
- Weights available: `400 / 600 / 700`
- Sizes applied at real proportions (48px / 32px / 24px specimens)
- Google Fonts import URL in small text near specimen:
  `import: https://fonts.googleapis.com/css2?family=Fraunces:wght@400;600;700&display=swap`

Specimen at multiple weights is critical — Claude Design infers weight scale from what it sees.

### Spacing tokens (Page 8 — Visual Principles)

Visual grid showing the spacing scale (4 / 8 / 16 / 24 / 32 / 48 / 64 / 96 px) **applied to actual layout spacing in the PDF itself**. The page IS an example of the scale.

Add a small reference: `spacing-scale: 4 / 8 / 16 / 24 / 32 / 48 / 64 / 96`.

### Component tokens (Page 9 — Copy Library Samples)

Applied component examples ARE the tokens — no abstraction layer. Render:
- Button at exact properties (color = accent, radius = 8px, padding = sm/md, font = body 500, size = body)
- Card at exact properties (radius = 12px, shadow = sm, padding = lg)
- These render with the same values as `tokens.css` / `tokens.json` produces

Add small annotation: `button: bg=accent, radius=md, padding=sm md, font=body 500`.

---

## Format & Production

### Tool

Use `ms-office-suite:pdf` skill. Generation path:
1. Handoff Compiler compiles markdown content per page with inline styling for visual elements
2. Markdown → PDF via skill (with embedded styling)
3. Embed Google Fonts (imported in PDF generation context)
4. Embed logo SVGs
5. Embed mood image refs (links + attribution, NOT downloaded binaries)

### Filename

`brand-design-document.pdf` — always canonical. Do not version in filename (versioning lives in `brand/{slug}/snapshot/v{N}` Engram metadata).

### File size targets

- Typical: **2-8 MB**
- Maximum acceptable: **~15 MB** (heavier when scope includes more imagery embeds, e.g., `content-media` or `b2c-consumer-app` with screenshot previews)
- If PDF exceeds 15 MB: regenerate with image compression. Flag if persistent after retry.

### PDF compatibility

- **PDF/A compliance** preferred (archivability) when the skill supports it.
- Fonts embedded — no CDN dependency post-download.
- Logo SVGs embedded as vector when supported, raster fallback otherwise.
- Tested in standard viewers: Preview (macOS), Adobe Reader, Firefox, Chrome.

---

## Claude Design Compatibility Testing (manual)

Verify the PDF is Claude Design-friendly. Required for at least 1 run per brand profile during Sprint 1 dogfooding.

**Test procedure**:
1. User uploads `brand-design-document.pdf` to Claude Design "Set up your design system".
2. Wait for extraction (~30s-2min).
3. Verify extracted design system:
   - **Colors**: primary, background, accent — match the swatches in Page 4? (HEX exact)
   - **Typography**: heading + body — match Page 5 specimens? (family + weights)
   - **Components**: buttons, cards — reflect Page 9 applied examples? (visual fidelity)
   - **Voice**: copy that Claude Design generates next — matches voice attributes from Page 3?
4. Create a test project in Claude Design.
5. Prompt: *"Create a simple 1-page site for {Brand Name} using my brand"*.
6. Compare: does the output feel like our brand (palette, typography, voice all coherent)?

**If mismatches**:
- Investigate which page failed to convey the value (color HEX visible? typography rendered in actual font?)
- Iterate the template (this file) and regenerate.
- Track in §Iteration Changelog below.

---

## Iteration Changelog

This section accumulates learnings from Claude Design dogfooding. Append entries; do not delete history (it's the signal).

```
## v1.0 (2026-04 — initial spec)
- Base structure as documented above

## v1.1 (TBD — after first dogfood run)
- {what was learned}
- {what changed in the template}
- {Claude Design behavior observation}
```

This file is a **living spec**. As Sprint 1 produces real Claude Design uploads, edit this section with concrete observations and version-bump as breaking changes accumulate.

---

## Fallback (markdown if PDF skill fails)

If `ms-office-suite:pdf` fails after retries, emit `brand-design-document.md` with:
- Same page structure as headings (H1 for cover, H2 for sections)
- Inline HEX codes + image embeds (via markdown image syntax)
- User-facing note: *"PDF generation failed. Convert this Markdown to PDF manually (Pandoc, browser print-to-PDF, etc.) or upload the .md to Claude Design directly (Claude Design accepts Markdown in codebase link mode)."*

Flag `pdf_conversion_failed: true` in Handoff envelope.

---

## Critical Rules

1. **Visual > Spec everywhere.** Never list HEX codes without applying them in the same view.
2. **Meta-brand the document.** The PDF uses the brand's own logo/palette/typography.
3. **Scope manifest drives optional sections.** Do not emit scope-extra pages that aren't in the manifest.
4. **Every page has a focus.** One main concept per page.
5. **Typography must be embedded.** Use Google Fonts import in the PDF generation context so rendered typography matches brand.
6. **Page count stays in range** per brand profile. Do not exceed.
7. **Machine-readable tokens always present.** Each color swatch, font specimen, and component example carries the literal token line that Claude Design can parse (e.g., `color-primary: #0B1F3A`).
8. **File size ≤ 15 MB.** Compress images on regeneration if exceeded.
9. **Test against Claude Design at least once per profile** during dogfooding. Record results in §Iteration Changelog.

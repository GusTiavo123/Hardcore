# Archetype Palette Seeds — HSL Ranges

Detailed HSL ranges and seed color suggestions per archetype. Consumed by Visual System as the starting point for palette generation.

Format per archetype:
- **Signature colors** — 3-5 HEX seeds with HSL values
- **HSL range guidance** — hue ranges, saturation range, lightness range for primary and accent slots
- **Formality modulation** — how `visual_formality: high | medium | low` shifts the ranges
- **Avoid** — colors that clash with the archetype

---

## Sage

**Signature seeds**
- Navy `#0B1F3A` — hsl(216, 68%, 14%)
- Charcoal `#2D3748` — hsl(218, 23%, 23%)
- Off-white `#F4EFE6` — hsl(38, 28%, 93%)
- Amber `#D4A74A` — hsl(41, 60%, 56%)
- Forest `#1F3A2E` — hsl(147, 32%, 18%)

**HSL ranges**
- Primary: hue 200–240, sat 30–70, light 15–35 (cool deep)
- Background: hue 30–60 or neutral, sat 10–30, light 90–96
- Accent: hue 30–50 (amber/gold) or 180–220 (cyan-blue), sat 40–70, light 50–65
- Text primary: hue 210–230, sat 20–40, light 20–30

**Formality modulation**
- `high` → darker primaries (light 10-20), desaturated accents (sat 40-55)
- `medium` → default ranges
- `low` → lighter primaries allowed (light 30-45), more saturated accents (sat 60-75)

**Avoid**: neons, pastels fluorescent, pure saturations >85

---

## Ruler

**Signature seeds**
- Black `#0A0A0A` — hsl(0, 0%, 4%)
- Deep green `#0C3B2E` — hsl(159, 66%, 14%)
- Gold `#D4AF37` — hsl(46, 65%, 52%)
- Burgundy `#5C1A1B` — hsl(359, 56%, 23%)
- Cream `#F5EBD5` — hsl(42, 60%, 90%)

**HSL ranges**
- Primary: hue 0 or 210–260 (near-black), sat 0–80, light 4–20
- Background: warm neutral or pure black, sat 0–40, light 3–95 (extremes)
- Accent: hue 30–55 (gold) or 350–10 (burgundy), sat 40–70, light 40–60
- Text: cream or charcoal for high contrast

**Formality modulation**
- `high` → black + gold minimalism
- `medium` → cream + deep green + gold
- `low` → approachable but keeps darker primaries

**Avoid**: playful pastels, casual earth tones, low-contrast palettes

---

## Hero

**Signature seeds**
- Crimson `#B91C1C` — hsl(0, 76%, 42%)
- Navy `#1E3A8A` — hsl(224, 64%, 33%)
- Bright yellow `#FBBF24` — hsl(45, 96%, 56%)
- Charcoal `#1F2937` — hsl(217, 33%, 17%)
- White `#FFFFFF` — hsl(0, 0%, 100%)

**HSL ranges**
- Primary: hue 0 (red) or 220 (navy), sat 60–85, light 30–45
- Accent: hue 40–55 (yellow), sat 80–95, light 50–60
- Background: pure white or near-black, sat 0, light 0–100
- Contrast: HIGH always

**Formality modulation**
- `high` → more navy, less yellow
- `medium` → balanced
- `low` → more yellow accent, more color blocks

**Avoid**: pastels, muted tones, low-contrast

---

## Creator

**Signature seeds**
- Teal `#0D9488` — hsl(174, 85%, 32%)
- Coral `#F97316` — hsl(22, 94%, 53%)
- Mustard `#D4A017` — hsl(46, 80%, 45%)
- Deep purple `#6B21A8` — hsl(272, 67%, 39%)
- Ivory `#FEFCE8` — hsl(54, 92%, 95%)

**HSL ranges**
- Primary: any hue, sat 60–85, light 35–55
- 3 accents allowed (unusual combinations encouraged)
- Background: warm off-white or saturated deep tone

**Formality modulation**
- `high` → rare for Creator; if needed, desaturate accents
- `medium` → 2 accents, 1 neutral
- `low` → full expression, 3 accents, unexpected combos

**Avoid**: completely neutral palettes (clashes with creative energy)

---

## Jester

**Signature seeds**
- Fuchsia `#EC4899` — hsl(330, 81%, 60%)
- Lime `#84CC16` — hsl(84, 81%, 44%)
- Electric blue `#3B82F6` — hsl(217, 91%, 60%)
- Sunshine yellow `#FACC15` — hsl(48, 96%, 54%)
- Soft white `#FAFAFA` — hsl(0, 0%, 98%)

**HSL ranges**
- 3+ accents mandatory
- All hues welcome, sat 60–90
- Deliberate clash encouraged (unexpected pairings)

**Formality modulation**
- `high` → ~incompatible (Jester rarely lives in high formality)
- `medium` → 2 bright accents on neutral
- `low` → full chaos, 4 accents, high saturation

**Avoid**: muted/desaturated palettes (kills the personality)

---

## Everyman

**Signature seeds**
- Warm gray `#78716C` — hsl(25, 5%, 45%)
- Soft earth `#A68A64` — hsl(33, 26%, 52%)
- Friendly orange `#F97316` — hsl(22, 94%, 53%)
- Cream `#FAF5E6` — hsl(43, 70%, 94%)
- Deep brown `#44403C` — hsl(30, 7%, 25%)

**HSL ranges**
- Primary: hue 20–50 (warm), sat 5–40, light 20–55
- Accent: hue 15–35 (friendly orange), sat 70–95, light 45–60 (max 1 accent)
- Background: warm cream or white

**Formality modulation**
- `high` → darker earth tones, less accent
- `medium` → balanced earth + 1 accent
- `low` → brighter, more accent

**Avoid**: cool aggressive tones, neons

---

## Caregiver

**Signature seeds**
- Terracotta `#C97B63` — hsl(12, 49%, 59%)
- Sage `#B5C7A1` — hsl(94, 25%, 71%)
- Cream `#FAF0E6` — hsl(30, 61%, 94%)
- Deep rose `#A67373` — hsl(0, 21%, 55%)
- Warm charcoal `#4A403C` — hsl(22, 11%, 26%)

**HSL ranges**
- Primary: hue 0–30 (warm) or 90–120 (soft green), sat 20–50, light 45–70
- Background: cream, hue 20–40, sat 30–60, light 90–95
- Accent: hue 340–20 (warm rose/peach), sat 30–60, light 55–70

**Formality modulation**
- `high` → deeper rose + cream, less accent
- `medium` → balanced
- `low` → more green/warm mix

**Avoid**: cool aggressive, high saturation, clinical gray

---

## Innocent

**Signature seeds**
- Sky blue `#BFDBFE` — hsl(213, 97%, 87%)
- Mint `#A7F3D0` — hsl(151, 79%, 80%)
- Pale pink `#FCE7F3` — hsl(326, 78%, 95%)
- Bright white `#FFFFFF` — hsl(0, 0%, 100%)
- Soft yellow `#FEF3C7` — hsl(48, 96%, 89%)

**HSL ranges**
- All colors pastels: sat 15–60, light 75–95
- High lightness universally
- Bright white backgrounds

**Formality modulation**
- `high` → less saturation (sat 15-30), more white
- `medium` → default pastels
- `low` → more saturation within pastel range (up to 60)

**Avoid**: dark tones, high saturation deep colors

---

## Explorer

**Signature seeds**
- Forest green `#1F3A2E` — hsl(147, 32%, 18%)
- Terracotta `#BF5B3F` — hsl(13, 52%, 50%)
- Sky blue `#60A5FA` — hsl(213, 94%, 68%)
- Khaki `#8B7355` — hsl(31, 25%, 44%)
- Cream `#F5E8C7` — hsl(43, 62%, 87%)

**HSL ranges**
- Primary: hue 80–160 (green) or hue 20–40 (earth), sat 20–55, light 20–50
- Accent: hue 10–30 (terracotta/saffron) or 190–220 (sky), sat 50–85, light 45–70
- Background: warm cream or earth

**Formality modulation**
- `high` → deeper earth, less sky accent
- `medium` → balanced earth + accent
- `low` → brighter accents, more sky

**Avoid**: sterile urban, pure grays, neons

---

## Outlaw

**Signature seeds**
- Pure black `#000000` — hsl(0, 0%, 0%)
- Blood red `#B91C1C` — hsl(0, 76%, 42%)
- Electric yellow `#FDE047` — hsl(51, 98%, 63%)
- Rust `#9C4221` — hsl(15, 64%, 37%)
- Stark white `#FFFFFF` — hsl(0, 0%, 100%)

**HSL ranges**
- Primary: hue 0 (red) or 0% (black), sat 0–85, light 0–45
- High contrast enforced (often black + one saturated accent)
- Accent: electric extremes, sat 70+

**Formality modulation**
- `high` → ~incompatible — Outlaw rarely lives in high formality
- `medium` → tamed but still high-contrast
- `low` → full provocation

**Avoid**: muted pastels, any "safe" palette, low contrast

---

## Magician

**Signature seeds**
- Deep purple `#3B0764` — hsl(270, 88%, 21%)
- Midnight blue `#1E1B4B` — hsl(242, 47%, 20%)
- Gold `#D4AF37` — hsl(46, 65%, 52%)
- Iridescent silver `#C0C0C0` — hsl(0, 0%, 75%)
- Cosmic black `#0A0A23` — hsl(240, 55%, 9%)

**HSL ranges**
- Primary: hue 230–290, sat 40–80, light 10–30
- Accent: metallic tones (gold, silver), any hue 0–360, sat 15–50, light 50–75
- Background: deep tones or dramatic dark

**Formality modulation**
- `high` → minimal metallic accents on deep
- `medium` → balanced
- `low` → more iridescence, more accent

**Avoid**: bright pastels, everyday tones

---

## Lover

**Signature seeds**
- Burgundy `#7F1D1D` — hsl(0, 62%, 31%)
- Dusty pink `#D4A5A5` — hsl(0, 35%, 74%)
- Cream `#FAF0E6` — hsl(30, 61%, 94%)
- Warm gold `#C9A063` — hsl(37, 46%, 59%)
- Deep rose `#A93755` — hsl(345, 52%, 44%)

**HSL ranges**
- Primary: hue 340–10 (warm red) or 20–45 (warm gold), sat 30–70, light 25–55
- Background: warm cream, hue 25–45, sat 40–65, light 90–95
- Accent: hue 340–5, sat 30–70, light 55–75

**Formality modulation**
- `high` → deeper tones, more cream
- `medium` → balanced
- `low` → brighter pinks, more accent

**Avoid**: cool sterile, analytical grays

---

## Usage Notes

1. **These are seeds, not prescriptions**. Visual System's Claude-native reasoning integrates seeds + archetype + formality + user overrides to produce the final palette. The seeds are starting points.

2. **WCAG compliance supersedes seed preservation**. If a seed color fails WCAG when paired with text, Visual must adjust text color (preserving seed as primary), not the seed itself. See `wcag-utility.md`.

3. **Hybrid profiles blend ranges**. For hybrid scopes, primary archetype's ranges dominate but secondary archetype's accents may be introduced at 20-30% weight.

4. **Override takes precedence**. `user_overrides.primary_color` replaces the seed-based primary. Remaining colors derived by harmony (complementary, triadic, split-complementary, analogous) based on archetype's color family.

5. **Alternate palettes** should demonstrate different aesthetic directions within the archetype — not random variations. Example for Sage: primary = cool dominant (navy/charcoal), alt-1 = warm dominant (cream/brown + navy accent), alt-2 = minimal (white + charcoal + single amber accent).

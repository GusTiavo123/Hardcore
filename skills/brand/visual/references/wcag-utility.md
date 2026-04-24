# WCAG Contrast Utility

Algorithm and pseudocode for computing WCAG 2.1 contrast ratios. Used by Visual System for palette validation (Step 3) and by Handoff Compiler for Gate 6 (Logo ↔ Palette legibility).

---

## WCAG 2.1 Formula

### Step 1 — Compute Relative Luminance of a color

For each sRGB component c ∈ {R, G, B} (values 0–255):

```
c_normalized = c / 255

if c_normalized ≤ 0.03928:
    c_linear = c_normalized / 12.92
else:
    c_linear = ((c_normalized + 0.055) / 1.055) ^ 2.4
```

Then compute luminance:

```
L = 0.2126 * R_linear + 0.7152 * G_linear + 0.0722 * B_linear
```

L is in the range [0, 1] where 0 is darkest black and 1 is brightest white.

### Step 2 — Contrast Ratio between two colors

```
L1 = luminance(color_lighter)
L2 = luminance(color_darker)
ratio = (L1 + 0.05) / (L2 + 0.05)
```

ratio is in the range [1, 21] where 1 is identical colors (no contrast) and 21 is pure black on pure white.

### Step 3 — Compliance Thresholds

| Level | Body text | Large text (≥18pt or bold ≥14pt) | UI components |
|---|---|---|---|
| AA | ≥ 4.5:1 | ≥ 3:1 | ≥ 3:1 |
| AAA | ≥ 7:1 | ≥ 4.5:1 | ≥ 3:1 |

**Visual System enforces AA**. AAA is nice-to-have but not a hard requirement.

---

## Pseudocode

```python
def hex_to_rgb(hex_color: str) -> tuple[int, int, int]:
    # "#0B1F3A" → (11, 31, 58)
    hex_color = hex_color.lstrip("#")
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def linearize(c: int) -> float:
    c_normalized = c / 255.0
    if c_normalized <= 0.03928:
        return c_normalized / 12.92
    return ((c_normalized + 0.055) / 1.055) ** 2.4

def luminance(hex_color: str) -> float:
    r, g, b = hex_to_rgb(hex_color)
    r_lin = linearize(r)
    g_lin = linearize(g)
    b_lin = linearize(b)
    return 0.2126 * r_lin + 0.7152 * g_lin + 0.0722 * b_lin

def contrast_ratio(color1_hex: str, color2_hex: str) -> float:
    L1 = luminance(color1_hex)
    L2 = luminance(color2_hex)
    lighter = max(L1, L2)
    darker = min(L1, L2)
    return (lighter + 0.05) / (darker + 0.05)

def passes_aa_body(text_hex: str, bg_hex: str) -> bool:
    return contrast_ratio(text_hex, bg_hex) >= 4.5

def passes_aa_large(text_hex: str, bg_hex: str) -> bool:
    return contrast_ratio(text_hex, bg_hex) >= 3.0
```

---

## Auto-Adjustment Algorithm (Visual System, Step 3)

When a text-background pair fails AA:

```python
def adjust_text_for_wcag(text_hex: str, bg_hex: str, target_ratio: float = 4.5) -> str:
    """
    Adjust text color's lightness until it meets target contrast ratio.
    Preserves the background (brand identity).
    Preserves hue and saturation of text as much as possible.
    """
    h, s, l = hex_to_hsl(text_hex)
    bg_luminance = luminance(bg_hex)

    # Decide direction: darken text if bg is light, lighten if bg is dark
    if bg_luminance > 0.5:
        # Light background → darken text (decrease lightness)
        direction = -1
    else:
        # Dark background → lighten text (increase lightness)
        direction = +1

    for iteration in range(50):  # max 50 iterations (~5% step)
        adjusted_hex = hsl_to_hex(h, s, l)
        ratio = contrast_ratio(adjusted_hex, bg_hex)

        if ratio >= target_ratio:
            return adjusted_hex

        l = max(0, min(100, l + direction * 2))  # 2% step
        if l == 0 or l == 100:
            break  # can't adjust further

    # If still failing: return the adjusted color with a flag for upstream handling
    return adjusted_hex  # caller checks ratio and decides to regenerate palette
```

---

## Required Pairs for Visual System Validation

For every generated palette, Visual System must compute and verify these pairs against AA body text:

| Text | Background | Target |
|---|---|---|
| text_primary | background | ≥ 4.5:1 |
| text_primary | primary | ≥ 4.5:1 |
| text_secondary | background | ≥ 4.5:1 |
| primary | background | ≥ 3:1 (UI component) |
| accent | background | ≥ 3:1 (UI component) |

Additionally for Large Text (≥ 3:1):
- Headings rendered in heading color on background

Emit all measured values in `data.palette.contrast_matrix`.

---

## Gate 6 (Handoff) — Logo Legibility Checks

Handoff Compiler uses the same algorithm for Gate 6 (Logo ↔ Palette legibility):

| Logo variant | Background | Target |
|---|---|---|
| primary logo | background (light) | ≥ 4.5:1 |
| primary logo | primary color | ≥ 4.5:1 |
| mono variant | any bg | ≥ 4.5:1 |
| inverse variant | dark bg | ≥ 4.5:1 |

For Gate 6, Handoff must render the SVG logo at a sample size, sample the dominant color(s), and check against the palette backgrounds.

---

## Notes

1. **WCAG 2.1 is the current standard**. WCAG 2.2 adds new guidelines but does not change contrast formulas. Our implementation covers both.

2. **Large text threshold**: "large" means ≥18pt normal weight OR ≥14pt bold. In our typography scale, `h1`, `h2`, `h3`, and `body_large` qualify as large.

3. **Color blindness**: AA compliance helps but does not fully address color blindness. For critical UI decisions, Brand Document recommends users test with Sim Daltonism or similar (noted in the Brand Document accessibility section).

4. **Semantic colors**: success/warning/error states should also meet AA against their backgrounds. Visual System includes semantic colors in `contrast_matrix` if present in the palette.

5. **Implementation note**: since Brand runs inside Claude with no compiled utilities, the sub-agent performs the above calculations as reasoning (converting HEX → RGB → linearized → luminance → ratio) and reports the values. Claude executes this deterministically for well-formed HEX inputs.

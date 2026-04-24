# Visual System — Data Schema

Schema of the `data` object that Visual returns (and persists at `brand/{slug}/visual`).

---

## Schema

```json
{
  "schema_version": "1.0",
  "department": "visual_system",
  "timestamp": "ISO-8601",
  "scope_ref": "brand/{slug}/scope",
  "strategy_ref": "brand/{slug}/strategy",

  "palette": {
    "generation_method": "claude-reasoning",
    "primary_palette": {
      "colors": {
        "primary": {
          "hex": "#RRGGBB",
          "hsl": {"h": "number", "s": "number", "l": "number"},
          "name": "string",
          "usage": "string"
        },
        "background": { "...": "..." },
        "accent": { "...": "..." },
        "text_primary": { "...": "..." },
        "text_secondary": { "...": "..." }
      }
    },
    "alternate_palettes": [
      {
        "name": "alt-1",
        "colors": { "...": "..." },
        "rationale": "string"
      },
      {
        "name": "alt-2",
        "colors": { "...": "..." },
        "rationale": "string"
      }
    ],
    "contrast_matrix": {
      "text_primary_on_background": "number",
      "text_secondary_on_background": "number",
      "primary_on_background": "number",
      "text_primary_on_primary": "number",
      "accent_on_background": "number"
    },
    "wcag_status": "passed | adjusted | fallback_applied",
    "palette_narrative": "string — why these colors for this archetype + formality"
  },

  "typography": {
    "era_applied": "editorial-classic | neutral-modern | expressive-contemporary | experimental",
    "heading": {
      "family": "string",
      "weights_available": ["number"],
      "weight_default": "number",
      "google_fonts_import": "https://fonts.googleapis.com/css2?family=...",
      "rationale": "string"
    },
    "body": {
      "family": "string",
      "weights_available": ["number"],
      "weight_default": "number",
      "google_fonts_import": "string",
      "rationale": "string"
    },
    "mono": {
      "family": "string",
      "weights_available": ["number"],
      "weight_default": "number",
      "google_fonts_import": "string",
      "rationale": "string"
    },
    "scale": {
      "h1": "string",
      "h2": "string",
      "h3": "string",
      "body_large": "string",
      "body": "string",
      "body_small": "string",
      "meta": "string",
      "line_height_body": "string",
      "line_height_heading": "string"
    }
  },

  "mood_imagery_refs": "null | [object]",

  "visual_principles": {
    "whitespace": "string",
    "shape_language": "geometric | organic | mixed + details",
    "imagery_style_direction": "string",
    "density": "low | medium | high",
    "motion_principles": "string"
  },

  "flags": ["string"],

  "evidence_trace": {
    "profile_fields_used": ["string"],
    "validation_depts_used": ["competitive"],
    "scope_modifiers_applied": ["string"],
    "mood_refs_queries_used": ["string"],
    "wcag_adjustments_applied": ["string"],
    "tool_versions": {
      "engram_mcp": "X.Y.Z",
      "unsplash_api_tier": "free-demo | free-production | unavailable",
      "claude_model": "claude-opus-4-7"
    },
    "timestamps": {
      "dept_start": "ISO-8601",
      "dept_end": "ISO-8601"
    }
  }
}
```

**`mood_imagery_refs[]` entry schema**:
```json
{
  "mood_axis": "energy | texture | composition | light | focus | motion",
  "query_used": "string",
  "unsplash_url": "https://unsplash.com/photos/{id}",
  "photo_id": "string",
  "photographer": "string",
  "attribution": "Photo by {photographer} on Unsplash",
  "description": "string — why this ref for this mood"
}
```

---

## Valid Flag Values

- `mood_imagery_skipped` — Unsplash down or 0 results after synonym retry
- `typography_fallback_to_default` — no archetype-specific pairing available, universal default applied
- `wcag_auto_adjusted` — text color was adjusted to meet AA
- `palette_regenerated` — initial palette failed WCAG, regeneration was needed
- `primary_color_override_used` — user provided `primary_color` as seed
- `primary_color_override_archetype_mismatch` — override incompatible with archetype (Gate 3 will halt)

---

## Assembly Checklist

**Top-level envelope**:
- [ ] `schema_version`, `status`, `department = "visual_system"`, `executive_summary`, `data`, `flags`, `next_recommended`

**Within `data.palette`**:
- [ ] `primary_palette.colors` has: primary, background, accent, text_primary, text_secondary (all 5 with hex + hsl + name + usage)
- [ ] `alternate_palettes[]` has 2 entries with rationale
- [ ] `contrast_matrix` has ≥5 measured pairs
- [ ] `wcag_status` populated
- [ ] `palette_narrative` non-empty

**Within `data.typography`**:
- [ ] `heading`, `body`, `mono` — all 3 populated with family, weights, default, google_fonts_import, rationale
- [ ] `era_applied` populated
- [ ] `scale` — all 9 sub-keys populated (h1-h3, body_large, body, body_small, meta, line_heights)

**Within `data.mood_imagery_refs`**:
- [ ] If scope manifest includes mood refs AND Unsplash available → 3-6 entries with all fields
- [ ] If scope excludes OR Unsplash unavailable → `null` with appropriate flag

**Within `data.visual_principles`**:
- [ ] All 5 keys populated (whitespace, shape_language, imagery_style_direction, density, motion_principles)

**Within `data.evidence_trace`**:
- [ ] `tool_versions` populated
- [ ] `mood_refs_queries_used[]` populated if mood refs generated
- [ ] `wcag_adjustments_applied[]` populated (empty array if no adjustments)

Missing fields break Logo (needs palette + typography) and Handoff (needs everything for tokens + Brand Document). Verify before returning.

# Logo — Data Schema

Schema of the `data` object that Logo returns (persisted at `brand/{slug}/logo`). SVG files themselves live on filesystem; Engram stores metadata + paths.

---

## Schema

```json
{
  "schema_version": "1.0",
  "department": "logo",
  "timestamp": "ISO-8601",
  "scope_ref": "brand/{slug}/scope",
  "strategy_ref": "brand/{slug}/strategy",
  "visual_ref": "brand/{slug}/visual",
  "verbal_ref": "brand/{slug}/verbal",

  "directions_generated": {
    "primary_form": "wordmark-preferred | combination | symbolic-first | icon-first",
    "generation_method": "claude-native-svg",
    "concepts": [
      {
        "id": "string (e.g., B1, B2, C1)",
        "direction": "string",
        "path": "output/{slug}/brand/logo/concepts/concept-{id}.svg",
        "rationale": "string",
        "form_language": "wordmark | combination | symbolic-geometric",
        "quality_validation_passed": "boolean",
        "retries_used": "number"
      }
    ],
    "chosen": "string (concept id)",
    "user_selection_method": "user-picked | auto-picked | user-manual-uploaded | dominant-auto-picked",
    "manual_upload_note": "string | null"
  },

  "variants": {
    "primary": "output/{slug}/brand/logo/source/primary.svg",
    "mono": "output/{slug}/brand/logo/source/primary-mono.svg",
    "inverse": "output/{slug}/brand/logo/source/primary-inverse.svg",
    "icon_only": "path | null"
  },

  "derivations": {
    "favicon": ["path"],
    "apple_touch": "path",
    "og_card": "path",
    "profile_pics": ["path"],
    "covers": {
      "x": "path | null",
      "linkedin": "path | null"
    }
  },

  "app_icons": "null | {ios: [path], android: {foreground: path, background: path, adaptive: path, masks: {circle: path, rounded: path, squircle: path}}}",

  "merch_direction": "null | {tshirt: path, stickers: path, mug: path}",

  "usage_guidelines": {
    "clearspace_rule": "string — e.g., '1x the x-height of the wordmark' or '0.5x the icon diameter'",
    "minimum_size": {
      "wordmark_px": "number",
      "icon_px": "number",
      "favicon_px": "number"
    },
    "donts": ["string"]
  },

  "quality_validation": {
    "all_concepts_passed_quality": "boolean",
    "retries_required": "number",
    "flags": ["string"],
    "organic_mark_requested_geometric_delivered": "boolean"
  },

  "flags": ["string"],

  "evidence_trace": {
    "svg_generation_attempts": "number",
    "regenerations_due_to_validation_fail": "number",
    "tool_versions": {
      "engram_mcp": "X.Y.Z",
      "claude_model": "claude-opus-4-7",
      "rasterization_tool": "string | unavailable"
    },
    "timestamps": {
      "dept_start": "ISO-8601",
      "dept_end": "ISO-8601"
    }
  }
}
```

---

## Valid Flag Values

- `quality_degraded` — 2+ consecutive concepts failed quality validation
- `organic_mark_requested_geometric_delivered` — scope/user wanted organic but v1 delivers geometric
- `user_manual_upload` — user provided own SVG
- `rasterization_deferred_to_user` — PNG/ICO conversion tool not available
- `regeneration_rounds_exceeded` — user rejected 3+ rounds; manual upload offered
- `16px_legibility_fallback` — icon-first concept failed 16px test; simplified version delivered

---

## Assembly Checklist

**Top-level envelope**:
- [ ] `schema_version`, `status`, `department = "logo"`, `executive_summary`, `data`, `flags`, `next_recommended`

**Within `data.directions_generated`**:
- [ ] `primary_form` matches scope.intensity_modifiers.logo_primary_form (unless user override)
- [ ] `concepts[]` has at least 3 valid entries (unless user manual upload)
- [ ] Each concept has id, direction, path, rationale, form_language, quality_validation_passed
- [ ] `chosen` references a valid concept id
- [ ] `user_selection_method` populated

**Within `data.variants`**:
- [ ] `primary`, `mono`, `inverse` — all 3 paths populated
- [ ] `icon_only` populated if form allows (combination, symbolic, icon-first)

**Within `data.derivations`**:
- [ ] Favicon paths (at minimum 16, 32, 48 sizes)
- [ ] Apple touch icon path
- [ ] OG card path (if landing in scope)
- [ ] Profile pics + covers per scope

**Within `data.app_icons`**:
- [ ] Populated with full set if `app_asset_criticality: primary`; `null` otherwise

**Within `data.usage_guidelines`**:
- [ ] `clearspace_rule` non-empty
- [ ] `minimum_size` all 3 keys populated
- [ ] `donts[]` has ≥3 entries

**Within `data.quality_validation`**:
- [ ] `all_concepts_passed_quality` boolean
- [ ] `retries_required` number
- [ ] `organic_mark_requested_geometric_delivered` boolean

Missing fields break Handoff (needs logo paths for Brand Document + Reference Assets). Verify before returning.

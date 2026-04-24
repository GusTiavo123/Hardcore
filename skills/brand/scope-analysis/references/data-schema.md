# Scope Analysis — Data Schema

Schema of the `data` object that the Scope Analysis sub-agent returns (and persists at `brand/{slug}/scope`). Every field listed here MUST be populated — missing fields break downstream depts.

---

## Schema

```json
{
  "schema_version": "1.0",
  "department": "scope_analysis",
  "timestamp": "ISO-8601",

  "inputs_summary": {
    "validation_slug": "string",
    "profile_user_slug": "string | null",
    "has_profile": true,
    "profile_completeness": "number (0..1) | null",
    "validation_verdict": "GO | PIVOT | NO-GO",
    "user_overrides": {}
  },

  "classification": {
    "customer": "B2B | B2C | B2D | B2G | Internal",
    "customer_secondary": "string | null",
    "format": "SaaS | mobile-app | physical-product | service-local | service-global | content-media | community | marketplace | API",
    "distribution": ["sales-driven | social-driven | community-driven | content-driven | app-store | marketplace | partnership-driven | PR-driven"],
    "stage": "pre-launch | MVP | growth | scale",
    "cultural_scope": "global | regional-LATAM | regional-US | regional-EU | local | niche-community"
  },

  "brand_profile": {
    "primary": "b2b-enterprise | b2b-smb | b2d-devtool | b2c-consumer-app | b2c-consumer-web | b2local-service | content-media | community-movement",
    "primary_confidence": "number (0..1)",
    "secondary": "string | null",
    "composition_weights": {
      "primary_profile_id": "number",
      "secondary_profile_id": "number (if hybrid)"
    }
  },

  "requires_user_confirmation": "boolean",
  "confirmation_options": [
    {
      "id": "number",
      "label": "string"
    }
  ],
  "confirmation_context": "string | null",

  "output_manifest": {
    "brand_document_sections": {
      "required": ["string"],
      "optional_recommended": ["string"],
      "skip": ["string"],
      "out_of_scope_declared": ["string"]
    },
    "prompts_library": {
      "required": ["string"],
      "optional_recommended": ["string"],
      "skip": ["string"]
    },
    "brand_tokens": {
      "required": ["string"]
    },
    "reference_assets": {
      "required": ["string"],
      "optional_recommended": ["string"]
    }
  },

  "intensity_modifiers": {
    "verbal_register": "formal-professional | professional-warm | casual-friendly | playful-bold | expressive-raw",
    "copy_depth": "long-form-allowed | medium | punchy-only",
    "visual_formality": "high | medium | low",
    "logo_primary_form": "symbolic-first | wordmark-preferred | combination | icon-first",
    "typography_era": "editorial-classic | neutral-modern | expressive-contemporary | experimental",
    "social_presence_priority": "enterprise-linkedin-only | professional-multichannel | consumer-heavy | community-native | content-creator | local-whatsapp",
    "app_asset_criticality": "not-needed | derivative | primary",
    "print_needs": "none | minimal | heavy",
    "sonic_needs": "none | branded | heavy",
    "motion_needs": "none | subtle | expressive"
  },

  "archetype_constraints": {
    "blocked": ["string — archetype name"],
    "preferred_range": ["string — archetype name"],
    "reasoning": "string — why these are blocked vs preferred for this classification + profile"
  },

  "reasoning_trace": {
    "classification_signals": {
      "customer": "string — evidence",
      "format": "string — evidence",
      "distribution": "string — evidence",
      "stage": "string — evidence",
      "cultural_scope": "string — evidence"
    },
    "profile_matching_scores": {
      "b2b-enterprise": "number",
      "b2b-smb": "number",
      "b2d-devtool": "number",
      "b2c-consumer-app": "number",
      "b2c-consumer-web": "number",
      "b2local-service": "number",
      "content-media": "number",
      "community-movement": "number"
    },
    "modifier_decisions": {
      "verbal_register": "string — why this value",
      "visual_formality": "string — why this value",
      "logo_primary_form": "string — why this value"
    }
  },

  "flags": ["string"],

  "evidence_trace": {
    "profile_fields_used": ["string"],
    "validation_depts_used": ["problem", "market", "competitive", "bizmodel", "risk", "synthesis"],
    "scope_modifiers_applied": ["string"],
    "tool_versions": {
      "engram_mcp": "X.Y.Z",
      "claude_model": "claude-opus-4-7"
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

- `low_confidence_classification` — primary_confidence < 0.5, fallback applied
- `decided_without_profile` — no founder profile available
- `decided_with_partial_profile` — profile completeness < 0.4
- `user_override_applied` — user pre-set brand_profile or other override
- `hybrid_profile` — secondary profile with weight > 0.4

---

## Assembly Checklist

Before returning the envelope, verify every field below is populated:

**Top-level envelope** (per `skills/_shared/output-contract.md`):
- [ ] `schema_version`
- [ ] `status` (`ok | warning | blocked | failed`)
- [ ] `department` = `"scope_analysis"`
- [ ] `executive_summary` (1-2 sentences with primary profile + confidence)
- [ ] `data` (full schema above)
- [ ] `flags` (array; empty acceptable)
- [ ] `next_recommended` (array; typically `["Launch Strategy"]`)

**Within `data`**:
- [ ] `classification` — all 5 axes populated
- [ ] `brand_profile.primary` + `primary_confidence` + (if hybrid) `secondary` + `composition_weights`
- [ ] `requires_user_confirmation` (boolean) — if true, both `confirmation_options` and `confirmation_context` populated
- [ ] `output_manifest` — all 4 sub-objects populated (brand_document_sections, prompts_library, brand_tokens, reference_assets)
- [ ] `intensity_modifiers` — all 10 keys populated (no nulls)
- [ ] `archetype_constraints` — blocked + preferred_range + reasoning
- [ ] `reasoning_trace.classification_signals` — evidence for each axis
- [ ] `reasoning_trace.profile_matching_scores` — scores for all 8 profiles
- [ ] `reasoning_trace.modifier_decisions` — rationale for modifier values
- [ ] `evidence_trace.profile_fields_used` (array; empty if no profile)
- [ ] `evidence_trace.validation_depts_used` — at minimum `problem, market, competitive, bizmodel`
- [ ] `evidence_trace.tool_versions` populated

Missing any field = pipeline fails downstream. Verify before returning.

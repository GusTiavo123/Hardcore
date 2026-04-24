# Strategy — Data Schema

Schema of the `data` object that Strategy returns (and persists at `brand/{slug}/strategy`).

---

## Schema

```json
{
  "schema_version": "1.0",
  "department": "strategy",
  "timestamp": "ISO-8601",
  "scope_ref": "brand/{slug}/scope",

  "archetype": {
    "chosen": "Innocent | Sage | Explorer | Outlaw | Magician | Hero | Lover | Jester | Everyman | Caregiver | Ruler | Creator",
    "rationale": "string",
    "considered_alternatives": [
      {"name": "string", "reason_rejected": "string"}
    ],
    "sentiment_landscape_used": "trust_heavy | disruption_ready | saturation_neutral | low_trust_context | mixed | insufficient_data"
  },

  "voice_attributes": [
    {
      "attribute": "string",
      "definition": "string",
      "do_examples": ["string"],
      "dont_examples": ["string"]
    }
  ],

  "voice_precedence_applied": {
    "archetype_contribution": "string",
    "scope_register_contribution": "string",
    "profile_preference_applied": "boolean",
    "profile_preference_noted_in_document": "boolean",
    "conflicts_resolved": ["string"]
  },

  "voice_register_archetype_tension": "boolean",

  "brand_values": [
    {
      "value": "string",
      "definition": "string",
      "evidence_source": "founder profile | validation.problem | validation.competitive | derived from positioning",
      "rationale": "string"
    }
  ],

  "brand_promise": "string",

  "positioning_statement": "string",

  "target_audience_refined": {
    "primary": {
      "description": "string",
      "psychographics": "string",
      "channels": ["string"],
      "pain_narrative": "string",
      "language_register_native": "string"
    },
    "secondary": "null | object (same shape as primary)"
  },

  "sentiment_landscape": "trust_heavy | disruption_ready | saturation_neutral | low_trust_context | mixed | insufficient_data",

  "flags": ["string"],

  "evidence_trace": {
    "profile_fields_used": ["string"],
    "validation_depts_used": ["problem", "market", "competitive", "bizmodel", "risk", "synthesis"],
    "scope_modifiers_applied": ["string"],
    "sentiment_landscape_derivation_path": "string — what signals led to this descriptor",
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

- `founder-voice-override-suppressed` — profile voice preference conflicted with archetype/scope
- `founder-credibility-anchor` — founder credibility_capital used in positioning
- `founder-domain-authority` — operator-level domain expertise leveraged
- `archetype_blocked_relaxation_applied` — preferred_range filter was relaxed to find a viable archetype
- `decided_without_profile` — no profile available
- `decided_with_partial_profile` — profile completeness < 0.4
- `insufficient_competitive_data_for_sentiment` — fallback to `insufficient_data` in sentiment_landscape
- `archetype_forced_by_user_override` — user set `archetype=X` pre-run

---

## Assembly Checklist

**Top-level envelope**:
- [ ] `schema_version`, `status`, `department = "strategy"`, `executive_summary`, `data`, `flags`, `next_recommended`
- [ ] `executive_summary` mentions archetype + positioning in 1-2 sentences

**Within `data`**:
- [ ] `archetype.chosen` (one of 12)
- [ ] `archetype.rationale` non-empty
- [ ] `archetype.considered_alternatives[]` has ≥2 entries with reason_rejected
- [ ] `archetype.sentiment_landscape_used` populated
- [ ] `voice_attributes[]` has 3-5 attributes
- [ ] Each voice attribute has definition + do_examples (≥2) + dont_examples (≥2)
- [ ] `voice_precedence_applied` all keys populated
- [ ] `voice_register_archetype_tension` boolean explicit (not null)
- [ ] `brand_values[]` has 3-5 entries
- [ ] Each brand value has definition + evidence_source + rationale
- [ ] `brand_promise` non-empty
- [ ] `positioning_statement` non-empty
- [ ] `target_audience_refined.primary` — all 5 sub-keys populated
- [ ] `sentiment_landscape` populated (one of 6 valid values)
- [ ] `evidence_trace.sentiment_landscape_derivation_path` non-empty
- [ ] `evidence_trace.validation_depts_used[]` includes at minimum problem, market, competitive, synthesis
- [ ] `evidence_trace.tool_versions` populated

Missing fields break Verbal, Visual, Logo, and Handoff. Verify before returning.

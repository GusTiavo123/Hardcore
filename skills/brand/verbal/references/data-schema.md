# Verbal Identity — Data Schema

Schema of the `data` object that Verbal returns (and persists at `brand/{slug}/verbal`).

---

## Schema

```json
{
  "schema_version": "1.0",
  "department": "verbal",
  "timestamp": "ISO-8601",
  "scope_ref": "brand/{slug}/scope",
  "strategy_ref": "brand/{slug}/strategy",

  "naming_artifact": {
    "strategies_used": ["Descriptive", "Compound", "Abstract", "..."],
    "candidates_all": [
      {
        "name": "string",
        "strategy": "string",
        "initial_fit_score": "number (0..10)"
      }
    ],
    "candidates_verified": [
      {
        "name": "string",
        "strategy": "string",
        "domain_availability": {
          ".com": "available | taken | unknown",
          ".io": "available | taken | unknown",
          ".ai": "available | taken | unknown",
          ".app": "available | taken | unknown",
          ".co": "available | taken | unknown",
          "{regional}": "available | taken | unknown"
        },
        "trademark_status": {
          "uspto": "green | yellow | red | unchecked",
          "wipo": "green | yellow | red | unchecked",
          "jurisdictional": {"jurisdiction": "status"}
        },
        "linguistic_notes": "string",
        "availability_score": "number (0..10)",
        "strategic_fit_score": "number (0..10)",
        "memorability_score": "number (0..10)",
        "linguistic_safety_score": "number (0..10)",
        "total_score": "number (0..10)"
      }
    ],
    "chosen": "string",
    "chosen_rationale": "string",
    "user_selection_method": "user-picked | auto-picked | dominant-auto-picked | user-override | manual",
    "disclaimer": "Trademark screening is a preliminary signal, not legal clearance. Consult a trademark attorney before commercial launch."
  },

  "core_copy_artifact": {
    "taglines": [
      {"length": "short", "text": "string"},
      {"length": "medium", "text": "string"},
      {"length": "aspirational", "text": "string"}
    ],
    "hero": {
      "primary": {"headline": "string", "subheadline": "string"},
      "alternatives": [
        {"headline": "string", "subheadline": "string"},
        {"headline": "string", "subheadline": "string"}
      ]
    },
    "value_props": {
      "one_line": "string",
      "paragraph": "string",
      "three_bullets": ["string", "string", "string"]
    },
    "about": {
      "short": "string (1 paragraph)",
      "medium": "string (3 paragraphs)"
    },
    "cta": {
      "primary": "string",
      "secondary": "string"
    },
    "pitch": {
      "one_liner": "string",
      "thirty_seconds": "string | null"
    },
    "social_bios": {
      "linkedin_company": "string | null",
      "linkedin_personal": "string | null",
      "twitter": "string | null",
      "instagram": "string | null",
      "tiktok": "string | null"
    },
    "communications_core": {
      "email_signature": "string | null",
      "whatsapp_greeting_seed": "string | null",
      "phone_greeting_script": "string | null"
    },
    "specialized_by_scope": {
      "github_readme_excerpt": "string | null",
      "cli_help_seed": "string | null",
      "app_store_short": "string | null",
      "app_store_long": "string | null",
      "manifesto_opening": "string | null",
      "recruiting_copy": "string | null",
      "pitch_deck_cover_slide": "string | null"
    },
    "faq_seed": [
      {"q": "string", "a": "string"}
    ]
  },

  "self_check_results": {
    "all_assets_voice_compliant": "boolean",
    "flagged_assets": [
      {"asset_key": "string", "issue": "string"}
    ],
    "regeneration_count": "number"
  },

  "flags": ["string"],

  "evidence_trace": {
    "profile_fields_used": ["string"],
    "validation_depts_used": ["problem", "competitive"],
    "tool_versions": {
      "engram_mcp": "X.Y.Z",
      "domain_availability_mcp": "X.Y.Z",
      "open_websearch_mcp": "X.Y.Z",
      "claude_model": "claude-opus-4-7"
    },
    "tm_jurisdictions_checked": ["USPTO", "WIPO", "..."],
    "domain_tlds_checked": [".com", ".io", ".ai", "..."],
    "timestamps": {
      "dept_start": "ISO-8601",
      "dept_end": "ISO-8601"
    }
  }
}
```

---

## Valid Flag Values

- `domain_availability_checked: false` — Domain MCP unavailable, skipped
- `trademark_screened: false` — open-websearch unavailable or failed, TM skipped
- `voice_compliance_partial` — one or more assets failed voice self-check after retries
- `user_override_name_used` — user provided name via override
- `dominant_candidate_auto_picked` — top-1 name auto-picked due to clear dominance
- `all_com_taken` — no candidates have `.com` available (alternate TLD strategies offered)
- `manual_name_mode` — user provided manual name after regeneration rejections

---

## Assembly Checklist

**Top-level envelope**:
- [ ] `schema_version`, `status`, `department = "verbal"`, `executive_summary`, `data`, `flags`, `next_recommended`

**Within `data.naming_artifact`**:
- [ ] `candidates_all[]` has 15-20 entries (unless user override)
- [ ] `candidates_verified[]` has 5-7 entries (or 1 if user override)
- [ ] Each verified candidate has domain_availability + trademark_status + all 4 sub-scores
- [ ] `chosen` populated
- [ ] `chosen_rationale` non-empty
- [ ] `user_selection_method` populated
- [ ] `disclaimer` exact text present

**Within `data.core_copy_artifact`**:
- [ ] `taglines[]` has 3 entries (short, medium, aspirational)
- [ ] `hero.primary` + at least 2 alternatives
- [ ] `value_props` — all 3 variants (one_line, paragraph, three_bullets)
- [ ] `about.short` + `about.medium`
- [ ] `cta.primary` + `cta.secondary`
- [ ] `pitch.one_liner`
- [ ] `pitch.thirty_seconds` if scope requires (b2b-enterprise/smb or select consumer)
- [ ] Social bios populated per scope manifest (scope-driven — not all are required)
- [ ] `communications_core.email_signature` (most scopes)
- [ ] `communications_core.whatsapp_greeting_seed` + `phone_greeting_script` if scope is b2local-service
- [ ] `specialized_by_scope.*` populated per scope trigger
- [ ] `faq_seed[]` has 10 entries

**Within `data.self_check_results`**:
- [ ] `all_assets_voice_compliant` boolean
- [ ] `flagged_assets[]` array (empty acceptable)
- [ ] `regeneration_count` number

**Within `data.evidence_trace`**:
- [ ] `tool_versions` populated for engram, domain_mcp, open-websearch, claude
- [ ] `tm_jurisdictions_checked[]` populated
- [ ] `domain_tlds_checked[]` populated

Missing fields break Logo (needs name) and Handoff (needs copy). Verify before returning.

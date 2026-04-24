# Handoff Compiler — Data Schema

Schema of the `data` object that Handoff Compiler returns (persisted at `brand/{slug}/handoff`). The filesystem package lives at `output/{slug}/brand/`.

---

## Schema

```json
{
  "schema_version": "1.0",
  "department": "handoff_compiler",
  "timestamp": "ISO-8601",
  "scope_ref": "brand/{slug}/scope",
  "strategy_ref": "brand/{slug}/strategy",
  "verbal_ref": "brand/{slug}/verbal",
  "visual_ref": "brand/{slug}/visual",
  "logo_ref": "brand/{slug}/logo",

  "coherence_trace": {
    "gates_executed": [
      {
        "gate_id": "number (0-8)",
        "name": "string",
        "result": "passed | failed | skipped",
        "feedback": "string | null",
        "criticality_for_profile": "critical | standard | flexible",
        "user_decision": "re_run_{dept} | accept_with_flag | abort | null",
        "re_run_outcome": "passed_on_second_pass | failed_again | null",
        "additional_details": {}
      }
    ],
    "final_state": "all_gates_passed | halted_by_user | accepted_with_flags | failed_after_user_decision",
    "halt_reason": "string | null",
    "flags_raised": ["string"]
  },

  "deliverables": {
    "brand_design_document": {
      "path": "output/{slug}/brand/brand-design-document.pdf",
      "format": "pdf | md-fallback",
      "pages": "number",
      "size_bytes": "number",
      "sha256": "string"
    },
    "prompts_library": {
      "path": "output/{slug}/brand/prompts-for-claude-design.md",
      "prompts_count": "number",
      "size_bytes": "number",
      "sha256": "string"
    },
    "brand_tokens": {
      "path": "output/{slug}/brand/brand-tokens/",
      "files": [
        {"name": "tokens.css", "validation_passed": true, "sha256": "string"},
        {"name": "tokens.json", "validation_passed": true, "sha256": "string"},
        {"name": "tailwind.config.js", "validation_passed": true, "sha256": "string"},
        {"name": "fonts.css", "validation_passed": true, "sha256": "string"},
        {"name": "examples/button.html", "validation_passed": true, "sha256": "string"},
        {"name": "examples/card.html", "validation_passed": true, "sha256": "string"},
        {"name": "examples/hero.html", "validation_passed": true, "sha256": "string"}
      ]
    },
    "reference_assets": {
      "path": "output/{slug}/brand/reference-assets/",
      "logo_files": [
        {"name": "primary.svg", "size_bytes": "number", "sha256": "string"}
      ],
      "mood_files": [
        {"name": "mood-01-energy.md", "unsplash_url": "string", "attribution": "string"}
      ],
      "app_icons_files": "null | [object]",
      "merch_files": "null | [object]"
    },
    "readme": {
      "path": "output/{slug}/brand/README.md",
      "size_bytes": "number"
    },
    "audit": {
      "path": "output/{slug}/brand/AUDIT.md",
      "size_bytes": "number"
    }
  },

  "package_summary": {
    "total_files": "number",
    "total_size_bytes": "number",
    "scope_profile": "string",
    "scope_confidence": "number",
    "brand_name": "string",
    "archetype": "string"
  },

  "claude_design_integration": {
    "handoff_method": "manual | auto-uploaded (future)",
    "brand_document_pdf_path": "string",
    "user_upload_confirmed": "null | ISO-8601 timestamp"
  },

  "status_final": "ok | partial | halted_at_gate | failed",

  "flags": ["string"],

  "evidence_trace": {
    "steps_completed": ["coherence_gates", "pdf_generation", "prompts_library", "brand_tokens", "reference_assets", "readme", "audit"],
    "retries_per_step": {
      "pdf_generation": "number",
      "token_validation": "number"
    },
    "tool_versions": {
      "engram_mcp": "X.Y.Z",
      "pdf_skill": "X.Y",
      "claude_model": "claude-opus-4-7"
    },
    "timestamps": {
      "dept_start": "ISO-8601",
      "gates_completed": "ISO-8601",
      "pdf_completed": "ISO-8601",
      "package_assembled": "ISO-8601",
      "dept_end": "ISO-8601"
    }
  }
}
```

---

## Valid Flag Values

- `pdf_conversion_failed` — PDF skill failed; markdown fallback delivered
- `token_file_validation_failed:{file}` — one or more token files failed validation after retries
- `mood_imagery_skipped` — Unsplash unavailable (propagated from Visual)
- `rasterization_deferred_to_user` — PNG/ICO generation skipped (propagated from Logo)
- `partial_delivery` — some outputs completed, some failed
- `accepted_with_flags_at_gate_{N}` — user accepted a coherence gate failure
- `halted_at_gate_{N}` — user aborted at a coherence gate
- `trademark_screened: false` — TM screening skipped (propagated from Verbal)
- `domain_availability_checked: false` — Domain MCP skipped (propagated from Verbal)
- `decided_without_profile` / `decided_with_partial_profile` — propagated profile flags

---

## Assembly Checklist

**Top-level envelope**:
- [ ] `schema_version`, `status`, `department = "handoff_compiler"`, `executive_summary`, `data`, `flags`, `next_recommended`
- [ ] `executive_summary` mentions gate outcome + package path

**Within `data.coherence_trace`**:
- [ ] `gates_executed[]` has 9 entries (one per gate), each with gate_id, name, result
- [ ] Each executed gate has `criticality_for_profile`
- [ ] Any failed gate has `feedback` + `user_decision`
- [ ] `final_state` populated

**Within `data.deliverables`**:
- [ ] `brand_design_document` populated (path, pages, size, sha256)
- [ ] `prompts_library` populated (path, prompts_count, size, sha256)
- [ ] `brand_tokens.files[]` has all 7 required files (or flagged)
- [ ] `reference_assets.logo_files[]` has primary + mono + inverse at minimum
- [ ] `readme` + `audit` paths populated

**Within `data.package_summary`**:
- [ ] All 6 keys populated

**Within `data.claude_design_integration`**:
- [ ] `handoff_method = "manual"` in v1
- [ ] `brand_document_pdf_path` matches deliverables path
- [ ] `user_upload_confirmed: null` (to be set post-delivery by user report)

**Within `data.status_final`**:
- [ ] Populated (`ok` if all gates passed and all files delivered)

**Within `data.evidence_trace`**:
- [ ] `steps_completed[]` tracks actual execution
- [ ] `tool_versions` populated
- [ ] `timestamps` all 5 sub-keys populated

Missing fields complicate downstream module consumption + audit. Verify before returning.

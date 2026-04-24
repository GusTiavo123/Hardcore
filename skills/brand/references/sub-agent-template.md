# Brand Sub-Agent Launch Template

When the Brand orchestrator launches a department as a sub-agent (including Scope Analysis), use the **Agent tool** with this prompt template.

---

## Standard Template

```
Read and follow these files exactly:
- skills/_shared/output-contract.md
- skills/_shared/engram-convention.md
- skills/_shared/persistence-contract.md
- skills/_shared/department-protocol.md
- skills/_shared/glossary.md
- skills/_shared/profile-contract.md
- skills/_shared/brand-contract.md
- skills/brand/{department}/SKILL.md

For the data schema and assembly checklist, read:
- skills/brand/{department}/references/data-schema.md

Shared Brand references (read if your SKILL.md instructs you to):
- skills/brand/references/brand-profiles.md
- skills/brand/references/archetype-guide.md
- skills/brand/references/coherence-rules.md

Input:
{
  "idea": "{original idea text}",
  "slug": "{slug}",
  "persistence_mode": "engram",
  "mode": "{normal | fast | extend | resume}",
  "founder_brand_context": {founder_brand_context_json} or null,
  "scope_ref": "brand/{slug}/scope" or null,
  "strategy_ref": "brand/{slug}/strategy" or null,
  "verbal_ref": "brand/{slug}/verbal" or null,
  "visual_ref": "brand/{slug}/visual" or null,
  "logo_ref": "brand/{slug}/logo" or null,
  "user_overrides": {} or null
}

CRITICAL:
- Your `data` object must contain EVERY field from the schema in references/data-schema.md.
- Cross-reference the Assembly Checklist before returning.
- Missing fields break downstream departments.
- If `founder_brand_context` is not null, read `skills/_shared/brand-contract.md` for the Profile → Brand field map.
- Profile context informs qualitative choices only (voice register, narrative framing, cultural cues) — NEVER structural decisions (archetype, palette, token structure).

Return the output envelope per `skills/_shared/output-contract.md`.
```

---

## Which Refs Each Dept Reads

| Department | Additional refs to load |
|---|---|
| scope-analysis | `brand-profiles.md` (primary reference), `archetype-guide.md` (§6 sentiment map) |
| strategy | `archetype-guide.md` (all sections) |
| verbal | `archetype-guide.md` (§2, §3, §4, §5) |
| visual | `archetype-guide.md` (§7, §8); own refs `archetype-palette-seeds.md`, `wcag-utility.md` |
| logo | `archetype-guide.md` (§9); own ref `svg-templates.md` |
| handoff-compiler | `coherence-rules.md` (primary); own refs `brand-document-template.md`, `prompts-library-templates.md`, `tokens-templates.md` |

---

## Tool Expectations per Department

| Department | Tools required |
|---|---|
| scope-analysis | Engram only (retrieval + save) |
| strategy | Engram + optional open-websearch (only if `sentiment_landscape` derivation returns `insufficient_data` and user authorized additional research) |
| verbal | Engram + Domain MCP (domain availability) + open-websearch (trademark screening via USPTO TESS + WIPO Global Brand Database) |
| visual | Engram + Unsplash free API (mood imagery refs) |
| logo | Engram only (Claude native SVG generation) |
| handoff-compiler | Engram + `ms-office-suite:pdf` skill (PDF generation) + filesystem write |

If a dept's required external tool is down, follow the failure protocol in `skills/brand/SKILL.md` §Failure Modes. Graceful degradation with explicit flag > hard halt (except Engram — hard halt).

---

## Envelope Validation (after each department)

After receiving output from each sub-agent, the orchestrator verifies the envelope. Log violations as warnings but do NOT block the pipeline unless the status is `blocked` or `failed`.

**Required checks**:
1. `status` is one of: `ok | warning | blocked | failed`
2. `schema_version` is present
3. `department` matches expected department name
4. `data` contains every field from the dept's data-schema.md (cross-reference the Assembly Checklist)
5. `evidence_trace.tool_versions` is present
6. `flags[]` is present (empty array acceptable)
7. Required artifact paths exist when emitted (e.g., Logo must produce at least 3 valid SVGs for primary)

If any check fails: warn, continue. If `status` is `blocked` or `failed`: halt, surface to user, offer `/brand:extend {dept}` or `/brand:resume`.

---

## Fast Mode Modifier

When `mode: "fast"` is passed:
- Dept skips user-interaction prompts (naming selection, logo selection — auto-picks top-ranked).
- Dept returns condensed `executive_summary`.
- Dept still produces the full `data` object — detail level never reduces data completeness.

See `department-protocol.md` §Detail Level Rules for the underlying pattern (Brand reuses the Validation convention).

---

## Extend Mode Modifier

When `mode: "extend"` is passed, the sub-agent:
- Reads the previous output from Engram (same topic key).
- Applies the user-provided feedback (passed in `user_overrides.extend_feedback`).
- Regenerates with the feedback incorporated.
- Increments `revision_count` in its own output.

Orchestrator then re-runs coherence gates (from scratch, full set) after extend completes.

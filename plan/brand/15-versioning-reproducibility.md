# 15 — Versioning y Reproducibilidad

## 15.1 Propósito

Cómo Brand versiona runs, permite reproducción, y compara versiones.

Snapshot incluye `tier_used`, tracking de Claude Design compatibility, y cost tracking tier-aware.

## 15.2 Conceptos

### Snapshot

- Captura state completo de run exitoso
- Creado al completar Handoff Compiler
- Inmutable
- Identificado por `vN`
- Auto-increment en full run

### Partial re-run (extend)

`/brand:extend {depto}` **NO** crea snapshot nuevo:
- Updatea topic key del dept
- Incrementa revision_count del dept
- Files en filesystem sobrescriben
- Se graba en `snapshot.extensions[]` del current

### User-forced snapshot

`/brand:snapshot` fuerza nuevo snapshot con current state (útil después de varios extends).

## 15.3 Snapshot schema

Topic key: `brand/{slug}/snapshot/v{N}`

```json
{
  "schema_version": "1.0",
  "snapshot_version": "v1",
  "snapshot_type": "full_run | user_forced",
  "created_at": "ISO-8601",
  "completed_at": "ISO-8601",
  "duration_seconds": 1122,
  
  "idea_slug": "auren-compliance",
  "user_slug": "user-slug",
  
  "mode_used": "normal | fast | extend | override",
  "tier_used": 0 | 1 | 2,
  "user_overrides": [...],
  
  "input_hashes": {
    "validation_hash": "sha256:...",
    "profile_hash": "sha256:...",
    "idea_text_hash": "sha256:..."
  },
  
  "tool_versions": {
    "brand_module_version": "1.0",
    "recraft_model": "v4 or null if Tier 0",
    "huemint_api": "v1 or null if Tier 0",
    "domain_mcp": "2.1.0",
    "pdf_skill": "1.2",
    "claude_model": "claude-opus-4-7"
  },
  
  "output_refs": {
    "scope": "brand/{slug}/scope#revision_N",
    "strategy": "brand/{slug}/strategy#revision_N",
    "verbal": "brand/{slug}/verbal#revision_N",
    "visual": "brand/{slug}/visual#revision_N",
    "logo": "brand/{slug}/logo#revision_N",
    "handoff": "brand/{slug}/handoff#revision_N"
  },
  
  "filesystem_path": "output/auren-compliance/brand/",
  "filesystem_manifest": [
    {"path": "brand-design-document.pdf", "sha256": "..."},
    {"path": "prompts-for-claude-design.md", "sha256": "..."},
    {"path": "brand-tokens/tokens.json", "sha256": "..."},
    {"path": "reference-assets/logo/primary.svg", "sha256": "..."}
  ],
  
  "cost_tracking": {
    "tier_used": 0,
    "image_gen_usd": 0.00,
    "image_gen_count": 0,
    "claude_design_handoff_made": true,
    "total_cost_usd": 0.00,
    "total_runtime_seconds": 1122
  },
  
  "coherence_trace": {
    "gates_executed": [...8 gates],
    "escalations": [],
    "final_state": "all_gates_passed"
  },
  
  "audit": {
    "failures_encountered": [],
    "retries_per_tool": {...},
    "extensions": []
  },
  
  "claude_design_integration": {
    "handoff_method": "manual | auto (future when MCP exists)",
    "brand_document_pdf_path": "...",
    "user_upload_confirmed": null | true | false
  }
}
```

## 15.4 Comando `/brand:diff v1 v2`

Compara dos snapshots.

**Ejemplo output**:

```
/brand:diff v1 v2

Comparing v1 (2026-04-20) ↔ v2 (2026-04-25)

Inputs changed:
  ⚠ validation_hash: differente (re-run Validation entre snapshots)
  ✓ profile_hash: same
  ✓ idea_text_hash: same

Tier:
  v1: Tier 0 ($0.00)
  v2: Tier 1 ($0.18) — auto-elevated for symbolic logo

Strategy:
  archetype: Sage → Sage (same)
  voice_attributes:
    - added: "formal"
    - removed: "levemente irónico"

Verbal:
  name: Auren → Auren (same)
  tagline: "Audit the audits." → "Institutional-grade simplification." (changed)
  copy assets changed: 8/12

Visual:
  palette: (navy/off-white/amber) → (navy/cream/gold) — accent shifted
  typography: same
  mood_imagery: 
    v1: none (Tier 0)
    v2: 6 Unsplash curated (Tier 1)

Logo:
  chosen: B2 → C1 (different direction — wordmark → combination)
  generation_method: claude-native → mixed (Recraft + Claude)

Handoff:
  brand-design-document.pdf: regenerated
  prompts-library.md: regenerated  
  brand-tokens/: regenerated
  reference-assets/: logos regenerated + mood added

Cost delta: $0.00 → $0.18 (tier elevation)

Claude Design compatibility:
  v1 upload: confirmed ✓
  v2 upload: pending

Overall: v2 shifted more institutional register, logo direction changed,
mood imagery added.
```

## 15.5 Comando `/brand:rollback v1`

Revertir a snapshot v1:
- Restore Engram topic keys
- Backup current filesystem to `output/{slug}/brand-v2-backup/`
- Restore filesystem from v1 state

User confirms antes de sobreescribir.

## 15.6 Comando `/brand:show`

```
/brand:show                    # Latest snapshot
/brand:show v1                 # Specific version
/brand:show --list             # List all snapshots
```

`--list` output:
```
Brand snapshots for "auren-compliance":

v1 (2026-04-20T14:57:42Z)  — full_run, normal, Tier 0, $0.00
  Archetype: Sage · Name: Auren · Profile: b2b-smb
  Claude Design upload: confirmed

v2 (2026-04-25T10:30:15Z)  — full_run, normal, Tier 1, $0.18
  Archetype: Sage · Name: Auren · Profile: b2b-smb
  Changes: voice formal, mood imagery added, logo direction changed
  Claude Design upload: pending

(latest)
```

## 15.7 Reproducibility — exact reproduction

Reproducir snapshot:

**Requirements**:
1. Same tool versions accessible
2. Same input hashes (Validation + Profile unchanged)
3. Same user overrides
4. Same tier (cost-relevant)

**Process**:

```
/brand:reproduce v1

Checks:
  ✓ Validation hash matches
  ✓ Profile hash matches
  ✓ Brand module version: 1.0 → 1.0 (same)
  ⚠ Recraft model: v4 (v1) → v4.1 (current) — minor update, may produce different images

Options:
  1. Reproduce con current tools (expect minor variance en imagenes)
  2. Abort — need exact versions
  3. Produce new v3 with current tools (not reproduction, start from v1 inputs)
```

**Limitation honest**: image generation no determinístico. Logos y mood pueden variar. Strategy decisions, Verbal copy (if deterministic Claude) deben ser idénticos.

## 15.8 Staleness detection

Downstream module consuming Brand:
- Compare `brand.snapshot.created_at` vs `validation.last_updated` + `profile.last_updated`
- If Brand snapshot viejo que Validation/Profile updates: flag staleness
- If Brand > 180 days: flag "considera regenerar"

## 15.9 Storage considerations

Snapshots en Engram + filesystem:

- **Engram**: metadata (~5KB). Negligible.
- **Filesystem per snapshot**: varies por tier.
  - Tier 0: ~5-10MB (sin mood imagery, PDF + SVGs + markdowns)
  - Tier 1: ~20-30MB (+ Unsplash mood refs)
  - Tier 2: ~30-50MB (+ Recraft mood generated)

10 snapshots mixed: ~200-400MB.

**Policy**:
- Keep all por default
- `/brand:cleanup --keep-last N` deletear viejos (except v1)
- Recommendation: keep all until 2GB, después cleanup oldest

Cleanup NO toca Engram — solo filesystem.

## 15.10 Tool version compatibility matrix

`skills/brand/references/version-compatibility.md`:

```yaml
brand_module_version: "1.0"
tested_with:
  recraft: ["v4"]
  huemint_api: ["v1"]
  domain_mcp: [">= 2.0.0"]
  pdf_skill: [">= 1.0.0"]
  claude_design: "web v1 (Apr 2026)"

breaking_changes:
  - brand_module: "1.0 → 2.0 (hypothetical)"
    effect: "archetype selection algorithm changed"
    migration: "re-run brand"
  
  - claude_design: "Labs → GA (when released)"
    effect: "PDF format expectations may change"
    migration: "re-run Handoff Compiler to regenerate PDF in new format"
```

## 15.11 Audit log

Cada action graba:

```
brand/{slug}/audit-log

Entries:
  2026-04-20 14:30 — brand:new started (mode: normal, tier: 0)
  2026-04-20 14:57 — brand:new completed, snapshot v1 created
  2026-04-21 09:15 — user reported: Claude Design upload successful
  2026-04-25 10:00 — brand:extend logo started (requesting Tier 1 elevation)
  2026-04-25 10:05 — user confirmed tier elevation to Tier 1 (+$0.18 estimated)
  2026-04-25 10:15 — brand:extend logo completed
  2026-04-25 10:30 — brand:snapshot (user-forced) — v2 created
```

Accesible via `/brand:audit {slug}`.

## 15.12 Reference file a escribir en Sprint 0

`skills/brand/references/versioning.md` con:
- Snapshot schema completo
- Diff algorithm
- Rollback procedure
- Reproducibility guarantees y limitations
- Storage policies
- Tier tracking details

## 15.13 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Full run → snapshot v1 creado
2. `/brand:extend logo` → v1.logo revision++ but NO new snapshot
3. `/brand:snapshot` → forces v2
4. Second full run → snapshot v2 auto-creado
5. `/brand:diff v1 v2` → muestra diferencias incluyendo tier change
6. `/brand:rollback v1` → restores correctly
7. `/brand:show --list` → lista todos
8. Staleness detection triggered correctly
9. Cleanup filesystem preserves Engram metadata
10. Tier 0 snapshot vs Tier 1 snapshot diff reflects cost + generation_method differences

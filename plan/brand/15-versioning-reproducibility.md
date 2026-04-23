# 15 — Versioning y Reproducibilidad

## 15.1 Propósito

Cómo Brand versiona runs, permite reproducción, y compara versiones.

Snapshot incluye input hashes, tool versions, timestamps, coherence trace, y file manifests. Reproducibility está limitada por la naturaleza no-determinística de la SVG generation (ver 15.7).

## 15.2 Conceptos

### Snapshot

- Captura state completo de run exitoso
- Creado al completar Handoff Compiler
- Inmutable
- Identificado por `vN`
- Auto-increment en cada full run completo

### Partial re-run (extend)

`/brand:extend {depto}` **NO** crea snapshot nuevo:
- Updatea topic key del dept
- Incrementa `revision_count` del dept en el current snapshot
- Files en filesystem sobrescriben
- Se graba en `snapshot.extensions[]` del snapshot actual

### User-forced snapshot

`/brand:snapshot` fuerza nuevo snapshot con el current state (útil después de varios extends consecutivos).

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
  "user_slug": "user-slug | null",

  "mode_used": "normal | fast | extend | override | resume",
  "user_overrides": [],

  "input_hashes": {
    "validation_hash": "sha256:...",
    "profile_hash": "sha256:... | null",
    "idea_text_hash": "sha256:..."
  },

  "tool_versions": {
    "brand_module_version": "1.0",
    "engram_mcp": "X.Y.Z",
    "open_websearch_mcp": "X.Y.Z",
    "domain_availability_mcp": "X.Y.Z",
    "unsplash_api_tier": "free-demo | free-production | unavailable",
    "pdf_skill": "X.Y",
    "claude_model": "claude-opus-4-7",
    "claude_design_version": "web v1 (2026-04)"
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
    "external_api_cost_usd": 0.00,
    "engram_operations": 0,
    "web_search_queries": 0,
    "domain_checks": 0,
    "unsplash_fetches": 0,
    "pdf_generations": 1,
    "claude_svgs_generated": 0
  },

  "coherence_trace": {
    "gates_executed": [],
    "final_state": "all_gates_passed | halted_by_user | accepted_with_flags"
  },

  "audit": {
    "failures_encountered": [],
    "retries_per_tool": {},
    "extensions": [],
    "flags_raised": []
  },

  "claude_design_integration": {
    "handoff_method": "manual",
    "brand_document_pdf_path": "output/{slug}/brand/brand-design-document.pdf",
    "user_upload_confirmed": null
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
  ⚠ validation_hash: different (re-run Validation entre snapshots)
  ✓ profile_hash: same
  ✓ idea_text_hash: same

Strategy:
  archetype: Sage → Sage (same)
  voice_attributes:
    - added: "formal"
    - removed: "levemente irónico"
  sentiment_landscape: trust_heavy → trust_heavy (same)

Verbal:
  name: Auren → Auren (same)
  tagline: "Audit the audits." → "Institutional-grade simplification." (changed)
  copy assets changed: 8/12

Visual:
  palette: (navy/off-white/amber) → (navy/cream/gold) — accent shifted
  typography: same
  mood_imagery_refs: 3 → 6 (+3)

Logo:
  chosen: B2 → C1 (different direction — wordmark → combination)

Handoff:
  brand-design-document.pdf: regenerated (8 pages → 12 pages)
  prompts-library.md: regenerated
  brand-tokens/: regenerated
  reference-assets/: logos regenerated + mood refs added

Coherence:
  gates passed: 9/9 → 9/9 (both clean)

Claude Design compatibility:
  v1 upload: confirmed ✓
  v2 upload: pending

Overall: v2 shifted more institutional register, logo direction changed, more mood refs.
```

## 15.5 Comando `/brand:rollback v1`

Revertir a snapshot v1:
- Restore Engram topic keys al state de v1
- Backup current filesystem a `output/{slug}/brand-vN-backup/`
- Restore filesystem desde v1 manifest
- User confirms antes de sobreescribir (confirmación explícita requerida porque es destructive)

## 15.6 Comando `/brand:show`

```
/brand:show                    # Latest snapshot — executive summary
/brand:show v1                 # Specific version
/brand:show --list             # List all snapshots
```

`--list` output:
```
Brand snapshots for "auren-compliance":

v1 (2026-04-20T14:57:42Z)  — full_run, normal
  Archetype: Sage · Name: Auren · Profile: b2b-smb
  Claude Design upload: confirmed

v2 (2026-04-25T10:30:15Z)  — full_run, normal
  Archetype: Sage · Name: Auren · Profile: b2b-smb
  Changes: voice más formal, mood refs añadidos, logo direction cambiado
  Claude Design upload: pending

(latest)
```

## 15.7 Reproducibility — honest limitations

Reproducir exactamente un snapshot tiene límites inherentes:

**Qué es determinístico (alta reproducibilidad)**:
- Archetype selection (dado mismo input)
- Voice attributes (dado mismo archetype + register)
- Brand values (dado mismos inputs)
- Positioning statement (alta consistencia)
- Palette generation (Claude razonamiento — alta consistencia pero no idéntica)
- Typography pairing

**Qué NO es determinístico**:
- SVG logo generation (Claude genera SVG markup con variación creativa)
- Copy text específico (tagline, hero headlines — wording varía)
- Unsplash refs (si Unsplash devuelve resultados distintos o el query cambia levemente)
- Brand Document layout fino (PDF rendering puede variar entre versiones del skill)

**Proceso para reproduction**:

```
/brand:reproduce v1

Checks:
  ✓ Validation hash matches (validation no cambió desde v1)
  ✓ Profile hash matches
  ✓ Brand module version: 1.0 → 1.0 (same)
  ⚠ pdf_skill version: X.Y (v1) → X.Z (current) — minor update, layout puede variar

Options:
  1. Reproduce con current tools (expect variance en SVGs + copy wording)
  2. Abort — needs exact versions (no siempre posible)
  3. Produce new v3 with current tools (no reproduction — start from v1 inputs)
```

**Qué sí podemos garantizar al reproduce**:
- Archetype elegido es el mismo
- Voice attributes son los mismos (o muy cercanos)
- Brand values son los mismos
- Scope classification es la misma

**Qué no podemos garantizar**:
- SVG output idéntico (bytes iguales)
- Copy wording idéntico
- PDF layout idéntico

## 15.8 Staleness detection

Downstream module consuming Brand:
- Compara `brand.snapshot.created_at` vs `validation.last_updated` + `profile.last_updated`
- Si Brand snapshot es más viejo que Validation/Profile updates: flag staleness ("brand may be outdated — upstream changed")
- Si Brand > 180 días: flag "considera regenerar"

## 15.9 Storage considerations

Snapshots en Engram + filesystem:

- **Engram**: metadata (~5-10 KB por snapshot). Negligible.
- **Filesystem per snapshot**: típicamente 2-15 MB
  - PDF (~2-8 MB según profile)
  - SVGs (<1 MB total — vector text)
  - Markdown files (<1 MB total)
  - Tokens folder (<1 MB)

10 snapshots típicos: ~20-150 MB total filesystem.

**Policy**:
- Keep all por default
- `/brand:cleanup --keep-last N` borra los snapshots más viejos (excepto v1 — siempre preservado como baseline histórico)
- Recommendation: keep all hasta que el espacio sea un issue

Cleanup NO toca Engram — solo filesystem. Los metadata de snapshots viejos quedan en Engram para `/brand:diff` histórico aunque los files ya no estén.

## 15.10 Tool version compatibility matrix

Sección dentro de `skills/brand/SKILL.md` (orchestrator):

```yaml
brand_module_version: "1.0"
tested_with:
  engram_mcp: [">= X.Y.Z"]
  open_websearch_mcp: [">= X.Y.Z"]
  domain_mcp: [">= 2.0.0"]
  unsplash_free_api: "current (2026-04)"
  pdf_skill: [">= X.Y"]
  claude_design: "web v1 (2026-04 Labs)"

breaking_changes:
  - brand_module: "1.0 → 2.0 (hypothetical)"
    effect: "archetype selection algorithm changed"
    migration: "re-run brand — old snapshots preservan v1 behavior histórico"

  - claude_design: "Labs → GA (when released)"
    effect: "PDF format expectations may change"
    migration: "re-run Handoff Compiler para regenerar PDF en new format"

  - claude_design: "MCP/API released"
    effect: "auto-upload flag available en Handoff"
    migration: "opt-in additive, no migration required"
```

## 15.11 Audit log

Cada action graba en `brand/{slug}/audit-log`:

```
Entries:
  2026-04-20 14:30 — brand:new started (mode: normal)
  2026-04-20 14:35 — Scope Analysis completed (b2b-smb, confidence 0.84)
  2026-04-20 14:42 — Strategy completed (archetype: Sage)
  2026-04-20 14:48 — user confirmed Strategy at Punto 2
  2026-04-20 14:52 — Verbal naming presented, user picked "Auren" at Punto 3
  2026-04-20 14:57 — Logo presented, user picked "B2" at Punto 4
  2026-04-20 15:02 — Coherence gates: 9/9 passed
  2026-04-20 15:05 — Handoff Compiler completed, snapshot v1 created
  2026-04-21 09:15 — user reported: Claude Design upload successful
  2026-04-25 10:00 — brand:extend logo started
  2026-04-25 10:15 — brand:extend logo completed (revision 2)
  2026-04-25 10:30 — brand:snapshot (user-forced) — v2 created
```

Accesible via `/brand:audit {slug}`.

## 15.12 Dónde vive esto en Sprint 0

Versioning + reproducibility se documentan **dentro de `skills/brand/SKILL.md`** (orchestrator) como sección dedicada:
- Snapshot schema completo
- Diff algorithm
- Rollback procedure (incluye backup step)
- Reproducibility guarantees y limitations explícitas
- Storage policies
- Audit log format
- Tool version compatibility matrix

## 15.13 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Full run → snapshot v1 creado con manifest + hashes + audit
2. `/brand:extend logo` → v1.logo revision++ pero NO nuevo snapshot
3. `/brand:snapshot` → fuerza v2
4. Second full run → snapshot v2 auto-creado
5. `/brand:diff v1 v2` → muestra diferencias de todos los deptos
6. `/brand:rollback v1` → restaura correctly, backup del current preservado
7. `/brand:show --list` → lista todos los snapshots con summary
8. Staleness detection triggered cuando Validation updated post-snapshot
9. Cleanup filesystem preserva Engram metadata
10. `/brand:reproduce v1` → produce output con variance esperable, mismas decisiones estratégicas

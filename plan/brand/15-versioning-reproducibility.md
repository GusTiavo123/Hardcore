# 15 — Versioning y Reproducibilidad

## 15.1 Propósito

Definir cómo Brand versiona runs, permite reproducción de runs pasados, y compara versiones. Crítico para:

- User iteration ("quiero ver cómo cambió mi marca entre v1 y v2")
- Rollback (revertir a v1 si v2 es peor)
- Auditoría (entender por qué un run produjo ciertos outputs)
- Debugging (reproducir bugs en runs específicos)

## 15.2 Conceptos de versioning

### Snapshot

Un **snapshot** captura el state completo de un run de Brand exitoso.

- Creado al completar Activation exitosamente
- Inmutable (no se edita después de creado)
- Identificado por `vN` (v1, v2, v3, ...)
- Auto-increment: siguiente run completo crea `v{N+1}`

### Partial re-run (extend)

`/brand:extend {depto}` NO crea nuevo snapshot. En su lugar:

- Actualiza el topic key del dept afectado en Engram
- Incrementa `revision_count` de ese dept
- Files en filesystem se sobrescriben
- Se graba en `audit.extensions[]` del snapshot current

**Por qué no nuevo snapshot**: partial re-runs son iterative tweaks, no runs completos. Crear snapshots por cada extend inflaría storage.

### User-forced new snapshot

User puede forzar creation de nuevo snapshot con `/brand:snapshot` (freezes current state):

- Útil si user hizo varios extends y quiere capturar el combined state
- Incrementa version number

## 15.3 Snapshot schema

Topic key: `brand/{slug}/snapshot/v{N}`

```json
{
  "schema_version": "1.0",
  "snapshot_version": "v1",
  "snapshot_type": "full_run" | "user_forced",
  "created_at": "ISO-8601",
  "completed_at": "ISO-8601",
  "duration_seconds": 1662,
  
  "idea_slug": "auren-compliance",
  "user_slug": "user-slug",
  
  "mode_used": "normal | fast | extend | override",
  "user_overrides": [...],
  
  "input_hashes": {
    "validation_hash": "sha256:...",
    "profile_hash": "sha256:...",
    "idea_text_hash": "sha256:..."
  },
  
  "tool_versions": {
    "brand_module_version": "1.0",
    "stitch_mcp": "0.3.2",
    "image_gen_mcp": "1.0.5",
    "recraft_model": "v4",
    "huemint_api": "v1 (2026-04)",
    "domain_mcp": "2.1.0",
    "pdf_skill": "1.2"
  },
  
  "output_refs": {
    "scope": "brand/{slug}/scope#revision_N",
    "strategy": "brand/{slug}/strategy#revision_N",
    "verbal": "brand/{slug}/verbal#revision_N",
    "visual": "brand/{slug}/visual#revision_N",
    "logo": "brand/{slug}/logo#revision_N",
    "activation": "brand/{slug}/activation#revision_N"
  },
  
  "filesystem_path": "output/auren-compliance/brand/",
  "filesystem_manifest": [
    {"path": "brand-book.pdf", "sha256": "..."},
    {"path": "DESIGN.md", "sha256": "..."},
    {"path": "microsite/index.html", "sha256": "..."},
    {"path": "logo/source/primary.svg", "sha256": "..."}
  ],
  
  "cost_tracking": {
    "image_gen_usd": 0.73,
    "stitch_generations_used": 5,
    "image_gen_count": 18,
    "total_cost_usd": 0.73
  },
  
  "coherence_trace": {
    "gates_executed": [...],
    "escalations": [],
    "final_state": "all_gates_passed"
  },
  
  "audit": {
    "failures_encountered": [],
    "retries_per_tool": {...},
    "extensions": []
  }
}
```

## 15.4 Comando `/brand:diff v1 v2`

Compara dos snapshots y muestra diferencias.

**Ejemplo output**:

```
/brand:diff v1 v2

Comparing snapshot v1 (2026-04-20) ↔ v2 (2026-04-25)

Inputs changed:
  ⚠ validation_hash: diferente (Validation re-run entre snapshots)
  ✓ profile_hash: same
  ✓ idea_text_hash: same

Scope:
  brand_profile: b2b-smb → b2b-smb (same)
  intensity_modifiers.verbal_register: professional-warm → formal-professional (changed)

Strategy:
  archetype: Sage → Sage (same)
  voice_attributes: 
    - added: "formal"
    - removed: "levemente irónico"
  brand_values:
    - added: "Institucional"
    - removed: "Humanidad"

Verbal:
  name: Auren → Auren (same)
  tagline: "Audit the audits." → "Institutional-grade audit simplification." (changed)
  copy assets changed: 14/18

Visual:
  palette_primary: (navy/off-white/amber) → (navy/cream/gold) — accent shifted
  typography: same
  mood_imagery: 6 new images generated (no reuse)

Logo:
  chosen: B2 → C1 (different direction — wordmark → combination)
  variants: regenerated

Activation:
  microsite: regenerated (Stitch re-run)
  brand_book_pdf: regenerated

Cost delta:
  v1: $0.73
  v2: $0.82
  Δ: +$0.09

Overall impression: 
  v2 shifted the brand toward more formal/institutional register.
  Archetype stayed but voice modulation changed significantly.
  Visual: similar palette but more institutional (cream + gold vs off-white + amber).
```

Implementation: parse ambos snapshots, diff per section, produce readable summary.

## 15.5 Comando `/brand:rollback v1`

Revertir a snapshot v1:

**Effect**:
- Topic keys de deptos point back a revisions from v1
- Filesystem: preserve current state pero copy v1 files to fresh location for review
- User confirma antes de sobreescribir current

**Use case**: user hizo v2 y no le gusta, quiere volver a v1.

```
/brand:rollback v1

Current snapshot: v2
Target: v1

This will:
  ✓ Restore Engram topic keys to v1 state
  ✓ Backup current filesystem to output/{slug}/brand-v2-backup/
  ✓ Restore filesystem from v1 state

Continue? [y/n]
```

## 15.6 Comando `/brand:show` con versioning

```
/brand:show                    # Muestra latest snapshot
/brand:show v1                 # Muestra snapshot v1 específicamente
/brand:show --list             # Lista todos los snapshots con summaries
```

Output de `/brand:show --list`:

```
Brand snapshots for "auren-compliance":

v1 (2026-04-20T14:57:42Z)  — full_run, normal mode, $0.73
  Archetype: Sage · Name: Auren · Profile: b2b-smb

v2 (2026-04-25T10:30:15Z)  — full_run, normal mode, $0.82
  Archetype: Sage · Name: Auren · Profile: b2b-smb
  Changes: voice shifted to formal-professional, palette refined

(latest)
```

## 15.7 Reproducibility — exact reproduction

Reproducir exactamente un snapshot:

**Requirements**:
1. Same tool versions accessible (si breaking changes, imposible exacto)
2. Same input hashes (Validation + Profile unchanged — o snapshot registra hash para detect divergence)
3. Same user overrides if any

**Proceso**:

```
/brand:reproduce v1

Reproducing snapshot v1...

Checks:
  ✓ Validation hash matches (no changes)
  ✓ Profile hash matches
  ✓ Stitch MCP version: 0.3.2 (v1) → 0.3.5 (current) — MINOR change, compatible
  ⚠ Recraft model version: v4 (v1) → v4.1 (current) — model updated, may produce different images

Options:
  1. Reproduce with current tools (expect minor variance in generated images)
  2. Abort — need exact tool versions
  3. Produce new snapshot v3 with current tools (not a reproduction, but start from v1 inputs)
```

**Limitación honest**: image generation no es determinístico — mismo prompt puede producir imagen diferente. Logos y mood imagery pueden variar. Otros outputs (Strategy decisions, Verbal copy si deterministic Claude) deberían ser idénticos.

**Por qué registrar input hashes**: detecta cuando inputs cambiaron y un "reproduce" sería reproducing-with-different-inputs (not true reproduction).

## 15.8 Staleness detection

Cuando un módulo downstream consume Brand:

- Compare `brand.snapshot.created_at` vs `validation.last_updated` + `profile.last_updated`
- Si Brand snapshot es más viejo que Validation/Profile updates: flag staleness
- Si Brand snapshot > 180 days: flag "considera regenerar"

Esto NO auto-invalida — Brand sigue siendo el reference. Pero alerta al user que el input context cambió.

## 15.9 Storage considerations

Snapshots persisten en Engram + filesystem:

- **Engram**: metadata del snapshot (~5KB) y revision refs. Negligible.
- **Filesystem**: cada run produce ~50MB (microsite + logos + mood imagery + PDF + sources). 10 snapshots = ~500MB.

**Policy**:
- Keep all snapshots por default
- User puede `/brand:cleanup --keep-last N` para deletar snapshots viejos
- Default recommendation: keep all hasta hit 2GB del idea, después cleanup oldest except v1

**Cleanup NO toca Engram** — solo filesystem. Engram metadata preserved for historical audit.

## 15.10 Tool version compatibility matrix

Track cuáles tool versions son compatibles con cuáles brand_module_version.

Archivo: `skills/brand/references/version-compatibility.md`

```yaml
brand_module_version: "1.0"
tested_with:
  stitch_mcp: [">= 0.3.0", "< 1.0.0"]
  image_gen_mcp: [">= 1.0.0"]
  recraft: ["v4"]
  huemint_api: ["v1"]
  domain_mcp: [">= 2.0.0"]
  pdf_skill: [">= 1.0.0"]

breaking_changes:
  - brand_module: "1.0 → 2.0 (hypothetical)"
    effect: "archetype selection algorithm changed"
    migration: "re-run brand to get new archetype decisions"
```

## 15.11 Audit log

Cada action del user sobre Brand artifacts se graba:

```
brand/{slug}/audit-log

Entries:
  2026-04-20 14:30 — brand:new started (mode: normal)
  2026-04-20 14:57 — brand:new completed, snapshot v1 created
  2026-04-25 10:00 — brand:extend logo started
  2026-04-25 10:15 — brand:extend logo completed, v1.logo.revision_count: 1 → 2
  2026-04-25 10:30 — brand:snapshot (user-forced) — snapshot v2 created
```

Accesible via `/brand:audit {slug}` command.

## 15.12 Reference file a escribir en Sprint 0

`skills/brand/references/versioning.md` con:
- Snapshot schema completo
- Diff algorithm
- Rollback procedure
- Reproducibility guarantees y limitations
- Storage policies

## 15.13 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Full run → snapshot v1 creado correctamente
2. `/brand:extend logo` → v1.logo revision++ pero NO new snapshot
3. `/brand:snapshot` → forces new snapshot v2
4. Second full run → snapshot v2 creado automáticamente
5. `/brand:diff v1 v2` → muestra diferencias accurately
6. `/brand:rollback v1` → restores correctly
7. `/brand:show --list` → lista todos
8. Staleness detection triggered correctly
9. Cleanup deletes old filesystem but preserves Engram metadata

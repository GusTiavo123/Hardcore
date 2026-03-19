# Persistence Contract (shared across all HC departments)

## Relationship with Agent Teams Lite

ATL defines 4 modes: `engram`, `openspec`, `hybrid`, `none`. Idea Validation uses 2 modes: `engram` (default) and `file` (explicit fallback). Our `file` mode is a simplified version of ATL's `openspec` — we write JSON envelopes to `output/` instead of specs/proposals to `openspec/changes/`.

## Mode Resolution

The orchestrator passes `persistence_mode` with one of: `engram | file`.

**Engram is required.** The pipeline cannot run without it. At startup, the orchestrator verifies Engram availability via `mem_search`. If Engram is unavailable, the pipeline halts with an error message asking the user to ensure Engram is running.

`file` mode is only used when the orchestrator explicitly passes it (e.g., for local archival alongside Engram).

## Behavior Per Mode

| Mode | Read from | Write to | Project files | Cross-session |
|------|-----------|----------|---------------|---------------|
| `engram` | Engram (see `engram-convention.md`) | Engram | Never | Yes |
| `file` | JSON files in `output/` directory | JSON files in `output/` directory | Yes | No |

### `engram` Mode (default)

- Persist every department output to Engram using the naming in `engram-convention.md`
- Use valid Engram `type` enums (see Type Mapping in `engram-convention.md`)
- Do NOT use `tags` parameter (it does not exist in Engram's API)
- Read previous department outputs from Engram using the 2-step recovery protocol
- On recovery failure, follow the **Retry Protocol** in `engram-convention.md` (3 attempts with progressively broader queries before declaring failure)
- **Never** write project files
- Cross-session recovery is automatic (Engram persists to SQLite)
- Orchestrator MUST manage session lifecycle: `mem_session_start` → work → `mem_session_summary` → `mem_session_end` (see `engram-convention.md`)

### `file` Mode (fallback)

When Engram is not available, departments can persist to local JSON files:

```
output/{idea-slug}/
├── problem.json
├── market.json
├── competitive.json
├── bizmodel.json
├── risk.json
├── synthesis.json
├── report.json
└── state.yaml
```

Each JSON file contains the full output envelope (see `output-contract.md`).

- Write files ONLY to the `output/` directory at project root
- Read previous department outputs by loading the JSON files
- No cross-session intelligence (no search, no timeline, no progressive disclosure)
- No session lifecycle management (Engram-only feature)

## State Persistence (Orchestrator)

| Mode | Persist State | Recover State |
|------|--------------|---------------|
| `engram` | `mem_save(topic_key: "validation/{slug}/state", type: "config")` | `mem_search("validation/{slug}/state")` → `mem_get_observation(id)` |
| `file` | Write `output/{slug}/state.yaml` | Read `output/{slug}/state.yaml` |

## Common Rules

1. If mode is `engram`, do NOT write any project files. Persist to Engram and return observation IDs.
2. If mode is `file`, write files ONLY to the `output/` directory.
3. **NEVER** auto-create `output/` unless in `file` mode.
4. Default mode is always `engram`. If Engram is unavailable, the pipeline **halts** — do not attempt to continue without persistence.

## Detecting Engram Availability

The orchestrator verifies Engram at pipeline startup by calling `mem_search`. If the tool is unavailable or errors, the pipeline halts with: "Engram is required to run the validation pipeline. Please ensure the Engram MCP server is running."

## Detail Level

The orchestrator may pass `detail_level`: `concise | standard | deep`.

> **CRITICAL**: ALL fields from the department's SKILL.md `data` schema MUST be present in the `data` object regardless of `detail_level`. Detail level NEVER strips `data` fields. Detail level controls ONLY: `executive_summary` length, `detailed_report` inclusion, and `evidence` count. The `data` object is consumed by downstream departments — stripping fields breaks the pipeline.

| Level | `executive_summary` | `detailed_report` | `evidence` | `data` |
|-------|---------------------|--------------------|------------|--------|
| `concise` | 1 sentence | Omitted | Top 3 sources | **Full schema (always)** |
| `standard` | 1-2 sentences | Omitted | All sources | **Full schema (always)** |
| `deep` | 2-3 sentences | Included | All sources + reliability assessment | **Full schema (always)** |

**`data` is never affected by detail level.** Every field defined in the department's SKILL.md data schema must be present with the exact key name and nesting structure. If a field has no value (e.g., no data found), use the schema's default or an explicit empty value (`[]`, `0`, `""`) — never omit the field.

Detail level controls output verbosity but does NOT affect what gets persisted — always persist the full artifact regardless.

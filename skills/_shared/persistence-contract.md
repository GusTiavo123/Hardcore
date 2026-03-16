# Persistence Contract (shared across all HC departments)

## Relationship with Agent Teams Lite

ATL defines 4 modes: `engram`, `openspec`, `hybrid`, `none`. Idea Validation uses 3 modes: `engram`, `file`, `none`. Our `file` mode is a simplified version of ATL's `openspec` — we write JSON envelopes to `output/` instead of specs/proposals to `openspec/changes/`. We don't implement `hybrid` since validation artifacts are either in Engram or local files, not both.

## Mode Resolution

The orchestrator passes `persistence_mode` with one of: `engram | file | none`.

Default resolution (when not explicitly set):
1. If Engram is available → use `engram`
2. Otherwise → use `none`

`file` mode is only used when the orchestrator explicitly passes it.

## Behavior Per Mode

| Mode | Read from | Write to | Project files | Cross-session |
|------|-----------|----------|---------------|---------------|
| `engram` | Engram (see `engram-convention.md`) | Engram | Never | Yes |
| `file` | JSON files in `output/` directory | JSON files in `output/` directory | Yes | No |
| `none` | Orchestrator prompt context | Nowhere (inline only) | Never | No |

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

### `none` Mode

- All department outputs are returned inline to the orchestrator
- **No** persistence of any kind
- The orchestrator passes previous outputs in the prompt context for each subsequent department
- **Warning**: Context window fills up quickly. Only use for quick single-run validations.
- No session lifecycle management

## State Persistence (Orchestrator)

| Mode | Persist State | Recover State |
|------|--------------|---------------|
| `engram` | `mem_save(topic_key: "validation/{slug}/state", type: "config")` | `mem_search("validation/{slug}/state")` → `mem_get_observation(id)` |
| `file` | Write `output/{slug}/state.yaml` | Read `output/{slug}/state.yaml` |
| `none` | Not possible — state lives only in context | Not possible — warn user |

## Common Rules

1. If mode is `none`, do NOT create or modify any project files. Return results inline only.
2. If mode is `engram`, do NOT write any project files. Persist to Engram and return observation IDs.
3. If mode is `file`, write files ONLY to the `output/` directory.
4. **NEVER** auto-create `output/` unless in `file` mode.
5. If unsure which mode to use, default to `engram` if available, otherwise `none`.
6. When falling back to `none`, recommend the user install Engram for better results.

## Detecting Engram Availability

A department detects Engram by checking if `mem_search` is available as an MCP tool. If the tool exists and responds, Engram is available.

## Detail Level

The orchestrator may pass `detail_level`: `concise | standard | deep`.

> **CRITICAL**: The `data` object MUST always contain the FULL schema as defined in each department's SKILL.md, regardless of `detail_level`. Detail level controls ONLY: `executive_summary` length, `detailed_report` inclusion, and `evidence` count. The `data` object is consumed by downstream departments — stripping fields breaks the pipeline.

| Level | `executive_summary` | `detailed_report` | `evidence` |
|-------|---------------------|--------------------|------------|
| `concise` | 1 sentence | Omitted | Top 3 sources |
| `standard` | 1-2 sentences | Omitted | All sources |
| `deep` | 2-3 sentences | Included | All sources + reliability assessment |

**`data`**: Full schema always. Not affected by detail level.

Detail level controls output verbosity but does NOT affect what gets persisted — always persist the full artifact regardless.

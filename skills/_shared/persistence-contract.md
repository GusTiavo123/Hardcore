# Persistence Contract (shared across all HC departments)

## Mode Resolution

The orchestrator passes `persistence_mode` with one of: `engram | file | none`.

Default resolution (when not explicitly set):
1. If Engram is available → use `engram`
2. Otherwise → use `none`

`file` mode is only used when the orchestrator explicitly passes it.

## Behavior Per Mode

| Mode | Read from | Write to | Project files |
|------|-----------|----------|---------------|
| `engram` | Engram (see `engram-convention.md`) | Engram | Never |
| `file` | JSON files in `output/` directory | JSON files in `output/` directory | Yes |
| `none` | Orchestrator prompt context | Nowhere (inline only) | Never |

### `engram` Mode (default)

- Persist every department output to Engram using the naming in `engram-convention.md`
- Read previous department outputs from Engram using the 2-step recovery protocol
- **Never** write project files
- Cross-session recovery is automatic (Engram persists to SQLite)

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

### `none` Mode

- All department outputs are returned inline to the orchestrator
- **No** persistence of any kind
- The orchestrator passes previous outputs in the prompt context for each subsequent department
- **Warning**: Context window fills up quickly. Only use for quick single-run validations.

## State Persistence (Orchestrator)

| Mode | Persist State | Recover State |
|------|--------------|---------------|
| `engram` | `mem_save(topic_key: "validation/{slug}/state")` | `mem_search("validation/{slug}/state")` → `mem_get_observation(id)` |
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

| Level | `executive_summary` | `data` | `evidence` |
|-------|---------------------|--------|------------|
| `concise` | 1 sentence | Key metrics only | Top 3 sources |
| `standard` | 1-2 sentences | Full analysis | All sources |
| `deep` | 2-3 sentences | Full analysis + methodology notes | All sources + reliability assessment |

Detail level controls output verbosity but does NOT affect what gets persisted — always persist the full artifact regardless.

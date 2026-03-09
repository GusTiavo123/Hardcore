# Output Contract (shared across all HC departments)

Every department MUST return this exact JSON envelope. No exceptions.

## Envelope Schema

```json
{
  "status": "ok | warning | blocked | failed",
  "department": "problem | market | competitive | bizmodel | risk | synthesis",
  "executive_summary": "1-2 oraciones decision-grade para el orquestador",
  "score": 0,
  "score_reasoning": "justificación explícita del score asignado",
  "data": {},
  "evidence": [],
  "artifacts": [],
  "flags": [],
  "next_recommended": []
}
```

## Field Definitions

### `status`

| Value | Meaning | Orchestrator Action |
|-------|---------|---------------------|
| `ok` | Department completed successfully | Proceed to next in DAG |
| `warning` | Completed but with caveats | Proceed, show caveats to user |
| `blocked` | Cannot complete — missing input or external blocker | Halt pipeline, escalate to user |
| `failed` | Unrecoverable error | Halt pipeline, show error |

### `department`

Exact string identifying which department produced this output. One of:
`problem`, `market`, `competitive`, `bizmodel`, `risk`, `synthesis`.

### `executive_summary`

**Max 2 sentences.** This is what the orchestrator shows the user between phases. Must be decision-grade — someone reading only this should understand the key finding.

Bad: "Se analizó el mercado."
Good: "Mercado de $5B con 12% crecimiento anual. SOM estimado en $50M con early adopters claros en el segmento tech freelancer."

### `score`

Integer 0-100. See `scoring-convention.md` for rubrics per department and normalization rules.

### `score_reasoning`

**Required.** Explains WHY this specific score was assigned. Must reference evidence. Without this, the score is meaningless.

### `data`

Department-specific structured output. Each department defines its own schema (see individual SKILL.md files). This is the full analysis payload.

### `evidence`

Array of evidence items supporting the analysis:

```json
{
  "source": "https://real-url.com/article",
  "quote": "dato puntual extraído de la fuente",
  "reliability": "high | medium | low"
}
```

**Rules:**
- Every factual claim MUST have at least one evidence entry
- `high`: Official reports, peer-reviewed, government data
- `medium`: Blog posts, forum threads with multiple confirmations, reputable news
- `low`: Single anecdotal source, LLM knowledge without URL, unverified
- If no URL is available, set `source: "llm-knowledge"` and `reliability: "low"`

### `artifacts`

Array of persisted artifacts:

```json
{
  "name": "problem-analysis",
  "store": "engram | file | none",
  "ref": "observation-id or topic_key"
}
```

See `persistence-contract.md` for store behavior and `engram-convention.md` for naming rules.

### `flags`

Array of strings alerting the orchestrator to issues that need attention:

```
"no-reliable-market-data"
"competitor-data-may-be-stale"
"score-below-threshold"
"evidence-mostly-unverified"
```

Flags don't halt the pipeline (use `status: "blocked"` for that) but they ARE shown to the user.

### `next_recommended`

Array of department names that should run next according to the DAG:

```json
["market", "competitive"]
```

The orchestrator uses this as a hint but always validates against the DAG definition.

## Validation Rules

1. `status` MUST be one of the four valid values
2. `department` MUST match the department producing the output
3. `score` MUST be integer 0-100
4. `score_reasoning` MUST NOT be empty
5. `executive_summary` MUST NOT exceed 2 sentences
6. `evidence` SHOULD have at least 3 entries for `status: "ok"`
7. If `status` is `blocked`, `flags` MUST explain why
8. `data` schema is validated by each department's own contract (see SKILL.md)

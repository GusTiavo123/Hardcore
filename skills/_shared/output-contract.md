# Output Contract (shared across all HC departments)

Every department MUST return this exact JSON envelope. No exceptions.

## Relationship with Agent Teams Lite

This contract extends the ATL output contract (`status`, `executive_summary`, `detailed_report`, `artifacts`, `next_recommended`, `risks`) with domain-specific fields for idea validation (`department`, `score`, `score_reasoning`, `data`, `evidence`). The ATL `risks` field is mapped to `flags` in our contract since our `flags` serve as operational alerts to the orchestrator rather than risk descriptions (risk analysis is a dedicated department).

## Schema Strictness

The `data` schema defined in each department's SKILL.md is an **exact contract**:
1. **Field names are exact.** Use the precise key from the schema — do not rename, abbreviate, or synonym-swap (e.g., `churn_rate_monthly` not `monthly_churn_rate`; `estimated_ltv` not `ltv`).
2. **Nesting is exact.** If the schema shows a field at the top level of `data`, it MUST be there. Do not reorganize.
3. **Enum values are exact.** If the schema specifies `"high | medium | low"`, use one of those strings, not free text.
4. **The `data` object always contains the full schema** regardless of `detail_level`. See `persistence-contract.md`.

## Envelope Schema

```json
{
  "status": "ok | warning | blocked | failed",
  "department": "problem | market | competitive | bizmodel | risk | synthesis",
  "executive_summary": "1-2 oraciones decision-grade para el orquestador",
  "detailed_report": "optional — análisis extendido cuando detail_level es deep",
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

### `detailed_report`

**Optional.** Extended analysis for `detail_level: "deep"`. Can be arbitrarily long. The orchestrator does NOT show this by default — only when the user requests more detail on a specific department. If omitted, the orchestrator uses `executive_summary` + `data` for presentation.

### `score`

Integer 0-100. See `scoring-convention.md` for rubrics per department and normalization rules.

### `score_reasoning`

**Required.** Explains WHY this specific score was assigned. Must reference evidence. Without this, the score is meaningless.

### `data`

Department-specific structured output. Each department defines its own schema (see individual SKILL.md files). This is the full analysis payload — downstream departments consume it as machine-readable input.

**The `data` object MUST always contain ALL fields defined in the department's schema, regardless of `detail_level`.** Detail level affects `executive_summary`, `detailed_report`, and `evidence` only — never `data`. Stripping `data` fields breaks downstream departments that depend on them.

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

**Note:** This maps to ATL's `risks` field but serves a different purpose — our flags are operational alerts, not risk descriptions. Risk analysis is handled by the dedicated `hc-risk` department.

### `next_recommended`

Array of department names that should run next according to the DAG:

```json
["market", "competitive"]
```

**Note**: This field is **informational only**. The orchestrator uses its own DAG definition to determine execution order and always validates against it. Departments MUST still set `next_recommended` to their hardcoded downstream value (for documentation and potential future use by external tools), but the orchestrator NEVER relies on this field for routing decisions. If `next_recommended` conflicts with the DAG, the DAG wins.

## Validation Rules

1. `status` MUST be one of the four valid values
2. `department` MUST match the department producing the output
3. `score` MUST be integer 0-100
4. `score_reasoning` MUST NOT be empty
5. `executive_summary` MUST NOT exceed 2 sentences
6. `evidence` SHOULD have at least 3 entries for `status: "ok"`
7. If `status` is `blocked`, `flags` MUST explain why
8. `data` schema is validated by each department's own contract (see SKILL.md)
9. `detailed_report` is OPTIONAL — omit entirely if `detail_level` is not `deep`

## Output Assembly Protocol

Every department MUST cross-reference its `data` object against the SKILL.md schema **before persisting or returning**. This is the enforcement mechanism for Schema Strictness rules 1-4 above.

### The Protocol (mandatory for every department)

1. **After completing all analysis steps** and **before the Persist step**, execute the Output Assembly Checklist defined in your SKILL.md (Step X.5: "Assemble Output").
2. For each field listed in the checklist, verify it is **present** in your `data` object with the **exact key name** from the schema.
3. Verify **nesting is correct** — fields defined at the top level of `data` MUST be at the top level, not nested inside another object. Fields defined inside a sub-object MUST be inside that sub-object.
4. Verify **no field is silently dropped** — information that exists in your analysis (score_reasoning, executive_summary, evidence) but is missing from `data` is invisible to downstream departments.
5. If any field cannot be populated (e.g., no data found), use the schema's default value or an explicit empty value (`[]` for arrays, `0` for numbers, `""` for strings) — never omit the field entirely.

### Why This Exists

Sub-agents reliably produce correct analysis in prose (`score_reasoning`, `executive_summary`) but historically strip structured `data` fields when assembling the output envelope. The Output Assembly Checklist forces an explicit mapping from each analysis step to each `data` field, closing the gap between "analyzed correctly" and "reported correctly."

# Department Protocol (shared across all HC departments)

This file defines the standard procedures that every department follows. Department-specific SKILL.md files reference these procedures instead of repeating them.

## Standard Input

Every department receives from the orchestrator:

```json
{
  "idea": "original idea description in natural language",
  "slug": "kebab-case-slug",
  "persistence_mode": "engram | file",
  "detail_level": "concise | standard | deep"
}
```

If `idea` or `slug` are missing, return `status: "blocked"` with `flags: ["invalid-input"]`.

## Upstream Recovery Procedure

When a department depends on upstream outputs, follow this 2-step protocol:

**If `persistence_mode` is `engram`:**
1. `mem_search(query: "validation/{slug}/{department}", project: "hardcore")` — get the observation ID from the result
2. `mem_get_observation(id: {observation-id})` — get the FULL content

Never use `mem_search` results directly — they are truncated previews.

**If `persistence_mode` is `file`:** Read `output/{slug}/{department}.json`

**If recovery fails** (no results, file missing, or content is empty):
- For **hard dependencies**: return `status: "blocked"` with `flags: ["missing-dependency"]`. Do NOT proceed.
- For **soft dependencies**: proceed with `flags: ["missing-upstream-data"]`. Note limitations and use defaults.

**Retry escalation** (if first search fails):
1. Exact query: `"validation/{slug}/{department}"`
2. Broader query: `"validation {slug} {department}"`
3. Browse all: `mem_search("validation/{slug}/", project: "hardcore")`

See `engram-convention.md` for full naming and recovery details.

## Web Search Protocol

**Search depth**: Review the top **10 results per query**. If a query returns mostly irrelevant results, stop at 5 and move on.

**Language strategy**: Formulate all queries in **English** (largest corpus). If the idea targets a regional market, add **1-2 queries in the local language** targeting regional sources.

**`site:` operator note**: If your search tool does not support `site:` operators, reformulate without them (e.g., `"freelance invoicing" reddit frustrating` instead of using `site:reddit.com`).

**Evidence log** — record each useful source as:
```json
{
  "source": "https://...",
  "quote": "exact relevant quote from the source",
  "reliability": "high | medium | low"
}
```

**Reliability levels:**
- `high`: Official reports, institutional data, verified product pages, peer-reviewed sources, product directory listings with review counts (G2, Capterra)
- `medium`: Forum threads with multiple confirmations, reputable news, VC/analyst posts with cited data
- `low`: Single anecdotal source, unverified claims, blog posts without citations

Record all executed queries in `search_queries_used`.

## Scoring Procedure

After collecting evidence, score each sub-dimension per the rubrics in `scoring-convention.md`:

1. State the **observable evidence** (raw counts, figures, sources)
2. Map to the rubric tier using exact thresholds from `scoring-convention.md`
3. Assign points **within the tier** (thirds rule): bottom if barely qualifies, middle if solidly in range, top if near next tier's threshold
4. **Total score** = sum of all sub-dimensions. Verify arithmetic before proceeding.

**Score consistency rule**: `data.{department}_score` MUST equal the envelope's top-level `score` field. Both represent the same value.

## Output Assembly Protocol

Before persisting or returning, cross-reference every field in your department's `references/data-schema.md`. Verify that:

1. Every `data` field listed in the schema is populated in your `data` object
2. Every envelope field is populated in the output envelope
3. `score` = sum of sub-scores (arithmetic verified)
4. `evidence[]` has >= 3 entries when `status` is `"ok"`

Missing fields break downstream departments. This check is mandatory.

## Persist Protocol

Each department is the **authoritative persister** of its own output. The orchestrator persists only pipeline state.

**If `persistence_mode` is `engram`:**
```
mem_save(
  title: "Validation: {slug} — {department} ({score}/100)",
  topic_key: "validation/{slug}/{department}",
  type: "discovery",
  project: "hardcore",
  scope: "project",
  content: "**What**: {executive_summary} [validation] [{department}] [{industry}]\n\n**Why**: Score {score}/100 — {score_reasoning}\n\n**Where**: validation/{slug}/{department}\n\n**Data**:\n{full data object as JSON string}"
)
```

**If `persistence_mode` is `file`:** Create directory `output/{slug}/` if needed. Write the full output envelope to `output/{slug}/{department}.json`.

After persisting, record the artifact reference:
```json
{
  "name": "{department}-analysis",
  "store": "{persistence_mode}",
  "ref": "validation/{slug}/{department}"
}
```

Always persist the full artifact regardless of `detail_level`.

## Detail Level Rules

`detail_level` controls presentation, never data completeness:

| Field | `concise` | `standard` | `deep` |
|---|---|---|---|
| `executive_summary` | 1 sentence | 1-2 sentences | 2-3 sentences |
| `detailed_report` | Omit | Omit | Include (see SKILL.md for dept-specific content) |
| `data` | **Full schema (always)** | **Full schema (always)** | **Full schema (always)** |
| `evidence` | Top 3 highest-reliability | All sources | All sources with reliability justification |

The `data` object MUST always contain ALL fields defined in the department's schema, regardless of `detail_level`. Stripping `data` fields breaks downstream departments.

## Universal Critical Rules

These apply to every research department (problem, market, competitive, bizmodel, risk):

1. **No fabrication.** Never invent evidence, competitors, market numbers, or complaints. Report what you actually found — even if it's 0.
2. **Arithmetic must be exact.** `{department}_score` MUST equal the sum of sub-scores. Verify before returning.
3. **Web search is mandatory.** If >50% of queries return 0 relevant results, return `status: "failed"` with `flags: ["no-search-results"]`. Do NOT fall back to LLM knowledge.
4. **Evidence minimum.** `evidence[]` must have >= 3 entries when `status` is `"ok"`. Do NOT leave it empty.
5. **Real sources only.** Every competitor, product, or market figure must have a verifiable URL or source citation.

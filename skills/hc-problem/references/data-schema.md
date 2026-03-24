# Problem Validation — Data Schema & Assembly Checklist

## Assembly Checklist

Before persisting or returning, verify every field is populated:

- [ ] `problem_exists` ← Steps 3-4 (see Criteria table below)
- [ ] `demand_stack` ← Step 1 (object with `abstract_need`, `specific_context`, `solution_category`, `key_constraints[]`)
- [ ] `problem_statement` ← Step 1 (refined 1-2 sentence description at the specific_context level, not abstract_need)
- [ ] `target_user` ← Step 1 (specific description of who suffers this problem)
- [ ] `industry` ← Step 1 (industry/domain keyword)
- [ ] `pain_intensity` ← Step 5 (one of: `critical | high | medium | low`)
- [ ] `current_solutions[]` ← Step 6 (array with `solution`, `type`, `satisfaction`)
- [ ] `evidence_summary` ← Step 3 (summary mentioning solution category demand signals)
- [ ] `search_queries_used[]` ← Step 3 (array of actual query strings)
- [ ] `sub_scores` ← Step 4 (object with all 6 sub-score keys)
- [ ] `problem_score` ← Step 4 (integer sum of all 6 sub_scores — verify arithmetic)
- [ ] `evidence[]` ← Step 3 (ENVELOPE field, not inside `data`; >= 3 entries for status "ok")

## `data` Schema

Field names, nesting, and enum values are exact contracts. See `output-contract.md` Schema Strictness.

```json
{
  "problem_exists": true,
  "demand_stack": {
    "abstract_need": "The broad human need being addressed",
    "specific_context": "How the target user experiences the problem",
    "solution_category": "The TYPE of solution the idea proposes",
    "key_constraints": ["specific constraints the idea imposes"]
  },
  "problem_statement": "Refined 1-2 sentence description at the specific_context level",
  "target_user": "Specific description of who suffers this problem",
  "industry": "Industry/domain keyword (e.g., 'contract management', 'freelance invoicing')",
  "pain_intensity": "critical | high | medium | low",
  "current_solutions": [
    {
      "solution": "Name of product or workaround",
      "type": "paid | free | workaround",
      "satisfaction": "high | medium | low"
    }
  ],
  "evidence_summary": "X unique complaints across Y sources. Solution category demand: {summary}. Pattern: ...",
  "search_queries_used": ["actual query string executed"],
  "sub_scores": {
    "complaint_volume": 0,
    "complaint_recency": 0,
    "pain_signals": 0,
    "workaround_evidence": 0,
    "paid_alternatives": 0,
    "solution_category_demand": 0
  },
  "problem_score": 0
}
```

## `problem_exists` Criteria

| Value | Condition |
|---|---|
| `true` | At least 3 unique complaint threads AND (at least 1 paid alternative OR at least 2 distinct workarounds) |
| `false` | Fewer than 3 complaint threads, AND 0 paid alternatives, AND fewer than 2 workarounds |

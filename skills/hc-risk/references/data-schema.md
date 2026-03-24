# Risk Assessment — Data Schema & Assembly Checklist

## Assembly Checklist

Before persisting or returning, verify every field is populated:

- [ ] `risks[]` ← Step 5 (array of risk objects — the FULL register, not just top killers; each with `category`, `risk`, `probability`, `impact`, `mitigation`, `evidence`, `source_department`)
- [ ] `dependencies[]` ← Step 4 (array with `dependency`, `type`, `criticality`, `fallback`, `history`)
- [ ] `overall_risk_level` ← Step 8 (one of: `low | medium | high | critical`)
- [ ] `top_3_killers[]` ← Step 6 (exactly 3 entries, each with `risk`, `why_killer`, `mitigation_feasible`, `early_warning_signal`)
- [ ] `search_queries_used[]` ← Steps 1-4 (ALL queries across all steps)
- [ ] `sub_scores` ← Step 7 (object with all 4 sub-score keys)
- [ ] `risk_score` ← Step 7 (integer sum of 4 sub_scores — verify arithmetic; remember INVERTED: higher = safer)
- [ ] `evidence[]` ← ENVELOPE field (>= 3 entries for status "ok", DO NOT leave empty)

## `data` Schema

Field names, nesting, and enum values are exact contracts. See `output-contract.md` Schema Strictness.

```json
{
  "risks": [
    {
      "category": "execution | regulatory | market | timing | dependency | financial",
      "risk": "Specific description",
      "probability": "high | medium | low",
      "impact": "critical | high | medium | low",
      "mitigation": "Specific action to reduce risk",
      "evidence": "Data point or source that surfaced this risk",
      "source_department": "problem | market | competitive | own-research"
    }
  ],
  "dependencies": [
    {
      "dependency": "What is depended upon",
      "type": "platform | channel | technology | regulatory | customer",
      "criticality": "high | medium | low",
      "fallback": "Alternative if dependency fails",
      "history": "Has this dependency been restricted/broken before?"
    }
  ],
  "overall_risk_level": "low | medium | high | critical",
  "top_3_killers": [
    {
      "risk": "Description",
      "why_killer": "Why this could kill the idea, not just slow it",
      "mitigation_feasible": true,
      "early_warning_signal": "What to watch for"
    }
  ],
  "search_queries_used": ["actual query string executed"],
  "sub_scores": {
    "execution_feasibility": 0,
    "regulatory_legal": 0,
    "market_timing": 0,
    "dependency_concentration": 0
  },
  "risk_score": 0
}
```

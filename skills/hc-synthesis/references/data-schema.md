# GO/NO-GO Synthesis — Data Schema & Assembly Checklist

## Assembly Checklist

Before persisting or returning, verify every field is populated:

- [ ] `verdict` ← Steps 2-4 (one of: `GO | NO-GO | PIVOT`)
- [ ] `confidence` ← Step 5 (one of: `high | medium | low`)
- [ ] `weighted_score` ← Step 1 (decimal, rounded to 1 decimal place)
- [ ] `score_breakdown` ← Step 1 (object with `problem`, `market`, `competitive`, `bizmodel`, `risk` — each with `score`, `weight`, `contribution`)
- [ ] `knockouts_triggered[]` ← Step 2 (array with `rule`, `value`, `threshold`, `department` — empty `[]` if none)
- [ ] `executive_summary` ← Step 6 (2-3 sentence verdict summary for the founder)
- [ ] `key_strengths[]` ← Step 6 (specific strengths with evidence references)
- [ ] `key_concerns[]` ← Step 6 (specific concerns with evidence references)
- [ ] `critical_assumptions[]` ← Step 7 (assumptions from BizModel, Market flags, Problem flags)
- [ ] `pivot_suggestions[]` ← Step 8 (each with `direction`, `addresses`, `revalidation_idea` — empty `[]` if not PIVOT)
- [ ] `next_steps[]` ← Step 9 (each with `action`, `priority`, `timeframe`, `rationale`)
- [ ] `validation_experiments[]` ← Step 10 (each with `experiment`, `success_metric`, `effort`, `what_it_validates` — empty `[]` for NO-GO)
- [ ] `department_flags` ← Step 11 (object with `problem`, `market`, `competitive`, `bizmodel`, `risk` — each an array of flag strings)
- [ ] `evidence[]` ← ENVELOPE field (Synthesis is exempt from >= 3 requirement — may be empty `[]`)

## `data` Schema

Field names, nesting, and enum values are exact contracts. See `output-contract.md` Schema Strictness.

```json
{
  "verdict": "GO | NO-GO | PIVOT",
  "confidence": "high | medium | low",
  "weighted_score": 0.0,
  "score_breakdown": {
    "problem": {"score": 0, "weight": 0.30, "contribution": 0.0},
    "market": {"score": 0, "weight": 0.25, "contribution": 0.0},
    "competitive": {"score": 0, "weight": 0.15, "contribution": 0.0},
    "bizmodel": {"score": 0, "weight": 0.20, "contribution": 0.0},
    "risk": {"score": 0, "weight": 0.10, "contribution": 0.0}
  },
  "knockouts_triggered": [
    {
      "rule": "Name of knockout rule",
      "value": 0,
      "threshold": 0,
      "department": "which department"
    }
  ],
  "executive_summary": "2-3 sentence verdict summary for the founder",
  "key_strengths": ["Specific strength with evidence reference"],
  "key_concerns": ["Specific concern with evidence reference"],
  "critical_assumptions": ["Assumption with source"],
  "pivot_suggestions": [
    {
      "direction": "Description of pivot direction",
      "addresses": "Which blocking score/issue this addresses",
      "revalidation_idea": "How to phrase this as a new idea for re-validation"
    }
  ],
  "next_steps": [
    {
      "action": "Specific actionable step",
      "priority": "high | medium | low",
      "timeframe": "1-2 weeks | 1 month | etc.",
      "rationale": "Why this step matters"
    }
  ],
  "validation_experiments": [
    {
      "experiment": "What to do",
      "success_metric": "Quantified threshold",
      "effort": "low | medium | high",
      "what_it_validates": "Which assumption or score"
    }
  ],
  "department_flags": {
    "problem": [],
    "market": [],
    "competitive": [],
    "bizmodel": [],
    "risk": []
  }
}
```

# Business Model — Data Schema & Assembly Checklist

## Assembly Checklist

Before persisting or returning, verify every field is populated:

**CRITICAL NESTING RULES**: `sensitivity_analysis` and `assumptions[]` are **TOP-LEVEL keys** in `data`, NOT nested inside `unit_economics`. Use **exact field names**: `estimated_ltv` not `ltv`, `churn_rate_monthly` not `monthly_churn_rate`, `estimated_cac` not `cac`.

- [ ] `recommended_model` ← Step 1 (one of: `subscription | usage-based | marketplace | one-time | freemium | hybrid`)
- [ ] `model_justification` ← Step 1 (why this model, based on competitive evidence)
- [ ] `pricing_suggestion` ← Step 2 (object with `price_point`, `billing`, `currency`, `justification`)
- [ ] `unit_economics` ← Step 4 (object — see sub-fields below)
- [ ] `unit_economics.arpu_monthly` ← Step 4 (numeric)
- [ ] `unit_economics.churn_rate_monthly` ← Step 4 (decimal, e.g., 0.05)
- [ ] `unit_economics.churn_source` ← Step 3 (benchmark source and segment)
- [ ] `unit_economics.gross_margin` ← Step 4 (decimal, e.g., 0.80)
- [ ] `unit_economics.margin_source` ← Step 3 (benchmark source)
- [ ] `unit_economics.estimated_ltv` ← Step 4 (numeric)
- [ ] `unit_economics.estimated_cac` ← Step 4 (numeric)
- [ ] `unit_economics.cac_source` ← Step 3 (benchmark source and channel assumption)
- [ ] `unit_economics.ltv_cac_ratio` ← Step 4 (decimal ratio)
- [ ] `unit_economics.payback_months` ← Step 4 (decimal months)
- [ ] `sensitivity_analysis` ← Step 5 (**TOP-LEVEL** in `data`, NOT inside `unit_economics`)
- [ ] `sensitivity_analysis.cac_plus_20` ← (object with `ltv_cac_ratio`, `payback_months`, `viable`, `assessment`)
- [ ] `sensitivity_analysis.churn_plus_20` ← (object with `ltv_cac_ratio`, `payback_months`, `viable`, `assessment`)
- [ ] `sensitivity_analysis.price_minus_20` ← (object with `ltv_cac_ratio`, `payback_months`, `viable`, `assessment`)
- [ ] `model_precedents[]` ← Step 6 (array with `company`, `model`, `segment`, `evidence`, `source`)
- [ ] `assumptions[]` ← Steps 3-4 (**TOP-LEVEL** in `data`; each as explicit string)
- [ ] `search_queries_used[]` ← Step 3 (array of actual query strings)
- [ ] `sub_scores` ← Step 7 (object with all 4 sub-score keys)
- [ ] `bizmodel_score` ← Step 7 (integer sum of 4 sub_scores — verify arithmetic)
- [ ] `evidence[]` ← ENVELOPE field (>= 3 entries for status "ok", DO NOT leave empty)

## `data` Schema

Field names, nesting, and enum values are exact contracts. See `output-contract.md` Schema Strictness.

```json
{
  "recommended_model": "subscription | usage-based | marketplace | one-time | freemium | hybrid",
  "model_justification": "Why this model, based on competitive evidence and market norms",
  "pricing_suggestion": {
    "price_point": 0,
    "billing": "monthly | annually | per-use",
    "currency": "USD",
    "justification": "How price relates to competitive benchmark and pain intensity"
  },
  "unit_economics": {
    "arpu_monthly": 0,
    "churn_rate_monthly": 0.0,
    "churn_source": "Benchmark source and segment",
    "gross_margin": 0.0,
    "margin_source": "Benchmark source",
    "estimated_ltv": 0,
    "estimated_cac": 0,
    "cac_source": "Benchmark source and channel assumption",
    "ltv_cac_ratio": 0.0,
    "payback_months": 0.0
  },
  "sensitivity_analysis": {
    "cac_plus_20": {
      "ltv_cac_ratio": 0.0,
      "payback_months": 0.0,
      "viable": true,
      "assessment": "One-sentence viability assessment"
    },
    "churn_plus_20": {
      "ltv_cac_ratio": 0.0,
      "payback_months": 0.0,
      "viable": true,
      "assessment": "One-sentence viability assessment"
    },
    "price_minus_20": {
      "ltv_cac_ratio": 0.0,
      "payback_months": 0.0,
      "viable": true,
      "assessment": "One-sentence viability assessment"
    }
  },
  "model_precedents": [
    {
      "company": "Company name",
      "model": "Same revenue model",
      "segment": "Similar customer segment",
      "evidence": "Funding, profitability, or scale signal",
      "source": "URL"
    }
  ],
  "assumptions": ["Each assumption stated explicitly with its source or basis"],
  "search_queries_used": ["actual query string executed"],
  "sub_scores": {
    "ltv_cac_ratio": 0,
    "revenue_model_validation": 0,
    "payback_period": 0,
    "pricing_power": 0
  },
  "bizmodel_score": 0
}
```

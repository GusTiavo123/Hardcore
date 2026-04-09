# Competitive Intelligence — Data Schema & Assembly Checklist

## Assembly Checklist

Before persisting or returning, verify every field is populated:

- [ ] `direct_competitors[]` ← Steps 1-2 (each with `name`, `url`, `pricing` {`model`, `range`, `detail`}, `strengths[]`, `weaknesses[]`, `traction` {`funding`, `employees`, `reviews`, `source`}, `moat_type`, `vulnerability_signals[]`, `estimated_size`)
- [ ] `indirect_competitors[]` ← Step 1 (each with `name`, `url`, `approach`, `relevance`)
- [ ] `adjacent_competitors[]` ← Step 1 (each with `name`, `url`, `current_focus`, `pivot_threat`, `evidence`)
- [ ] `failed_competitors[]` ← Step 4 (each with `name`, `url`, `year_failed`, `reason_failed`, `source`)
- [ ] `market_gaps[]` ← Step 3 (each with `gap`, `mention_count`, `sources[]`, `aligns_with_idea`, `alignment_strength`)
- [ ] `pricing_benchmark` ← Step 4 (object with `low`, `mid`, `high`, `currency`, `model`, `free_alternatives_exist`, `competitors_with_pricing`)
- [ ] `search_queries_used[]` ← Step 1 (array of actual query strings)
- [ ] `sub_scores` ← Step 5 (object with all 4 sub-score keys)
- [ ] `competitive_score` ← Step 5 (integer sum of 4 sub_scores — verify arithmetic)
- [ ] `evidence[]` ← ENVELOPE field (>= 3 entries for status "ok")

## `data` Schema

Field names, nesting, and enum values are exact contracts. See `output-contract.md` Schema Strictness.

```json
{
  "direct_competitors": [
    {
      "name": "Real Company Name",
      "url": "https://...",
      "pricing": {
        "model": "subscription | one-time | usage | freemium",
        "range": "$X-$Y/mo",
        "detail": "Tier breakdown if available"
      },
      "strengths": ["from positive reviews"],
      "weaknesses": ["from negative reviews"],
      "traction": {
        "funding": "$XM Series Y",
        "employees": "estimated count",
        "reviews": "count on G2/Capterra",
        "source": "crunchbase | linkedin | g2"
      },
      "moat_type": "structural | operational | soft | none",
      "vulnerability_signals": ["declining reviews", "layoffs", "acquired by unfocused parent"],
      "estimated_size": "Funding stage, estimated ARR"
    }
  ],
  "indirect_competitors": [
    {
      "name": "...",
      "url": "https://...",
      "approach": "How they solve the problem differently",
      "relevance": "Why they matter to this analysis"
    }
  ],
  "adjacent_competitors": [
    {
      "name": "...",
      "url": "https://...",
      "current_focus": "What they do now",
      "pivot_threat": "Why they could move into this space",
      "evidence": "Signal suggesting they might pivot"
    }
  ],
  "failed_competitors": [
    {
      "name": "...",
      "url": "https://... (if available)",
      "year_failed": 2023,
      "reason_failed": "Root cause from post-mortem or analysis",
      "source": "URL to post-mortem or article"
    }
  ],
  "market_gaps": [
    {
      "gap": "Description of the unmet need",
      "mention_count": 0,
      "sources": ["G2 reviews", "Reddit threads"],
      "aligns_with_idea": true,
      "alignment_strength": "full | partial | none"
    }
  ],
  "pricing_benchmark": {
    "low": 0,
    "mid": 0,
    "high": 0,
    "currency": "USD/mo",
    "model": "per-seat | flat | usage",
    "free_alternatives_exist": true,
    "competitors_with_pricing": 0
  },
  "search_queries_used": ["actual query string executed"],
  "sub_scores": {
    "market_validation": 0,
    "wedge_opportunity": 0,
    "incumbent_defensibility": 0,
    "market_intelligence": 0
  },
  "competitive_score": 0
}
```

## `alignment_strength` Field

The `alignment_strength` field in `market_gaps[]` is optional but recommended. See `glossary.md` for scoring rules on partial vs full alignment. When omitted, gaps with `aligns_with_idea: true` are treated as full alignment (1.0).

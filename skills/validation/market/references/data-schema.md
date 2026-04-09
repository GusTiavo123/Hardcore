# Market Sizing — Data Schema & Assembly Checklist

## Assembly Checklist

Before persisting or returning, verify every field is populated:

- [ ] `tam` ← Step 3 (object with `value`, `currency`, `source`, `methodology`)
- [ ] `tam.value` ← numeric TAM value
- [ ] `tam.currency` ← e.g., `"USD"`
- [ ] `tam.source` ← source name and year (NOT empty)
- [ ] `tam.methodology` ← one of: `top-down-institutional | top-down-estimated | bottom-up | analog`
- [ ] `sam` ← Step 3 (object with `value`, `currency`, `source`, `methodology`)
- [ ] `sam.value` ← numeric SAM value
- [ ] `sam.currency` ← e.g., `"USD"`
- [ ] `sam.source` ← source or calculation basis (NOT empty)
- [ ] `sam.methodology` ← what filters applied to TAM
- [ ] `som` ← Step 3 (object with `value`, `currency`, `source`, `methodology`)
- [ ] `som.value` ← numeric SOM value (most conservative estimate)
- [ ] `som.currency` ← e.g., `"USD"`
- [ ] `som.source` ← estimation basis (NOT empty)
- [ ] `som.methodology` ← how SOM derived from SAM
- [ ] `growth_rate` ← Step 4 (formatted string)
- [ ] `growth_source` ← Step 4 (source name, NOT empty)
- [ ] `market_stage` ← Step 6 (one of: `emerging | growing | mature | declining`)
- [ ] `early_adopters[]` ← Step 5 (array with `segment`, `estimated_size`, `evidence_of_spending`, `reachable_channels[]`)
- [ ] `search_queries_used[]` ← Step 2 (array of actual query strings)
- [ ] `sub_scores` ← Step 7 (object with all 4 sub-score keys)
- [ ] `market_score` ← Step 7 (integer sum of 4 sub_scores — verify arithmetic)
- [ ] `evidence[]` ← ENVELOPE field (>= 3 entries for status "ok", DO NOT leave empty)

## `data` Schema

Field names, nesting, and enum values are exact contracts. See `output-contract.md` Schema Strictness.

```json
{
  "tam": {
    "value": 0,
    "currency": "USD",
    "source": "Source name and year",
    "methodology": "How TAM was derived"
  },
  "sam": {
    "value": 0,
    "currency": "USD",
    "source": "Source or calculation basis",
    "methodology": "What filters were applied to TAM"
  },
  "som": {
    "value": 0,
    "currency": "USD",
    "source": "Estimation basis",
    "methodology": "How SOM was derived from SAM"
  },
  "growth_rate": "X% CAGR (YYYY-YYYY)",
  "growth_source": "Source name",
  "market_stage": "emerging | growing | mature | declining",
  "early_adopters": [
    {
      "segment": "Specific label for the group",
      "estimated_size": 0,
      "evidence_of_spending": "What adjacent products they pay for",
      "reachable_channels": [
        {"name": "channel name", "type": "subreddit | slack | conference | newsletter | other", "members": 0}
      ]
    }
  ],
  "search_queries_used": ["actual query string executed"],
  "sub_scores": {
    "data_availability": 0,
    "market_scale": 0,
    "growth_trajectory": 0,
    "early_adopter_identifiability": 0
  },
  "market_score": 0
}
```

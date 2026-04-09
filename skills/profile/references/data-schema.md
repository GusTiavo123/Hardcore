# Profile Data Schema

This defines the exact structure of the `data` object inside the Profile Envelope. Every field listed here must be present in the output (populated or explicitly `null`).

---

## Assembly Checklist

Before persisting or returning, verify every field:

- `identity` ← object with `name`, `location`, `languages`, `professional_background`
- `identity.location` ← object with `city`, `country`, `timezone`, `willing_to_relocate`, `target_geographies[]`
- `identity.languages[]` ← array with `language`, `level`
- `identity.professional_background` ← object with `current_role`, `years_experience`, `industries_worked[]`, `notable_employers[]`, `education_highlight`
- `skills` ← object with `technical[]`, `business[]`, `domain_expertise[]`
- `skills.technical[]` ← each with `skill`, `level`, `evidence`
- `skills.business[]` ← each with `skill`, `level`, `evidence`
- `skills.domain_expertise[]` ← each with `domain`, `depth`, `years`, `insider_knowledge`
- `resources` ← object with `capital`, `time`, `team`, `infrastructure`
- `resources.capital` ← object with `available`, `currency`, `source`, `runway_months`, `willing_to_fundraise`, `fundraising_experience`
- `resources.time` ← object with `commitment`, `hours_per_week`, `deadline`
- `resources.team` ← object with `solo`, `cofounders[]`, `contractors_available`, `hiring_budget_monthly`
- `resources.team.cofounders[]` ← each with `name`, `role`, `skills[]`, `commitment`
- `resources.infrastructure` ← object with `existing_tech[]`, `existing_products[]`, `existing_data[]`
- `constraints` ← object with `hard_nos[]`, `regulatory_limits[]`, `geographic_limits[]`, `ethical_limits[]`, `time_limits`, `capital_limits`, `risk_tolerance`, `risk_tolerance_evidence`
- `constraints.time_limits` ← object with `max_months_to_revenue`, `max_months_to_mvp`
- `constraints.capital_limits` ← object with `max_initial_investment`, `max_monthly_burn`
- `network` ← object with `audience[]`, `professional_network[]`, `communities[]`, `distribution_channels[]`
- `network.audience[]` ← each with `platform`, `followers`, `engagement`, `niche`
- `network.professional_network[]` ← each with `description`, `sector`, `strength`, `activatable`
- `network.communities[]` ← each with `name`, `role`, `size`
- `network.distribution_channels[]` ← each with `channel`, `owned`, `estimated_reach`
- `motivation` ← object with `primary_goal`, `success_definition`, `values[]`, `working_style`
- `motivation.working_style` ← object with `preference`, `decision_speed`, `orientation`, `comfort_with_ambiguity`
- `advantages` ← object with `proprietary_insights[]`, `unique_access[]`, `credibility_capital[]`, `timing_advantages[]`, `regulatory_knowledge[]`, `existing_ip[]`
- `previous_ventures[]` ← each with `name`, `outcome`, `duration_months`, `revenue_reached`, `key_lesson`, `assets_remaining[]`, `mistakes_to_avoid[]`
- `opportunity_cost` ← object with `current_income`, `best_alternative`, `switching_cost`, `personal_obligations[]`
- `meta_signals` ← object with `market_proximity`, `execution_readiness`, `blind_spots_detected[]`, `capital_efficiency`

---

## `data` Schema

```json
{
  "identity": {
    "name": "string",
    "location": {
      "city": "string | null",
      "country": "string | null",
      "timezone": "string | null",
      "willing_to_relocate": "boolean | null",
      "target_geographies": ["string"]
    },
    "languages": [
      {
        "language": "string",
        "level": "native | fluent | conversational | basic"
      }
    ],
    "professional_background": {
      "current_role": "string | null",
      "years_experience": "number | null",
      "industries_worked": ["string"],
      "notable_employers": ["string"],
      "education_highlight": "string | null"
    }
  },

  "skills": {
    "technical": [
      {
        "skill": "string",
        "level": "expert | proficient | familiar",
        "evidence": "string"
      }
    ],
    "business": [
      {
        "skill": "string",
        "level": "expert | proficient | familiar",
        "evidence": "string"
      }
    ],
    "domain_expertise": [
      {
        "domain": "string",
        "depth": "operator | practitioner | observer",
        "years": "number",
        "insider_knowledge": "string | null"
      }
    ]
  },

  "resources": {
    "capital": {
      "available": "number | null",
      "currency": "USD",
      "source": "savings | revenue | pre-seed | seed | external | null",
      "runway_months": "number | null",
      "willing_to_fundraise": "boolean | null",
      "fundraising_experience": "none | attempted | successful | null"
    },
    "time": {
      "commitment": "full-time | part-time | side-project | exploring | null",
      "hours_per_week": "number | null",
      "deadline": "string | null"
    },
    "team": {
      "solo": "boolean",
      "cofounders": [
        {
          "name": "string",
          "role": "string",
          "skills": ["string"],
          "commitment": "full-time | part-time"
        }
      ],
      "contractors_available": "boolean | null",
      "hiring_budget_monthly": "number | null"
    },
    "infrastructure": {
      "existing_tech": ["string"],
      "existing_products": ["string"],
      "existing_data": ["string"]
    }
  },

  "constraints": {
    "hard_nos": ["string"],
    "regulatory_limits": ["string"],
    "geographic_limits": ["string"],
    "ethical_limits": ["string"],
    "time_limits": {
      "max_months_to_revenue": "number | null",
      "max_months_to_mvp": "number | null"
    },
    "capital_limits": {
      "max_initial_investment": "number | null",
      "max_monthly_burn": "number | null"
    },
    "risk_tolerance": "conservative | moderate | aggressive | null",
    "risk_tolerance_evidence": "string | null"
  },

  "network": {
    "audience": [
      {
        "platform": "string",
        "followers": "number",
        "engagement": "high | medium | low",
        "niche": "string"
      }
    ],
    "professional_network": [
      {
        "description": "string",
        "sector": "string",
        "strength": "strong | acquaintance",
        "activatable": "boolean"
      }
    ],
    "communities": [
      {
        "name": "string",
        "role": "leader | active-member | lurker",
        "size": "number | null"
      }
    ],
    "distribution_channels": [
      {
        "channel": "string",
        "owned": "boolean",
        "estimated_reach": "number | null"
      }
    ]
  },

  "motivation": {
    "primary_goal": "financial-freedom | impact | build-something | escape-job | portfolio | learning | null",
    "success_definition": "string | null",
    "values": ["string"],
    "working_style": {
      "preference": "solo | small-team | team-builder | null",
      "decision_speed": "fast-iterate | deliberate | research-heavy | null",
      "orientation": "technical | business | balanced | null",
      "comfort_with_ambiguity": "high | medium | low | null"
    }
  },

  "advantages": {
    "proprietary_insights": ["string"],
    "unique_access": ["string"],
    "credibility_capital": ["string"],
    "timing_advantages": ["string"],
    "regulatory_knowledge": ["string"],
    "existing_ip": ["string"]
  },

  "previous_ventures": [
    {
      "name": "string",
      "outcome": "active | sold | shut-down | pivoted | side-project",
      "duration_months": "number | null",
      "revenue_reached": "number | null",
      "key_lesson": "string",
      "assets_remaining": ["string"],
      "mistakes_to_avoid": ["string"]
    }
  ],

  "opportunity_cost": {
    "current_income": "number | null",
    "best_alternative": "string | null",
    "switching_cost": "string | null",
    "personal_obligations": ["string"]
  },

  "meta_signals": {
    "market_proximity": "number | null",
    "execution_readiness": "ready | preparing | exploring | null",
    "blind_spots_detected": ["string"],
    "capital_efficiency": "lean | moderate | big-build | null"
  }
}
```

---

## Tier Classification

### Tier 1 — Core (always captured)
- `identity`
- `skills`
- `resources`
- `constraints`

### Tier 2 — Extended (captured when relevant)
- `network`
- `motivation`
- `advantages`
- `previous_ventures`
- `opportunity_cost`

### Tier 3 — Meta (inferred, not asked)
- `meta_signals`

---

## Field Semantics

### Boundary: `skills.technical` / `skills.business` vs `skills.domain_expertise`

These three arrays capture fundamentally different things:

- **`technical`** and **`business`**: WHAT you can DO — capabilities, tools, methodologies. These are transferable across industries. Examples: "Python", "UX Design", "Sales", "Financial Analysis".
- **`domain_expertise`**: WHERE you did it — industry or vertical knowledge gained from working IN that industry. These are not transferable. Examples: "Fintech", "Logistics", "E-commerce", "Healthcare".

**"Software Development" is a skill, not a domain.** "Fintech" is a domain. A developer with 5 years at a fintech has `technical: [{skill: "Python", ...}]` AND `domain_expertise: [{domain: "Fintech", ...}]`. The technical skill goes in `technical`, the industry knowledge goes in `domain_expertise`.

If you cannot name a specific industry or vertical, the expertise belongs in `technical` or `business`, not in `domain_expertise`.

### `skills.domain_expertise[].depth`

This is the most impactful classification in the entire profile. The three levels represent fundamentally different types of knowledge:

| Level | Meaning | Example | Knowledge type |
|---|---|---|---|
| `operator` | Ran a business in this domain | "Tuve una fintech en Colombia por 3 anos" | Unit economics, customer behavior, supplier dynamics, regulatory landmines — learned by operating |
| `practitioner` | Worked in the domain as employee | "Fui dev en un banco 5 anos" | Tools, processes, internal pain points, workflow inefficiencies — learned by working |
| `observer` | Studied it or is a consumer | "Leo mucho sobre crypto, uso DeFi" | User-side experience, surface trends, public information — learned by observing |

An **operator** with 2 years knows more actionable things than an **observer** with 10 years. This distinction directly impacts the Founder-Idea Fit `domain_expertise_match` dimension.

### `resources.capital.source`

| Value | Meaning | Implication |
|---|---|---|
| `savings` | Personal savings | Conservative deployment, loss aversion |
| `revenue` | From existing business/product | Can reinvest, less pressure |
| `pre-seed` | Friends/family/angels committed | External accountability, faster deployment |
| `seed` | Institutional seed funding | Expectations, milestones, board |
| `external` | Grants, prizes, other non-dilutive | No equity cost, often restricted use |

### `constraints.risk_tolerance`

Self-reported but calibrated during interview with a scenario question (see `interview-guide.md`). The `risk_tolerance_evidence` field captures WHY they assess themselves this way — this is often more informative than the label itself.

### `meta_signals.market_proximity`

| Value | Meaning | Impact on validation |
|---|---|---|
| 0 | Founder IS the target customer | Strongest signal — they live the pain daily |
| 1 | Knows target customers personally | Strong — can validate directly, has empathy |
| 2 | Can reach customers through network | Moderate — can access but doesn't live it |
| 3 | Cold outreach required | Weak — highest customer discovery risk |

---

## Null Handling

The profile uses two empty representations with distinct semantics:

- **`null`**: Used for **scalar fields** only. Means "unknown / not addressed."
- **`[]`**: Used for **array fields** only. Means "no entries."

**Array fields MUST always be `[]`, never `null`.** This includes: `skills.technical`, `skills.business`, `skills.domain_expertise`, `hard_nos`, `audience`, `professional_network`, `communities`, `distribution_channels`, `values`, `proprietary_insights`, `previous_ventures`, `personal_obligations`, and all other array-typed fields.

This rule ensures downstream modules can always iterate over arrays without null checks. It applies across all modes (quick, guided, update).

The profile is designed for progressive population:

- **Quick mode**: Most extended scalars will be `null`, arrays will be `[]`
- **Guided mode**: Core fields should be non-null; extended depends on interview depth
- **After multiple updates**: Most fields populated

Downstream modules MUST handle `null` gracefully on scalar fields. A `null` scalar means "unknown", not "absent".

---

## State Schema

The state object (persisted separately as `profile/{user-slug}/state`) tracks metadata:

```json
{
  "profile_version": "1.0",
  "user_slug": "string",
  "created": "ISO-8601",
  "last_updated": "ISO-8601",
  "revision_count": 1,
  "completeness": {
    "core": 0.0,
    "extended": 0.0,
    "meta": 0.0,
    "overall": 0.0
  },
  "tier_gaps": ["field.path"],
  "snapshots": [
    {
      "validation_slug": "string",
      "snapshot_date": "ISO-8601",
      "profile_revision": 1
    }
  ],
  "staleness": {
    "days_since_update": 0,
    "stale": false,
    "dimensions_likely_stale": ["field.path"]
  }
}
```

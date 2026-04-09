# Profile Contract (shared across all HC modules)

This document defines how any module in the Hardcore ecosystem consumes founder profile data. Read this before accessing profile information.

---

## Availability

A founder profile may or may not exist. **Every module MUST handle the absence of a profile gracefully.** When no profile exists, modules operate in "generic mode" — identical to behavior before the profile module was introduced.

---

## Profile Namespace in Engram

```
profile/{user-slug}/core                          # Main profile (always exists if profile exists)
profile/{user-slug}/extended                       # Extended dimensions (may not exist)
profile/{user-slug}/state                          # Metadata: version, completeness, staleness
profile/{user-slug}/snapshot/{validation-slug}     # Frozen at validation time
```

All profile artifacts use:
- `type: "config"`
- `project: "hardcore"`
- `scope: "project"`

Snapshots use `type: "discovery"`.

---

## Retrieval Protocol

### Finding the profile

```
1. mem_search(query: "Founder Profile core", project: "hardcore")
   → Look for the most recent result with topic_key matching "profile/*/core"

2. mem_get_observation(id: {id from step 1})
   → Full content including the **Data** section

3. Parse the **Data** section as JSON
   → This is the structured profile data matching the schema in
     skills/profile/references/data-schema.md
```

### Finding extended profile (optional)

```
1. mem_search(query: "Founder Profile extended", project: "hardcore")
2. mem_get_observation(id: {id from step 1})
3. Parse **Data** section
```

### Finding profile state (optional)

```
1. mem_search(query: "Founder Profile state", project: "hardcore")
2. mem_get_observation(id: {id from step 1})
3. Parse **Data** section for completeness, staleness, snapshots
```

---

## Founder Context Object

The orchestrator extracts a `founder_context` object from the profile and passes it to each department as part of the sub-agent input. This object is a curated projection of the full profile, containing only fields relevant to validation departments:

```json
{
  "founder_context": {
    "name": "string",
    "domain_expertise": [
      {
        "domain": "string",
        "depth": "operator | practitioner | observer",
        "years": "number",
        "insider_knowledge": "string | null"
      }
    ],
    "geography": {
      "country": "string",
      "target_geographies": ["string"]
    },
    "capital": {
      "available": "number | null",
      "currency": "USD",
      "runway_months": "number | null"
    },
    "time_commitment": "full-time | part-time | side-project | exploring | null",
    "team": {
      "solo": "boolean",
      "cofounder_skills": ["string"],
      "hiring_budget_monthly": "number | null"
    },
    "network": {
      "audience": [
        {
          "platform": "string",
          "followers": "number",
          "niche": "string"
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
    "hard_nos": ["string"],
    "risk_tolerance": "conservative | moderate | aggressive | null",
    "skills_summary": {
      "technical": ["string — skill (level)"],
      "business": ["string — skill (level)"]
    },
    "advantages": {
      "proprietary_insights": ["string"],
      "unique_access": ["string"],
      "credibility_capital": ["string"],
      "regulatory_knowledge": ["string"]
    },
    "meta": {
      "market_proximity": "number | null",
      "execution_readiness": "ready | preparing | exploring | null"
    }
  }
}
```

When no profile exists: `"founder_context": null`.

---

## Rules for Departments Consuming Founder Context

### 1. Never change scores based on founder context

Department scores must remain anchored to market reality. The problem either exists or it doesn't, regardless of who the founder is. Market size doesn't change because of who's asking.

**Founder context affects:**
- `executive_summary` — qualitative annotations ("Founder has operator-level knowledge in this domain")
- `flags` — founder-specific flags (e.g., `"founder-capital-constraint"`, `"founder-domain-expertise"`)
- `score_reasoning` — contextual notes alongside score justification

**Founder context does NOT affect:**
- `score` — remains purely market/evidence-based
- `sub_scores` — remain anchored to scoring rubrics
- `data` field values — remain objective

### 2. Handle null gracefully

```
if founder_context is null:
    # Operate exactly as before the profile module existed
    # Do not mention founder in executive_summary
    # Do not add founder-related flags
    # This IS the backward-compatible path
```

### 3. Founder-specific flags

Departments may add these flags when founder_context is available:

| Flag | Department | When |
|---|---|---|
| `"founder-domain-expertise"` | Problem, Competitive | Founder has practitioner+ depth in the idea's industry |
| `"founder-capital-constraint"` | BizModel | `capital.available < estimated_cac * 100` |
| `"founder-audience-overlap"` | Market | Founder's audience niche overlaps with early adopter segment |
| `"founder-execution-risk"` | Risk | Solo founder, part-time, or critical skill gaps |
| `"founder-regulatory-advantage"` | Risk, Competitive | Founder has relevant regulatory knowledge |
| `"founder-geographic-mismatch"` | Market | Founder's target_geographies don't include the idea's primary market |

These flags are consumed by Synthesis for the Founder-Idea Fit assessment.

### 4. Synthesis is the only module that produces a fit score

The quantitative Founder-Idea Fit scoring happens exclusively in `hc-synthesis` (Step 6b). Departments provide qualitative context and flags. Synthesis integrates everything into a structured fit assessment.

See `skills/profile/references/fit-dimensions.md` for the fit scoring rubrics.

---

## Pre-Filter Protocol

The orchestrator runs a pre-filter check before launching the validation pipeline. This is NOT a department — it's orchestrator logic.

### Pre-filter checks

| Check | Condition | Result |
|---|---|---|
| Hard-no violation | Idea text or industry overlaps with `hard_nos[]` | `BLOCK` — do not run pipeline |
| Capital floor | Idea category typically requires more capital than `capital.available` | `WARN` — show to user, ask to proceed |
| Critical skill gap | Idea requires skills not covered by founder or team | `WARN` |
| Geographic mismatch | Idea targets market outside `target_geographies[]` | `WARN` |

**Results:**
- `BLOCK`: Hard stop. Explain why the idea conflicts with the founder's profile. Do not launch departments.
- `WARN`: Show concern to user. If user confirms "proceed anyway", launch normally with founder_context intact (departments will note the mismatches).
- `PROCEED`: No issues found. Launch pipeline normally.

If no profile exists, pre-filter is skipped entirely (all ideas proceed).

---

## Snapshot Protocol

When a validation pipeline starts and a profile exists, the orchestrator creates a snapshot:

```
mem_save(
  title: "Profile Snapshot: {name} @ {validation-slug}",
  topic_key: "profile/{user-slug}/snapshot/{validation-slug}",
  type: "discovery",
  project: "hardcore",
  scope: "project",
  content: "**What**: Frozen profile at validation time [profile] [snapshot] [{validation-slug}]\n\n**Where**: profile/{user-slug}/snapshot/{validation-slug}\n\n**Data**:\n{founder_context as JSON string}"
)
```

This allows future re-examination of "what profile context was active when this validation ran?"

---

## Module Manifest (Extensibility)

Future modules can declare what profile dimensions they need by placing a `profile-needs.md` file in their `references/` directory. The profiler scans for these at interview time and adapts its questions.

Format:
```yaml
module: hc-brand
profile_dimensions:
  required:
    - motivation.values
    - motivation.working_style
    - identity.languages
  optional:
    - advantages.credibility_capital
    - previous_ventures
  usage: |
    Values and working style drive brand voice and positioning.
    Languages determine which markets the brand materials target.
    Credibility capital informs brand authority messaging.
```

When `hc-brand` is installed (`skills/brand/references/profile-needs.md` exists), the profiler ensures Phase 5 (Motivation & Working Style) is never skipped and probes `values` specifically.

# Hardcore — AI Agent Business Operating System

## What This Project Is

**Hardcore** is a modular AI agent ecosystem where the user is the CEO and the agents are the departments. Each module covers a real business function — from validating an idea to giving a company its identity.

**Current modules:**
- **Idea Validation** (complete) — 6-department pipeline, GO/NO-GO/PIVOT verdicts with real evidence
- **Founder Profile** (complete) — Adaptive profiling that personalizes validation with Founder-Idea Fit scoring
- **Brand & Identity** (planned) — Company identity generation for validated ideas

See `ROADMAP.md` for the strategic plan.

## How to Validate an Idea (Idea Validation Module)

## How to Validate an Idea

When the user asks to validate a startup idea (in any language), you become the **HC Orchestrator**. Read and follow `skills/hc-orchestrator/SKILL.md` as your primary instruction set.

Before starting, read ALL shared conventions:
- `skills/_shared/output-contract.md`
- `skills/_shared/scoring-convention.md`
- `skills/_shared/engram-convention.md`
- `skills/_shared/persistence-contract.md`
- `skills/_shared/department-protocol.md`
- `skills/_shared/glossary.md`

### Two Modes

**Normal mode** (default — when the user says "validá esta idea", "validate this idea", or similar):
- Human-in-the-loop checkpoints after Problem and after Market+Competitive
- `detail_level: "standard"`

**Fast mode** (when the user says "validación rápida", "fast validate", or explicitly asks for no pauses):
- No checkpoints, runs end-to-end
- `detail_level: "concise"`
- Problem knockout (< 40) skips directly to Synthesis

### The Pipeline (DAG)

```
PROBLEM → (MARKET ∥ COMPETITIVE) → (BIZMODEL ∥ RISK) → SYNTHESIS
```

Each department is a sub-agent. For each one:
1. Read the corresponding `skills/hc-{dept}/SKILL.md`
2. Launch a sub-agent (use the Agent tool) with that SKILL as instructions
3. Pass: `{ idea, slug, persistence_mode, detail_level }`
4. The sub-agent does its research, scores, persists, and returns an output envelope
5. Show the `executive_summary` to the user

**Market and Competitive run in parallel** — launch both simultaneously.
**BizModel and Risk run in parallel** — launch both after Market+Competitive complete.

### Department Skills

| Department | Skill file | Weight |
|---|---|---|
| Problem Validation | `skills/hc-problem/SKILL.md` | 30% |
| Market Sizing | `skills/hc-market/SKILL.md` | 25% |
| Competitive Intelligence | `skills/hc-competitive/SKILL.md` | 15% |
| Business Model | `skills/hc-bizmodel/SKILL.md` | 20% |
| Risk Assessment | `skills/hc-risk/SKILL.md` | 10% |
| GO/NO-GO Synthesis | `skills/hc-synthesis/SKILL.md` | — |

### Sub-Agent Launch Pattern

When launching each department as a sub-agent, use the template in `skills/hc-orchestrator/references/sub-agent-template.md`:

```
Read and follow these files exactly:
- skills/_shared/output-contract.md
- skills/_shared/scoring-convention.md
- skills/_shared/engram-convention.md
- skills/_shared/persistence-contract.md
- skills/_shared/department-protocol.md
- skills/_shared/glossary.md
- skills/hc-{department}/SKILL.md

For the data schema and assembly checklist, read:
- skills/hc-{department}/references/data-schema.md

Input:
{
  "idea": "{original idea text}",
  "slug": "{slug}",
  "persistence_mode": "{mode}",
  "detail_level": "{level}"
}

CRITICAL: Your `data` object must contain EVERY field from the data schema in your references/data-schema.md.
Cross-reference the Assembly Checklist before returning.
Missing fields break downstream departments.

Execute the full process defined in the SKILL.md and return the output envelope.
```

Each department needs **web search** capabilities. The sub-agent must use WebSearch and WebFetch tools to find real evidence (complaints, market reports, competitors, benchmarks, regulations).

## How to Build a Founder Profile (Profile Module)

When the user asks to create their profile (e.g., "crea mi perfil", "create my profile", "quiero armar mi perfil"), launch the profile sub-agent.

Before starting, read the shared conventions listed above PLUS:
- `skills/_shared/profile-contract.md`

### Profile Commands

| Command | What it does |
|---|---|
| `/profile:new` | Start guided interview (default, 8-15 adaptive questions) |
| `/profile:quick <text>` | Create profile from freeform text |
| `/profile:show` | Display current profile |
| `/profile:update <changes>` | Update specific dimensions |

### How Profile Integrates with Validation

When a profile exists in Engram, the validation pipeline automatically:
1. **Retrieves the profile** at Step 0b (before launching departments)
2. **Pre-filters** for hard-no violations and obvious mismatches
3. **Injects `founder_context`** into each department for qualitative annotations
4. **Calculates Founder-Idea Fit** in Synthesis (Step 6b) — 6 dimensions, 0-100 score

The profile is **optional**. Validations work identically without one (backward compatible). With a profile, you get personalized context and a fit assessment alongside the verdict.

### Profile Persistence

Profile artifacts live in Engram under `profile/{user-slug}/`:
- `profile/{user-slug}/core` — main profile
- `profile/{user-slug}/extended` — extended dimensions
- `profile/{user-slug}/state` — metadata, completeness, staleness
- `profile/{user-slug}/snapshot/{validation-slug}` — frozen at validation time

### Profile Department

| Component | File |
|---|---|
| Profiler Instructions | `skills/hc-profile/SKILL.md` |
| Profile Schema | `skills/hc-profile/references/data-schema.md` |
| Interview Guide | `skills/hc-profile/references/interview-guide.md` |
| Fit Scoring Rubrics | `skills/hc-profile/references/fit-dimensions.md` |
| Consumption Contract | `skills/_shared/profile-contract.md` |

## Persistence Mode Resolution

**Engram is required.** The pipeline cannot run without it.

1. At startup, verify Engram MCP tools are available (`mem_search`, `mem_save`, etc.) → use `"engram"`
2. If Engram is not available → **halt the pipeline** with an error asking the user to start Engram
3. User can explicitly request `"file"` mode in addition to Engram (writes to `output/{slug}/`)

## Knockout Rules (Non-Negotiable)

These trigger automatic **NO-GO** regardless of weighted score:
- `Problem < 40` — no evidence of real pain
- `Market < 40` — market too small or nonexistent
- `Risk < 30` — critical unmitigated risks
- Two or more department scores `< 45` — multiple weak fundamentals

## Key Rules

1. **You are delegate-only.** NEVER do analysis work yourself. Each department is a sub-agent that does its own research and scoring.
2. **Every department must use real web search.** No fabricating evidence, competitors, or market data.
3. **Arithmetic must be exact.** Every score is the sum of sub-dimensions. Verify before returning.
4. **Scoring is anchored to observable criteria.** See `skills/_shared/scoring-convention.md` for the exact rubrics per department.
5. **Each department persists its own output.** You only persist pipeline state (see orchestrator SKILL.md).
6. **Show progress to the user.** After each department completes, show the executive_summary and score.

## Presenting Results

After Synthesis completes, present to the user:
- **Verdict** prominently (GO / NO-GO / PIVOT)
- Weighted score and breakdown by department
- Key strengths and concerns
- Next steps and validation experiments
- If PIVOT: pivot suggestions

## Exporting Test Results

When the user asks to export results after a validation (e.g., "export results to testing"), follow the protocol in `testing/PROTOCOL.md`:

1. Create directory `testing/runs/{YYYY-MM-DD}_{machine}_{idea-id}/`
   - `machine`: ask the user for their machine identifier if not known (e.g., "desktop", "laptop")
   - `idea-id`: from `testing/suite.yaml` if the idea matches, otherwise use the slug
2. Recover all 6 department outputs from Engram and write each as `{dept}.json`
3. Generate `verdict.yaml` with scores, verdict, and validation checks against suite expectations
4. Show a summary of checklist pass/fail to the user

## Language

Respond in the same language the user uses. The specs are in English but the user-facing communication follows the user's language (typically Spanish).

## Project Structure

```
ROADMAP.md                             # Strategic roadmap (start here for context)
CLAUDE.md                              # This file — Claude Code integration instructions
skills/
├── _shared/                           # Shared conventions (read these first)
│   ├── output-contract.md             # JSON envelope every dept returns
│   ├── scoring-convention.md          # Sub-dimensions, rubrics, weights, knockouts
│   ├── engram-convention.md           # Engram naming, recovery, session lifecycle
│   ├── persistence-contract.md        # Mode resolution (engram/file)
│   ├── department-protocol.md         # Common procedures for all departments
│   ├── glossary.md                    # Ambiguity resolutions and term definitions
│   └── profile-contract.md           # How any module consumes founder profile
├── hc-orchestrator/
│   ├── SKILL.md                       # Orchestrator (your primary instructions)
│   └── references/
│       └── sub-agent-template.md      # Launch template + envelope validation
├── hc-profile/
│   ├── SKILL.md                       # Founder Profile — adaptive profiling
│   └── references/
│       ├── data-schema.md             # Profile schema + assembly checklist
│       ├── interview-guide.md         # Adaptive interview questions by phase
│       └── fit-dimensions.md          # Founder-Idea Fit scoring rubrics
├── hc-problem/
│   ├── SKILL.md                       # Dept 1: Problem Validation
│   └── references/
│       └── data-schema.md             # Data schema + assembly checklist
├── hc-market/
│   ├── SKILL.md                       # Dept 2: Market Sizing
│   └── references/
│       └── data-schema.md
├── hc-competitive/
│   ├── SKILL.md                       # Dept 3: Competitive Intelligence
│   └── references/
│       └── data-schema.md
├── hc-bizmodel/
│   ├── SKILL.md                       # Dept 4: Business Model
│   └── references/
│       └── data-schema.md
├── hc-risk/
│   ├── SKILL.md                       # Dept 5: Risk Assessment
│   └── references/
│       └── data-schema.md
├── hc-synthesis/
│   ├── SKILL.md                       # Dept 6: GO/NO-GO Synthesis
│   └── references/
│       ├── data-schema.md
│       └── upstream-field-map.md      # Field source mapping for synthesis
testing/                               # Quality assurance
├── PROTOCOL.md                        # Testing protocol, checklist, phase gates
├── suite.yaml                         # 10 curated test ideas with expected outcomes
├── runs/                              # Committed run results (per machine, per idea)
└── analysis/                          # Cross-machine variance analysis
calibration/                           # Scoring system validation
└── scenarios.md                       # 13 calibration scenarios (84.6% accuracy)
docs/                                  # Reference
└── idea-loop-architecture.md          # Future Idea Engine module design
```

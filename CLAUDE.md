# Hardcore — AI Agent Business Operating System

## What This Project Is

**Hardcore** is a modular AI agent ecosystem where the user is the CEO and the agents are the departments. Each module covers a real business function — from validating an idea to giving a company its identity.

**Current modules:**
- **Idea Validation** (complete) — 6-department pipeline, GO/NO-GO/PIVOT verdicts with real evidence
- **Founder Profile** (complete) — Adaptive profiling that personalizes validation with Founder-Idea Fit scoring
- **Brand & Identity** (specs complete, Sprint 1 pending) — Company identity generation for validated ideas, optimized for Claude Design downstream

See `ROADMAP.md` for the strategic plan.

## How to Validate an Idea (Idea Validation Module)

## How to Validate an Idea

When the user asks to validate a startup idea (in any language), you become the **HC Orchestrator**. Read and follow `skills/validation/orchestrator/SKILL.md` as your primary instruction set.

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
1. Read the corresponding `skills/validation/{dept}/SKILL.md`
2. Launch a sub-agent (use the Agent tool) with that SKILL as instructions
3. Pass: `{ idea, slug, persistence_mode, detail_level }`
4. The sub-agent does its research, scores, persists, and returns an output envelope
5. Show the `executive_summary` to the user

**Market and Competitive run in parallel** — launch both simultaneously.
**BizModel and Risk run in parallel** — launch both after Market+Competitive complete.

### Department Skills

| Department | Skill file | Weight |
|---|---|---|
| Problem Validation | `skills/validation/problem/SKILL.md` | 30% |
| Market Sizing | `skills/validation/market/SKILL.md` | 25% |
| Competitive Intelligence | `skills/validation/competitive/SKILL.md` | 15% |
| Business Model | `skills/validation/bizmodel/SKILL.md` | 20% |
| Risk Assessment | `skills/validation/risk/SKILL.md` | 10% |
| GO/NO-GO Synthesis | `skills/validation/synthesis/SKILL.md` | — |

### Sub-Agent Launch Pattern

When launching each department as a sub-agent, use the template in `skills/validation/orchestrator/references/sub-agent-template.md`:

```
Read and follow these files exactly:
- skills/_shared/output-contract.md
- skills/_shared/scoring-convention.md
- skills/_shared/engram-convention.md
- skills/_shared/persistence-contract.md
- skills/_shared/department-protocol.md
- skills/_shared/glossary.md
- skills/validation/{department}/SKILL.md

For the data schema and assembly checklist, read:
- skills/validation/{department}/references/data-schema.md

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

| Command | Handler | What it does |
|---|---|---|
| `/profile:new` | sub-agent (mode: `guided`) | Start guided interview (default, 8-15 adaptive questions) |
| `/profile:quick <text>` | sub-agent (mode: `quick`) | Create profile from freeform text |
| `/profile:update <changes>` | sub-agent (mode: `update`) | Update specific dimensions of an existing profile |
| `/profile:show [slug]` | **orchestrator (direct)** | Recover from Engram and display in markdown — no sub-agent |

For `/profile:show`, the orchestrator follows Entry Point 4 in `skills/profile/SKILL.md` directly: locate the profile (search by slug or by latest), recover the 3 artifacts via `mem_get_observation`, parse the `**Data**:` JSON, and render the markdown card. **No writes to Engram.**

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
| Profiler Instructions | `skills/profile/SKILL.md` |
| Profile Schema | `skills/profile/references/data-schema.md` |
| Interview Guide | `skills/profile/references/interview-guide.md` |
| Fit Scoring Rubrics | `skills/profile/references/fit-dimensions.md` |
| Consumption Contract | `skills/_shared/profile-contract.md` |

## How to Build a Brand (Brand Module)

When the user asks to brand a validated idea (e.g., "brandea esta idea", "brand this idea", "armá la marca", `/brand:new`), you become the **HC Brand Orchestrator**. Read and follow `skills/brand/SKILL.md` as your primary instruction set.

**Requires Claude Pro / Max / Team / Enterprise subscription** — pre-flight gate. The downstream target is **Claude Design** (claude.ai/design). Without a valid subscription, the orchestrator halts.

Before starting, read shared conventions listed above PLUS:
- `skills/_shared/brand-contract.md`
- `skills/brand/references/brand-profiles.md`
- `skills/brand/references/archetype-guide.md`
- `skills/brand/references/coherence-rules.md`

### Brand Commands

| Command | What it does |
|---|---|
| `/brand:new [idea or slug]` | Start brand run (Normal mode — mid-run interactions) |
| `/brand:fast [idea or slug]` | Run without mid-run interactions (auto-picks top-ranked) |
| `/brand:extend {dept}` | Re-run a specific dept with feedback |
| `/brand:override {k}={v}` | Pre-run override (see allowlist in `skills/brand/SKILL.md` §Override Allowlist) |
| `/brand:resume [slug]` | Resume an interrupted run |
| `/brand:show [slug \| version]` | Display final report or snapshot |
| `/brand:diff v1 v2` | Compare two snapshots |
| `/brand:rollback v{N}` | Restore previous snapshot (destructive — requires user confirmation) |
| `/brand:snapshot` | Force new snapshot |
| `/brand:reproduce v{N}` | Re-run with frozen inputs (SVGs + copy wording may vary) |
| `/brand:audit {slug}` | Show audit log |

### The Brand Pipeline (DAG)

```
Pre-flight → Snapshot upstream → ⓪ SCOPE ANALYSIS → ① STRATEGY
                                                       ↓
                                    ② VERBAL ∥ ③ VISUAL  (parallel)
                                                       ↓
                                              ④ LOGO & KEY VISUALS
                                                       ↓
                                              ⑤ HANDOFF COMPILER (9 gates, fail-fast)
                                                       ↓
                                 Pre-delivery review (obligatory, even in Fast mode)
                                                       ↓
                                 Package at output/{slug}/brand/
                                 ├─ brand-design-document.pdf
                                 ├─ prompts-for-claude-design.md
                                 ├─ brand-tokens/
                                 └─ reference-assets/
```

### Brand Department Skills

| Dept | Skill file |
|---|---|
| Scope Analysis | `skills/brand/scope-analysis/SKILL.md` |
| Strategy | `skills/brand/strategy/SKILL.md` |
| Verbal Identity | `skills/brand/verbal/SKILL.md` |
| Visual System | `skills/brand/visual/SKILL.md` |
| Logo & Key Visuals | `skills/brand/logo/SKILL.md` |
| Handoff Compiler | `skills/brand/handoff-compiler/SKILL.md` |

### Sub-Agent Launch Pattern

Use `skills/brand/references/sub-agent-template.md`. Each dept receives `scope_ref` and preceding dept refs as input; retrieves upstream data from Engram per the shared department-protocol.

### Brand Integrates Validation + Profile

- **Validation required**: verdict `GO` or `PIVOT`. NO-GO blocks (override with explicit "brandea igual" + permanent warning).
- **Profile optional**: Brand runs without profile in "generic mode" (flag `decided_without_profile: true`). With profile at completeness ≥ 0.4, full personalization.
- **Voice precedence**: archetype (primary) > scope.verbal_register (constraint) > profile (annotation only). See `skills/_shared/brand-contract.md`.

### Claude Design Workflow (downstream, user-mediated in v1)

The brand package is optimized for Claude Design consumption:
1. User uploads `brand-design-document.pdf` to Claude Design "Set up your design system".
2. Claude Design extracts palette, typography, logo, voice, visual principles.
3. User validates with a test project, publishes the design system.
4. For each deliverable needed, user pastes prompts from `prompts-for-claude-design.md` into new Claude Design projects.
5. Claude Design exports (HTML/CSS/PDF/PPTX) → Claude Code → deploy.

### Brand Persistence

Brand artifacts live in Engram under `brand/{idea-slug}/*`:
- `brand/{slug}/scope` — classification + manifest
- `brand/{slug}/strategy` — archetype, voice, positioning, values, sentiment_landscape
- `brand/{slug}/verbal` — naming + core copy
- `brand/{slug}/visual` — palette, typography, mood, principles
- `brand/{slug}/logo` — logo paths + variants + derivations
- `brand/{slug}/handoff` — coherence trace + package manifest
- `brand/{slug}/final-report` — entry point for downstream consumers
- `brand/{slug}/snapshot/v{N}` — frozen state for versioning
- `brand/{slug}/snapshot/validation` + `brand/{slug}/snapshot/profile` — upstream snapshots at brand time

Filesystem artifacts at `output/{slug}/brand/`. Not versioned in git.

### Brand Failure Modes Summary

- **Engram down** → hard halt.
- **Claude Pro missing** → hard halt.
- **Validation missing / NO-GO** → hard halt (NO-GO allows explicit override).
- **Domain MCP down** → skip verification, flag.
- **open-websearch down** → skip TM screening, flag + warning.
- **Unsplash down** → skip mood imagery, Brand Document describes mood in prose.
- **PDF skill fails** → markdown fallback delivered.
- **Coherence gate fails** → fail-fast halt; user decides (re-run dept, accept with flag, abort).

See `skills/brand/SKILL.md` §Failure Modes and `skills/brand/references/coherence-rules.md` for full tables.

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
├── validation/                        # Idea Validation module
│   ├── orchestrator/
│   │   ├── SKILL.md                   # Orchestrator (primary instructions)
│   │   └── references/
│   │       └── sub-agent-template.md  # Launch template + envelope validation
│   ├── problem/
│   │   ├── SKILL.md                   # Dept 1: Problem Validation
│   │   └── references/
│   │       └── data-schema.md         # Data schema + assembly checklist
│   ├── market/
│   │   ├── SKILL.md                   # Dept 2: Market Sizing
│   │   └── references/
│   │       └── data-schema.md
│   ├── competitive/
│   │   ├── SKILL.md                   # Dept 3: Competitive Intelligence
│   │   └── references/
│   │       └── data-schema.md
│   ├── bizmodel/
│   │   ├── SKILL.md                   # Dept 4: Business Model
│   │   └── references/
│   │       └── data-schema.md
│   ├── risk/
│   │   ├── SKILL.md                   # Dept 5: Risk Assessment
│   │   └── references/
│   │       └── data-schema.md
│   └── synthesis/
│       ├── SKILL.md                   # Dept 6: GO/NO-GO Synthesis
│       └── references/
│           ├── data-schema.md
│           └── upstream-field-map.md  # Field source mapping for synthesis
├── profile/                           # Founder Profile module
│   ├── SKILL.md                       # Adaptive profiling
│   └── references/
│       ├── data-schema.md             # Profile schema + assembly checklist
│       ├── interview-guide.md         # Adaptive interview questions by phase
│       └── fit-dimensions.md          # Founder-Idea Fit scoring rubrics
└── brand/                             # Brand & Identity module
    ├── SKILL.md                       # Orchestrator (pipeline, modes, reveals, failures, versioning)
    ├── references/
    │   ├── sub-agent-template.md      # Launch template for Brand sub-agents
    │   ├── archetype-guide.md         # 12 Jungian archetypes × voice × typography × palette × sentiment
    │   ├── brand-profiles.md          # 8 canonical profiles + output matrix + hybrid composition rules
    │   └── coherence-rules.md         # 9 gates (G0-G8) + criticality matrix + escalation templates
    ├── scope-analysis/                # Paso 0 — classification + manifest
    │   ├── SKILL.md
    │   └── references/data-schema.md
    ├── strategy/                      # Dept 1 — archetype, voice, positioning, sentiment_landscape
    │   ├── SKILL.md
    │   └── references/data-schema.md
    ├── verbal/                        # Dept 2 — naming (with Domain + TM verification) + core copy
    │   ├── SKILL.md
    │   └── references/data-schema.md
    ├── visual/                        # Dept 3 — palette (WCAG AA) + typography + mood refs
    │   ├── SKILL.md
    │   └── references/
    │       ├── data-schema.md
    │       ├── archetype-palette-seeds.md   # HSL ranges per archetype
    │       └── wcag-utility.md              # WCAG contrast formulas + pseudocode
    ├── logo/                          # Dept 4 — Claude-native SVG + variants + derivations
    │   ├── SKILL.md
    │   └── references/
    │       ├── data-schema.md
    │       └── svg-templates.md             # Templates per archetype × form language
    └── handoff-compiler/              # Dept 5 — 9 gates + 4 deliverables for Claude Design
        ├── SKILL.md
        └── references/
            ├── data-schema.md
            ├── brand-document-template.md    # PDF structure per brand profile
            ├── prompts-library-templates.md  # Prompts for Claude Design (per scope)
            └── tokens-templates.md           # tokens.css / tokens.json / tailwind / fonts / examples
testing/                               # Quality assurance
├── PROTOCOL.md                        # Validation testing protocol
├── suite.yaml                         # 10 curated Validation test ideas
├── brand-PROTOCOL.md                  # Brand testing protocol
├── brand-suite.yaml                   # 8 Brand test ideas (1 per canonical profile)
├── brand-human-review-template.md     # Qualitative review template (founder shipping criterion)
├── runs/                              # Validation run results
├── brand-runs/                        # Brand run results
│   └── REGISTRY.md
└── analysis/                          # Cross-module analysis
    └── brand-coverage.md              # Aggregated Brand run observations
calibration/                           # Scoring system validation
└── scenarios.md                       # 13 calibration scenarios (84.6% accuracy)
docs/                                  # Reference
└── idea-loop-architecture.md          # Future Idea Engine module design
```

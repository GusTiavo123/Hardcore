# Hardcore Idea Validation — Claude Code Integration

## What This Project Is

A 6-department AI agent pipeline that validates startup ideas end-to-end and produces a **GO / NO-GO / PIVOT** verdict with real evidence, explicit scoring, and actionable next steps.

## How to Validate an Idea

When the user asks to validate a startup idea (in any language), you become the **HC Orchestrator**. Read and follow `skills/hc-orchestrator/SKILL.md` as your primary instruction set.

Before starting, read ALL shared conventions:
- `skills/_shared/output-contract.md`
- `skills/_shared/scoring-convention.md`
- `skills/_shared/engram-convention.md`
- `skills/_shared/persistence-contract.md`

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
PROBLEM → (MARKET ∥ COMPETITIVE) → BIZMODEL → RISK → SYNTHESIS
```

Each department is a sub-agent. For each one:
1. Read the corresponding `skills/hc-{dept}/SKILL.md`
2. Launch a sub-agent (use the Agent tool) with that SKILL as instructions
3. Pass: `{ idea, slug, persistence_mode, detail_level }`
4. The sub-agent does its research, scores, persists, and returns an output envelope
5. Show the `executive_summary` to the user

**Market and Competitive run in parallel** — launch both simultaneously.

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

When launching each department as a sub-agent, include in the prompt:

```
Read and follow these files exactly:
- skills/_shared/output-contract.md
- skills/_shared/scoring-convention.md
- skills/_shared/engram-convention.md
- skills/_shared/persistence-contract.md
- skills/hc-{department}/SKILL.md

Input:
{
  "idea": "{original idea text}",
  "slug": "{slug}",
  "persistence_mode": "{mode}",
  "detail_level": "{level}"
}

{If none mode: include upstream department outputs here}

Execute the full process defined in the SKILL.md and return the output envelope.
```

Each department needs **web search** capabilities. The sub-agent must use WebSearch and WebFetch tools to find real evidence (complaints, market reports, competitors, benchmarks, regulations).

## Persistence Mode Resolution

1. If Engram MCP tools are available (`mem_search`, `mem_save`, etc.) → use `"engram"`
2. If Engram is not available → use `"none"` (pass outputs inline between departments)
3. User can explicitly request `"file"` mode (writes to `output/{slug}/`)

When using `none` mode, you MUST pass the full output envelope from completed departments into the prompt context of downstream departments. See the None Mode Protocol in `skills/hc-orchestrator/SKILL.md`.

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

## Language

Respond in the same language the user uses. The specs are in English but the user-facing communication follows the user's language (typically Spanish).

## Project Structure

```
skills/
├── _shared/                    # Shared conventions (read these first)
│   ├── output-contract.md      # JSON envelope every dept returns
│   ├── scoring-convention.md   # Sub-dimensions, rubrics, weights, knockouts
│   ├── engram-convention.md    # Engram naming, recovery, session lifecycle
│   └── persistence-contract.md # Mode resolution (engram/file/none)
├── hc-orchestrator/SKILL.md    # Orchestrator (your primary instructions)
├── hc-problem/SKILL.md         # Dept 1: Problem Validation
├── hc-market/SKILL.md          # Dept 2: Market Sizing
├── hc-competitive/SKILL.md     # Dept 3: Competitive Intelligence
├── hc-bizmodel/SKILL.md        # Dept 4: Business Model
├── hc-risk/SKILL.md            # Dept 5: Risk Assessment
└── hc-synthesis/SKILL.md       # Dept 6: GO/NO-GO Synthesis
```

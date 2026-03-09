---
description: Start a full idea validation with human-in-the-loop checkpoints
---

# /validate:new

Run the Hardcore Idea Validation pipeline for a new startup idea.

## Usage

```
/validate:new <describe your idea in natural language>
```

## What It Does

1. Read `skills/hc-orchestrator/SKILL.md` and all shared conventions in `skills/_shared/`
2. Parse the idea and generate a slug
3. Check Engram for previous validations of this idea
4. Execute the 6-department DAG in order:
   - Problem Validation → Market Sizing ∥ Competitive Intel → Business Model → Risk → Synthesis
5. Show summaries and ask for confirmation between phases
6. Produce a GO / NO-GO / PIVOT verdict with evidence

## Example

```
/validate:new A platform that helps freelance developers manage contracts,
invoices, and client communication in one place
```

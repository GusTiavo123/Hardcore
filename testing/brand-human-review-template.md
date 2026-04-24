# Brand Review Template

Qualitative review of a Brand run. **Shipping criterion** — the founder/CEO fills this out after a run and decides if it ships. No numeric score.

Copy this file into each run directory as `human-review.md` and fill it out.

---

## Meta

- **Run ID**: `{date}_{machine}_{idea-id}`
- **Brand name produced**: {name}
- **Brand profile**: {profile}
- **Archetype**: {archetype}
- **Run mode**: normal | fast | extend | resume
- **Reviewer**: {name}
- **Review date**: {ISO date}

---

## What worked

Concrete, specific things that came out right. Prefer observations tied to the deliverables themselves (a line of copy, a palette choice, a logo concept) rather than generalizations.

- {specific thing}
- {specific thing}
- {specific thing}

---

## What didn't work

Failure modes in plain language. Not "the output was bad" — specific observations like "the voice in the About copy drifted too playful for the Sage archetype" or "the primary logo reads well at 200px but lost legibility at 32px".

- {specific failure mode}
- {specific pattern}

---

## Coherence gates — any surprises?

Even when gates passed automatically, did anything feel off that the gates didn't catch? Record gaps in our gate coverage.

- {observation}

---

## Claude Design compatibility (if tested)

Did you upload the PDF to Claude Design? If yes:

- **Design system extracted correctly?** yes | partial | no
- **Test project matched brand?** yes | partial | no
- **Any specific mismatch?** {describe}
- **Prompts library usefulness** (if you pasted any prompts): {brief note}

---

## Would you ship this?

- [ ] Yes — as-is
- [ ] Yes — with minor adjustments (list below)
- [ ] No — significant rework needed

---

## If adjustments: what?

- {adjustment 1}
- {adjustment 2}

Use `/brand:extend {dept}` for targeted regeneration, or `/brand:new` if the whole direction needs to change.

---

## Module iteration notes

What would you change in the module's SKILL.md / references based on this run? These notes feed post-dogfooding iteration.

- {what to change in {dept}/SKILL.md}
- {what to change in {dept}/references/{file}}
- {new edge case to document}
- {new failure mode to add to `plan/brand/13-failure-modes.md`}

---

## Run metadata for cross-run analysis

Fill these to enable cross-run pattern detection:

- **Archetype same as previous run for this profile?** yes | no | first run for this profile
- **Palette family same?** yes | no | first run
- **Logo form language same?** yes | no | first run
- **Voice attributes overlap with previous run ≥ 3?** yes | no | first run
- **Any flags raised?** {list}
- **Soft failures encountered?** {list}

---

## Qualitative 1-liner

One sentence the founder would use to describe the brand produced, in their own words:

> {your one sentence}

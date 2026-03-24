# Glossary — Ambiguity Resolutions

This file clarifies terms and thresholds that are referenced across multiple department skills. When a SKILL.md or scoring rubric uses these terms, these definitions apply.

## Partial Alignment (Competitive — Wedge Opportunity)

When evaluating whether a market gap "aligns with the idea" in `market_gaps[]`:

- `aligns_with_idea: true` — the idea's core approach directly OR partially addresses this gap
- `aligns_with_idea: false` — the gap exists but the idea does not address it

For **scoring purposes**, gaps have an alignment strength:

| Strength | When to apply | Scoring weight |
|---|---|---|
| Full (1.0) | The idea's core value proposition directly solves this gap | Counts as 1 aligned gap |
| Partial (0.5) | The idea could help with this gap but it's not the primary focus | Counts as 0.5 aligned gaps |
| None (0.0) | The gap exists in the market but the idea doesn't address it | Does not count |

When the Wedge Opportunity rubric says "at least 2 align with the idea," count full alignments as 1.0 and partial as 0.5 toward that total.

To track this, include an optional `alignment_strength` field in each gap entry: `"full" | "partial" | "none"`. Set `aligns_with_idea: true` for both `full` and `partial`. This preserves backward compatibility — Synthesis checks `aligns_with_idea == true`.

## Measurable Membership (Market — Early Adopter Identifiability)

A "reachable channel with measurable membership" requires:

1. **Publicly visible count** — you can report the number without needing insider access
2. **Minimum threshold** — 100+ members to qualify as a channel entry

**Qualifying examples:**
- Subreddit (displayed member count)
- Slack/Discord community (displayed or disclosed member count)
- Conference (publicly announced attendance figures)
- Newsletter (subscriber count disclosed or estimated from platform data)
- LinkedIn group (displayed member count)
- YouTube channel / podcast (subscriber count)
- Professional association (published membership figures)

**Not qualifying:**
- Private Slack without disclosed count
- "The freelancer community" (no specific, measurable channel)
- Blog without subscriber data

The per-tier thresholds in the scoring rubric (1,000+ members, 10,000+ combined) are separate from this minimum. This minimum (100+) determines whether a channel *exists* for counting purposes.

## Navigable vs Barrier Frameworks (Risk — Regulatory & Legal)

When counting regulatory frameworks for the Regulatory & Legal sub-dimension:

| Classification | Weight | Criteria |
|---|---|---|
| **Barrier** | 1.0 | Novel regulation with no commercial compliance path, or requires bespoke legal work with no established precedent |
| **Navigable** | 0.5 | Commercial compliance-as-a-service tools exist with 100+ paying customers, OR official government guidance includes a self-serve checklist/pathway |

**Common frameworks — default classifications:**

| Framework | Default | Rationale |
|---|---|---|
| PCI-DSS | Navigable (0.5) | Stripe, Square handle it; compliance tools widespread |
| SOC 2 | Navigable (0.5) | Vanta, Drata, Secureframe — large vendor ecosystem |
| GDPR | Navigable (0.5) | OneTrust, standard DPAs, well-documented paths |
| HIPAA | Navigable (0.5) | AWS/Azure BAAs, compliance platforms available |
| State money transmitter | Navigable (0.5) | Multiple compliance services, documented paths per state |
| COPPA (with AI) | Barrier (1.0) | No clear compliance path for AI + children's data |
| FDA device clearance | Barrier (1.0) | 510(k)/PMA requires bespoke clinical + legal work |
| Novel crypto regulation | Barrier (1.0) | Evolving, no stable compliance framework |
| Medical licensing (per jurisdiction) | Barrier (1.0) | Requires jurisdiction-by-jurisdiction legal work |

**Override rule**: If your search finds commercial compliance-as-a-service for a framework listed as "Barrier," reclassify it as Navigable and cite the evidence. Conversely, if a "Navigable" framework has had recent enforcement actions with no compliance tool update, consider reclassifying as Barrier.

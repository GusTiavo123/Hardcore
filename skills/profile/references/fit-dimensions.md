# Founder-Idea Fit — Scoring Dimensions & Rubrics

This document defines the 6 dimensions used by `hc-synthesis` to assess how well a specific founder matches a specific validated idea. Synthesis reads this file during Step 6b (Founder-Idea Fit Assessment).

---

## Overview

| # | Dimension | Max | What it measures | Primary cross-reference |
|---|---|---|---|---|
| 1 | Domain Expertise Match | 20 | How deep is the founder's knowledge of this domain? | `domain_expertise` vs Problem `industry` |
| 2 | Resource Sufficiency | 20 | Can the founder fund and sustain this idea? | `resources` vs BizModel `unit_economics` |
| 3 | Risk Tolerance Alignment | 20 | Does appetite match reality? | `risk_tolerance` vs Risk `overall_risk_level` |
| 4 | Network & Distribution | 20 | Can the founder reach target customers? | `network` vs Market `early_adopters` |
| 5 | Execution Capability | 20 | Can the founder (and team) build this? | `skills` + `team` vs idea requirements |
| 6 | Asymmetric Advantage | 20 | Does the founder have an unfair edge? | `advantages` vs Competitive landscape |

**Total**: 0-120, normalized to **0-100** as: `fit_score = round((raw_total / 120) * 100)`

---

## Dimension 1: Domain Expertise Match (0-20)

**Source fields**: `founder.skills.domain_expertise[]` vs `problem.data.industry`

| Score | Criteria |
|---|---|
| 0-4 | No domain expertise in the idea's industry or adjacent industries. Founder is entering a completely unfamiliar market. |
| 5-8 | **Observer-level** in the exact industry, OR **practitioner/operator** in an adjacent industry. Has surface knowledge but no operational insight. |
| 9-12 | **Practitioner-level** in the exact industry. Has worked inside the domain, knows tools/processes/pain points from the employee perspective. |
| 13-16 | **Operator-level** in an adjacent industry, OR **practitioner** with 5+ years in the exact industry AND `insider_knowledge` field is substantive. |
| 17-20 | **Operator-level** in the exact industry. Has run a business in this domain. Knows unit economics, customer behavior, supplier dynamics, regulatory landscape from direct experience. |

**Scoring notes:**
- The `insider_knowledge` field is a strong differentiator between the middle tiers. A practitioner who can articulate non-obvious insights scores higher.
- If the founder has `meta_signals.market_proximity == 0` (they ARE the target customer), add +2 (cap at 20).
- If domain_expertise is `null`, score 0 — this dimension cannot be inferred.

---

## Dimension 2: Resource Sufficiency (0-20)

**Source fields**: `founder.resources.*` vs `bizmodel.data.unit_economics.*`

Cross-reference the founder's available capital, time, and team against what the business model requires.

| Score | Criteria |
|---|---|
| 0-4 | Capital covers < 3 months of estimated burn. Part-time or exploring. Solo with critical skill gaps. Cannot acquire even 50 customers at estimated CAC. |
| 5-8 | Capital covers 3-6 months. Part-time but committed. Team covers some gaps. Can fund initial validation but not sustained growth. |
| 9-12 | Capital covers 6-12 months. Part-time with 20+ hrs/week OR full-time. Team or skills cover core execution needs. Can acquire first 100 customers. |
| 13-16 | Capital covers 12-18 months. Full-time commitment. Team covers most skill gaps. Fundraising experience or willingness if needed. |
| 17-20 | Capital covers 18+ months OR has revenue/funding. Full-time with team. All critical capabilities covered. Can sustain through to product-market fit. |

**Scoring notes:**
- Use BizModel's `estimated_cac` to calculate customer acquisition capacity: `available_capital / estimated_cac`.
  - < 50 customers → 0-4 range
  - 50-100 → 5-8 range
  - 100-500 → 9-12 range
  - 500+ → 13+ range
- Use BizModel's `payback_months` to estimate burn: if payback > 12 months and founder has < 12 months runway, flag mismatch.
- `commitment: "exploring"` caps this dimension at 8 regardless of capital (execution uncertainty too high).
- If capital fields are `null`, estimate conservatively (assume constrained).

---

## Dimension 3: Risk Tolerance Alignment (0-20)

**Source fields**: `founder.constraints.risk_tolerance` + `risk_tolerance_evidence` vs `risk.data.overall_risk_level`

This measures alignment, not absolute tolerance. A conservative founder + low risk idea scores high. An aggressive founder + high risk idea also scores high. Mismatch is what scores low.

| Founder \ Idea Risk | Low | Medium | High | Critical |
|---|---|---|---|---|
| **Conservative** | 17-20 | 9-12 | 3-6 | 0-2 |
| **Moderate** | 14-17 | 14-17 | 7-10 | 2-5 |
| **Aggressive** | 10-14 | 14-17 | 14-17 | 7-10 |

**Scoring notes:**
- Cross-reference `risk_tolerance_evidence` with actual constraints. Someone who says "aggressive" but has a family and mortgage is effectively moderate-to-conservative.
- If the founder has `advantages.regulatory_knowledge` relevant to the idea's regulatory risks (from Risk department), boost by +2 (cap at 20) — they can navigate risks others can't.
- If `risk_tolerance` is `null`, assume `moderate` (score at the moderate row).
- `critical` risk ideas score low for everyone — even aggressive founders face existential risk.

---

## Dimension 4: Network & Distribution Advantage (0-20)

**Source fields**: `founder.network.*` vs `market.data.early_adopters[]`

| Score | Criteria |
|---|---|
| 0-4 | No relevant network. No audience. `market_proximity >= 3`. Would rely entirely on paid acquisition or cold outreach to reach customers. |
| 5-8 | Some relevant professional contacts but not directly activatable. Member of 1-2 communities in adjacent space. No owned distribution channel. |
| 9-12 | Meaningful network in the target sector (`professional_network` with `activatable: true`). Active member of 1+ relevant community. OR small audience (< 1K) in the exact niche. |
| 13-16 | Strong activatable network AND at least 1 owned distribution channel (newsletter, blog, podcast). OR audience of 1K-10K in the target niche with medium+ engagement. |
| 17-20 | Large relevant audience (10K+) in the exact target segment with high engagement. OR multiple owned distribution channels. OR `market_proximity == 0` (founder IS the customer) + strong community presence. |

**Scoring notes:**
- Compare `founder.network.audience[].niche` against `market.data.early_adopters[].segment`. Direct overlap = high score. Adjacent = moderate. No overlap = low.
- Compare `founder.network.distribution_channels[]` against `market.data.early_adopters[].reachable_channels[]`. If the founder already owns a channel that maps to a reachable channel, this is a major advantage.
- An audience of 50K in an unrelated niche scores lower than 500 in the exact target segment.
- Quality > quantity: `engagement: "high"` with 2K followers > `engagement: "low"` with 50K.

---

## Dimension 5: Execution Capability (0-20)

**Source fields**: `founder.skills.technical[]` + `founder.skills.business[]` + `founder.resources.team.*`

Assess whether the founder (and team) can build an MVP of this idea without significant external hiring.

| Score | Criteria |
|---|---|
| 0-4 | Cannot build an MVP. No relevant technical skills, no technical co-founder, no budget to hire. Would need to find a technical partner before starting. |
| 5-8 | Could build a basic prototype with significant effort or learning. Some relevant skills but major gaps. OR has budget to hire 1 freelancer for core development. |
| 9-12 | Can build the MVP. Core technical skills covered (by founder or team). Minor gaps fillable with learning or contractors. Business skills adequate for launch. |
| 13-16 | Strong execution capability. Full-stack technical coverage (founder or team). Business skills include at least one of: sales, marketing, or operations at proficient+ level. |
| 17-20 | Exceptional capability. Technical + business fully covered by the team. Has built similar products before. Previous ventures demonstrate execution track record. |

**Scoring notes:**
- Evaluate skills at the TEAM level, not individual. A non-technical founder with a technical co-founder scores the same as a technical solo founder.
- `previous_ventures` with `outcome: "active" or "sold"` is strong evidence of execution capability (+3 to baseline).
- For AI/ML ideas: distinguish between "can integrate APIs" (moderate) vs "can train/fine-tune models" (expert).
- For marketplace ideas: business skills (sales, operations, supply management) matter more than pure technical skills.
- `team.solo == true` with critical gaps caps at 8 regardless of other factors.

---

## Dimension 6: Asymmetric Advantage (0-20)

**Source fields**: `founder.advantages.*` vs Competitive department output

This is the most subjective dimension. It measures whether this specific founder has an unfair advantage that a well-funded random team would NOT have.

| Score | Criteria |
|---|---|
| 0-4 | No identifiable advantages. Any well-resourced team could pursue this idea equally well. The founder brings nothing unique beyond the idea itself. |
| 5-8 | Minor advantages: some domain knowledge, loose industry connections, personal experience with the problem. These help but don't create a moat. |
| 9-12 | Clear advantages: substantive `insider_knowledge`, strong network in the specific space, or credibility that would accelerate trust-building with customers. |
| 13-16 | Strong advantages: combination of 2+ clear advantages. OR proprietary access (unique data, exclusive relationships, existing customer base from another product). |
| 17-20 | Unfair advantages: proprietary data that competitors can't replicate, existing customers who would switch immediately, regulatory expertise that acts as a moat, OR existing IP (patents, codebase) that gives a 6+ month head start. |

**Scoring notes:**
- Cross-reference with Competitive's `data.direct_competitors[].moat_type`. If competitors have strong moats, the founder needs equally strong asymmetric advantages to compensate.
- `advantages.existing_ip` with reusable code/product is worth +3-5 depending on relevance.
- `advantages.credibility_capital` matters most in trust-heavy markets (healthcare, finance, enterprise).
- If `advantages` is entirely empty/null, score 2-3 (not 0 — the founder chose this idea for a reason, even if they didn't articulate why).

---

## Fit Labels

| Range | Label | Interpretation for the founder |
|---|---|---|
| 80-100 | `strong` | You are exceptionally well-positioned for this idea. Your background, resources, and advantages align strongly with what this business needs. |
| 60-79 | `moderate` | Reasonable fit with addressable gaps. You can pursue this but should plan to fill specific weaknesses (hire for gaps, raise capital, build audience first). |
| 40-59 | `weak` | Significant mismatches between your profile and what this idea demands. Consider whether a different idea better leverages your strengths, or address blockers before starting. |
| 0-39 | `misaligned` | Fundamental incompatibilities. This idea likely requires capabilities, resources, or access that you don't have and can't easily acquire. Consider a different direction. |

---

## Output Schema

The fit assessment produces this object within the Synthesis `data`:

```json
{
  "founder_fit": {
    "available": true,
    "fit_score": 72,
    "fit_label": "moderate",
    "dimensions": {
      "domain_expertise_match": 15,
      "resource_sufficiency": 12,
      "risk_tolerance_alignment": 14,
      "network_distribution": 18,
      "execution_capability": 16,
      "asymmetric_advantage": 11
    },
    "fit_summary": "2-3 sentence summary connecting the founder's strengths and gaps to this specific idea",
    "fit_boosters": ["Specific advantage that helps this idea"],
    "fit_blockers": ["Specific gap or mismatch that hurts"],
    "adjusted_verdict_note": "How the market verdict should be interpreted for THIS specific founder"
  }
}
```

When no profile is available:
```json
{
  "founder_fit": {
    "available": false
  }
}
```

---

## Critical Rules

1. **The fit score does NOT change the verdict.** GO/PIVOT/NO-GO remains anchored to market reality. A misaligned founder doesn't make a good idea bad — it just means someone else might execute it better.
2. **The `adjusted_verdict_note` is the most valuable output.** It bridges the gap between "what the market says" and "what that means for you." Make it specific and actionable.
3. **Partial profiles produce partial fit assessments.** If a dimension can't be scored due to missing profile data, score it at the midpoint (10) and note "insufficient profile data for this dimension" in `fit_summary`. Flag `"partial-fit-assessment"` in Synthesis flags.
4. **Be honest about weaknesses.** A fit assessment that's all boosters and no blockers is useless. Every idea has at least one dimension where the founder is less than ideal.
5. **Connect dimensions to departments.** Don't just say "resource sufficiency: 8". Say "8/20 — BizModel estimates $200 CAC and 14-month payback, but founder has $10K and 12-month runway. Can acquire ~50 customers before needing revenue."

# Scoring Convention (shared across all HC departments)

## Design Principle

Every score in this system is computed as the **sum of measurable sub-dimensions**, not a subjective judgment. Each sub-dimension is anchored to observable, countable criteria that an AI agent doing web search can verify. This reduces score variance between executions to ±3-5 points instead of ±10+.

## Scale

All departments score on a **0-100 integer scale**. No decimals, no negatives.
Each score is the sum of its sub-dimensions (defined per department below).

## Universal Ranges

| Range | Label | Meaning |
|-------|-------|---------|
| 80-100 | **Strong** | Clear evidence supports a positive signal |
| 60-79 | **Moderate** | Signal is positive but with caveats or gaps |
| 40-59 | **Weak** | Signal is ambiguous, insufficient evidence, or mixed |
| 0-39 | **Critical** | Evidence is negative or absent |

---

## Department Sub-Scoring Rubrics

### Problem Validation — hc-problem (5 sub-dimensions × 20 points = 100)

#### 1. Complaint Volume (0-20)

Count of unique complaint threads, posts, or reviews mentioning the problem across Reddit, Hacker News, Twitter/X, G2, Capterra, Trustpilot, and niche forums. Each thread/post counts as 1; duplicate cross-posts from the same author count as 1.

| Points | Criteria |
|--------|----------|
| 0-5 | 0-5 unique complaint threads found across all sources |
| 6-10 | 6-20 unique complaint threads found |
| 11-15 | 21-75 unique complaint threads found |
| 16-20 | 76+ unique complaint threads found |

#### 2. Complaint Recency (0-20)

Percentage of **dated** complaints found in sub-dimension 1 that were posted within the last 24 months. Complaints whose date cannot be determined (not visible in snippet and page not fetchable) are excluded from both numerator and denominator — do not guess dates.

| Points | Criteria |
|--------|----------|
| 0-5 | <20% of complaints are from the last 24 months, OR all complaints are 3+ years old |
| 6-10 | 20-49% from the last 24 months |
| 11-15 | 50-79% from the last 24 months |
| 16-20 | 80%+ from the last 24 months, with at least some from the last 6 months |

#### 3. Pain Intensity Signals (0-20)

Count of urgency/desperation markers in complaint threads: profanity directed at the problem, words like "desperate"/"urgent"/"wasting hours"/"losing money", quantified time/money costs (e.g., "I spend 3 hours a week on this"), or explicit willingness-to-pay statements (e.g., "I would pay for something that...").

| Points | Criteria |
|--------|----------|
| 0-5 | 0-2 pain markers found; language is mild/observational |
| 6-10 | 3-10 pain markers; some frustration but no quantified cost or willingness-to-pay |
| 11-15 | 11-25 pain markers; at least 2 instances of quantified time/money cost OR willingness-to-pay |
| 16-20 | 26+ pain markers; 3+ quantified costs AND at least 1 explicit willingness-to-pay statement |

#### 4. Workaround Evidence (0-20)

Count of distinct workarounds people describe. A workaround = multi-step process, cobbled tool stack, manual process, spreadsheet/script, or misuse of adjacent tool. Each unique method counts as 1 (multiple people describing the same workaround = 1).

| Points | Criteria |
|--------|----------|
| 0-5 | 0-1 distinct workarounds described |
| 6-10 | 2-3 distinct workarounds; workarounds are simple (1-2 steps) |
| 11-15 | 4-6 distinct workarounds; at least 1 involves combining 2+ tools or significant manual effort |
| 16-20 | 7+ distinct workarounds; at least 2 involve multi-tool stacks, custom scripts, or processes called "painful"/"hacky" |

#### 5. Existing Paid Alternatives (0-20)

Count of products/services people currently pay for to address this problem (even partially). Must have observable pricing (free-only tools do not count). Identified via G2/Capterra listings, product websites with paid tiers, or mentions of paid tools in complaint threads.

| Points | Criteria |
|--------|----------|
| 0-5 | 0 paid alternatives found |
| 6-10 | 1-2 paid alternatives with fewer than 10 combined reviews on G2/Capterra/app stores |
| 11-15 | 3-5 paid alternatives with 10+ combined reviews, OR 1-2 with 50+ combined reviews |
| 16-20 | 6+ paid alternatives with reviews, OR 3+ paid alternatives each with 50+ reviews |

---

### Market Sizing — hc-market (4 sub-dimensions × 25 points = 100)

#### 1. Data Availability & Source Quality (0-25)

Count and quality of market sizing sources found: institutional reports (Gartner, Forrester, Statista, Grand View Research), government/census data, public company filings, VC/analyst posts with cited numbers, industry association reports.

| Points | Criteria |
|--------|----------|
| 0-6 | 0 quantified market size estimates found; sizing would be pure speculation |
| 7-12 | 1-2 estimates from non-institutional sources (blog posts, press releases without citations, or reports older than 3 years) |
| 13-18 | 3-5 estimates from at least 1 institutional source published within the last 3 years; estimates within 3x of each other |
| 19-25 | 6+ estimates from 2+ institutional sources published within the last 2 years; estimates converge within 2x |

#### 2. Market Scale — SOM (0-25)

Serviceable Obtainable Market value from the most conservative credible estimate. If only TAM is available, SOM is estimated as a percentage of TAM using this scale:

| TAM Size | SOM Default % | Rationale |
|----------|---------------|-----------|
| > $10B | 1% of TAM | Broad market — many segments, harder to capture meaningful share |
| $1B-$10B | 2-3% of TAM | Mid-size market — moderate competition for share |
| < $1B | 5% of TAM | Niche market — fewer players, easier to establish foothold |

| Points | Criteria |
|--------|----------|
| 0-6 | SOM < $1M OR no data available to estimate |
| 7-12 | SOM $1M-$10M |
| 13-18 | SOM $10M-$100M |
| 19-25 | SOM > $100M, supported by at least 2 independent source estimates |

#### 3. Growth Trajectory (0-25)

CAGR of the relevant market or closest parent market. If multiple CAGRs found, use median. If no CAGR but year-over-year figures exist, calculate implied rate.

| Points | Criteria |
|--------|----------|
| 0-6 | No growth data found, OR market declining (negative CAGR), OR CAGR < 3% |
| 7-12 | CAGR 3-9% (mature market, near GDP growth) |
| 13-18 | CAGR 10-24% (above-average, market expanding) |
| 19-25 | CAGR 25%+ from at least 1 institutional source (high-growth/emerging) |

#### 4. Early Adopter Identifiability (0-25)

Count of specific, targetable early adopter segments. A segment counts only if ALL three are observable: (a) a label/name for the group, (b) evidence they spend money on adjacent solutions, (c) at least one concrete channel to reach them (subreddit, community, conference, publication with measurable membership).

| Points | Criteria |
|--------|----------|
| 0-6 | 0 segments meeting all 3 criteria; target customer is vague ("businesses", "consumers") |
| 7-12 | 1 segment meeting all 3 criteria |
| 13-18 | 2-3 segments meeting all 3 criteria, with at least 1 channel having 1,000+ members |
| 19-25 | 4+ segments meeting all 3 criteria, channels totaling 10,000+ combined members |

---

### Competitive Intelligence — hc-competitive (5 sub-dimensions × 20 points = 100)

#### 1. Market Validation Signal (0-20)

Total competitors found: direct (same problem, similar solution), indirect (same problem, different approach), adjacent (different problem, similar tech that could pivot). From G2, Capterra, ProductHunt, Crunchbase, app stores.

| Points | Criteria |
|--------|----------|
| 0-5 | 0-1 total competitors found (may signal no market) |
| 6-10 | 2-5 competitors with at least 1 direct |
| 11-15 | 6-15 competitors with at least 2 direct and 2 indirect |
| 16-20 | 16+ competitors with clear mix of direct, indirect, and adjacent (validated active market) |

#### 2. Incumbent Weakness (0-20, INVERTED: weaker incumbents = higher score)

Observable traction of the STRONGEST competitor: Crunchbase funding, employee count, reviews, web traffic. Higher score means LESS entrenched competition = MORE opportunity.

**Strongest competitor selection**: Evaluate each direct competitor's traction signals and select the single most threatening one (the one that would score lowest on this rubric). If signals conflict across tiers (e.g., low funding but high review count), use the signal that places the competitor in the **lowest** tier — one dominant signal is enough to indicate entrenchment. See `hc-competitive/SKILL.md` Step 2 for the full selection protocol.

| Points | Criteria |
|--------|----------|
| 0-5 | Strongest competitor has >$50M funding OR 500+ employees OR 1000+ reviews OR is a public company (dominant incumbent) |
| 6-10 | Strongest competitor has $5M-$50M funding OR 50-500 employees OR 100-1000 reviews (established but not dominant) |
| 11-15 | Strongest competitor has <$5M funding OR 10-50 employees OR 10-100 reviews (moderate traction, no dominant player) |
| 16-20 | Strongest competitor has no known funding, <10 employees, <10 reviews (all early stage, wide open) |

**INVERSION SELF-CHECK (mandatory)**: After scoring, verify the direction: a score of 0-5 means "dominant incumbent exists, hard to compete" and MUST co-occur with the `"dominant-incumbent-found"` flag. A score of 16-20 means "no strong player" and MUST NOT co-occur with `"dominant-incumbent-found"`. If there is a contradiction, re-evaluate.

#### 3. Market Gap Evidence (0-20)

Count of specific unmet needs from competitor reviews (1-3 stars on G2/Capterra/app stores). A gap counts if mentioned by 2+ distinct reviewers across 1+ products.

| Points | Criteria |
|--------|----------|
| 0-5 | 0-1 gaps from reviews; users appear generally satisfied |
| 6-10 | 2-3 gaps; complaints are scattered across unrelated issues |
| 11-15 | 4-6 gaps; at least 2 are thematically related (suggesting an underserved niche) |
| 16-20 | 7+ gaps; at least 3 thematically related AND at least 1 mentioned by 10+ reviewers |

#### 4. Pricing Intelligence (0-20)

Count of competitors with discoverable pricing (from pricing pages, G2/Capterra, or review mentions).

| Points | Criteria |
|--------|----------|
| 0-5 | Pricing found for 0-1 competitors; market norms unknown |
| 6-10 | Pricing for 2-3 competitors, top-line only ("starts at $X/mo") |
| 11-15 | Pricing for 3-5 competitors with tier-level detail for at least 2 |
| 16-20 | Pricing for 6+ competitors with tier detail for at least 3; clear pricing band identifiable |

#### 5. Failure Intelligence (0-20)

Count of dead/failed competitors (Failory, CB Insights, Crunchbase "closed", dead ProductHunt links) PLUS churn signals from surviving competitors (reviews mentioning switching, cancellation threads).

| Points | Criteria |
|--------|----------|
| 0-5 | 0 dead competitors AND 0 churn signals found |
| 6-10 | 1-2 dead competitors OR 1-3 churn threads, no identifiable root cause |
| 11-15 | 3-5 dead with at least 1 readable post-mortem, OR 4-10 churn threads with identifiable reasons |
| 16-20 | 6+ dead with 2+ post-mortems AND 5+ churn threads; clear failure patterns extractable |

---

### Business Model — hc-bizmodel (4 sub-dimensions × 25 points = 100)

#### 1. LTV/CAC Ratio (0-25)

LTV = (benchmark ARPU from competitive pricing) × (industry retention rate from published benchmarks) × (estimated lifetime months). CAC = from industry benchmarks (ProfitWell, OpenView, KeyBanc reports).

| Points | Criteria |
|--------|----------|
| 0-6 | Cannot calculate (missing inputs), OR LTV/CAC < 1.0 |
| 7-12 | LTV/CAC 1.0-2.0; at least 1 input is an assumption, not a benchmark |
| 13-18 | LTV/CAC 2.1-4.0 with ARPU and CAC derived from found benchmarks |
| 19-25 | LTV/CAC > 4.0 with both inputs from 2+ found benchmarks each |

#### 2. Revenue Model Validation (0-25)

Count of successful companies (funded, profitable, or public) using the same revenue model for a similar customer segment.

| Points | Criteria |
|--------|----------|
| 0-6 | 0 successful companies found using this model for a similar segment |
| 7-12 | 1-2 in similar segment, OR 3+ in adjacent but not directly comparable segment |
| 13-18 | 3-5 in similar segment, at least 1 well-documented (case study, earnings data, press coverage) |
| 19-25 | 6+ in same segment; model is clearly the dominant approach with published conversion/retention benchmarks |

#### 3. Payback Period (0-25)

CAC / monthly gross margin. Gross margin = ARPU × estimated margin % (70-85% SaaS, 20-40% marketplace, etc. from industry benchmarks).

| Points | Criteria |
|--------|----------|
| 0-6 | Cannot calculate, OR payback > 24 months |
| 7-12 | Payback 13-24 months |
| 13-18 | Payback 7-12 months |
| 19-25 | Payback < 7 months, calculated with 2+ benchmark-derived inputs |

#### 4. Pricing Power (0-25)

How constrained is pricing based on competitive data: spread of competitor pricing, existence of premium players, free/freemium alternatives creating a floor.

| Points | Criteria |
|--------|----------|
| 0-6 | 3+ dominant free alternatives AND all paid competitors within narrow band (<2x spread) |
| 7-12 | 1-2 free alternatives, OR narrow paid band (<2x) with no premium breakout |
| 13-18 | Pricing spans 2x-5x range; at least 1 premium player at 3x+ median with positive reviews; 0-1 free alternatives |
| 19-25 | Pricing spans >5x; 2+ premium players with 4+ star reviews; no dominant free alternative; evidence of recent price increases without user revolt |

---

### Risk Assessment — hc-risk (4 sub-dimensions × 25 points = 100)

**INVERTED: 100 = lowest risk. Higher score = fewer/more mitigable risks.**

#### 1. Execution Feasibility (0-25)

Technical and operational feasibility: API availability, open-source components, talent availability, infrastructure costs.

| Points | Criteria |
|--------|----------|
| 0-6 | 2+ critical tech dependencies with no public API or working OSS implementation, OR infrastructure >$50K/month at MVP scale |
| 7-12 | 1 critical dependency with uncertain availability, OR core component requires build-from-scratch (no OSS/API) |
| 13-18 | All required tech has available APIs or OSS; no single point of failure; 100+ relevant job postings found |
| 19-25 | Core stack well-established with multiple redundant providers; similar architectures documented in public case studies; 1000+ relevant job postings |

#### 2. Regulatory & Legal (0-25)

Regulatory barriers, compliance requirements, enforcement actions, pending legislation.

**Industry-aware framework counting**: Not all regulatory frameworks are equal barriers. When counting frameworks for this rubric, distinguish between **barrier frameworks** and **navigable frameworks**:

| Framework type | Count as | Examples |
|----------------|----------|----------|
| **Barrier** | 1.0 | Novel regulation with no established compliance path, pending legislation with uncertain scope, frameworks requiring government licenses |
| **Navigable** | 0.5 | Frameworks with commercial compliance-as-a-service tools (e.g., Stripe for PCI-DSS, Vanta for SOC 2, compliance platforms for GDPR), well-documented self-serve compliance paths |

Use the **adjusted count** (sum of weighted frameworks) when mapping to tiers. This prevents penalizing industries like fintech where 3 navigable frameworks (PCI-DSS + KYC/AML + state licensing = adjusted 1.5) represent standard operating cost, not existential barriers.

**Industry-specific query templates**: When the idea's industry is known, add targeted regulatory queries:
- Fintech: `"{industry}" compliance cost OR "compliance as a service" OR "regulatory sandbox"`
- Healthtech: `"{industry}" FDA pathway OR "510(k)" OR HIPAA compliance tools`
- Edtech: `"{industry}" FERPA OR COPPA compliance`
- General SaaS: `"{industry}" SOC 2 OR GDPR OR "data processing agreement"`

| Points | Criteria |
|--------|----------|
| 0-6 | Adjusted framework count ≥ 3, OR active enforcement actions against competitors in last 2 years, OR pending legislation could restrict core value proposition |
| 7-12 | Adjusted framework count 1.5-2.5 with documented compliance pathways; no active enforcement |
| 13-18 | Adjusted framework count 0-1 with standard compliance pathways; commercial compliance tools available; no pending legislation |
| 19-25 | No specific regulatory requirements beyond standard business; no history of regulatory intervention; no pending legislation |

#### 3. Market Timing (0-25)

Too early, on time, or too late. Measured by Google Trends direction, competitor launch recency, investment activity.

| Points | Criteria |
|--------|----------|
| 0-6 | Google Trends declining over 24 months AND no new competitors in 18 months AND no recent VC investment (market may be dead) |
| 7-12 | Trends flat/slightly declining BUT at least 1 new competitor or 1 funding round in last 2 years (mixed signals) |
| 13-18 | Trends stable/growing AND 2-5 new competitors in last 18 months AND 2+ funding rounds in last 2 years |
| 19-25 | Trends 2x+ growth over 24 months AND 5+ new entrants in 18 months AND 3+ funding rounds last year AND major publication coverage |

#### 4. Dependency & Concentration (0-25)

Single-point-of-failure dependencies: platform lock-in, single distribution channel, single customer segment, regulatory status quo.

| Points | Criteria |
|--------|----------|
| 0-6 | 3+ critical dependencies, at least 1 is a platform with history of restricting access |
| 7-12 | 2 critical dependencies, at least 1 has an observable fallback; OR 1 with no fallback on a stable platform |
| 13-18 | 1 critical dependency with 2+ fallbacks; OR no platform dependency but moderate channel concentration |
| 19-25 | 0 critical dependencies; 2+ viable distribution channels; core tech on multiple interchangeable providers |

---

## Weighted Score (Synthesis)

Weights validated through simulation of 13 scenarios (84.6% accuracy vs 61.5% with equal-ish weights):

| Department | Weight | Rationale |
|------------|--------|-----------|
| Problem | 30% | Foundation — if no real pain exists, nothing else matters |
| Market | 25% | Ceiling — defines the upper bound of the opportunity |
| Competitive | 15% | Subordinate to Problem + Market; landscape matters but less than fundamentals |
| Business Model | 20% | Unit economics are make-or-break for sustainability |
| Risk | 10% | Meta-analysis; its real power is through knockout rules, not weight |
| **Total** | **100%** | |

**Formula**: `weighted_score = (Problem × 0.30) + (Market × 0.25) + (Competitive × 0.15) + (BizModel × 0.20) + (Risk × 0.10)`

## Decision Rules

### Automatic NO-GO (knockout)

Any of these triggers immediate NO-GO regardless of weighted score:
- `Problem < 40` — no evidence of real pain
- `Market < 40` — market too small or nonexistent
- `Risk < 30` — critical unmitigated risks
- Two or more department scores `< 45` — multiple weak fundamentals

### GO

ALL of the following must be true:
- `weighted_score >= 70`
- `Problem >= 60` — problem must be at least moderate for GO
- All other individual scores `>= 45`

### PIVOT

Everything that is neither NO-GO nor GO:
- Weighted score between 50-69 with no knockouts triggered
- OR weighted score ≥ 70 but Problem < 60
- OR weighted score ≥ 70 but one score between 40-44
- Pivot suggestions and alternative directions are generated

## Within-Tier Point Assignment

When a count or metric falls within a tier's range, use the **thirds rule** to assign points within that tier:

| Position within tier | Points | Guideline |
|----------------------|--------|-----------|
| Bottom third | Tier minimum + 0-1 | Count barely qualifies for this tier (just crossed the threshold) |
| Middle third | Tier midpoint | Count is solidly within the tier's range |
| Top third | Tier maximum - 0-1 | Count is near the next tier's threshold |

**Example** — Complaint Volume tier 6-10 (criteria: 6-20 threads):
- 6-9 threads → 6-7 points (bottom third — barely in tier)
- 10-14 threads → 8 points (middle third — solidly in range)
- 15-20 threads → 9-10 points (top third — approaching next tier)

**Boundary cases**: When a count falls exactly on a tier boundary, assign it to the tier it enters (e.g., exactly 6 threads = tier 6-10, assign 6 points). When evidence quality is mixed within a tier (e.g., 8 threads but 3 are borderline duplicates), round down within the tier.

## Score Reasoning Requirements

Every score MUST include reasoning that:
1. Lists each sub-dimension with its individual point value and the observable criteria that determined it
2. Shows the sum that produces the final department score
3. Explains any sub-dimension where the criteria fell between two tiers
4. Is structured as a breakdown table, not prose

**Bad**:
```
Score 72 because the market seems decent.
```

**Good**:
```
Score: 72/100
- Complaint Volume: 12/20 (14 unique threads found across Reddit and G2)
- Complaint Recency: 16/20 (85% from last 24 months, several from last 3 months)
- Pain Intensity: 14/20 (18 pain markers, 3 quantified costs, no explicit WTP statement)
- Workaround Evidence: 15/20 (5 distinct workarounds, 2 involving multi-tool stacks)
- Paid Alternatives: 15/20 (4 paid alternatives, 2 with 50+ reviews on G2)
Total: 12 + 16 + 14 + 15 + 15 = 72
```

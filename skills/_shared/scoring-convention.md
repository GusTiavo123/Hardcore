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

### Problem Validation — hc-problem (5 × 15 points + 1 × 25 points = 100)

Sub-dimensions 1-5 validate the **problem's existence and severity** (75 points total). Sub-dimension 6 validates whether the **proposed solution category has organic demand** (25 points). This structure ensures that a real problem with a zero-demand solution type scores in the moderate range (max 75), not the strong range.

#### 1. Complaint Volume (0-15)

Count of unique complaint threads, posts, or reviews mentioning the problem across Reddit, Hacker News, Twitter/X, G2, Capterra, Trustpilot, and niche forums. Each thread/post counts as 1; duplicate cross-posts from the same author count as 1.

| Points | Criteria |
|--------|----------|
| 0-3 | 0-5 unique complaint threads found across all sources |
| 4-7 | 6-20 unique complaint threads found |
| 8-11 | 21-75 unique complaint threads found |
| 12-15 | 76+ unique complaint threads found |

#### 2. Complaint Recency (0-15)

Percentage of **dated** complaints found in sub-dimension 1 that were posted within the last 24 months. Complaints whose date cannot be determined (not visible in snippet and page not fetchable) are excluded from both numerator and denominator — do not guess dates.

| Points | Criteria |
|--------|----------|
| 0-3 | <20% of complaints are from the last 24 months, OR all complaints are 3+ years old |
| 4-7 | 20-49% from the last 24 months |
| 8-11 | 50-79% from the last 24 months |
| 12-15 | 80%+ from the last 24 months, with at least some from the last 6 months |

#### 3. Pain Intensity Signals (0-15)

Count of urgency/desperation markers in complaint threads: profanity directed at the problem, words like "desperate"/"urgent"/"wasting hours"/"losing money", quantified time/money costs (e.g., "I spend 3 hours a week on this"), or explicit willingness-to-pay statements (e.g., "I would pay for something that...").

| Points | Criteria |
|--------|----------|
| 0-3 | 0-2 pain markers found; language is mild/observational |
| 4-7 | 3-10 pain markers; some frustration but no quantified cost or willingness-to-pay |
| 8-11 | 11-25 pain markers; at least 2 instances of quantified time/money cost OR willingness-to-pay |
| 12-15 | 26+ pain markers; 3+ quantified costs AND at least 1 explicit willingness-to-pay statement |

#### 4. Workaround Evidence (0-15)

Count of distinct workarounds people describe. A workaround = multi-step process, cobbled tool stack, manual process, spreadsheet/script, or misuse of adjacent tool. Each unique method counts as 1 (multiple people describing the same workaround = 1).

| Points | Criteria |
|--------|----------|
| 0-3 | 0-1 distinct workarounds described |
| 4-7 | 2-3 distinct workarounds; workarounds are simple (1-2 steps) |
| 8-11 | 4-6 distinct workarounds; at least 1 involves combining 2+ tools or significant manual effort |
| 12-15 | 7+ distinct workarounds; at least 2 involve multi-tool stacks, custom scripts, or processes called "painful"/"hacky" |

#### 5. Existing Paid Alternatives (0-15)

Count of products/services people currently pay for to address this problem (even partially). Must have observable pricing (free-only tools do not count). Identified via G2/Capterra listings, product websites with paid tiers, or mentions of paid tools in complaint threads.

| Points | Criteria |
|--------|----------|
| 0-3 | 0 paid alternatives found |
| 4-7 | 1-2 paid alternatives with fewer than 10 combined reviews on G2/Capterra/app stores |
| 8-11 | 3-5 paid alternatives with 10+ combined reviews, OR 1-2 with 50+ combined reviews |
| 12-15 | 6+ paid alternatives with reviews, OR 3+ paid alternatives each with 50+ reviews |

#### 6. Solution Category Demand (0-25)

Does the TARGET USER show organic pull toward the TYPE of solution the idea proposes? This sub-dimension validates that the demand stack is coherent — that the proposed solution modality has evidence of being wanted for this problem by this user.

**What to count:**
- **Positive demand signals**: People asking for, describing wanting, or expressing interest in this type of solution. Products on G2/ProductHunt in this category with actual users. Communities discussing this approach positively. Published studies showing adoption/interest.
- **Negative demand signals / adoption barriers**: Evidence that the target user resists or cannot use this type of solution. Published usability studies, rejection patterns, failed attempts at adoption.
- **Existing attempts**: Products or projects that tried this specific approach — whether successful, struggling, or dead.

**Net signal** = positive signals minus adoption barriers. Existing attempts count as positive unless they failed specifically due to lack of demand (vs. execution/funding failure).

| Points | Criteria |
|--------|----------|
| 0-6 | 0 positive demand signals found for this solution category among the target user; OR net signal is negative (more barriers than demand signals); OR all existing attempts failed due to lack of demand |
| 7-12 | 1-2 positive signals (someone mentioned wanting this, or 1 product exists with minimal traction); barriers exist but are not absolute; net signal is ambiguous |
| 13-18 | 3-5 positive signals; at least 1 existing product in this category with real users (reviews, downloads, revenue); barriers are navigable (documented mitigations exist); net signal is moderately positive |
| 19-25 | 6+ positive signals; 2+ products in this category with traction; target user community actively discusses/adopts this approach; minimal adoption barriers; net signal is clearly positive |

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

### Competitive Intelligence — hc-competitive (4 sub-dimensions × 25 points = 100)

#### 1. Market Validation Signal (0-25)

Total competitors found: direct (same problem, similar solution), indirect (same problem, different approach), adjacent (different problem, similar tech that could pivot). From G2, Capterra, ProductHunt, Crunchbase, app stores.

| Points | Criteria |
|--------|----------|
| 0-6 | 0-1 total competitors found (may signal no market, not opportunity) |
| 7-12 | 2-5 competitors with at least 1 direct |
| 13-18 | 6-15 competitors with at least 2 direct and 2 indirect |
| 19-25 | 16+ competitors with clear mix of direct, indirect, and adjacent (validated active market) |

#### 2. Wedge Opportunity (0-25)

How well does THIS IDEA exploit gaps in existing competitors? This is the most strategically important signal: "Given who is already here, can this specific idea carve out a defensible position?" Scoring uses the `market_gaps[]` array and evaluates alignment between identified gaps and the idea's value proposition.

A gap "aligns with the idea" if the idea's core approach would directly address the complaint. Partial alignment (idea might help but isn't focused on this gap) counts as 0.5.

| Points | Criteria |
|--------|----------|
| 0-6 | 0-1 gaps found from reviews, OR gaps exist but 0 align with the idea's value proposition |
| 7-12 | 2-3 gaps found, at least 1 aligns with the idea; complaints are scattered across unrelated issues |
| 13-18 | 4-6 gaps, at least 2 align with the idea and are thematically related (suggesting an underserved niche the idea can own) |
| 19-25 | 7+ gaps, at least 3 align with the idea and cluster thematically around the idea's value proposition, at least 1 gap mentioned by 10+ reviewers |

**Key distinction from old "Market Gap Evidence"**: This sub-dimension doesn't just count gaps — it evaluates whether THIS IDEA specifically exploits them. Two different ideas in the same market can (and should) receive different Wedge Opportunity scores.

#### 3. Incumbent Defensibility (0-25, inverted: higher = more opportunity)

How defensible is the strongest direct competitor's position? Measures **moat type and fragility**, not company size. A $500M company with no structural moat and churning customers is LESS defensible than a $5M company with strong network effects.

**Moat types (from most to least defensible):**
- **Structural**: Network effects, proprietary data lock-in, regulatory capture, platform exclusivity
- **Operational**: Switching costs, integration depth, long-term contracts, ecosystem lock-in
- **Soft**: Brand recognition, funding/scale advantage, first-mover, sales relationships

**Vulnerability signals**: Declining review sentiment, increasing churn threads, layoffs, strategic pivots away from the segment, acquisition by unfocused parent company, pricing complaints without alternatives.

**Product-level evaluation rule**: When the strongest direct competitor is a product/division within a multi-product company (e.g., SwaggerHub within SmartBear, Photomath within Google), evaluate the **product's** defensibility — its product-specific reviews, dedicated team size, product investment signals — not the parent company's overall size. A 1000-employee company with a neglected side product is LESS defensible than a 50-employee company whose entire business is the competing product.

| Points | Criteria |
|--------|----------|
| 0-6 | Strongest competitor has structural moats (network effects, data lock-in, regulatory capture) AND is executing well (growing reviews, stable/growing team, recent product investment) |
| 7-12 | Strongest competitor has operational moats (switching costs, integration depth) OR has structural moats but shows vulnerability signals (declining reviews, layoffs, acquired by unfocused parent, strategic pivot away from segment) |
| 13-18 | Strongest competitor's position is primarily funding/scale-based with no structural lock-in; evidence of customer dissatisfaction (churn threads, switching behavior) OR the idea targets a segment the incumbent is structurally moving away from (going upmarket, different geography, different customer size) |
| 19-25 | No competitor has defensible moats; existing competitors compete on execution/funding only; multiple competitors' customers actively seeking alternatives; OR market is pre-structural (too early for anyone to have built moats) |

**Consistency check**: A score of 0-6 means a structurally defended incumbent exists and MUST co-occur with the `"structural-moat-found"` flag. A score of 19-25 means no defensible moats and MUST NOT co-occur with `"structural-moat-found"`. If there is a contradiction, re-evaluate.

#### 4. Market Intelligence Quality (0-25)

How much actionable data is available for downstream departments (BizModel, Risk)? Combines pricing discoverability and failure/churn intelligence — both serve the same purpose: providing data inputs and signaling market maturity.

| Points | Criteria |
|--------|----------|
| 0-6 | Pricing found for 0-1 competitors AND 0 dead competitors AND 0 churn signals |
| 7-12 | Pricing for 2-3 competitors (top-line only) OR 1-2 dead competitors with no identifiable root cause OR 1-3 churn threads |
| 13-18 | Pricing for 3-5 competitors with tier detail for ≥2 AND (2+ dead competitors with ≥1 post-mortem OR 4+ churn threads with identifiable reasons) |
| 19-25 | Pricing for 6+ competitors with tier detail for ≥3, clear pricing band identifiable AND 3+ dead/failed with extractable failure patterns AND 5+ churn signals with identifiable causes |

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

**Example** — Complaint Volume tier 4-7 (criteria: 6-20 threads):
- 6-9 threads → 4-5 points (bottom third — barely in tier)
- 10-14 threads → 5-6 points (middle third — solidly in range)
- 15-20 threads → 6-7 points (top third — approaching next tier)

**Example** — Market Validation Signal tier 13-18 (criteria: 6-15 competitors):
- 6-8 competitors → 13-14 points (bottom third)
- 9-12 competitors → 15-16 points (middle third)
- 13-15 competitors → 17-18 points (top third)

**Boundary cases**: When a count falls exactly on a tier boundary, assign it to the tier it enters (e.g., exactly 6 threads = tier 4-7, assign 4 points). When evidence quality is mixed within a tier (e.g., 8 threads but 3 are borderline duplicates), round down within the tier.

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
- Complaint Volume: 9/15 (14 unique threads found across Reddit and G2)
- Complaint Recency: 12/15 (85% from last 24 months, several from last 3 months)
- Pain Intensity Signals: 10/15 (18 pain markers, 3 quantified costs, no explicit WTP statement)
- Workaround Evidence: 11/15 (5 distinct workarounds, 2 involving multi-tool stacks)
- Paid Alternatives: 11/15 (4 paid alternatives, 2 with 50+ reviews on G2)
- Solution Category Demand: 19/25 (4 products in category with traction, active community discussion, no adoption barriers)
Total: 9 + 12 + 10 + 11 + 11 + 19 = 72
```

**Score reasoning vs `data`**: Score reasoning documents the **WHY** (justification, evidence references, tier mapping). The `data` object documents the **WHAT** (structured fields consumed by downstream departments). Both must be complete — information that exists only in `score_reasoning` but not in `data` is invisible to downstream departments. After writing your score reasoning, cross-reference the Output Assembly Checklist in your SKILL.md to ensure every finding is also captured in the corresponding `data` field.

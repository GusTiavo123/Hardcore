# Scoring Convention (shared across all HC departments)

## Scale

All departments score on a **0-100 integer scale**. No decimals, no negatives.

## Universal Ranges

| Range | Label | Meaning |
|-------|-------|---------|
| 80-100 | **Strong** | Clear evidence supports a positive signal |
| 60-79 | **Moderate** | Signal is positive but with caveats or gaps |
| 40-59 | **Weak** | Signal is ambiguous, insufficient evidence, or mixed |
| 0-39 | **Critical** | Evidence is negative or absent |

## Department-Specific Rubrics

Each department applies these ranges to its domain:

### Problem Validation (hc-problem)

| Range | Criteria |
|-------|----------|
| 80-100 | Quejas frecuentes documentadas, workarounds costosos, urgencia demostrable |
| 60-79 | Problema real, algunas quejas, alternativas aceptables existen |
| 40-59 | Problema difuso, poca evidencia directa, puede ser nice-to-have |
| 0-39 | Sin evidencia de dolor real, soluciones existentes son suficientes |

### Market Sizing (hc-market)

| Range | Criteria |
|-------|----------|
| 80-100 | SOM > $50M, crecimiento > 15% anual, early adopters claros |
| 60-79 | SOM $10-50M, crecimiento moderado, segmentos identificables |
| 40-59 | SOM $1-10M, mercado estable o fragmentado |
| 0-39 | SOM < $1M o mercado en decline |

### Competitive Intelligence (hc-competitive)

Scoring is **opportunity-based** (high = more opportunity to differentiate):

| Range | Criteria |
|-------|----------|
| 80-100 | Pocos competidores, gaps claros, ningún dominante con moat |
| 60-79 | Competencia moderada, diferenciación posible |
| 40-59 | Mercado saturado pero gaps específicos identificables |
| 0-39 | Dominante claro con moat fuerte, sin gaps aparentes |

### Business Model (hc-bizmodel)

| Range | Criteria |
|-------|----------|
| 80-100 | LTV/CAC > 5x, payback < 6 meses, modelo probado en industria |
| 60-79 | LTV/CAC 3-5x, payback 6-12 meses, viable con ajustes |
| 40-59 | LTV/CAC 1-3x, payback > 12 meses, assumptions frágiles |
| 0-39 | LTV/CAC < 1x, insostenible |

### Risk Assessment (hc-risk)

Scoring is **inverted** (100 = lowest risk):

| Range | Criteria |
|-------|----------|
| 80-100 | Riesgos menores, todos mitigables, sin dependencias críticas |
| 60-79 | Algunos riesgos significativos pero mitigables |
| 40-59 | Riesgos importantes, mitigación requiere esfuerzo sustancial |
| 0-39 | Riesgos críticos sin mitigación clara |

## Weighted Score (Synthesis)

The synthesis department calculates a weighted score:

| Department | Weight |
|------------|--------|
| Problem | 25% |
| Market | 20% |
| Competitive | 20% |
| Business Model | 20% |
| Risk | 15% |
| **Total** | **100%** |

**Formula**: `weighted_score = Σ (department_score × weight)`

## Decision Rules

| Verdict | Condition |
|---------|-----------|
| **GO** | `weighted_score >= 70` AND no individual score < 40 |
| **PIVOT** | `weighted_score 50-69` OR exactly one score < 40 |
| **NO-GO** | `weighted_score < 50` OR two or more scores < 40 |

## Score Reasoning Requirements

Every score MUST include reasoning that:
1. References specific evidence (URLs, data points, quotes)
2. Maps to the rubric criteria for that range
3. Explains why the score is not higher or lower (the boundary argument)
4. Is at least 2-3 sentences

**Bad**: "Score 72 because the market seems decent."
**Good**: "Score 72. SOM estimated at $35M based on Grand View Research 2024 report, with 11% annual growth. Early adopters identified in the tech freelancer segment (500K+ potential users). Score is not higher because growth rate is below 15% threshold and SOM is mid-range."

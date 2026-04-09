# Synthesis — Upstream Field Map

This table maps every Synthesis output field to its exact upstream source path.

## Recovery Sources

| Source | Key fields | Used for |
|---|---|---|
| **Problem** | `score`, `executive_summary`, `flags`, `data.problem_exists`, `data.demand_stack`, `data.pain_intensity`, `data.target_user`, `data.industry`, `data.current_solutions`, `data.sub_scores` (especially `solution_category_demand`) | Knockout check, pain assessment, demand stack coherence, strengths/concerns |
| **Market** | `score`, `executive_summary`, `flags`, `data.som`, `data.market_stage`, `data.growth_rate`, `data.early_adopters` | Knockout check, opportunity sizing, early adopter channels for experiments |
| **Competitive** | `score`, `executive_summary`, `flags` (especially `"structural-moat-found"`, `"no-wedge-found"`), `data.market_gaps[].aligns_with_idea`, `data.pricing_benchmark`, `data.failed_competitors`, `data.direct_competitors[].moat_type`, `data.direct_competitors[].vulnerability_signals` | Multi-weakness check, wedge assessment, gaps for pivot suggestions, failure patterns |
| **BizModel** | `score`, `executive_summary`, `flags`, `data.unit_economics.ltv_cac_ratio`, `data.sensitivity_analysis` (check `viable` fields), `data.assumptions` | Multi-weakness check, financial strength/concern, assumption extraction |
| **Risk** | `score`, `executive_summary`, `flags` (especially `"knockout-risk"`), `data.overall_risk_level`, `data.top_3_killers`, `data.risks` | Knockout check, top killers become concerns, early_warning_signals feed experiments |

## Output Field → Source Mapping

| Synthesis output field | Source field path | Fallback if missing |
|---|---|---|
| `score_breakdown.problem.score` | Problem → `score` | 0 (triggers knockout) |
| `score_breakdown.market.score` | Market → `score` | 0 (triggers knockout) |
| `score_breakdown.competitive.score` | Competitive → `score` | 0 |
| `score_breakdown.bizmodel.score` | BizModel → `score` | 0 |
| `score_breakdown.risk.score` | Risk → `score` | 0 (triggers knockout) |
| `key_strengths` entries | Any dept → `data.sub_scores` entries in top tier | Omit if no dept data |
| `key_concerns` entries | Risk → `data.top_3_killers[]`; any dept → `flags`; BizModel → `data.sensitivity_analysis.*.viable == false` | Omit if no dept data |
| `critical_assumptions` entries | BizModel → `data.assumptions[]`; Market → `flags` containing `"som-is-estimate"`; Problem → `flags` containing `"evidence-mostly-unverified"` | Empty array |
| `pivot_suggestions[].direction` | Competitive → `data.market_gaps[].aligns_with_idea == true`; Market → `data.early_adopters[]`; Competitive → `data.failed_competitors[].reason_failed` | Generic suggestion |
| `validation_experiments[].channels` | Market → `data.early_adopters[].reachable_channels[]` | Omit channel detail |
| `validation_experiments[].signals` | Risk → `data.top_3_killers[].early_warning_signal` | Omit signal detail |
| `department_flags.*` | Each dept → `flags` | Empty array |

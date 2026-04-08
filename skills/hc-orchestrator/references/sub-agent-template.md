# Sub-Agent Launch Template

When launching each department as a sub-agent, use the **Agent tool** with this prompt template:

```
Read and follow these files exactly:
- skills/_shared/output-contract.md
- skills/_shared/scoring-convention.md
- skills/_shared/engram-convention.md
- skills/_shared/persistence-contract.md
- skills/_shared/department-protocol.md
- skills/_shared/glossary.md
- skills/_shared/profile-contract.md
- skills/hc-{department}/SKILL.md

For the data schema and assembly checklist, read:
- skills/hc-{department}/references/data-schema.md

Input:
{
  "idea": "{original idea text}",
  "slug": "{slug}",
  "persistence_mode": "{mode}",
  "detail_level": "{level}",
  "founder_context": {founder_context_json} or null
}

CRITICAL: Your `data` object must contain EVERY field from the data schema in your references/data-schema.md.
Cross-reference the Assembly Checklist before returning.
Missing fields break downstream departments.

If `founder_context` is not null, read `skills/_shared/profile-contract.md` for how to use it.
Founder context provides qualitative annotations only — it NEVER changes your scores.

Execute the full process defined in the SKILL.md and return the output envelope.
```

Each department needs **web search** capabilities. The sub-agent must use WebSearch and WebFetch tools to find real evidence.

**For Synthesis**, the template is the same except:
- Synthesis also reads: `skills/hc-synthesis/references/upstream-field-map.md`
- Synthesis also reads: `skills/hc-profile/references/fit-dimensions.md` (for Founder-Idea Fit scoring)
- Synthesis does NOT do web search (it synthesizes upstream data only)

## Envelope Validation (after each department)

After receiving output from each sub-agent, verify the envelope. Log violations as warnings but do NOT block the pipeline.

**Required checks:**
1. `status` is one of: `ok | warning | blocked | failed`
2. `schema_version` is present and equals `"1.1"`
3. `score` is an integer 0-100
4. `score_reasoning` is a non-empty string
5. `evidence` array has >= 3 entries when `status` is `ok` (except Synthesis)
6. `department` matches the expected department name
7. All top-level envelope fields present: `schema_version`, `status`, `department`, `executive_summary`, `score`, `score_reasoning`, `data`, `evidence`, `artifacts`, `flags`, `next_recommended`

If any check fails: "Warning: {department} output has schema violations: {list}". Pipeline continues.

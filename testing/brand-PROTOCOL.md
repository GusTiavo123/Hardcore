# Brand — Testing Protocol

Testing protocol for the Brand & Identity module. Parallel to `testing/PROTOCOL.md` (Validation) but adapted to Brand's qualitative nature.

---

## Purpose

Validate that Brand produces correct, robust, and usable outputs — with honesty about what's objectively measurable and what's not.

---

## The Fundamental Challenge

Validation has easily verifiable outputs (scores, verdicts, knockouts). **Brand does not**. There's no objective threshold for "good brand" equivalent to "Problem ≥ 40". Consequently:

- **No numeric quality knockouts** in Brand
- **No "≥ 7.5/10" shipping gate**
- **Shipping criterion is founder approval** — the founder/CEO reviews the output and decides
- **Automatable: structural (envelope complete, binary coherence gates pass/fail, files parseable)**
- **Subjective: tracked qualitatively** (failure modes in plain language, not scores)

This is a conscious decision: faking a numeric gate where reality is subjective creates false confidence. We prefer honesty.

---

## 6-Layer Testing Strategy

1. **Structural tests** (automated) — outputs complete + schema-conforming
2. **Coherence gate tests** (automated, binary) — 9 gates pass or fail; this IS objective
3. **Scope-appropriateness tests** (semi-automated) — outputs match brand profile
4. **Claude Design compatibility tests** (manual) — PDF parseable by Claude Design downstream
5. **Qualitative review** (founder/CEO) — shipping criterion. No numeric score.
6. **Regression tests** (automated) — Brand doesn't break Validation/Profile

Run-to-run variance is tracked as data, not as a gate — useful for instability detection, but does not block shipping.

---

## Test Suite

`brand-suite.yaml` defines 8 curated ideas, one per canonical brand profile.

**Dogfooding subset** (initial runs): `brand-test-b2b-smb`, `brand-test-b2c-consumer-app`, `brand-test-b2local-service`. The other 5 run when real cases appear or during full coverage pass.

---

## Prerequisites

1. Repo cloned, `bash scripts/setup.sh` completed.
2. Engram MCP running.
3. open-websearch MCP available.
4. Domain MCP installed (`uvx --from imprvhub/mcp-domain-availability domain-mcp`). Configured in `.mcp.json`.
5. Unsplash API key registered (free demo tier OK) + configured in env (`UNSPLASH_ACCESS_KEY`).
6. Claude Pro subscription (required — pre-flight gate).
7. Validation run completed for the target idea.
8. Profile optional (run tests both with and without profile for coverage).

---

## Running a Brand Test

### Step 1 — Pick an idea

Pick from `brand-suite.yaml`. Start with the dogfooding subset.

### Step 2 — Run Brand

Normal mode:
```
brandea esta idea: {paste idea text from suite}
```

Fast mode (for regression):
```
/brand:fast {idea text}
```

### Step 3 — Export run results

After completion, export to `testing/brand-runs/{date}_{machine}_{idea-id}/` with:
- `scope.json`, `strategy.json`, `verbal.json`, `visual.json`, `logo.json`, `handoff.json`, `final-report.json` (full envelopes from Engram)
- `test-results.yaml` (automated checks Cat 1-3, 5, 7)
- `claude-design-compatibility.md` (manual Cat 4 results)
- `human-review.md` (qualitative Cat 6)

Filesystem artifacts go to `output/{slug}/brand/` (package itself, not duplicated here — only referenced).

### Step 4 — Run automated checks (Cat 1-3, 5, 7)

See "Test Categories" below. Record results in `test-results.yaml` with pass/fail per item.

### Step 5 — Run Claude Design compatibility (Cat 4, manual)

1. Upload `brand-design-document.pdf` to Claude Design "Set up your design system".
2. Verify extracted design system matches:
   - Colors → `visual.palette` HEX
   - Typography → `visual.typography` families
   - Logo → `logo.variants.primary`
3. Create a test project: "Create a simple 1-page site for {Brand Name} using my brand". Verify output matches expectations.
4. Paste a prompt from Prompts Library into a new Claude Design project. Verify output matches brand.
5. Record in `claude-design-compatibility.md`.

### Step 6 — Qualitative review (Cat 6)

Founder/CEO fills `human-review.md` (see `brand-human-review-template.md`).

### Step 7 — Commit run

```
git add testing/brand-runs/{date}_{machine}_{idea-id}/
git commit -m "brand test: {idea-id} — {verdict}"
```

Append entry to `testing/brand-runs/REGISTRY.md`.

---

## Test Categories

### Category 1 — Unit tests per dept (structural, automated)

Per dept, verify the envelope is schema-valid and data-complete per the dept's `references/data-schema.md` Assembly Checklist.

**Scope Analysis**:
- [ ] Clear B2B SaaS → `b2b-smb` confidence ≥ 0.8
- [ ] Clear consumer mobile app → `b2c-consumer-app` confidence ≥ 0.8
- [ ] Hybrid B2D + community → primary + secondary with composition_weights
- [ ] Ambiguous → `requires_user_confirmation: true`
- [ ] Local service → `b2local-service`
- [ ] No profile → `decided_without_profile: true`
- [ ] User override respected
- [ ] Envelope schema-valid

**Strategy**:
- [ ] B2B SaaS + Sage-compatible profile + trust_heavy → Sage
- [ ] Consumer app + Explorer profile + disruption_ready → Explorer
- [ ] No profile → weight redistribution works
- [ ] Same input 2 runs → archetype consistent (variance tracking)
- [ ] Voice attributes derived from archetype + register
- [ ] Sentiment landscape derived for various market contexts
- [ ] Voice precedence conflict resolved correctly with flag
- [ ] Envelope schema-valid

**Verbal**:
- [ ] 15-20 initial candidates → 10-12 verified → top 5-7 presented
- [ ] TM red candidates excluded from top
- [ ] Scope b2b-smb prefers descriptive
- [ ] Scope b2c-consumer-app prefers short/memorable
- [ ] Scope b2b-enterprise generates pitch deck cover copy, NOT TikTok bio
- [ ] Voice self-check: assets exhibit voice detectably
- [ ] Domain MCP integration functional
- [ ] TM screening via open-websearch functional
- [ ] Graceful degradation when Domain MCP / open-websearch down
- [ ] Envelope schema-valid

**Visual**:
- [ ] Archetype Sage + formality medium → conservative palette (sat 40-60)
- [ ] Archetype Jester + formality low → vibrant palette
- [ ] WCAG contrast auto-adjust works
- [ ] Typography pairing matches archetype + era
- [ ] Unsplash mood refs work (with attribution)
- [ ] Graceful degradation when Unsplash down
- [ ] Envelope schema-valid

**Logo**:
- [ ] `wordmark-preferred` → 4 valid SVG wordmarks
- [ ] `combination` → wordmark + geometric mix
- [ ] `symbolic-first` → 3 geometric + 1 combination
- [ ] `icon-first` (consumer-app) → 4 marks pass 16px legibility
- [ ] Variants mono/inverse/icon-only preserve structure
- [ ] Derivations render from SVG source
- [ ] `app_asset_criticality: primary` → full iOS + Android set
- [ ] User manual upload path works
- [ ] Rasterization tool absent → SVG-only delivery + manual instructions
- [ ] Envelope schema-valid

**Handoff Compiler**:
- [ ] Brand Design Document PDF generated, page range correct per profile
- [ ] Prompts Library markdown valid, prompts customized
- [ ] Brand Tokens: JSON/CSS/Tailwind/HTML parseable + valid
- [ ] Reference Assets folder structured per scope
- [ ] README.md accurate regarding includes/skips
- [ ] AUDIT.md full trace of 9 gates + flags + timestamps
- [ ] Envelope schema-valid

### Category 2 — Coherence gate tests (automated, binary)

Inject specific inputs to validate each gate's halt behavior:

- [ ] G0: Outlaw + trust_heavy → halt with user surface
- [ ] G0: sentiment insufficient_data → skipped, user decides
- [ ] G1: Outlaw + risk_tolerance=conservative → halt
- [ ] G1: no profile → skipped_no_profile (pass)
- [ ] G2: voice "playful" + archetype Sage → halt
- [ ] G3: palette neon + archetype Sage → halt
- [ ] G4: palette avg sat 85 + formality=high → halt
- [ ] G5: display script + archetype Ruler → halt
- [ ] G6: logo contrast 3.2:1 → halt (WCAG fail)
- [ ] G7: copy 60% voice compliance → halt
- [ ] G8: wordmark chosen + scope symbolic-first → halt
- [ ] User re-runs dept → gates re-evaluate from scratch, consistent pass
- [ ] User accepts with flag → flag persisted in AUDIT.md + brand book
- [ ] Criticality matrix influences escalation UI (correct tone per profile)

### Category 3 — Scope-appropriateness tests

Verify each scope produces appropriate outputs:

- [ ] b2b-enterprise → pitch deck prompt, case study, security page
- [ ] b2b-smb → pricing page, LinkedIn bio, email welcome
- [ ] b2d-devtool → GitHub README, docs landing, code snippet styling
- [ ] b2c-consumer-app → app store listing, Instagram templates, full app icon set
- [ ] b2c-consumer-web → Instagram templates, newsletter, referral copy
- [ ] b2local-service → WhatsApp templates, GMB copy, flyer
- [ ] content-media → podcast cover, newsletter, social post series
- [ ] community-movement → manifesto opening, symbolic assets, Discord branding
- [ ] No profile includes outputs from another profile inappropriately (e.g., b2b-enterprise has no TikTok bio)

### Category 4 — Claude Design compatibility (manual)

**Requires Claude Pro subscription + active claude.ai/design account.**

- [ ] Brand Design Document PDF uploads without errors
- [ ] Claude Design extracts design system correctly (colors, typography, logo)
- [ ] Test project produces brand-consistent output
- [ ] Prompts Library prompts produce brand-matching deliverables in Claude Design
- [ ] Brand Tokens folder is linkable as codebase (if user tests this path)
- [ ] Reference Assets uploadable as visual references

**Automated file checks**:
- [ ] PDF not corrupt (opens in standard PDF readers)
- [ ] PDF has all required sections per brand profile
- [ ] Prompts Library structurally correct (goal + layout + content + audience per prompt)
- [ ] Each prompt customized with brand name, palette HEX, voice

### Category 5 — Integration tests (end-to-end)

- [ ] Dogfood: Brand for Hardcore itself produces coherent brand
- [ ] 3 dogfooding subset ideas end-to-end
- [ ] Cross-dept data flow: Strategy → Verbal + Visual → Logo → Handoff
- [ ] Visual palette applied in Logo SVGs
- [ ] Everything integrated in Handoff brand-tokens (colors, fonts, spacing)
- [ ] Engram topic keys + filesystem paths consistent
- [ ] User cancel mid-run → `/brand:resume` recovers
- [ ] Soft failure (e.g., Unsplash down) → package delivered partial with correct flags
- [ ] `/brand:extend {dept}` → regenerates only that dept, coherence re-eval, versioning increments

### Category 6 — Qualitative review (founder/CEO)

Shipping criterion. Uses `brand-human-review-template.md`. Not a numeric gate.

Multiple reviews accumulate into a failure-modes list that guides module iteration — plain language, not scores.

### Category 7 — Regression tests (automated)

- [ ] Validation existing tests pass
- [ ] Profile existing tests pass
- [ ] Engram reads/writes consistent (no cross-module contamination)
- [ ] Shared contracts respected (output-contract.md, engram-convention.md, brand-contract.md)

---

## Aggregated Reporting

`testing/analysis/brand-coverage.md`:
- Profiles tested (which of the 8 suite ideas have runs)
- Failure modes encountered (plain language, cumulative)
- Observed patterns (what consistently breaks, what works)
- Coverage gaps
- Variance observations (archetype consistency, palette family consistency across runs)

---

## Phase Gates

### Pre-Sprint 1 gate
- [ ] Plan files complete and consistent
- [ ] User approved plan
- [ ] `brand-contract.md` written
- [ ] Tool stack setup (Engram, open-websearch, Domain MCP, Unsplash API key, PDF skill)
- [ ] Claude Pro account available for testing

### Sprint 1 → dogfooding gate
- [ ] All 5 depts + Scope Analysis functional end-to-end
- [ ] 3 dogfooding profiles testable with ≥ 1 run
- [ ] Founder approves at least 1 run end-to-end
- [ ] Hardcore self-brand functional
- [ ] Brand Design Document tested in Claude Design account (design system extracts OK)
- [ ] 9 coherence gates working (automated tests pass)
- [ ] Failure modes tested (Engram down → hard halt; Unsplash down → skip; etc.)

### Dogfooding → full coverage gate
- [ ] All 8 brand profiles run at least once with founder approval
- [ ] Claude Design compatibility verified for all 8 profiles
- [ ] 0 critical failure modes unhandled (hard halts surface; soft degrades flag)
- [ ] `brand-contract.md` stable (no changes in last 2 dogfooding runs)
- [ ] Module documentation complete (SKILL.md + references per dept)

---

## Acceptance Criteria (production-ready)

- [ ] Cat 1 unit tests pass for all 5 depts + Scope Analysis
- [ ] Cat 2 coherence gate injection tests pass
- [ ] Cat 3 scope-appropriateness confirmed for 3 dogfooding profiles
- [ ] Cat 4 Claude Design compatibility confirmed for ≥ 3 profiles
- [ ] Cat 5 end-to-end integration runs successful for 3 profiles
- [ ] Cat 6 founder marks ≥ 3 runs as "ship" or "ship with minor adjustments"
- [ ] Cat 7 regression tests pass
- [ ] Hardcore self-dogfood approved and used in real launch

Post-"production-ready", the module evolves via real user feedback, not synthetic scores.

---

## Calibration (deferred)

Validation has 13 calibration scenarios. Brand equivalent (10 coherence-focused scenarios — one+ per gate) is deferred to post-dogfooding. First run real cases to see which failure modes appear in practice, then build synthetic scenarios for gap coverage.

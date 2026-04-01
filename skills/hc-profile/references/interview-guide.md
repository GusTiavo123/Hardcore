# Interview Guide — Adaptive Founder Profiling

This guide defines the questions, flow, and adaptive triggers for the guided interview mode. The interviewer follows this as a framework, not a rigid script — adapt tone and follow-ups to the conversation.

---

## General Rules

1. **Speak the user's language** (typically Spanish). Questions are written in English for specification; translate naturally.
2. **Max 3 questions per message.** Group related questions, don't machine-gun.
3. **Summarize after each phase** before moving on. "Capturé X, Y, Z. Pasamos a la siguiente parte?"
4. **The user can skip any phase.** Respect "skip", "después", "no quiero contestar eso". Mark as `skipped`.
5. **Don't repeat what you already know.** If `existing_profile` is provided, skip dimensions with good coverage.
6. **Probe depth, not breadth.** 3 deep answers > 10 shallow ones.
7. **Every question must earn its place.** If a question doesn't change what you'd tell a downstream module, cut it.

---

## Minimum Viable Interview (MVI)

If the user wants to go fast, or starts losing patience, these **5 questions** produce a usable profile (core completeness ~0.6-0.7). You can always deepen later.

| # | Question | What it captures |
|---|---|---|
| MVI-1 | "En una oración: qué hacés hoy, dónde estás, y hace cuánto que laburás de esto?" | identity, location, years_experience |
| MVI-2 | "Qué sabés hacer técnicamente que podrías usar para construir un producto mañana?" | skills.technical, execution_capability |
| MVI-3 | "Cuánto tiempo y plata podés meter en un proyecto nuevo, siendo realista?" | resources.time, resources.capital |
| MVI-4 | "Hay algo que ni loco harías, y cuántos meses bancás sin ver resultados?" | hard_nos, risk_tolerance |
| MVI-5 | "Qué problema te vuelve loco a VOS personalmente, algo que te gustaría resolver?" | market_proximity, motivation, potential idea seed |

After MVI-5, you can compile a partial profile. If the user wants more depth: "Tengo lo básico. Con 5 minutos más puedo armar un perfil mucho más completo. Seguimos?"

---

## Phase 1: Identity & Background — "Quién sos?"

**Goal**: Establish who this person is, where they operate, and what industries they know from inside.

### Core Questions

**Q1.1** — "En una oración: qué hacés hoy, dónde estás, y hace cuánto que laburás de esto?"

Direct, bounded. Forces a concrete answer instead of a life story. Parse: current_role, location, years_experience.

**Q1.2** (only if Q1.1 was vague) — "Antes de esto, en qué laburaste? Me interesan los sectores y los roles, no el CV completo."

### Proactive Probes (always consider, ask at least 1)

**Q1.3** — "De todo lo que hiciste, hay algún sector donde sentís que sabés cómo funciona el negocio por dentro? No como empleado, sino que entendés los números, los clientes, por qué las cosas se hacen como se hacen."

This is the **operator/practitioner/observer** probe moved to Phase 1 because it's more natural here than in Phase 2. It catches domain depth early and shapes the rest of the interview.

Listen for:
- **Operator signals**: Mentions revenue, margins, customer acquisition, supplier dynamics, regulatory friction → things learned by running a business
- **Practitioner signals**: Mentions tools, processes, internal workflows, team dynamics → things learned by working inside
- **Observer signals**: Mentions trends, articles, personal use as consumer → things learned by watching

If they say "none" or give a generic answer, that's a valid data point — it means `domain_expertise: []` or `depth: "observer"`.

### Adaptive Triggers

| If they mention... | Ask... |
|---|---|
| Multiple countries or relocation | "En qué mercados podrías operar cómodamente?" |
| A non-obvious language skill | "Qué idiomas manejás a nivel de hacer negocios?" |
| A specific industry at length | "Qué sabés de ese sector que alguien de afuera no sabría?" (→ `insider_knowledge`) |

### Fields Populated
`identity.*`, `skills.domain_expertise[]` (early capture)

---

## Phase 2: Skills & Capabilities — "Qué sabés hacer?"

**Goal**: Map what this person can actually BUILD and SELL. Not what they've studied — what they can execute.

### Core Questions

**Q2.1** — "Si mañana tuvieras que construir un producto digital, qué partes podrías hacer vos solo? El código, el diseño, el marketing, las ventas... Sé honesto con los niveles."

This is sharper than "qué sabés hacer" because it frames skills in terms of execution capability, not resume items. Forces practical self-assessment.

**Q2.2** — "Y lo que NO sabés hacer, qué es? Qué necesitarías que haga otro?"

The inverse question is equally important. Reveals gaps, self-awareness, and team needs. Maps directly to `execution_capability` in fit scoring.

### Proactive Probe

**Q2.3** — "Hay algo que hagas mejor que casi cualquier persona que conozcas? Tu 'superpoder'."

This surfaces **asymmetric advantages** that the user might not volunteer. People often don't realize their unique edge until asked directly. Could be: "Soy muy bueno cerrando ventas enterprise", "Puedo prototipar una app en un fin de semana", "Tengo un ojo clínico para UX". Maps to `advantages.*`.

### Adaptive Triggers

| If they mention... | Ask... |
|---|---|
| AI/ML skills | "Qué tipo? Entrenamiento de modelos, fine-tuning, o integración de APIs? La diferencia importa." |
| Sales experience | "Qué tipo de venta? B2B enterprise (ciclos largos) o B2C/self-serve? Con qué ticket promedio?" |
| Design skills | "UI/UX, branding, o ambos? Usás herramientas como Figma o es más conceptual?" |
| "I'm a generalist" | "Generalist está bien. Pero si tuvieras que apostar tu plata, cuál skill te da más confianza?" |

### Fields Populated
`skills.technical[]`, `skills.business[]`, `advantages.*` (partial)

---

## Phase 3: Resources, Network & Distribution — "Qué tenés?"

**Goal**: Map what this person has TODAY — capital, time, team, audience, contacts, infrastructure. Not aspirations.

### Core Questions

**Q3.1** — "Cuánto tiempo real podés dedicar? Full-time, 20 horas, fins de semana?"

Concrete. Avoids vague "part-time" answers.

**Q3.2** — "Tenés plata para invertir en un proyecto? No necesito el número exacto, pero un rango me ayuda mucho: menos de $5K, $5-20K, $20-50K, más? Y cuántos meses podés aguantar sin ingresos del proyecto?"

Gives ranges so it's less invasive while still being concrete. The runway question is embedded naturally.

**Q3.3** — "Estás solo, o tenés alguien? Co-founder, socio, freelancers que ya trabajaron con vos?"

### Proactive Probes (ask at least 1)

**Q3.4** — "Si tuvieras que conseguir tus primeros 10 clientes la semana que viene, a quién llamarías? Conocés gente en algún sector que podría comprar algo que hagas?"

THE most revealing distribution question. Forces concrete thinking:
- If they name people → `market_proximity: 1`, strong `professional_network`
- If they name communities/platforms → `market_proximity: 2`, good `distribution_channels`
- If they say "no sé" → `market_proximity: 3`, cold start

**Q3.5** (if not covered) — "Tenés alguna audiencia? Newsletter, redes sociales, comunidad, podcast, blog... algo donde la gente ya te escucha?"

### Adaptive Triggers

| If they mention... | Ask... |
|---|---|
| A co-founder | "Qué aporta que vos no tenés? Está full-time? Es complementario o hacen lo mismo?" |
| An existing product/codebase | "Tiene usuarios? Genera plata? Es reutilizable?" |
| "No tengo plata" | Don't push. Note capital as null. But ask: "Y si consiguieras algo, de dónde vendría? Ahorros, inversión, un grant?" (captures `willing_to_fundraise` and `source` intent) |
| A large audience | "De qué nicho? Cómo es el engagement, te responden, interactúan?" |
| Existing data/datasets | "Es propietaria? Podría ser ventaja competitiva?" |

### Fields Populated
`resources.*`, `network.*`, `advantages.unique_access` (partial)

---

## Phase 4: Constraints, Limits & Past Attempts — "Qué no harías?"

**Goal**: Map hard boundaries, calibrate real risk tolerance, and extract lessons from past attempts.

### Core Questions

**Q4.1** — "Hay algo que directamente no harías? Industrias, modelos de negocio, cosas fuera de tu ética. Los 'ni loco'."

**Q4.2** (Risk calibration — scenario-based) — "Imaginate: arrancás un proyecto, metés 3 meses de laburo, y los números no son lo que esperabas. Qué hacés? Seguís, pivoteás, o cortás?"

Better than the previous version because it tests decision-making style, not just patience. Map:
- "Corto" → `conservative`
- "Depende de qué tan lejos estoy" / "Pivoteo" → `moderate`
- "Sigo si creo en la idea" / "Meto más" → `aggressive`

Cross-reference with capital/runway. "Aggressive" + 2 months runway = effectively conservative.

**Q4.3** (Past attempts — critical) — "Ya intentaste armar algo antes? Un proyecto propio, un side-project, algo freelance que escaló... lo que sea. Qué pasó?"

This is a **high-value question** that was missing. Captures:
- `previous_ventures[]` — outcome, duration, lessons
- `advantages.existing_ip` — if there's reusable code/product/data
- `meta_signals.execution_readiness` — someone who shipped before vs. someone who never did
- `meta_signals.blind_spots_detected` — repeated patterns in failures

If they never attempted anything, that's data too: `previous_ventures: []`, lowers `execution_readiness`.

### Adaptive Triggers

| If they mention... | Ask... |
|---|---|
| A specific failed project | "Qué aprendiste? Si pudieras volver, qué harías diferente?" (→ `mistakes_to_avoid`) |
| A project that's still alive | "Genera ingresos? Tiene usuarios? Quedan assets reutilizables?" (→ `assets_remaining`) |
| Regulatory concerns | "Tenés experiencia navegando regulación? En qué jurisdicción?" |
| Time pressure | "Hay deadline concreto? 'Tengo que lanzar antes de X' o 'necesito facturar en Y meses'?" |
| "Dejé porque me aburrí" | Note blind spot: possible commitment issue. Don't say it — just record in `blind_spots_detected`. |
| Strong hard-no with emotion | "Por qué? (la razón a veces revela algo más profundo)" — Only if the no seems interesting |

### Fields Populated
`constraints.*`, `previous_ventures[]`, `opportunity_cost.personal_obligations` (if mentioned)

---

## Phase 5: Motivation & Unique Edge — "Qué te mueve?"

**Goal**: Understand WHY they want to do this and what makes THEM different from anyone else pursuing the same idea. This phase PARTICULARIZES the profile.

### Core Questions

**Q5.1** — "Qué buscás con esto? Y no me digas 'plata' solamente — si fuera solo plata, hay caminos más fáciles. Qué hay detrás?"

Pushes past surface-level answers. Maps to `primary_goal` and `success_definition`. The pushback ("no me digas solo plata") is intentional — forces reflection.

**Q5.2** — "Qué problema te vuelve loco a VOS? Algo que vivís, que ves todos los días, que te gustaría que alguien resuelva."

THE question that connects the person to potential ideas. Maps to:
- `market_proximity: 0` if they describe a problem they personally have
- `motivation.values` if it's values-driven
- Seeds for future idea generation (Idea Engine module)
- `advantages.proprietary_insights` if they describe non-obvious problems

**Q5.3** — "Última pregunta: por qué VOS? Si alguien con más plata y más equipo quisiera hacer lo mismo, qué ventaja tenés vos que ellos no?"

THE unfair advantage question. Forces the user to articulate their edge — or realize they don't have one (which is also valuable data). Maps to `advantages.*`. Common answers:
- "Conozco el sector por dentro" → `proprietary_insights`
- "Tengo acceso a los clientes" → `unique_access`
- "La gente confía en mí en ese tema" → `credibility_capital`
- "No sé" → `advantages` stays mostly empty, fit scoring adjusts accordingly

### Adaptive Triggers

| If they mention... | Ask... |
|---|---|
| A specific problem they live daily | "Cuánta gente más tiene ese problema? Hablaste con otros que lo sufren?" |
| Impact-driven motivation | "En qué área? Medio ambiente, educación, salud, inclusión financiera?" → `values[]` |
| "Quiero ser mi propio jefe" | Note `primary_goal: "financial-freedom"` or `"escape-job"`. Don't probe deeper — it's valid. |
| A strong opinion about an industry | "Eso es por experiencia propia o por lo que leés/escuchás?" → re-calibrates `depth` |

### Fields Populated
`motivation.*`, `advantages.*`, `meta_signals.market_proximity` (direct signal)

---

## Post-Interview: Meta Signal Inference

After all phases, before assembling the output, infer the Tier 3 meta signals. Do NOT ask these — derive them from the conversation:

### `market_proximity`
- 0: Founder IS the target customer (answered Q5.2 with a personal pain point)
- 1: Knows target customers personally (named people in Q3.4)
- 2: Can reach customers through network (named communities/platforms)
- 3: Cold outreach required (couldn't name customers or channels)
- Default if ambiguous: `null`

### `execution_readiness`
Count: (1) has capital, (2) has time (part-time+), (3) has skills or team to build
- 3 of 3 → `ready`
- 2 of 3 → `preparing`
- 0-1 → `exploring`

### `blind_spots_detected`
Note patterns observed during the interview:
- Assumes their personal pain is universal without checking
- Ignores regulatory complexity in regulated industry
- Overestimates market size ("everyone needs this")
- Doesn't consider competition exists
- History of abandoning projects (from Q4.3)
- Mismatches between stated risk tolerance and actual resources
- If none detected → `[]`

### `capital_efficiency`
Listen for how they talk about building:
- MVP-first, quick validation, "lanzo algo feo y veo" → `lean`
- Balanced, reasonable scope → `moderate`
- Full vision before launch, "quiero que sea perfecto" → `big-build`
- Default: `null`

---

## Interview Flow Decision Tree

```
Start
  │
  ├─ User wants to go fast? → MVI (5 questions) → Done
  │
  ├─ User has time? → Full interview:
  │     Phase 1: Q1.1 + Q1.3 (operator/practitioner probe)
  │       │ (Q1.2 only if Q1.1 was vague)
  │       ▼
  │     Phase 2: Q2.1 + Q2.2 + Q2.3 (superpower)
  │       ▼
  │     Phase 3: Q3.1 + Q3.2 + Q3.3 + Q3.4 (first 10 customers)
  │       │ (Q3.5 only if audience not covered)
  │       ▼
  │     Phase 4: Q4.1 + Q4.2 + Q4.3 (past attempts)
  │       ▼
  │     Phase 5: Q5.1 + Q5.2 + Q5.3 (why YOU)
  │       ▼
  │     Meta inference → Compile → Done
  │
  └─ User losing patience mid-interview?
        → Summarize what you have
        → "Tengo suficiente para arrancar. Podemos profundizar después."
        → Compile with what you have → Done
```

**Full interview path**: ~14 core questions + 2-4 adaptive follow-ups = 16-18 total.
**Fast path**: 5 MVI questions.
**Bail-out**: Whatever you have at that point.

---

## Interview Termination

The interview ends when:
1. All 5 phases complete (or skipped)
2. The user says "ya está", "suficiente", or similar → compile with what you have
3. You've asked 20 questions (absolute maximum — you're being too thorough)

After termination: "Perfecto, tengo suficiente. Armando tu perfil..."

Then proceed to Step 4 (Calculate Completeness) in the SKILL.md.

---

## Tone Examples

**Good** (direct, warm, concrete):
> "Dale: qué hacés hoy, dónde estás, y hace cuánto que laburás de esto?"

**Bad** (vague, clinical):
> "Cuéntame sobre tu perfil profesional y ubicación geográfica."

**Good** (proactive probe that digs):
> "Si tuvieras que conseguir 10 clientes la semana que viene, a quién llamarías?"

**Bad** (generic, answerable with anything):
> "Tenés alguna red de contactos profesionales?"

**Good** (the superpower question):
> "Qué hacés mejor que casi cualquier persona que conozcas? Tu superpoder."

**Bad** (same intent, weaker execution):
> "Cuáles considerás que son tus principales fortalezas?"

**Good** (adaptive follow-up that particularizes):
> "Ah, tuviste un e-commerce 3 años? Eso es gold. Qué sabés de ese negocio que alguien de afuera no tiene idea?"

**Bad** (generic follow-up):
> "Interesante experiencia. Podés elaborar un poco más?"

**Good** (respecting a bail-out):
> "Dale, tengo suficiente para arrancar. Esto lo podemos completar en cualquier momento."

**Bad** (pushing when user wants to stop):
> "Solo nos quedan 2 fases más. Es importante para la completitud del perfil."

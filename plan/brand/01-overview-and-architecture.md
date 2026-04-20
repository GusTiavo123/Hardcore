# 01 — Overview y Arquitectura General

## 1.1 Qué es el módulo Brand

Brand es el **tercer módulo** de Hardcore. Su rol en el ecosistema:

- **Validation** → decide si una idea vale la pena perseguir (verdict GO/NO-GO/PIVOT)
- **Profile** → entiende quién es el founder para personalizar
- **Brand** → le da identidad ejecutable a una idea validada

**Brand no entrega specs de marca — entrega una marca funcionando**. La diferencia es crítica: un PDF con "acá están tus colores y tu archetype" es lo que cualquier competidor AI puede producir. Brand de Hardcore produce un microsite HTML corriendo, logos editables, copy aplicado, assets en contextos. El founder cierra la sesión con algo que puede subir a internet mañana.

## 1.2 Posicionamiento estratégico

**Por qué este es el módulo que vende Hardcore**: Validation es el core mental — convence por rigor argumentativo. Brand es el core emocional — convence por tangibilidad. Al usuario típico le cuesta argumentar contra una validación (scoring, evidence, rubrics); NO le cuesta ignorarla si no siente algo. Brand cierra ese gap. Es el eslabón que convierte "tu idea tiene 73/100" en "y acá está tu marca funcionando".

**El moat**: cualquier herramienta AI puede generar cada pieza suelta. Hardcore genera un **sistema coherente** anclado a:
1. El perfil real del founder (via Profile)
2. La evidencia real del mercado (via Validation)
3. Reglas de coherencia cross-dept enforced automáticamente
4. Adaptación al tipo de idea (no output genérico)

Los 4 juntos no los tiene nadie en 2026.

## 1.3 Posicionamiento técnico dentro de Hardcore

Brand es un módulo paralelo a Validation y Profile, no una extensión. Cada módulo es independiente pero se potencia con los demás:

- Brand **consume** outputs de Validation (obligatorio) y Profile (opcional, opt-in)
- Brand **produce** artifacts en Engram que módulos futuros (Launch, GTM, Ops) podrán consumir
- Brand **no modifica** Validation ni Profile — solo lee

El patrón de delegación es el mismo que Validation: hay un orchestrator que delega a 5 sub-agentes (los departamentos), cada uno es una skill con su SKILL.md.

## 1.4 Invocación del módulo

**Comandos primarios**:
- `"brandea esta idea"` / `"brand this idea"` / `"armá la marca"` (español natural)
- `/brand:new` (explícito)

**Comandos auxiliares** (ver [12-modes-and-interactions.md](./12-modes-and-interactions.md)):
- `/brand:fast` — run sin interacciones
- `/brand:extend {depto}` — re-run parcial de un depto
- `/brand:override {key}={value}` — override pre-run
- `/brand:show [slug]` — display del final report
- `/brand:resume` — reanudar run interrumpido
- `/brand:diff v1 v2` — comparar snapshots

**Bloqueado si**: la idea tiene verdict `NO-GO` en Validation. Override explícito (`"brandea igual"`) disponible pero graba warning permanente en Engram.

## 1.5 Arquitectura general — diagrama del pipeline

```
          VALIDATION OUTPUT + FOUNDER PROFILE (Engram)
                              ↓
                   ┌───────────────────────┐
                   │   BRAND ORCHESTRATOR  │
                   │  (skills/brand/       │
                   │   SKILL.md)           │
                   └───────────┬───────────┘
                               ↓
               Paso 0: SCOPE ANALYSIS
          (inline en orchestrator, produce manifest)
                               ↓
                   ① STRATEGY
                   (decisiones, anclada al scope)
                               ↓
         ┌─────────────────────┴─────────────────────┐
         ↓                                             ↓
② VERBAL IDENTITY                             ③ VISUAL SYSTEM
   (paralelo)                                    (paralelo)
         └─────────────────────┬─────────────────────┘
                               ↓
                  ④ LOGO & KEY VISUALS
                  (requiere Visual + Verbal)
                               ↓
                  ⑤ ACTIVATION
                  (coherence gates + delivery)
                               ↓
                  Brand Package Entregable
                  (estructura dinámica por scope)
```

## 1.6 Justificación de cada decisión arquitectónica

### ¿Por qué Scope Analysis como Paso 0?

Porque toda decisión downstream depende del tipo de idea. Un output manifest específico determina qué generar, qué omitir, y con qué intensidad. Sin clasificación explícita al inicio, el módulo degrada en "template fijo con lipstick de personalización".

Ver [02-scope-analysis.md](./02-scope-analysis.md).

### ¿Por qué Scope Analysis inline (no sub-agente)?

Es razonamiento liviano sin tools externos. Lanzar un sub-agente agrega overhead (context window, setup) sin beneficio. Mismo patrón que `/profile:show` — operaciones que el orchestrator ejecuta directamente.

### ¿Por qué Strategy primero?

Strategy es el único depto que **toma decisiones**. Archetype, voice, positioning. Todo lo demás es ejecución. Sin decisión upstream, la ejecución es incoherente o requiere que cada dept re-decida (duplicación + divergencia).

### ¿Por qué Verbal y Visual en paralelo?

Operan en dominios ortogonales (palabras vs diseño). Ambos dependen solo de Strategy, no entre sí. Paralelizar corta el tiempo total del pipeline ~40% sin sacrificar coherencia — ambos leen el mismo Strategy output como contrato.

### ¿Por qué Logo después de Visual + Verbal?

Necesita paleta para aplicar (del Visual) y nombre para wordmarks/variantes (del Verbal). Lanzarlo antes produce logos genéricos desalineados.

### ¿Por qué Activation al final?

Activation integra todos los outputs + enforza coherence gates + arma el paquete entregable. Es el equivalente al Synthesis de Validation. Si algo no es coherente cross-dept, Activation lo detecta antes de delivery.

### ¿Por qué 5 departamentos y no otro número?

Ver el razonamiento completo en el mockup. TL;DR: cada dept tiene un modo cognitivo y stack de tools distinto. Menos de 5 (ej: juntar Logo en Visual) rompe boundaries de costo/failure/testing. Más de 5 (ej: separar Copy de Naming) rompe coherencia interna sin ganancia.

## 1.7 Relación con Profile y Validation

**Input obligatorio**:
- `validation/{idea-slug}/*` — todos los dept outputs de Validation
  - Problem: target audience real, pain points
  - Market: SOM, segmentos, geografías, CAGR
  - Competitive: incumbents, gaps, white space
  - BizModel: pricing, modelo de revenue (informa voice: "premium price" vs "freemium")
  - Risk: timing context (puede informar archetype — Rebel vs Sage según timing de mercado)
  - Synthesis: verdict + scores + flags

**Input opcional**:
- `profile/{user-slug}/core` + `extended` — todo el profile del founder

**Cuando falta Profile**: Brand corre en modo "sin personalización". Archetype se elige basado solo en idea + scope. Copy no puede usar target_geographies del profile para linguistic check (usa market geographies en su lugar). Output flagged con `"decided_without_profile: true"` + suggestion para el user de crear profile.

**Cuando verdict es NO-GO**: bloqueado por default. Override explícito disponible (comando `"brandea igual aunque es NO-GO"`) — graba decisión + warning permanente en Engram + brand book incluye warning visible.

## 1.8 Principio de adaptación (core del módulo)

Ninguna idea necesita exactamente los mismos outputs que otra. El módulo decide qué generar basándose en el **tipo de idea** (clasificado en Scope Analysis), no en un template fijo.

**Ejemplo concreto**: el output para un `b2b-enterprise` SaaS incluye pitch deck, case studies, formal email templates, LinkedIn presence — pero NO TikTok bios ni app icons. Para un `b2c-consumer-app`, app icon es CRÍTICO y primary, los pitch decks formales se omiten, la presencia en TikTok/IG es required.

Esto está detallado en [03-brand-profiles.md](./03-brand-profiles.md) con los 8 profiles canónicos.

## 1.9 Output primario del módulo

Un directorio `output/{idea-slug}/brand/` que contiene (estructura dinámica — ver [18-output-package-structure.md](./18-output-package-structure.md)):

- Brand book PDF (siempre)
- Microsite HTML/CSS/Tailwind corriendo (siempre — generado por Stitch MCP)
- DESIGN.md machine-readable (siempre)
- Logos SVG editables + derivations (siempre)
- Copy library organizada por uso (siempre)
- Social assets específicos al scope
- Email/communication templates específicos al scope
- Pitch deck / case studies / app assets si el scope lo requiere
- README.md explicando qué incluye y qué NO (transparencia total)
- AUDIT.md con evidence trace + versioning

## 1.10 Timeline estimado (Sprint 0 + Sprint 1)

- **Sprint 0 (planning completo)**: 1 sesión focalizada para escribir los 22 SKILL.md + references del módulo. Total ~60-90 min de escritura densa.
- **Sprint 1 (implementación)**: múltiples sesiones.
  - Implementación del orchestrator + scope analysis
  - Implementación de cada dept (Strategy, Verbal, Visual, Logo, Activation)
  - Integración con MCPs (Stitch, Recraft, Huemint, domain)
  - Testing (8 brand profiles × dogfooding)
  - Dogfooding contra Hardcore mismo
- **Sprint 2**: iteración basada en lo aprendido, expansión de reference docs, calibración.

## 1.11 Lecturas relacionadas

- Scope Analysis: [02-scope-analysis.md](./02-scope-analysis.md)
- Brand profiles: [03-brand-profiles.md](./03-brand-profiles.md)
- Deptos individuales: [04](./04-dept-strategy.md) a [08](./08-dept-activation.md)
- Coherencia: [09-coherence-model.md](./09-coherence-model.md)
- Stack de tools: [11-tools-stack.md](./11-tools-stack.md)

# 01 — Overview y Arquitectura General

## 1.1 Qué es el módulo Brand

Brand es el **tercer módulo** de Hardcore. Su rol en el ecosistema:

- **Validation** → decide si una idea vale la pena perseguir (verdict GO/NO-GO/PIVOT)
- **Profile** → entiende quién es el founder para personalizar
- **Brand** → **produce el brief óptimo para que Claude Design ejecute la marca**

## 1.2 Premisa fundamental

> **Brand module alimenta a Claude Design con el brief perfecto + prompts perfectos + tokens perfectos.**

Nosotros producimos strategic intelligence + brand foundation. Claude Design produce los artefactos aplicados (landing, slides, mockups, etc.) con nuestro brief como input.

**Nuestro moat**:
1. Integración con upstream context (Profile + Validation) que Claude Design no tiene
2. Scope Analysis con 8 brand profiles canónicos (clasificación automática del tipo de idea)
3. Strategy reasoning (archetype Jung, voice attributes anchored a evidence)
4. Naming con verification externa (domain + trademark)
5. Coherence gates cross-dept enforced
6. Brief compilation en formato óptimo para Claude Design

## 1.3 Invocación del módulo

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

**Bloqueado si**: verdict `NO-GO` en Validation. Override explícito (`"brandea igual"`) disponible con warning permanente grabado.

## 1.4 Arquitectura general — diagrama del pipeline

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
   (naming + core copy)                          (palette + type + mood)
         └─────────────────────┬─────────────────────┘
                               ↓
                  ④ LOGO & KEY VISUALS
                  (Tier-based generation)
                               ↓
                  ⑤ HANDOFF COMPILER
                  (coherence gates + 4 deliverables)
                               ↓
           ┌─────────────────────────────────────┐
           │ Brand Package para Claude Design    │
           │  ├─ Brand Design Document (PDF)     │
           │  ├─ Prompts Library (Markdown)      │
           │  ├─ Brand Tokens (CSS+JSON+TW)      │
           │  └─ Reference Assets (logos+mood)   │
           └─────────────────────────────────────┘
                               ↓
                               ↓
                   [ Claude Design ]
                   (downstream — no nos pertenece)
                               ↓
           Artifacts finales (microsite, decks, social, etc.)
                               ↓
                   [ Claude Code ] → deploy
```

**Separación de responsabilidades**:
- **Nosotros**: decisions + brief compilation
- **Claude Design**: UI generation + applied design system
- **Claude Code**: deployment

## 1.5 Justificación de cada decisión arquitectónica

### ¿Por qué Scope Analysis como Paso 0?

Porque toda decisión downstream depende del tipo de idea. Un output manifest específico determina qué generar, qué omitir, y con qué intensidad. Sin clasificación explícita al inicio, el módulo degrada en "template fijo con lipstick de personalización".

Ver [02-scope-analysis.md](./02-scope-analysis.md).

### ¿Por qué Scope Analysis inline (no sub-agente)?

Es razonamiento liviano sin tools externos. Lanzar un sub-agente agrega overhead (context window, setup) sin beneficio. Mismo patrón que `/profile:show` — operaciones que el orchestrator ejecuta directamente.

### ¿Por qué Strategy primero?

Strategy es el único depto que **toma decisiones**. Archetype, voice, positioning. Todo lo demás es ejecución. Sin decisión upstream, la ejecución es incoherente o requiere que cada dept re-decida (duplicación + divergencia).

### ¿Por qué Verbal y Visual en paralelo?

Operan en dominios ortogonales (palabras vs diseño). Ambos dependen solo de Strategy, no entre sí. Paralelizar corta el tiempo total del pipeline ~40% sin sacrificar coherencia — ambos leen el mismo Strategy output como contrato.

### ¿Por qué Logo después de Verbal + Visual?

Necesita paleta para aplicar (del Visual) y nombre para wordmarks/variantes (del Verbal). Lanzarlo antes produce logos desalineados.

### ¿Por qué Handoff Compiler al final?

Integra todos los outputs + enforza coherence gates + compila los 4 deliverables en formato optimizado para Claude Design. Es el equivalente al Synthesis de Validation — sintetiza + empaqueta.

### ¿Por qué 5 departamentos y no otro número?

Cada dept tiene un modo cognitivo y stack de tools distinto:
- Strategy: razonamiento estratégico puro
- Verbal: creatividad verbal + verification externa
- Visual: razonamiento de diseño + APIs de palette/mood
- Logo: image generation (con tiers)
- Handoff Compiler: templating + compilation + validation

Menos deptos colapsa boundaries. Más deptos rompe coherencia interna sin ganancia.

## 1.6 Image generation por tiers (cost-conscious)

Claude Design cubre la mayoría de image generation pagada:

| Tier | Image gen stack | Cost/run | Cuándo |
|---|---|---|---|
| **Tier 0 (default)** | Claude native SVG + Claude Design in-context | **~$0.00** | Dogfooding, early stage, vos mismo usándolo |
| **Tier 1** | + Recraft V4 para logos simbólicos + Unsplash free API para mood refs | ~$0.10-0.20 | Primeros 50-100 users reales |
| **Tier 2** | + Huemint paid + Recraft full | ~$0.40-0.60 | Escala con users pagos |

**Control runtime**: feature flag `IMAGE_GEN_MODE` en env var o CLI arg.

**Estrategia**: default Tier 0. User advanced puede escalar. Ver [07-dept-logo.md](./07-dept-logo.md) y [11-tools-stack.md](./11-tools-stack.md) para detalles.

## 1.7 Relación con Profile y Validation

**Input obligatorio**:
- `validation/{idea-slug}/*` — todos los dept outputs de Validation
  - Problem: target audience real, pain points
  - Market: SOM, segmentos, geografías, CAGR
  - Competitive: incumbents, gaps, white space
  - BizModel: pricing, modelo de revenue
  - Risk: timing context
  - Synthesis: verdict + scores + flags

**Input opcional**:
- `profile/{user-slug}/core` + `extended`

**Cuando falta Profile**: Brand corre en modo "sin personalización". Flag `"decided_without_profile: true"` en outputs. README + Brand Document suggest creating profile.

**Cuando verdict es NO-GO**: bloqueado por default. Override explícito disponible con warning permanente.

## 1.8 Principio de adaptación (core del módulo)

Ninguna idea necesita exactamente los mismos outputs que otra. El módulo decide qué generar basándose en el **tipo de idea** (clasificado en Scope Analysis), no en un template fijo.

**Ejemplo concreto**: el output para un `b2b-enterprise` SaaS incluye pitch deck prompts + case study templates + formal LinkedIn bio. Para un `b2c-consumer-app`, incluye TikTok bio + Instagram prompts + app store copy. La estructura del Brand Design Document se adapta al profile.

Detallado en [03-brand-profiles.md](./03-brand-profiles.md) con los 8 profiles canónicos.

## 1.9 Output primario del módulo — 4 deliverables

Un directorio `output/{idea-slug}/brand/` que contiene **4 artefactos optimizados para Claude Design**:

### 1. Brand Design Document PDF
Branded document (no spec dump) que el user sube a Claude Design design system setup (Fase 1). Claude Design lo lee y extrae el design system completo.

Detallado en [24-brand-design-document-structure.md](./24-brand-design-document-structure.md).

### 2. Prompts Library Markdown
Prompts pre-escritos, customizados al brand + scope, que el user pega en Claude Design para cada deliverable específico (landing, deck, social, etc.). Cada prompt sigue la estructura best-practice de Claude Design: goal + layout + content + audience.

Detallado en [25-prompts-library-templates.md](./25-prompts-library-templates.md).

### 3. Brand Tokens code folder
Codebase-style folder que Claude Design puede linkear para extraer design tokens automáticamente. Incluye CSS custom properties, JSON (DTCG format), Tailwind config, examples.

### 4. Reference Assets folder
Logos SVG, mood imagery (tier-dependent), sample applications — archivos sueltos que el user puede subir como visual references en proyectos específicos de Claude Design.

Estructura detallada en [18-output-package-structure.md](./18-output-package-structure.md).

## 1.10 Workflow del user — end-to-end

```
1. User: /brand:new
2. Hardcore Brand module runs (5 deptos, ~15-20 min)
3. Output: 4 deliverables en output/{slug}/brand/
4. User va a claude.ai/design
5. Uploads Brand Design Document PDF en design system setup
6. Claude Design extrae design system automáticamente
7. User valida con test project, publica el design system
8. User usa prompts del Prompts Library para generar cada deliverable específico
9. Claude Design aplica el design system consistentemente en cada project
10. Cuando termina, Claude Design genera handoff bundle para Claude Code
11. Claude Code deploya
```

**Nuestro módulo aporta**: pasos 1-3 (el brief optimizado).
**Claude Design aporta**: pasos 4-10 (UI generation).
**Claude Code aporta**: paso 11 (deployment).

## 1.11 Timeline estimado

- **Sprint 0 (planning completo)**: 1-2 sesiones focalizadas para escribir los SKILL.md + references del módulo (~55 archivos)
- **Sprint 1 (implementación)**: 2-3 semanas
  - Implementación del orchestrator + scope analysis
  - Implementación de cada dept (Strategy, Verbal, Visual, Logo, Handoff Compiler)
  - Integración con MCPs (Recraft opcional via feature flag, Huemint opcional, Domain MCP, PDF skill)
  - Testing (8 brand profiles × dogfooding)
  - Dogfooding contra Hardcore mismo (output sube a Claude Design para testing del flow completo)
- **Sprint 2**: iteración + migration a Claude Design MCP cuando Anthropic lo ship.

## 1.12 Lecturas relacionadas

- Scope Analysis: [02-scope-analysis.md](./02-scope-analysis.md)
- Brand profiles: [03-brand-profiles.md](./03-brand-profiles.md)
- Deptos individuales: [04](./04-dept-strategy.md) a [08](./08-dept-handoff-compiler.md)
- Coherencia: [09-coherence-model.md](./09-coherence-model.md)
- Stack de tools (con tiers): [11-tools-stack.md](./11-tools-stack.md)
- Cost + timing por tier: [17-cost-and-timing.md](./17-cost-and-timing.md)
- Structure del Brand Design Document: [23-brand-design-document-structure.md](./23-brand-design-document-structure.md)
- Prompts Library templates: [24-prompts-library-templates.md](./24-prompts-library-templates.md)

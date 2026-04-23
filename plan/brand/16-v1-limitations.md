# 16 — Limitaciones v1 Declaradas

## 16.1 Propósito

Declarar **explícitamente** lo que Brand v1 NO cubre. La transparencia es una feature del producto — un user que sabe los límites confía más que uno que descubre gaps.


## 16.2 Limitaciones del approach

### Dependencia de Claude Design (gate de entrada)

**Qué**: Brand v1 produce el brief optimizado, Claude Design produce los artefactos aplicados.

**Implicación**: user **necesita** Claude Pro/Max/Team/Enterprise subscription para correr Brand. El pre-flight del orchestrator bloquea si no hay Claude Pro activo.

**Sin workaround para el gate**: Brand no corre sin Claude Pro. Este es un design choice — Brand está optimizado end-to-end para Claude Design downstream.

**Long-term**: cuando Anthropic expanda Claude Design o agregue free tier, este gate se ajusta.

### Claude Design handoff es manual en v1

**Qué**: user sube PDF + pega prompts manualmente. No hay integración programática automática.

**Razón**: Claude Design no expone API/MCP aún (Anthropic dijo "coming weeks" en abril 2026).

**Workaround**:
- README con instructions claras paso a paso
- Una vez configurado, prompts son copy-paste rápido

**Long-term**: cuando Anthropic ship Claude Design MCP, Handoff Compiler auto-invoca. Feature flag `--auto-setup` disponible.

### SVG generation para symbolic marks

**Qué**: Claude native SVG generation es excelente para wordmarks y marks geométricos simples. Limitada para ilustraciones orgánicas complejas o mascots dibujados.

**Implicación**: v1 sesga logo output hacia wordmark / lettermark / geometric marks. Si el scope demanda un mark orgánico fuerte (ilustración expresiva, mascota), el output flagea `organic_mark_requested_geometric_delivered: true` con nota al user.

**Workaround**:
- User puede proveer own logo (manual mode)
- User puede iterar el mark geometric entregado usando Claude Design para variaciones más orgánicas sobre la base
- Hire illustrator con Brand Document como brief

### No generamos UI (por diseño, no por limitation)

**Qué**: No producimos microsite HTML/CSS, slides, mockups aplicados.

**Razón**: Claude Design lo hace mejor en el ecosystem Anthropic. Evitamos duplicar.

**Workaround**: ninguno necesario — es intentional.

## 16.3 Limitaciones físicas/industriales

### Packaging 3D / dieline design

**Out of scope v1**. Requiere 3D modeling tools. Consider future Brand-Physical module.

### Print-ready CMYK specifications

**Out of scope v1**. Stack es RGB digital-first. Entregamos RGB con flag + recommendation de conversion.

### Motion design assets

**Out of scope v1**. Requiere tools distintos (After Effects, Lottie). Consider future Brand-Motion.

### Sonic branding

**Out of scope v1**. Requiere audio AI tools. Consider future Brand-Sonic.

## 16.4 Limitaciones fotográficas

### Real photography (products, team, locations)

**Out of scope v1**. Mood imagery refs (cuando scope los incluye) son curated stock via Unsplash free API (URLs + attribution), no photography real de productos/team/locations del user.

### Product mockups complejos

**Limited**. Simple 2D mockups (OG card, business card mock, phone icon mock) están cubiertos. Complex 3D product mockups (logo on billboard, storefront, merchandise 3D render) requieren Claude Design o services externos.

## 16.5 Limitaciones de alcance cultural

### Multi-language brand simultáneo

**Limited**. Brand se genera en UN idioma primario. User puede re-run en otro language (separate snapshot) y merge manually.

**Long-term**: multi-language Brand pipeline en v2.

### Cultural sensitivity deep

**Limited**. Basic linguistic check cubierto (obvious negative connotations). Deep cultural sensitivity (religious, political, regional nuances) requires local consultant.

**Disclaimer obligatorio**: "Cultural sensitivity screening preliminar. Consultá local cultural consultant para mercados sensibles."

## 16.6 Limitaciones legales

### Trademark search no es legal opinion

**Permanent limitation**. Preliminary TM screening via web search. NO sustituye consulta con abogado IP.

**Disclaimer obligatorio en cada output**.

### Privacy / Terms content

**Limited**. En el Brand Document podemos incluir skeleton sections, pero el microsite real (generado por Claude Design) tendrá Privacy/Terms skeletons que requieren legal review.

## 16.7 Limitaciones de personalización

### Brand without Profile (degraded)

**Graceful degradation**. Brand runs sin profile con flag. Pierde:
- Archetype fit validation basado en founder
- Voice modulation basada en personality
- Target audience refinement basada en founder context

**Flag**: `decided_without_profile: true`

### Partial profile (low completeness)

**Graceful**. Si profile.completeness < 0.4, Brand runs con flags.

## 16.8 Limitaciones técnicas

### SVG generation quality

**Limited**:
- Claude native SVG: great para wordmarks y geometric marks, limited para organic abstracts / mascots
- Quality validation built-in (XML parse, element count, palette compliance, 16px legibility) pero no perfect
- Regenerate option disponible + manual upload como fallback

### Tool dependencies

- **Engram MCP**: mandatory. Sin Engram, Brand no corre (hard halt).
- **open-websearch MCP**: mandatory para TM screening + sentiment derivation. Graceful degrade si down (flags).
- **Domain availability MCP**: mandatory para naming verification. Graceful degrade si down.
- **Unsplash free API**: recommended (para mood refs cuando scope los pide). Graceful skip si down.
- **PDF skill**: mandatory para Brand Document. Fallback a markdown si falla.
- **Claude Pro subscription del user**: mandatory. Pre-flight halt si no disponible.

Todos los tools son gratuitos (free APIs y MCPs). El único costo recurring es la suscripción Claude Pro del user, no facturada por Hardcore.

## 16.9 Out-of-scope permanent

NO son "v1 — fix later" sino decisions permanentes:

- **Legal opinion / TM registration service**: we're not a law firm, never
- **Physical production (printing, manufacturing)**: software tool, not agency
- **Photography services**: no physical production
- **Ongoing brand management 24/7**: Brand delivers package, no continuous service (future "Brand Maintenance" could be separate module)

## 16.10 Lo que NO es limitation

Cosas que pueden parecer limitations pero son **decisión arquitectónica intentional**:

- **No microsite generation**: intentional — Claude Design lo hace mejor
- **No mockups aplicados**: intentional — Claude Design
- **No full copy library** (emails completos, long-form blog posts): intentional — Claude Design genera in-context per prompt
- **No slides / pitch deck completo**: intentional — Claude Design

Son **decisiones de scope** (nuestro output es brief + tokens), no limitations.

## 16.11 Cómo comunicar limitations

### En el Brand Design Document PDF

Página dedicada "Scope & Limitations":
- Lo que este document enables (via Claude Design)
- Lo que NO cubre y por qué (physical, motion, sonic, CMYK)
- Workarounds / future modules

### En el README.md del package

Explicit sections (ver [08-dept-handoff-compiler.md](./08-dept-handoff-compiler.md#66-paso-6-generar-readme-del-package)):
- Lo que incluye
- Skipped por scope con reasons
- Out of scope v1 con reasons
- Workarounds

### En reveal al user (post-delivery)

Summary visible:
```
Out-of-scope v1:
  • Packaging 3D — tu producto es digital
  • Print CMYK heavy — usamos RGB
  • Motion design — brief escrito only
  • Sonic branding — brief escrito only
  • Real photography — no generamos

Via Claude Design (downstream):
  • Microsite aplicado, slides, mockups, copy completo
  • Design system consistente across projects

Para out-of-scope, considerar:
  • Módulos futuros de Hardcore (Brand-Physical, Brand-Motion, Brand-Sonic)
  • Hire specialists con nuestro Brand Document como brief
```

## 16.12 Roadmap candidatos (future módulos)

Limitations que podrían resolverse:

| Módulo candidato | Resuelve | Prioridad |
|---|---|---|
| Claude Design MCP integration | Handoff manual → automatic | **Alta** — cuando Anthropic ship |
| `brand-physical` | Packaging 3D, print CMYK | Media (physical product users) |
| `brand-motion` | Motion design | Media (post-launch, demand-driven) |
| `brand-sonic` | Audio branding | Baja |
| `brand-photography` | Real photography guidance | Baja |
| `brand-multi-language` | Global multi-lang | Media (demand-driven) |
| `brand-maintenance` | Ongoing consistency | Baja (post-launch) |

Priorizar por demanda real.

## 16.13 Honesty policy

Brand v1 **siempre declara limitations**:
- README del package
- Brand Design Document PDF (scope & limitations section)
- Reveal al user post-delivery

No silently skip — always transparent.

## 16.14 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos:

1. Brand run sin profile → flag + declaration
2. Naming verification fails → flag "TM not verified" + disclaimer
3. Package README lista out-of-scope accurately per scope
4. Brand Document PDF contains "Scope & Limitations" section
5. User asks for packaging 3D via override → graceful rejection + alternatives
6. User sin Claude Pro → pre-flight halt con mensaje claro
7. Scope requiere organic mark complejo → flag + manual-upload suggestion

# 16 — Limitaciones v1 Declaradas

## 16.1 Propósito

Declarar **explícitamente** lo que Brand v1 NO cubre. La transparencia es una feature del producto — un user que sabe los límites confía más que uno que descubre gaps.


## 16.2 Limitaciones del approach

### Dependencia de Claude Design para execution

**Qué**: Brand v1 produce el brief optimizado, Claude Design produce los artefactos aplicados.

**Implicación**: user necesita Claude Pro/Max/Team/Enterprise subscription para consumir nuestro output al 100%.

**Workaround**:
- User sin Claude subscription puede usar Brand Design Document PDF como brief para otros tools (Figma, Midjourney, human designer)
- Brand Tokens folder funciona standalone (puede usarse en cualquier codebase)
- Reference Assets son usables en cualquier tool

**Long-term**: cuando Anthropic expanda Claude Design o agregue free tier, esta limitation se reduce.

### Claude Design handoff es manual en v1

**Qué**: user sube PDF + pega prompts manualmente. No hay integración programática automática.

**Razón**: Claude Design no expone API/MCP aún (Anthropic dijo "coming weeks" en abril 2026).

**Workaround**:
- README con instructions claras paso a paso
- Una vez configurado, prompts son copy-paste rápido

**Long-term**: cuando Anthropic ship Claude Design MCP, Handoff Compiler auto-invoca. Feature flag `--auto-setup` disponible.

### Tier 0 degradación para symbolic logos

**Qué**: Claude native SVG generation es excelente para wordmarks pero limitado para symbolic marks abstractos complejos.

**Implicación**: si scope requiere `symbolic-first` o `icon-first`, Tier 0 produce quality lower. System auto-eleva a Tier 1 con user confirmation.

**Workaround**:
- Auto-elevation prompt explicit
- User puede declinar y proceder con Tier 0 acknowledging loss
- User puede proveer own logo (manual mode)

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

**Out of scope v1**. Mood imagery (si tier ≥ 1) es stylized o curated stock (Unsplash), no photography real.

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
- Claude native SVG (Tier 0): great para wordmarks, limited para symbolic abstracts
- Recraft V4 (Tier 1+): excellent but ocasional artifacts posibles
- Quality validation built-in pero no perfect

**Workaround**: manual mode available + regenerate options

### Free tier limits

- Stitch: N/A (salió del stack)
- Huemint: free non-commercial → upgrade para launch comercial
- Recraft: pay-per-use
- Domain MCP: free, no limit
- Claude Design: requires Pro+ subscription

**Implication**: escalar requiere commercial licenses en Huemint + possibly Recraft budget growth.

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
6. User sin Claude subscription → guidance displayed
7. Tier 0 symbolic request → auto-elevation prompt + honest about quality

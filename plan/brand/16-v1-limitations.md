# 16 — Limitaciones v1 Declaradas

## 16.1 Propósito

Declarar **explícitamente** lo que Brand v1 NO cubre. La transparencia aquí es una feature del producto, no una debilidad: un user que sabe los límites confía más que uno que descubre gaps por sorpresa.

Cada limitation incluye:
- Qué no se cubre
- Por qué (technical / scope / cost reason)
- Qué brand profiles más afectados
- Workaround en v1
- Consideración para futuras versiones

## 16.2 Limitaciones físicas/industriales

### Packaging 3D / dieline design

**Qué no se cubre**: 3D packaging design, physical product packaging, dielines (cut + fold patterns for boxes, bags, labels).

**Por qué**: Requeriría 3D modeling tools, CAD software, physical product expertise. Stack actual (Recraft + Stitch) no incluye capabilities 3D. Agregar tooling 3D sería un proyecto separado significativo.

**Profiles afectados**: 
- `b2c-consumer-app` (si tiene subscription box o physical merch — raro pero posible)
- `b2local-service` (food/hospitality que necesitan packaging)
- Physical product brands (no cubiertos por los 8 profiles canónicos actuales)

**Workaround v1**: 
- Generar "packaging direction" como brief escrito para diseñador humano
- Mood imagery que evoca el estilo de packaging deseado
- Especificaciones de paleta + typography que el diseñador físico aplica

**Futuras versiones**: 
- Módulo Brand-Physical separado con integration a CAD tools
- Integration con Midjourney (que sabe generar packaging mockups) como complemento

### Print-ready CMYK specifications

**Qué no se cubre**: CMYK color profiles, print specs (bleed, crop marks, pantone matching), pre-press quality outputs.

**Por qué**: Stack visual es RGB digital-first. Conversion RGB→CMYK es destructive y depende del printer. Pantone matching requiere database licenciadas.

**Profiles afectados**:
- `b2local-service` (flyers, business cards, signage)
- `content-media` con merch direction
- `community-movement` con merch

**Workaround v1**:
- Entregamos colores con flag "RGB — convertir a CMYK antes de imprenta"
- Recomendación explícita de profile a usar (ISOcoated_v2 para EU offset, US Web Coated SWOP for US)
- Notas de "probable color shift in amber accent when CMYK-converted"
- Aspect ratios correct para print sizes standard

**Futuras versiones**:
- Módulo Brand-Print separado
- Integration con prepress tools
- Pantone match suggestions

### Motion design assets

**Qué no se cubre**: video intros, logo animations, UI transition specifications, after-effects templates, motion graphics.

**Por qué**: Motion design requiere tools completamente distintos (After Effects, Lottie, Framer). Stack actual genera imágenes estáticas + HTML/CSS estático.

**Profiles afectados**:
- `content-media` (video content, podcast video, YouTube channel)
- `b2c-consumer-app` (app transitions, splash screens, onboarding motion)
- Creative brand directions

**Workaround v1**:
- "Motion principles" como brief escrito (speed, easing preferences, dramatic moments)
- Ejemplos de referencias existentes (linked)
- Principios documentados para que motion designer humano interprete

**Futuras versiones**:
- Módulo Brand-Motion
- Integration con Runway, Kaiber, Sora (cuando maduren)
- Lottie template generation

### Sonic branding

**Qué no se cubre**: audio logos, jingles, intro music for podcasts/videos, voice-over guidelines, sound effects branded.

**Por qué**: Requiere AI audio tools (Suno, Stable Audio, ElevenLabs) not in current stack. Audio gen + evaluation es subjective en maneras distintas a visual.

**Profiles afectados**:
- `content-media` (especialmente podcasts)
- `b2c-consumer-app` (app sounds, notification tones)
- Video creators

**Workaround v1**:
- "Sonic attributes" como brief escrito ("warm, textured, 90 BPM, acústico")
- References a existing sonic brands que evocan el mood
- Recommendations to hire composer or use Suno/similar

**Futuras versiones**:
- Módulo Brand-Sonic
- Integration con Suno, Stable Audio

## 16.3 Limitaciones fotográficas

### Real photography (products, team, locations)

**Qué no se cubre**: photography real — product shots, team photos, lifestyle, location shoots.

**Por qué**: 
- Mood imagery generada por Recraft es stylized, no photorealistic
- Photorealistic AI (Flux 2 Pro) podría aproximar but still AI-generated, not real
- Real photography requires photographer + production

**Profiles afectados**:
- Consumer profiles especially
- Physical products
- Local services

**Workaround v1**:
- Mood imagery generated evoca direction
- Stock photo recommendations (Unsplash links, curated by archetype)
- Photography brief escrito para hire photographer

**Futuras versiones**:
- Integration con high-quality photorealistic models cuando maduren
- Pero "AI-generated photo" vs "real photo" tiene limitations éticas y de percepción

### Product mockups (logo en contextos complejos)

**Qué sí se cubre**: OG card, business card mock, phone icon mock (simples).
**Qué no se cubre**: complex product mockups (logo on billboard, on storefront, on merchandise 3D render).

**Workaround v1**:
- Simple 2D mockups via composition (logo layer + template bg)
- Recomendamos servicios externos para high-fidelity mockups (Placeit, Smartmockups)

## 16.4 Limitaciones de alcance cultural

### Multi-language brand (beyond primary)

**Qué no se cubre**: brand completo en múltiples idiomas simultaneously. Brand se genera en UN idioma primario.

**Por qué**:
- Naming verification en multiple languages multiplies complexity
- Copy tone doesn't translate 1:1 — requires separate creative pass per language
- Visual system generally language-independent but some elements (tagline rendering) need per-lang consideration

**Profiles afectados**:
- Global brands que necesitan EN + ES + PT simultaneously
- Multi-market launches

**Workaround v1**:
- Brand generado en primary language
- Copy library incluye tagline in 1-2 alternate languages (manual translation)
- User puede re-run Brand en otro language (produce snapshot separate) y merge artifacts manually

**Futuras versiones**:
- Multi-language Brand pipeline
- Cross-language coherence checks (same voice mantenido en traducciones)

### Cultural sensitivity checks (deep)

**Qué sí se cubre**: basic linguistic check (negative connotations obvias en target_geographies).
**Qué no se cubre**: deep cultural sensitivity — religious implications, political connotations, regional humor nuances, indigenous concepts.

**Por qué**: Requiere expertise cultural específica per region. Claude reasoning puede catch obvious pero no subtle.

**Workaround v1**:
- Disclaimer en brand book: "Cultural sensitivity screening preliminar. Para mercados sensibles (religious, political), consultá local cultural consultant."

**Futuras versiones**:
- Cultural sensitivity MCP if develops
- Human-in-the-loop review para certain markets

## 16.5 Limitaciones legales

### Trademark search no es legal

**Qué sí se cubre**: preliminary TM screening via web search en USPTO, EUIPO, TMView, INPI/IMPI/SIC.
**Qué no se cubre**: legal opinion, comprehensive trademark search, international filing strategy, prior art research.

**Por qué**: 
- Web search no cubre registered but not-yet-published marks
- Doesn't include common law trademarks
- Can't evaluate likelihood of confusion legally
- Not licensed to give legal opinion

**Afectados**: todos los profiles (naming es universal)

**Workaround v1**:
- **Disclaimer obligatorio en output + brand book**: "TM screening preliminar. No sustituye consulta con abogado de propiedad intelectual."
- Recommend user consult lawyer before filing

**Futuras versiones**: no planned — este es permanent limitation (we're not a law firm).

### Privacy policy / Terms of Service content

**Qué sí se cubre**: skeleton documents estructurados con header + sections + brand voice en prose introductoria.
**Qué no se cubre**: legally binding language, GDPR compliance verification, CCPA compliance, jurisdiction-specific clauses.

**Workaround v1**:
- Skeleton PDF included en microsite
- Header: "DRAFT — requires legal review"
- Recommend user engage legal counsel

## 16.6 Limitaciones de personalización

### Brand without Profile (degraded)

**Qué sí se cubre**: Brand runs sin profile con reasonable defaults.
**Qué pierde**: 
- Archetype decision based only on idea (not founder fit)
- Voice doesn't reflect founder personality
- Target audience less specific (founder context absent)
- Cultural considerations reduced (no target_geographies from profile)

**Profiles afectados**: todos si user no tiene Profile.

**Workaround v1**:
- Flag `decided_without_profile: true` en all outputs
- Suggest `/profile:new` al user con priority high
- README del package explicitly notes "brand would benefit from profile — consider creating one"

### Partial profile (low completeness)

Si profile completeness < 0.4:
- Brand runs con profile disponible
- Flag "low completeness profile" 
- Certain decisions skip profile check (e.g., risk_tolerance check if unclear)

## 16.7 Limitaciones técnicas

### SVG generation quality (Recraft)

**Limitation**: Recraft genera SVG nativo, pero:
- Complex illustrative logos may have artifacts
- SVGs pueden tener paths muy complejos (miles de puntos) — difícil editar manually
- Text rendering en wordmarks puede fallar a veces (Ideogram sería mejor but excluded from v1 stack)

**Workaround**:
- Quality validation pre-delivery
- Flag "SVG may need manual cleanup in Figma/Illustrator"
- Manual mode como fallback (user uploads own logo)

### Stitch output consistency

**Limitation**: Stitch depende de Gemini 3 quality. Output variance possible — same DESIGN.md en dos runs puede producir UI ligeramente diferente.

**Workaround**:
- Accept as creative variance (similar a image gen)
- Variance tests documentan acceptable range
- User puede regenerate via `/brand:extend activation.microsite`

### Free tier limits

- Stitch: 350/mes free. Para 50+ runs/mes, sufficient.
- Huemint: free non-commercial. Para commercial launch, upgrade needed.
- Recraft: pay-per-use, no real limit beyond budget.
- Domain MCP: free, no limit.

**Implication**: al escalar a 100+ runs/mes, budget + potential tier upgrades become considerations.

## 16.8 Out-of-scope permanent (not planned for future)

Estas NO son limitations "v1 — fix later" sino decisiones permanent:

- **Legal opinion / TM registration service**: we're not a law firm, never will be
- **Physical production (printing, manufacturing)**: we're a software tool, not a production agency
- **Photoshooting services**: same — we don't do physical production
- **Ongoing brand management**: Brand delivers a package, no continuous management service (though a future "Brand Maintenance" module could exist)

## 16.9 Cómo comunicar limitations

### En el brand book PDF

Sección dedicada "Scope & Limitations":
- Lo que este brand book cubre
- Lo que NO cubre y por qué
- Recommended next steps for uncovered areas

### En el README.md del package

Explicit lists (ver [08-dept-activation.md#63-paso-6](./08-dept-activation.md#63-paso-6)):
- Lo que incluye
- Lo que NO incluye con reason
- Workarounds

### En reveal al user

Summary visible:
```
Out-of-scope v1:
  • Packaging 3D — tu producto es digital
  • Print CMYK heavy — usamos RGB
  • Motion design — brief escrito only
  • Sonic branding — brief escrito only

Para estas, considerar módulos futuros de Hardcore
o hire specialists.
```

## 16.10 Roadmap candidatos (future módulos)

Limitations que podrían resolverse con módulos separados:

| Módulo candidato | Resuelve | Prioridad |
|---|---|---|
| `brand-physical` | Packaging 3D, print CMYK, dielines | Media — cuando tengamos physical product users |
| `brand-motion` | Motion design, video intros, transitions | Media — después del launch, demanda-driven |
| `brand-sonic` | Audio branding, jingles, podcast audio | Baja — nice to have |
| `brand-photography` | Real photography guidance + hire workflow | Baja |
| `brand-multi-language` | Global brands en 3+ languages | Media — demanda-driven |
| `brand-maintenance` | Ongoing brand updates, consistency checks | Baja — post-launch |

No all será built. Priorizar basado en demanda real de usuarios.

## 16.11 Honesty policy

Brand v1 **siempre declara limitations**:
- En README del package (section "Lo que NO incluye")
- En brand book PDF (section dedicada)
- En reveal al user al final del run

No silently skip — always transparent about what's not covered. Esta es una decisión de producto, no solo técnica: confianza del user viene de transparency, no de fake completeness.

## 16.12 Testing

Ver [14-testing-strategy.md](./14-testing-strategy.md). Casos relacionados con limitations:

1. Brand run sin profile → `decided_without_profile: true` flag + explicit declaration
2. Naming verification web search fails → flag "TM not verified" + disclaimer obligatorio
3. Package README lista out-of-scope accurately per scope
4. Brand book PDF contains "Scope & Limitations" section
5. User asks for packaging 3D via override → graceful rejection + suggest alternatives

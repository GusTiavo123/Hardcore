# Hardcore — Roadmap Estratégico

## Qué es Hardcore

Un ecosistema modular de agentes AI donde el usuario es el CEO y los agentes son sus departamentos. Cada módulo cubre una función empresarial. Usá uno, usá todos — es modular. El contexto fluye entre módulos a través de Engram como bus de memoria compartida.

**El moat**: Cada módulo solo es "otra herramienta AI". La cadena acoplada donde el perfil del founder, las ideas validadas, la identidad de marca y las specs del MVP se informan mutuamente — eso no lo tiene nadie.

**Uso dual**: Hardcore se usa internamente para construir productos Y se vende como producto. El éxito propio es el marketing.

---

## Estado Actual

| Módulo | Estado | Descripción |
|---|---|---|
| **Idea Validation** | Completo | 6 departamentos, scoring anclado a evidencia, GO/NO-GO/PIVOT. Testeado con 80% accuracy. |
| **Founder Profile** | Pendiente | Próximo módulo a construir. |
| **Brand & Identity** | Pendiente | Después de Profile. |

---

## Fase 1 — Founder Profile (`hc-profile`)

**Qué**: Un módulo que entiende quién es el usuario — skills, recursos, constraints, mercados que conoce, tolerancia al riesgo, red de contactos, intereses, hard-nos.

**Por qué primero**: Es upstream de todo. Cada módulo futuro se beneficia de saber quién es el founder. Transforma Hardcore de "herramienta genérica" a "sistema personalizado". Una idea que es GO para un founder con experiencia en fintech y $50K no es lo mismo que para alguien sin experiencia y $0.

**Qué habilita**:
- Validación personalizada (ideas evaluadas relativas al founder)
- Generación de ideas anclada a lo que el founder puede ejecutar
- Brand alineada con el perfil del founder
- Cualquier módulo futuro que necesite contexto del usuario

**Criterio de completitud**: El perfil se persiste en Engram y es consumible por el pipeline de validación existente.

---

## Fase 2 — Brand & Identity (`hc-brand`)

**Qué**: Un departamento de agentes que genera la identidad empresarial de una idea validada — posicionamiento, arquetipos, naming, paleta, tipografía, tono de voz, guidelines.

**Por qué segundo**: El primer cliente es Hardcore mismo. "Esta marca fue creada por el departamento de Brand de Hardcore" es el mejor pitch posible — el producto se brandeó a sí mismo. Además, un lanzamiento con branding profesional convierte órdenes de magnitud mejor que un prototipo publicado.

**Qué habilita**:
- Lanzamiento de Hardcore con identidad propia y profesional
- Propuesta de valor completa para usuarios: perfil → validación → identidad
- Un módulo vendible desde el día 1

**Criterio de completitud**: El módulo genera una identidad coherente para Hardcore mismo, que se usa en el lanzamiento.

---

## Fase 3 — Lanzamiento

Con 3 módulos funcionando (Profile + Validation + Brand), Hardcore sale al mercado:

- Landing page con identidad generada por el propio sistema
- Journey completo: "Decime quién sos → dame tu idea → te la valido → te genero la identidad"
- Pricing: freemium (1 validación gratis, después pago)
- Target inicial: founders técnicos, emprendedores digitales

---

## Fase 4+ — Expansión por demanda

Módulos futuros se construyen cuando los usuarios los pidan, no antes. Cada módulo nuevo es un upgrade del plan y un motivo para quedarse.

**Candidatos** (sin orden definido, se priorizan por feedback real):

| Módulo | Función |
|---|---|
| **Idea Engine** | Generación automática de ideas basada en perfil + iteración + banco de ideas GO |
| **MVP Architect** | Specs funcionales, tech stack, user stories, estimación de esfuerzo |
| **Go-to-Market** | Estrategia de lanzamiento, canales, messaging, pricing strategy |
| **Financial Model** | Proyecciones financieras, escenarios, runway, break-even |
| **Operations** | Procesos, herramientas, workflows para operar el negocio |

La referencia técnica para el Idea Engine está en `docs/idea-loop-architecture.md`.

---

## Principios de Diseño

1. **Modular**: Cada módulo funciona independiente pero se potencia con los demás
2. **Context-first**: El perfil del founder fluye por toda la cadena
3. **Evidence-based**: Datos reales, no opiniones de LLM
4. **Vendible por módulo**: Cada módulo agrega valor comercial independiente
5. **Dogfooding**: Hardcore se usa a sí mismo primero

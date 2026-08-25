---
name: editor-de-video
description: >-
  Pipeline completo de edición de video con IA: convierte footage crudo (hablando a cámara,
  con tomas repetidas y pausas) en un video terminado con cortes, subtítulos,
  rótulos, apoyos visuales y diseño de sonido. Cubre el proceso entero — brief, corte
  automático con WhisperX, acabado con ffmpeg, animación opcional en After Effects vía
  MCP, iteración con feedback en lenguaje natural, guardado del estilo como plantilla
  reutilizable y producción en lote. Úsala cuando la persona diga cosas como "edita este
  video", "haz el corte", "quítale los silencios", "ponle subtítulos", "recrea este estilo
  de edición", "aplica el estilo X a estos clips", "guarda esto como plantilla", "edita
  estos 20 videos igual", o cuando pegue un link de YouTube/Instagram/TikTok/Pinterest con
  la intención de recrear su estilo visual.
---

# Editor de video — pipeline de edición con IA

> **El trabajo:** la persona solo graba. Todo lo demás — elegir tomas, cortar, animar,
> sonorizar, iterar y escalar — pasa por aquí.

**Vertical 9:16 y horizontal 16:9, los dos.** El vertical tiene más estilos probados; el
horizontal está verificado en producción para YouTube. **Pregunta el formato en el brief** —
no lo deduzcas del crudo, porque se puede grabar en horizontal para montar en vertical.

⛔ **Antes de reencuadrar, confirma.** Un crudo horizontal puede ser para un video horizontal
o el material de un estilo vertical de dos zonas. Son cosas distintas y no se adivinan.

**Principio de fondo:** el criterio estético lo pone la persona o un video de referencia.
Tú ejecutas con precisión, iteras rápido y no te desvías. **Nunca inventes un estilo desde
cero sin referencia** — si no hay referencia, pídela antes de construir.

---

## FASE 0 — Verificar el entorno (siempre, antes de tocar nada)

Revisa qué está disponible **hoy** y elige el camino en consecuencia. No asumas.

| Necesitas | Cómo verificar | Si falta |
|---|---|---|
| ffmpeg | `ffmpeg -version` | → `references/07-instalacion.md` |
| WhisperX | `~/.equipo-de-ia/wx-env/bin/python -c "import whisperx"` | → `references/07-instalacion.md` |
| Puente MCP de After Effects | ¿aparecen herramientas de AE en esta sesión? | usa el camino ffmpeg |

⛔⛔ **A WhisperX no le hagas `ls` — ejecútalo de verdad.** Que el archivo exista no significa
que corra: en macOS, Gatekeeper puede bloquear un binario recién instalado aunque esté en el
disco. Si el `import whisperx` de arriba falla (aunque el archivo exista), **WhisperX NO está
disponible** — es el mismo caso que si faltara.

### La regla de degradación (importante)

**Si el puente de After Effects no está disponible, NO te detengas.** Baja al camino de
ffmpeg y entrega igual: un video cortado, en el formato que pidan, y publicable. Sin motion
graficos finos, pero real. Avisa qué camino tomaste y qué se pierde.

⛔⛔ **Si WhisperX falla, es al revés: SÍ te detienes.** Sin WhisperX no hay corte por
silencios ni bordes de palabra exactos — es el corazón del pipeline, no un extra. **No
entregues "solo subtítulos" como si fuera el resultado completo.** Dile a la persona
exactamente qué falló y mándala a `references/07-instalacion.md` para arreglarlo antes de
seguir. Un resultado a medias sin avisar es peor que pararse a tiempo.

Orden de preferencia: **After Effects (mejor) → ffmpeg (respaldo siempre disponible)**.

**El nivel 3 se activa preguntando.** Si no hay After Effects, no lo propongas ni lo
instales por tu cuenta: es software de pago. Solo cuando la persona diga *"quiero instalar
After Effects, guíame"*, llévala paso a paso con `references/07-instalacion.md`.

### Dónde están los estilos

Mira en los **dos** sitios antes de decir que no hay ninguno:

1. **`${CLAUDE_PLUGIN_ROOT}/skills/editor-de-video/estilos/`** — los que vienen con el plugin.
   Se actualizan solos y **no se editan**: una actualización los sobrescribe.
2. **`content-os/styles/proven/` y `content-os/styles/experimental/`** — los de la persona.
   Nunca se tocan al actualizar. Si uno se llama igual que uno del plugin, **gana el suyo**.

Para partir de un estilo del plugin y cambiarlo, **cópialo primero** a
`content-os/styles/experimental/<nombre>/` y trabaja sobre la copia.

Después pregunta qué tipo de trabajo es:
- **Estilo nuevo** → Fase 1
- **Seguir iterando algo empezado** → Fase 4
- **Aplicar un estilo ya guardado a clips nuevos** → Fase 7

---

## FASE 1 — El brief

⛔ **Si el video llega arrastrado suelto** (no está ya dentro de `content-os/raw-footage/`),
ubícalo antes de seguir con el brief:

1. Si **no existe** `content-os/raw-footage/<fecha-de-hoy>/`, créala y proponla:
   *"Voy a crear la carpeta `<fecha-de-hoy>` para este video, ¿está bien?"*
2. Si **ya existe** una carpeta de hoy (porque ya hay otro video de hoy dentro), no la
   reuses — crea `<fecha-de-hoy>-2`, o el siguiente número libre si ya hay más de una.
   Mismo aviso de una línea antes de moverlo.
3. Solo después de mover el archivo, sigue con el resto del brief.

**Nunca crees la carpeta sin decirlo primero** — es una línea, no un formulario.

Consigue lo mínimo antes de construir. Checklist completo en `references/05-brief.md`.

Lo indispensable:
1. **Referencia visual** — link (YouTube/Instagram/TikTok/Pinterest) o descripción. Si es
   un link para recrear un estilo desde cero → `references/06-recrear-estilo.md`.
2. **Footage crudo** — ruta exacta de los archivos.
3. **¿Para quién es?** — contenido propio o de un cliente. Si es de cliente, pide su tono,
   su paleta y sus referencias antes de construir.
4. **Nivel de fidelidad** — ¿copia exacta de una escena, o solo la vibra?

**Voz de marca:** todo texto en pantalla debe sonar como la persona dueña del canal, nunca
como copy genérico de IA.

- Si existe `content-os/mi-voz.md`, léelo y úsalo.
- Si no existe, **no le pidas que escriba un archivo en blanco** — nadie sabe describir su
  propio tono. Hazle tres preguntas dentro del brief: **¿a quién le hablas?**, **¿qué frases
  repites siempre?**, **¿qué tono te da pena?** Y **guarda las respuestas en
  `content-os/mi-voz.md`** para no volver a preguntar.

Si el footage necesita una toma específica (encuadre, obturador, apertura, duración),
**dile exactamente qué grabar antes de seguir.** No asumas que lo que hay sirve.

---

## FASE 2 — El corte

→ **`references/01-corte.md`** (método completo, no lo resumas de memoria)

En una línea: extraer audio → WhisperX da el inicio/fin exacto de cada palabra → tú eliges
el hilo rojo (una sola toma buena por idea, ordenadas como historia) → `build_wx.py` corta
en bordes exactos de palabra y borra solo los huecos sin voz.

El resultado es una lista de cortes que aterriza igual en cualquier herramienta. **El corte
queda cerrado aquí.** De la Fase 3 en adelante nadie vuelve a mover un punto de corte.

---

## FASE 2b — El BRIEF DE RECURSOS (hazlo SIEMPRE, antes de construir nada)

→ **`references/08-brief-recursos.md`**

Con el corte cerrado y la transcripción del render en mano, **propón tú el plan visual completo
antes de tocar After Effects**. No esperes a que te pidan elemento por elemento.

Lee el guion, identifica cada afirmación que pide una prueba visual, y entrega una tabla con:
**tiempo · qué dice · qué mostrar · tipo (lo construyo yo / lo consigue la persona) · recurso**.

Cierra con un **resumen corto de lo que necesitas que te consigan** — solo lo que no puedas
construir.

**Por qué esto va antes:** sin el brief, cada elemento cuesta una ronda de ida y vuelta
(mira → pide → construyes → vuelve a mirar). Con el brief, corrige todo de un tirón,
junta los recursos, y montas el video completo en una pasada. Es la diferencia entre veinte
mensajes y dos.

Guarda el brief como `brief-de-recursos.md` **junto al video**, no en una carpeta aparte.

---

## FASE 3 — El acabado (estilo y animación)

→ **`references/02-tecnica.md`** para las técnicas y los valores exactos
→ **`references/03-after-effects.md`** para ejecutarlas en AE vía MCP

**Trabaja sobre una copia, nunca sobre el corte cerrado.**

Las cuatro técnicas que hacen el 90% del resultado:
1. **Zoom de gancho** al abrir — `1.3 → 1.0`, frontal y rápido, luego se arrastra.
2. **La ola de punch in/out** — cada clip acelera hacia su corte; el corte cae en el pico.
3. **Fade exponencial** en todo texto — nunca lineal, siempre bloom.
4. **Sonido que coincide con el movimiento** — whoosh = movimiento, click = aparición sin
   movimiento, tick = check. Alineado al **pico** del sonido, no al inicio del archivo.

**⛔ DENSIDAD: algo tiene que moverse cada 2 segundos.** → `references/09-densidad-visual.md`
Medido sobre las referencias: un evento visual cada 1.6–2.2s. Ningún elemento estático más de
3 segundos; si va a durar más, tiene que evolucionar. **Se verifica midiendo el render final.**

**Genera 3–5 alternativas de cada momento estilizado y compáralas.** No te cases con la
primera. Así es como se acierta el gusto.

---

## FASE 3b — La música (PREGUNTA SIEMPRE si lleva)

→ **`references/10-musica.md`** (método completo y números aprobados)

**La música va por VIDEO, no por estilo.** Antes de montarla, **pregunta si este lleva o no**.

Cuando lleve, el objetivo no es "ponerle una canción de fondo" — es que **el guion y la música
vayan en el mismo ritmo y se apoyen entre sí**.

Las tres cosas que lo consiguen:

1. **El tempo se MIDE sobre los cortes**, no se elige de oído. Buscar el BPM + offset cuya
   rejilla cae más cerca de los puntos de corte del render, **puntuando contra el azar**
   (a BPM alto todo "encaja" y el número engaña). Aprobado: 118.5 BPM a 0.44 × el azar.
2. **La estructura sale del guion**: cada sección del argumento tiene su energía, y **el remate
   va en SILENCIO** para que la frase caiga sola. Ese silencio es la mitad del efecto.
3. **Siempre sintetizada.** Nada descargado: se construyen con ffmpeg (ruido filtrado +
   envolvente medida sobre la referencia).

⛔ **No usar `sidechaincompress` de ffmpeg** para el ducking: aplasta la música 34.6 dB por
debajo de la voz. La curva se calcula sobre la envolvente real de la voz y **se comprueba**:
12 dB por debajo mientras habla, +4 dB en los huecos.

---

## FASE 4 — Iterar con feedback

El corazón del pipeline. El feedback va a llegar impreciso (dictado por voz, texto rápido).
Tu trabajo es traducirlo a cambios concretos.

- Acepta lo vago ("no me gusta ese contorno", "se siente lento", "hazlo más flashy") y
  tradúcelo. Pregunta solo si de verdad es ambiguo.
- **Pide capturas marcadas** cuando el feedback sea de posición o timing. Una imagen con
  una flecha vale más que tres párrafos.
- **Sube de número SOLO cuando ya vieron la versión anterior.** Si la v2 era mejor que la v4,
  tiene que poder volver — pero eso solo aplica a lo que ya vieron.
  **Tus propias correcciones antes de enseñar la versión sobrescriben el mismo archivo.**
  Si no, se llega a v10 habiendo enseñado tres: los cortes intermedios son errores tuyos
  (palabras mochas, tomas mal elegidas) y ocupan cientos de MB sin aportar nada.
  Un video normal debería quedar en **corte → base → final**.
- Reporta cuánto tardó cada versión.
- **No te detengas después de una ronda.** Sigue hasta que la persona confirme.

Pregunta explícita al entregar cada versión: **"¿Esto te sirve o seguimos iterando?"**
Solo mira el monitor. No necesita entender qué pasó adentro.

---

## FASE 5 — Guardar el estilo (el DNA)

→ **`references/04-content-os.md`**

Cuando lo aprueben, **el trabajo no termina — se captura.** Sin este paso el
siguiente video arranca desde cero otra vez.

1. Guarda el proyecto como plantilla reutilizable, nombrada **por estilo**, no por video.
2. Escribe `content-os/styles/experimental/<nombre>/dna.md`: paleta, tipografía, curvas,
   ritmo, efectos clave y para qué contenido sirve. Escrito para que se entienda **sin ver
   el video original**.
3. Guarda el link de referencia en `referencia.md`.
4. Pasa de `experimental/` a `proven/` solo cuando el estilo ya se usó con éxito en un
   video real publicado.

---

## FASE 6 — Control de calidad

Antes de dar algo por final:
- Revisa **cuadro por cuadro las transiciones y los momentos de texto**. Ahí es donde se
  rompen los estilos automatizados: timing raro, texto cortado, glitches.
- Verifica que ningún gráfico quede pegado al **borde derecho** — TikTok e Instagram
  recortan ahí.
- Verifica que ningún gráfico tape la cara.
- Haz tú la revisión primero. Solo pide su tiempo cuando ya pasó tu filtro.

---

## ⛔ Los tres archivos que SIEMPRE se conservan

Un video terminado deja exactamente **tres** archivos en `versiones/`, y **ninguno se borra**:

| | Qué es |
|---|---|
| **1. El corte** | Silencios y tomas malas fuera. El trabajo editorial caro. |
| **2. La base** | El render de After Effects: video + subtítulos + zooms. |
| **3. El final** | Con rótulos, apoyos y sonido. El que se publica. |

**No borrar nada después del OK.** El motivo es de negocio:
si un video funciona, va a querer **re-subirlo con variaciones**. Para eso hacen falta el corte y
la base — desde el final no se puede volver atrás.

Lo que sobra no son los tres archivos, es llegar a v10 habiendo enseñado tres: eso se evita
sobrescribiendo tus propias correcciones (Fase 4), no borrando después.

Deja igualmente junto al video las expresiones en texto (`expr_captions.txt`,
`expr_zoom_hook.txt`) y un `COMO-REHACER-LA-BASE.md`. **Una expresión que solo vive dentro de
After Effects se pierde al cerrar sin guardar** — pasó con el video del 2026-08-14.

---

## 📁 Cómo queda la carpeta de un video

Al abrir la carpeta de un día se tiene que ver **el crudo y poco más**. Los documentos de
trabajo hacen ruido: lo único que se abre a diario es `versiones/`.

```
2026-08-16/
  2026-08-16.MP4        ← el crudo
  ✅-APROBADO.md         ← la marca de su OK
  versiones/            ← LO ÚNICO QUE ÉL ABRE
  proceso/              ← todo lo demás: assets, scripts, transcripciones, logs, briefs
```

Se ordena con:

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/skills/editor-de-video/scripts/ordenar.py <carpeta>
python3 ${CLAUDE_PLUGIN_ROOT}/skills/editor-de-video/scripts/ordenar.py --todas
```

**Correrlo al terminar cada video**, antes de pedirle el ✅.

⛔ **No borra nada** — mueve. Y **no rompe los scripts**: dentro de `proceso/` deja enlaces a
`versiones/` y al crudo, y reescribe las rutas absolutas guardadas en los `plan.json`.

⛔ Los scripts buscan la biblioteca compartida de b-roll subiendo dos niveles desde la carpeta
del video. Al meter `scripts/` dentro de `proceso/` esa cuenta se corre un nivel, así que hay
un enlace `content-os/raw-footage/b-roll -> ../b-roll` que lo resuelve. **No borrarlo.**

## ✅ Cómo se sabe que un video está APROBADO

**Tener un render final NO es tener el OK.** Un video solo está aprobado cuando lo dicen, y
ese OK tiene que quedar escrito donde lo vea cualquier chat y cualquier sesión futura — no en
la conversación, que se pierde.

**La marca es `✅`**, y vive en un archivo dentro de la carpeta del video:

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/skills/editor-de-video/scripts/aprobar.py content-os/raw-footage/<fecha> --nota "lo que dijo"
```

Eso escribe `✅-APROBADO.md` con la versión aprobada, la fecha y su frase. Para ver el estado
de todos de un vistazo:

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/skills/editor-de-video/scripts/aprobar.py --listar
```

`✅` aprobado · `🟡` editado, falta el OK · `⬜` sin editar.

**Antes de dar por cerrado un video, publicarlo o distribuirlo, mirar la marca.** Y si después
del ✅ se sube de versión, el OK caduca: hay que volver a pedirlo.

## ⛔ Cómo se identifica la versión final (regla estricta)

Vale para **todos los videos**: publicar, mandar, retomar el trabajo, distribuir a Metricool.

**Solo compiten los archivos cuyo nombre empieza con `v` seguido de dígitos y un separador**
(`v1-corte.mp4`, `v10-final.mp4`). Todo lo demás se ignora: `hook-v3-final.mp4`,
`comparacion-color.mp4`, pruebas sueltas. No son versiones del video, son piezas de trabajo.

**El número se compara COMO NÚMERO, nunca como texto.** Ordenar por nombre pone `v9` encima de
`v10` porque compara carácter por carácter y `9` > `1`. En la carpeta `2026-08-13` eso agarraba
`v9-base.mp4` — el render sin rótulos — en vez de `v10-final.mp4`.

**Empate de número** (existen tres `v1-gap*` en una carpeta): gana el más reciente por fecha de
modificación.

Nunca decidir "a ojo" mirando el listado. Usar:

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/skills/editor-de-video/scripts/version_final.py <carpeta-del-video>
```

Con `--todas` muestra qué archivo cuenta y cuál se descarta.

---

## FASE 7 — Producción en lote

Cuando ya hay un estilo listo — del plugin o en `proven/` — y llegan clips nuevos:

1. Carga la plantilla y su `dna.md`.
2. Por cada clip: Fase 2 (corte) → aplica la plantilla → adapta textos y duraciones.
   **Las animaciones, curvas y ritmo no se tocan** — esa es la identidad.
3. **QC individual por video** (Fase 6). Un estilo que funcionó en un clip no se ve bien
   automáticamente en todos.

**Premiere Pro está fuera de alcance de este plugin.** Para proyectos largos el camino es el
mismo: ffmpeg arma el corte y After Effects, si está, hace los motion graphics.

---

## Límites honestos (dilos, no los escondas)

- **La música ya se resolvió, pero sintetizada** (Fase 3b). Lo que
  sigue fuera de alcance es **elegir una canción de catálogo**: no se descarga ni se extrae
  nada. Y el calce con los cortes **nunca va a ser perfecto** — el habla no es un metrónomo.
  Di el número medido (mediana de distancia corte↔golpe), no "quedó sincronizado".
- **El color grading está fuera de alcance.** Se hace aparte.
- **El puente MCP de After Effects es un proyecto de la comunidad**, no un producto oficial.
  Si algo se comporta raro, pide una captura del panel en vez de adivinar.
- **Este pipeline no es creativo.** Reproduce y ejecuta un criterio que viene de afuera.
  Sin referencia no hay resultado bueno.

## Archivos de referencia

| Archivo | Cuándo abrirlo |
|---|---|
| `references/01-corte.md` | Fase 2 — siempre que haya que cortar |
| `references/02-tecnica.md` | Fase 3 — zooms, texto, sonido, assets |
| `references/03-after-effects.md` | Fase 3 y 7 — ejecutar en After Effects |
| `references/04-content-os.md` | Fase 5 — guardar un estilo |
| `references/05-brief.md` | Fase 1 — arrancar algo nuevo |
| `references/06-recrear-estilo.md` | Un link de referencia → estilo guardado |
| `references/07-instalacion.md` | Falta alguna pieza técnica |
| `references/08-brief-recursos.md` | Fase 2b — el plan visual antes de montar |
| `references/09-densidad-visual.md` | Fase 3 — verificar que algo se mueve cada 2s |
| `references/10-musica.md` | Fase 3b — cuando el video lleve música |

# Fase 3 — Técnicas de acabado

> Estos son **principios con números exactos**, no plantillas. Se ejecutan igual en After
> Effects, en Remotion o en ffmpeg. Cómo ejecutarlos en AE: `03-after-effects.md`.

**El corte es sagrado.** Aquí nunca se re-elige una toma ni se mueve un punto de corte.

## Reencuadre 9:16 — revisa la fuente primero

Lienzo **1080×1920**. Antes de cualquier cálculo de relleno:
- **Fuente ya vertical** (ej. 2160×3840): el lienzo 9:16 llena perfecto. Escala 1.0 = cuadro
  completo limpio; >1 hace punch-in.
- **Fuente 16:9**: hay que escalar para llenar (recortando los lados) o salen barras.

---

## TÉCNICA 1 — Zooms animados

El video se mantiene vivo porque **siempre hay movimiento sutil**. Tres movimientos hacen casi
todo el trabajo.

### Zoom-OUT de gancho (apertura)

Un retroceso rápido-luego-lento al inicio atrapa la atención. **Escala `1.3 → 1.0`** con
**ease-out frontal**: casi todo el movimiento en los primeros ~0.6s, después se arrastra hasta
detenerse. En keyframes a 24fps:

```
[frame 0]=1.3  [6]=1.13  [14]=1.05  [26]=1.01  [40]=1.0
```

Un toque de motion blur **solo durante el movimiento** (obturador ~180°).
Perillas: escala inicial (drama), separación de keyframes (snap vs. calma), frame de asiento.

> **⛔ CENTRO BLOQUEADO en cualquier zoom que baje a ≤ 1.0.** El centro del zoom se queda en
> **0.5, 0.5 (centro del cuadro). NUNCA lo desplaces.** En el instante en que la escala llega
> a ≤ 1.0, un zoom descentrado **expone NEGRO en el borde** y saca al sujeto de cuadro. En un
> retroceso solo se anima la *escala*.

### La ola de punch-IN / punch-OUT (energía de medio video)

Mantiene el movimiento constante para que el espectador no se canse. El ritmo:

- **Intros = punch OUT** (arranca acercado, se abre — el gancho).
- **Cortes de medio video = una ola:** cada clip **hace punch IN al FINAL** (el zoom acelera
  hacia el corte) → el corte cae en el pico → el siguiente clip **arranca acercado y hace
  punch OUT al inicio** (se asienta), luego hace punch in en SU final → se repite.
  El corte queda escondido dentro de movimiento continuo, con ambos lados en el pico.
- **La curva "stretch":** más zoom + ease-out DURO — velocísimo al salir, luego arrastre largo.
  Ejemplo de punch-out:

```
[0]=1.5  [3]=1.15  [8]=1.04  [16]=1.005  [24]=1.0     (≈70% del movimiento en 3 frames)
```

  Espejéalo para el punch-in. Acompáñalo con zoom-blur fuerte durante la parte rápida.
- **Hazlo POR CLIP** (un zoom independiente en cada uno), para que cada lado del corte tenga
  su propio movimiento.

### Centro del zoom en un zoom-IN puro

En un movimiento que se queda **≥ 1.0** (push-in que nunca baja del cuadro completo), *sí*
puedes sesgar el centro hacia lo que quieras enfatizar (ej. 0.5, ~0.6 para "inclinar la cámara"
hacia un gráfico de la franja superior). **Solo se permite si la escala nunca baja de 1.0** —
si no, aplica el bloqueo de centro de arriba.

### Efectos de lente que se intensifican DURANTE el movimiento

- **Zoom blur** — desenfoque direccional cuya fuerza pico coincide con la parte rápida y
  regresa a 0 en reposo.
- **Aberración cromática** — desplazamiento radial de canales RGB, pico durante el movimiento.
- **⛔ El motion blur se LIMITA AL MOVIMIENTO, nunca al clip completo.** Si difuminas todos los
  frames, las manos y objetos en movimiento se embarran todo el clip. Al asentarse, el clip
  DEBE quedar nítido.
- **Todo zoom quiere un SONIDO.** Un riser/whoosh alineado al movimiento. Un zoom con motion
  blur y sin swell de audio se siente vacío.

---

## TÉCNICA 2 — Fade exponencial de texto

La firma del texto en pantalla. **Nunca un fade lineal.** El texto debe *florecer*: rápido al
inicio, asentándose lento, para que se sienta que **se materializa** en vez de disolverse.

- **Opacidad** sobre curva exponencial / ease-out: `opacity = 1 - e^(-k·t)`. Sube casi todo de
  golpe, luego se acomoda.
- **Acompáñalo con una deriva sutil hacia arriba + desenfoque a nítido**: arranca ~10px abajo y
  ligeramente borroso, se asienta en posición y nítido con el mismo ease-out.
- **La salida es el espejo** — un levantar-y-desenfocar rápido, no un fade plano.

Aplica a **todo** elemento de texto: énfasis de captions, lower-thirds, voz del editor.

---

## TÉCNICA 2b — CAPTIONS PALABRA POR PALABRA (probado en producción)

Una palabra a la vez en pantalla, sincronizada al habla. Es la firma de los creadores de
formato corto de gama alta, y **a mano son cientos de capas**. Aquí es **UNA sola capa**.

**El truco:** una expresión en `Source Text` que lleva adentro las palabras y sus tiempos, y
elige cuál mostrar según `time`. Se pone una vez y no lleva un solo keyframe.

```javascript
var P="Mira,|con|un|cliente|...".split("|");   // las palabras
var D=[5,28,18,12,52,...];                      // deltas en centesimas de segundo
var t=time*100,a=0,s="";
for(var i=0;i<D.length;i++){a+=D[i];if(a>t)break;s=P[i];}
s
```

**Codificación compacta — importa.** Con 754 palabras, guardar inicio y fin en segundos da
~14.000 caracteres. Guardando **solo el inicio** (la palabra dura hasta que empieza la
siguiente) y los tiempos como **deltas en centésimas**, baja a ~6.400. Mitad de tamaño y
evalúa más rápido por cuadro.

**Huecos:** donde hay una pausa > 0.45s, inserta un evento con texto vacío para que la última
palabra no se quede colgada en pantalla durante el silencio.

**De dónde salen los tiempos:** de transcribir **el archivo renderizado**, no de calcularlos.
Ver la regla dura en `01-corte.md`. Este es exactamente el caso donde predecir falla.

**Ajustes de gusto:** posición justo arriba de la ventana del hablante; tamaño 54-64px en
1080×1920; peso bold. En español las palabras son más largas que en inglés — si se siente
saturado, agrupar de 2 en 2 es un cambio de una línea en el generador.

---

## TÉCNICA 3 — El look "authority stack"

El texto de "voz del editor" / cita destacada: **las palabras salen de una neblina suave y
frenan con speed-ramp hasta asentarse**, apiladas, bold, tracking apretado. Se lee como algo
autoral y deliberado, no como un caption por defecto.

- **Bold, letter-spacing apretado** (≈ -0.04em), alto contraste, cómodamente grande.
- **Cada línea entra con subida-desde-neblina**: empieza abajo + borrosa + tenue, sube a su
  lugar mientras se define — con el ease-out de la Técnica 2 y un ligero speed ramp.
- **Apila las líneas** de modo que las posteriores queden ligeramente detrás/debajo (un dejo de
  profundidad).
- **Salida = levantar + desenfocar.** Nunca un corte plano.
- **Para la "voz del editor"** (el texto que habla como tu editor IA): dale un color de acento
  cálido para que se lea como una voz distinta, y anímalo exactamente como el authority stack.

---

## ⛔ ZONAS SEGURAS DE PLATAFORMA (medida fija — verificada)

Instagram y TikTok **dibujan su interfaz encima de tu video**: usuario, copy y botones abajo,
botones de acción a la derecha. Nada importante puede vivir ahí.

Sobre un lienzo de **720×1280**:

```
┌───────────────────────────┐
│                           │
│      ZONA SEGURA          │
│                           │  ← todo el contenido va aquí
│                    ┌──────┤
│                    │ 115px│  ← botones de acción (derecha)
├────────────────────┴──────┤
│      240 px               │  ← usuario, copy, botones (abajo)
└───────────────────────────┘
```

- **Franja inferior: 240 px** (de y=1040 a 1280) → en 1080×1920 son **360 px**
- **Franja derecha: 115 px** (de x=605 a 720) → en 1080×1920 son **170 px**

**La cara del hablante NUNCA puede entrar ahí.** En el primer montaje real la ventana llegaba
hasta abajo y la interfaz le tapaba de la nariz para abajo: hablaba y no se le veía la boca.

**Layout de dos zonas corregido, en 720×1280:**

| Elemento | Posición |
|---|---|
| Panel de contenido | 0 → 660 |
| Captions | y = 605 |
| Ventana del hablante | 660 → 1060, **490 px de ancho**, centrada |
| Margen muerto | 1060 → 1280 (aquí va la interfaz) |

Con la ventana inset, el video se escala al **68%** y se coloca en `[360, 845]` para que la
cara quede encuadrada dentro.

> **Las esquinas redondeadas de la ventana no se pueden hacer con este puente** — requieren una
> máscara sobre el footage y no existe ese comando. La ventana queda rectangular.

---

## Reglas para gráficos y assets propios

- **REGLA 0 — MIRA el asset antes de usarlo.** Nunca elijas un gráfico por su nombre de
  archivo. Un gráfico cuyo significado contradice la línea hablada es un error.
- **REGLA 1 — Debe coincidir con la línea EXACTA sobre la que va.** Aparece solo mientras se
  dice esa cosa y desaparece en el instante en que el tema pasa. Re-textéalo con las palabras o
  el número exacto que se están diciendo.
- **REGLA 2 — Imágenes del usuario (capturas/fotos):** pequeñas, agrupadas en el **espacio
  negativo alrededor de la cara** (default confiable: una **rejilla 2×2 en la franja inferior,
  arriba de los captions**), **aparecen tal cual** (sin deslizar ni escalar), en **sucesión
  rápida (~3 frames de separación)**, en pantalla **solo durante su sección**, nunca sobre la
  cara, nunca encimadas.
- **REGLA 3 — Re-textea en el ORIGEN y re-renderiza.** Cada gráfico es una PLANTILLA
  re-texteable; cambias el texto en la composición fuente y re-renderizas con alfa. Nunca
  superpongas texto sobre un render ya quemado.
- **REGLA 4 — El PARALLAX es obligatorio sobre un clip que hace zoom.** El **footage hace
  zoom** Y el **gráfico hace un poco MÁS de zoom** (el primer plano se inclina hacia adelante),
  sincronizado a los mismos frames. Si solo el gráfico hace zoom, no se lee. (Elementos
  trackeados, como un retículo sobre un dedo, NO llevan parallax — el zoom rompe el lock.)
- **REGLA 5 — El SFX se hornea por asset.** Cada asset lleva SU propio SFX sutil alineado a sus
  keyframes de entrada — no una cama gigante de sonido sobre toda la timeline. Ponle un SFX
  sutil a básicamente todo lo que anime hacia adentro.
- **⛔ REGLA 6 — NADA pegado al borde derecho.** TikTok, Instagram y otras plataformas recortan
  esa zona con su propia interfaz. Deja margen.
- **DISCIPLINA DE LAYOUT:** no dispares elementos arriba/centro/abajo. Agrúpalos para que el
  ojo se quede en una zona.

---

## TÉCNICA 4 — Diseño de sonido

**El tipo de sonido ES el movimiento.** Elige por lo que se mueve, después alinea el pico.

- **WHOOSH = un ZOOM / movimiento.** El largo del whoosh **debe coincidir con el largo del
  zoom** (zoom lento y largo → whoosh largo; zoom rápido → whoosh corto y seco).
- **CLICK / SNAP = un cambio súbito SIN movimiento** (una tarjeta que aparece de golpe sin
  desplazarse → click, no whoosh).
- **TICK = un checkmark / toggle** (sutil).
- **NADA en cortes simples de b-roll** — ahí los whooshes no pegan.
- **ALINEA AL PICO, no al inicio del archivo.** Analiza la forma de onda, encuentra el pico
  transitorio y recorta el silencio inicial para que **el pico caiga exactamente en el evento
  visual**. Truco reutilizable: haz el SFX simétrico con el **pico al centro**, luego coloca el
  clip centrado en el corte — el pico cae bien siempre. **Baja los whooshes de volumen**;
  casi siempre quedan demasiado altos.
- **SIEMPRE lee la FORMA DE ONDA, no la duración** — la duración miente. Revisa qué tan seco es
  el ataque, dónde está el pico y qué tan profundo es antes de elegir o colocar un sonido.

### Reverb throw — `scripts/reverb_throw.sh`

El movimiento de audio de firma: el clip suena **limpio/seco**, y al cortar **el último
instante florece en una cola de reverb** que se arrastra al silencio — NO reverb en todo el
clip, solo en el final. Da profundidad en los puntos de corte (apílalo bajo un riser/whoosh).

- Motor = **SoX Freeverb** (`brew install sox`) + ffmpeg. (El `afir` de ffmpeg está roto en
  muchas compilaciones — devuelve silencio. La versión wet-only de SoX es la buena.)
- `reverb_throw.sh IN.wav OUT.wav [THROW_SEC=0.7] [REVERB=78] [TAIL_PAD=4] [WET=1.0]`
- Perillas: THROW_SEC (cuánto del final florece), REVERB (largo/densidad de la cola), WET
  (nivel del bloom). Salida normalizada a −3 dB.

---

## TÉCNICA 5 — "Toma del editor" (opcional, firma de marca)

Movimiento divertido de medio video: la persona dice *"deja que mi editor te explique esto"* →
corte a un explicador corto de motion graphics narrado con voz IA → vuelve a cámara. Ella es
el gancho; el editor es la capa de claridad.

- Constrúyelo con plantillas de slides de texto propias, narra con TTS (ej. ElevenLabs).
- **Sincroniza el texto a los timestamps de palabra del VO.**
- Usa el fade exponencial / authority stack para el texto.
- **Que hable con su voz** — usa `content-os/mi-voz.md` si existe (Fase 1).
- **Mantenlo parásito:** úsalo solo donde hay un hueco real en la explicación. No lo metas
  porque sí.

---

## Flujo de audición (la forma de terminar)

- **Renderiza 3–5 ALTERNATIVAS por momento estilizado** (distinta cantidad de zoom, distintos
  gráficos, distintos SFX) y compáralas, en vez de comprometerte con una. Esta es la forma
  confiable de acertar el gusto.
- **Coloca cada asset creado en la timeline.** Nunca dejes un render como archivo suelto en
  disco "para arrastrarlo después". Impórtalo, ponlo en su pista, en su lugar, habilitado.

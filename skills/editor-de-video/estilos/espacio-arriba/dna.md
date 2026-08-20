# Estilo `espacio-arriba`

**Hablante abajo, tercio superior libre para los titulares.** Es el estilo más denso de todos:
un evento visual cada 1.4 s.

⚠️ **Nivel 3 — necesita After Effects** para el render base (zooms y subtítulos). Si no lo
tienes, el pipeline baja al camino de ffmpeg: el corte y los titulares salen igual, pero se
pierden los zooms finos. Para trabajar sin Adobe, usa `yapping`.

Probado en `2026-08-13` → `versiones/v10-final.mp4` (70.4s) y en
`2026-08-20` → `versiones/v3-final.mp4` (48.5s, aprobado el 2026-08-15).
Referencia: `styles/experimental/espacio-arriba-referencia.mp4`.

Hablante encuadrado abajo, con el tercio superior libre para los titulares. Es el estilo más
denso de los tres: **un evento visual cada 1.4 s** (en el 2026-08-20 se midió 1.08 s).

---

## 1. Encuadre

| | |
|---|---|
| Formato | 1080 × 1920, 30 fps constante |
| Hablante | encuadrado abajo; la cabeza ocupa **x 390-750** (hasta 824 si se inclina), arranca en **y ≈ 600** |
| Franja de titulares | **y 150-520**, siempre libre |
| Zonas seguras | inferior 360 px, derecha 170 px (solo por debajo de y ≈ 1000) |
| Subtítulos | y = 1330, agrupados por **caracteres (máx 24)**, nunca por palabras |

### ⛔ El sitio de los apoyos se MIDE por video — la tabla de arriba es del 2026-08-13

Él graba a distintas distancias según el día, así que **la caja libre cambia de un video a otro**
y una plantilla rígida rompe el estilo en vez de acelerarlo. Se mide siempre antes de colocar nada
(`raw-footage/2026-08-20/scripts/medir_encuadre.py`):

1. Sacar frames a 4 fps del corte.
2. Marcar al sujeto y listar, por caja candidata, las ventanas con **< 8% de ocupación**.
3. Asignar cada apoyo a una ventana limpia medida.

**Cómo marcar al sujeto — dos detectores, según el cuarto:**

| Cuarto | Detector | Por qué |
|---|---|---|
| Pared clara neutra | piel (`r>95, g>40, b>20, r>g+15, r>b+15`) | el del dna de yapping |
| **Pared beige** | **sustracción de fondo**: la mediana temporal de los frames es la pared, y lo que se aparta de ella es la persona | la pared beige **pasa el test de piel**: la franja alta, vacía, medía **92% de piel** |

**Lo que salió medido en el 2026-08-20 y contradice la plantilla:** el lado **derecho es su cara**
(25.6% de ocupación media, picos de 84%) y el izquierdo está libre (4.8%). Ahí los apoyos
**NO alternan lados** — van todos a la izquierda. La franja alta sí estaba libre el 100% del video.

---

## 2. Tipografía

**Helvetica Neue Bold Italic** para el acento y **Helvetica Neue Bold** para lo neutro.
Identificada comparando los glifos contra los rótulos, no de memoria: gana con 59.5% de
coincidencia media contra Avenir Next (56.4%) y Arial (54.6%).

- **Amarillo `#FFD62E` en itálica** = la palabra que carga el significado
- **Blanco** = el resto de la frase
- Pesos mezclados en el mismo bloque (número grande claro + palabra en negrita)

**Escala de los rótulos: 26.7%** sobre PNG generados a 5x. Todos la misma — nunca escalar "al
mismo ancho", porque una palabra corta sale gigante y tapa la cara. Tope de ancho: si el bloque
pasa de ~930 px en pantalla, se baja la escala (le pasó a dos rótulos: 25.1% y 24.3%).
Las palabras del hook van al **36%**.

### ⛔ La sombra nunca toca el borde del PNG
Si el halo llega al borde del archivo se corta en seco y en pantalla se lee un **cuadrado de
sombra**. Se construye con dos gaussianas —**σ3 al 60% + σ8 al 38%**— sobre un lienzo con
36 px de margen, y se comprueba que el borde queda en **alfa 0 exacto**.
Sin `Drop Shadow` de After Effects: el halo va horneado en el PNG.

---

## 3. El hook (0-6 s)

Se graba **dejando silencios** entre las palabras clave. La edición los convierte en tensión con
una **escalera de zooms**, no los recorta:

| | |
|---|---|
| Palabra 1 | zoom 100 → 112 + golpe |
| Palabra 2 | zoom 112 → 124 + golpe más grave |
| Palabra 3 | zoom 124 → 138 + golpe más grave aún |
| Salida | zoom out de golpe a 100 + whoosh largo |

Cada palabra queda apilada en pantalla. **Que tapen la cara dos segundos aquí está bien** — es
el momento de mayor tensión, y quedó aprobado explícitamente.

---

## 4. Rótulos de énfasis

Suben palabras clave a la franja alta durante la frase que las contiene.
**Entran bajando** desde 160 px arriba con desaceleración cuártica en **0.28 s**. Nunca aparecen
de golpe. Cada entrada lleva su sonido.

Además de las palabras sueltas, funcionan bien las **frases partidas en dos tiempos**
(`NO ES DISCIPLINA` → `ES SISTEMA`).

⛔ **La segunda línea cae 55 px, no 160.** Con los 160 del estilo, la línea de abajo **cruza por
encima de la de arriba** durante los 0.28 s de la entrada y se lee pisada. Se vio en
`AFTER EFFECTS` / `ni sé usarlo` (2026-08-20), con dos líneas separadas 115 px.

---

## 5. Carteles de sección

Marcan los pasos: `Paso 1` (blanco) · `El video` (blanco) · `GRABADO` (amarillo itálico).
Mismo tratamiento de entrada y de sombra que los rótulos.

---

## 6. Apoyos visuales — **lo que se espera cuando se piden animaciones**

Van **al costado de la cabeza**, alternando lados:

| | |
|---|---|
| Izquierda | x 15-415 |
| Derecha | x 740-1060 |
| Altura | y 515-870 |
| Caja mínima | **320 px**; texto **≥ 40 px**. A 250 px no se leen en teléfono. |

Reglas de animación:

- **Se dibujan o se transforman**, nunca aparecen quietos
- **Brillo (glow) en el instante de encaje**, no permanente
- **Entrada:** escala de 0.60 → 1.00 con desaceleración, 0.22 s
- **Salida:** encoge a 0.70 y se desvanece, 0.25 s
- **Cada entrada lleva sonido y cada encaje un clic**
- Mismo halo oscuro que los rótulos, para que se lean sobre la pared clara

Los seis del primer video probado: barra de energía vaciándose · tres cuadros dibujándose ·
calendario de 7 días con uno encendido · onda de audio recortándose sola · marca de Claude con
contador a 100% · palabra tachada que se convierte en otra marcada.

### Suben de nivel en cada video

*"la idea es que se vean cada vez más premium los recursos que creas"* (2026-08-15). No basta con
que el apoyo funcione: cada video tiene que subir el listón. Lo que se sumó en el segundo video y
aprobó (*"me encantaron, sí se ven más premium"*):

- **Panel oscuro con lavada de luz naciendo por debajo del borde inferior.** El contraste entre la
  mitad de arriba (casi negra) y la de abajo es lo que lo hace premium — no el icono.
  Ver [[motion-graphics-premium]].
- **Tarjetas rellenas y claras** (nunca contornos), con **insignia numerada** celeste `#7CB4EC` y
  el número en azul oscuro, y **conectores punteados** entre ellas.
- **Apagar un elemento es OSCURECERLO**, no lavarlo: sobre la pared clara el gris claro desaparece.
  Misma fuente, mismo cuerpo, misma posición — lo único que cambia es el color.
- **El estilo VARÍA entre gráficos.** En el mismo video convivieron paneles oscuros (contador,
  contador de 2 h → 3 min), tarjeta clara tipo recibo, y línea suelta con halo sobre el video
  (la barra de la tarde). No convertirlo en plantilla.

### ⭐ El apoyo puede ser un B-ROLL en cuadrito

Pedido suyo el 2026-08-20, sobre «y esto es lo que seguiría después»: donde había una captura de
pantalla planeada, se pidió **un b-roll propio trabajando en el escritorio, en pequeño arriba**.
Cuando la frase dice *"esto es lo que hacés después"*, el apoyo natural es **verlo haciéndolo**.

- Tarjeta con **borde claro + sombra horneada** para que flote sobre la pared, esquinas de 26 px.
- **Siempre sin sonido.**
- **Ojo con la orientación:** su b-roll de escritorio está grabado en vertical (`rotation=-90`).
  Un recorte 16:9 le corta la cabeza; el **cuadrado** es el único que deja cabeza Y manos.

---

## 7. Sonido

Medido en la referencia: **el 69% de los eventos visuales lleva golpe de audio** (control
desplazado: 29%, o sea la sincronía es deliberada).

Todo se **sintetiza con ffmpeg** — ruido filtrado con envolvente, barridos de frecuencia. No hace
falta comprar ni descargar packs.

| Evento | Sonido |
|---|---|
| Entrada de rótulo | aire corto ascendente, pico ≈ **−13.7 dB** (a −22 dB no se notaba) |
| Cartel de sección | igual pero con más cuerpo |
| Palabra del hook | golpe grave, cada uno más profundo |
| Zoom out | whoosh descendente largo |
| Entrada de apoyo | aire suave |
| Encaje de apoyo | clic corto y brillante |

Mezcla final a **−14 LUFS**, pico real −1.5 dBTP.

## 7b. Música (se pregunta video por video)

El estilo la admite, pero **no la trae puesta**: se pregunta siempre. Cuando lleve, va sintetizada
y **cuadrada con los cortes** — método completo en `references/10-musica.md`.
Medido en el 2026-08-20: **123.00 BPM, offset 0.425 s**, mediana de 38 ms entre corte y golpe,
11 de 20 cortes por debajo de 80 ms, y **silencio en seco sobre la frase de remate**.

---

## 8. Cadena de montaje

1. **ffmpeg corta** en una sola pasada (`trim`/`atrim` + `concat` en `-filter_complex`)
2. **La base** (video, subtítulos, zooms): After Effects, **o ffmpeg si el puente está ocupado**
3. **ffmpeg compone** rótulos, apoyos y toda la mezcla de sonido

**La base también sale entera con ffmpeg** (probado y aprobado en el 2026-08-20, con AE ocupado
por el proyecto del video largo): zoom por clip con `zoompan` sobre la fuente a 1728 px, y
subtítulos como secuencia PNG de una franja de 1080×230 en y = 1225. Ventaja: libera el puente de
AE para que otro chat trabaje en paralelo.

> ⛔ **`zoompan` deja los timestamps rotos.** Sin `settb=AVTB,setpts=N*1001/30000/TB` detrás de
> cada `zoompan`, el concat salió de **70 minutos** en vez de 48 segundos (127.580 cuadros en vez
> de 1.454). No da ningún error.
>
> El zoom va **por clip con tiempo local (`it`)**, nunca sobre la timeline global: así no hay
> deriva de cuadros que corregir y todo cae sobre los tiempos ya medidos en el render.

Los rótulos **no** se montan en After Effects: no relee los PNG cambiados en disco sin reabrir el
proyecto, y en este estilo se itera mucho sobre tamaño y sombra. Con ffmpeg un ajuste es un solo
comando. Para sacarlos de AE: `batchSetLayerProperties` con `opacity: 0`.

Scripts de referencia en `raw-footage/2026-08-13/scripts/`.

---

## 9. Grabación de pantalla

860 px de ancho en y = 1180. Los subtítulos **bajan solos a y = 1560** mientras dura y vuelven
después. A 480 px no se leía nada.

### ⭐ Si la pantalla ya está EN el plano, no pidas la captura: acércate

En el 2026-08-20 pedí tres capturas de pantalla y las tres ya estaban grabadas — se veían en la
laptop que sostiene en el plano. En vez de grabar nada extra, el video **se acerca a la pantalla de la
laptop** mientras dice la frase:

- Ventana 9:16 **medida sobre el render** (aquí x 0-630, y 800-1920) → zoom **1.71×**.
- A 1728 px de fuente eso son 1008 px de recorte escalados a 1080: **casi 1:1, no se ablanda**.
- Se sostiene ~2 s, entra con whoosh y sale con whoosh descendente + rótulo encima.
- El bloqueo de centro no aplica: la escala nunca baja de 1.0.

**Antes de pedirle que grabe algo, mira el footage cuadro por cuadro.** Es lo que convirtió la
línea más débil del brief en la prueba más fuerte del video.

---

## ⛔ Reglas que costaron un fallo real

1. **MEDIR, NUNCA PREDECIR.** Los tiempos salen de transcribir el archivo renderizado. Predecir
   dio 4.9 s de deriva en subtítulos.
2. **La posición y la escala también se miden.** La expresión de posición de AE lleva su propia
   altura dentro del código, distinta de la que reporta el puente: predecirla metió 160 px de
   error en 17 de 18 rótulos. Se mide el centro del amarillo en el render aprobado.
3. **Cortar en una sola pasada.** Cortar a N archivos y concatenar desincronizó el audio 2.97 s.
4. **Frame rate constante siempre** (`-r 30 -fps_mode cfr`). Un VFR hizo que AE renderizara 2.7%
   acelerado.
5. **QC obligatorio:** transcribir el render y comparar contra el original. Ninguno de los fallos
   encontrados hasta hoy dio un mensaje de error.
6. **Proponer antes de montar.** Siempre dar las ideas y en qué segundo van ANTES de tocar AE.

---

## Sin colorización

La probó (cine, ámbar) y prefirió el original. **No se colorea.**

---

# Actualización 2026-08-17 — segundo video del estilo (`raw-footage/2026-08-17`)

Aprobado (*"me gustó, quedó re bien"*). Montado **entero con ffmpeg**, sin After Effects.
Tres cosas de arriba dejaron de ser ciertas y una técnica nueva se suma.

## ⛔ 1. Los niveles de sonido de la sección 7 están MAL — no los uses

Los números de arriba (rótulo a **−13.7 dB**, barridos de 900 a 3400 Hz, con la nota
*"a −22 dB no se notaba"*) los rechazó en cuanto los oyó en este video:

> *"está muy agudo, es como un chirrido... que complemente, que no llegue a tapar mi voz...
> hazlo más grave y con menos volumen"*

**El problema no era el volumen, era la banda:** esos barridos caían justo encima del
centroide de su voz y competían. Lo aprobado ahora:

| Evento | Pico | Centroide |
|---|---|---|
| Entrada de rótulo | **−26 dB** | 541 Hz |
| Cartel de sección | **−24 dB** | 464 Hz |
| Entrada de apoyo | **−28 dB** | 268 Hz |
| Encaje (ya no es un clic brillante, es un tic grave) | **−28 dB** | 393 Hz |
| Whoosh de apertura | **−22 dB** | 411 Hz |
| Golpe del gancho | **−14 dB** | 128 Hz |

**Regla: el 90% de la energía de todo el lecho por debajo de 760 Hz.** Ver la memoria de
sonidos sintetizados — es la que manda cuando choque con este documento.

## ⛔ 2. Los costados dependen del ENCUADRE, no del estilo

La sección 6 dice izquierda x 15-415 / derecha x 740-1060 porque en el primer video la
cabeza ocupaba x 390-750. **En este ocupaba x 600-930 y la derecha simplemente no
existía**: los apoyos de ese lado salían cortados por el borde y encima del hombro.

**Medir la cabeza en el render antes de repartir los lados.** Si solo hay un costado
libre, van todos ahí **alternando dos sitios** (x 40/y 505 y x 110/y 585) para que no
queden clavados en el mismo punto. Y decírselo: si se sienta más al centro-izquierda,
se recupera la alternancia.

## 3. El gancho de escalera necesita silencios GRABADOS

Si la toma viene de corrido no se puede armar y **no hay que forzarlo**. Lo confirmó:
*"está bien que no lo apliques porque no quedaba bien... qué bueno que no lo aplicaste
automáticamente"*. El repuesto que sí funciona: zoom 1.30 → 1.00 en 0.7 s + punch con
golpe grave sobre la palabra que carga el gancho.

## ⭐ 4. Técnica nueva: el elemento que CRUZA el cuadro entero

Quedó muy bien. Un monigote de palitos cae desde el borde de arriba hasta
salirse por abajo sobre *"tu negocio no tiene un piso"* — 2.8 s, manoteando y dando
tumbos, mientras la persona sigue hablando.

Lo que lo hace funcionar:

- **Cae por el carril del apoyo que ya estaba** (la casita con el piso hueco), así que
  la atraviesa y se sale por donde falta el piso: el chiste se cierra solo.
- **Va montado DEBAJO de rótulos y subtítulos.** Encima tapaba media línea de subtítulo.
- **La posición es una expresión de `overlay`**, no PNG de 1080x1920 por cuadro: el
  sprite solo trae el manoteo y el tumbo.
- **La aceleración no es la real.** Con `pow(p,2)` pasaba tan rápido que no se leía;
  con `pow(p,1.55)` se ve caer los 2.8 s enteros.
- **El sonido se apaga siguiendo la MISMA curva de la caída**, no con un fade genérico:
  −38 dB arriba → −41 → −54 → silencio en el último 20%. Eso es lo que lo hace leer
  como que se aleja.

Sirve para cualquier idea de "caída", "desplome" o "se te va". Escrito en
`scripts/caida.py` y `scripts/grito.py`.

## ⛔ 5. El pico real no se mide con `volumedetect`

La mezcla marcaba −2.2 dBFS de pico de muestra y tenía **+0.4 dBFS de pico real**.
`loudnorm` no lo arregla: no puede cumplir el TP pedido, se cae a modo dinámico y da un
número distinto en cada corrida (bajarle 0.6 dB de ganancia subió el pico 3 dB).
Lo determinista es limitar en sobremuestreo y medir con `ebur128=peak=true`:

```
volume=-0.4dB,aresample=192000,alimiter=limit=0.86:level=disabled,aresample=48000
```

## 6. Números del video aprobado

50.9 s · 22 rótulos · 8 apoyos · 47 subtítulos · un evento cada **1.31 s** (hueco mayor
2.54 s) · música a **109 BPM** medidos sobre los cortes (0.43 × el azar, calce mediano
59 ms) · ducking 11.7 dB bajo la voz · **−13.9 LUFS, pico real −2.3 dBFS**.

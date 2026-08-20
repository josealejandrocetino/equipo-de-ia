# Estilo: yapping

**El estilo de arranque.** Pantalla completa, titular fijo arriba, captions por frases y apoyos
visuales que entran de golpe.

⛔ **No necesita After Effects.** Se monta entero con ffmpeg + Chrome, así que funciona con
el **nivel 2** — solo el instalador. Comprobado de punta a punta en videos publicados.

Estado: **PROVEN** — tres videos montados y aprobados:
`2026-08-11-ia-locura` (publicado el 2026-08-13), `2026-08-15` «el link roto» y
`2026-08-19` «el cliente caro» (aprobado el 2026-08-15: *"quedó perfecto, este es el
oficial"*).

> 📌 **El video de referencia del estilo hoy es `2026-08-19`.** Es el único que tiene el
> halo bueno, los apoyos sin recortar y los b-rolls reproduciéndose. Para el siguiente
> video, copiar sus scripts — no los del «link roto».

> ⚠️ **Este documento describe un rango, no una plantilla.** Los dos videos aprobados tienen
> encuadres opuestos y por eso los apoyos van en sitios opuestos. Cuando llegue un video nuevo,
> **mide** — no copies las coordenadas. Ver *«Dónde van los apoyos»*.

## Referencias

`content-os/styles/experimental/yapping-referencia-1` a `-4`, todas 720×1280.
Duraciones: 241s · 33s · 57s · 73s.

---

## La idea en una frase

**Tú a pantalla completa hablando, y cada cosa que nombras aparece como imagen.** Sin paneles,
sin listas, sin motion graphics. La imagen carga todo el peso.

Es el opuesto de `kallaway-dos-zonas`: allá se construye el gráfico, aquí **se muestra la cosa**.

---

## Estructura

```
┌───────────────────────────┐
│   TITULAR FIJO (2-3 líneas)│  ← se queda TODO el video
│                           │
│   [img]        [img]      │  ← imágenes en el espacio libre
│         TÚ                │     alrededor de la cabeza
│      pantalla             │
│      completa             │
│                           │
│      caption (frase)      │  ← tercio medio-bajo
│                           │
│                    [img]  │
└───────────────────────────┘
```

**Sin recorte ni ventana: el video ocupa todo el cuadro.** Por eso este estilo sí admite
grabación vertical cerrada — al revés que `kallaway-dos-zonas`.

## Los cuatro elementos, y no hay más

| Elemento | Cómo |
|---|---|
| **Titular fijo** | Arriba, 2-3 líneas, presente del segundo 0 al final. Es el contexto que ancla todo. Puede llevar una línea entre paréntesis como remate. **Empieza en minúscula** y **lleva sombra suave** — ver abajo. |
| **Captions** | **Frases cortas, NO palabra por palabra.** Centrados, tercio medio-bajo. Blanco con sombra suave. Tamaño discreto — no compiten con la cara. |
| **Imágenes** | Rectángulos pequeños, **sin marco ni borde**. Aparecen y desaparecen. Se colocan en el espacio libre a los lados de la cabeza. **Hasta 3 a la vez.** |
| **Hablante** | Pantalla completa, quieto. Sin zooms ni punch-ins. |

## ⛔⛔ El titular NO se inventa: se pregunta

El titular de arriba **no lo escribe el editor**. Es la frase con la que la persona pensó el
video, y casi siempre ya existe en algún sitio: su guion, sus notas, su calendario de contenido.

**Pregúntala antes de montar nada:** *"¿cuál es el titular que va arriba?"* Si contesta que no
lo tiene, propón dos o tres y que elija — pero **no lo inventes por tu cuenta ni lo "mejores"**.

> 💡 **Si tiene su calendario de contenido conectado** (Notion u otra herramienta), búscalo ahí
> primero: se localiza el video **por su fecha** y se toma el campo del titular tal cual.
> **Es un atajo, no un requisito** — si no hay nada conectado, se pregunta y ya.
> Del calendario se toma **solo el titular**: las notas de producción y las ideas visuales que
> haya alrededor no se montan salvo que se pidan.

Ejemplo real: el titular era `VIEWS: 40,000 · MENSAJES: 0` y en pantalla quedó
`views: 40,000` / `mensajes: 0`. Si no cabe en una línea a 80 px, se parte en dos por donde
parta el sentido — el separador `·` desaparece y cada mitad es una línea.

> ⛔ **Se copia el TEXTO, no el formato.** Aunque venga en mayúsculas, el titular de yapping
> va **en minúsculas** (ver abajo).

> ⛔ **Del guion se toma SÓLO el titular.** Las notas de producción y las ideas visuales que
> haya alrededor **son ideas sueltas, no se montan** salvo que se pidan.

## ⭐ El titular: minúscula inicial + sombra suave

Dos detalles pequeños que hacen casi todo el trabajo. Sacados de una referencia de `jun_yuh`:

**1. Empieza en minúscula.** `lo que hago en 1 hora con IA`, no `Lo que hago...`. Se lee
espontáneo, escrito al momento, no producido. Es un código de la plataforma: la mayúscula
inicial delata que alguien lo diseñó.
**Sin excepción: aunque el titular venga escrito en mayúsculas, en pantalla va en minúsculas.**

**2. Sombra suave detrás, no contorno.** El texto es blanco simple, sin borde ni caja. Lo que
lo hace despegar del fondo es una **sombra difusa y oscura** detrás. Sin ella, sobre un fondo
claro el blanco desaparece; con ella se lee sobre cualquier cosa **sin ensuciar el diseño**.

En After Effects: efecto **Sombra paralela** (`ADBE Drop Shadow`) con distancia casi nula
(2-4 px), **suavidad alta** (25-40) y opacidad media (~55%).

> ⛔ **No usar contorno (stroke) ni caja de fondo.** Eso es lenguaje de CapCut y rompe el
> aspecto orgánico. La sombra difusa es lo que distingue este estilo.

Lo mismo aplica a los captions.

### ⛔⛔ La sombra va en PÍXELES ABSOLUTOS, nunca en múltiplos del cuerpo de letra (2026-08-16)

**Rechazo suyo:** *"se ve el cuadrado de sombra afuera del título"*. La causa medida: el radio
de desenfoque estaba atado al tamaño de fuente (`2.20 × fs`), así que el titular a 80 px se
llevaba un desenfoque de **176 px**. Eso no es un halo, es una nube — y sobre un fondo claro
se lee como un rectángulo gris.

**No es que sobre sombra: es que está repartida en demasiada superficie.** La buena es más
oscura y muchísimo más corta.

Perfil de caída objetivo, medido sobre el video aprobado como correcto
(`2026-08-11-ia-locura`), en px desde el borde de la letra sobre fondo plano:

| distancia | caída de luminancia |
|---|---|
| 3–8 px | **−40 a −47** |
| 8–16 px | −12 a −20 |
| 16–28 px | −3 a −5 |
| **más de 28 px** | **0 — tiene que MORIR aquí** |

Valores validados en CSS (Chrome headless), **los mismos para titular de 80 px y captions
de 62 px** — el halo es físico, no proporcional:

```css
text-shadow: 0 0 10px rgba(0,0,0,0.80), 0 0 26px rgba(0,0,0,0.55);
```

(a escala 1; multiplicar los radios por el factor de generación). Es el equivalente del
Drop Shadow único de AE con suavidad 75 que se usaba para los dos tamaños.

### ✅ RESUELTO: manda [`halo.md`](halo.md)

Un montaje con los valores de ESTA sección fue rechazado: el halo **se veía cuadrado**.
**El halo del estilo es el de `halo.md` — gaussianas reales, σ proporcional al cuerpo de
letra.** Esta sección se conserva solo como registro del diagnóstico; **no usar sus
valores de CSS.**

Lo que sigue es la comparación de las dos specs, por si algún día hace falta el porqué.

| | Esta sección (2026-08-16) | [`halo.md`](halo.md) (2026-08-19) |
|---|---|---|
| Referencia | montaje de referencia | una captura propia, *"guess how many people signed up?"* |
| Ancho | **muere pasados 28 px** | llega a ~90 px |
| Escala | **absoluta**, igual a 80 y a 62 px | **proporcional** al cuerpo de letra |
| Técnica | `text-shadow` de CSS, dos sombras | gaussianas reales sobre el alfa de las letras |
| Aprobado en | video del 2026-08-16 | video del 2026-08-19, *"quedó perfecto, este es el oficial"* |

Las dos diagnosticaron bien el mismo síntoma (*"se ve el cuadrado de sombra"*) y culparon a
cosas distintas: aquí, que el radio estuviera atado al cuerpo de letra; en `halo.md`, que la
caída del `text-shadow` de CSS tiene meseta y escalón en vez de ser gaussiana.

⚠️ La hipótesis de que la diferencia fuera el FONDO (pared beige lisa contra fondos más
oscuros) **quedó descartada**: rechazó el halo estrecho en los dos videos, con fondos
distintos. No es un número por video, es el método — el `text-shadow` de CSS no sirve.

⛔ **Si tocás un video viejo, revisá también su `textos.py`.** El 2026-08-15 le arreglé los
apoyos congelados y le dejé los textos con el halo viejo; se lo tuve que enseñar dos veces.
El halo vive en `textos.py`, los apoyos en `montar.py`, y son arreglos independientes.

---

## Números probados (1080×1920) — montaje real del 2026-08-13

| Elemento | Valor |
|---|---|
| **Titular** | 80 px · **dos líneas** · centrado en `[540, 320]` · Inter Tight SemiBold |
| **Captions** | 62 px · centrado en `[540, 1480]` (77% de alto, **a la altura de la barbilla**) |
| **Límite de caption** | ⛔ **24 caracteres máximo** — ver abajo |
| **Sombra del titular** | distancia **0** · suavidad **75** · opacidad **105/255 (41%)** |
| **Sombra de captions** | distancia **0** · suavidad **75** · opacidad **120/255 (47%)** — más opaca porque va sobre la cara y la ropa, no sobre pared |
| **Ancho de imágenes** | **380–420 px** sobre 1080 |

### ⛔ Agrupar captions por CARACTERES, nunca por palabras

Agrupar "de 5 palabras" produce frases que se salen del cuadro: *"tiempo porque estoy ayudando
obviamente"* son 39 caracteres → ~1.250 px sobre un lienzo de 1.080. **Se sale por los dos lados.**

**Límite: 24 caracteres.** A 62 px eso da ~770 px, con margen cómodo. Resultado medido: 58 frases
en 61 segundos, una cada **1.1s** — que además sube la densidad, cosa buena en este estilo.

### ⛔ Las capturas densas NO funcionan pequeñas

En las referencias las imágenes son **fotos de personas reconocibles** (Eminem, Jordan). Funcionan
diminutas porque **no se leen, se reconocen**.

Una captura de interfaz —un panel, After Effects, un dashboard— **hay que leerla**. A 180 px es un
rectángulo oscuro sin información.

**La solución no es solo agrandar: es recortar.** De cada captura se toma **la región que
comunica** y se escala. Ejemplos del montaje real:
- After Effects → **solo la ventana de composición** con el video y los gráficos encima, más el
  timecode. Se quitó todo el lienzo gris vacío.
- Un calendario o una tabla → **solo las filas que importan**, sin los paneles laterales.
- Perfil de Instagram → **solo la cabecera** con el nombre y el número de seguidores.

Recortadas y a ~400 px de ancho, se leen perfectamente.

---

## ⭐ Dónde van los apoyos: NO es fijo — lo decide el encuadre

**⛔ No convertir esto en una plantilla.** El sitio de los apoyos cambia
según lo cerca o lejos que esté de la cámara. Hay dos casos ya montados y aprobados, y son
opuestos entre sí. Sirven de calibración, no de ley.

**El criterio: dónde caen los OJOS sobre la retícula de tercios.**

| | `2026-08-11-ia-locura` | `2026-08-15` (el link roto) |
|---|---|---|
| Ojos | cerca de la línea **central** (y≈935) | sobre la línea del **tercio superior** (y≈640) |
| Encuadre | cerca de cámara, la cabeza llena el medio | más abierto, cabeza arriba |
| **Espacio libre** | **arriba de la cabeza** y a los costados a la altura de la cara | **la franja del pecho, debajo de la barbilla** |
| Apoyos | a los costados | debajo de la barbilla |

Medido sobre los dos cortes (% de piel; menos es mejor):

| Caja 440×300 | ia-locura | el link roto |
|---|---|---|
| arriba de la cabeza (y 200–500) | **0.0%** — limpia el 100% | ocupada por el titular |
| costados a la altura de la cara (y 700–1000) | 9.6% / 11.3% — limpia 43–52% | la cara |
| pecho (y 1090–1390) | **84.3% — inservible** | **6% — limpia el 83%** |

**Léelo así:** la caja del pecho que funcionó perfecto en un video es inservible en el otro, y
al revés. Por eso se mide cada video antes de colocar nada.

### El procedimiento (esto sí es fijo)
1. Sacar frames a 2–4 fps del corte.
2. Detectar piel: `r>95, g>40, b>20, max-min>15, r>g+15, r>b+15`.
3. Listar, por caja candidata, las ventanas de tiempo con **<8% de piel**.
4. Asignar cada aparición a una ventana limpia medida.

**Predecir a ojo no funciona.** En el video del link roto el gancho parecía despejado: el centro
medía 11.6% de piel y los costados 5%. Y las manos suben mucho más de lo que parece — de 1500
para abajo había manos en el 98% de los frames.

### ⛔ El detector de piel NO sirve sobre pared cálida (2026-08-16)

En el video del 2026-08-16 la pared es beige y dispara la regla entera
(`r>95, g>40, b>20, r>g+15, r>b+15`): medía **91% de "piel" sobre pared vacía**. El
procedimiento de arriba sólo vale con fondos fríos o neutros.

**Sustituto que sí funciona en cualquier fondo:** sacar frames a 3–6 fps, calcular la
**mediana por píxel** de toda la secuencia (eso ES el fondo, porque la persona se mueve y el cuarto
no), y marcar como ocupado todo píxel que se aparte más de 18 niveles de luminancia de su
mediana. Después, barrer cajas candidatas y quedarse con **la más grande cuya ocupación
máxima en la ventana sea <8%**. Distingue pared de persona sin depender del color.

## ⭐ El apoyo puede ser VIDEO, no solo foto (2026-08-15)

Pedido suyo con referencias de `its.sammywu`: **un b-roll reproduciéndose en un cuadrito**.
Overlay de ffmpeg, esquinas redondeadas, **siempre SIN SONIDO** — la voz manda.

**Y en el gancho puede ir a pantalla grande, tapándole la cara.** En el link roto la grabación
de scroll de TikTok entra en 0.3, ocupa 414×900 en el hueco entre el titular y los captions, y
sale en 2.4. Va **acelerada 2x** para que el scroll se lea rápido. Tapar la cara dos segundos en
el gancho es deliberado.

> ⛔ **Elegir el tramo del b-roll MIRÁNDOLO, no midiendo movimiento.** Medí el movimiento de la
> grabación de pantalla y el tramo "más movido" resultó ser el **Centro de Control de iOS**
> deslizándose — el gesto de parar la grabación. Salió a pantalla completa en el gancho. El
> número decía que era el mejor tramo y el contenido era basura. Sacar una hoja de contactos
> y ver qué hay.

## ⛔⛔ El b-roll de VIDEO va COMPLETO y VERTICAL, jamás recortado (2026-08-16)

**Rechazo suyo:** meter un clip en una caja apaisada de 440×300 lo convierte en *"solo mi cara
o solo mi boca"* y se lee como una captura mal sacada, no como metraje.

**La regla:** se coloca el clip **entero, en su proporción original**, igual que el apoyo del
gancho pero más chico. **Sólo se fija el ALTO; el ancho lo pone la fuente.** Toda la biblioteca
de b-roll está grabada en vertical, así que salen cuadritos altos y estrechos.

Medida validada sobre 1080×1920: **alto 620 → ancho 348** para una fuente 9:16. El cuadrito va
**de la barbilla al borde superior del caption** (y 780 → 1400).

⚠️ **Leer la rotación, no el `width`/`height` crudo.** Media biblioteca reporta `3840x2160` y
en pantalla es `2160x3840`. Sin mirar el metadato de rotación el clip sale acostado.

> ⛔ Y **no** convertir un b-roll en una captura fija. Si hay clip, va el clip.

## ⭐⭐ Los apoyos van DONDE SEÑALA LA MANO

La regla que manda sobre todas las demás de colocación: **si hace un gesto hacia un lado, el
apoyo aparece de ese lado.** El gesto es el que dirige la mirada; el apoyo es el pago.

Se sacan mirando el corte gesto por gesto y anotando lado y altura. Ejemplo de un montaje real:
`5.2s DER · 9.5s DER · 13.6s índice arriba IZQ · 23.8s puño IZQ · 30s IZQ · 44.2s IZQ ·
46.4s IZQ · 50.8s DER · 55s IZQ`.

El apoyo va **junto al gesto, no encima de la mano**.

**Que roce el cachete o la oreja no importa.** Lo prohibido es taparle la cara entera. Esto relaja la regla vieja de "nunca sobre la cara": vale para no sepultarlo, no
para dejar un margen de seguridad tímido.

## Colocación de las imágenes

- Siempre en el espacio negativo, y **cuál es depende del encuadre** (ver arriba) — pero el
  gesto manda sobre la medición cuando hay gesto.
- **La posición varía** entre apariciones — no es un sitio fijo. Eso es parte de lo que da vida.
- Las **capturas** (documentos: DMs, analytics, comentarios) sí conservan caja propia y su
  proporción: 440 px de ancho, o más si llevan varias líneas de texto.
- **Entran de golpe**, sin deslizar ni escalar. Aparecen y ya.
- Si hay varias, entran **en rápida sucesión**, no simultáneas.
- ⛔ Nunca pegadas al borde derecho ni al inferior: zonas de interfaz.

## Densidad

Medida en las referencias (`gt(scene,0.05)`):

| Referencia | Un evento cada |
|---|---|
| ref-1 (241s) | 5.74s |
| ref-2 (33s) | 2.35s |
| ref-3 (57s) | 5.68s |
| ref-4 (73s) | 3.49s |

**Rango objetivo: un evento cada 2.5–4 segundos.** Más relajado que Kallaway (1.6–2.2s) porque
cada imagen concreta pesa más que un gráfico abstracto.

En un video de 70 segundos son **~20 apariciones de imagen**.

## ⭐ Excepción: cuando la prueba NO existe, se CONSTRUYE como motion graphic (2026-08-16)

El estilo dice «aquí solo se colocan cosas, no se construye». Sigue valiendo **mientras la cosa
exista**. Cuando la prueba que pide el guion es una captura que no hay —comentarios reales,
estadísticas, ejemplos de CTA de otros— **la construyo yo como MG en vez de dejar el hueco**.
Pedido suyo: *"créalo tú, como un MG… recordemos que ahorita estamos tratando de que sea más
premium, como el video del veinte de agosto"*.

Se hacen con el lenguaje premium de `motion-graphics-premium`: panel casi negro con lavada de
luz naciendo por debajo, tarjetas claras rellenas, insignia numerada celeste, conectores
punteados, resplandor **solo** en el instante del encaje, y el estilo **variando** entre
gráficos (unos con panel, otros a línea sobre el video).

⛔ **Lo que va a línea sobre la pared clara necesita más cuerpo y más halo del que parece.**
Medido en este video: barra de 44 px y texto rojo sobre beige no se leían; con barra de 62 px,
trazo de 6 px, halo (8, 0.78) y el rótulo dentro de una pastilla rellena, sí.

⛔ **Nada de cifras inventadas.** Para «te guardan pero no te escriben» se compararon **barras**,
no un «1.240 vs 3»: un número falso en pantalla se lee como una métrica real de la persona.

Plantilla: `content-os/raw-footage/2026-08-16/scripts/apoyos.py`.

## Qué NO lleva

- Motion graphics, listas, diagramas, contadores
- Zooms, punch-ins, cambios de encuadre
- Panel de contenido ni layout de dos zonas
- Captions palabra por palabra (aquí son frases)
- Música con protagonismo

**Si estás construyendo algo, te saliste del estilo.** Aquí solo se colocan cosas.

## Por qué funciona

El espectador escucha un concepto abstracto y **ve la cosa concreta al instante**. "Eminem tenía
a Slim Shady" → foto de Eminem. No hay que interpretar un gráfico: se reconoce y se sigue
escuchando. Por eso admite densidad más baja.

## Funciona bien para

Contenido conversacional, de opinión, contando lo que estás haciendo. Temas donde **cada
concepto tiene una imagen obvia**: personas, marcas, apps, capturas de pantalla, productos.

## No funciona para

- Conceptos abstractos sin imagen posible (ahí sirve `kallaway-dos-zonas`)
- Contenido con estructura numerada — pide panel, no fotos
- Temas donde no tengas las imágenes: **el estilo depende por completo de tener el material**

## Duración

Las referencias van de 33 a 241 segundos. **Es más tolerante a la duración** que
`kallaway-dos-zonas`, porque la carga de producción por segundo es mucho menor.

---

# ⭐ Cómo se produce: SOLO con ffmpeg, sin After Effects

Comprobado de punta a punta en `2026-08-15` (el link roto), aprobado el 2026-08-15.
**Este estilo no necesita el puente de After Effects para nada**, y eso libera AE para que
otro video lo use en paralelo (ver `dos-chats-editando-a-la-vez`).

Funciona porque yapping **no tiene motion graphics**: el titular está quieto, los captions
aparecen y desaparecen, y las imágenes *"entran de golpe, sin deslizar ni escalar"*. Todo eso
es `overlay` con `enable='between(t,a,b)'`. No hay nada que animar.

## La cadena

```
v1-corte.mp4  →  montar.py (un solo ffmpeg)  →  v3-yapping.mp4
```

Capas, de abajo a arriba: corte → apoyos → captions → titular fijo.
Un único `-filter_complex`; el audio se mapea del corte y no se toca
(verificado: correlación 0.999993, 0 ms de diferencia).

### ⛔⛔ Sin `tpad`, TODOS los apoyos de video salen CONGELADOS (2026-08-15)

El fallo más caro del estilo hasta hoy, y **no da ningún error**. `overlay` de ffmpeg consume
la segunda entrada al **reloj del video principal**: si el b-roll empieza en PTS 0 y su
aparición es en el segundo 19, para cuando `enable` lo destapa ese clip ya se acabó y overlay
repite su **último fotograma**. En pantalla se ve una foto, no un video.

Él lo detectó solo, en dos videos a la vez: *"esos b-rolls colocalos, coloca el video tal
cual… no quiero que hagas el screenshot y lo coloques"*. No estábamos poniendo capturas —
era esto.

**El arreglo**, después del `alphamerge`:

```
tpad=start_duration=<t0>:start_mode=add:color=0x00000000
```

Mete fotogramas transparentes por delante para que el primer fotograma real caiga en t0.

**Comprobación obligatoria** (recortar la caja del apoyo en tres momentos de su ventana y
medir la diferencia media entre fotogramas):

| | diferencia sobre 255 |
|---|---|
| congelado | **0.08 – 0.72** |
| reproduciéndose | 2 – 76 |

Medido en `2026-08-15` antes del arreglo: **6 de 7 apoyos de video congelados.** El único
sano era el del gancho, porque entra en el segundo 0.3. Corregido en su `v5`/`v6`.

⚠️ El mismo test delata **b-roll que no sirve aunque corra**: `viendo-telefono-scrolleando.MOV`
se mueve 0.65–1.05 en TODO el clip — es un plano casi fijo y en cuadrito se lee como foto
igual. Se cambió por `levantandome-de-escritorio.MOV` (18.4). Antes de dar un apoyo por bueno,
medir el tramo en el clip fuente, no solo en el render.

## Los textos van como PNG, no como `drawtext`

⛔ **El ffmpeg de Homebrew no trae el filtro `drawtext`** (comprobado en 8.1.2). El titular y
los captions se generan con **Chrome headless** a 4x y se reducen al componer. Da la sombra
difusa del estilo, que `drawtext` no hace bien.

⛔ **La ventana de Chrome tiene que ser MÁS ancha que el texto a 4x.** Con `--window-size=3000`
23 de 44 captions salieron cortados en seco, todos con exactamente 750 px de ancho final —
ese número repetido es la señal. Con 8000 ya no. **Si varios PNG miden lo mismo, están cortados.**

## Números del montaje aprobado (`2026-08-15`)

| | |
|---|---|
| Titular | Inter Tight SemiBold 80 px, centrado en [540, 320], dos líneas |
| Captions | 62 px, centrados en **y 1465**, máx. 24 caracteres, uno por segundo |
| Sombra | distancia 0, tres desenfoques (0.55× / 1.10× / 2.20× del cuerpo), opacidad 41–47% |
| Margen del PNG | 40 px al recortar, para que la sombra muera en alfa 0 y no se corte en seco |
| Caja de apoyo | 440×300, esquinas de radio 28 |

⛔ **Los captions NO van a y 1600.** La plataforma recorta los 360 px de abajo: todo lo que pase
de **y 1560** se pierde. A 1465 quedan entre la caja y el corte.

⛔ **Una captura con varias líneas de texto no se lee a 440 px.** La conversación de DM hubo que
subirla a 620 px y centrarla. Por la derecha no cabía: se metía en los 170 px de interfaz.

## Antes de publicar

1. Correlación de onda contra el corte: tiene que dar ~1.000 y 0 ms.
2. Ancho visible de cada caption: que ninguno pase de x≈910.
3. Mirar los frames de cada aparición, no solo confiar en que el comando no dio error.

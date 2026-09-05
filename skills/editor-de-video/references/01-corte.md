# Fase 2 — El corte

> **El trabajo:** WhisperX dice EXACTAMENTE dónde empieza y termina cada palabra → cortas en
> esos bordes → ninguna palabra queda mocha → se borran solo los huecos donde no se habla →
> tú ordenas las tomas buenas en una historia que fluye.

Esta fase entrega una **lista de cortes** + un MP4. Nada de captions, música, color ni zooms
— eso es Fase 3.

---

## Por qué WhisperX y no otra cosa (léelo antes de improvisar)

Un "silencio" es **un tramo donde no se dice ninguna palabra**, NO una caída de volumen. Por
eso el corte tiene que guiarse por la posición de las palabras.

El problema: los transcriptores normales (faster-whisper) **adivinan** los tiempos de cada
palabra y se desvían feo alrededor de las pausas — colocan una palabra dentro de un silencio
de 2 segundos, o estiran una palabra a 2.2s falsos. De ahí salen todos los errores típicos:
clips que empiezan antes de tiempo, últimas palabras cortadas, clips que caen en silencio.

**WhisperX transcribe y DESPUÉS alinea cada palabra al audio con un modelo de fonemas** →
inicio y fin reales y exactos por palabra. Con eso, cortar es trivial y sale bien.

---

## El método

> ⚠️ **NO pongas `export PATH="…:$PATH"` delante de cada comando.**
> La carpeta de Homebrew **ya es el primer directorio del PATH** que recibe la herramienta Bash
> (`/opt/homebrew/bin` en Apple Silicon, `/usr/local/bin` en Intel). ffmpeg, ffprobe, python3 y
> node se encuentran sin hacer nada.
>
> Y el export tiene un coste real: **las reglas de permiso miran cómo EMPIEZA el comando**. Un
> comando que arranca con `export` no coincide con ninguna regla `Bash(ffmpeg *)`, así que hay
> que aprobar a mano cada paso de la edición.
>
> Empieza los comandos por `cd`, por la herramienta, o por el script. Nunca por `export`.

```bash
WORK=~/shortform-cut          # carpeta de trabajo
mkdir -p "$WORK"/{audio,work}
SRC="/ruta/a/TU_CLIP.MP4"     # el clip crudo 9:16

# 1. extraer audio mono 16k
ffmpeg -y -i "$SRC" -vn -ac 1 -ar 16000 -c:a libmp3lame -q:a 5 "$WORK/audio/CLIP.mp3"

SK="$CLAUDE_PLUGIN_ROOT/skills/editor-de-video/scripts"

# 2. WhisperX → timestamps exactos por palabra
HF_HOME=~/.equipo-de-ia/wx-cache OMP_NUM_THREADS=4 \
  ~/.equipo-de-ia/wx-env/bin/python "$SK/whisperx_align.py" \
  "$WORK/audio/CLIP.mp3" "$WORK/work/CLIP_wx.json"

# 3. PASO DE EDITOR (solo tú puedes hacerlo): lee las palabras, escribe beats.txt

# 4. construir el corte
python3 "$SK/build_wx.py" \
  "$WORK/work/CLIP_wx.json" beats.txt src 0.22 > "$WORK/work/ci.json"
# build_wx imprime la lista de cortes (segundos inicio-fin + texto) en stderr
```

`OMP_NUM_THREADS=4` evita que WhisperX se coma todos los núcleos. En CPU la alineación tarda
1–2 min por clip. Vale la pena.

---

---

## ⛔ Paso obligatorio: verificar los bordes contra el audio

**Verificado el 2026-09-02 sobre un VSL real.** WhisperX alinea texto contra fonemas, y con los
**numerales falla feo**: a «diecisiete» le asignó **0.06 s** de duración — cuatro sílabas en un
parpadeo. El corte se hizo sobre ese final falso y la palabra salió mocha. Lo mismo con la última
palabra de muchas frases.

**El audio no miente.** Después de construir `clip_infos.json` y ANTES de renderizar:

```bash
python3 "$SK/verificar_bordes.py" "$WORK/audio/CLIP.mp3" "$WORK/work/ci.json" 30 --escribir
```

Detecta por energía dónde hay voz de verdad; si el final de un clip cae **dentro** de un tramo con
voz, es que la palabra seguía sonando y **estira el clip** hasta que la voz termina.

Es barato y solo toca lo que está mal: en la prueba real corrigió **2 clips de 52** — exactamente
los dos que la persona detectó de oído. **No te saltes este paso:** una palabra mocha es el defecto
que más se nota y el que más confianza quita.

---

## Paso 3 — EL HILO ROJO (el paso de editor)

Lee las palabras de WhisperX. Escribe `beats.txt`, un beat por línea: `INICIO FIN etiqueta`.
Elige tomas para que la historia AVANCE:

**gancho → qué es → cómo → resultado → valor → CTA → (cierre divertido)**

Reglas:

- **Una sola toma limpia por beat.** La gente repite hasta que sale bien → **normalmente gana
  la toma más tardía**.
- **Descarta:** arranques falsos, reinicios ("déjame empezar de nuevo"), dobles (un dato dicho
  dos veces), tomas de "aquí puedo señalar", puro meta ("esto es solo una prueba"), muletillas.
- **CONSERVA el contenido real.** "Puro meta" = logística y hablarle a la IA sobre el edit.
  Las ideas y opiniones son EL CONTENIDO — no las tires por parecer tangentes. **Ante la duda,
  consérvalo.**
- **Respeta la dirección a cámara.** Si en la grabación se dirige el edit en voz alta ("aquí
  puedes cortar"), esa línea suele ser el cierre divertido intencional. Consérvala si aterriza.
- **Arregla contradicciones y orden.** Arma los beats para que se lea como UN solo pensamiento
  coherente, aunque el orden original estuviera revuelto. El mejor gancho va primero aunque se
  haya grabado al final.
- **El dial GAP** (4º argumento de `build_wx`): `0.22` es el default punchy pero fluido. Más
  chico = quita más pausas (más jump-cuts). Más grande = más respirado. Los bordes de palabra
  son exactos, así que es un dial limpio.

Formato en `references/beats.example.txt`.

---

## ⛔ Callejones sin salida — NO los repitas

Esto ya se probó y falló. Está documentado para que no pierdas horas redescubriéndolo.

1. **Whisper como cortador de silencios** — sus *segmentos* suavizan las pausas (funden una
   pausa larga de pensamiento dentro de una misma oración).
2. **Márgenes de amplitud apretados** — cortan palabras enteras de los extremos.
3. **Timestamps de palabra de faster-whisper** — mal calibrados alrededor de pausas → clips
   mudos de movimiento de cámara, silencios no detectados. **Esta es la razón entera de usar
   WhisperX.**
4. **`silencedetect` con dB fijo** (`-30dB`) — falla cuando varía la distancia al micrófono.
5. **Auto-corte por volumen solo** — bueno, pero sus bordes son de volumen y no de palabra:
   arranca un pelo antes y deja pausas.
6. **Auto-corte demasiado agresivo** — corta palabras suaves a media oración y fragmenta todo.
7. **⚠️ CIFRAS ESCRITAS CON DÍGITOS — el fallo más caro (fallo real, ya arreglado).**
   WhisperX alinea **texto contra fonemas**. Un token numeral como `1700` no le dice al modelo
   cuántas sílabas se pronuncian ("mil setecientos" = 8), así que le asigna una ventana
   **comprimida** — 0.58s para algo que dura ~1s. El arranque de la cifra queda fuera de la
   alineación, el hueco resultante **parece silencio**, se corta, y la cifra sale mutilada:
   `"un producto de 1700 dólares"` → `"un producto de 700 dólares"`.
   **Pasó dos veces en el mismo clip real, en el hook y en el cierre — los dos momentos donde
   más duele.** Con GAP 0.50 no ocurría, pero por accidente, no por diseño.
   **YA ESTÁ ARREGLADO en `build_wx.py`:** nunca abre ni cierra un clip pegado a un token con
   dígitos. Costo medido: 4 cortes menos y +1.3s en un video de 3.5 min. Prácticamente gratis.
   **Nunca quites esa protección.** Las cifras suelen ser el corazón de un hook: si se mutilan,
   se rompe justo el momento que más importa.

> **QC OBLIGATORIO — transcribe siempre el resultado.** No confíes en que el corte salió bien
> porque no dio error. Extrae el audio del render final, pásalo por WhisperX y compara las
> cifras y el texto contra el original. Así se encontró el fallo #7, y es un minuto de trabajo.

---

## ⛔ REGLA DURA — MEDIR, NUNCA PREDECIR

**Todo tiempo que se use aguas abajo del corte se saca transcribiendo el archivo renderizado.
Jamás de un cálculo sobre las duraciones de los clips.**

Por qué: al renderizar, ffmpeg redondea cada clip **al cuadro completo**, así que cada clip sale
~1 cuadro más largo de lo pedido. Un cuadro no se nota. **155 clips son 5 segundos.**

Medido en un caso real: captions calculados sumando duraciones quedaron sincronizados
al inicio y **4.9 segundos adelantados al final** — una deriva del 2.4% que crece linealmente.
Al segundo 10 se veía perfecto; al segundo 200 el texto iba media frase adelante de la voz.

```
palabra 1     desfase -0.01s      ← parece que está bien
segundo 100   desfase -2.28s
segundo 200   desfase -4.91s      ← ya es otro video
```

**El procedimiento correcto, siempre:**
1. Renderizar el corte.
2. **Transcribir el archivo renderizado** con `whisperx_align.py`.
3. Usar ESOS tiempos para captions, textos, gráficos y sonidos.

Nunca compenses la deriva con un factor de corrección — eso esconde el problema. Mide.

Los cuatro fallos encontrados en la primera producción real (cifras mutiladas, CTA cortado,
video acelerado, captions desincronizados) **se atraparon todos midiendo el resultado**, y
**ninguno de los cuatro produjo un mensaje de error.**

> **No persigas esto:** el NLE, los FPS, o "usar Gemini para encontrar los silencios". La
> matemática del corte es determinista a partir de los bordes de palabra. Si un corte salió
> mal, es el `beats.txt` o el GAP — no la herramienta.

**El constructor vivo es `build_wx.py` sobre las palabras de `whisperx_align.py`.** Los otros
scripts (`build_cut.py`, `build_wordcut.py`, `build_clipinfos.py`, `flow_cut.py`) son
callejones sin salida documentados, conservados como referencia. `motion_score.py` y
`storyboard.sh` son ayudas opcionales para revisar movimiento de cámara y encuadre.

---

## Dónde aterriza el corte

**After Effects** — convierte las líneas `# inicio-fin` (en segundos) que
`build_wx.py` imprime en stderr a un EDL CMX3600 o XML FCP7: un evento por clip, source
in/out = los segundos de inicio/fin, record-in = acumulado. Se importa y arma la secuencia
apuntando a tu archivo fuente. Ver `03-after-effects.md`.

**Camino ffmpeg (respaldo, sin ningún NLE)** — renderiza cada clip con
`ffmpeg -ss INICIO -i SRC -t DURACION`, reencuadra a 9:16 en el mismo paso, y concatena con
re-encode. **Maneja el loop desde Python, no con un `while read` de bash** (bash se come el
stdin en los clips cortos). Filtro de reencuadre:

```
-vf "crop=ih*9/16:ih,scale=1080:1920,fps=30"
```

Este camino produce un MP4 terminado y publicable sin instalar nada más. **Es el que se usa
cuando el puente de After Effects no está disponible.**

> ⛔ **CORTA EN UNA SOLA PASADA, NUNCA EN ARCHIVOS SUELTOS + CONCAT (fallo real).**
> Cortar a N archivos y concatenarlos **desincroniza el audio**: cada empalme reinicia el audio, y
> como los cuadros de audio (~21 ms) y de video (33 ms) no coinciden, el error se acumula.
> **Medido en un caso real: el mismo corte dio 71.90s por archivos sueltos y 68.93s en una sola
> pasada — 2.97 segundos de cuadros duplicados en 40 clips.** El usuario lo percibió como
> "la imagen se adelanta al sonido".
>
> **Método correcto:** un único `ffmpeg` con `trim`/`atrim` + `concat` en `-filter_complex`:
> ```
> [0:v]trim=start=S:end=E,setpts=PTS-STARTPTS[v0];
> [0:a]atrim=start=S:end=E,asetpts=PTS-STARTPTS[a0];
> ... [v0][a0][v1][a1]…concat=n=N:v=1:a=1[vc][a];[vc]scale=1080:1920,fps=30[v]
> ```
> Escalar **dentro del grafo** — no se puede usar `-vf` junto a `-filter_complex`.
> **Verificar siempre:** las duraciones de las pistas de video y audio deben coincidir en ±10 ms.

> ⚠️ **FUERZA SIEMPRE FRAME RATE CONSTANTE AL CONCATENAR (fallo real, ya arreglado).**
> Sin esto, el concat produce un MP4 con **frame rate variable**. After Effects lo importa y le
> asigna un promedio absurdo (se vio un `29.194 fps`). Al renderizar a 29.97, AE suelta los mismos
> cuadros a otra velocidad: **el video sale 2.7% acelerado y al audio le cortan el final** — en el
> caso real se perdieron los últimos 5.6s, que eran el CTA completo.
> En el concat usa **`-r 30 -vsync cfr`** (o `-fps_mode cfr`) y verifica después con
> `ffprobe … r_frame_rate` que dé un valor limpio (`30/1`, `30000/1001`), nunca un decimal raro.
> **Si ya pasó:** se corrige con `setCompositionProperties` (`frameRate`) sin rehacer el montaje.

> ⚠️ **Limitación conocida:** el ffmpeg de Homebrew **no incluye el
> filtro `drawtext`**, así que por esta vía **no se puede quemar texto ni captions** en el video.
> El corte, el reencuadre y la concatenación funcionan perfecto; solo el texto no.
> Si hace falta texto quemado por ffmpeg, se instala la variante completa:
> `brew tap homebrew-ffmpeg/ffmpeg && brew install homebrew-ffmpeg/ffmpeg/ffmpeg`.
> Por el camino de After Effects esto es irrelevante — ahí el texto lo pone AE.

# Fase 3b — La música, cuadrada con el ritmo de los cortes

> **Método validado en producción.** El objetivo es que **el guion y la música vayan conectados
> y se apoyen entre sí, en el mismo ritmo** — no "ponerle una canción de fondo".

**⛔ SIEMPRE PREGUNTAR.** La música va **por video, no por estilo**. Antes de montarla, preguntar
si este lleva o no.

**⛔ SIEMPRE SINTETIZADA.** Nada descargado ni extraído de una grabación de pantalla. El riesgo del Content ID no vale la pena y además así la pista
se puede cuadrar exactamente con el video, cosa que una canción de catálogo nunca hace.

---

## La idea entera en una frase

**El video hablado YA tiene un pulso** — se lo dan los cortes, que salen de dónde respira y
dónde termina cada frase. El trabajo no es inventar un ritmo: es **encontrar el que ya está**
y hacerlo audible.

---

## 1. El tempo se MIDE, no se elige de oído

Tomar los puntos de corte acumulados en el render (los de `cortes.txt` sumados) y buscar por
fuerza bruta el BPM + offset cuya rejilla de negras cae más cerca de ellos.

**Puntuar contra el azar, no en milisegundos sueltos.** A BPM alto la rejilla es tan fina que
todo "encaja": a 153 BPM salían 28 de 29 cortes a menos de 90 ms, y eso lo consigue cualquier
cosa. La métrica honesta es:

```
puntuacion = desvio_mediano / (negra / 4)      # 1.00 = igual que el azar, <1 = encaja de verdad
```

Resultado en el video aprobado: **118.5 BPM, offset 0.02 s → 0.44 × el azar**, desvío mediano
56 ms, 14 de 29 cortes a menos de 60 ms de un pulso.

**No esperar un calce perfecto: no existe.** Los cortes los manda el habla, no un metrónomo.
Lo que se busca es que el espectador *sienta* que van juntos.

## 2. La estructura sale del GUION, no de una plantilla de canción

Cada sección del argumento tiene su energía (0–1), y se saca de `palabras_render.json`. La del
video aprobado:

| Sección | Energía | Qué suena |
|---|---|---|
| gancho | 0.25 | sub + riser, sin batería — tensión |
| el problema | 0.60 | entran bombo y charles |
| la mecánica → el nombre del concepto | 0.80 | sube, impacto sobre el nombre |
| el pivote (*"lo importante es qué hacés"*) | 0.30 | **baja** — respira |
| uno / dos / tres | 1.00 | lo más firme, golpe seco en cada número |
| la solución | 0.90 | se mantiene |
| el diagnóstico | 0.75 | tensión que sube |
| **el remate** | **0.00** | **silencio total — la frase cae sola** |
| CTA | 0.70 | resuelve y se va |

⭐ **El silencio del remate es la mitad del efecto.** Cortar la música en seco justo antes de la
frase que más pesa la hace sonar el doble de fuerte. Va con la regla del estilo de dejar ese
momento sin apoyo visual: si no lleva imagen, tampoco lleva música.

Acentos obligatorios: **riser** antes de cada sección que sube de energía, **impacto** en su
primer pulso, y un golpe seco sobre cada elemento enumerado del guion.

## 3. La mezcla se mide

**⛔ NO usar `sidechaincompress` de ffmpeg.** Se probó: aplastó la música **34.6 dB** por debajo
de la voz, inaudible. Su umbral es lineal y a ciegas no hay forma de afinarlo.

**Sí:** calcular la curva de ducking en numpy sobre la envolvente real de la voz (RMS a 100 Hz),
con umbral en el percentil 55, ataque rápido y recuperación media, y **comprobar el resultado**.

Objetivo, verificado sobre la mezcla final:

| | Valor aprobado |
|---|---|
| Música mientras habla | **12 dB por debajo de la voz** |
| Subida en los huecos | **+4 dB** (ahí es donde se oye el ritmo) |
| Integrado final | −14 LUFS, pico −2.4 dBTP |

⛔ **La recuperación no puede ser lenta.** Con 0.5 s la música subía solo 0.7 dB: como los
silencios ya están cortados, los huecos entre frases duran 0.1–0.3 s y nunca daba tiempo.
Con ~0.1 s el ritmo se oye entre frases.

## 4. Comprobación antes de entregar

1. **Distancia de cada corte al golpe musical más cercano.** En el aprobado: mediana 50 ms,
   15 de 28 a menos de 80 ms. Decirle el número, no "quedó sincronizado".
2. **Separación voz/música** con la voz aislada por la máscara de palabras.
3. **El video no se re-codifica**: la música se muxea con `-c:v copy`.

## Scripts

Copiados aquí al lado como **plantilla**: `musica.py` (síntesis) y `mezcla.py` (ducking medido).
Ambos calculan sus rutas desde su propia ubicación, así que **se copian a
`<carpeta-del-video>/scripts/` y se corren desde ahí**, no desde esta carpeta.

Lo que se toca por video: `SECCIONES` (energía por tramo del guion), `BPM`/`OFF` (los que salgan
de medir los cortes de ESE video) y `ACORDES`. Todo lo demás se deja como está.

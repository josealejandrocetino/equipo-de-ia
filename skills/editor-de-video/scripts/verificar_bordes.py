#!/usr/bin/env python3
"""verificar_bordes.py — la red de seguridad contra palabras mochas.

EL PROBLEMA (verificado el 2026-09-02 sobre un VSL real):
WhisperX alinea texto contra fonemas, y con los NUMERALES falla feo: a «diecisiete»
le asignó 0.06 s de duración — cuatro sílabas en un parpadeo. El corte se hizo sobre
ese final falso y la palabra salió mocha. Lo mismo pasa con la última palabra de
muchas frases.

LA SOLUCIÓN:
El audio no miente. Se detectan los tramos donde HAY VOZ por energía, y si el final
de un clip cae DENTRO de uno de esos tramos, es que la palabra seguía sonando: se
estira el clip hasta que la voz termina de verdad.

Barato, automático, y solo toca los clips que están mal (en la prueba real: 2 de 52).

Uso:  verificar_bordes.py AUDIO.mp3 clip_infos.json [FPS] [--escribir]
      Sin --escribir solo informa. Con --escribir corrige el json en su sitio.
"""
import json, subprocess, sys, re, io

AUDIO, CI = sys.argv[1], sys.argv[2]
FPS = float(sys.argv[3]) if len(sys.argv) > 3 and not sys.argv[3].startswith("--") else 30.0
ESCRIBIR = "--escribir" in sys.argv

RUIDO, MINSIL, COLA = "-38dB", 0.18, 0.12

sal = subprocess.run(
    ["ffmpeg", "-nostdin", "-hide_banner", "-nostats", "-i", AUDIO,
     "-af", f"silencedetect=noise={RUIDO}:d={MINSIL}", "-f", "null", "-"],
    capture_output=True, text=True).stderr

ini, habla = 0.0, []
for m in re.finditer(r"silence_(start|end): ([0-9.]+)", sal):
    tipo, t = m.group(1), float(m.group(2))
    if tipo == "start":
        if t - ini > 0.1:
            habla.append((ini, t))
    else:
        ini = t

clips = json.load(io.open(CI, encoding="utf-8"))
arreglos = []
for c in clips:
    fin = c["end_frame"] / FPS
    for a, b in habla:
        if a < fin < b - 0.02:          # el corte cae encima de voz
            nuevo = b + COLA
            arreglos.append((fin, nuevo))
            c["end_frame"] = int(round(nuevo * FPS))
            break

for viejo, nuevo in arreglos:
    print(f"  palabra mocha en {viejo:8.2f}s → estirada a {nuevo:8.2f}s  (+{nuevo-viejo:.2f}s)",
          file=sys.stderr)
print(f"{len(arreglos)} de {len(clips)} clips corregidos", file=sys.stderr)

if ESCRIBIR:
    json.dump(clips, io.open(CI, "w", encoding="utf-8"), indent=1)
    print(f"escrito en {CI}", file=sys.stderr)
else:
    print(json.dumps(clips, indent=1))

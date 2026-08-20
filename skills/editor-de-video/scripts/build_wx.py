#!/usr/bin/env python3
"""build_wx.py — THE short-form cut builder.
Cut on WhisperX's EXACT word edges, keep every word whole, remove only the no-word gaps.

Input = WhisperX-aligned words (whisperx_align.py) + beats.txt (the editor's red-thread: one clean
take per beat, folds/doubles/meta/ums already excluded). For each beat it keeps the words inside it,
walks them, and starts a NEW clip whenever (a) a new beat begins or (b) the gap between two words
exceeds GAP — i.e. a real "silence" (a stretch with no words, which is what "silence" means here,
NOT waveform dips). Each clip is bounded by word.start−LEAD / word.end+TAIL, so a word is never
clipped and a clip never starts in dead air.

Usage: build_wx.py CLIP_wx.json beats.txt MEDIA_POOL_ITEM_ID [GAP] [SRC_FPS] > clip_infos.json
  (MEDIA_POOL_ITEM_ID = your Resolve media-pool item id; for any other editor pass a label like "src".)
  GAP (default 0.22s) = the tightness dial. Smaller = remove more pauses (punchier, more jump-cuts);
  larger = keep more natural pauses (breathier). 0.22 is a good punchy-but-flowing default.
"""
import json, re, sys

WX, BEATS, MPID = sys.argv[1], sys.argv[2], sys.argv[3]
GAP = float(sys.argv[4]) if len(sys.argv) > 4 else 0.22
FPS = float(sys.argv[5]) if len(sys.argv) > 5 else 24000 / 1001
LEAD, TAIL = 0.04, 0.06
UMS = {"uh", "um", "umm", "uhh", "hmm", "mm", "err", "eh"}

# --- PROTECCIÓN DE NUMERALES ---------------------------
# WhisperX alinea TEXTO contra FONEMAS. Un token numeral ("1700") no le dice al
# modelo cuántas sílabas se pronuncian ("mil setecientos" = 8), así que le asigna
# una ventana comprimida y deja fuera el arranque de la cifra. El hueco resultante
# parece silencio → se corta → la cifra sale mutilada ("700" en vez de "1700").
# VERIFICADO: pasó dos veces en un clip real; GAP 0.50 lo evitaba por accidente.
# ARREGLO: nunca abrir ni cerrar un clip pegado a un token con dígitos.
HAS_DIGIT = re.compile(r"\d")
def es_numeral(w): return bool(HAS_DIGIT.search(w))

# --- FINALES FALSOS DE LA ÚLTIMA PALABRA ANTES DE UN SILENCIO ---
# WhisperX estira la ÚLTIMA palabra de una toma hasta bien entrado el silencio que
# sigue. Medido en un clip real de 588 palabras: percentil 95 = 0.51s, pero nueve
# palabras daban de 1.1s a 12.7s ("vendés." 3.74s, "distinto." 3.12s).
# Consecuencia: el final de la palabra cae FUERA del beat, build_wx la descarta entera
# y la frase sale mocha ("no cómo lo ___", "cada uno tenía un muro ___").
# ARREGLO: a las palabras con duración claramente atípica (>0.9s) se les recorta el
# final a una duración realista según su largo. Las sanas no se tocan.
MAX_SANA = 0.9
def dur_realista(txt):
    return 0.10 + 0.07 * len(txt.strip(".,¿?¡!…"))

def arreglar_finales(ws):
    out, n = [], 0
    for s, e, t in ws:
        if e - s > MAX_SANA:
            e = s + dur_realista(t); n += 1
        out.append((s, e, t))
    if n:
        print(f"# aviso: {n} palabra(s) con final falso de WhisperX, recortadas a duración realista",
              file=sys.stderr)
    return out

W = arreglar_finales([(w["s"], w["e"], w["w"]) for w in json.load(open(WX))])
beats = []
for ln in open(BEATS):
    ln = ln.strip()
    if ln and not ln.startswith("#"):
        a, b, *r = ln.split()
        beats.append((float(a), float(b), r[0] if r else ""))

# kept words = words whose midpoint falls in an editorial beat, minus ums
kept = []
for ws, we, ww in W:
    if ww.lower().strip(".,!?") in UMS:
        continue
    mid = (ws + we) / 2
    for bi, (a, b, lab) in enumerate(beats):
        if a <= mid <= b:
            kept.append((ws, we, ww, bi)); break

# --- EL ORDEN LO MANDA beats.txt, NO EL RELOJ DEL CRUDO ---
# El bucle de arriba recorre las palabras en orden de GRABACION, asi que el corte salia
# siempre cronologico y era imposible reordenar. La fase 2 dice justo lo contrario:
# "el mejor gancho va primero aunque se haya grabado al final". Ordenar por (beat, tiempo)
# no cambia nada cuando beats.txt ya va en orden, y habilita el reordenado cuando no.
# Hizo falta de verdad en el video del 2026-08-18, grabado con todas las lineas del
# personaje A juntas y despues todas las de B: sin esto la conversacion salia al reves.
kept.sort(key=lambda k: (k[3], k[0]))

# group into clips; cut at beat changes and at word-gaps > GAP (the no-word silences)
clips, cs, ce, pbi = [], None, None, None
prev_w = ""
for ws, we, ww, bi in kept:
    if cs is None:
        cs, ce, pbi, prev_w = ws, we, bi, ww; continue
    # no cortar pegado a un numeral: ni justo antes ni justo después
    protegido = es_numeral(ww) or es_numeral(prev_w)
    if bi != pbi or (ws - ce > GAP and not protegido):
        clips.append([cs - LEAD, ce + TAIL]); cs, ce, pbi = ws, we, bi
    else:
        ce = we
    prev_w = ww
if cs is not None:
    clips.append([cs - LEAD, ce + TAIL])

infos, rec = [], 0
for s, e in clips:
    sf, ef = round(max(0, s) * FPS), round(e * FPS)
    infos.append({"media_pool_item_id": MPID, "start_frame": sf, "end_frame": ef, "record_frame": rec})
    rec += ef - sf

print(json.dumps(infos))
print(f"# {len(infos)} clips, {rec/FPS:.1f}s (GAP={GAP}s)", file=sys.stderr)
for s, e in clips:
    txt = " ".join(w[2] for w in W if s <= (w[0] + w[1]) / 2 <= e)
    print(f"#  {s:7.2f}-{e:7.2f} ({e-s:4.1f}s)  «{txt[:56]}»", file=sys.stderr)

#!/usr/bin/env python3
"""Pista musical SINTETIZADA, cuadrada con el ritmo de los cortes del video.

No se descarga nada: todo se sintetiza (regla del proyecto — ver memoria de sonidos).

El tempo NO se elige de oído. Se busca el BPM cuya rejilla de negras mejor cae sobre
los 29 puntos de corte del render. Resultado medido: 118.5 BPM con offset 0.02s da un
desvio mediano de 56 ms, 0.44 veces lo que daria el azar. Es el pulso que ya tiene el
video hablado; la musica solo lo hace audible.

La estructura sigue el GUION, no una plantilla de cancion: cada seccion del argumento
tiene su energia, y el remate se queda en silencio para que la frase caiga sola.
"""
import numpy as np, os, subprocess, wave

AQUI = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SR = 48000
DUR = 44.62
BPM = 118.5
OFF = 0.02
BEAT = 60.0 / BPM
SALIDA = os.path.join(AQUI, "assets", "musica.wav")

n = int(DUR * SR)
t = np.arange(n) / SR
L = np.zeros(n); R = np.zeros(n)

rng = np.random.default_rng(7)


def env(dur, a=0.002, d=None, sus=0.0, r=0.05):
    """Envolvente percusiva simple."""
    N = int(dur * SR)
    e = np.zeros(N)
    na = int(a * SR)
    d = d if d is not None else dur - a - r
    nd = int(d * SR)
    e[:na] = np.linspace(0, 1, na)
    e[na:na + nd] = np.linspace(1, sus, nd)
    resto = N - na - nd
    if resto > 0:
        e[na + nd:] = np.linspace(sus, 0, resto)
    return e


def poner(buf, señal, t0, gan=1.0):
    i = int(t0 * SR)
    if i < 0:
        señal = señal[-i:]; i = 0
    j = min(len(buf), i + len(señal))
    if j > i:
        buf[i:j] += señal[:j - i] * gan


def kick(f0=115, f1=42, dur=0.30):
    N = int(dur * SR); x = np.arange(N) / SR
    f = f1 + (f0 - f1) * np.exp(-x * 26)
    cuerpo = np.sin(2 * np.pi * np.cumsum(f) / SR) * np.exp(-x * 9)
    clic = rng.normal(0, 1, N) * np.exp(-x * 420) * 0.25
    return (cuerpo + clic) * 0.9


def hat(dur=0.045, brillo=7000, gan=1.0):
    N = int(dur * SR); x = np.arange(N) / SR
    ruido = rng.normal(0, 1, N)
    # pasa-altos barato: derivada
    ruido = np.diff(np.concatenate([[0], ruido]))
    return ruido * np.exp(-x * (brillo / 40)) * 0.22 * gan


def clap(dur=0.22):
    N = int(dur * SR); x = np.arange(N) / SR
    ruido = rng.normal(0, 1, N)
    ruido = np.diff(np.concatenate([[0], ruido]))
    cuerpo = ruido * np.exp(-x * 22) * 0.30
    # tres micro-golpes: es lo que lo hace sonar a palmada y no a ruido
    for off, g in ((0.000, 1.0), (0.011, .7), (0.022, .5)):
        i = int(off * SR)
        cuerpo[i:] += (ruido[:N - i] * np.exp(-x[:N - i] * 60)) * 0.22 * g
    return cuerpo


def nota(freq, dur, tipo="bajo", gan=1.0):
    N = int(dur * SR); x = np.arange(N) / SR
    if tipo == "bajo":
        y = (np.sin(2 * np.pi * freq * x)
             + 0.5 * np.sin(4 * np.pi * freq * x)
             + 0.22 * np.sin(6 * np.pi * freq * x))
        e = env(dur, 0.004, dur * 0.5, 0.35, dur * 0.35)
    else:   # pad
        y = (np.sin(2 * np.pi * freq * x)
             + np.sin(2 * np.pi * freq * 1.004 * x)
             + 0.6 * np.sin(2 * np.pi * freq * 2 * x))
        e = env(dur, dur * 0.30, dur * 0.30, 0.7, dur * 0.40)
    return y[:len(e)] * e * 0.16 * gan


def riser(dur, f0=200, f1=2600, gan=1.0):
    N = int(dur * SR); x = np.arange(N) / SR
    k = x / dur
    ruido = rng.normal(0, 1, N)
    ruido = np.diff(np.concatenate([[0], ruido]))
    barrido = np.sin(2 * np.pi * np.cumsum(f0 + (f1 - f0) * k ** 2) / SR)
    return (ruido * k ** 2 * 0.10 + barrido * k ** 3 * 0.05) * gan


def impacto(dur=1.4, gan=1.0):
    N = int(dur * SR); x = np.arange(N) / SR
    sub = np.sin(2 * np.pi * (58 - 18 * np.exp(-x * 3)) * x) * np.exp(-x * 3.2)
    aire = rng.normal(0, 1, N) * np.exp(-x * 7) * 0.18
    return (sub * 0.55 + aire) * gan


# --- LA ESTRUCTURA, SACADA DEL GUION ------------------------------------------
# (inicio, fin, nombre, energia 0-1)  tiempos medidos en palabras_render.json
SECCIONES = [
    (0.00,  2.41, "gancho",      0.25),
    (2.53,  9.04, "problema",    0.60),
    (9.18, 15.48, "mecanica",    0.80),
    (15.60, 18.67, "pivote",     0.30),   # respira: "lo importante es que hacés"
    (18.99, 28.67, "los-tres",   1.00),
    (28.81, 36.22, "solucion",   0.90),
    (36.40, 40.02, "diagnostico", 0.75),
    (40.18, 41.76, "remate",     0.00),   # SILENCIO: la frase cae sola
    (41.78, 44.60, "cta",        0.70),
]


def energia(x):
    for a, b, _, e in SECCIONES:
        if a - 0.12 <= x <= b + 0.12:
            return e
    return 0.0


def nombre_sec(x):
    for a, b, nm, _ in SECCIONES:
        if a - 0.12 <= x <= b + 0.12:
            return nm
    return ""


# --- REJILLA ------------------------------------------------------------------
beats = np.arange(OFF, DUR, BEAT)

# La | menor: la progresion cambia por seccion, no cada 4 compases,
# para que el acompañamiento siga el argumento.
ACORDES = {"gancho": 55.00, "problema": 55.00, "mecanica": 43.65,   # A1, A1, F1
           "pivote": 65.41, "los-tres": 55.00, "solucion": 48.99,   # C2, A1, G1
           "diagnostico": 43.65, "remate": 55.00, "cta": 55.00}

for i, b in enumerate(beats):
    e = energia(b)
    if e <= 0.01:
        continue
    compas = i % 4
    # bombo: 1 y 3, y un rebote en la ultima corchea del compas cuando hay energia
    if compas in (0, 2):
        poner(L, kick(), b, 0.85 * e); poner(R, kick(), b, 0.85 * e)
    if compas == 3 and e >= 0.9:
        poner(L, kick(), b + BEAT / 2, 0.45 * e); poner(R, kick(), b + BEAT / 2, 0.45 * e)
    # palmada en 2 y 4 a partir de energia media
    if compas in (1, 3) and e >= 0.55:
        c = clap()
        poner(L, c, b, 0.5 * e); poner(R, c, b, 0.5 * e)
    # charles en corcheas, con acento y un poco de estereo
    if e >= 0.45:
        for k, sub in enumerate((0.0, 0.5)):
            g = (1.0 if sub == 0 else 0.55) * e
            h = hat(gan=g)
            poner(L, h, b + sub * BEAT, 0.9 if k == 0 else 0.6)
            poner(R, hat(gan=g), b + sub * BEAT, 0.6 if k == 0 else 0.9)
    # bajo: raiz en el 1 de cada compas, quinta en el 3
    f = ACORDES.get(nombre_sec(b), 55.0)
    if compas == 0:
        y = nota(f, BEAT * 1.9, "bajo", 1.0 * e)
        poner(L, y, b, 0.9); poner(R, y, b, 0.9)
    elif compas == 2 and e >= 0.7:
        y = nota(f * 1.5, BEAT * 1.4, "bajo", 0.7 * e)
        poner(L, y, b, 0.9); poner(R, y, b, 0.9)

# pad de fondo por seccion: es lo que sostiene el ambiente entre golpes
for a, b, nm, e in SECCIONES:
    if e <= 0.01:
        continue
    f = ACORDES.get(nm, 55.0)
    for mult, g in ((4, 0.55), (6, 0.30), (8, 0.18)):
        y = nota(f * mult, b - a, "pad", g * e)
        poner(L, y, a, 0.8); poner(R, nota(f * mult * 1.003, b - a, "pad", g * e), a, 0.8)

# --- ACENTOS SOBRE EL GUION ---------------------------------------------------
# riser antes de cada seccion que sube de energia, e impacto justo en su primer beat
for i, (a, b, nm, e) in enumerate(SECCIONES):
    prev = SECCIONES[i - 1][3] if i else 0.0
    if e > prev + 0.15:
        d = min(1.5, a - (SECCIONES[i - 1][0] if i else 0) - 0.2)
        if d > 0.35:
            y = riser(d, gan=0.85 * e)
            poner(L, y, a - d, 0.8); poner(R, y, a - d, 0.8)
        y = impacto(gan=0.85 * e)
        poner(L, y, a, 0.9); poner(R, y, a, 0.9)

# golpe seco en "Uno," "Dos," "Tres," — los tres pilares del argumento
for x in (18.99, 23.53, 28.81):
    y = impacto(1.0, gan=0.55)
    poner(L, y, x, 1.0); poner(R, y, x, 1.0)

# el remate: corte en seco antes de "es dónde estás intentando vender"
i0 = int(40.02 * SR); i1 = int(40.30 * SR)
caida = np.linspace(1, 0, i1 - i0)
L[i0:i1] *= caida; R[i0:i1] *= caida
L[i1:int(41.78 * SR)] = 0; R[i1:int(41.78 * SR)] = 0

# salida
fin = int(43.9 * SR)
rampa = np.linspace(1, 0, n - fin)
L[fin:] *= rampa; R[fin:] *= rampa

# --- limitador suave y escritura ---------------------------------------------
def limitar(x):
    x = np.tanh(x * 0.9) / 0.9
    return x / max(1e-9, np.abs(x).max()) * 0.89

L, R = limitar(L), limitar(R)
inter = np.empty(n * 2, dtype=np.float32)
inter[0::2] = L; inter[1::2] = R
pcm = (np.clip(inter, -1, 1) * 32767).astype(np.int16)

os.makedirs(os.path.dirname(SALIDA), exist_ok=True)
with wave.open(SALIDA, "wb") as w:
    w.setnchannels(2); w.setsampwidth(2); w.setframerate(SR)
    w.writeframes(pcm.tobytes())
print(SALIDA, "%.2fs  %d BPM  offset %.2fs" % (DUR, BPM, OFF))

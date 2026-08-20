#!/usr/bin/env python3
"""Mezcla la música bajo la voz con un ducking MEDIDO, no a ojo.

`sidechaincompress` de ffmpeg se probó primero y aplastaba la música 34.6 dB por debajo
de la voz — inaudible. Su umbral es lineal y a ciegas es imposible de afinar. Aquí la
curva de ducking se calcula sobre la envolvente real de la voz y se comprueba después.

Objetivo (medido sobre el resultado):
  · bajo la voz    → música ~13 dB por debajo
  · en los huecos  → sube ~6 dB, que es donde se oye el ritmo
"""
import numpy as np, os, subprocess, wave

AQUI = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SR = 48000
VIDEO = os.path.join(AQUI, "versiones", "v3-yapping.mp4")
MUSICA = os.path.join(AQUI, "assets", "musica.wav")
SALIDA = os.path.join(AQUI, "assets", "mezcla.wav")

BAJO_VOZ_DB = -13.0     # cuánto por debajo de la voz va la música mientras habla
LEVANTE_DB = 7.5        # cuánto sube en los huecos


def leer(path, canales):
    c = ["ffmpeg", "-v", "error", "-i", path, "-ac", str(canales),
         "-ar", str(SR), "-f", "s16le", "-"]
    b = subprocess.run(c, capture_output=True).stdout
    x = np.frombuffer(b, dtype=np.int16).astype(np.float32) / 32768
    return x.reshape(-1, canales) if canales > 1 else x


voz = leer(VIDEO, 2)
mus = leer(MUSICA, 2)
n = min(len(voz), len(mus))
voz, mus = voz[:n], mus[:n]

# --- envolvente de la voz y curva de ducking ---------------------------------
mono = voz.mean(1)
hop = SR // 100                                  # 100 Hz
m = len(mono) // hop
env = np.sqrt(np.array([(mono[i * hop:(i + 1) * hop] ** 2).mean() for i in range(m)]))
env_db = 20 * np.log10(np.maximum(env, 1e-6))

umbral = np.percentile(env_db, 55)               # por encima de esto, "está hablando"
duck = np.where(env_db > umbral, 0.0, LEVANTE_DB)

# suavizar: ataque rápido (baja pronto), recuperación media.
# ⛔ Con recuperación 0.02 (0.5 s) la música solo subía 0.7 dB: en este video los
# silencios ya están cortados, así que los huecos entre palabras duran 0.1-0.3 s y
# nunca daba tiempo a recuperar. A 0.12 (~0.1 s) el ritmo se oye entre frases.
sal = np.zeros_like(duck)
a_at, a_re = 0.35, 0.12
for i, x in enumerate(duck):
    prev = sal[i - 1] if i else x
    sal[i] = prev + (x - prev) * (a_at if x < prev else a_re)

# a muestras
curva = np.interp(np.arange(n), np.arange(m) * hop, sal)


def rms_db(x):
    return 20 * np.log10(max(1e-9, np.sqrt((x ** 2).mean())))


hablando = np.zeros(n, bool)
rep = np.repeat(env_db > umbral, hop)
hablando[:len(rep)] = rep[:n]
base = rms_db(mono[hablando]) + BAJO_VOZ_DB - rms_db(mus.mean(1))
gan = 10 ** ((base + curva) / 20)

mez = voz + mus * gan[:, None]

# limitador suave por si algún pico se pasa
pico = np.abs(mez).max()
if pico > 0.99:
    mez = np.tanh(mez / pico * 1.1) * 0.97

pcm = (np.clip(mez.reshape(-1), -1, 1) * 32767).astype(np.int16)
with wave.open(SALIDA, "wb") as w:
    w.setnchannels(2); w.setsampwidth(2); w.setframerate(SR)
    w.writeframes(pcm.tobytes())

# --- comprobación ------------------------------------------------------------
solo_mus = (mus * gan[:, None]).mean(1)
print("ganancia base de la música: %.1f dB" % base)
print("voz hablando            : %.1f dB" % rms_db(mono[hablando]))
print("música bajo la voz      : %.1f dB   (%.1f dB por debajo)"
      % (rms_db(solo_mus[hablando]), rms_db(mono[hablando]) - rms_db(solo_mus[hablando])))
print("música en los huecos    : %.1f dB   (sube %.1f dB)"
      % (rms_db(solo_mus[~hablando]), rms_db(solo_mus[~hablando]) - rms_db(solo_mus[hablando])))
print("pico de la mezcla       : %.3f" % np.abs(mez).max())
print(SALIDA)

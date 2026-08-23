#!/usr/bin/env python3
"""Ordena la carpeta de un video para que solo se vea lo que importa a diario.

Pedido suyo del 2026-08-16: al abrir la carpeta de un día se encontraba con audio.wav,
beats.txt, cuatro JSON, logs y scripts sueltos. *"Todos esos documentos extra me hacen
mucho ruido. Lo único que yo voy a ver es versiones."*

Queda así:

    2026-08-16/
      2026-08-16.MP4        ← el crudo
      ✅-APROBADO.md         ← la marca del OK
      versiones/            ← LO ÚNICO QUE ÉL ABRE
      proceso/              ← todo lo demás, fuera de la vista

⛔ NO BORRA NADA. Todo se mueve, nunca se elimina (si un video
funciona va a querer re-subirlo con variaciones, y para eso hacen falta el corte y la base).

⛔ Y NO ROMPE LOS SCRIPTS. Los scripts calculan sus rutas como «la carpeta que contiene a
scripts/», que después de mover pasa a ser `proceso/`. Para que sigan encontrando
`versiones/` y el crudo se dejan dos enlaces dentro de `proceso/`. Además se reescriben las
rutas absolutas guardadas dentro de los JSON de planes (assets/mg/plan.json y captions/plan.json),
que apuntaban a la ubicación vieja.

    python3 ordenar.py <carpeta>            # ordena una
    python3 ordenar.py --todas              # ordena todos los videos
    python3 ordenar.py <carpeta> --simular  # dice qué haría, sin tocar nada
"""
import json, os, shutil, sys

AQUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, AQUI)
from _raiz import raw_footage

RAW = raw_footage()

# lo que se queda arriba: el crudo, la marca de aprobado y versiones/
VIDEO_CRUDO = (".mp4", ".mov", ".m4v")
SE_QUEDAN = {"versiones", ".DS_Store"}
PROCESO = "proceso"


def es_crudo(nombre, carpeta):
    return (nombre.lower().endswith(VIDEO_CRUDO)
            and os.path.isfile(os.path.join(carpeta, nombre))
            and not nombre.startswith("_"))


def arreglar_json(proceso, viejo_base, nuevo_base):
    """Los planes guardan rutas absolutas de las secuencias PNG. Si no se reescriben,
    el montaje deja de encontrarlas y falla sin decir por qué."""
    tocados = 0
    for raiz, _, ficheros in os.walk(proceso):
        for fn in ficheros:
            if not fn.endswith(".json"):
                continue
            ruta = os.path.join(raiz, fn)
            try:
                txt = open(ruta).read()
            except Exception:
                continue
            if viejo_base not in txt:
                continue
            open(ruta, "w").write(txt.replace(viejo_base, nuevo_base))
            tocados += 1
    return tocados


def ordenar(carpeta, simular=False):
    carpeta = os.path.abspath(carpeta)
    nombre = os.path.basename(carpeta)
    if not os.path.isdir(os.path.join(carpeta, "versiones")):
        print("  ⬜ %s — sin versiones/, no se toca" % nombre); return
    destino = os.path.join(carpeta, PROCESO)
    sueltos = []

    def fusionar(org, dst):
        """⛔⛔ NUNCA borrar el destino.
        Antes esto hacía `shutil.rmtree(dst)` cuando el destino ya existía. En un video real
        había una carpeta `assets/` VACÍA en la raíz y una `proceso/assets/` LLENA con 1.5 GB
        de secuencias PNG, el corte 9:16 y los wav de música: el rmtree se llevó la llena para
        meter la vacía. Se perdió todo el material generado y hubo que volver a producirlo.
        El script promete «no borra nada, mueve» — ahora lo cumple.
        Dos carpetas se FUNDEN; un archivo que choca se guarda con sufijo."""
        if not os.path.exists(dst):
            shutil.move(org, dst); return
        if os.path.isdir(org) and os.path.isdir(dst):
            for hijo in os.listdir(org):
                fusionar(os.path.join(org, hijo), os.path.join(dst, hijo))
            if not os.listdir(org):
                os.rmdir(org)
            return
        base, ext = os.path.splitext(dst)
        i = 2
        while os.path.exists("%s-%d%s" % (base, i, ext)): i += 1
        shutil.move(org, "%s-%d%s" % (base, i, ext))
        print("      ⚠ %s ya existía en proceso/: el de la raíz se guardó como %s"
              % (n, os.path.basename("%s-%d%s" % (base, i, ext))))

    for n in sorted(os.listdir(carpeta)):
        if n in SE_QUEDAN or n == PROCESO or n.startswith("✅"):
            continue
        if es_crudo(n, carpeta):
            continue
        sueltos.append(n)
    if not sueltos:
        print("  ✓ %s — ya estaba ordenada" % nombre); return
    print("  %s %s — %d cosas -> proceso/" % ("(simulado)" if simular else "→", nombre, len(sueltos)))
    if simular:
        print("      " + ", ".join(sueltos[:12]) + (" …" if len(sueltos) > 12 else ""))
        return
    os.makedirs(destino, exist_ok=True)
    for n in sueltos:
        fusionar(os.path.join(carpeta, n), os.path.join(destino, n))
    # enlaces para que los scripts sigan encontrando lo que esperan
    for objetivo, enlace in [("../versiones", os.path.join(destino, "versiones"))]:
        if not os.path.lexists(enlace):
            os.symlink(objetivo, enlace)
    for n in os.listdir(carpeta):
        if es_crudo(n, carpeta):
            enlace = os.path.join(destino, n)
            if not os.path.lexists(enlace):
                os.symlink(os.path.join("..", n), enlace)
    n = arreglar_json(destino, carpeta + os.sep, destino + os.sep)
    if n:
        print("      %d json con rutas reescritas" % n)


if __name__ == "__main__":
    args = sys.argv[1:]
    simular = "--simular" in args
    args = [a for a in args if a != "--simular"]
    if args and args[0] == "--todas":
        print("ordenando todos los videos%s:\n" % (" (simulado)" if simular else ""))
        for d in sorted(os.listdir(RAW)):
            c = os.path.join(RAW, d)
            if os.path.isdir(c) and not os.path.islink(c):
                ordenar(c, simular)
    elif args:
        ordenar(args[0], simular)
    else:
        print(__doc__)

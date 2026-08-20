#!/usr/bin/env python3
"""Marca un video como APROBADO.

Convención: **✅ significa que ese video ya está editado y aprobado.**
Sin la marca, un video con render final NO está aprobado — solo está terminado.

El OK vive en un archivo dentro de la carpeta del video, no en el chat: así lo ve
cualquier sesión y cualquier chat, hoy o dentro de un mes.

    python3 aprobar.py <carpeta-del-video> [--nota "lo que dijo"]
    python3 aprobar.py --listar            # estado de todos los videos

Escribe `✅-APROBADO.md` con la versión aprobada (la que elige version_final.py), la
fecha y, si se pasa, la frase con la que lo aprobó.
"""
import os, sys, datetime, subprocess

AQUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, AQUI)
from _raiz import raw_footage

RAW = raw_footage()
MARCA = "✅-APROBADO.md"


def version_final(carpeta):
    out = subprocess.run([sys.executable, os.path.join(AQUI, "version_final.py"), carpeta],
                         capture_output=True, text=True).stdout.strip()
    return out.splitlines()[-1] if out else ""


def aprobar(carpeta, nota=None):
    v = version_final(carpeta)
    if not v:
        print("✗ %s no tiene ninguna versión final" % carpeta); return 1
    hoy = datetime.date.today().isoformat()
    txt = "# ✅ APROBADO\n\n"
    txt += "**Versión aprobada:** `%s`\n\n" % os.path.basename(v)
    txt += "**Fecha del OK:** %s\n" % hoy
    if nota:
        txt += "\n**Lo que dijo:** «%s»\n" % nota
    txt += ("\n---\n\nEste archivo ES el OK. Mientras esté, el video se considera editado y "
            "aprobado, y no se vuelve a tocar salvo que lo pidan.\n"
            "Si se sube de versión después de esto, hay que volver a pedirle el ✅.\n")
    ruta = os.path.join(carpeta, MARCA)
    open(ruta, "w").write(txt)
    print("✅ %s  ->  %s" % (os.path.basename(os.path.normpath(carpeta)), os.path.basename(v)))
    return 0


def listar():
    print("estado de los videos de short-form:\n")
    for d in sorted(os.listdir(RAW)):
        c = os.path.join(RAW, d)
        if not os.path.isdir(c) or os.path.islink(c):
            continue
        v = version_final(c)
        if not v:
            print("  ⬜ %-30s sin editar" % d); continue
        ok = os.path.exists(os.path.join(c, MARCA))
        print("  %s %-30s %s" % ("✅" if ok else "🟡", d, os.path.basename(v)))
    print("\n  ✅ aprobado · 🟡 editado, falta el OK · ⬜ sin editar")


if __name__ == "__main__":
    args = sys.argv[1:]
    if not args or args[0] == "--listar":
        listar(); sys.exit(0)
    nota = None
    if "--nota" in args:
        i = args.index("--nota"); nota = args[i + 1]; args = args[:i] + args[i + 2:]
    sys.exit(aprobar(args[0], nota))

#!/usr/bin/env python3
"""Devuelve la version final de un video de content-os.

REGLA ESTRICTA (2026-08-14). Solo compiten los archivos cuyo nombre empieza con
'v' seguido de digitos:  v1-corte.mp4, v10-final.mp4, v6-kallaway.mp4.
Todo lo demas se ignora: hook-v3-final.mp4, comparacion-color.mp4, pruebas.

El numero se compara COMO NUMERO, nunca como texto. Ordenar por texto pone v9
encima de v10 porque compara caracter por caracter y '9' > '1'.

Empate de numero (tres v1-gap*): gana el mas reciente por fecha de modificacion.

    python3 version_final.py <carpeta-del-video>
    python3 version_final.py <carpeta> --todas     # muestra el descarte
"""
import os
import re
import sys

# ancla al inicio + digitos + separador: ni 'hook-v3' ni 'version-2' pasan
PATRON = re.compile(r"^v(\d+)[-_.]", re.IGNORECASE)
EXTS = {".mp4", ".mov", ".m4v"}


def candidatas(carpeta):
    """[(numero, mtime, nombre)] de los archivos que cumplen la regla."""
    out = []
    for n in os.listdir(carpeta):
        if os.path.splitext(n)[1].lower() not in EXTS:
            continue
        m = PATRON.match(n)
        if not m:
            continue
        out.append((int(m.group(1)), os.path.getmtime(os.path.join(carpeta, n)), n))
    return out


def final(carpeta):
    """Ruta de la version final, o None si la carpeta no tiene ninguna valida."""
    c = candidatas(carpeta)
    if not c:
        return None
    return os.path.join(carpeta, max(c)[2])


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    carpeta = sys.argv[1]
    if os.path.isdir(os.path.join(carpeta, "versiones")):
        carpeta = os.path.join(carpeta, "versiones")
    if not os.path.isdir(carpeta):
        sys.exit(f"No existe la carpeta: {carpeta}")

    elegida = final(carpeta)
    if not elegida:
        sys.exit(f"Ninguna version valida en {carpeta} (nada que empiece con v<numero>-)")

    if "--todas" in sys.argv:
        validas = {n for _, _, n in candidatas(carpeta)}
        print(f"  {'archivo':32}{'cuenta?':>10}")
        for n in sorted(os.listdir(carpeta)):
            if os.path.splitext(n)[1].lower() not in EXTS:
                continue
            m = PATRON.match(n)
            print(f"  {n:32}{('si  v' + m.group(1)) if n in validas else 'NO':>10}")
        print()
    print(elegida)


if __name__ == "__main__":
    main()

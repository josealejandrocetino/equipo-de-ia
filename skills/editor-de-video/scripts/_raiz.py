"""Encuentra la carpeta de trabajo. Compartido por los scripts que la necesitan.

⛔ REGLA: `content-os/` vive en la carpeta donde la persona abrió Claude Code.
No se cuentan niveles hacia arriba desde la skill — instalada como plugin, la skill vive
en otro disco lógico y esa cuenta cae en cualquier lado.

Se busca desde el directorio actual hacia arriba, para que los scripts también funcionen
si se corren desde dentro de la carpeta de un video.
"""
import os, sys


def raiz_content_os(obligatorio=True):
    aqui = os.path.abspath(os.getcwd())
    tope = os.path.abspath(os.path.expanduser("~"))
    while True:
        cand = os.path.join(aqui, "content-os")
        if os.path.isdir(cand):
            return cand
        padre = os.path.dirname(aqui)
        if padre == aqui or aqui == tope:
            break
        aqui = padre
    if not obligatorio:
        return None
    sys.exit(
        "No encuentro tu carpeta content-os/.\n\n"
        "El pipeline la busca en la carpeta donde abriste Claude Code.\n"
        "Dos formas de arreglarlo:\n"
        "  1. Cierra Claude Code y vuelve a abrirlo eligiendo tu carpeta de trabajo\n"
        "     (la que creó el instalador, por ejemplo Pedro-Cowork).\n"
        "  2. O crea la carpeta aquí mismo:  mkdir -p content-os/raw-footage\n"
    )


def raw_footage():
    return os.path.join(raiz_content_os(), "raw-footage")

# Estilos que vienen con el plugin

Cada carpeta de aquí es un **estilo de edición listo para usar**. Llegan con el plugin y se
actualizan solos cuando sale una versión nueva.

⛔ **Estos estilos no se editan.** Una actualización los sobrescribe. Si quieres cambiar uno,
cópialo a `content-os/styles/experimental/<nombre>/` y trabaja sobre esa copia: lo que vive en
tu `content-os/` es tuyo y **nunca se toca al actualizar**.

## Cómo se ve un estilo

```
<nombre-del-estilo>/
  dna.md          ← obligatorio. Qué lo define, escrito para entenderlo sin ver el video
  referencia.md   ← de dónde salió (link del video que lo inspiró)
  template.aep    ← opcional. Solo si el estilo usa After Effects (nivel 3)
```

**Si no hay `dna.md`, el estilo no está guardado.** Es el archivo que permite reproducirlo.

## Dónde busca la skill

Los dos sitios, en este orden:

1. **`${CLAUDE_PLUGIN_ROOT}/skills/editor-de-video/estilos/`** — los que vienen con el plugin
2. **`content-os/styles/proven/` y `content-os/styles/experimental/`** — los tuyos

Si un estilo tuyo se llama igual que uno del plugin, **gana el tuyo**.

## Para añadir uno nuevo al plugin

Usa `PLANTILLA-dna.md` como punto de partida. Antes de meterlo, quítale:

- Colores y tipografías de una marca concreta — describe el rol ("acento de marca"), no el valor
- Nombres de personas y de clientes, dentro del texto y no solo en los nombres de archivo
- Rutas de una máquina concreta

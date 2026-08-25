# Content OS — la librería de estilos

Carpeta central donde vive todo lo que hace falta para recrear o reutilizar un estilo.

⛔ **`content-os/` vive en la raíz de la carpeta donde abriste Claude Code.** Esa carpeta es tu
espacio de trabajo — el nombre da igual. Si no existe `content-os/`, créala ahí; no la busques
en otro sitio ni subas niveles para encontrarla.

**Sin esta fase, cada video arranca desde cero.** Ese es el único motivo por el que el pipeline
escala: un estilo se construye una vez y se reutiliza cincuenta.

```
content-os/
├── mi-voz.md                   ← tu tono, construido con las preguntas del brief (Fase 1)
├── styles/
│   ├── proven/                  ← estilos validados, listos para producción en lote
│   │   └── <nombre-estilo>/
│   │       ├── dna.md           ← descripción escrita del estilo
│   │       ├── template.aep     ← proyecto de After Effects reutilizable
│   │       └── referencia.md    ← link(s) del video original que lo inspiró
│   └── experimental/            ← estilos en prueba, todavía no confirmados
├── raw-footage/                 ← CORTO FORMATO en producción, una carpeta por FECHA
│   └── <fecha>/                    el archivo de cámara suelto + assets/ + versiones/
│       (dos videos el mismo día: <fecha>-2, <fecha>-3... — nunca se comparte carpeta)
├── youtube/                     ← LARGO FORMATO en producción, una carpeta por VIDEO
│   └── <fecha>-<nombre>/           misma forma: cámara suelto + assets/ + versiones/
└── b-roll/                      ← material que se REUTILIZA entre videos
    ├── short/
    └── youtube/
```

> **No hay carpeta de `briefs/` suelta.** El brief y la propuesta van **junto al video**, dentro
> de su carpeta. Los renders finales van en `<video>/versiones/`.

> **Dónde vive cada formato.** El corto va en `raw-footage/<fecha>/` y el largo de YouTube en
> `youtube/<fecha>-<nombre>/`. **Todo el video vive dentro de `content-os/`.** El archivo de
> cámara va **suelto** dentro de la carpeta del video, no en una subcarpeta: así al abrirla se ve
> el crudo de un vistazo.

## Reglas para que esto escale

1. **Un estilo = una carpeta**, siempre con `dna.md` adentro. **Si no hay `dna.md`, el estilo
   no está guardado** — solo se probó una vez y se va a perder.
2. Nombres descriptivos y sin espacios: `danco-glow`, no `estilo 3` ni `nuevo final v2`.
3. Un estilo pasa de `experimental/` a `proven/` **solo cuando ya se usó con éxito en un video
   real publicado**, no en una prueba.
4. `dna.md` se escribe para que **otra persona — o tú mismo en 3 meses — lo entienda sin ver el
   video original**.
5. Los estilos de un cliente específico se nombran con su prefijo: `<cliente>-hook`.

## Plantilla de `dna.md`

```markdown
# Estilo: <nombre>

## Referencia original
[link al video/tutorial que lo inspiró]

## Paleta
Fondo casi negro, acentos en cian/blanco con glow suave.

## Tipografía
Sans-serif bold para titulares, tracking apretado, mayúsculas.

## Curvas de animación
Entradas rápidas con ease-out marcado, sin rebote. Salidas más lentas que las entradas.
Valores de zoom usados: [pega los keyframes exactos]

## Ritmo
Corte cada 1.5–2.5s en la parte hablada, más lento en tomas de impacto.
GAP usado en el corte: 0.22

## Efectos clave
- Glow difuso detrás del texto principal
- Grano/film ligero para que no se vea demasiado digital

## Sonido
Whooshes cortos en los punch-in. Reverb throw en los cortes de sección.

## Funciona bien para
Hooks cortos, contenido de negocios/marketing, vertical.

## No funciona para
[lo que ya se probó y no pegó — igual de valioso]
```

## Sobre los assets

El plugin trae los estilos base. Los **gráficos, los sonidos y los LUTs no vienen incluidos**:
se construyen una vez y son tuyos.

⛔ **Tus estilos y tus assets nunca se tocan al actualizar el plugin.** Viven en tu `content-os/`.

Los estilos que **vienen con el plugin** viven aparte, en `estilos/` dentro de la skill, y sí se
actualizan. Para partir de uno de ellos, cópialo a `content-os/styles/experimental/<nombre>/`
y trabaja sobre la copia — si lo editas en su sitio, la siguiente actualización se lo lleva.

- **Motion graphics propios** — tarjetas de conteo, toggles, checkboxes, mocks de comentarios
  de IG, lower-thirds. Constrúyelos como **plantillas re-texteables**, no como renders fijos.
- **SFX** — whooshes, clicks, ticks, risers. Cualquier pack decente sirve. Guárdalos en una
  carpeta propia y organizada por tipo de movimiento.
- **Color / LUTs** — fuera de alcance de esta skill.

Cada asset nuevo que se cure entra a la librería. **La librería es el activo real**, más que
cualquier video individual.

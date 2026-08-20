# Ejecutar en After Effects

Cómo aterrizar las técnicas de `02-tecnica.md` en **After Effects** vía el puente MCP.
Esto es el **nivel 3**: opcional, y solo si la persona ya tiene After Effects.

**DaVinci Resolve, Premiere Pro y Remotion no son parte de este stack.** No los sugieras salvo que se lo
pida explícitamente.

---

## Antes de empezar — verificar el puente

1. After Effects abierto.
2. Panel del puente MCP abierto dentro de AE, en estado conectado / "Auto Process: ON".
3. Las herramientas MCP de AE aparecen disponibles en esta sesión de Claude Code.

Si el paso 3 falla: reiniciar Claude Code. Si sigue fallando → `07-instalacion.md`.

**Si el puente no está: baja al camino ffmpeg de `01-corte.md` y entrega igual.** Avisa qué
camino tomaste y qué se pierde. **Nunca dejes a la persona sin resultado.**

**Si algo se ve raro** (un panel que no responde, un botón que no está donde debería),
**pide una captura de pantalla.** No adivines qué está pasando adentro de la app.

---

## Meter el corte en la timeline

`build_wx.py` imprime las líneas `# inicio-fin` en segundos. Conviértelas a un **EDL CMX3600**
o un **XML FCP7**:
- un evento por clip
- source in/out = los segundos de inicio/fin del clip
- record-in = acumulado

Se importa en After Effects y arma la secuencia apuntando al archivo fuente original.
Confirma los FPS de la fuente antes de generar el EDL — un EDL con FPS equivocados desplaza
todo.

---

## Las técnicas, traducidas a After Effects

| Técnica | Cómo se hace en AE |
|---|---|
| **Zoom (gancho, punch in/out)** | Keyframes de **Scale** en Transform de la capa. Mete los valores tal cual de `02-tecnica.md` y aplica easing a los keyframes (ease-out fuerte, no lineal) |
| **Centro del zoom** | **Anchor Point** / Position. Recuerda el bloqueo de centro: en cualquier zoom que baje a ≤1.0, el centro no se mueve |
| **Motion blur del movimiento** | Activa motion blur **solo en el tramo del movimiento**, o usa **Directional Blur / CC Force Motion Blur** con su intensidad animada a 0 en reposo |
| **Zoom blur** | **Radial Blur** en modo Zoom, intensidad animada con pico en la parte rápida |
| **Aberración cromática** | Separación de canales RGB (o un plugin equivalente), intensidad animada con pico en el movimiento |
| **Fade exponencial de texto** | Keyframes de **Opacity** + **Position** + un **Gaussian Blur** que va de borroso a 0, todos con el mismo ease-out. Se puede hacer con expresión para que sea repetible |
| **Authority stack** | Capas de texto apiladas, tracking ≈ -0.04em, cada línea con su fade exponencial desfasado |
| **Parallax sobre zoom** | El gráfico lleva su propio Scale, **un poco mayor** que el del footage, sincronizado a los mismos frames |
| **Assets re-texteables** | Cada gráfico es una **composición** con su capa de texto editable. Cambia el texto en la comp fuente y re-renderiza con alfa. Nunca superpongas texto sobre un render quemado |

**Expresiones:** si un creador de referencia comparte expresiones de AE, cópialas tal cual —
son la forma más fiel de reproducir una curva de animación específica.

### ⚠️ USA matchNames, NUNCA nombres traducidos

**After Effects se instala en el idioma del usuario**, y los nombres visibles de efectos y
propiedades están traducidos: en un AE en español `"Blurriness"` **falla**, porque allí se
llama "Grado de desenfoque". Y al revés: escribir el nombre en español rompe en un AE en inglés.
**Nunca uses el nombre que ves en pantalla.**

**Solución: identificadores internos (matchName), iguales en todos los idiomas.**

| Para qué | Qué pasar |
|---|---|
| Aplicar un efecto | `effectMatchName: "ADBE Gaussian Blur 2"` |
| Animar su parámetro | `propertyName: "ADBE Gaussian Blur 2-0001"` |

El patrón del parámetro es `<matchName del efecto>-000N`, numerando los parámetros desde 1.

**Sí funcionan sin traducir** (son nombres internos de AE, no traducidos): `Position`, `Scale`,
`Rotation`, `Opacity`, `Source Text`.

**El puente sí puede animar parámetros de efectos.** Su `setLayerExpression` recorre los efectos
de la capa buscando la subpropiedad. Eso habilita desenfoques animados, glow, aberración
cromática y demás — todo por expresión, sin un solo keyframe.

---

## Versionado (Fase 4)

Cada iteración es una versión nueva, no una sobreescritura:
- Guarda el proyecto como `<nombre>_v1.aep`, `_v2.aep`, etc., o usa marcadores muy claros.
- Renderiza una vista previa corta de cada versión para que la persona la mire.
- Reporta cuánto tardó cada una.
- Si la v2 era mejor que la v4, hay que poder volver a la v2 sin reconstruir.

---

## Proyectos largos

Para YouTube long-form (extensión futura, todavía no probada aquí): el corte lo arma **ffmpeg**
igual que en el vertical, y After Effects hace solo las animaciones y motion graphics puntuales.

**No fuerces todo dentro de After Effects** si el proyecto es más de timeline que de motion
graphics: cuantas más capas y clips, más frágil se vuelve el puente.

---

## Producción en lote (Fase 7)

1. Abre la plantilla `.aep` del estilo aprobado + lee su `dna.md`.
2. Por cada clip nuevo: reemplaza el footage, adapta textos y duraciones.
3. **Las animaciones, curvas y ritmo NO se tocan.** Esa es la identidad de marca.
4. QC individual por video antes de darlo por terminado.

---

## Notas de realidad

- El puente MCP de After Effects es un **proyecto de la comunidad**, no un producto oficial de
  Adobe ni de Anthropic. Funciona, pero se instala a mano.
- Es **más estable en Windows que en Mac**. Si en Mac hay fricción, es esperable — no es que
  estés haciendo algo mal.
- **Después de cualquier cambio grande, abre/recarga el proyecto una vez** antes de renderizar.

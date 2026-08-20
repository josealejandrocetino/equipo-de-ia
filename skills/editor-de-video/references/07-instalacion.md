# Instalación y diagnóstico

**Casi nada de esto se hace a mano.** El instalador deja la máquina lista; este archivo sirve
para entender qué pasó, leer el diagnóstico cuando algo falla, y conectar After Effects si la
persona lo pide.

⛔ **Nunca le dictes comandos de terminal a alguien que no los pidió.** Si falta una pieza, la
respuesta casi siempre es *"vuelve a hacer doble clic en el instalador"*.

---

## Qué hace el instalador

Un solo archivo, doble clic desde el explorador de archivos. **Se puede correr las veces que
haga falta: lo que ya está instalado no se toca.**

| Paso | Qué deja |
|---|---|
| 1 | Pregunta el nombre y crea `<Nombre>-Cowork/content-os/` con `raw-footage/`, `styles/` y `b-roll/` |
| 2 | El gestor de programas del sistema (Homebrew en Mac, winget en Windows) |
| 3 | ffmpeg, Python 3.11, Node y poppler |
| 4 | WhisperX 3.8.6 en su propio entorno aislado, más Pillow |
| 5 | Google Chrome — de ahí sale **todo** el texto en pantalla |
| 6 | Claude Code y este plugin, ya activado |
| 7 | Corre el diagnóstico y enseña cómo empezar |

**No instala After Effects.** Es software de pago de Adobe, con su propia cuenta y su propia
descarga. El instalador solo comprueba si está.

Guarda la ruta de la carpeta de trabajo para que el diagnóstico la encuentre después.

---

## Cómo leer el diagnóstico

El archivo de revisión (también doble clic) **solo mira: no instala, no borra, no modifica nada.**
Termina con lo único que de verdad importa:

```
════ QUÉ PUEDES HACER HOY ════
  SÍ  Nivel 1 — Corte: silencios, tomas, subtítulos
  SÍ  Nivel 2 — Acabado: rótulos, apoyos, sonidos
  NO  Nivel 3 — Animación: motion graphics
```

**Un "NO" en el nivel 3 no es un error.** Significa que no hay After Effects, que es de pago y
opcional. Con los niveles 1 y 2 se entregan videos publicables el mismo día.

### Qué significa cada falta

| Lo que dice | Qué pasa de verdad | Qué contestar |
|---|---|---|
| `FALTA ffmpeg` | Sin motor de video. No se puede cortar | Doble clic en el instalador |
| `FALTA WhisperX` | Sin transcriptor: no hay corte por palabras ni subtítulos | Doble clic en el instalador. Es el paso más lento |
| `FALTA Google Chrome` | **Bloquea el nivel 2.** Todo el texto en pantalla se genera con Chrome | Instalar Chrome |
| `FALTA Pillow` | Sin apoyos visuales | Doble clic en el instalador |
| `FALTA Plugin Equipo de IA` | El pipeline no está enganchado a Claude Code | Doble clic en el instalador |
| `AVISO carpeta movida` | La carpeta de trabajo cambió de sitio o de nombre | No rompe nada: basta con abrir Claude Code dentro de la carpeta nueva |

⛔ **Chrome no es opcional en los niveles 1 y 2.** El ffmpeg que se instala no trae `drawtext`,
así que rótulos, subtítulos y carteles salen de Chrome en modo invisible. Sin Chrome, hay corte
pero no hay texto en pantalla.

---

## Nivel 3 — Conectar After Effects (solo si lo piden)

⛔ **No propongas esto.** Si no hay After Effects, el pipeline baja al camino de ffmpeg y
entrega igual. Este camino se abre **solo** cuando la persona dice algo como *"quiero instalar
After Effects, guíame"*.

Cuando lo pida, llévala **paso a paso, confirmando cada uno antes de seguir**. Si algo falla,
pide una captura de pantalla en vez de adivinar.

**Paso 1 — Tener After Effects.** Se compra y se descarga desde Adobe, con Creative Cloud.
Ni tú ni el instalador pueden hacerlo. Si todavía no lo tiene, aquí se para.

**Paso 2 — El puente.** Es un proyecto de la comunidad (`Dakkshin/after-effects-mcp`), no un
producto oficial de Adobe ni de Anthropic. Se descarga y se compila con Node:

```bash
git clone --depth 1 https://github.com/Dakkshin/after-effects-mcp.git
cd after-effects-mcp && npm install
```

**Paso 3 — El panel dentro de After Effects.** Con After Effects **cerrado**, se copia el
archivo `mcp-bridge-auto.jsx` a la carpeta `Scripts/ScriptUI Panels/` de la instalación de
After Effects.

⛔ **En Mac esa carpeta es del sistema y pide contraseña de administrador. Ese paso lo tiene
que ejecutar la persona, nunca tú.** Dale el comando exacto y espera a que confirme.

**Paso 4 — El permiso.** Abrir After Effects → Preferencias → *Scripting y expresiones* →
marcar **"Permitir que las secuencias de comandos escriban archivos y accedan a la red"**.
Sin esto el puente no comunica, y no da ningún error visible.

**Paso 5 — Encender el panel.** `Ventana → mcp-bridge-auto.jsx`. Se abren **dos** ventanas: un
panel acoplable vacío (se cierra) y la flotante **"MCP Bridge Auto"**, que es la buena. Tiene
que decir `Ready - Auto-run is ON`. El aviso naranja sobre paneles acoplables **no es un error**.

**Paso 6 — Conectar con Claude Code.** Registrar el servidor con la ruta absoluta de `node` y
la del puente recién compilado, y **reiniciar Claude Code**.

**Paso 7 — Comprobar.** En una sesión nueva tienen que aparecer las herramientas de After
Effects. Si no aparecen, revisar el paso 4 y que el panel siga abierto.

### La rutina de cada día

**El panel no se abre solo.** Cada vez que se abre After Effects hay que ir a
`Ventana → mcp-bridge-auto.jsx` y dejar la ventana flotante abierta. Si se cierra, se corta la
comunicación a mitad de trabajo.

### Para desinstalarlo

Borrar `mcp-bridge-auto.jsx` de la carpeta de paneles y quitar el servidor de la configuración.
After Effects queda como estaba.

---

## Si nada de esto lo arregla

Pide **una captura del diagnóstico completo**. Dice el procesador, la versión del sistema y qué
encontró de cada pieza — con eso se diagnostica sin adivinar.

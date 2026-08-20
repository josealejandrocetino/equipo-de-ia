# Equipo de IA — plugin de Claude Code

Pipeline de edición de video con IA, empaquetado como plugin instalable para Mac. Los miembros
lo instalan una vez y reciben las actualizaciones desde este repositorio.

---

## ⛔ Reglas de esta carpeta

**1. Este repositorio es público.** No entra nada personal ni de clientes: `settings.local.json`,
`.mcp.json`, contextos personales, footage, material de clientes, rutas con nombre de usuario.
El `.gitignore` bloquea lo obvio, pero **no agarra un nombre escrito dentro de un script**.

**2. La carpeta de origen del pipeline es SOLO LECTURA.** De ahí solo se copia hacia acá.
Nunca escribir, mover, renombrar ni borrar nada allí. Sigue en uso activo por otras sesiones.

**3. Si el plugin se arma sin depender de la carpeta de origen, funcionará en otra máquina.**
Si falta algo, **ese hueco es el hallazgo** — se anota, no se tapa leyendo del origen sin decirlo.

**4. Antes de publicar: revisión de nombres.** Buscar nombres de personas y de clientes *dentro
del contenido* de los archivos, no solo en los nombres de archivo.

**5. Refrescar la copia justo antes de publicar**, no antes — el origen sigue cambiando — y
volver a pasar la revisión de nombres sobre lo refrescado.

---

## Los tres niveles (la clave del producto)

| Nivel | Qué entrega | Qué pide |
|---|---|---|
| **1 Corte** | Silencios fuera, tomas elegidas, subtítulos | Solo el instalador |
| **2 Acabado** | Rótulos, apoyos visuales, sonidos | Solo el instalador |
| **3 Animación** | Motion graphics | + After Effects |

**Los niveles 1 y 2 no necesitan Adobe, y ahí vive la mayor parte del valor.** Adobe es mejora
opcional, no barrera. Si el puente de After Effects no está, el pipeline **no se detiene**:
baja al camino de ffmpeg y entrega igual.

**La v1 es SOLO el pipeline de edición.** La distribución de contenido queda fuera —
todavía no está resuelta y puede entregarse por otro camino más adelante.

**Premiere Pro está fuera de alcance.** No se usó y no hace falta.
**Mac y Windows en la v1** (decidido el 2026-08-18). Windows no se excluye. Implica:
segundo instalador con `winget` en vez de Homebrew, rutas del venv distintas
(`bin/python` vs `Scripts\python.exe`), y otra ruta de After Effects.

⛔ **Regla de diseño que sale de ahí:** las skills se mantienen **neutras de sistema
operativo**. Que los scripts de Python resuelvan solos dónde está cada programa, y que las
guías llamen al script, no al programa. Toda la diferencia entre Mac y Windows queda encerrada
en el instalador. **Windows sin probar no se cobra** — hace falta una máquina real antes.

---

## Decisiones cerradas (2026-08-17)

1. **La skill se llama `editor-de-video`.** Ningún nombre de marca de origen en las skills.
2. **El instalador pregunta el nombre del miembro** y crea su carpeta de trabajo. El pipeline
   usa ese nombre; hoy hay 32 menciones a una persona concreta en 10 archivos.
3. **El contexto y la voz se sacan con preguntas, no con un archivo en blanco.** Las respuestas
   se guardan solas. Motivo: nadie sabe describir su propio tono, pero todos saben contestar
   "¿a quién le vendes?". Un archivo vacío es fricción.
4. **`Work/Clientes/` fuera** — es una estructura de agencia, no del miembro.
5. **B-roll se queda**, para que el miembro meta el suyo.
6. **`07-instalacion.md` se reescribe:** deja de ser comandos para pegar y pasa a ser qué hace
   el instalador y cómo leer el diagnóstico.
7. **After Effects no lo instala el instalador** — es software de pago de Adobe.
8. **Un solo plugin, dos instaladores.** No se separa en un plugin de Mac y otro de Windows:
   de 32 archivos, solo los instaladores dependen del sistema. Duplicar los otros 30 los hace
   separarse con el tiempo — se arregla una regla en uno y el otro queda roto. En la página de
   descarga sí van **dos botones**; por dentro la cocina es una.

```
instalar-mac.command     revisar-mac.command
instalar-windows.bat     revisar-windows.bat
skills/                  ← compartido
```

9. **El nivel 3 se activa preguntando.** El miembro escribe *"quiero instalar After Effects,
   guíame"* y la skill lo lleva paso a paso: descarga, panel del puente, permiso de scripts,
   conexión. **Quien no vaya a comprar After Effects nunca ve ese camino** — no hay un paso
   trabado al principio que le haga sentir que le falta algo.

---

## Dónde vive la carpeta de trabajo

**La carpeta donde el miembro abre Claude Code es su carpeta de trabajo.** Cero configuración.
El nombre da igual (`Pedro-Cowork`, `Mi Negocio`, lo que sea).

⛔ Hoy los scripts buscan `content-os/` **contando cuatro niveles hacia arriba** desde la skill.
Eso solo funciona en la máquina de origen. Instalado como plugin, se rompe.

El instalador le crea la carpeta para que no arranque en blanco:

```
<Nombre>-Cowork/
  content-os/
    raw-footage/     ← su footage, una carpeta por fecha
    styles/          ← los estilos que trae el plugin + los suyos
    b-roll/          ← material que reutiliza entre videos
```

⛔ **Sin carpeta `briefs/`.** El brief va junto al video, dentro de su carpeta. `mi-voz.md` lo
crea la skill sola con las tres preguntas del brief — el instalador no deja archivos en blanco.

Rutas dentro de la skill: usar **`${CLAUDE_PLUGIN_ROOT}`**, nunca `.claude/skills/...`.

---

## Los estilos: dos orígenes que no se mezclan

| | Dónde vive | Qué pasa al actualizar |
|---|---|---|
| **Estilos del plugin** | Dentro de este repositorio | Llegan solos a todos los miembros |
| **Estilos del miembro** | En su `content-os/styles/` | **Nunca se tocan** |

Por eso un estilo nuevo solo llega a la comunidad si está **dentro del repositorio**. Antes de
meter uno: limpiarlo de marca, de nombres de clientes y de rutas de máquina.

---

## Recorrido del miembro

1. Descarga el `.zip` y lo abre.
2. **Doble clic en `instalar.command`** — pregunta su nombre, instala lo que falte
   (Homebrew, ffmpeg, Python 3.11, WhisperX, Node, poppler, Chrome, Claude Code),
   crea su carpeta y deja el plugin puesto. **Idempotente:** correrlo dos veces no rompe nada.
3. **Abre la app de Claude Code y elige esa carpeta.** No necesita Terminal.
4. Escribe *"edita este video"*.

**`revisar.command`** es el diagnóstico: dice qué falta, cómo arreglarlo y **qué nivel le
funciona hoy**. Es el que ahorra el soporte.

---

## Cómo se instala (VERIFICADO el 2026-08-18)

Requiere el CLI: `npm install -g @anthropic-ai/claude-code`. Después, dos comandos — **sin
clics y sin abrir la app**, que es justo lo que necesita el instalador:

```bash
claude plugin marketplace add <ruta-o-repo-de-github>
claude plugin install equipo-de-ia@equipo-de-ia --yes
```

⛔ **La ruta local tiene que ser `./ruta` o absoluta.** Un `.` suelto lo rechaza.
`--yes` es obligatorio cuando no hay una persona confirmando.

Para que el repositorio sea instalable hacen falta **dos manifiestos**, no uno:

| Archivo | Qué es |
|---|---|
| `.claude-plugin/plugin.json` | La ficha del producto: nombre, descripción, versión |
| `.claude-plugin/marketplace.json` | El catálogo: qué plugins hay en el repo y dónde |

Deshacer: `claude plugin uninstall equipo-de-ia@equipo-de-ia` y
`claude plugin marketplace remove equipo-de-ia`.

**Validar antes de publicar** (da fallos y avisos concretos):

```bash
claude plugin validate .
```

⚠️ **El scope importa.** Por defecto se instala en `user` y queda activo en **todas** las
sesiones. Durante el desarrollo eso hace que convivan la skill del plugin y la original de la
carpeta de origen — desinstalarlo mientras no se esté probando.

**Coste medido:** la skill son ~210 tokens siempre + ~3.9k cuando se dispara. Barato incluso
con varios plugins instalados.

---

## Probar sin publicar

Desde esta carpeta:

```bash
claude --plugin-dir "$(pwd)"
```

---

## Estado (2026-08-18)

**Skill `editor-de-video` limpia y probada.** 9 de 10 archivos de referencia + los 14 scripts:
cero rastros de la máquina de origen, de marca o de persona concreta.

Arreglado y **verificado con una carpeta de prueba**: `aprobar.py` y `ordenar.py` ya no cuentan
niveles hacia arriba — resuelven `content-os/` desde donde se abrió Claude Code, con
`scripts/_raiz.py`. Funcionan desde la raíz del espacio de trabajo y desde dentro de la carpeta
de un video; si no hay `content-os/`, dan un mensaje que dice cómo arreglarlo en vez de reventar.

**Lo aprendido en esa prueba:** los scripts **imprimen texto en pantalla**, y ahí también había
rastros ("aprobado por él", "falta su OK"). Un barrido sobre la documentación no los ve —
**hay que ejecutar los scripts y leer su salida.**

**Instalación verificada de punta a punta** (2026-08-18): `claude plugin validate` pasa,
`marketplace add` + `install --yes` funcionan sin intervención. Ver la sección de instalación.

**`instalar-mac.command` y `revisar-mac.command` escritos y probados.** El instalador tiene
`--simular` para ensayarlo sin tocar la máquina; el diagnóstico es solo lectura y termina
diciendo **qué nivel funciona hoy**. `07-instalacion.md` reescrito: ya no son comandos para
pegar, sino cómo leer el diagnóstico + la guía paso a paso de After Effects.

**Windows probado de punta a punta el 2026-08-19** en un Windows 11 Home real: instalación
completa y los tres niveles en SÍ. Salieron cinco bugs que desde Mac era imposible ver — están
todos arriba, en la sección de Windows.

## ✅ PIPELINE PROBADO DE VERDAD (2026-08-19, en la PC de Windows)

Con solo escribir **"edita este video"**, en una máquina que no es la de origen y con una cuenta
de Claude nueva, la skill:

1. Se disparó sola con esa frase — el `description` funciona
2. Verificó el entorno (Fase 0) y, al no ver el puente de After Effects, **bajó al camino de
   ffmpeg y avisó qué se perdía** — la regla de degradación, funcionando
3. Encontró `content-os/` desde la carpeta abierta — el bug de las rutas, resuelto
4. Encontró el video, lo midió, y **leyó el `dna.md` de `yapping` desde dentro del plugin**
5. Pidió el brief antes de cortar, incluido **el titular preguntado** (ya no lo busca en ningún
   sitio externo) y si lleva música
6. Cortó, puso titular y subtítulos. Resultado publicable.

**Único defecto observado:** se comió una palabra en un corte. Es el borde de palabra de
WhisperX, ya documentado en `01-corte.md`; se arregla iterando.

**Falta para vender:** publicar en GitHub, más estilos, y llevar a esa PC los arreglos
posteriores (Git, escritorio de OneDrive).

---

## Para el manual de instalación (no olvidar)

- **Decirle al miembro que no le cambie el nombre ni mueva su carpeta de trabajo** después de
  instalar. El pipeline funciona igual (encuentra `content-os/` desde donde se abre Claude Code),
  pero el diagnóstico la localiza por su ruta guardada y por el sufijo `-Cowork`. Si la mueven,
  el diagnóstico avisa que no la encuentra — y eso parece un error aunque no lo sea.
- El instalador guarda la ruta en `~/.equipo-de-ia/config`; el diagnóstico la lee de ahí primero.

---

## ⛔ Windows: los `.ps1` van con BOM (descubierto el 2026-08-19, probándolo en una PC real)

Windows PowerShell 5.1 —el que trae Windows por defecto— **lee un archivo UTF-8 sin BOM como si
fuera Windows-1252**. Una raya larga `—` se convierte en `â€"`, y ese `"` **parte la cadena por
la mitad**: el script revienta con diez errores de sintaxis que no tienen nada que ver con el
problema real.

**La regla:** los `.ps1` se guardan **UTF-8 con BOM** (`encoding="utf-8-sig"` en Python), y en los
`.bat` va `chcp 65001 >nul` antes de llamar a PowerShell para que la consola muestre los acentos.
Nada de rayas largas ni comillas tipográficas dentro de los `.ps1`.

⛔ **Esto no se puede detectar desde Mac.** Solo aparece ejecutándolo en Windows.

**Otros dos que salieron en la misma prueba (2026-08-19):**

- **En modo simulación no se puede llamar a un programa que no está instalado.** El paso del
  plugin preguntaba `claude plugin list` aunque Claude Code no existiera todavía. Un ensayo tiene
  que poder correr en una máquina vacía.
- **Windows trae un `python` de mentira** (un acceso directo a la Microsoft Store). Existe en el
  PATH y responde a `Get-Command`, pero no es Python. Hay que comprobar que
  `--version` devuelva una versión de verdad, y preferir `py -3.11`.

- ⛔⛔ **En PowerShell no se puede llamar `$args` a un parámetro propio.** Es una variable
  reservada del sistema: el comando se acaba lanzando **sin argumentos** y no da error — `winget`
  imprimió su manual de ayuda y el instalador siguió como si nada. **La pista estaba en el ensayo:**
  imprimía `(simulado) winget` a secas, sin los argumentos detrás. En Mac salían completos.
  Regla: cuando el ensayo imprima un comando, **leer que lleve sus argumentos**.
- Todo comando que instala algo **comprueba su código de salida**. Un fallo silencioso parece éxito.

- **`pip` no puede actualizarse a sí mismo si se le llama por su ejecutable.** Hay que usar
  `python -m pip install --upgrade pip`. Con `pip.exe` da error 1 en Windows. No es grave —
  WhisperX se instala igual— pero ensucia la pantalla y asusta.

- ⛔⛔ **Windows solo ensena los programas nuevos a las ventanas abiertas DESPUES.** Se instala
  Node en el paso 3 y en el paso 5 `npm` "no se reconoce", porque la ventana del instalador ya
  estaba abierta. Igual con ffmpeg: instalado en disco, invisible para esa sesión.
  **Solución:** releer el PATH del registro (`[Environment]::GetEnvironmentVariable("Path","Machine")`
  + `"User"`) después de cada instalación, y tener rutas de respaldo para `npm` y `claude`.
  En Mac no pasa porque el instalador exporta el PATH de Homebrew al arrancar.

- ⛔⛔ **Con OneDrive hay DOS escritorios en Windows.** El que la persona ve puede ser
  `C:\Users\<x>\OneDrive\Escritorio`, mientras que `$env:USERPROFILE\Desktop` apunta al
  clásico, que ya no se muestra. La carpeta de trabajo se creaba donde nadie la veía.
  **Usar `[Environment]::GetFolderPath("Desktop")`**, que respeta la redirección. OneDrive viene
  activado de fábrica en muchos Windows, así que esto le pasaría a mucha gente.

- **Claude Code en Windows necesita Git for Windows** para abrir carpetas locales. Sin él, al
  elegir la carpeta responde *"se requiere Git for Windows para ejecutar sesiones locales"*.
  En Mac no se ve porque macOS ya trae git. **Añadido al instalador (`Git.Git`) y al diagnóstico.**

**Lo que sí funcionó a la primera:** las rutas del venv (`Scripts\pip.exe` en vez de `bin/pip`),
la detección de winget, Chrome y After Effects, y la creación de `<Nombre>-Cowork/content-os/`.

---

## Pendientes / sin verificar

- **Si la actualización le llega sola al miembro o tiene que aceptar algo.** Existe
  `claude plugin update <plugin>`, pero no está verificado si corre solo o hay que llamarlo.
- **Los estilos todavía no están dentro del repositorio.** La casa ya está hecha:
  `skills/editor-de-video/estilos/`, con `LEEME.md` y `PLANTILLA-dna.md`, y la skill ya sabe
  mirar ahí. Falta que entren los estilos limpios de marca.
- **La skill de diseño** todavía no se copia. Está cableada a una marca concreta (paleta,
  rutas, `base.css`, `motor.js`). Decidir si entra en la v1.
- **Chrome no es opcional en niveles 1-2:** el ffmpeg de Homebrew no trae `drawtext`, así que
  todo el texto en pantalla sale de Chrome headless.
- **`/opt/homebrew` asume Apple Silicon.** En Mac Intel es `/usr/local`. Detectar, no asumir.
